import 'package:flutter_test/flutter_test.dart';
import 'package:valleysave/core/services/farm_placement_service.dart';

void main() {
  group('vanilla farm surfaces', () {
    test('loads all eight vanilla farm maps', () {
      for (var whichFarm = 0; whichFarm <= 7; whichFarm++) {
        expect(
          VanillaFarmSurfaceRepository.forWhichFarm(whichFarm),
          isNotNull,
          reason: 'missing whichFarm=$whichFarm',
        );
      }
      expect(VanillaFarmSurfaceRepository.forWhichFarm(999), isNull);
    });

    test('Riverland exposes bounds, water, fishing and walkability', () {
      final riverland = VanillaFarmSurfaceRepository.forWhichFarm(1)!;
      expect(riverland.name, 'Farm_Fishing');
      expect(riverland.width, 80);
      expect(riverland.height, 65);
      expect(riverland.contains(const TilePoint(79, 64)), isTrue);
      expect(riverland.contains(const TilePoint(80, 64)), isFalse);
      expect(riverland.isWater(const TilePoint(77, 45)), isTrue);
      expect(riverland.isFishingAllowed(const TilePoint(77, 45)), isTrue);
      expect(riverland.isBuildable(const TilePoint(77, 45)), isFalse);
      expect(riverland.isPassable(const TilePoint(73, 46)), isTrue);
    });
  });

  group('Safe Riverland host swap placement', () {
    final surface = VanillaFarmSurfaceRepository.forWhichFarm(1)!;
    const farmhouse = BuildingGeometry(
      origin: TilePoint(59, 12),
      width: 9,
      height: 5,
      doorOffset: TilePoint(5, 2),
      collisionRows: FarmPlacementService.farmhouseCollision,
      mailboxOffset: TilePoint(9, 4),
      doorApproachOffset: TilePoint(5, 5),
    );
    const cabin = BuildingGeometry(
      origin: TilePoint(68, 41),
      width: 5,
      height: 3,
      doorOffset: TilePoint(2, 1),
      collisionRows: FarmPlacementService.cabinCollision,
      doorApproachOffset: TilePoint(2, 3),
    );

    test('rejects current top-left swap because mailbox is water', () {
      expect(surface.isWater(const TilePoint(77, 45)), isTrue);
      expect(surface.isBuildable(const TilePoint(77, 45)), isFalse);
    });

    test('rejects exact door anchor and chooses closest safe placement', () {
      // Exact door anchor is (65,40), so Default_Mailbox would be (74,44).
      expect(surface.isWater(const TilePoint(74, 44)), isTrue);

      final expectedCabin = cabin.at(const TilePoint(62, 13));
      for (final tile in expectedCabin.collisionTiles()) {
        expect(surface.isBuildable(tile), isTrue, reason: 'cabin tile $tile');
      }
      expect(surface.isPassable(const TilePoint(70, 44)), isTrue);
      expect(surface.isBuildable(const TilePoint(72, 44)), isTrue);
      expect(surface.isPassable(const TilePoint(68, 45)), isTrue);
      expect(surface.isPassable(const TilePoint(72, 45)), isTrue);

      final placement = FarmPlacementService(surface).choose(
        farmhouse: farmhouse,
        cabin: cabin,
        otherBuildingTiles: const {},
      );

      expect(placement, isNotNull);
      expect(placement!.farmhouse.origin, const TilePoint(64, 40));
      expect(placement.farmhouse.absoluteDoor, const TilePoint(69, 42));
      expect(placement.mailbox, const TilePoint(73, 44));
      expect(placement.doorApproach, const TilePoint(69, 45));
      expect(surface.isBuildable(placement.mailbox), isTrue);
      expect(surface.isPassable(placement.mailboxApproach), isTrue);
      expect(placement.cabin.origin, const TilePoint(62, 13));
      expect(placement.cabin.absoluteDoor, const TilePoint(64, 14));
    });
  });

  group('Four Corners host swap placement', () {
    final surface = VanillaFarmSurfaceRepository.forWhichFarm(5)!;
    const farmhouse = BuildingGeometry(
      origin: TilePoint(59, 12),
      width: 9,
      height: 5,
      doorOffset: TilePoint(5, 2),
      collisionRows: FarmPlacementService.farmhouseCollision,
      mailboxOffset: TilePoint(9, 4),
      doorApproachOffset: TilePoint(5, 5),
    );
    const cabin = BuildingGeometry(
      origin: TilePoint(30, 44),
      width: 5,
      height: 3,
      doorOffset: TilePoint(2, 1),
      collisionRows: FarmPlacementService.cabinCollision,
      doorApproachOffset: TilePoint(2, 3),
    );

    test('rejects fixed fence and northern choke-point placements', () {
      final trapped = farmhouse.at(const TilePoint(32, 52));
      expect(trapped.walkableTiles().where(surface.isPassable), hasLength(6));
      expect(
        trapped.walkableTiles().where((tile) => !surface.isPassable(tile)),
        hasLength(4),
      );

      final placement = FarmPlacementService(surface).choose(
        farmhouse: farmhouse,
        cabin: cabin,
        otherBuildingTiles: const {},
      );

      expect(placement, isNotNull);
      expect(placement!.farmhouse.origin, isNot(const TilePoint(32, 52)));
      // (65,42) leaves the porch walkable but seals the two-tile passage
      // towards the east/north exit, adding a 48-tile detour.
      expect(placement.farmhouse.origin, isNot(const TilePoint(65, 42)));
      expect(placement.farmhouse.origin, const TilePoint(23, 43));
      expect(
        placement.farmhouse.walkableTiles().every(surface.isPassable),
        isTrue,
      );
    });
  });
}
