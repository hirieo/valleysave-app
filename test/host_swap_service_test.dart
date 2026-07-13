import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:xml/xml.dart';

import 'package:valleysave/core/services/host_swap_service.dart';
import 'package:valleysave/core/services/save_service.dart';
import 'package:valleysave/core/services/transfer_service.dart';

import 'fixtures/coop_save_fixture.dart';

/// Huella proyectada por el fixture: Farmhouse 9x5 sobre la cabaña de Bruno
/// (23,31) → X 23..31, Y 31..35.
const _footprintX0 = 23, _footprintX1 = 31, _footprintY0 = 31, _footprintY1 = 35;

/// Snapshot de una carpeta (nombre de archivo → bytes) para comprobar que
/// nada cambió (G1) o que el original sigue intacto (G2). Sin dependencias
/// nuevas: bytes crudos + `equals` (deep-compara Map/List de por sí).
Future<Map<String, List<int>>> _snapshot(Directory dir) async {
  final out = <String, List<int>>{};
  await for (final e in dir.list(recursive: true)) {
    if (e is File) {
      out[e.path] = await e.readAsBytes();
    }
  }
  return out;
}

/// Cuenta los `<item>` dentro de objects+terrainFeatures+largeTerrainFeatures
/// de la location `Farm` (para comprobar que nada se pierde — G7).
int _countFarmItems(XmlDocument doc) {
  final farm = doc.rootElement
      .findElements('locations')
      .first
      .findElements('GameLocation')
      .firstWhere((l) => l.findElements('name').first.innerText == 'Farm');
  var count = 0;
  for (final c in ['objects', 'terrainFeatures', 'largeTerrainFeatures']) {
    final container = farm.findElements(c).firstOrNull;
    if (container == null) continue;
    count += container.findElements('item').length;
  }
  return count;
}

void main() {
  late Directory tempDir;
  late String saveFolderPath;
  late String savesDir;
  late String backupsDir;
  final service = HostSwapService();

  String mainFilePath(String folderName) =>
      '$savesDir${Platform.pathSeparator}$folderName${Platform.pathSeparator}$folderName';

  setUp(() async {
    tempDir = await Directory.systemTemp.createTemp('host_swap_test_');
    final r = await CoopSaveFixture.create(tempDir);
    saveFolderPath = r.saveFolderPath;
    savesDir = r.savesDir;
    backupsDir = '${tempDir.path}${Platform.pathSeparator}Backups';
  });

  tearDown(() async {
    if (await tempDir.exists()) await tempDir.delete(recursive: true);
  });

  group('analyze', () {
    test('cuenta 3 objetos no ignorables (1 Chest + 2 Tree); Weeds excluida', () async {
      final result = await service.analyze(
        saveFolderPath: saveFolderPath,
        targetUniqueId: CoopSaveFixture.targetUniqueId,
      );
      expect(result.ok, isTrue);
      expect(result.itemsToRelocate, 3);
      expect(result.targetName, CoopSaveFixture.targetName);
    });

    test('G1: analyze no escribe ni crea nada', () async {
      final before = await _snapshot(Directory(saveFolderPath));
      await service.analyze(
        saveFolderPath: saveFolderPath,
        targetUniqueId: CoopSaveFixture.targetUniqueId,
      );
      final after = await _snapshot(Directory(saveFolderPath));
      expect(after, before);
      final entries = await Directory(savesDir).list().toList();
      expect(entries.length, 1, reason: 'no debe aparecer ninguna carpeta nueva');
    });

    test('objetivo inexistente ⇒ invalidSave', () async {
      final result = await service.analyze(
        saveFolderPath: saveFolderPath,
        targetUniqueId: 'no-existe',
      );
      expect(result.ok, isFalse);
      expect(result.error, HostSwapError.invalidSave);
    });

    test('cabaña vacía (sin nombre) no es objetivo válido ⇒ invalidSave', () async {
      final result = await service.analyze(
        saveFolderPath: saveFolderPath,
        targetUniqueId: CoopSaveFixture.emptyUniqueId,
      );
      expect(result.ok, isFalse);
      expect(result.error, HostSwapError.invalidSave);
    });

    test('sin colisiones ⇒ itemsToRelocate = 0', () async {
      await File(mainFilePath(CoopSaveFixture.originalFolderName))
          .writeAsString(CoopSaveFixture.mainXmlNoCollisions());
      final result = await service.analyze(
        saveFolderPath: saveFolderPath,
        targetUniqueId: CoopSaveFixture.targetUniqueId,
      );
      expect(result.ok, isTrue);
      expect(result.itemsToRelocate, 0);
    });

    test('granja saturada ⇒ noFreeTile', () async {
      await File(mainFilePath(CoopSaveFixture.originalFolderName))
          .writeAsString(CoopSaveFixture.mainXmlSaturated());
      final result = await service.analyze(
        saveFolderPath: saveFolderPath,
        targetUniqueId: CoopSaveFixture.targetUniqueId,
      );
      expect(result.ok, isFalse);
      expect(result.error, HostSwapError.noFreeTile);
    });
  });

  group('execute — swap en sitio (spec 007)', () {
    test('G2: folderName y uniqueIDForThisGame NO cambian tras el swap', () async {
      final originalId = XmlDocument.parse(CoopSaveFixture.mainXml())
          .rootElement
          .findElements('uniqueIDForThisGame')
          .first
          .innerText;

      final result = await service.execute(
        saveFolderPath: saveFolderPath,
        targetUniqueId: CoopSaveFixture.targetUniqueId,
        backupsDir: backupsDir,
      );
      expect(result.ok, isTrue);

      // Sigue en la MISMA carpeta, mismo nombre — no aparece ninguna carpeta
      // nueva en savesDir.
      final entries = await Directory(savesDir).list().toList();
      expect(entries.length, 1);
      expect(
        entries.single.path.split(Platform.pathSeparator).last,
        CoopSaveFixture.originalFolderName,
      );

      final mainFile = File(mainFilePath(CoopSaveFixture.originalFolderName));
      expect(await mainFile.exists(), isTrue);
      final doc = XmlDocument.parse(await mainFile.readAsString());
      final idAfter =
          doc.rootElement.findElements('uniqueIDForThisGame').first.innerText;
      expect(idAfter, originalId, reason: 'el id ya no se muta (spec 007)');
    });

    test('G8: no queda _old_tmp ni temporal tras el éxito', () async {
      await service.execute(
        saveFolderPath: saveFolderPath,
        targetUniqueId: CoopSaveFixture.targetUniqueId,
        backupsDir: backupsDir,
      );
      final entries = await Directory(savesDir).list().toList();
      expect(entries.length, 1, reason: 'ni _old_tmp ni ninguna otra carpeta debe sobrevivir');
    });

    test('G3: el zip de respaldo reproduce el save PRE-swap (roundtrip con importSave)',
        () async {
      final result = await service.execute(
        saveFolderPath: saveFolderPath,
        targetUniqueId: CoopSaveFixture.targetUniqueId,
        backupsDir: backupsDir,
      );
      expect(result.ok, isTrue);
      expect(result.backupZipPath, isNotNull);
      expect(await File(result.backupZipPath!).exists(), isTrue);

      final restoreDir = Directory('${tempDir.path}${Platform.pathSeparator}restore');
      await restoreDir.create(recursive: true);
      final importResult = await TransferService().importSave(
        result.backupZipPath!,
        savesDir: restoreDir.path,
      );
      expect(importResult.ok, isTrue);
      expect(importResult.importedFolderName, CoopSaveFixture.originalFolderName);

      final restoredMain = await File(
        '${restoreDir.path}${Platform.pathSeparator}${CoopSaveFixture.originalFolderName}${Platform.pathSeparator}${CoopSaveFixture.originalFolderName}',
      ).readAsString();
      final restoredPlayers = SaveService.parseFullSave(restoredMain);
      final restoredHost = restoredPlayers.firstWhere((p) => p.isHost);
      expect(
        restoredHost.uniqueId,
        CoopSaveFixture.hostUniqueId,
        reason: 'el respaldo es la versión ANTERIOR al swap — Ana sigue siendo anfitriona ahí',
      );
    });

    test('G1: si el zip de respaldo no se puede crear, el original queda intacto',
        () async {
      // Bloquea backupsDir con un ARCHIVO en su lugar → Directory(...).create()
      // falla dentro de _zipFolder, que devuelve null antes de tocar el original.
      final blocker = File(backupsDir);
      await blocker.parent.create(recursive: true);
      await blocker.writeAsString('not a dir');

      final beforeSnapshot = await _snapshot(Directory(saveFolderPath));

      final result = await service.execute(
        saveFolderPath: saveFolderPath,
        targetUniqueId: CoopSaveFixture.targetUniqueId,
        backupsDir: backupsDir,
      );

      expect(result.ok, isFalse);
      expect(result.error, HostSwapError.writeFailure);

      final afterSnapshot = await _snapshot(Directory(saveFolderPath));
      expect(afterSnapshot, beforeSnapshot, reason: 'el original nunca se toca si el zip falla');
      final entries = await Directory(savesDir).list().toList();
      expect(entries.length, 1);
    });

    test('G4: sin archivos *_old en el save resultante', () async {
      final result = await service.execute(
        saveFolderPath: saveFolderPath,
        targetUniqueId: CoopSaveFixture.targetUniqueId,
        backupsDir: backupsDir,
      );
      expect(result.ok, isTrue);
      final oldFiles = await Directory(saveFolderPath)
          .list()
          .where((e) => e.path.endsWith('_old'))
          .toList();
      expect(oldFiles, isEmpty);
    });

    test('G5: SaveGameInfo raíz = nombre real del nuevo host', () async {
      final result = await service.execute(
        saveFolderPath: saveFolderPath,
        targetUniqueId: CoopSaveFixture.targetUniqueId,
        backupsDir: backupsDir,
      );
      expect(result.ok, isTrue);
      final infoFile = File(
        '$saveFolderPath${Platform.pathSeparator}SaveGameInfo',
      );
      final infoDoc = XmlDocument.parse(await infoFile.readAsString());
      expect(infoDoc.rootElement.name.local, CoopSaveFixture.targetName);
      expect(
        infoDoc.rootElement.findElements('slotCanHost').first.innerText,
        'true',
      );
    });

    test('G6+G12: roles intercambiados; nombres/IDs/ampliación viajan con la persona', () async {
      final result = await service.execute(
        saveFolderPath: saveFolderPath,
        targetUniqueId: CoopSaveFixture.targetUniqueId,
        backupsDir: backupsDir,
      );
      expect(result.ok, isTrue);
      final mainRaw =
          await File(mainFilePath(CoopSaveFixture.originalFolderName)).readAsString();
      final players = SaveService.parseFullSave(mainRaw);

      final newHost =
          players.firstWhere((p) => p.uniqueId == CoopSaveFixture.targetUniqueId);
      final oldHost =
          players.firstWhere((p) => p.uniqueId == CoopSaveFixture.hostUniqueId);

      expect(newHost.isHost, isTrue, reason: 'Bruno pasa a ser el anfitrión');
      expect(newHost.name, CoopSaveFixture.targetName, reason: 'el nombre no se toca');
      expect(oldHost.isHost, isFalse, reason: 'Ana pasa a farmhand');
      expect(oldHost.name, CoopSaveFixture.hostName);

      expect(newHost.houseUpgradeLevel, 0);
      expect(oldHost.houseUpgradeLevel, 0);

      final doc = XmlDocument.parse(mainRaw);
      final farmhandsHomes = doc.rootElement
          .findElements('farmhands')
          .first
          .findElements('Farmer')
          .map((f) => f.findElements('homeLocation').firstOrNull?.innerText)
          .toList();
      expect(
        farmhandsHomes,
        contains(CoopSaveFixture.targetHome),
        reason: 'Ana (farmhand ahora) vive en la cabaña que era de Bruno',
      );
    });

    test('G7: nº total de objetos de Farm idéntico antes/después', () async {
      final beforeDoc = XmlDocument.parse(CoopSaveFixture.mainXml());
      final before = _countFarmItems(beforeDoc);

      final result = await service.execute(
        saveFolderPath: saveFolderPath,
        targetUniqueId: CoopSaveFixture.targetUniqueId,
        backupsDir: backupsDir,
      );
      expect(result.ok, isTrue);
      final afterRaw =
          await File(mainFilePath(CoopSaveFixture.originalFolderName)).readAsString();
      final after = _countFarmItems(XmlDocument.parse(afterRaw));

      expect(after, before, reason: 'nada se borra, solo se reubica');
    });

    test('G8b: los objetos reubicados no quedan dentro de la huella nueva', () async {
      final result = await service.execute(
        saveFolderPath: saveFolderPath,
        targetUniqueId: CoopSaveFixture.targetUniqueId,
        backupsDir: backupsDir,
      );
      expect(result.ok, isTrue);
      final afterRaw =
          await File(mainFilePath(CoopSaveFixture.originalFolderName)).readAsString();
      final farm = XmlDocument.parse(afterRaw)
          .rootElement
          .findElements('locations')
          .first
          .findElements('GameLocation')
          .firstWhere((l) => l.findElements('name').first.innerText == 'Farm');

      for (final c in ['objects', 'terrainFeatures']) {
        final container = farm.findElements(c).firstOrNull;
        if (container == null) continue;
        for (final item in container.findElements('item')) {
          final vec = item.findElements('key').first.findElements('Vector2').first;
          final tx = int.parse(vec.findElements('X').first.innerText);
          final ty = int.parse(vec.findElements('Y').first.innerText);
          final insideFootprint = tx >= _footprintX0 &&
              tx <= _footprintX1 &&
              ty >= _footprintY0 &&
              ty <= _footprintY1;
          final valChild = item
              .findElements('value')
              .first
              .children
              .whereType<XmlElement>()
              .first;
          final isWeeds = valChild.attributes
                  .where((a) => a.name.qualified == 'xsi:type')
                  .firstOrNull
                  ?.value ==
              'Weeds';
          if (!isWeeds) {
            expect(
              insideFootprint,
              isFalse,
              reason: 'objeto no ignorable en $tx,$ty sigue dentro de la huella nueva',
            );
          }
        }
      }
    });

    test('G9: boundingBox del cofre reubicado = tile*64', () async {
      final result = await service.execute(
        saveFolderPath: saveFolderPath,
        targetUniqueId: CoopSaveFixture.targetUniqueId,
        backupsDir: backupsDir,
      );
      expect(result.ok, isTrue);
      final afterRaw =
          await File(mainFilePath(CoopSaveFixture.originalFolderName)).readAsString();
      final farm = XmlDocument.parse(afterRaw)
          .rootElement
          .findElements('locations')
          .first
          .findElements('GameLocation')
          .firstWhere((l) => l.findElements('name').first.innerText == 'Farm');
      final objects = farm.findElements('objects').first;

      XmlElement? movedChest;
      for (final item in objects.findElements('item')) {
        final vec = item.findElements('key').first.findElements('Vector2').first;
        final tx = int.parse(vec.findElements('X').first.innerText);
        final ty = int.parse(vec.findElements('Y').first.innerText);
        if (tx == 10 && ty == 10) continue; // el cofre que NUNCA se movió
        final valChild =
            item.findElements('value').first.children.whereType<XmlElement>().first;
        final isChest = valChild.attributes
                .where((a) => a.name.qualified == 'xsi:type')
                .firstOrNull
                ?.value ==
            'Chest';
        if (isChest) movedChest = item;
      }

      expect(movedChest, isNotNull, reason: 'el cofre reubicado debe seguir existiendo');
      final vec = movedChest!.findElements('key').first.findElements('Vector2').first;
      final tx = int.parse(vec.findElements('X').first.innerText);
      final ty = int.parse(vec.findElements('Y').first.innerText);
      final valChild = movedChest.findElements('value').first.children
          .whereType<XmlElement>()
          .first;
      final bbox = valChild.findElements('boundingBox').first;
      expect(int.parse(bbox.findElements('X').first.innerText), tx * 64);
      expect(int.parse(bbox.findElements('Y').first.innerText), ty * 64);
      final loc = bbox.findElements('Location').first;
      expect(int.parse(loc.findElements('X').first.innerText), tx * 64);
      expect(int.parse(loc.findElements('Y').first.innerText), ty * 64);
      expect(int.parse(bbox.findElements('Width').first.innerText), 64);
      expect(int.parse(bbox.findElements('Height').first.innerText), 64);
    });

    test('G10: itemsToRelocate (analyze) == relocatedCount (execute) sobre el mismo save', () async {
      final analysis = await service.analyze(
        saveFolderPath: saveFolderPath,
        targetUniqueId: CoopSaveFixture.targetUniqueId,
      );
      final result = await service.execute(
        saveFolderPath: saveFolderPath,
        targetUniqueId: CoopSaveFixture.targetUniqueId,
        backupsDir: backupsDir,
      );
      expect(result.relocatedCount, analysis.itemsToRelocate);
    });

    test('G11: re-parseo con SaveService.parseFullSave — host correcto, nº jugadores intacto', () async {
      final result = await service.execute(
        saveFolderPath: saveFolderPath,
        targetUniqueId: CoopSaveFixture.targetUniqueId,
        backupsDir: backupsDir,
      );
      expect(result.ok, isTrue);
      final mainRaw =
          await File(mainFilePath(CoopSaveFixture.originalFolderName)).readAsString();
      final players = SaveService.parseFullSave(mainRaw);
      expect(players.length, 2);
      expect(players.where((p) => p.isHost).length, 1);
      expect(players.firstWhere((p) => p.isHost).uniqueId, CoopSaveFixture.targetUniqueId);
    });
  });

  group('errores', () {
    test('granja saturada en execute ⇒ nada creado, original intacto, sin zip', () async {
      await File(mainFilePath(CoopSaveFixture.originalFolderName))
          .writeAsString(CoopSaveFixture.mainXmlSaturated());
      final beforeSnapshot = await _snapshot(Directory(saveFolderPath));

      final result = await service.execute(
        saveFolderPath: saveFolderPath,
        targetUniqueId: CoopSaveFixture.targetUniqueId,
        backupsDir: backupsDir,
      );

      expect(result.ok, isFalse);
      expect(result.error, HostSwapError.noFreeTile);

      final entries = await Directory(savesDir).list().toList();
      expect(entries.length, 1, reason: 'ninguna carpeta nueva debe sobrevivir');

      final afterSnapshot = await _snapshot(Directory(saveFolderPath));
      expect(afterSnapshot, beforeSnapshot, reason: 'el original no se toca ni con fallo');

      final backupsExists = await Directory(backupsDir).exists();
      expect(
        backupsExists,
        isFalse,
        reason: 'el zip se crea DESPUÉS de validar el swap — noFreeTile falla antes',
      );
    });

    test('objetivo inexistente en execute ⇒ invalidSave, nada creado', () async {
      final result = await service.execute(
        saveFolderPath: saveFolderPath,
        targetUniqueId: 'no-existe',
        backupsDir: backupsDir,
      );
      expect(result.ok, isFalse);
      expect(result.error, HostSwapError.invalidSave);
      final entries = await Directory(savesDir).list().toList();
      expect(entries.length, 1);
    });

    // Nota de alcance: `postValidationFailed` comparte el mismo mecanismo de
    // limpieza que `noFreeTile` (ambos borran el temporal antes de devolver
    // el error, sin llegar a zipear ni renombrar nada) — los tests de arriba
    // ya demuestran esa garantía. Forzar específicamente un fallo de
    // *validación post-swap* requeriría inyectar un fallo a mitad del
    // algoritmo, fuera de alcance para esta suite de caja negra.
  });
}
