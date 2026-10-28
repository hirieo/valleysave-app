import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:valleysave/core/models/backup_entry.dart';
import 'package:valleysave/core/services/backup_content_hash.dart';
import 'package:valleysave/core/services/backup_in_use_store.dart';
import 'package:valleysave/core/services/backup_service.dart';
import 'package:valleysave/core/services/transfer_service.dart';

/// Spec 012, pasos 3-4: restaurar = «Antes de restaurar» + marcar en uso.

String _infoXml(String money) =>
    '''<?xml version="1.0" encoding="utf-8"?>
<Farmer>
  <name>Ana</name>
  <farmName>Granja Test</farmName>
  <slotCanHost>false</slotCanHost>
  <money>$money</money>
</Farmer>''';

String _mainXml() => '''<?xml version="1.0" encoding="utf-8"?>
<SaveGame xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">
  <uniqueIDForThisGame>123456789</uniqueIDForThisGame>
  <player><name>Ana</name></player>
  <locations/>
</SaveGame>''';

void main() {
  late Directory tempDir;
  late String savesDir;
  late String backupsDir;
  late String savePath;
  const folderName = 'Pleyades_395187544';
  final sep = Platform.pathSeparator;
  final service = BackupService();

  Future<void> writeSave(String money) async {
    final dir = Directory(savePath);
    await dir.create(recursive: true);
    await File('$savePath${sep}SaveGameInfo').writeAsString(_infoXml(money));
    await File('$savePath$sep$folderName').writeAsString(_mainXml());
  }

  Future<List<BackupEntry>> listed() =>
      service.listLocalBackups(backupsDir, folderName: folderName);

  Future<BackupEntry> manualBackupOf(String money, DateTime at) async {
    await writeSave(money);
    return service.createBackup(
      saveFolderPath: savePath,
      folderName: folderName,
      backupsDir: backupsDir,
      now: at,
    );
  }

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    tempDir = await Directory.systemTemp.createTemp('vs_restore_test_');
    savesDir = '${tempDir.path}${sep}Saves';
    backupsDir = '${tempDir.path}${sep}Backups';
    savePath = '$savesDir$sep$folderName';
  });

  tearDown(() async {
    if (await tempDir.exists()) await tempDir.delete(recursive: true);
  });

  Future<void> restore(BackupEntry e) async {
    final result = await service.restoreBackup(
      e,
      savesDir: savesDir,
      backupsDir: backupsDir,
    );
    expect(result.ok, isTrue);
  }

  test(
    'criterio 1: restaurar A, B, A, B, A sin jugar crea UN prerestore y no borra A ni B',
    () async {
      final a = await manualBackupOf('100', DateTime(2026, 7, 1, 10));
      final b = await manualBackupOf('200', DateTime(2026, 7, 1, 11));
      await writeSave('999'); // la partida real, con progreso sin respaldar
      final realHash = await hashSaveFolder(savePath);

      for (final e in [a, b, a, b, a]) {
        await restore(e);
      }

      final all = await listed();
      expect(
        all.where((e) => e.origin == BackupOrigin.preRestore),
        hasLength(1),
      );
      expect(all.map((e) => e.fileName), containsAll([a.fileName, b.fileName]));
      expect(all, hasLength(3));
      expect(
        (await const BackupInUseStore().get(folderName))!.fileName,
        a.fileName,
      );
      // El prerestore guarda la partida real (999), no un estado intermedio.
      final pre = all.singleWhere((e) => e.origin == BackupOrigin.preRestore);
      expect(await hashBackupZip(pre.localPath!, folderName), realHash);
    },
  );

  test(
    'criterio 2: jugar tras restaurar y restaurar de nuevo crea otro prerestore',
    () async {
      final a = await manualBackupOf('100', DateTime(2026, 7, 1, 10));
      final b = await manualBackupOf('200', DateTime(2026, 7, 1, 11));
      await writeSave('999');

      await restore(a);
      await Future<void>.delayed(const Duration(milliseconds: 1100));
      await writeSave('555'); // se juega con A cargado
      await restore(b);

      final pres = (await listed()).where(
        (e) => e.origin == BackupOrigin.preRestore,
      );
      expect(pres, hasLength(2));
    },
  );

  test('restaurar marca en uso con la huella del zip', () async {
    final a = await manualBackupOf('100', DateTime(2026, 7, 1, 10));
    await writeSave('999');

    await restore(a);

    final marked = await const BackupInUseStore().get(folderName);
    expect(marked!.fileName, a.fileName);
    expect(await service.currentInUse(folderName, savePath), a.fileName);
  });

  test('currentInUse quita la marca cuando la partida cambió', () async {
    final a = await manualBackupOf('100', DateTime(2026, 7, 1, 10));
    await writeSave('999');
    await restore(a);

    await writeSave('101'); // se juega

    expect(await service.currentInUse(folderName, savePath), isNull);
    expect(await const BackupInUseStore().get(folderName), isNull);
  });

  test('markInUse:false no marca; markRestoredInUse lo hace después', () async {
    final a = await manualBackupOf('100', DateTime(2026, 7, 1, 10));
    await writeSave('999');

    final result = await service.restoreBackup(
      a,
      savesDir: savesDir,
      backupsDir: backupsDir,
      markInUse: false,
    );
    expect(result.ok, isTrue);
    expect(await const BackupInUseStore().get(folderName), isNull);

    await service.markRestoredInUse(a);
    expect(
      (await const BackupInUseStore().get(folderName))!.fileName,
      a.fileName,
    );
  });

  test('un restore fallido no marca nada', () async {
    final bad = File('${tempDir.path}${sep}bad.zip');
    await bad.create(recursive: true);
    await bad.writeAsBytes([1, 2, 3]);
    final entry = BackupEntry(
      fileName: '${folderName}_backup_20260701-100000.zip',
      folderName: folderName,
      timestamp: DateTime(2026, 7, 1, 10),
      localPath: bad.path,
      sizeBytes: 3,
    );

    final result = await service.restoreBackup(
      entry,
      savesDir: savesDir,
      backupsDir: backupsDir,
    );

    expect(result.ok, isFalse);
    expect(await const BackupInUseStore().get(folderName), isNull);
  });

  test(
    'importar un zip de fuera sigue creando el respaldo como auto',
    () async {
      final a = await manualBackupOf('100', DateTime(2026, 7, 1, 10));
      await writeSave('999');

      final result = await TransferService().importSave(
        a.localPath!,
        savesDir: savesDir,
        backupsDir: backupsDir,
        overwrite: true,
      );

      expect(result.ok, isTrue);
      final all = await listed();
      expect(all.where((e) => e.origin == BackupOrigin.auto), hasLength(1));
      expect(all.where((e) => e.origin == BackupOrigin.preRestore), isEmpty);
      expect(await const BackupInUseStore().get(folderName), isNull);
    },
  );
}
