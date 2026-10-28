import 'dart:convert';
import 'dart:io';

import 'package:archive/archive.dart';

import '../models/backup_entry.dart';
import 'backup_content_hash.dart';
import 'backup_in_use_store.dart';
import 'save_service.dart';
import 'transfer_service.dart';

/// Nº máximo de respaldos AUTOMÁTICOS conservados por partida
/// (`BackupOrigin.auto`). Los manuales nunca se borran solos (FR-005).
const kMaxAutoBackups = 5;

/// Nº máximo de respaldos «Antes de restaurar» conservados por partida
/// (`BackupOrigin.preRestore`, spec 012).
const kMaxPreRestoreBackups = 3;

/// Listar/restaurar respaldos LOCALES (spec 007 + spec
/// 001-integridad-transaccional-saves). Dart puro, sin dependencia de Drive
/// — la parte de Drive vive en `DriveService`
/// (`listDriveBackups`/`uploadBackupZip`/`deleteDriveBackup`), el caller
/// (`saves_screen.dart`) hace el merge por nombre de archivo (G10).
class BackupService {
  /// Crea un respaldo sin tocar la partida. Reutiliza el mismo zip seguro
  /// que exportación/importación y lo conserva fuera de `Saves`.
  /// [origin] distingue un respaldo pedido por el usuario
  /// ([BackupOrigin.manual], default) de uno creado automáticamente por
  /// `SaveReplaceService` antes de sobrescribir ([BackupOrigin.auto]), o por
  /// uno de antes de cargar un backup ([BackupOrigin.preRestore]).
  Future<BackupEntry> createBackup({
    required String saveFolderPath,
    required String folderName,
    required String backupsDir,
    BackupOrigin origin = BackupOrigin.manual,
    DateTime? now,
  }) async {
    final exported = await TransferService().exportSave(
      saveFolderPath,
      folderName,
    );
    final timestamp = now ?? DateTime.now();
    final tag = switch (origin) {
      BackupOrigin.auto => 'autobackup',
      BackupOrigin.preRestore => 'prerestore',
      BackupOrigin.manual => 'backup',
    };
    final fileName = '${folderName}_${tag}_${_timestamp(timestamp)}.zip';
    final destinationDir = Directory(backupsDir);
    await destinationDir.create(recursive: true);
    final destination = File('$backupsDir${Platform.pathSeparator}$fileName');
    try {
      await exported.copy(destination.path);
    } finally {
      try {
        final tempDir = exported.parent;
        if (await tempDir.exists()) await tempDir.delete(recursive: true);
      } catch (_) {
        // Limpieza best-effort; el respaldo final ya está fuera del temporal.
      }
    }
    // Huella del zip ya escrito (no de la carpeta): garantiza que la caché
    // describe exactamente lo que hay en el archivo. Best-effort.
    final hash = await hashBackupZip(destination.path, folderName);
    if (hash != null) await const BackupHashCache().put(fileName, hash);
    return BackupEntry(
      fileName: fileName,
      folderName: folderName,
      timestamp: timestamp,
      localPath: destination.path,
      sizeBytes: await destination.length(),
      origin: origin,
    );
  }

  /// D4 (spec 012): busca un backup LOCAL de [folderName] cuyo contenido sea
  /// idéntico al de [saveFolderPath] ahora mismo. Se compara el contenido
  /// (huella), nunca la fecha. El zip encontrado se verifica
  /// ([verifyBackupZipContents]) antes de devolverlo, porque el caller lo
  /// usará como único respaldo. Los zips sin huella en caché se calculan y
  /// se guardan. Best-effort: ante cualquier fallo devuelve `null` y el
  /// caller crea el backup como siempre.
  Future<BackupEntry?> findIdenticalBackup({
    required String saveFolderPath,
    required String folderName,
    required String backupsDir,
  }) async {
    try {
      final current = await hashSaveFolder(saveFolderPath);
      const cache = BackupHashCache();
      final candidates = await listLocalBackups(
        backupsDir,
        folderName: folderName,
      );
      for (final entry in candidates) {
        var hash = await cache.get(entry.fileName);
        if (hash == null) {
          hash = await hashBackupZip(entry.localPath!, folderName);
          if (hash == null) continue;
          await cache.put(entry.fileName, hash);
        }
        if (hash != current) continue;
        if (await verifyBackupZipContents(entry.localPath!, folderName)) {
          return entry;
        }
      }
    } catch (_) {
      // Sin dedupe, se crea el backup normal.
    }
    return null;
  }

  /// Nunca hace llamadas de red (G9) — solo lee el directorio local.
  Future<List<BackupEntry>> listLocalBackups(
    String backupsDir, {
    String? folderName,
  }) async {
    final dir = Directory(backupsDir);
    if (!await dir.exists()) return [];
    final out = <BackupEntry>[];
    await for (final entity in dir.list(recursive: false)) {
      if (entity is! File) continue;
      final name = entity.uri.pathSegments.last;
      final parsed = BackupEntry.parseFileName(name);
      if (parsed == null) continue;
      if (folderName != null && parsed.folderName != folderName) continue;
      out.add(
        BackupEntry(
          fileName: name,
          folderName: parsed.folderName,
          timestamp: parsed.timestamp,
          localPath: entity.path,
          sizeBytes: await entity.length(),
          origin: parsed.origin,
        ),
      );
    }
    out.sort((a, b) => b.timestamp.compareTo(a.timestamp));
    return out;
  }

  /// Retención por tipo (FR-005, spec 012 D2): borra los respaldos más
  /// antiguos de [folderName] cuyo origen es [origin] y que excedan su límite
  /// ([kMaxAutoBackups] para auto, [kMaxPreRestoreBackups] para preRestore).
  /// Los manuales no se tocan, y un tipo nunca borra del otro. NUNCA borra el
  /// backup «en uso» (`BackupInUseStore`): cuenta dentro del límite pero se
  /// salta. Se llama tras crear un backup nuevo — best-effort: un fallo al
  /// borrar no interrumpe la operación que lo disparó.
  Future<void> enforceRetention(
    String backupsDir,
    String folderName,
    BackupOrigin origin,
  ) async {
    final limit = switch (origin) {
      BackupOrigin.auto => kMaxAutoBackups,
      BackupOrigin.preRestore => kMaxPreRestoreBackups,
      BackupOrigin.manual => null,
    };
    if (limit == null) return;
    try {
      final all = await listLocalBackups(backupsDir, folderName: folderName);
      final ofType = all.where((e) => e.origin == origin).toList()
        ..sort((a, b) => b.timestamp.compareTo(a.timestamp));
      if (ofType.length <= limit) return;
      final inUse = (await const BackupInUseStore().get(folderName))?.fileName;
      for (final old in ofType.skip(limit)) {
        if (old.fileName == inUse) continue;
        if (old.localPath != null) await deleteLocalBackup(old.localPath!);
      }
    } catch (_) {
      // best-effort (FR-005 no bloquea la operación que la disparó).
    }
  }

  /// Restaura [entry] sobre [savesDir] con `overwrite: true` SIEMPRE (G11) —
  /// restaurar un backup implica sobrescribir la partida viva de ese
  /// `folderName`, por diseño (mismo nombre siempre). Si [entry] no está en
  /// local, [downloadToPath] lo descarga primero a un temporal que se limpia
  /// tanto en éxito como en fallo (G12). [downloadToPath] se inyecta para
  /// que este servicio siga siendo Dart puro, sin acoplar a `DriveService`.
  Future<ImportResult> restoreBackup(
    BackupEntry entry, {
    required String savesDir,
    required String backupsDir,
    Future<void> Function(String localPath)? downloadToPath,
  }) async {
    String zipPath;
    Directory? tempDir;
    if (entry.localPath != null) {
      zipPath = entry.localPath!;
    } else {
      if (downloadToPath == null) {
        throw StateError(
          'Backup no disponible en este equipo y no se proporcionó downloadToPath.',
        );
      }
      tempDir = await Directory.systemTemp.createTemp('vs_restore_');
      zipPath = '${tempDir.path}${Platform.pathSeparator}${entry.fileName}';
      await downloadToPath(zipPath);
    }
    try {
      final result = await TransferService().importSave(
        zipPath,
        savesDir: savesDir,
        backupsDir: backupsDir,
        overwrite: true,
      );
      if (result.ok) {
        final hash = await hashBackupZip(zipPath, entry.folderName);
        if (hash != null) {
          await const BackupHashCache().put(entry.fileName, hash);
        }
      }
      return result;
    } finally {
      if (tempDir != null) {
        try {
          if (await tempDir.exists()) await tempDir.delete(recursive: true);
        } catch (_) {
          // best-effort
        }
      }
    }
  }

  Future<void> deleteLocalBackup(String localPath) async {
    final file = File(localPath);
    if (await file.exists()) await file.delete();
  }

  static String _timestamp(DateTime value) {
    String p(int n) => n.toString().padLeft(2, '0');
    return '${value.year}${p(value.month)}${p(value.day)}-'
        '${p(value.hour)}${p(value.minute)}${p(value.second)}';
  }
}

/// Confirma que un zip de respaldo contiene un save real ANTES de confiar en
/// él para un rollback o una restauración — mismo criterio mínimo que
/// `TransferService.importArchive` (SaveGameInfo parseable + archivo
/// principal presente). Compartida por `HostSwapService` y
/// `SaveReplaceService` (FR-002: un solo sitio, no duplicar).
Future<bool> verifyBackupZipContents(String zipPath, String folderName) async {
  try {
    final bytes = await File(zipPath).readAsBytes();
    final archive = ZipDecoder().decodeBytes(bytes);
    ArchiveFile? info;
    ArchiveFile? main;
    for (final f in archive.files) {
      final name = f.name.replaceAll('\\', '/');
      if (name == '$folderName/SaveGameInfo') info = f;
      if (name == '$folderName/$folderName') main = f;
    }
    if (info == null || main == null) return false;
    final infoXml = utf8.decode(info.content, allowMalformed: true);
    final parsed = SaveService.parseSaveGameInfo(
      infoXml,
      folderName: folderName,
      lastModified: DateTime.now(),
    );
    return parsed != null;
  } catch (_) {
    return false;
  }
}
