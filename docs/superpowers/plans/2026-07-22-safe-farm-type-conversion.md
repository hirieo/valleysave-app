# Safe Farm Type Conversion Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Convertir una partida entre los ocho mapas vanilla sin dejar edificios, accesos ni contenido de granja sobre agua, acantilados, salidas o entre sí, con análisis previo, respaldo verificado y rollback.

**Architecture:** Un planificador puro trabajará sobre las máscaras reales de los mapas ya incluidas en `VanillaFarmSurfaceRepository`. Un servicio XML aplicará el plan solo sobre una copia de staging y publicará el resultado mediante `SaveReplaceService`. La futura interfaz llamará al mismo servicio, pero queda fuera de esta entrega para no mezclar seguridad de datos con UI.

> **Nota de ejecución (2026-07-22):** no se conserva un CLI dentro del paquete. En Flutter 3.44/Dart 3.12, `dart run` activa los build hooks de las dependencias nativas de la aplicación y el compilador VM falla antes de ejecutar el comando. El servicio quedó validado con `flutter test`, incluida una ejecución manual temporal sobre una copia real; no se deja una herramienta que no funcione de forma fiable.

**Tech Stack:** Dart 3, Flutter, `xml`, máscaras vanilla generadas desde XNB/TBin, `BackupService`, `SaveReplaceService`, `flutter_test`.

---

## Incidente reproducido (22-07-2026)

Cambiar únicamente `<whichFarm>1</whichFarm>` por `6` sustituyó el mapa Riverland por Playa, pero dejó el contenido persistente del mapa anterior. La comparación de los dos respaldos confirmó:

- Original Riverland: 7 edificios, 131 objetos y 333 terrain features.
- Playa rota después de cargar/operar: 8 edificios, 132 objetos y 342 terrain features.
- Coop conservado en `(33,15)` y Silo en `(39,15)`, encima de terreno estático de Playa.
- Greenhouse conservado en `(25,10)` y Cabin en una coordenada procedente del flujo anterior.
- Stardew no migra de forma general los edificios construidos por el usuario al cambiar `whichFarm`, porque esa operación no existe en el juego.

Por tanto, queda prohibido implementar o usar una sustitución directa de `whichFarm`. Toda conversión debe demostrar primero que el estado completo cabe en el mapa destino.

## Invariantes de seguridad

1. `analyze` es estrictamente de solo lectura.
2. Ningún archivo vivo se toca antes de disponer de un plan completo y válido.
3. Todo edificio conserva su XML, ID, interior, animales y mejoras; solo puede cambiar `tileX/tileY`.
4. Ningún edificio puede solaparse con terreno no edificable, otro edificio, una salida del mapa o un corredor reservado.
5. Toda puerta humana debe tener una casilla exterior transitable y ruta a una salida del mapa.
6. Farmhouse exige además buzón accesible y corredor frontal, igual que el host swap.
7. Ningún objeto se elimina silenciosamente. Los elementos soportados se recolocan; un formato no soportado que quede inválido aborta la conversión.
8. El número y los IDs de edificios, animales, objetos, terrain features, resource clumps y large terrain features son idénticos antes y después.
9. El cambio se publica con `SaveReplaceService`, respaldo verificado, validación post-publicación y rollback.
10. El usuario recibe antes de confirmar una lista exacta de edificios y elementos que se moverán.

## Estructura de archivos

- Create: `lib/core/services/farm_migration_planner.dart` — modelos geométricos y planificador puro.
- Create: `lib/core/services/farm_type_change_service.dart` — análisis XML, staging, aplicación y validación.
- Create: `tool/change_farm_type.dart` — comando de desarrollo seguro; análisis por defecto, escritura solo con `--apply`.
- Create: `test/farm_migration_planner_test.dart` — geometría, conectividad y caso Riverland→Playa.
- Create: `test/farm_type_change_service_test.dart` — contrato de solo lectura, respaldo, rollback e integridad XML.
- Create: `test/fixtures/farm_type_change_fixture.dart` — fixture mínimo basado en las coordenadas del incidente, sin datos personales.
- Modify: `lib/core/services/farm_placement_service.dart` — exponer primitivas reutilizables de alcance package para BFS, ajuste y corredores.
- Modify: `test/farm_placement_service_test.dart` — cubrir las primitivas extraídas y evitar regresiones del host swap.
- Modify: `tool/generate_farm_surfaces.ps1` — generar también una zona protegida alrededor de cada warp.
- Modify: `lib/core/data/vanilla_farm_surfaces_data.dart` — regenerado, nunca editado manualmente.

### Task 1: Reproducir el fallo con una fixture anónima

**Files:**
- Create: `test/fixtures/farm_type_change_fixture.dart`
- Create: `test/farm_migration_planner_test.dart`

- [ ] **Step 1: Crear la fixture Riverland del incidente**

Definir una fixture con `whichFarm=1` y estos edificios: Farmhouse `(59,12,9×5)`, Greenhouse `(25,10,7×6)`, Shipping Bin `(71,14,2×1)`, Coop `(33,15,6×3)`, Silo `(39,15,3×3)` y Cabin `(67,41,5×3)`. Cada edificio debe tener un ID fijo y, cuando corresponda, `humanDoor`.

```dart
class FarmTypeChangeFixture {
  static const folderName = 'Migration_100';

  static String mainXml() => '''
<SaveGame xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">
  <whichFarm>1</whichFarm>
  <uniqueIDForThisGame>100</uniqueIDForThisGame>
  <player><name>Host</name><UniqueMultiplayerID>10</UniqueMultiplayerID></player>
  <locations><GameLocation xsi:type="Farm"><name>Farm</name><buildings>
    ${building('farmhouse', 'Farmhouse', 59, 12, 9, 5, doorX: 5, doorY: 2)}
    ${building('greenhouse', 'Greenhouse', 25, 10, 7, 6, doorX: 3, doorY: 5)}
    ${building('shipping', 'Shipping Bin', 71, 14, 2, 1)}
    ${building('coop', 'Coop', 33, 15, 6, 3, doorX: 1, doorY: 2)}
    ${building('silo', 'Silo', 39, 15, 3, 3)}
    ${building('cabin', 'Cabin', 67, 41, 5, 3, doorX: 2, doorY: 1)}
  </buildings><objects/><terrainFeatures/><resourceClumps/><largeTerrainFeatures/></GameLocation></locations>
</SaveGame>''';
}
```

- [ ] **Step 2: Escribir el test que demuestra que cambiar solo `whichFarm` es inválido**

```dart
test('Riverland coordinates are not a valid Beach layout', () {
  final beach = VanillaFarmSurfaceRepository.forWhichFarm(6)!;
  final fixture = FarmTypeChangeFixture.buildings;
  expect(
    fixture.where((building) => !building.everyTile.every(beach.isBuildable)),
    isNotEmpty,
  );
});
```

- [ ] **Step 3: Ejecutar el test y comprobar el fallo inicial**

Run: `flutter test test/farm_migration_planner_test.dart`

Expected: FAIL porque todavía no existen los modelos `MigrationBuilding` ni `everyTile`.

- [ ] **Step 4: Commit de la reproducción**

```bash
git add test/fixtures/farm_type_change_fixture.dart test/farm_migration_planner_test.dart
git commit -m "test: reproduce unsafe farm type conversion"
```

### Task 2: Añadir zonas protegidas a las superficies vanilla

**Files:**
- Modify: `tool/generate_farm_surfaces.ps1`
- Modify: `lib/core/data/vanilla_farm_surfaces_data.dart`
- Modify: `lib/core/services/farm_placement_service.dart`
- Modify: `test/farm_placement_service_test.dart`

- [ ] **Step 1: Escribir tests para las zonas protegidas de warps**

```dart
test('Beach protects every warp and its two-tile approach', () {
  final beach = VanillaFarmSurfaceRepository.forWhichFarm(6)!;
  expect(beach.anchors, isNotEmpty);
  for (final anchor in beach.anchors) {
    expect(beach.isProtected(anchor), isTrue);
  }
});
```

- [ ] **Step 2: Cargar los XNB directamente y generar el bitset `protected`**

Eliminar el parámetro `TbinDirectory`: el generador debe cargar `Content/Maps/<nombre>.xnb` con el `ContentManager` de MonoGame, igual que Stardew, para que regenerar los datos no dependa de una carpeta externa manual. Inicializarlo así:

```powershell
$monoGame = [Reflection.Assembly]::LoadFrom((Join-Path $GamePath 'MonoGame.Framework.dll'))
$xTile = [Reflection.Assembly]::LoadFrom((Join-Path $GamePath 'xTile.dll'))
$contentType = $monoGame.GetType('Microsoft.Xna.Framework.Content.ContentManager')
$services = [System.ComponentModel.Design.ServiceContainer]::new()
$content = $contentType.GetConstructor(@([IServiceProvider])).Invoke([object[]]@($services))
$content.RootDirectory = Join-Path $GamePath 'Content'
$mapType = $xTile.GetType('xTile.Map')
$load = $contentType.GetMethods() |
  Where-Object { $_.Name -eq 'Load' -and $_.IsGenericMethodDefinition } |
  Select-Object -First 1
$loadMap = $load.MakeGenericMethod($mapType)
```

Dentro del bucle usar `$map = $loadMap.Invoke($content, [object[]]@("Maps/$name"))`. Después de `Get-WarpAnchors`, marcar cada warp y todas las casillas transitables a distancia Manhattan `<= 2`. Añadir el Base64 como clave `protected`.

```powershell
$protected = [byte[]]::new($byteCount)
foreach ($anchorIndex in $anchors) {
  $ax = $anchorIndex % $width
  $ay = [math]::Floor($anchorIndex / $width)
  for ($dy = -2; $dy -le 2; $dy++) {
    for ($dx = -2; $dx -le 2; $dx++) {
      if ([math]::Abs($dx) + [math]::Abs($dy) -gt 2) { continue }
      $px = $ax + $dx; $py = $ay + $dy
      if ($px -ge 0 -and $px -lt $width -and $py -ge 0 -and $py -lt $height) {
        Set-Bit $protected ($py * $width + $px)
      }
    }
  }
}
```

- [ ] **Step 3: Exponer `FarmSurface.isProtected`**

Añadir `_protected`, validarlo en `fromData` y exponer:

```dart
bool isProtected(TilePoint tile) => _read(_protected, tile);
```

- [ ] **Step 4: Regenerar y ejecutar tests**

Run: `pwsh -File tool/generate_farm_surfaces.ps1 -GamePath "C:\Program Files (x86)\Steam\steamapps\common\Stardew Valley" -OutputPath lib/core/data/vanilla_farm_surfaces_data.dart`

Expected: ocho entradas con `protected`; `flutter test test/farm_placement_service_test.dart` pasa.

- [ ] **Step 5: Commit**

```bash
git add tool/generate_farm_surfaces.ps1 lib/core/data/vanilla_farm_surfaces_data.dart lib/core/services/farm_placement_service.dart test/farm_placement_service_test.dart
git commit -m "feat: protect vanilla farm exits during placement"
```

### Task 3: Implementar el planificador puro de edificios

**Files:**
- Create: `lib/core/services/farm_migration_planner.dart`
- Modify: `lib/core/services/farm_placement_service.dart`
- Modify: `test/farm_migration_planner_test.dart`

- [ ] **Step 1: Definir modelos inmutables**

```dart
enum FarmMoveReason { invalidTerrain, protectedExit, overlap, unreachableDoor }

class MigrationBuilding {
  const MigrationBuilding({
    required this.id,
    required this.type,
    required this.origin,
    required this.width,
    required this.height,
    this.doorOffset,
    this.mailboxOffset,
  });
  final String id;
  final String type;
  final TilePoint origin;
  final int width;
  final int height;
  final TilePoint? doorOffset;
  final TilePoint? mailboxOffset;
  Set<TilePoint> get everyTile => {
    for (var y = 0; y < height; y++)
      for (var x = 0; x < width; x++) origin + TilePoint(x, y),
  };
  MigrationBuilding at(TilePoint value) => MigrationBuilding(
    id: id,
    type: type,
    origin: value,
    width: width,
    height: height,
    doorOffset: doorOffset,
    mailboxOffset: mailboxOffset,
  );
}

class PlannedBuildingMove {
  const PlannedBuildingMove(this.building, this.from, this.to, this.reason);
  final MigrationBuilding building;
  final TilePoint from;
  final TilePoint to;
  final FarmMoveReason reason;
}

class FarmMigrationPlan {
  const FarmMigrationPlan({required this.placements, required this.moves});
  final Map<String, TilePoint> placements;
  final List<PlannedBuildingMove> moves;
}
```

- [ ] **Step 2: Escribir tests de prioridad y estabilidad**

Comprobar que se conservan primero las posiciones que ya son válidas; después se colocan Farmhouse, Greenhouse, Shipping Bin, Cabins, edificios con puerta, edificios grandes y finalmente los que no tienen puerta. Dentro de la misma prioridad, ordenar por área descendente e ID para obtener resultados deterministas.

```dart
expect(plan.placements.keys.toSet(), fixture.map((b) => b.id).toSet());
expect(plan.placements['coop'], isNot(const TilePoint(33, 15)));
expect(plan.placements['silo'], isNot(const TilePoint(39, 15)));
expect(plan.moves.map((m) => m.building.id), containsAll(['coop', 'silo']));
```

- [ ] **Step 3: Implementar validación y búsqueda**

`FarmMigrationPlanner.plan` debe:

1. Rechazar huellas fuera del mapa, sobre `!isBuildable`, sobre `isProtected` o sobre edificios ya colocados.
2. Exigir casilla exterior transitable para cada `humanDoor`.
3. Para Farmhouse, exigir `mailboxOffset=(9,4)`, aproximación al buzón y corredor frontal.
4. Mantener una posición original válida; si no, buscar por distancia Manhattan creciente y desempatar por `y`, `x`.
5. Tras cada candidato, ejecutar BFS desde la puerta de Farmhouse; todas las puertas y anchors accesibles del mapa base deben seguir alcanzables.
6. Devolver `null` si no existe una distribución demostrablemente segura.

```dart
FarmMigrationPlan? plan({
  required List<MigrationBuilding> buildings,
  required TilePoint preferredFarmhouseOrigin,
}) {
  final ordered = [...buildings]..sort(_buildingPriority);
  final placements = <String, TilePoint>{};
  final occupied = <TilePoint>{};
  for (final building in ordered) {
    final candidate = _keepOrFind(building, occupied);
    if (candidate == null) return null;
    placements[building.id] = candidate.origin;
    occupied.addAll(candidate.everyTile);
  }
  if (!_allEntrancesAndAnchorsConnected(ordered, placements, occupied)) {
    return null;
  }
  return FarmMigrationPlan(placements: placements, moves: _diff(buildings, placements));
}
```

- [ ] **Step 4: Probar Riverland→Playa**

Run: `flutter test test/farm_migration_planner_test.dart`

Expected: PASS; Coop y Silo se mueven, ningún edificio se solapa y todas las puertas/salidas permanecen conectadas.

- [ ] **Step 5: Commit**

```bash
git add lib/core/services/farm_migration_planner.dart lib/core/services/farm_placement_service.dart test/farm_migration_planner_test.dart
git commit -m "feat: plan safe building placement across farm maps"
```

### Task 4: Compartir la recolocación de contenido dinámico

**Files:**
- Create: `lib/core/services/farm_content_relocation.dart`
- Modify: `lib/core/services/host_swap_service.dart`
- Modify: `test/host_swap_service_test.dart`
- Modify: `test/farm_migration_planner_test.dart`

- [ ] **Step 1: Extraer sin cambiar comportamiento**

Mover desde `host_swap_service.dart` las funciones que enumeran `objects` y `terrainFeatures`, calculan su casilla y actualizan `boundingBox` a una clase pura:

```dart
class FarmContentRelocationPlan {
  const FarmContentRelocationPlan(this.moves, this.unsupportedInvalidNodes);
  final List<FarmContentMove> moves;
  final List<String> unsupportedInvalidNodes;
  bool get isSafe => unsupportedInvalidNodes.isEmpty;
}

class FarmContentRelocator {
  FarmContentRelocationPlan plan({
    required XmlElement farm,
    required FarmSurface target,
    required Set<TilePoint> reserved,
  });
  void apply(FarmContentRelocationPlan plan);
}
```

- [ ] **Step 2: Conservar todos los tests de host swap**

Run: `flutter test test/host_swap_service_test.dart`

Expected: PASS sin cambiar expectativas; la extracción es mecánica.

- [ ] **Step 3: Añadir contenido inválido del mapa origen**

El plan debe revisar `objects`, `terrainFeatures`, `resourceClumps` y `largeTerrainFeatures`, considerando sus huellas. Si conoce el formato, busca la casilla edificable más cercana y actualiza todas sus coordenadas derivadas. Si encuentra un nodo sobre terreno inválido cuyo formato no reconoce, lo añade a `unsupportedInvalidNodes` y la conversión se cancela; nunca se borra.

```dart
expect(plan.unsupportedInvalidNodes, isEmpty);
expect(afterObjectIds, beforeObjectIds);
expect(afterTerrainFeatureIds, beforeTerrainFeatureIds);
```

- [ ] **Step 4: Commit**

```bash
git add lib/core/services/farm_content_relocation.dart lib/core/services/host_swap_service.dart test/host_swap_service_test.dart test/farm_migration_planner_test.dart
git commit -m "refactor: share lossless farm content relocation"
```

### Task 5: Implementar el servicio transaccional de conversión

**Files:**
- Create: `lib/core/services/farm_type_change_service.dart`
- Create: `test/farm_type_change_service_test.dart`

- [ ] **Step 1: Definir la API**

```dart
enum FarmTypeChangeError {
  invalidSave,
  unsupportedSource,
  unsupportedTarget,
  sameFarm,
  noSafePlacement,
  unsupportedFarmContent,
  writeFailure,
  postValidationFailed,
}

class FarmTypeChangeAnalysis {
  const FarmTypeChangeAnalysis({
    required this.ok,
    this.error,
    this.sourceWhichFarm,
    this.targetWhichFarm,
    this.buildingMoves = const [],
    this.contentMoves = 0,
  });
  final bool ok;
  final FarmTypeChangeError? error;
  final int? sourceWhichFarm;
  final int? targetWhichFarm;
  final List<PlannedBuildingMove> buildingMoves;
  final int contentMoves;
}
```

- [ ] **Step 2: Escribir tests de `analyze`**

Verificar que `analyze` no cambia hashes ni fechas, rechaza `source==target`, IDs fuera de `0..7`, granjas saturadas y contenido inválido no soportado. El caso Riverland→Playa debe listar como mínimo Coop y Silo.

- [ ] **Step 3: Implementar análisis XML**

Localizar `Farm`, parsear cada `Building` desde `buildingType`, `tileX`, `tileY`, `tilesWide`, `tilesHigh`, `humanDoor` e ID estable. Usar `FarmMigrationPlanner` y `FarmContentRelocator` sobre el mapa destino sin mutar el documento original.

- [ ] **Step 4: Implementar `execute` mediante staging**

```dart
final replace = await SaveReplaceService.instance.replaceSaveFolder(
  savesDir: Directory(saveFolderPath).parent.path,
  folderName: folderName,
  backupsDir: backupsDir,
  prepare: (staging) async {
    await copyDirectory(Directory(saveFolderPath), staging);
    final main = File('${staging.path}$sep$folderName');
    final doc = XmlDocument.parse(await main.readAsString());
    _applyVerifiedPlan(doc, plan, targetWhichFarm);
    await main.writeAsString(doc.toXmlString(pretty: false));
  },
  validate: (dir) => _validatePublishedConversion(
    dir,
    expectedWhichFarm: targetWhichFarm,
    originalSnapshot: snapshot,
    plan: plan,
  ),
);
```

La validación debe ejecutarse en staging y después de publicar. Debe volver a parsear geometría, comprobar máscaras, puertas, buzón, anchors, recuentos/IDs y `whichFarm`.

- [ ] **Step 5: Cubrir rollback y respaldo**

Forzar con `SaveReplaceService.withRename` el fallo del segundo rename. Comprobar byte a byte que el original vuelve y que una ejecución exitosa produce un respaldo verificable.

- [ ] **Step 6: Ejecutar suite**

Run: `flutter test test/farm_type_change_service_test.dart test/farm_migration_planner_test.dart test/host_swap_service_test.dart test/save_replace_service_test.dart`

Expected: PASS.

- [ ] **Step 7: Commit**

```bash
git add lib/core/services/farm_type_change_service.dart test/farm_type_change_service_test.dart
git commit -m "feat: convert vanilla farm types transactionally"
```

### Task 6: Sustituir el script peligroso por un CLI seguro

**Files:**
- Create: `tool/change_farm_type.dart`
- Modify: `test/farm_type_change_service_test.dart`

- [ ] **Step 1: Implementar argumentos sin dependencias nuevas**

El comando exige `--save <carpeta>` y `--target <0..7>`. Sin `--apply` solo analiza e imprime JSON. Con `--apply` exige además `--backups <carpeta>` y usa `FarmTypeChangeService.execute`.

```dart
void main(List<String> args) async {
  final options = CliOptions.parse(args);
  final service = FarmTypeChangeService();
  final analysis = await service.analyze(
    saveFolderPath: options.save,
    targetWhichFarm: options.target,
  );
  stdout.writeln(jsonEncode(analysis.toJson()));
  if (!analysis.ok || !options.apply) {
    exitCode = analysis.ok ? 0 : 2;
    return;
  }
  final result = await service.execute(
    saveFolderPath: options.save,
    targetWhichFarm: options.target,
    backupsDir: options.backups!,
  );
  stdout.writeln(jsonEncode(result.toJson()));
  exitCode = result.ok ? 0 : 3;
}
```

- [ ] **Step 2: Probar siempre primero en dry-run**

Run:

```powershell
dart run tool/change_farm_type.dart --save "$env:APPDATA\StardewValley\Saves\Safe_443286781" --target 6
```

Expected: no cambia archivos; lista movimientos propuestos y termina `0` si hay plan seguro.

- [ ] **Step 3: Aplicar solo sobre una copia restaurable**

Preparar una copia aislada y ejecutar:

```powershell
$testRoot = Join-Path $env:TEMP 'valleysave-farm-conversion-test'
if (Test-Path -LiteralPath $testRoot) { Remove-Item -LiteralPath $testRoot -Recurse -Force }
New-Item -ItemType Directory -Path $testRoot | Out-Null
Expand-Archive -LiteralPath 'C:\Users\Hirieo\Documents\ValleySave\Backups\Safe_443286781_pre-test-20260722-161142.zip' -DestinationPath $testRoot
dart run tool/change_farm_type.dart --save "$testRoot\Safe_443286781" --target 6 --backups "$testRoot\backups" --apply
```

Expected: crea respaldo, convierte, valida y devuelve rutas/movimientos en JSON.

- [ ] **Step 4: Commit**

```bash
git add tool/change_farm_type.dart test/farm_type_change_service_test.dart
git commit -m "tool: add dry-run farm type conversion command"
```

### Task 7: Verificación final proporcional al riesgo

**Files:**
- Modify: `docs/superpowers/plans/2026-07-22-safe-farm-type-conversion.md` solo para marcar pasos completados durante la ejecución.

- [ ] **Step 1: Análisis estático**

Run: `flutter analyze`

Expected: `No issues found!`

- [ ] **Step 2: Suite completa**

Run: `flutter test`

Expected: toda la suite pasa; no solo los tests nuevos.

- [ ] **Step 3: Matriz de los ocho mapas**

Ejecutar el planificador para las 56 conversiones dirigidas entre granjas vanilla (`8×7`). Cada resultado válido debe cumplir invariantes; los casos sin espacio pueden rechazarse con `noSafePlacement`, nunca producir una conversión parcial.

```dart
for (var source = 0; source < 8; source++) {
  for (var target = 0; target < 8; target++) {
    if (source == target) continue;
    final result = planner.planForFixture(source: source, target: target);
    if (result != null) expectValidMigration(result, target);
  }
}
```

- [ ] **Step 4: Prueba manual final con Safe**

1. Restaurar una copia del primer respaldo, nunca el save activo sin copia.
2. Ejecutar dry-run Riverland→Playa y revisar la lista de movimientos.
3. Aplicar sobre la copia.
4. Abrir en Stardew y comprobar Coop, Silo, Cabin, Farmhouse, buzón, puertas, salidas, cueva y animales.
5. Cerrar durmiendo un día y volver a cargar para comprobar que Stardew no reajusta el resultado.
6. Restaurar el respaldo de prueba al terminar.

La interfaz de selección de granja será una entrega separada: deberá mostrar el análisis y exigir confirmación explícita antes de llamar a `execute`.
