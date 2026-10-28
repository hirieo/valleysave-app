import 'dart:convert';
import 'dart:io';
import 'dart:isolate';

import 'package:archive/archive.dart';
import 'package:meta/meta.dart';

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

/// Datos de partida de un backup (spec 012, D6), leídos del `SaveGameInfo` del
/// zip. [season] es la clave del juego (`spring`, `summer`, `fall`, `winter`);
/// quien lo muestra la traduce.
typedef BackupGameSummary = ({int year, String season, int day, int money});

BackupGameSummary? _summaryFromZip(String zipPath) {
  try {
    final archive = ZipDecoder().decodeBytes(File(zipPath).readAsBytesSync());
    for (final f in archive.files) {
      if (!f.isFile) continue;
      final name = f.name.replaceAll('\\', '/');
      if (name != 'SaveGameInfo' && !name.endsWith('/SaveGameInfo')) continue;
      final segments = name.split('/');
      final folderName = segments.length > 1
          ? segments[segments.length - 2]
          : '';
      final parsed = SaveService.parseSaveGameInfo(
        utf8.decode(f.content, allowMalformed: true),
        folderName: folderName,
        lastModified: DateTime.now(),
      );
      if (parsed == null) return null;
      return (
        year: parsed.year,
        season: parsed.currentSeason,
        day: parsed.dayOfMonth,
        money: parsed.currentMoney,
      );
    }
  } catch (_) {
    // zip ilegible o sin SaveGameInfo: sin datos, no un error.
  }
  return null;
}

/// Resultado de [BackupService.keepBackup]: la entrada ya actualizada y, si
/// alguna copia en Drive no se pudo renombrar, el motivo.
class KeepBackupResult {
  const KeepBackupResult({required this.entry, this.remoteError});

  final BackupEntry entry;
  final String? remoteError;
}

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
  ///
  /// El respaldo de seguridad de la partida que se sustituye es de tipo
  /// [BackupOrigin.preRestore] (spec 012). Si todo sale bien, [entry] queda
  /// marcado «en uso» ([BackupInUseStore]); el caller que aún tiene que
  /// copiar el resultado a otro sitio (Android) pasa [markInUse] `false` y
  /// llama a [markRestoredInUse] cuando termina de verdad.
  Future<ImportResult> restoreBackup(
    BackupEntry entry, {
    required String savesDir,
    required String backupsDir,
    Future<void> Function(String localPath)? downloadToPath,
    bool markInUse = true,
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
        safetyOrigin: BackupOrigin.preRestore,
      );
      if (result.ok) {
        final hash = await hashBackupZip(zipPath, entry.folderName);
        if (hash != null) {
          await const BackupHashCache().put(entry.fileName, hash);
          if (markInUse) {
            try {
              await const BackupInUseStore().set(
                entry.folderName,
                entry.fileName,
                hash,
              );
            } catch (_) {
              // La restauración ya está hecha: perder la marca solo quita
              // la etiqueta «En uso», nunca debe convertirla en un error.
            }
          }
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

  static final Map<String, BackupGameSummary> _summaryCache = {};

  /// Año, estación, día y dinero del backup [zipPath] (D6), o `null` si el
  /// zip no se puede leer — la fila entonces muestra solo la fecha. La
  /// lectura va en un isolate para no congelar la interfaz. Caché en memoria
  /// por nombre de archivo (el nombre ya es único por contenido); un `null`
  /// no se cachea, por si el zip aún se estaba descargando.
  Future<BackupGameSummary?> readGameSummary(String zipPath) async {
    final fileName = zipPath.split(RegExp(r'[\\/]')).last;
    final cached = _summaryCache[fileName];
    if (cached != null) return cached;
    try {
      final summary = await Isolate.run(() => _summaryFromZip(zipPath));
      if (summary != null) _summaryCache[fileName] = summary;
      return summary;
    } catch (_) {
      return null;
    }
  }

  /// Vacía la caché de [readGameSummary]. Solo para tests.
  @visibleForTesting
  static void clearSummaryCache() => _summaryCache.clear();

  /// «Conservar» (spec 012, D5): convierte un automático o un «antes de
  /// restaurar» en manual cambiando el tag del nombre a `_backup_` (la fecha
  /// no cambia). Renombra el zip local y, vía [renameRemote], el de Mi Drive
  /// y el de la carpeta compartida cuando [renameShared] indica que hay
  /// permiso de edición. [renameRemote] se inyecta para que este servicio no
  /// dependa de `DriveService`.
  ///
  /// Si el renombrado en Drive falla, el local ya queda renombrado y el motivo
  /// va en [KeepBackupResult.remoteError]: nunca falla en silencio. La copia
  /// remota que no se pudo renombrar se quita de la entrada devuelta (sigue
  /// existiendo en Drive con el nombre antiguo). Si el backup solo está en
  /// Drive y el renombrado falla, devuelve la entrada sin cambios.
  Future<KeepBackupResult> keepBackup(
    BackupEntry entry, {
    Future<void> Function(String fileId, String newName)? renameRemote,
    bool renameShared = false,
  }) async {
    final newName = entry.keptFileName;
    if (newName == null) return KeepBackupResult(entry: entry);

    var updated = entry.copyWith(
      fileName: newName,
      origin: BackupOrigin.manual,
    );
    var changed = false;

    if (entry.localPath != null) {
      final dir = File(entry.localPath!).parent.path;
      final destination = '$dir${Platform.pathSeparator}$newName';
      if (await File(destination).exists()) {
        throw StateError('Ya existe un backup manual con el nombre $newName.');
      }
      await File(entry.localPath!).rename(destination);
      updated = updated.copyWith(localPath: destination);
      changed = true;
    }

    final errors = <String>[];
    Future<void> renameOne(String id) async {
      if (renameRemote == null) {
        errors.add('Sin conexión con Drive');
        return;
      }
      try {
        await renameRemote(id, newName);
        changed = true;
      } catch (e) {
        errors.add(e.toString());
      }
    }

    var keepOwn = false;
    var keepShared = false;
    if (entry.driveFileId != null) {
      final before = errors.length;
      await renameOne(entry.driveFileId!);
      keepOwn = errors.length == before;
    }
    if (entry.sharedDriveFileId != null && renameShared) {
      final before = errors.length;
      await renameOne(entry.sharedDriveFileId!);
      keepShared = errors.length == before;
    }
    if (!keepOwn) updated = updated.copyWith(clearDriveFileId: true);
    if (!keepShared) updated = updated.copyWith(clearSharedDriveFileId: true);

    if (!changed) {
      return KeepBackupResult(entry: entry, remoteError: errors.join('; '));
    }

    try {
      await const BackupHashCache().rename(entry.fileName, newName);
      await const BackupInUseStore().rename(
        entry.folderName,
        entry.fileName,
        newName,
      );
    } catch (_) {
      // Solo cachés: se recalculan.
    }
    return KeepBackupResult(
      entry: updated,
      remoteError: errors.isEmpty ? null : errors.join('; '),
    );
  }

  /// Marca [entry] «en uso» con la huella que [restoreBackup] dejó en caché.
  /// Para los callers que llamaron a [restoreBackup] con `markInUse: false`.
  Future<void> markRestoredInUse(BackupEntry entry) async {
    try {
      final hash = await const BackupHashCache().get(entry.fileName);
      if (hash == null) return;
      await const BackupInUseStore().set(
        entry.folderName,
        entry.fileName,
        hash,
      );
    } catch (_) {
      // Solo se pierde la etiqueta «En uso».
    }
  }

  /// `fileName` del backup «en uso» de [folderName], o `null`. Si el
  /// contenido actual de [saveFolderPath] ya no coincide con el que dejó la
  /// restauración (se jugó o se sincronizó), la marca se quita (D3).
  Future<String?> currentInUse(String folderName, String saveFolderPath) async {
    const store = BackupInUseStore();
    final marked = await store.get(folderName);
    if (marked == null) return null;
    try {
      if (await hashSaveFolder(saveFolderPath) == marked.contentHash) {
        return marked.fileName;
      }
    } catch (_) {
      // carpeta ilegible o ausente: tampoco coincide.
    }
    await store.clear(folderName);
    return null;
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
