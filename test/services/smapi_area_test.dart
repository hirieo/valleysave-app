import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:valleysave/core/models/save_area.dart';
import 'package:valleysave/core/services/drive_service.dart';
import 'package:valleysave/core/services/save_area_classifier.dart';
import 'package:valleysave/core/services/smapi_service.dart';

void main() {
  late Directory tmp;
  final sep = Platform.pathSeparator;

  setUp(() async {
    tmp = await Directory.systemTemp.createTemp('vs_smapi_');
    SharedPreferences.setMockInitialValues({});
  });

  tearDown(() => tmp.delete(recursive: true));

  group('SmapiService.detectIn', () {
    test('sin SMAPI devuelve null', () async {
      expect(await SmapiService.detectIn(tmp.path), isNull);
    });

    test('detecta SMAPI y lee la versión de ConsoleCommands', () async {
      await File('${tmp.path}${sep}StardewModdingAPI.dll').writeAsString('x');
      await Directory('${tmp.path}${sep}smapi-internal').create();
      final mod = Directory('${tmp.path}${sep}Mods${sep}ConsoleCommands');
      await mod.create(recursive: true);
      await File('${mod.path}${sep}manifest.json').writeAsString('''
{
  // comentario permitido en manifiestos
  "Name": "Console Commands",
  "Version": "4.5.2",
}''');

      final install = await SmapiService.detectIn(tmp.path);
      expect(install, isNotNull);
      expect(install!.version, '4.5.2');
      expect(install.modsDir, '${tmp.path}${sep}Mods');
    });

    test('sin ConsoleCommands: detectado, versión desconocida', () async {
      await File('${tmp.path}${sep}StardewModdingAPI.dll').writeAsString('x');
      await Directory('${tmp.path}${sep}smapi-internal').create();
      final install = await SmapiService.detectIn(
        tmp.path,
        modsDirOverride: '${tmp.path}${sep}OtrosMods',
      );
      expect(install!.version, isNull);
      expect(install.modsDir, '${tmp.path}${sep}OtrosMods');
    });

    test('solo el dll sin smapi-internal no cuenta', () async {
      await File('${tmp.path}${sep}StardewModdingAPI.dll').writeAsString('x');
      expect(await SmapiService.detectIn(tmp.path), isNull);
    });
  });

  group('SmapiService.isValidLocalPath', () {
    test('rechaza relativas, vacías y con ..', () {
      expect(SmapiService.isValidLocalPath(null), isFalse);
      expect(SmapiService.isValidLocalPath(''), isFalse);
      expect(SmapiService.isValidLocalPath('Mods'), isFalse);
      final bad = Platform.isWindows ? r'C:\juego\..\Mods' : '/juego/../Mods';
      expect(SmapiService.isValidLocalPath(bad), isFalse);
    });

    test('acepta una absoluta normal', () {
      final ok = Platform.isWindows
          ? r'C:\Program Files (x86)\Steam\steamapps\common\Stardew Valley\Mods'
          : '/home/u/.local/share/Steam/steamapps/common/Stardew Valley/Mods';
      expect(SmapiService.isValidLocalPath(ok), isTrue);
    });
  });

  group('isModSidecarName', () {
    test('acepta datos de mod planos .json', () {
      expect(isModSidecarName('spacecore-serialization.json'), isTrue);
      expect(isModSidecarName('spacecore-serialization-farmer.json'), isTrue);
    });

    test('rechaza rutas, metadatos de la app y otros archivos', () {
      expect(isModSidecarName('../evil.json'), isFalse);
      expect(isModSidecarName('a/b.json'), isFalse);
      expect(isModSidecarName(r'a\b.json'), isFalse);
      expect(isModSidecarName('manifest.json'), isFalse);
      expect(isModSidecarName('players.json'), isFalse);
      expect(isModSidecarName('SaveGameInfo'), isFalse);
      expect(isModSidecarName('.hidden.json'), isFalse);
      expect(isModSidecarName('x.json.exe'), isFalse);
    });
  });

  group('SaveAreaClassifier', () {
    const folder = 'Granja_123';

    Future<Directory> makeSave(String mainContent) async {
      final dir = Directory('${tmp.path}$sep$folder');
      await dir.create();
      await File('${dir.path}${sep}SaveGameInfo').writeAsString('<x/>');
      await File('${dir.path}$sep$folder').writeAsString(mainContent);
      return dir;
    }

    test('partida sin rastro de mods va a Normal', () async {
      await makeSave('<SaveGame><player/></SaveGame>');
      expect(
        await SaveAreaClassifier.instance.classify(tmp.path, folder),
        SaveArea.normal,
      );
    });

    test('clave smapi/mod-data en la partida la manda a SMAPI', () async {
      await makeSave(
        '<SaveGame><CustomData><key>smapi/mod-data/pathoschild.x/y</key>'
        '</CustomData></SaveGame>',
      );
      expect(
        await SaveAreaClassifier.instance.classify(tmp.path, folder),
        SaveArea.smapi,
      );
    });

    test('datos de mod .json junto a la partida la mandan a SMAPI', () async {
      final dir = await makeSave('<SaveGame/>');
      await File(
        '${dir.path}${sep}spacecore-serialization.json',
      ).writeAsString('{}');
      expect(
        await SaveAreaClassifier.instance.hasModTraces(dir.path, folder),
        isTrue,
      );
    });

    test('la elección manual manda sobre la detección', () async {
      await makeSave('smapi/mod-data/a/b');
      await SaveAreaClassifier.instance.setOverride(folder, SaveArea.normal);
      expect(
        await SaveAreaClassifier.instance.classify(tmp.path, folder),
        SaveArea.normal,
      );
      await SaveAreaClassifier.instance.setOverride(folder, null);
      expect(
        await SaveAreaClassifier.instance.classify(tmp.path, folder),
        SaveArea.smapi,
      );
    });

    test('containsBytes encuentra el marcador partido entre bloques', () async {
      final needle = ascii.encode('smapi/mod-data/');
      final stream = Stream<List<int>>.fromIterable([
        ascii.encode('xxxxsmapi/mo'),
        ascii.encode('d-data/yyy'),
      ]);
      expect(await SaveAreaClassifier.containsBytes(stream, needle), isTrue);
    });

    test('overrides: JSON corrupto o valores desconocidos se ignoran', () {
      expect(SaveAreaClassifier.decodeOverrides('no json'), isEmpty);
      expect(
        SaveAreaClassifier.decodeOverrides('{"a":"smapi","b":"otro"}'),
        {'a': SaveArea.smapi},
      );
      final round = SaveAreaClassifier.encodeOverrides({'a': SaveArea.smapi});
      expect(SaveAreaClassifier.decodeOverrides(round), {'a': SaveArea.smapi});
    });
  });
}
