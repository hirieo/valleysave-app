import 'dart:io';

/// Fixture de un save coop sintético, estructuralmente real (mismos patrones
/// de XML observados en saves reales durante la investigación de F3: xsi:type
/// para elementos polimórficos, boundingBox en píxeles para Chest, etc.).
///
/// Huella proyectada al convertir a Bruno en anfitrión (Farmhouse 9x5 sobre
/// su cabaña en 23,31): X 23..31, Y 31..35. Dentro de esa huella hay
/// exactamente 3 objetos no ignorables (1 Chest + 2 Tree) y 1 Weeds
/// (ignorable) — mismo patrón validado en juego real durante A3/A4/B3/B4.
class CoopSaveFixture {
  static const hostUniqueId = '1111111111111111111';
  static const targetUniqueId = '2222222222222222222'; // Bruno
  static const emptyUniqueId = '3333333333333333333';
  static const hostName = 'Ana';
  static const targetName = 'Bruno';
  static const targetHome = 'FarmHouseBRUNOUUID';
  static const emptyHome = 'FarmHouseEMPTYUUID';
  static const originalFolderPrefix = 'TestCoop';
  static const originalId = '443121237';
  static String get originalFolderName => '${originalFolderPrefix}_$originalId';

  /// Materializa `Saves/<carpeta>/<archivo principal>` + `SaveGameInfo` +
  /// dos archivos `*_old` sobrantes (simulan los que crea el propio juego al
  /// jugar la copia — deben desaparecer en la carpeta NUEVA tras `execute`,
  /// contrato G4) dentro de [tempDir]. NO modifica nada fuera de [tempDir].
  static Future<({String saveFolderPath, String savesDir})> create(
    Directory tempDir,
  ) async {
    final sep = Platform.pathSeparator;
    final savesDir = Directory('${tempDir.path}${sep}Saves');
    await savesDir.create(recursive: true);
    final folder = Directory('${savesDir.path}$sep$originalFolderName');
    await folder.create(recursive: true);

    await File(
      '${folder.path}$sep$originalFolderName',
    ).writeAsString(mainXml());
    await File('${folder.path}${sep}SaveGameInfo').writeAsString(infoXml());
    await File(
      '${folder.path}$sep${originalFolderName}_old',
    ).writeAsString('stale');
    await File('${folder.path}${sep}SaveGameInfo_old').writeAsString('stale');

    return (saveFolderPath: folder.path, savesDir: savesDir.path);
  }

  /// Variante sin colisiones (huella libre) — usada para el caso N=0.
  static String mainXmlNoCollisions() => _mainXml(withCollisions: false);

  /// Variante donde no cabe ningún hueco de reubicación (para `noFreeTile`):
  /// rodea la huella y sus radios de búsqueda de edificios.
  static String mainXmlSaturated() => _mainXml(saturated: true);

  static String mainXml() => _mainXml();

  static String _mainXml({bool withCollisions = true, bool saturated = false}) {
    final farm = _farmLocation(
      withCollisions: withCollisions,
      saturated: saturated,
    );
    return '''<?xml version="1.0" encoding="utf-8"?>
<SaveGame xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">
  <uniqueIDForThisGame>$originalId</uniqueIDForThisGame>
  <currentSeason>spring</currentSeason>
  <dayOfMonth>5</dayOfMonth>
  <year>1</year>
  <gameVersion>1.6.15</gameVersion>
  <player>
    <name>$hostName</name>
    <UniqueMultiplayerID>$hostUniqueId</UniqueMultiplayerID>
    <slotCanHost>true</slotCanHost>
    <homeLocation>FarmHouse</homeLocation>
    <houseUpgradeLevel>0</houseUpgradeLevel>
    <daysUntilHouseUpgrade>2</daysUntilHouseUpgrade>
    <useSeparateWallets>false</useSeparateWallets>
    <Gender>Male</Gender>
    <money>5000</money>
    <totalMoneyEarned>5000</totalMoneyEarned>
    <millisecondsPlayed>100000</millisecondsPlayed>
    <farmingLevel>0</farmingLevel><miningLevel>0</miningLevel>
    <combatLevel>0</combatLevel><foragingLevel>0</foragingLevel>
    <fishingLevel>0</fishingLevel><deepestMineLevel>0</deepestMineLevel>
    <health>100</health><stamina>270</stamina>
  </player>
  <farmhands>
    <Farmer>
      <name>$targetName</name>
      <UniqueMultiplayerID>$targetUniqueId</UniqueMultiplayerID>
      <slotCanHost>false</slotCanHost>
      <homeLocation>$targetHome</homeLocation>
      <houseUpgradeLevel>0</houseUpgradeLevel>
      <daysUntilHouseUpgrade>2</daysUntilHouseUpgrade>
      <Gender>Male</Gender>
      <money>3000</money>
      <totalMoneyEarned>3000</totalMoneyEarned>
      <millisecondsPlayed>50000</millisecondsPlayed>
      <farmingLevel>0</farmingLevel><miningLevel>0</miningLevel>
      <combatLevel>0</combatLevel><foragingLevel>0</foragingLevel>
      <fishingLevel>0</fishingLevel><deepestMineLevel>0</deepestMineLevel>
      <health>100</health><stamina>270</stamina>
    </Farmer>
    <Farmer>
      <name></name>
      <UniqueMultiplayerID>$emptyUniqueId</UniqueMultiplayerID>
      <slotCanHost>false</slotCanHost>
      <homeLocation>$emptyHome</homeLocation>
      <houseUpgradeLevel>0</houseUpgradeLevel>
      <daysUntilHouseUpgrade>-1</daysUntilHouseUpgrade>
    </Farmer>
  </farmhands>
  <locations>
    $farm
    <GameLocation>
      <name>FarmHouse</name>
      <isStructure>false</isStructure>
      <furniture>
        <Furniture><name>Bed</name><bedType>Double</bedType></Furniture>
      </furniture>
      <objects/><terrainFeatures/><buildings/><animals/><characters/>
      <resourceClumps/><largeTerrainFeatures/>
      <fridge/><wallPaper/><appliedWallpaper/><floor/><appliedFloor/>
      <piecesOfHay>0</piecesOfHay><numberOfSpawnedObjectsOnMap>0</numberOfSpawnedObjectsOnMap>
      <miniJukeboxCount>0</miniJukeboxCount><miniJukeboxTrack/>
      <Animals/><IsGreenhouse>false</IsGreenhouse>
      <fridgePosition><X>0</X><Y>0</Y></fridgePosition><cribStyle>0</cribStyle>
    </GameLocation>
  </locations>
</SaveGame>''';
  }

  static String _farmLocation({
    required bool withCollisions,
    required bool saturated,
  }) {
    final buildings = saturated ? _saturatedBuildings() : _normalBuildings();
    final objects = withCollisions ? _collidingObjects() : _freeObjects();
    final terrain = withCollisions
        ? _collidingTerrainFeatures()
        : _freeTerrainFeatures();
    return '''
    <GameLocation>
      <name>Farm</name>
      <buildings>
        $buildings
      </buildings>
      <objects>
        $objects
      </objects>
      <terrainFeatures>
        $terrain
      </terrainFeatures>
      <largeTerrainFeatures/>
      <resourceClumps/>
    </GameLocation>''';
  }

  static String _normalBuildings() =>
      '''
        <Building>
          <buildingType>Farmhouse</buildingType>
          <tileX>59</tileX><tileY>12</tileY>
          <tilesWide>9</tilesWide><tilesHigh>5</tilesHigh>
          <humanDoor><X>5</X><Y>2</Y></humanDoor>
          <nonInstancedIndoorsName><string>FarmHouse</string></nonInstancedIndoorsName>
        </Building>
        <Building>
          <buildingType>Cabin</buildingType>
          <skinId><string>Log Cabin</string></skinId>
          <tileX>23</tileX><tileY>31</tileY>
          <tilesWide>5</tilesWide><tilesHigh>3</tilesHigh>
          <humanDoor><X>2</X><Y>1</Y></humanDoor>
          <indoors xsi:type="Cabin">
            <uniqueName>$targetHome</uniqueName>
            <name>Cabin</name>
            <isStructure>true</isStructure>
            <farmhandReference>$targetUniqueId</farmhandReference>
            <furniture>
              <Furniture><name>Bed</name><bedType>Single</bedType></Furniture>
            </furniture>
            <objects/><terrainFeatures/><buildings/><animals/><characters/>
            <resourceClumps/><largeTerrainFeatures/>
            <fridge/><wallPaper/><appliedWallpaper/><floor/><appliedFloor/>
            <piecesOfHay>0</piecesOfHay><numberOfSpawnedObjectsOnMap>0</numberOfSpawnedObjectsOnMap>
            <miniJukeboxCount>0</miniJukeboxCount><miniJukeboxTrack/>
            <Animals/><IsGreenhouse>false</IsGreenhouse>
            <fridgePosition><X>0</X><Y>0</Y></fridgePosition><cribStyle>0</cribStyle>
          </indoors>
        </Building>
        <Building>
          <buildingType>Cabin</buildingType>
          <skinId><string>Stone Cabin</string></skinId>
          <tileX>66</tileX><tileY>37</tileY>
          <tilesWide>5</tilesWide><tilesHigh>3</tilesHigh>
          <humanDoor><X>2</X><Y>1</Y></humanDoor>
          <indoors xsi:type="Cabin">
            <uniqueName>$emptyHome</uniqueName>
            <name>Cabin</name>
            <isStructure>true</isStructure>
            <farmhandReference>$emptyUniqueId</farmhandReference>
          </indoors>
        </Building>''';

  /// Cubre TODO el área alcanzable por los radios de búsqueda (cerca=6,
  /// lejos=20) alrededor de la huella nueva (23..31, 31..35) con edificios
  /// 1x1 sin huecos, para forzar `noFreeTile` en `analyze`/`execute`. El
  /// radio lejano se mide desde una posible víctima desalojada (hasta 6
  /// tiles de un objeto de la huella), así que el área cubierta es generosa:
  /// X -5..57, Y 0..61.
  static String _saturatedBuildings() {
    final buf = StringBuffer(_normalBuildings());
    for (var bx = -5; bx <= 57; bx++) {
      for (var by = 0; by <= 61; by++) {
        buf.write('''
        <Building>
          <buildingType>Shed</buildingType>
          <tileX>$bx</tileX><tileY>$by</tileY>
          <tilesWide>1</tilesWide><tilesHigh>1</tilesHigh>
          <humanDoor><X>0</X><Y>0</Y></humanDoor>
        </Building>''');
      }
    }
    return buf.toString();
  }

  static String _collidingObjects() => '''
        <item>
          <key><Vector2><X>24</X><Y>34</Y></Vector2></key>
          <value>
            <Object xsi:type="Chest">
              <name>Chest</name>
              <tileLocation><X>24</X><Y>34</Y></tileLocation>
              <boundingBox><X>1536</X><Y>2176</Y><Width>64</Width><Height>64</Height>
                <Location><X>1536</X><Y>2176</Y></Location></boundingBox>
              <items/>
            </Object>
          </value>
        </item>
        <item>
          <key><Vector2><X>29</X><Y>31</Y></Vector2></key>
          <value>
            <Object xsi:type="Weeds">
              <name>Weeds</name>
              <tileLocation><X>29</X><Y>31</Y></tileLocation>
            </Object>
          </value>
        </item>
        <item>
          <key><Vector2><X>10</X><Y>10</Y></Vector2></key>
          <value>
            <Object xsi:type="Chest">
              <name>Chest</name>
              <tileLocation><X>10</X><Y>10</Y></tileLocation>
              <boundingBox><X>640</X><Y>640</Y><Width>64</Width><Height>64</Height>
                <Location><X>640</X><Y>640</Y></Location></boundingBox>
              <items/>
            </Object>
          </value>
        </item>''';

  static String _freeObjects() => '''
        <item>
          <key><Vector2><X>10</X><Y>10</Y></Vector2></key>
          <value>
            <Object xsi:type="Chest">
              <name>Chest</name>
              <tileLocation><X>10</X><Y>10</Y></tileLocation>
              <boundingBox><X>640</X><Y>640</Y><Width>64</Width><Height>64</Height>
                <Location><X>640</X><Y>640</Y></Location></boundingBox>
              <items/>
            </Object>
          </value>
        </item>''';

  static String _collidingTerrainFeatures() => '''
        <item>
          <key><Vector2><X>29</X><Y>33</Y></Vector2></key>
          <value>
            <TerrainFeature xsi:type="Tree">
              <treeType>1</treeType><growthStage>7</growthStage>
              <tileLocation><X>29</X><Y>33</Y></tileLocation>
            </TerrainFeature>
          </value>
        </item>
        <item>
          <key><Vector2><X>31</X><Y>32</Y></Vector2></key>
          <value>
            <TerrainFeature xsi:type="Tree">
              <treeType>1</treeType><growthStage>0</growthStage>
              <tileLocation><X>31</X><Y>32</Y></tileLocation>
            </TerrainFeature>
          </value>
        </item>
        <item>
          <key><Vector2><X>5</X><Y>5</Y></Vector2></key>
          <value>
            <TerrainFeature xsi:type="Tree">
              <treeType>2</treeType><growthStage>7</growthStage>
              <tileLocation><X>5</X><Y>5</Y></tileLocation>
            </TerrainFeature>
          </value>
        </item>''';

  static String _freeTerrainFeatures() => '''
        <item>
          <key><Vector2><X>5</X><Y>5</Y></Vector2></key>
          <value>
            <TerrainFeature xsi:type="Tree">
              <treeType>2</treeType><growthStage>7</growthStage>
              <tileLocation><X>5</X><Y>5</Y></tileLocation>
            </TerrainFeature>
          </value>
        </item>''';

  static String infoXml() =>
      '''<?xml version="1.0" encoding="utf-8"?>
<$hostName>
  <name>$hostName</name>
  <farmName>Granja Test</farmName>
  <slotCanHost>true</slotCanHost>
  <useSeparateWallets>false</useSeparateWallets>
  <seasonForSaveGame>0</seasonForSaveGame>
  <dayOfMonthForSaveGame>5</dayOfMonthForSaveGame>
  <yearForSaveGame>1</yearForSaveGame>
  <gameVersion>1.6.15</gameVersion>
  <money>5000</money>
  <UniqueMultiplayerID>$hostUniqueId</UniqueMultiplayerID>
</$hostName>''';
}
