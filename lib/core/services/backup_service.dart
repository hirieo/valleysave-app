import 'dart:io';

import '../models/backup_entry.dart';
import 'transfer_service.dart';

/// Listar/restaurar respaldos LOCALES pre-swap (spec 007). Dart puro, sin
/// dependencia de Drive — la parte de Drive vive en `DriveService`
/// (`listDriveBackups`/`uploadBackupZip`/`deleteDriveBackup`), el caller
/// (`saves_screen.dart`) hace el merge por nombre de archivo (G10).
class BackupService {
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
      out.add(BackupEntry(
        fileName: name,
        folderName: parsed.folderName,
        timestamp: parsed.timestamp,
        localPath: entity.path,
        sizeBytes: await entity.length(),
      ));
    }
    out.sort((a, b) => b.timestamp.compareTo(a.timestamp));
    return out;
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
}
