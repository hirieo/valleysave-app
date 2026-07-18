import 'dart:io';

import 'package:archive/archive.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:valleysave/core/services/save_service.dart';
import 'package:valleysave/core/services/transfer_service.dart';

import 'fixtures/zip_fixtures.dart';

void main() {
  late Directory tempDir;

  setUp(() async {
    tempDir = await Directory.systemTemp.createTemp('vs_transfer_test_');
  });

  tearDown(() async {
    if (await tempDir.exists()) await tempDir.delete(recursive: true);
  });

  Future<Directory> makeSavesDir() async {
    final dir = Directory('${tempDir.path}${Platform.pathSeparator}Saves');
    await dir.create(recursive: true);
    return dir;
  }

  Future<Directory> makeBackupsDir() async {
    final dir = Directory('${tempDir.path}${Platform.pathSeparator}Backups');
    await dir.create(recursive: true);
    return dir;
  }

  /// Escribe un save real y mínimo (mismo contenido que
  /// `ZipFixtures.validArchive()`) directamente en [dir] — necesario porque
  /// `SaveReplaceService.replaceSaveFolder` ahora respalda el destino ANTES
  /// de sustituirlo, y ese respaldo se verifica: una carpeta destino que no
  /// parece un save real (p. ej. solo un `marker` suelto) hace fallar esa
  /// verificación con `backupFailed`.
  Future<void> writeValidSaveFiles(Directory dir, String folderName) async {
    await dir.create(recursive: true);
    final sep = Platform.pathSeparator;
    for (final f in ZipFixtures.validArchive(folderName: folderName).files) {
      final relative = f.name.substring(folderName.length + 1);
      await File('${dir.path}$sep$relative').writeAsBytes(f.content);
    }
  }

  group('exportSave (G1, G2)', () {
    test('G1: no modifica el save original', () async {
      final sep = Platform.pathSeparator;
      final folderName = 'MyFarm_1';
      final folder = Directory('${tempDir.path}$sep$folderName');
      await folder.create(recursive: true);
      await File('${folder.path}$sep$folderName').writeAsString('main-content');
      await File('${folder.path}${sep}SaveGameInfo').writeAsString('info-content');

      final before = {
        'main': await File('${folder.path}$sep$folderName').readAsString(),
        'info': await File('${folder.path}${sep}SaveGameInfo').readAsString(),
      };

      await TransferService().exportSave(folder.path, folderName);

      final after = {
        'main': await File('${folder.path}$sep$folderName').readAsString(),
        'info': await File('${folder.path}${sep}SaveGameInfo').readAsString(),
      };
      expect(after, equals(before));
    });

    test('G2: la carpeta del save es la raíz del zip', () async {
      final sep = Platform.pathSeparator;
      final folderName = 'MyFarm_2';
      final folder = Directory('${tempDir.path}$sep$folderName');
      await folder.create(recursive: true);
      await File('${folder.path}$sep$folderName').writeAsString('main');
      await File('${folder.path}${sep}SaveGameInfo').writeAsString('info');

      final zipFile = await TransferService().exportSave(folder.path, folderName);
      final bytes = await zipFile.readAsBytes();
      final archive = ZipDecoder().decodeBytes(bytes);
      expect(archive.files, isNotEmpty);
      for (final f in archive.files) {
        expect(f.name.startsWith('$folderName/'), isTrue);
      }
    });
  });

  group('importSave / importArchive — rechazos (G3-G5)', () {
    test('G3: zip-slip devuelve unsafePath sin escribir nada', () async {
      final savesDir = await makeSavesDir();
      final result = await TransferService().importArchive(
        ZipFixtures.zipSlipArchive(),
        savesDir: savesDir.path,
        backupsDir: (await makeBackupsDir()).path,
      );
      expect(result.ok, isFalse);
      expect(result.error, ImportError.unsafePath);
      expect(await savesDir.list().toList(), isEmpty);
    });

    test('G3b: symlink devuelve unsafePath sin escribir nada', () async {
      final savesDir = await makeSavesDir();
      final result = await TransferService().importArchive(
        ZipFixtures.symlinkArchive(),
        savesDir: savesDir.path,
        backupsDir: (await makeBackupsDir()).path,
      );
      expect(result.ok, isFalse);
      expect(result.error, ImportError.unsafePath);
      expect(await savesDir.list().toList(), isEmpty);
    });

    test('G4: tamaño declarado excesivo devuelve tooLarge sin escribir nada', () async {
      final savesDir = await makeSavesDir();
      final result = await TransferService().importArchive(
        ZipFixtures.zipBombArchive(),
        savesDir: savesDir.path,
        backupsDir: (await makeBackupsDir()).path,
      );
      expect(result.ok, isFalse);
      expect(result.error, ImportError.tooLarge);
      expect(await savesDir.list().toList(), isEmpty);
    });

    test('G4b: demasiadas entradas devuelve tooLarge sin escribir nada', () async {
      final savesDir = await makeSavesDir();
      final result = await TransferService().importArchive(
        ZipFixtures.tooManyEntriesArchive(),
        savesDir: savesDir.path,
        backupsDir: (await makeBackupsDir()).path,
      );
      expect(result.ok, isFalse);
      expect(result.error, ImportError.tooLarge);
      expect(await savesDir.list().toList(), isEmpty);
    });

    test('G5: sin SaveGameInfo devuelve notASave sin escribir nada', () async {
      final savesDir = await makeSavesDir();
      final result = await TransferService().importArchive(
        ZipFixtures.notASaveArchive(),
        savesDir: savesDir.path,
        backupsDir: (await makeBackupsDir()).path,
      );
      expect(result.ok, isFalse);
      expect(result.error, ImportError.notASave);
      expect(await savesDir.list().toList(), isEmpty);
    });

    test('G5b: sin archivo principal devuelve notASave sin escribir nada', () async {
      final savesDir = await makeSavesDir();
      final result = await TransferService().importArchive(
        ZipFixtures.missingMainFileArchive(),
        savesDir: savesDir.path,
        backupsDir: (await makeBackupsDir()).path,
      );
      expect(result.ok, isFalse);
      expect(result.error, ImportError.notASave);
      expect(await savesDir.list().toList(), isEmpty);
    });

    test('G5c: SaveGameInfo corrupto devuelve notASave sin escribir nada', () async {
      final savesDir = await makeSavesDir();
      final result = await TransferService().importArchive(
        ZipFixtures.corruptInfoArchive(),
        savesDir: savesDir.path,
        backupsDir: (await makeBackupsDir()).path,
      );
      expect(result.ok, isFalse);
      expect(result.error, ImportError.notASave);
      expect(await savesDir.list().toList(), isEmpty);
    });
  });

  group('importSave / importArchive — éxito y conflicto (G6-G8, G10)', () {
    test('G6: zip válido sin conflicto se mueve y devuelve ok', () async {
      final savesDir = await makeSavesDir();
      final result = await TransferService().importArchive(
        ZipFixtures.validArchive(),
        savesDir: savesDir.path,
        backupsDir: (await makeBackupsDir()).path,
      );
      expect(result.ok, isTrue);
      expect(result.importedFolderName, ZipFixtures.validFolderName);

      final sep = Platform.pathSeparator;
      final imported = Directory(
        '${savesDir.path}$sep${ZipFixtures.validFolderName}',
      );
      expect(await imported.exists(), isTrue);
      expect(
        await File('${imported.path}${sep}SaveGameInfo').exists(),
        isTrue,
      );
      expect(
        await File('${imported.path}$sep${ZipFixtures.validFolderName}')
            .exists(),
        isTrue,
      );
    });

    test('G7: carpeta destino ya existe sin overwrite -> conflict, sin tocar nada',
        () async {
      final savesDir = await makeSavesDir();
      final sep = Platform.pathSeparator;
      final existing = Directory(
        '${savesDir.path}$sep${ZipFixtures.validFolderName}',
      );
      await existing.create(recursive: true);
      final marker = File('${existing.path}${sep}marker');
      await marker.writeAsString('original');

      final result = await TransferService().importArchive(
        ZipFixtures.validArchive(),
        savesDir: savesDir.path,
        backupsDir: (await makeBackupsDir()).path,
      );
      expect(result.ok, isFalse);
      expect(result.conflict, isTrue);
      expect(result.importedFolderName, ZipFixtures.validFolderName);
      expect(await marker.exists(), isTrue);
      expect(await marker.readAsString(), 'original');
    });

    test('G8: overwrite:true reemplaza el contenido existente', () async {
      final savesDir = await makeSavesDir();
      final sep = Platform.pathSeparator;
      final existing = Directory(
        '${savesDir.path}$sep${ZipFixtures.validFolderName}',
      );
      await writeValidSaveFiles(existing, ZipFixtures.validFolderName);
      final marker = File('${existing.path}${sep}marker');
      await marker.writeAsString('original');

      final result = await TransferService().importArchive(
        ZipFixtures.validArchive(),
        savesDir: savesDir.path,
        backupsDir: (await makeBackupsDir()).path,
        overwrite: true,
      );
      expect(result.ok, isTrue);
      expect(await marker.exists(), isFalse);
      expect(
        await File('${existing.path}${sep}SaveGameInfo').exists(),
        isTrue,
      );
    });

    test('G10: fallo tras crear temporal no deja restos en savesDir', () async {
      final sep = Platform.pathSeparator;
      // savesDir apunta a la ruta de un ARCHIVO existente (no un directorio)
      // para forzar un fallo de escritura al intentar crear/mover dentro.
      final blocker = File('${tempDir.path}${sep}blocker');
      await blocker.writeAsString('not a dir');

      final result = await TransferService().importArchive(
        ZipFixtures.validArchive(),
        savesDir: blocker.path,
        backupsDir: (await makeBackupsDir()).path,
      );
      expect(result.ok, isFalse);
      expect(result.error, ImportError.writeFailure);
    });
  });

  group('roundtrip export -> import (G9)', () {
    test('G9: los datos de jugador sobreviven exportar + importar', () async {
      final sep = Platform.pathSeparator;
      final sourceDir = Directory('${tempDir.path}${sep}source');
      await sourceDir.create(recursive: true);
      const folderName = 'Roundtrip_1';
      final folder = Directory('${sourceDir.path}$sep$folderName');
      await folder.create(recursive: true);

      const mainXml = '''<?xml version="1.0" encoding="utf-8"?>
<SaveGame xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">
  <uniqueIDForThisGame>555</uniqueIDForThisGame>
  <player>
    <name>Roundtrip</name>
    <UniqueMultiplayerID>555555555555555555</UniqueMultiplayerID>
    <slotCanHost>false</slotCanHost>
    <homeLocation>FarmHouse</homeLocation>
    <Gender>Female</Gender>
    <money>777</money>
    <totalMoneyEarned>777</totalMoneyEarned>
    <millisecondsPlayed>1000</millisecondsPlayed>
    <farmingLevel>0</farmingLevel><miningLevel>0</miningLevel>
    <combatLevel>0</combatLevel><foragingLevel>0</foragingLevel>
    <fishingLevel>0</fishingLevel><deepestMineLevel>0</deepestMineLevel>
    <health>100</health><stamina>270</stamina>
  </player>
  <locations/>
</SaveGame>''';
      await File('${folder.path}$sep$folderName').writeAsString(mainXml);
      await File('${folder.path}${sep}SaveGameInfo').writeAsString('''<?xml version="1.0" encoding="utf-8"?>
<Farmer>
  <name>Roundtrip</name>
  <farmName>Granja Roundtrip</farmName>
  <slotCanHost>false</slotCanHost>
  <UniqueMultiplayerID>555555555555555555</UniqueMultiplayerID>
</Farmer>''');

      final originalPlayers =
          SaveService.parseFullSave(mainXml).map((p) => p.name).toList();

      final zipFile = await TransferService().exportSave(folder.path, folderName);
      final otherSavesDir = Directory('${tempDir.path}${sep}other_saves');
      await otherSavesDir.create(recursive: true);

      final result = await TransferService().importSave(
        zipFile.path,
        savesDir: otherSavesDir.path,
        backupsDir: (await makeBackupsDir()).path,
      );
      expect(result.ok, isTrue);

      final importedMain = await File(
        '${otherSavesDir.path}$sep$folderName$sep$folderName',
      ).readAsString();
      final importedPlayers =
          SaveService.parseFullSave(importedMain).map((p) => p.name).toList();

      expect(importedPlayers, originalPlayers);
    });
  });
}
