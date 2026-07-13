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

  group('BackupEntry.parseFileName', () {
    test('parsea folderName y timestamp del patrón esperado', () {
      final parsed =
          BackupEntry.parseFileName('Stardust_443121237_pre-swap_20260712-143205.zip');
      expect(parsed, isNotNull);
      expect(parsed!.folderName, 'Stardust_443121237');
      expect(parsed.timestamp, DateTime(2026, 7, 12, 14, 32, 5));
    });

    test('devuelve null para nombres que no siguen el patrón', () {
      expect(BackupEntry.parseFileName('readme.txt'), isNull);
      expect(BackupEntry.parseFileName('Stardust_443121237.zip'), isNull);
    });
  });

  group('listLocalBackups (G9)', () {
    test('G9: no hace ninguna llamada de red — solo lee disco', () async {
      final dir = Directory('${tempDir.path}${Platform.pathSeparator}Backups');
      await dir.create(recursive: true);
      await File('${dir.path}${Platform.pathSeparator}Farm_pre-swap_20260101-000000.zip')
          .writeAsBytes([1, 2, 3]);

      final result = await service.listLocalBackups(dir.path);
      expect(result, hasLength(1));
      expect(result.single.isLocal, isTrue);
      expect(result.single.isOnDrive, isFalse);
    });

    test('filtra por folderName cuando se pasa', () async {
      final dir = Directory('${tempDir.path}${Platform.pathSeparator}Backups');
      await dir.create(recursive: true);
      await File('${dir.path}${Platform.pathSeparator}Farm_pre-swap_20260101-000000.zip')
          .writeAsBytes([1]);
      await File('${dir.path}${Platform.pathSeparator}Other_pre-swap_20260101-000000.zip')
          .writeAsBytes([1]);

      final result = await service.listLocalBackups(dir.path, folderName: 'Farm');
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
    test('G11: siempre pasa overwrite:true — restaura backup local sobre save existente',
        () async {
      final savesDir = Directory('${tempDir.path}${Platform.pathSeparator}Saves');
      await savesDir.create(recursive: true);
      final existing =
          Directory('${savesDir.path}${Platform.pathSeparator}${ZipFixtures.validFolderName}');
      await existing.create(recursive: true);
      await File('${existing.path}${Platform.pathSeparator}marker').writeAsString('viejo');

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

      final result = await service.restoreBackup(entry, savesDir: savesDir.path);
      expect(result.ok, isTrue);
      final markerStillThere = await File('${existing.path}${Platform.pathSeparator}marker')
          .exists();
      expect(markerStillThere, isFalse, reason: 'overwrite reemplaza el contenido anterior');
    });

    test('G12: backup solo-en-Drive se descarga a un temporal y se limpia tras el éxito',
        () async {
      final savesDir = Directory('${tempDir.path}${Platform.pathSeparator}Saves');
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

      String? tempPathUsed;
      final result = await service.restoreBackup(
        entry,
        savesDir: savesDir.path,
        downloadToPath: (path) async {
          tempPathUsed = path;
          await zipFile.copy(path);
        },
      );

      expect(result.ok, isTrue);
      expect(tempPathUsed, isNotNull);
      expect(await File(tempPathUsed!).exists(), isFalse,
          reason: 'el temporal se limpia tras restaurar');
    });

    test('G12b: sin downloadToPath y sin localPath, lanza en vez de fallar en silencio',
        () async {
      final entry = BackupEntry(
        fileName: 'x.zip',
        folderName: 'X',
        timestamp: DateTime.now(),
        sizeBytes: 0,
      );
      expect(
        () => service.restoreBackup(entry, savesDir: tempDir.path),
        throwsA(isA<StateError>()),
      );
    });
  });

  group('deleteLocalBackup', () {
    test('borra el archivo si existe', () async {
      final file = File('${tempDir.path}${Platform.pathSeparator}b.zip');
      await file.writeAsBytes([1]);
      await service.deleteLocalBackup(file.path);
      expect(await file.exists(), isFalse);
    });

    test('no lanza si el archivo ya no existe', () async {
      final file = File('${tempDir.path}${Platform.pathSeparator}no-existe.zip');
      await service.deleteLocalBackup(file.path);
    });
  });
}
