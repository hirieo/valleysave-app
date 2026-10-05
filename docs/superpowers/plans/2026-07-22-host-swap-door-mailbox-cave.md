# Host swap con puerta, buzón y cueva seguros Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Mantener el intercambio físico Farmhouse↔Cabin, pero elegir una colocación que conserve la puerta absoluta, deje accesibles el buzón y el frente de la casa, y preserve la decisión global de la cueva.

**Architecture:** Separar la geometría del mapa del mutador XML: `FarmPlacementService` recibe una superficie transitable/construible y produce un plan inmutable; `HostSwapService` solo aplica el plan a una copia temporal y publica mediante `SaveReplaceService`. Las superficies de las granjas vanilla se generan desde los TBin desempaquetados y se empaquetan como bitsets base64 en Dart puro, para que Windows, Linux, macOS y Android usen exactamente las mismas reglas sin depender de una instalación local del juego ni de `rootBundle`.

**Tech Stack:** Flutter/Dart, `xml`, assets JSON, StardewXnbHack solo como herramienta de desarrollo, `package:test`, `SaveReplaceService`.

---

## Decisión de producto y evidencia real

Este plan sustituye a `2026-07-21-host-swap-map-safety.md`: aquella propuesta inmovilizaba los edificios y fue rechazada. El intercambio físico es obligatorio.

En el save real `Safe_443286781` de la granja Riverland (`whichFarm=1`) se observó:

- Antes: Farmhouse `(59,12)`, puerta relativa `(5,2)`, puerta absoluta `(64,14)`.
- Antes: cabaña de Hirieo `(68,41)`, puerta relativa `(2,1)`, puerta absoluta `(70,42)`.
- Resultado actual defectuoso: Farmhouse `(68,41)` y puerta `(73,43)`, porque se copió la esquina superior izquierda.
- Primer origen anclado por puerta: `(70,42) - (5,2) = (65,40)`.
- `Data/Buildings` de Stardew 1.6.15 define la Farmhouse con tamaño `9×5`, puerta `(5,2)`, buzón `Default_Mailbox` en `(9,4)` —fuera de la huella— y casilla adicional de salida `(5,5)`.
- En la posición defectuosa `(68,41)`, la puerta queda en `(73,43)`, la salida `(73,46)` es tierra válida, pero el buzón `(77,45)` tiene `Water=T`.
- El anclaje exacto de puerta `(65,40)` también es inválido: su buzón `(74,44)` tiene `Water=T` y una colisión en la capa `Buildings`.
- `(63,40)` deja puerta y buzón sobre tierra, pero el flood-fill real solo alcanza 64 casillas frente a 2307 antes del cambio: queda descartada por aislar la vivienda.
- La posición finalmente elegida es `(64,40)`: puerta `(69,42)`, buzón `(73,44)` y salida `(69,45)`. Conserva el corredor frontal en C, las salidas alcanzables y la conectividad relevante del mapa.
- El host anterior conserva `caveChoice=2` y evento `65`, mientras el nuevo host queda con `caveChoice=0`; eso permite que Demetrius vuelva a ofrecer una decisión ya tomada.

El save afectado no se repara automáticamente. Se recupera desde `Safe_443286781_pre-swap_20260722-084556.zip` y se repite el cambio con la versión corregida.

## Estructura de archivos

- Create: `lib/core/services/farm_placement_service.dart` — tipos geométricos, búsqueda de candidatos y comprobación de accesibilidad.
- Create: `lib/core/data/vanilla_farm_surfaces_data.dart` — bitsets generados para las ocho granjas vanilla.
- Create: `tool/generate_farm_surfaces.ps1` — generador reproducible desde TBin; nunca modifica `Content` del juego.
- Create: `test/farm_placement_service_test.dart` — pruebas unitarias puras de puerta, buzón, agua, ruta y puntuación.
- Modify: `lib/core/services/host_swap_service.dart` — integra el plan, aplica coordenadas seguras y conserva la cueva.
- Modify: `test/fixtures/coop_save_fixture.dart` — fixture Riverland con puerta, cueva y objeto frontal.
- Modify: `test/host_swap_service_test.dart` — regresión transaccional del caso `Safe`.
- Modify: `lib/l10n/app_es.arb`, `lib/l10n/app_en.arb` y `lib/generated/app_localizations*.dart` — error claro cuando no existe colocación segura.

## Estado de implementación (2026-07-22)

Completado y verificado: modelo y máscaras de las ocho granjas, búsqueda segura por puerta/buzón/corredor, protección de conectividad y salidas, reubicación con conteo exacto para el aviso, aplicación transaccional, validación tras publicar y transferencia mínima de `caveChoice` + evento 65. El fixture reproduce Riverland `Safe`; la posición `(64,40)` y ambas puertas absolutas se comprueban automáticamente.

Desviaciones intencionales respecto al borrador: se usa un archivo Dart generado en vez de un asset JSON para que el servicio siga siendo síncrono y multiplataforma; la conectividad final es más estricta que el umbral inicial del 50 %, porque también conserva salidas y rechaza pérdidas superiores al volumen razonable de las dos viviendas.

### Task 1: Modelar la colocación sin mutar XML

**Files:**
- Create: `lib/core/services/farm_placement_service.dart`
- Create: `test/farm_placement_service_test.dart`

- [ ] **Step 1: Escribir las pruebas fallidas del caso Safe**

```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:valleysave/core/services/farm_placement_service.dart';

void main() {
  test('ancla la Farmhouse a la puerta absoluta de la cabaña', () {
    final surface = FakeFarmSurface.allSafe(width: 100, height: 80);
    final result = FarmPlacementService(surface).plan(
      farmhouse: const BuildingGeometry(
        origin: TilePoint(59, 12), width: 9, height: 5,
        doorOffset: TilePoint(5, 2), mailboxOffset: TilePoint(9, 4),
      ),
      cabin: const BuildingGeometry(
        origin: TilePoint(68, 41), width: 5, height: 3,
        doorOffset: TilePoint(2, 1),
      ),
      occupiedBuildings: const [],
      movableItems: const [],
    );

    expect(result, isNotNull);
    expect(result!.farmhouseOrigin, const TilePoint(65, 40));
    expect(result.farmhouseDoor, const TilePoint(70, 42));
    expect(result.cabinOrigin, const TilePoint(62, 13));
    expect(result.cabinDoor, const TilePoint(64, 14));
  });

  test('rechaza el anclaje si el buzón cae en agua y elige el válido más próximo', () {
    final surface = FakeFarmSurface.allSafe(width: 100, height: 80)
      ..markWater(const TilePoint(74, 44));
    final result = FarmPlacementService(surface).plan(
      farmhouse: safeFarmhouse,
      cabin: safeCabin,
      occupiedBuildings: const [],
      movableItems: const [],
    );
    expect(result, isNotNull);
    expect(result!.farmhouseMailbox, isNot(const TilePoint(74, 44)));
    expect(surface.isWater(result.farmhouseMailbox), isFalse);
  });

  test('aborta si ningún candidato da acceso desde puerta hasta buzón', () {
    final surface = FakeFarmSurface.allBlocked(width: 100, height: 80);
    final result = FarmPlacementService(surface).plan(
      farmhouse: safeFarmhouse,
      cabin: safeCabin,
      occupiedBuildings: const [],
      movableItems: const [],
    );
    expect(result, isNull);
  });
}
```

- [ ] **Step 2: Ejecutar las pruebas y comprobar el fallo esperado**

Run: `flutter test test/farm_placement_service_test.dart`

Expected: FAIL porque `farm_placement_service.dart` y sus tipos aún no existen.

- [ ] **Step 3: Crear los tipos geométricos y el contrato de superficie**

```dart
class TilePoint {
  const TilePoint(this.x, this.y);
  final int x;
  final int y;
  TilePoint operator +(TilePoint other) => TilePoint(x + other.x, y + other.y);
  TilePoint operator -(TilePoint other) => TilePoint(x - other.x, y - other.y);
  int manhattanTo(TilePoint other) => (x - other.x).abs() + (y - other.y).abs();
  @override bool operator ==(Object other) => other is TilePoint && x == other.x && y == other.y;
  @override int get hashCode => Object.hash(x, y);
}

class BuildingGeometry {
  const BuildingGeometry({
    required this.origin, required this.width, required this.height,
    required this.doorOffset, this.mailboxOffset,
  });
  final TilePoint origin;
  final int width;
  final int height;
  final TilePoint doorOffset;
  final TilePoint? mailboxOffset;
  TilePoint get absoluteDoor => origin + doorOffset;
}

abstract interface class FarmSurface {
  bool isBuildable(TilePoint tile);
  bool isPassable(TilePoint tile);
  bool isWater(TilePoint tile);
  bool isFishingAllowed(TilePoint tile);
}

class HostSwapPlacementPlan {
  const HostSwapPlacementPlan({
    required this.farmhouseOrigin, required this.cabinOrigin,
    required this.farmhouseDoor, required this.cabinDoor,
    required this.farmhouseMailbox, required this.itemsToMove,
  });
  final TilePoint farmhouseOrigin;
  final TilePoint cabinOrigin;
  final TilePoint farmhouseDoor;
  final TilePoint cabinDoor;
  final TilePoint farmhouseMailbox;
  final List<ItemMove> itemsToMove;
}
```

- [ ] **Step 4: Implementar la búsqueda determinista**

`FarmPlacementService.plan` debe:

1. Calcular las dos puertas absolutas originales.
2. Probar primero `oldCabinDoor - farmhouse.doorOffset` y `oldFarmhouseDoor - cabin.doorOffset`.
3. Enumerar desplazamientos de radio Manhattan `0..8`, ordenados por: desplazamiento de puerta, desplazamiento del origen y coordenadas X/Y para desempate estable.
4. Exigir huella construible, no solapada con edificios ajenos.
5. Tratar objetos/árboles XML como movibles, nunca como terreno válido.
6. Exigir que la casilla base del buzón esté sobre terreno válido (dentro del mapa, no agua y sin edificio ajeno). El poste no tiene que ser transitable: se interactúa desde una casilla vecina.
7. Calcular las cuatro casillas ortogonales al buzón, descartar las que caigan en agua, fuera del mapa o dentro de la huella de la casa, y exigir al menos una casilla de aproximación transitable.
8. Construir un corredor frontal en C: fila `bottom+1` desde `left-1` hasta `right+1`, más columnas laterales desde la altura de la puerta hasta `bottom+1`.
9. Hacer flood-fill y exigir conexión entre la casilla sur de la puerta, al menos una aproximación válida al buzón y uno de los dos extremos laterales. La puerta anclada es una preferencia: si ese candidato no conecta el buzón, se desplaza la casa lo mínimo necesario —en el caso mostrado, hacia la izquierda—.
10. Devolver `null` si no existe un candidato; nunca degradar a la copia de esquina actual.

- [ ] **Step 5: Ejecutar pruebas y commit**

Run: `dart format lib/core/services/farm_placement_service.dart test/farm_placement_service_test.dart && flutter test test/farm_placement_service_test.dart`

Expected: PASS.

```bash
git add lib/core/services/farm_placement_service.dart test/farm_placement_service_test.dart
git commit -m "feat: planifica viviendas por puerta y buzón accesibles"
```

### Task 2: Generar superficies vanilla reproducibles

**Files:**
- Create: `tool/generate_farm_surfaces.dart`
- Create: `assets/data/vanilla_farm_surfaces.json`
- Create: `lib/core/services/vanilla_farm_surface_repository.dart`
- Modify: `pubspec.yaml:68-72`
- Test: `test/vanilla_farm_surface_repository_test.dart`

- [ ] **Step 1: Añadir el test de carga y el caso Riverland**

```dart
test('whichFarm=1 carga Riverland y distingue agua de tierra', () async {
  final repo = await VanillaFarmSurfaceRepository.load();
  final riverland = repo.forWhichFarm(1);
  expect(riverland, isNotNull);
  expect(riverland!.isPassable(const TilePoint(70, 42)), isTrue);
  expect(riverland.isPassable(const TilePoint(73, 42)), isFalse);
});

test('tipo desconocido no inventa una superficie', () async {
  final repo = await VanillaFarmSurfaceRepository.load();
  expect(repo.forWhichFarm(999), isNull);
});
```

- [ ] **Step 2: Registrar el asset**

```yaml
flutter:
  assets:
    - assets/data/
    - assets/icons/
    - assets/flags/
```

- [ ] **Step 3: Crear el generador de máscaras**

El generador acepta una carpeta `Content (unpacked)` creada por StardewXnbHack y lee `Maps/Farm*.tmx` más `Data/Buildings.json`. Para cada tile produce cuatro bits: `buildable`, `passable`, `water` cuando la capa Back resuelve `Water=T`, y `fishingAllowed` cuando es agua y no resuelve `NoFishing=T`. `fishingAllowed` describe la geometría del mapa; reglas de localización, eventos o festivales todavía pueden impedir o alterar la pesca. Codifica cada fila como tramos `[inicio, longitud]`, de modo que el asset no copie imágenes ni tilesheets del juego.

```dart
Future<void> main(List<String> args) async {
  if (args.length != 2) {
    stderr.writeln('Uso: dart run tool/generate_farm_surfaces.dart <Content unpacked> <salida.json>');
    exitCode = 64;
    return;
  }
  final source = Directory(args[0]);
  final output = File(args[1]);
  final definitions = <int, String>{
    0: 'Farm', 1: 'Farm_Fishing', 2: 'Farm_Foraging', 3: 'Farm_Mining',
    4: 'Farm_Combat', 5: 'Farm_FourCorners', 6: 'Farm_Beach',
    7: 'Farm_Meadowlands',
  };
  final result = <String, Object?>{'schema': 1, 'farms': <String, Object?>{}};
  for (final entry in definitions.entries) {
    final tmx = File('${source.path}${Platform.pathSeparator}Maps${Platform.pathSeparator}${entry.value}.tmx');
    if (!tmx.existsSync()) throw StateError('Falta ${tmx.path}');
    (result['farms']! as Map<String, Object?>)[entry.key.toString()] =
        TmxFarmMaskParser.parse(tmx.readAsStringSync()).toJson();
  }
  output
    ..createSync(recursive: true)
    ..writeAsStringSync(const JsonEncoder.withIndent('  ').convert(result));
}
```

`TmxFarmMaskParser` debe resolver tilesets y propiedades, fallar si falta `Back` o `Buildings`, y verificar que todas las filas tienen el ancho declarado. No se admite completar datos ausentes con `true`.

- [ ] **Step 4: Generar el asset sin tocar el juego**

1. Copiar StardewXnbHack a una carpeta temporal.
2. Ejecutarlo contra una copia de `Content`; nunca escribir dentro de `C:\Program Files (x86)\Steam\steamapps\common\Stardew Valley\Content`.
3. Generar:

Run: `dart run tool/generate_farm_surfaces.dart "C:\ruta\Content (unpacked)" assets/data/vanilla_farm_surfaces.json`

Expected: JSON con `schema: 1`, claves `0..7`, dimensiones y filas RLE no vacías.

- [ ] **Step 5: Implementar el repositorio y verificarlo**

```dart
class VanillaFarmSurfaceRepository {
  VanillaFarmSurfaceRepository._(this._surfaces);
  final Map<int, FarmSurface> _surfaces;

  static Future<VanillaFarmSurfaceRepository> load() async {
    final raw = await rootBundle.loadString('assets/data/vanilla_farm_surfaces.json');
    final json = jsonDecode(raw) as Map<String, dynamic>;
    if (json['schema'] != 1) throw const FormatException('farm surface schema');
    final farms = json['farms'] as Map<String, dynamic>;
    return VanillaFarmSurfaceRepository._({
      for (final entry in farms.entries)
        int.parse(entry.key): RleFarmSurface.fromJson(entry.value as Map<String, dynamic>),
    });
  }

  FarmSurface? forWhichFarm(int whichFarm) => _surfaces[whichFarm];
}
```

Run: `flutter test test/vanilla_farm_surface_repository_test.dart`

Expected: PASS, incluido el punto de agua que reprodujo `Safe`.

- [ ] **Step 6: Commit**

```bash
git add pubspec.yaml tool/generate_farm_surfaces.dart assets/data/vanilla_farm_surfaces.json lib/core/services/vanilla_farm_surface_repository.dart test/vanilla_farm_surface_repository_test.dart
git commit -m "feat: incorpora superficies seguras de granjas vanilla"
```

### Task 3: Integrar el plan seguro en HostSwapService

**Files:**
- Modify: `lib/core/services/host_swap_service.dart:75-445`
- Modify: `lib/core/services/host_swap_service.dart:551-849`
- Modify: `test/fixtures/coop_save_fixture.dart`
- Modify: `test/host_swap_service_test.dart`

- [ ] **Step 1: Convertir el fixture en la regresión Safe**

Cambiar la cabaña objetivo a `(68,41)`, añadir `<whichFarm>1</whichFarm>`, `caveChoice=2` y `<eventsSeen><int>65</int></eventsSeen>` al host, `caveChoice=0` al objetivo, `farmCaveReady=true` a Farm, un `FarmCave` no vacío y un Campfire en `(73,46)`.

- [ ] **Step 2: Escribir el test transaccional**

```dart
test('Safe: puerta, buzón, corredor y cueva sobreviven al swap', () async {
  final before = XmlDocument.parse(await File(mainFilePath(
    CoopSaveFixture.originalFolderName,
  )).readAsString());
  final beforeCave = locationXml(before, 'FarmCave');

  final result = await service.execute(
    saveFolderPath: saveFolderPath,
    targetUniqueId: CoopSaveFixture.targetUniqueId,
    backupsDir: backupsDir,
  );

  expect(result.ok, isTrue);
  final after = XmlDocument.parse(await File(mainFilePath(
    CoopSaveFixture.originalFolderName,
  )).readAsString());
  expect(buildingDoor(after, 'Farmhouse'), const TilePoint(70, 42));
  expect(buildingDoor(after, 'Cabin'), const TilePoint(64, 14));
  expect(playerInt(after, CoopSaveFixture.targetUniqueId, 'caveChoice'), 2);
  expect(playerEvents(after, CoopSaveFixture.targetUniqueId), contains('65'));
  expect(locationXml(after, 'FarmCave'), beforeCave);
});
```

- [ ] **Step 3: Inyectar la superficie en el servicio**

```dart
class HostSwapService {
  HostSwapService({VanillaFarmSurfaceRepository? surfaces})
      : _surfaces = surfaces;
  VanillaFarmSurfaceRepository? _surfaces;

  Future<FarmSurface?> _surfaceFor(XmlElement root) async {
    _surfaces ??= await VanillaFarmSurfaceRepository.load();
    final whichFarm = int.tryParse(_text(root, 'whichFarm') ?? '');
    return whichFarm == null ? null : _surfaces!.forWhichFarm(whichFarm);
  }
}
```

En `analyze` y `execute`, una superficie ausente o un plan `null` devuelve `HostSwapError.noFreeTile`; no se ejecuta el fallback antiguo.

- [ ] **Step 4: Sustituir el intercambio de esquina por el plan**

Eliminar la lectura `fx/fy/cx/cy` y escribir:

```dart
_setElementValue(ctx.farmhouseBuilding, 'tileX', plan.farmhouseOrigin.x.toString());
_setElementValue(ctx.farmhouseBuilding, 'tileY', plan.farmhouseOrigin.y.toString());
_setElementValue(ctx.targetCabinBuilding, 'tileX', plan.cabinOrigin.x.toString());
_setElementValue(ctx.targetCabinBuilding, 'tileY', plan.cabinOrigin.y.toString());
for (final move in plan.itemsToMove) {
  _moveItemTo(move.element, move.destination.x, move.destination.y);
}
```

La reubicación existente se conserva, pero su zona prohibida pasa a ser la huella más el corredor frontal y las casillas de interacción de puerta/buzón. La puntuación sigue priorizando cofres/cultivos y nunca coloca objetos sobre agua, Buildings tiles, mailbox o corredor.

- [ ] **Step 5: Reforzar la validación post-publicación**

Pasar a `_isHostSwapIntegrityValid` las puertas absolutas y el `FarmCave` original. Tras publicar, exigir:

```dart
final farmhouseDoorOk = _absoluteDoor(verifyFarmhouse) == expectedFarmhouseDoor;
final cabinDoorOk = _absoluteDoor(verifyCabin) == expectedCabinDoor;
final caveOk = _locationXml(verifyDoc.rootElement, 'FarmCave') == originalFarmCaveXml;
return existingChecks && farmhouseDoorOk && cabinDoorOk && caveOk;
```

- [ ] **Step 6: Ejecutar pruebas**

Run: `flutter test test/farm_placement_service_test.dart test/host_swap_service_test.dart`

Expected: PASS; los tests antiguos de copia por esquina deben reemplazarse por invariantes de puerta y accesibilidad, no borrarse sin cobertura equivalente.

- [ ] **Step 7: Commit**

```bash
git add lib/core/services/host_swap_service.dart test/fixtures/coop_save_fixture.dart test/host_swap_service_test.dart
git commit -m "fix: evita buzones inaccesibles al cambiar anfitrión"
```

### Task 4: Transferir solo el estado global de la cueva

**Files:**
- Modify: `lib/core/services/host_swap_service.dart`
- Modify: `test/host_swap_service_test.dart`

- [ ] **Step 1: Escribir pruebas de cueva elegida y no elegida**

```dart
test('transfiere caveChoice y evento 65 sin copiar eventos personales', () async {
  final result = await executeSwap();
  expect(result.ok, isTrue);
  final doc = await readResult();
  expect(playerInt(doc, targetId, 'caveChoice'), 2);
  expect(playerEvents(doc, targetId), contains('65'));
  expect(playerEvents(doc, targetId), isNot(contains('personal-old-host-event')));
});

test('no inventa elección si la granja aún no eligió cueva', () async {
  await writeFixture(CoopSaveFixture.mainXmlWithoutCaveChoice());
  final result = await executeSwap();
  expect(result.ok, isTrue);
  final doc = await readResult();
  expect(playerInt(doc, targetId, 'caveChoice'), 0);
  expect(playerEvents(doc, targetId), isNot(contains('65')));
});
```

- [ ] **Step 2: Implementar la transferencia mínima**

```dart
void _preserveFarmCaveChoice(XmlElement oldHost, XmlElement newHost) {
  final choice = int.tryParse(_text(oldHost, 'caveChoice') ?? '0') ?? 0;
  if (choice <= 0) return;
  _setElementValue(newHost, 'caveChoice', choice.toString());
  final events = _ensureChild(newHost, 'eventsSeen');
  if (!events.findElements('int').any((e) => e.innerText == '65')) {
    events.children.add(XmlElement(XmlName('int'), [], [XmlText('65')]));
  }
}
```

Llamarla después de copiar el farmhand a `<player>`. No copiar `mailReceived`, otros eventos ni relaciones personales. `FarmCave` y `farmCaveReady` permanecen byte-equivalentes salvo formato XML.

- [ ] **Step 3: Ejecutar pruebas y commit**

Run: `flutter test test/host_swap_service_test.dart --plain-name "cueva"`

Expected: PASS.

```bash
git add lib/core/services/host_swap_service.dart test/host_swap_service_test.dart
git commit -m "fix: conserva la elección global de la cueva"
```

### Task 5: Mensaje seguro, recuperación y verificación final

**Files:**
- Modify: `lib/l10n/app_es.arb`
- Modify: `lib/l10n/app_en.arb`
- Generated: `lib/generated/app_localizations*.dart`
- Modify: `test/host_swap_service_test.dart`

- [ ] **Step 1: Añadir el mensaje de rechazo seguro**

```json
"makeHostNoFreeTile": "No hay una posición segura para intercambiar las casas. No se ha cambiado la partida: la puerta, el buzón o el camino quedarían bloqueados.",
"makeHostNoFreeTile": "There is no safe position to swap the homes. The save was not changed: the door, mailbox, or path would be blocked."
```

Cada cadena se añade en su ARB correspondiente y se regenera con `flutter gen-l10n`.

- [ ] **Step 2: Probar que un plan imposible no escribe ni crea backup engañoso**

```dart
test('colocación imposible conserva exactamente el original', () async {
  final before = await snapshot(saveFolderPath);
  final result = await blockedService.execute(
    saveFolderPath: saveFolderPath,
    targetUniqueId: targetId,
    backupsDir: backupsDir,
  );
  expect(result.error, HostSwapError.noFreeTile);
  expect(await snapshot(saveFolderPath), before);
  expect(Directory(backupsDir).existsSync(), isFalse);
});
```

- [ ] **Step 3: Ejecutar verificación automática completa**

Run: `dart format lib test tool && flutter gen-l10n && flutter analyze && flutter test`

Expected: `No issues found!` y toda la suite PASS.

- [ ] **Step 4: Recuperar y validar manualmente Safe**

1. Restaurar desde la UI el respaldo `Safe_443286781_pre-swap_20260722-084556.zip`.
2. Confirmar en ValleySave que Bollibella vuelve a ser host antes de repetir.
3. Ejecutar el swap a Hirieo con la versión corregida.
4. Abrir Stardew y comprobar: puerta utilizable, buzón alcanzable, salida lateral por el corredor, puente intacto, objetos movidos visibles y cueva ya elegida sin nueva visita de Demetrius.
5. Dormir un día, cerrar y volver a cargar para validar persistencia.

- [ ] **Step 5: Commit**

```bash
git add lib/l10n lib/generated test/host_swap_service_test.dart
git commit -m "fix: explica y valida el rechazo de swaps inseguros"
```

## Revisión del plan

- Intercambio físico obligatorio: Tasks 1 y 3 mueven ambos edificios y sus interiores.
- Puertas absolutas: Task 1 ancla ambas y Task 3 las verifica tras publicar.
- Buzón en esquina: Tasks 1 y 2 validan la base del poste y una casilla ortogonal de interacción conectada con la puerta; no basta con que quepa el sprite.
- Agua, puentes y caminos: Task 2 usa pasabilidad/construibilidad de mapas vanilla; ningún elemento estático se modifica.
- Objetos XML y corredor en C: Tasks 1 y 3 amplían la zona protegida y reutilizan la reubicación priorizada.
- Cueva global: Task 4 transfiere solo `caveChoice` y evento `65`, conservando `FarmCave` y datos personales.
- Seguridad de datos: `analyze` es solo lectura; `execute` sigue trabajando en temporal, genera respaldo verificado y publica mediante `SaveReplaceService`.
- Granjas personalizadas/mods: al no existir una máscara confiable, se rechaza el swap con `noFreeTile`; nunca se adivina terreno.
- No hay placeholders ni degradaciones silenciosas: toda ausencia de mapa, puerta, buzón o ruta devuelve fallo sin escribir.
