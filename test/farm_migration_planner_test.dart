import 'package:flutter_test/flutter_test.dart';
import 'package:valleysave/core/services/farm_content_relocation.dart';
import 'package:valleysave/core/services/farm_migration_planner.dart';
import 'package:valleysave/core/services/farm_placement_service.dart';
import 'package:xml/xml.dart';

import 'fixtures/farm_type_change_fixture.dart';

void main() {
  group('FarmMigrationPlanner', () {
    test('detects that Riverland coordinates are unsafe on Beach', () {
      final beach = VanillaFarmSurfaceRepository.forWhichFarm(6)!;
      final unsafe = FarmTypeChangeFixture.buildings.where(
        (building) => !building.everyTile.every(beach.isBuildable),
      );
      expect(unsafe, isNotEmpty);
      expect(unsafe.map((building) => building.id), contains('coop'));
      expect(unsafe.map((building) => building.id), contains('silo'));
    });

    test('moves unsafe buildings and preserves every building', () {
      final beach = VanillaFarmSurfaceRepository.forWhichFarm(6)!;
      final plan = FarmMigrationPlanner(
        beach,
      ).plan(FarmTypeChangeFixture.buildings);

      expect(plan, isNotNull);
      expect(
        plan!.placements.keys.toSet(),
        FarmTypeChangeFixture.buildings.map((building) => building.id).toSet(),
      );
      expect(plan.moves.map((move) => move.building.id), contains('coop'));
      expect(plan.moves.map((move) => move.building.id), contains('silo'));
      expect(
        FarmMigrationPlanner(
          beach,
        ).validate(FarmTypeChangeFixture.buildings, plan.placements),
        isTrue,
      );
    });

    test('returns the same deterministic plan for identical input', () {
      final beach = VanillaFarmSurfaceRepository.forWhichFarm(6)!;
      final planner = FarmMigrationPlanner(beach);
      final first = planner.plan(FarmTypeChangeFixture.buildings);
      final second = planner.plan(FarmTypeChangeFixture.buildings);
      expect(first?.placements, second?.placements);
    });

    test('reserves the full route to the Beach north exit', () {
      final beach = VanillaFarmSurfaceRepository.forWhichFarm(6)!;
      final planner = FarmMigrationPlanner(beach);
      final plan = planner.plan(FarmTypeChangeFixture.buildings)!;
      final corridors = planner.navigationCorridors(
        FarmTypeChangeFixture.buildings,
        plan.placements,
      )!;

      expect(corridors, contains(const TilePoint(40, 0)));
      expect(
        corridors.any(
          {
            const TilePoint(40, 12),
            const TilePoint(40, 13),
            const TilePoint(41, 13),
            const TilePoint(42, 13),
            const TilePoint(40, 14),
            const TilePoint(41, 14),
            const TilePoint(42, 14),
          }.contains,
        ),
        isTrue,
      );
    });
  });

  group('FarmContentRelocator', () {
    test('moves keyed items and resource clumps without deleting them', () {
      final beach = VanillaFarmSurfaceRepository.forWhichFarm(6)!;
      final farm = XmlDocument.parse('''
<Farm xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">
  <objects><item><key><Vector2><X>0</X><Y>0</Y></Vector2></key><value><Object><name>Stone</name><tileLocation><X>0</X><Y>0</Y></tileLocation><boundingBox><X>0</X><Y>0</Y><Location><X>0</X><Y>0</Y></Location></boundingBox></Object></value></item></objects>
  <terrainFeatures><item><key><Vector2><X>1</X><Y>0</Y></Vector2></key><value><TerrainFeature xsi:type="HoeDirt"><Tile><X>1</X><Y>0</Y></Tile><crop /></TerrainFeature></value></item></terrainFeatures>
  <resourceClumps><ResourceClump><width>2</width><height>2</height><tile><X>2</X><Y>0</Y></tile></ResourceClump></resourceClumps>
  <largeTerrainFeatures />
</Farm>
''').rootElement;
      final beforeCounts = {
        'objects': farm.findElements('objects').first.childElements.length,
        'terrain': farm
            .findElements('terrainFeatures')
            .first
            .childElements
            .length,
        'clumps': farm
            .findElements('resourceClumps')
            .first
            .childElements
            .length,
      };

      final relocator = FarmContentRelocator(beach);
      final plan = relocator.plan(farm: farm, reserved: const {});
      expect(plan.isSafe, isTrue);
      expect(plan.moves, hasLength(3));
      relocator.apply(plan);

      expect(
        farm.findElements('objects').first.childElements.length,
        beforeCounts['objects'],
      );
      expect(
        farm.findElements('terrainFeatures').first.childElements.length,
        beforeCounts['terrain'],
      );
      expect(
        farm.findElements('resourceClumps').first.childElements.length,
        beforeCounts['clumps'],
      );
      for (final move in plan.moves) {
        for (var y = 0; y < move.height; y++) {
          for (var x = 0; x < move.width; x++) {
            expect(beach.isBuildable(move.to + TilePoint(x, y)), isTrue);
          }
        }
      }
    });

    test('reports an unsupported node instead of dropping it', () {
      final farm = XmlDocument.parse(
        '<Farm><objects><item /></objects></Farm>',
      ).rootElement;
      final plan = FarmContentRelocator(
        VanillaFarmSurfaceRepository.forWhichFarm(6)!,
      ).plan(farm: farm, reserved: const {});
      expect(plan.isSafe, isFalse);
      expect(plan.unsupportedNodes, contains('objects[0]'));
    });

    test('moves Beach bushes away from the protected north corridor', () {
      final beach = VanillaFarmSurfaceRepository.forWhichFarm(6)!;
      final planner = FarmMigrationPlanner(beach);
      final buildings = FarmTypeChangeFixture.buildings;
      final buildingPlan = planner.plan(buildings)!;
      final corridors = planner.navigationCorridors(
        buildings,
        buildingPlan.placements,
      )!;
      final farm = XmlDocument.parse('''
<Farm xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">
  <largeTerrainFeatures>
    <LargeTerrainFeature xsi:type="Bush"><tilePosition><X>40</X><Y>12</Y></tilePosition><size>0</size></LargeTerrainFeature>
    <LargeTerrainFeature xsi:type="Bush"><tilePosition><X>40</X><Y>13</Y></tilePosition><size>2</size></LargeTerrainFeature>
  </largeTerrainFeatures>
</Farm>
''').rootElement;

      final relocation = FarmContentRelocator(
        beach,
      ).plan(farm: farm, reserved: corridors);

      expect(relocation.isSafe, isTrue);
      expect(relocation.moves, hasLength(2));
      for (final move in relocation.moves) {
        final footprint = {
          for (var y = 0; y < move.height; y++)
            for (var x = 0; x < move.width; x++) move.to + TilePoint(x, y),
        };
        expect(footprint.intersection(corridors), isEmpty);
      }
      expect(relocation.moves.last.width, 3);
      expect(relocation.moves.last.height, 2);
    });

    test('clears Meadowlands Warp Totem arrival from persisted bushes', () {
      final meadowlands = VanillaFarmSurfaceRepository.forWhichFarm(7)!;
      const arrival = TilePoint(71, 6);
      expect(meadowlands.anchors, contains(arrival));
      final farm = XmlDocument.parse('''
<Farm xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">
  <largeTerrainFeatures>
    <LargeTerrainFeature xsi:type="Bush"><tilePosition><X>71</X><Y>7</Y></tilePosition><size>0</size></LargeTerrainFeature>
    <LargeTerrainFeature xsi:type="Bush"><tilePosition><X>71</X><Y>8</Y></tilePosition><size>0</size></LargeTerrainFeature>
  </largeTerrainFeatures>
</Farm>
''').rootElement;

      final relocator = FarmContentRelocator(meadowlands);
      final plan = relocator.plan(farm: farm, reserved: const {});

      expect(plan.isSafe, isTrue);
      expect(plan.moves, hasLength(2));
      for (final move in plan.moves) {
        expect(move.from.x, 71);
        expect(move.to.manhattanTo(arrival), greaterThan(2));
      }
    });

    test('moves outdoor furniture off Forest water with its pixel boxes', () {
      final forest = VanillaFarmSurfaceRepository.forWhichFarm(2)!;
      const origin = TilePoint(67, 43);
      expect(forest.isWater(origin), isTrue);
      final farm = XmlDocument.parse('''
<Farm>
  <furniture>
    <Furniture>
      <name>Standing Geode</name>
      <tileLocation><X>67</X><Y>43</Y></tileLocation>
      <boundingBox><X>4288</X><Y>2752</Y><Width>64</Width><Height>64</Height><Location><X>4288</X><Y>2752</Y></Location></boundingBox>
      <defaultBoundingBox><X>4288</X><Y>2752</Y><Width>64</Width><Height>64</Height><Location><X>4288</X><Y>2752</Y></Location></defaultBoundingBox>
    </Furniture>
  </furniture>
</Farm>
''').rootElement;

      final relocator = FarmContentRelocator(forest);
      final plan = relocator.plan(farm: farm, reserved: const {});

      expect(plan.isSafe, isTrue);
      expect(plan.moves, hasLength(1));
      final move = plan.moves.single;
      expect(move.kind, FarmContentKind.furniture);
      expect(move.from, origin);
      expect(forest.isWater(move.to), isFalse);
      expect(forest.isBuildable(move.to), isTrue);

      relocator.apply(plan);
      final furniture = farm
          .findElements('furniture')
          .first
          .findElements('Furniture')
          .single;
      final tile = furniture.findElements('tileLocation').single;
      expect(tile.findElements('X').single.innerText, '${move.to.x}');
      expect(tile.findElements('Y').single.innerText, '${move.to.y}');
      for (final name in ['boundingBox', 'defaultBoundingBox']) {
        final box = furniture.findElements(name).single;
        expect(box.findElements('X').single.innerText, '${move.to.x * 64}');
        expect(box.findElements('Y').single.innerText, '${move.to.y * 64}');
        final location = box.findElements('Location').single;
        expect(
          location.findElements('X').single.innerText,
          '${move.to.x * 64}',
        );
        expect(
          location.findElements('Y').single.innerText,
          '${move.to.y * 64}',
        );
      }
    });
  });
}
