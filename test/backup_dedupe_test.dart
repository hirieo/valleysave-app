import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:valleysave/core/models/backup_entry.dart';
import 'package:valleysave/core/services/backup_content_hash.dart';
import 'package:valleysave/core/services/backup_service.dart';
import 'package:valleysave/core/services/save_replace_service.dart';

/// Spec 012, D4: sin backups duplicados. Se compara el contenido, nunca la
/// fecha.

String _infoXml({String money = '500'}) =>
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

Future<Directory> _writeSave(
  Directory parent,
  String folderName, {
  String money = '500',
}) async {
  final sep = Platform.pathSeparator;
  final dir = Directory('${parent.path}$sep$folderName');
  await dir.create(recursive: true);
  await File(
    '${dir.path}${sep}SaveGameInfo',
  ).writeAsString(_infoXml(money: money));
  await File('${dir.path}$sep$folderName').writeAsString(_mainXml());
  return dir;
}

void main() {
  late Directory tempDir;
  late String savesDir;
  late String backupsDir;
  const folderName = 'Pleyades_395187544';
  final backups = BackupService();
  final replacer = SaveReplaceService.instance;

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    tempDir = await Directory.systemTemp.createTemp('vs_dedupe_test_');
    savesDir = '${tempDir.path}${Platform.pathSeparator}Saves';
    backupsDir = '${tempDir.path}${Platform.pathSeparator}Backups';
    await Directory(savesDir).create(recursive: true);
  });

  tearDown(() async {
    if (await tempDir.exists()) await tempDir.delete(recursive: true);
  });

  Future<ReplaceResult> replaceWith(String money) => replacer.replaceSaveFolder(
    savesDir: savesDir,
    folderName: folderName,
    backupsDir: backupsDir,
    prepare: (dir) => _writeSave(dir.parent, folderName, money: money),
  );

  group('huella de contenido', () {
    test('carpeta y zip de ese mismo contenido dan la misma huella', () async {
      final save = await _writeSave(Directory(savesDir), folderName);
      final entry = await backups.createBackup(
        saveFolderPath: save.path,
        folderName: folderName,
        backupsDir: backupsDir,
      );

      final folderHash = await hashSaveFolder(save.path);
      final zipHash = await hashBackupZip(entry.localPath!, folderName);

      expect(zipHash, folderHash);
      expect(
        await const BackupHashCache().get(entry.fileName),
        folderHash,
        reason: 'createBackup deja la huella en caché',
      );
    });

    test('cambia si cambia un byte, y es estable si no cambia nada', () async {
      final a = await _writeSave(Directory(savesDir), folderName);
      final before = await hashSaveFolder(a.path);
      expect(await hashSaveFolder(a.path), before);

      await File(
        '${a.path}${Platform.pathSeparator}SaveGameInfo',
      ).writeAsString(_infoXml(money: '501'));
      expect(await hashSaveFolder(a.path), isNot(before));
    });

    test('el nombre del archivo cuenta, no solo los bytes', () async {
      final one = Directory('${tempDir.path}${Platform.pathSeparator}one');
      final two = Directory('${tempDir.path}${Platform.pathSeparator}two');
      await one.create();
      await two.create();
      await File('${one.path}${Platform.pathSeparator}a').writeAsString('xy');
      await File('${two.path}${Platform.pathSeparator}b').writeAsString('xy');

      expect(
        await hashSaveFolder(one.path),
        isNot(await hashSaveFolder(two.path)),
      );
    });

    test('un zip ilegible o sin la carpeta devuelve null', () async {
      final bad = File('${tempDir.path}${Platform.pathSeparator}bad.zip');
      await bad.writeAsBytes([1, 2, 3]);
      expect(await hashBackupZip(bad.path, folderName), isNull);
    });
  });

  group('BackupHashCache', () {
    test('put/get/rename/remove', () async {
      const cache = BackupHashCache();
      expect(await cache.get('a.zip'), isNull);
      await cache.put('a.zip', 'h1');
      expect(await cache.get('a.zip'), 'h1');

      await cache.rename('a.zip', 'b.zip');
      expect(await cache.get('a.zip'), isNull);
      expect(await cache.get('b.zip'), 'h1');

      await cache.remove('b.zip');
      expect(await cache.get('b.zip'), isNull);
    });
  });

  group('replaceSaveFolder sin duplicados', () {
    test('contenido igual a un backup existente: NO crea backup', () async {
      final save = await _writeSave(Directory(savesDir), folderName);
      final existing = await backups.createBackup(
        saveFolderPath: save.path,
        folderName: folderName,
        backupsDir: backupsDir,
      );

      final result = await replaceWith('999');

      expect(result.ok, isTrue);
      expect(result.autoBackup!.fileName, existing.fileName);
      final listed = await backups.listLocalBackups(backupsDir);
      expect(listed, hasLength(1), reason: 'no se añadió ningún zip');
    });

    test(
      'lo mismo con la caché vacía: la huella se calcula al vuelo',
      () async {
        final save = await _writeSave(Directory(savesDir), folderName);
        await backups.createBackup(
          saveFolderPath: save.path,
          folderName: folderName,
          backupsDir: backupsDir,
        );
        SharedPreferences.setMockInitialValues({});

        final result = await replaceWith('999');

        expect(result.ok, isTrue);
        expect(await backups.listLocalBackups(backupsDir), hasLength(1));
      },
    );

    test('contenido distinto al de los backups: SÍ crea backup', () async {
      final save = await _writeSave(Directory(savesDir), folderName);
      await backups.createBackup(
        saveFolderPath: save.path,
        folderName: folderName,
        backupsDir: backupsDir,
      );
      // La partida cambia (se juega) antes de sustituirla.
      await File(
        '${save.path}${Platform.pathSeparator}SaveGameInfo',
      ).writeAsString(_infoXml(money: '640'));

      final result = await replaceWith('999');

      expect(result.ok, isTrue);
      expect(result.autoBackup!.origin, BackupOrigin.auto);
      expect(await backups.listLocalBackups(backupsDir), hasLength(2));
    });

    test('un zip dañado con la huella en caché NO sirve de respaldo', () async {
      final save = await _writeSave(Directory(savesDir), folderName);
      await Directory(backupsDir).create(recursive: true);
      const fakeName = '${folderName}_backup_20260101-000000.zip';
      await File(
        '$backupsDir${Platform.pathSeparator}$fakeName',
      ).writeAsBytes([1, 2, 3]);
      await const BackupHashCache().put(
        fakeName,
        await hashSaveFolder(save.path),
      );

      final result = await replaceWith('999');

      expect(result.ok, isTrue);
      expect(result.autoBackup!.fileName, isNot(fakeName));
      expect(await backups.listLocalBackups(backupsDir), hasLength(2));
    });

    test('el backup idéntico de OTRA partida no cuenta', () async {
      final other = await _writeSave(Directory(savesDir), 'Otra_1');
      await backups.createBackup(
        saveFolderPath: other.path,
        folderName: 'Otra_1',
        backupsDir: backupsDir,
      );
      await _writeSave(Directory(savesDir), folderName);

      await replaceWith('999');

      expect(
        await backups.listLocalBackups(backupsDir, folderName: folderName),
        hasLength(1),
      );
    });
  });

  group('sweepOrphans sin duplicados', () {
    test(
      'rollback ya archivado en un backup: se borra sin crear otro',
      () async {
        final rollbackParent = Directory(
          '$savesDir${Platform.pathSeparator}.vs_rollback_abc',
        );
        final rollbackSave = await _writeSave(
          rollbackParent,
          folderName,
          money: '500',
        );
        await _writeSave(Directory(savesDir), folderName, money: '999');
        await backups.createBackup(
          saveFolderPath: rollbackSave.path,
          folderName: folderName,
          backupsDir: backupsDir,
        );

        await replacer.sweepOrphans(savesDir, backupsDir: backupsDir);

        expect(await rollbackParent.exists(), isFalse);
        expect(await backups.listLocalBackups(backupsDir), hasLength(1));
      },
    );

    test(
      'rollback con contenido nuevo: se archiva como backup automático',
      () async {
        final rollbackParent = Directory(
          '$savesDir${Platform.pathSeparator}.vs_rollback_abc',
        );
        await _writeSave(rollbackParent, folderName, money: '500');
        await _writeSave(Directory(savesDir), folderName, money: '999');

        await replacer.sweepOrphans(savesDir, backupsDir: backupsDir);

        expect(await rollbackParent.exists(), isFalse);
        final listed = await backups.listLocalBackups(backupsDir);
        expect(listed, hasLength(1));
        expect(listed.single.origin, BackupOrigin.auto);
      },
    );
  });
}
