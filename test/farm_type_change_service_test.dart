import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:valleysave/core/services/farm_content_relocation.dart';
import 'package:valleysave/core/services/farm_type_change_service.dart';
import 'package:valleysave/core/services/farm_placement_service.dart';
import 'package:xml/xml.dart';

import 'fixtures/farm_type_change_fixture.dart';

void main() {
  late Directory tempRoot;
  late Directory saveDirectory;
  late String mainPath;
  late String backupsPath;

  setUp(() async {
    tempRoot = await Directory.systemTemp.createTemp('farm_type_change_test_');
    saveDirectory = Directory(
      '${tempRoot.path}${Platform.pathSeparator}${FarmTypeChangeFixture.folderName}',
    );
    await saveDirectory.create(recursive: true);
    mainPath =
        '${saveDirectory.path}${Platform.pathSeparator}${FarmTypeChangeFixture.folderName}';
    backupsPath = '${tempRoot.path}${Platform.pathSeparator}backups';
    await File(mainPath).writeAsString(FarmTypeChangeFixture.mainXml());
    await File(
      '${saveDirectory.path}${Platform.pathSeparator}SaveGameInfo',
    ).writeAsString(FarmTypeChangeFixture.saveInfoXml());
  });

  tearDown(() async {
    if (await tempRoot.exists()) await tempRoot.delete(recursive: true);
  });

  test('analyze is read-only and lists the unsafe buildings', () async {
    final before = await File(mainPath).readAsBytes();
    final analysis = await const FarmTypeChangeService().analyze(
      saveFolderPath: saveDirectory.path,
      targetWhichFarm: 6,
    );

    expect(analysis.ok, isTrue);
    expect(analysis.sourceWhichFarm, 1);
    expect(analysis.targetWhichFarm, 6);
    expect(
      analysis.buildingMoves.map((move) => move.building.id),
      containsAll(['coop', 'silo']),
    );
    expect(await File(mainPath).readAsBytes(), before);
  });

  test('execute backs up and publishes a validated Beach layout', () async {
    final result = await const FarmTypeChangeService().execute(
      saveFolderPath: saveDirectory.path,
      targetWhichFarm: 6,
      backupsDir: backupsPath,
    );

    expect(result.ok, isTrue, reason: result.error?.name);
    expect(result.backupPath, isNotNull);
    expect(await File(result.backupPath!).exists(), isTrue);

    final document = XmlDocument.parse(await File(mainPath).readAsString());
    expect(document.rootElement.findElements('whichFarm').first.innerText, '6');
    final farm = document.rootElement
        .findElements('locations')
        .first
        .findElements('GameLocation')
        .first;
    final beach = VanillaFarmSurfaceRepository.forWhichFarm(6)!;
    final ids = <String>{};
    for (final building
        in farm.findElements('buildings').first.findElements('Building')) {
      ids.add(
        building
            .findElements('buildingId')
            .first
            .findElements('Guid')
            .first
            .innerText,
      );
      final x = int.parse(building.findElements('tileX').first.innerText);
      final y = int.parse(building.findElements('tileY').first.innerText);
      final width = int.parse(
        building.findElements('tilesWide').first.innerText,
      );
      final height = int.parse(
        building.findElements('tilesHigh').first.innerText,
      );
      for (var dy = 0; dy < height; dy++) {
        for (var dx = 0; dx < width; dx++) {
          expect(
            beach.isBuildable(TilePoint(x + dx, y + dy)),
            isTrue,
            reason:
                '${building.findElements('buildingType').first.innerText} ${x + dx},${y + dy}',
          );
        }
      }
    }
    expect(ids, {
      'farmhouse',
      'greenhouse',
      'shipping',
      'coop',
      'silo',
      'cabin',
    });
  });

  test('writes Meadowlands using the AdditionalFarms textual ID', () async {
    final result = await const FarmTypeChangeService().execute(
      saveFolderPath: saveDirectory.path,
      targetWhichFarm: 7,
      backupsDir: backupsPath,
    );

    expect(result.ok, isTrue, reason: result.error?.name);
    final document = XmlDocument.parse(await File(mainPath).readAsString());
    expect(
      document.rootElement.findElements('whichFarm').single.innerText,
      'MeadowlandsFarm',
    );
  });

  test('normalizes a legacy numeric Meadowlands value', () async {
    final raw = (await File(mainPath).readAsString()).replaceFirst(
      '<whichFarm>1</whichFarm>',
      '<whichFarm>7</whichFarm>',
    );
    await File(mainPath).writeAsString(raw);

    final analysis = await const FarmTypeChangeService().analyze(
      saveFolderPath: saveDirectory.path,
      targetWhichFarm: 7,
    );
    expect(analysis.ok, isTrue);
    expect(analysis.sourceWhichFarm, 7);

    final result = await const FarmTypeChangeService().execute(
      saveFolderPath: saveDirectory.path,
      targetWhichFarm: 7,
      backupsDir: backupsPath,
    );
    expect(result.ok, isTrue, reason: result.error?.name);
    final document = XmlDocument.parse(await File(mainPath).readAsString());
    expect(
      document.rootElement.findElements('whichFarm').single.innerText,
      'MeadowlandsFarm',
    );
  });

  test('rejects same farm and unsupported target without writing', () async {
    final before = await File(mainPath).readAsBytes();
    final same = await const FarmTypeChangeService().analyze(
      saveFolderPath: saveDirectory.path,
      targetWhichFarm: 1,
    );
    final unsupported = await const FarmTypeChangeService().analyze(
      saveFolderPath: saveDirectory.path,
      targetWhichFarm: 99,
    );
    expect(same.error, FarmTypeChangeError.sameFarm);
    expect(unsupported.error, FarmTypeChangeError.unsupportedTarget);
    expect(await File(mainPath).readAsBytes(), before);
  });

  test('reports moved content by kind for the future warning UI', () async {
    final raw = FarmTypeChangeFixture.mainXml().replaceFirst(
      '<objects />',
      '<objects><item><key><Vector2><X>0</X><Y>0</Y></Vector2></key>'
          '<value><Object><name>Stone</name><tileLocation><X>0</X><Y>0</Y>'
          '</tileLocation></Object></value></item></objects>',
    );
    await File(mainPath).writeAsString(raw);

    final analysis = await const FarmTypeChangeService().analyze(
      saveFolderPath: saveDirectory.path,
      targetWhichFarm: 6,
    );

    expect(analysis.ok, isTrue);
    expect(analysis.contentMoves, 1);
    expect(analysis.contentMoveCounts, {FarmContentKind.keyedItem: 1});
    expect(analysis.toJson()['contentMoveCounts'], {'keyedItem': 1});
  });

  test('preserves and relocates outdoor furniture on Forest water', () async {
    final raw = FarmTypeChangeFixture.mainXml().replaceFirst(
      '<furniture />',
      '<furniture><Furniture><name>Standing Geode</name>'
          '<tileLocation><X>67</X><Y>43</Y></tileLocation>'
          '<boundingBox><X>4288</X><Y>2752</Y><Width>64</Width><Height>64</Height>'
          '<Location><X>4288</X><Y>2752</Y></Location></boundingBox>'
          '<defaultBoundingBox><X>4288</X><Y>2752</Y><Width>64</Width><Height>64</Height>'
          '<Location><X>4288</X><Y>2752</Y></Location></defaultBoundingBox>'
          '</Furniture></furniture>',
    );
    await File(mainPath).writeAsString(raw);

    final analysis = await const FarmTypeChangeService().analyze(
      saveFolderPath: saveDirectory.path,
      targetWhichFarm: 2,
    );
    expect(analysis.ok, isTrue);
    expect(analysis.contentMoveCounts[FarmContentKind.furniture], 1);

    final result = await const FarmTypeChangeService().execute(
      saveFolderPath: saveDirectory.path,
      targetWhichFarm: 2,
      backupsDir: backupsPath,
    );
    expect(result.ok, isTrue, reason: result.error?.name);

    final document = XmlDocument.parse(await File(mainPath).readAsString());
    final farm = document.rootElement
        .findElements('locations')
        .single
        .findElements('GameLocation')
        .single;
    final furniture = farm
        .findElements('furniture')
        .single
        .findElements('Furniture')
        .single;
    final tile = furniture.findElements('tileLocation').single;
    final destination = TilePoint(
      int.parse(tile.findElements('X').single.innerText),
      int.parse(tile.findElements('Y').single.innerText),
    );
    final forest = VanillaFarmSurfaceRepository.forWhichFarm(2)!;
    expect(forest.isWater(destination), isFalse);
    expect(forest.isBuildable(destination), isTrue);
  });

  test('rejects unknown farm content instead of deleting it', () async {
    final raw = FarmTypeChangeFixture.mainXml().replaceFirst(
      '<objects />',
      '<objects><item /></objects>',
    );
    await File(mainPath).writeAsString(raw);
    final analysis = await const FarmTypeChangeService().analyze(
      saveFolderPath: saveDirectory.path,
      targetWhichFarm: 6,
    );
    expect(analysis.ok, isFalse);
    expect(analysis.error, FarmTypeChangeError.unsupportedFarmContent);
    expect(await File(mainPath).readAsString(), raw);
  });
}
