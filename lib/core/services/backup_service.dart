import 'dart:convert';
import 'dart:io';

import 'package:archive/archive.dart';

import '../models/backup_entry.dart';
import 'save_service.dart';
import 'transfer_service.dart';

/// Nº máximo de respaldos AUTOMÁTICOS conservados por partida
/// (`BackupOrigin.auto`). Los manuales nunca se borran solos (FR-005).
const kMaxAutoBackups = 5;

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
  /// `SaveReplaceService` antes de sobrescribir ([BackupOrigin.auto]).
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
    final tag = origin == BackupOrigin.auto ? 'autobackup' : 'backup';
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
    return BackupEntry(
      fileName: fileName,
      folderName: folderName,
      timestamp: timestamp,
      localPath: destination.path,
      sizeBytes: await destination.length(),
      origin: origin,
    );
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

  /// Borra los respaldos AUTOMÁTICOS más antiguos de [folderName] que
  /// excedan [kMaxAutoBackups] (FR-005). Los manuales no se tocan. Se llama
  /// tras crear un auto-backup nuevo — best-effort: un fallo al borrar no
  /// interrumpe la operación que lo disparó.
  Future<void> enforceAutoRetention(
    String backupsDir,
    String folderName,
  ) async {
    try {
      final all = await listLocalBackups(backupsDir, folderName: folderName);
      final autos = all.where((e) => e.origin == BackupOrigin.auto).toList()
        ..sort((a, b) => b.timestamp.compareTo(a.timestamp));
      if (autos.length <= kMaxAutoBackups) return;
      for (final old in autos.skip(kMaxAutoBackups)) {
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
      return await TransferService().importSave(
        zipPath,
        savesDir: savesDir,
        backupsDir: backupsDir,
        overwrite: true,
      );
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
