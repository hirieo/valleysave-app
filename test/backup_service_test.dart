import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:valleysave/core/models/backup_entry.dart';
import 'package:valleysave/core/services/backup_service.dart';

import 'fixtures/zip_fixtures.dart';

void main() {
  late Directory tempDir;
  final service = BackupService();

  setUp(() async {
    tempDir = await Directory.systemTemp.createTemp('vs_backup_test_');
  });

  tearDown(() async {
    if (await tempDir.exists()) await tempDir.delete(recursive: true);
  });

  /// Escribe un save real y mínimo (mismo contenido que
  /// `ZipFixtures.validArchive()`) directamente en [dir] — necesario porque
  /// `SaveReplaceService.replaceSaveFolder` ahora respalda el destino ANTES
  /// de sustituirlo, y ese respaldo se verifica (`verifyBackupZipContents`):
  /// una carpeta destino que no parece un save real (p. ej. solo un
  /// `marker` suelto) hace fallar esa verificación con `backupFailed`.
  Future<void> writeValidSaveFiles(Directory dir, String folderName) async {
    await dir.create(recursive: true);
    final sep = Platform.pathSeparator;
    for (final f in ZipFixtures.validArchive(folderName: folderName).files) {
      final relative = f.name.substring(folderName.length + 1);
      await File('${dir.path}$sep$relative').writeAsBytes(f.content);
    }
  }

  group('BackupEntry.parseFileName', () {
    test('parsea folderName y timestamp del patrón esperado', () {
      final parsed = BackupEntry.parseFileName(
        'Stardust_443121237_pre-swap_20260712-143205.zip',
      );
      expect(parsed, isNotNull);
      expect(parsed!.folderName, 'Stardust_443121237');
      expect(parsed.timestamp, DateTime(2026, 7, 12, 14, 32, 5));
    });

    test('acepta el patrón de backup manual', () {
      final parsed = BackupEntry.parseFileName(
        'Stardust_443121237_backup_20260713-120000.zip',
      );
      expect(parsed, isNotNull);
      expect(parsed!.folderName, 'Stardust_443121237');
      expect(parsed.timestamp, DateTime(2026, 7, 13, 12));
    });

    test('devuelve null para nombres que no siguen el patrón', () {
      expect(BackupEntry.parseFileName('readme.txt'), isNull);
      expect(BackupEntry.parseFileName('Stardust_443121237.zip'), isNull);
    });
  });

  test('copyWith distingue y puede limpiar las tres ubicaciones', () {
    final entry = BackupEntry(
      fileName: 'Farm_backup_20260713-120000.zip',
      folderName: 'Farm',
      timestamp: DateTime(2026, 7, 13, 12),
      localPath: 'C:/backup.zip',
      driveFileId: 'mine',
      sharedDriveFileId: 'owner',
      sizeBytes: 42,
    );

    final localCleared = entry.copyWith(clearLocalPath: true);
    expect(localCleared.localPath, isNull);
    expect(localCleared.driveFileId, 'mine');
    expect(localCleared.sharedDriveFileId, 'owner');

    final sharedCleared = entry.copyWith(clearSharedDriveFileId: true);
    expect(sharedCleared.sharedDriveFileId, isNull);
    expect(sharedCleared.driveFileId, 'mine');
  });

  test('mergeWith empareja las tres ubicaciones por nombre exacto', () {
    final timestamp = DateTime(2026, 7, 13, 12);
    final local = BackupEntry(
      fileName: 'Farm_backup_20260713-120000.zip',
      folderName: 'Farm',
      timestamp: timestamp,
      localPath: 'C:/backup.zip',
      sizeBytes: 10,
    );
    final own = BackupEntry(
      fileName: local.fileName,
      folderName: 'Farm',
      timestamp: timestamp,
      driveFileId: 'mine',
      sizeBytes: 20,
    );
    final shared = BackupEntry(
      fileName: local.fileName,
      folderName: 'Farm',
      timestamp: timestamp,
      sharedDriveFileId: 'owner',
      sizeBytes: 15,
    );

    final merged = local.mergeWith(own).mergeWith(shared);
    expect(merged.localPath, 'C:/backup.zip');
    expect(merged.driveFileId, 'mine');
    expect(merged.sharedDriveFileId, 'owner');
    expect(merged.sizeBytes, 20);
    expect(merged.locationCount, 3);
  });

  group('createBackup', () {
    test('crea un zip manual sin modificar la partida original', () async {
      final save = Directory(
        '${tempDir.path}${Platform.pathSeparator}Farm_123',
      );
      await save.create(recursive: true);
      final info = File('${save.path}${Platform.pathSeparator}SaveGameInfo');
      final main = File('${save.path}${Platform.pathSeparator}Farm_123');
      await info.writeAsString('<Farmer />');
      await main.writeAsString('<SaveGame />');
      final backupsDir =
          '${tempDir.path}${Platform.pathSeparator}ValleySave${Platform.pathSeparator}Backups';

      final entry = await service.createBackup(
        saveFolderPath: save.path,
        folderName: 'Farm_123',
        backupsDir: backupsDir,
        now: DateTime(2026, 7, 13, 12, 34, 56),
      );

      expect(entry.fileName, 'Farm_123_backup_20260713-123456.zip');
      expect(entry.isLocal, isTrue);
      expect(await File(entry.localPath!).exists(), isTrue);
      expect(await info.readAsString(), '<Farmer />');
      expect(await main.readAsString(), '<SaveGame />');
    });
  });

  group('listLocalBackups (G9)', () {
    test('G9: no hace ninguna llamada de red — solo lee disco', () async {
      final dir = Directory('${tempDir.path}${Platform.pathSeparator}Backups');
      await dir.create(recursive: true);
      await File(
        '${dir.path}${Platform.pathSeparator}Farm_pre-swap_20260101-000000.zip',
      ).writeAsBytes([1, 2, 3]);

      final result = await service.listLocalBackups(dir.path);
      expect(result, hasLength(1));
      expect(result.single.isLocal, isTrue);
      expect(result.single.isOnDrive, isFalse);
    });

    test('filtra por folderName cuando se pasa', () async {
      final dir = Directory('${tempDir.path}${Platform.pathSeparator}Backups');
      await dir.create(recursive: true);
      await File(
        '${dir.path}${Platform.pathSeparator}Farm_pre-swap_20260101-000000.zip',
      ).writeAsBytes([1]);
      await File(
        '${dir.path}${Platform.pathSeparator}Other_pre-swap_20260101-000000.zip',
      ).writeAsBytes([1]);

      final result = await service.listLocalBackups(
        dir.path,
        folderName: 'Farm',
      );
      expect(result, hasLength(1));
      expect(result.single.folderName, 'Farm');
    });

    test('carpeta inexistente devuelve lista vacía sin lanzar', () async {
      final result = await service.listLocalBackups(
        '${tempDir.path}${Platform.pathSeparator}NoExiste',
      );
      expect(result, isEmpty);
    });
  });

  group('restoreBackup (G11, G12)', () {
    test(
      'G11: siempre pasa overwrite:true — restaura backup local sobre save existente',
      () async {
        final savesDir = Directory(
          '${tempDir.path}${Platform.pathSeparator}Saves',
        );
        await savesDir.create(recursive: true);
        final existing = Directory(
          '${savesDir.path}${Platform.pathSeparator}${ZipFixtures.validFolderName}',
        );
        await writeValidSaveFiles(existing, ZipFixtures.validFolderName);
        await File(
          '${existing.path}${Platform.pathSeparator}marker',
        ).writeAsString('viejo');

        final zipFile = await ZipFixtures.writeZip(
          ZipFixtures.validArchive(),
          tempDir,
          'backup.zip',
        );
        final entry = BackupEntry(
          fileName: 'backup.zip',
          folderName: ZipFixtures.validFolderName,
          timestamp: DateTime.now(),
          localPath: zipFile.path,
          sizeBytes: await zipFile.length(),
        );

        final backupsDir = Directory(
          '${tempDir.path}${Platform.pathSeparator}Backups',
        );
        final result = await service.restoreBackup(
          entry,
          savesDir: savesDir.path,
          backupsDir: backupsDir.path,
        );
        expect(result.ok, isTrue);
        final markerStillThere = await File(
          '${existing.path}${Platform.pathSeparator}marker',
        ).exists();
        expect(
          markerStillThere,
          isFalse,
          reason: 'overwrite reemplaza el contenido anterior',
        );
      },
    );

    test(
      'G12: backup solo-en-Drive se descarga a un temporal y se limpia tras el éxito',
      () async {
        final savesDir = Directory(
          '${tempDir.path}${Platform.pathSeparator}Saves',
        );
        await savesDir.create(recursive: true);
        final zipFile = await ZipFixtures.writeZip(
          ZipFixtures.validArchive(),
          tempDir,
          'remote_backup.zip',
        );

        final entry = BackupEntry(
          fileName: 'remote_backup.zip',
          folderName: ZipFixtures.validFolderName,
          timestamp: DateTime.now(),
          driveFileId: 'fake-id',
          sizeBytes: await zipFile.length(),
        );

        final backupsDir = Directory(
          '${tempDir.path}${Platform.pathSeparator}Backups',
        );
        String? tempPathUsed;
        final result = await service.restoreBackup(
          entry,
          savesDir: savesDir.path,
          backupsDir: backupsDir.path,
          downloadToPath: (path) async {
            tempPathUsed = path;
            await zipFile.copy(path);
          },
        );

        expect(result.ok, isTrue);
        expect(tempPathUsed, isNotNull);
        expect(
          await File(tempPathUsed!).exists(),
          isFalse,
          reason: 'el temporal se limpia tras restaurar',
        );
      },
    );

    test(
      'G12b: sin downloadToPath y sin localPath, lanza en vez de fallar en silencio',
      () async {
        final entry = BackupEntry(
          fileName: 'x.zip',
          folderName: 'X',
          timestamp: DateTime.now(),
          sizeBytes: 0,
        );
        expect(
          () => service.restoreBackup(
            entry,
            savesDir: tempDir.path,
            backupsDir: tempDir.path,
          ),
          throwsA(isA<StateError>()),
        );
      },
    );
  });

  group('deleteLocalBackup', () {
    test('borra el archivo si existe', () async {
      final file = File('${tempDir.path}${Platform.pathSeparator}b.zip');
      await file.writeAsBytes([1]);
      await service.deleteLocalBackup(file.path);
      expect(await file.exists(), isFalse);
    });

    test('no lanza si el archivo ya no existe', () async {
      final file = File(
        '${tempDir.path}${Platform.pathSeparator}no-existe.zip',
      );
      await service.deleteLocalBackup(file.path);
    });
  });
}
