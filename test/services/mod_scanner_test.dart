import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:valleysave/core/models/mod_info.dart';
import 'package:valleysave/core/services/mod_prefs.dart';
import 'package:valleysave/core/services/mod_scanner.dart';

void main() {
  late Directory mods;
  final sep = Platform.pathSeparator;

  Future<void> writeMod(String rel, String manifest, {bool config = false}) async {
    final dir = Directory('${mods.path}$sep${rel.replaceAll('/', sep)}');
    await dir.create(recursive: true);
    await File('${dir.path}${sep}manifest.json').writeAsString(manifest);
    if (config) await File('${dir.path}${sep}config.json').writeAsString('{}');
  }

  setUp(() async {
    mods = await Directory.systemTemp.createTemp('vs_mods_');
    SharedPreferences.setMockInitialValues({});
  });

  tearDown(() => mods.delete(recursive: true));

  group('ModScanner.scan', () {
    test('lee mod C#, paquete de contenido y contenedores', () async {
      await writeMod('ContentPatcher', '''
{
  "Name": "Content Patcher",
  "Author": "Pathoschild",
  "Version": "2.5.0",
  "UniqueID": "Pathoschild.ContentPatcher",
  "EntryDll": "ContentPatcher.dll",
  "MinimumApiVersion": "4.1.0",
  "UpdateKeys": ["Nexus:1915"],
}''', config: true);
      await writeMod('[CP] Ridgeside/RSV-1234/Content', '''
{
  /* paquete dentro de un contenedor */
  "Name": "Ridgeside Village",
  "Author": "Rafseazz",
  "Version": "2.5.17",
  "UniqueId": "Rafseazz.RSVCP",
  "ContentPackFor": { "UniqueID": "Pathoschild.ContentPatcher" },
  "Dependencies": [
    { "UniqueID": "Pathoschild.ContentPatcher" },
    { "UniqueID": "Opcional.Mod", "IsRequired": false }
  ]
}''');
      await writeMod('.Desactivado', '{"Name":"X","UniqueID":"x.y","EntryDll":"a.dll"}');

      final list = await ModScanner.scan(mods.path);
      expect(list.map((m) => m.name), ['Content Patcher', 'Ridgeside Village']);

      final cp = list[0];
      expect(cp.kind, ModKind.csharp);
      expect(cp.version, '2.5.0');
      expect(cp.hasConfig, isTrue);
      expect(cp.pageUrl, 'https://www.nexusmods.com/stardewvalley/mods/1915');

      final rsv = list[1];
      expect(rsv.kind, ModKind.contentPack);
      expect(rsv.uniqueId, 'Rafseazz.RSVCP');
      expect(rsv.relativePath, '[CP] Ridgeside/RSV-1234/Content');
      expect(rsv.dependencies, ['Pathoschild.ContentPatcher']);
      expect(rsv.key, 'rafseazz.rsvcp');
    });

    test('ambos tipos a la vez o ninguno → inválido', () async {
      await writeMod('Ambos', '{"Name":"A","UniqueID":"a.a","EntryDll":"a.dll","ContentPackFor":{"UniqueID":"b"}}');
      await writeMod('Ninguno', '{"Name":"N","UniqueID":"n.n"}');
      final list = await ModScanner.scan(mods.path);
      expect(list.every((m) => m.kind == ModKind.invalid), isTrue);
    });

    test('manifiesto roto o sin UniqueID se omite; carpeta inexistente vacía', () async {
      await writeMod('Roto', '{ esto no es json');
      await writeMod('SinId', '{"Name":"S","EntryDll":"s.dll"}');
      expect(await ModScanner.scan(mods.path), isEmpty);
      expect(await ModScanner.scan('${mods.path}${sep}no_existe'), isEmpty);
    });
  });

  group('compatibilidad', () {
    ModInfo mod(ModKind kind, {String? minApi}) => ModInfo(
      uniqueId: 'a.b',
      name: 'A',
      author: '',
      version: '1.0.0',
      kind: kind,
      folderPath: '',
      relativePath: 'A',
      minimumApiVersion: minApi,
    );

    test('PC: según el SMAPI local', () {
      expect(ModScanner.pcCompat(mod(ModKind.csharp, minApi: '4.5.0'), '4.5.2'), ModCompat.works);
      expect(ModScanner.pcCompat(mod(ModKind.csharp, minApi: '4.6.0'), '4.5.2'), ModCompat.unsupported);
      expect(ModScanner.pcCompat(mod(ModKind.invalid), '4.5.2'), ModCompat.unsupported);
    });

    test('Android: contenido ✓, código ⚠, SMAPI demasiado nuevo ✗', () {
      expect(ModScanner.androidCompat(mod(ModKind.contentPack)), ModCompat.works);
      expect(ModScanner.androidCompat(mod(ModKind.csharp)), ModCompat.mayFail);
      expect(ModScanner.androidCompat(mod(ModKind.contentPack, minApi: '4.5.0')), ModCompat.unsupported);
    });

    test('compareVersions', () {
      expect(ModScanner.compareVersions('4.5.2', '4.5.10'), -1);
      expect(ModScanner.compareVersions('2.0', '2.0.0'), 0);
      expect(ModScanner.compareVersions('1.0.0-beta', '1.0.0'), -1);
      expect(ModScanner.compareVersions('1.1.0', '1.0.9'), 1);
    });
  });

  group('ModPrefs', () {
    test('la elección por partida manda sobre "llevar siempre"', () async {
      final p = ModPrefs.instance;
      await p.ensureLoaded();
      expect(p.carries('Granja_1', 'a.b'), isFalse);
      await p.setAlwaysCarry('a.b', true);
      expect(p.carries('Granja_1', 'a.b'), isTrue);
      await p.setCarries('Granja_1', 'a.b', false);
      expect(p.carries('Granja_1', 'a.b'), isFalse);
      expect(p.carries('Granja_2', 'a.b'), isTrue);
    });

    test('ajustes incluidos por defecto; JSON corrupto se ignora', () async {
      final p = ModPrefs.instance;
      expect(p.includeConfig('z.z'), isTrue);
      await p.setIncludeConfig('z.z', false);
      expect(p.includeConfig('z.z'), isFalse);
      expect(ModPrefs.decodeCarry('no json'), isEmpty);
    });
  });
}
