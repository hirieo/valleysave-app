import 'package:valleysave/core/services/farm_migration_planner.dart';
import 'package:valleysave/core/services/farm_placement_service.dart';

class FarmTypeChangeFixture {
  static const folderName = 'Migration_100';

  static const buildings = <MigrationBuilding>[
    MigrationBuilding(
      id: 'farmhouse',
      type: 'Farmhouse',
      origin: TilePoint(59, 12),
      width: 9,
      height: 5,
      doorOffset: TilePoint(5, 2),
      mailboxOffset: TilePoint(9, 4),
    ),
    MigrationBuilding(
      id: 'greenhouse',
      type: 'Greenhouse',
      origin: TilePoint(25, 10),
      width: 7,
      height: 6,
      doorOffset: TilePoint(3, 5),
    ),
    MigrationBuilding(
      id: 'shipping',
      type: 'Shipping Bin',
      origin: TilePoint(71, 14),
      width: 2,
      height: 1,
    ),
    MigrationBuilding(
      id: 'coop',
      type: 'Coop',
      origin: TilePoint(33, 15),
      width: 6,
      height: 3,
      doorOffset: TilePoint(1, 2),
    ),
    MigrationBuilding(
      id: 'silo',
      type: 'Silo',
      origin: TilePoint(39, 15),
      width: 3,
      height: 3,
    ),
    MigrationBuilding(
      id: 'cabin',
      type: 'Cabin',
      origin: TilePoint(67, 41),
      width: 5,
      height: 3,
      doorOffset: TilePoint(2, 1),
    ),
  ];

  static String mainXml() =>
      '''
<SaveGame xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">
  <whichFarm>1</whichFarm>
  <uniqueIDForThisGame>100</uniqueIDForThisGame>
  <player><name>Host</name><UniqueMultiplayerID>10</UniqueMultiplayerID></player>
  <locations>
    <GameLocation xsi:type="Farm">
      <name>Farm</name>
      <buildings>
        ${_building('farmhouse', 'Farmhouse', 59, 12, 9, 5, 5, 2)}
        ${_building('greenhouse', 'Greenhouse', 25, 10, 7, 6, 3, 5)}
        ${_building('shipping', 'Shipping Bin', 71, 14, 2, 1, -1, -1)}
        ${_building('coop', 'Coop', 33, 15, 6, 3, 1, 2)}
        ${_building('silo', 'Silo', 39, 15, 3, 3, -1, -1)}
        ${_building('cabin', 'Cabin', 67, 41, 5, 3, 2, 1)}
      </buildings>
      <objects />
      <terrainFeatures />
      <resourceClumps />
      <largeTerrainFeatures />
      <furniture />
    </GameLocation>
  </locations>
</SaveGame>
''';

  static String saveInfoXml() => '''
<Host><name>Host</name><slotCanHost>true</slotCanHost></Host>
''';

  static String _building(
    String id,
    String type,
    int x,
    int y,
    int width,
    int height,
    int doorX,
    int doorY,
  ) =>
      '''<Building><buildingId><Guid>$id</Guid></buildingId><buildingType>$type</buildingType><tileX>$x</tileX><tileY>$y</tileY><tilesWide>$width</tilesWide><tilesHigh>$height</tilesHigh><humanDoor><X>$doorX</X><Y>$doorY</Y></humanDoor></Building>''';
}
