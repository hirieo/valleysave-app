import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:valleysave/core/models/backup_entry.dart';
import 'package:valleysave/core/services/backup_content_hash.dart';
import 'package:valleysave/core/services/backup_in_use_store.dart';
import 'package:valleysave/core/services/backup_service.dart';

/// Spec 012, D5: «Conservar» convierte un automático o un «antes de
/// restaurar» en manual (renombra el tag) y deja de borrarse solo.
void main() {
  late Directory tempDir;
  late String backupsDir;
  const folderName = 'Granja_1';
  final sep = Platform.pathSeparator;
  final service = BackupService();

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    tempDir = await Directory.systemTemp.createTemp('vs_keep_test_');
    backupsDir = '${tempDir.path}${sep}Backups';
    await Directory(backupsDir).create(recursive: true);
  });

  tearDown(() async {
    if (await tempDir.exists()) await tempDir.delete(recursive: true);
  });

  Future<BackupEntry> localEntry(
    String tag, {
    String ts = '20260701-100000',
  }) async {
    final name = '${folderName}_${tag}_$ts.zip';
    final file = File('$backupsDir$sep$name');
    await file.writeAsBytes([1, 2, 3]);
    final parsed = BackupEntry.parseFileName(name)!;
    return BackupEntry(
      fileName: name,
      folderName: folderName,
      timestamp: parsed.timestamp,
      localPath: file.path,
      sizeBytes: 3,
      origin: parsed.origin,
    );
  }

  test('keptFileName: auto y preRestore → _backup_, manual → null', () async {
    expect(
      (await localEntry('autobackup')).keptFileName,
      '${folderName}_backup_20260701-100000.zip',
    );
    expect(
      (await localEntry('prerestore')).keptFileName,
      '${folderName}_backup_20260701-100000.zip',
    );
    expect((await localEntry('backup')).keptFileName, isNull);
    expect((await localEntry('pre-swap')).keptFileName, isNull);
  });

  test('local: renombra el zip, pasa a manual y conserva la fecha', () async {
    final e = await localEntry('autobackup');

    final result = await service.keepBackup(e);

    expect(result.remoteError, isNull);
    expect(result.entry.fileName, '${folderName}_backup_20260701-100000.zip');
    expect(result.entry.origin, BackupOrigin.manual);
    expect(result.entry.timestamp, e.timestamp);
    expect(await File(e.localPath!).exists(), isFalse);
    expect(await File(result.entry.localPath!).exists(), isTrue);

    final listed = await service.listLocalBackups(backupsDir);
    expect(listed.single.origin, BackupOrigin.manual);
  });

  test('un prerestore también se conserva', () async {
    final e = await localEntry('prerestore');
    final result = await service.keepBackup(e);
    expect(result.entry.origin, BackupOrigin.manual);
    expect(result.entry.fileName, contains('_backup_'));
  });

  test('un backup conservado ya no lo borra la retención', () async {
    final oldest = await localEntry('autobackup', ts: '20260701-100000');
    for (var i = 1; i <= kMaxAutoBackups; i++) {
      await localEntry('autobackup', ts: '20260701-10000$i');
    }
    await service.keepBackup(oldest);

    await service.enforceRetention(backupsDir, folderName, BackupOrigin.auto);

    final listed = await service.listLocalBackups(backupsDir);
    expect(listed.where((e) => e.origin == BackupOrigin.manual), hasLength(1));
    expect(listed.where((e) => e.origin == BackupOrigin.auto), hasLength(5));
  });

  test(
    'si era el backup en uso, la marca sigue al nuevo nombre; la huella también',
    () async {
      final e = await localEntry('autobackup');
      await const BackupInUseStore().set(folderName, e.fileName, 'h1');
      await const BackupHashCache().put(e.fileName, 'h1');

      final result = await service.keepBackup(e);

      final marked = await const BackupInUseStore().get(folderName);
      expect(marked!.fileName, result.entry.fileName);
      expect(marked.contentHash, 'h1');
      expect(await const BackupHashCache().get(result.entry.fileName), 'h1');
      expect(await const BackupHashCache().get(e.fileName), isNull);
    },
  );

  test('un manual no se toca', () async {
    final e = await localEntry('backup');
    final result = await service.keepBackup(e);
    expect(result.entry.fileName, e.fileName);
    expect(await File(e.localPath!).exists(), isTrue);
  });

  test(
    'si ya existe el nombre manual, lanza y no pierde el original',
    () async {
      final e = await localEntry('autobackup');
      await localEntry('backup'); // mismo timestamp, ya manual

      await expectLater(service.keepBackup(e), throwsA(isA<StateError>()));
      expect(await File(e.localPath!).exists(), isTrue);
    },
  );

  group('Drive', () {
    test('renombra en Mi Drive y en la compartida con permiso', () async {
      final base = await localEntry('autobackup');
      final e = base.copyWith(driveFileId: 'mine', sharedDriveFileId: 'owner');
      final calls = <String>[];

      final result = await service.keepBackup(
        e,
        renameShared: true,
        renameRemote: (id, name) async => calls.add('$id→$name'),
      );

      final newName = '${folderName}_backup_20260701-100000.zip';
      expect(calls, ['mine→$newName', 'owner→$newName']);
      expect(result.remoteError, isNull);
      expect(result.entry.driveFileId, 'mine');
      expect(result.entry.sharedDriveFileId, 'owner');
    });

    test(
      'compartida sin permiso: no se renombra allí y no es un error',
      () async {
        final base = await localEntry('autobackup');
        final e = base.copyWith(
          driveFileId: 'mine',
          sharedDriveFileId: 'owner',
        );
        final calls = <String>[];

        final result = await service.keepBackup(
          e,
          renameShared: false,
          renameRemote: (id, name) async => calls.add(id),
        );

        expect(calls, ['mine']);
        expect(result.remoteError, isNull);
        expect(result.entry.sharedDriveFileId, isNull);
      },
    );

    test(
      'falla en Drive: el local queda renombrado y se avisa con el motivo',
      () async {
        final base = await localEntry('autobackup');
        final e = base.copyWith(driveFileId: 'mine');

        final result = await service.keepBackup(
          e,
          renameRemote: (id, name) async => throw Exception('403 sin permiso'),
        );

        expect(result.entry.fileName, contains('_backup_'));
        expect(await File(result.entry.localPath!).exists(), isTrue);
        expect(result.remoteError, contains('403 sin permiso'));
        expect(
          result.entry.driveFileId,
          isNull,
          reason: 'esa copia sigue con el nombre antiguo en Drive',
        );
      },
    );

    test('sin cliente de Drive también se avisa, nunca en silencio', () async {
      final base = await localEntry('autobackup');
      final e = base.copyWith(driveFileId: 'mine');

      final result = await service.keepBackup(e);

      expect(result.remoteError, isNotNull);
      expect(result.entry.origin, BackupOrigin.manual);
    });

    test('solo en Drive y falla: la entrada queda sin cambios', () async {
      final e = BackupEntry(
        fileName: '${folderName}_autobackup_20260701-100000.zip',
        folderName: folderName,
        timestamp: DateTime(2026, 7, 1, 10),
        driveFileId: 'mine',
        sizeBytes: 3,
        origin: BackupOrigin.auto,
      );

      final result = await service.keepBackup(
        e,
        renameRemote: (id, name) async => throw Exception('sin red'),
      );

      expect(result.entry.fileName, e.fileName);
      expect(result.entry.origin, BackupOrigin.auto);
      expect(result.remoteError, contains('sin red'));
    });

    test('solo en Drive y funciona: pasa a manual', () async {
      final e = BackupEntry(
        fileName: '${folderName}_prerestore_20260701-100000.zip',
        folderName: folderName,
        timestamp: DateTime(2026, 7, 1, 10),
        driveFileId: 'mine',
        sizeBytes: 3,
        origin: BackupOrigin.preRestore,
      );

      final result = await service.keepBackup(
        e,
        renameRemote: (id, name) async {},
      );

      expect(result.entry.fileName, '${folderName}_backup_20260701-100000.zip');
      expect(result.entry.origin, BackupOrigin.manual);
      expect(result.entry.driveFileId, 'mine');
    });
  });
}
