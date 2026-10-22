import 'dart:io';

import 'package:archive/archive.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:valleysave/core/models/mod_info.dart';
import 'package:valleysave/core/services/mod_scanner.dart';
import 'package:valleysave/core/services/mod_transfer_service.dart';

void main() {
  late Directory tmp;
  late String modsA;
  late String modsB;
  late String backups;
  final sep = Platform.pathSeparator;

  const manifest =
      '{"Name":"Test Mod","Author":"Yo","Version":"1.2.0",'
      '"UniqueID":"Yo.TestMod","EntryDll":"TestMod.dll"}';

  Future<ModInfo> makeMod(String modsDir, {String config = '{"a":1}'}) async {
    final dir = Directory('$modsDir${sep}Test Mod');
    await Directory('${dir.path}${sep}assets').create(recursive: true);
    await File('${dir.path}${sep}manifest.json').writeAsString(manifest);
    await File('${dir.path}${sep}TestMod.dll').writeAsString('dll');
    await File('${dir.path}${sep}assets${sep}x.png').writeAsString('png');
    await File('${dir.path}${sep}config.json').writeAsString(config);
    return (await ModScanner.scan(modsDir)).single;
  }

  setUp(() async {
    tmp = await Directory.systemTemp.createTemp('vs_modxfer_');
    modsA = '${tmp.path}${sep}A';
    modsB = '${tmp.path}${sep}B';
    backups = '${tmp.path}${sep}bk';
    await Directory(modsA).create();
    await Directory(modsB).create();
  });

  tearDown(() => tmp.delete(recursive: true));

  test('ida y vuelta: zip en un equipo, instalar en otro', () async {
    final mod = await makeMod(modsA);
    final zip = await ModTransferService.zipMod(mod, includeConfig: true);
    final r = await ModTransferService.installMod(
      zip,
      modsDir: modsB,
      relativePath: mod.relativePath,
      expectedUniqueId: mod.uniqueId,
    );
    expect(r.ok, isTrue);
    final installed = await ModScanner.scan(modsB);
    expect(installed.single.uniqueId, 'Yo.TestMod');
    expect(
      await File('$modsB${sep}Test Mod${sep}assets${sep}x.png').readAsString(),
      'png',
    );
    expect(
      await File('$modsB${sep}Test Mod${sep}config.json').readAsString(),
      '{"a":1}',
    );
  });

  test('sin ajustes en el zip se conservan los del equipo destino y se respalda', () async {
    final mod = await makeMod(modsA, config: '{"origen":true}');
    await makeMod(modsB, config: '{"mios":true}');
    final zip = await ModTransferService.zipMod(mod, includeConfig: false);
    final existing = (await ModScanner.scan(modsB)).single.folderPath;
    final r = await ModTransferService.installMod(
      zip,
      modsDir: modsB,
      relativePath: mod.relativePath,
      expectedUniqueId: mod.uniqueId,
      existingFolder: existing,
      backupsDir: backups,
    );
    expect(r.ok, isTrue);
    expect(r.backupPath, isNotNull);
    expect(await File(r.backupPath!).exists(), isTrue);
    expect(
      await File('$existing${sep}config.json').readAsString(),
      '{"mios":true}',
    );
    final leftovers = Directory(modsB)
        .listSync()
        .where((e) => e.path.split(sep).last.startsWith('.vs_'));
    expect(leftovers, isEmpty);
  });

  test('un zip de otro mod no se instala y no toca nada', () async {
    final mod = await makeMod(modsA);
    final zip = await ModTransferService.zipMod(mod, includeConfig: true);
    final r = await ModTransferService.installMod(
      zip,
      modsDir: modsB,
      relativePath: 'Otro',
      expectedUniqueId: 'Otro.Mod',
    );
    expect(r.ok, isFalse);
    expect(r.error, ModInstallError.wrongMod);
    expect(Directory(modsB).listSync(), isEmpty);
  });

  test('rutas peligrosas se rechazan', () async {
    for (final bad in ['../fuera', '/abs', r'a\b', '.oculto', 'a/../b', '']) {
      expect(ModTransferService.isSafeRelativePath(bad), isFalse, reason: bad);
    }
    expect(ModTransferService.isSafeRelativePath('[CP] Mod/Content'), isTrue);

    final archive = Archive()
      ..addFile(ArchiveFile.bytes('manifest.json', manifest.codeUnits))
      ..addFile(ArchiveFile.bytes('../escape.txt', 'x'.codeUnits));
    final r = await ModTransferService.installMod(
      ZipEncoder().encodeBytes(archive),
      modsDir: modsB,
      relativePath: 'Test Mod',
      expectedUniqueId: 'Yo.TestMod',
    );
    expect(r.error, ModInstallError.unsafePath);
    expect(await File('${tmp.path}${sep}escape.txt').exists(), isFalse);
  });

  test('mods.json: ida y vuelta y JSON roto', () {
    const entry = SaveModEntry(
      uniqueId: 'Yo.TestMod',
      name: 'Test Mod',
      version: '1.2.0',
      kind: ModKind.csharp,
      relativePath: 'Test Mod',
      includeConfig: false,
      pageUrl: 'https://www.nexusmods.com/stardewvalley/mods/1',
    );
    final decoded = SaveModEntry.decodeList(SaveModEntry.encodeList([entry]));
    expect(decoded.single.uniqueId, 'Yo.TestMod');
    expect(decoded.single.includeConfig, isFalse);
    expect(decoded.single.kind, ModKind.csharp);
    expect(SaveModEntry.decodeList('nope'), isEmpty);
  });
}
