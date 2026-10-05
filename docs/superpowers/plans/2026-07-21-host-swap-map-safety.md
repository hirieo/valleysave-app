# Host swap seguro para mapa, buzón y cueva Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Cambiar el anfitrión sin mover la geometría física ya válida de la granja, preservando la decisión de la cueva y evitando que el nuevo anfitrión pierda el estado que impide repetir el evento de Demetrius.

**Architecture:** El save XML no contiene la capa de colisiones, los caminos ni el buzón estático de cada mapa de granja. Por tanto, el host swap no intentará inferir una ruta en C ni reubicar la Farmhouse sobre una Cabin: intercambiará únicamente los nodos de jugador y la asociación del ocupante de la cabaña. La validación transaccional exigirá que las coordenadas, dimensiones y puertas de ambos edificios, el interior de FarmHouse y FarmCave permanezcan intactos; además, propagará de manera mínima el evento global de cueva ya visto por el host saliente.

**Tech Stack:** Flutter/Dart, `xml`, `HostSwapService`, `SaveReplaceService`, tests `package:test`.

---

## Decisión de producto que implementa este plan

La Farmhouse grande **no viaja** a la coordenada de la cabaña del nuevo anfitrión. El jugador promovido pasa a vivir en la Farmhouse ya existente; el anfitrión saliente pasa a ocupar la cabaña ya existente. Por ello:

- Se preservan buzón, puerta, caminos y accesibilidad que ya proporcionaba el mapa.
- No se mueve ningún objeto de la granja ni se necesita buscar huecos libres.
- Los muebles y la estética permanecen con el edificio físico, no con la persona.
- No se aplicará reparación automática a saves ya intercambiados por la versión anterior: no existe una marca fiable que permita distinguirlos de una granja que el usuario haya movido a mano. Para ellos se restaura el zip `_pre-swap_` creado antes del cambio y se repite el swap con la versión corregida.

### Task 1: Sustituir la regla de reubicación por invariantes de mapa

**Files:**
- Modify: `lib/core/services/host_swap_service.dart:20-44`
- Modify: `lib/core/services/host_swap_service.dart:116-163`
- Modify: `lib/core/services/host_swap_service.dart:234-300`
- Modify: `test/host_swap_service_test.dart:88-146`

- [ ] **Step 1: Escribir los tests que expresan que el análisis no cambia de plan según objetos dentro de la huella**

```dart
test('G1b: objetos alrededor de la cabaña no bloquean el análisis', () async {
  final result = await service.analyze(
    saveFolderPath: saveFolderPath,
    targetUniqueId: CoopSaveFixture.targetUniqueId,
  );

  expect(result.ok, isTrue);
  expect(result.itemsToRelocate, 0);
});

test('G1c: granja antes saturada sigue siendo apta: no se mueve la casa', () async {
  await File(mainFilePath(CoopSaveFixture.originalFolderName))
      .writeAsString(CoopSaveFixture.mainXmlSaturated());

  final result = await service.analyze(
    saveFolderPath: saveFolderPath,
    targetUniqueId: CoopSaveFixture.targetUniqueId,
  );

  expect(result.ok, isTrue);
  expect(result.itemsToRelocate, 0);
});
```

- [ ] **Step 2: Ejecutar los dos tests para confirmar que fallan con el plan de reubicación actual**

Run: `flutter test test/host_swap_service_test.dart --plain-name "G1b"`

Expected: FAIL porque el fixture actual devuelve `itemsToRelocate == 3`.

- [ ] **Step 3: Eliminar la dependencia de `_planRelocation` en `analyze` y `execute`**

En `analyze`, después de validar `_loadContext`, devolver exactamente:

```dart
return HostSwapAnalysis(
  ok: true,
  itemsToRelocate: 0,
  targetName: ctx.targetName,
);
```

En `execute`, eliminar el bloque que calcula `plan`, devuelve `noFreeTile` y llama a `_moveItemTo`. El resultado exitoso debe declarar `relocatedCount: 0`.

Después de que no queden callers, borrar `_RelocationPlan`, `_Occupant`, `_FootprintEntry`, `_Candidate`, `_RelocationMove`, `_planRelocation`, `_moveItemTo`, `_itemType`, `_itemPriority`, las constantes `_ignorableTypes`, `_closeRadius`, `_farRadius` y el import `dart:math`.

- [ ] **Step 4: Ejecutar el fichero de tests y confirmar el comportamiento nuevo**

Run: `flutter test test/host_swap_service_test.dart`

Expected: PASS salvo los tests que todavía afirmen la reubicación física; actualizarlos en la tarea 2, no ocultarlos ni borrarlos sin reemplazo.

- [ ] **Step 5: Commit**

```bash
git add lib/core/services/host_swap_service.dart test/host_swap_service_test.dart
git commit -m "fix: host swap no mueve edificios ni objetos"
```

### Task 2: Mantener inmutable la geometría y los interiores físicos

**Files:**
- Modify: `lib/core/services/host_swap_service.dart:243-300`
- Modify: `lib/core/services/host_swap_service.dart:472-548`
- Modify: `lib/core/services/host_swap_service.dart:939-989`
- Modify: `test/host_swap_service_test.dart:330-530`

- [ ] **Step 1: Escribir el test de geometría del mapa antes del cambio de producción**

Añadir un helper de test que extraiga `tileX`, `tileY`, `tilesWide`, `tilesHigh` y `humanDoor` de un edificio por tipo y un test:

```dart
test('G6b: el swap conserva coordenadas, tamaño y puerta de cada vivienda', () async {
  final before = XmlDocument.parse(CoopSaveFixture.mainXml());
  final beforeFarmhouse = _buildingGeometry(before, 'Farmhouse');
  final beforeCabin = _buildingGeometry(before, 'Cabin');

  final result = await service.execute(
    saveFolderPath: saveFolderPath,
    targetUniqueId: CoopSaveFixture.targetUniqueId,
    backupsDir: backupsDir,
  );

  expect(result.ok, isTrue);
  final after = XmlDocument.parse(await File(
    mainFilePath(CoopSaveFixture.originalFolderName),
  ).readAsString());
  expect(_buildingGeometry(after, 'Farmhouse'), beforeFarmhouse);
  expect(_buildingGeometry(after, 'Cabin'), beforeCabin);
});
```

Añadir también un test que compare `FarmHouse` y el nodo `indoors` de la cabaña objetivo antes/después, ignorando únicamente `farmhandReference` si el formato del juego exige que apunte al host saliente.

- [ ] **Step 2: Ejecutar el test y confirmar que falla con la implementación actual**

Run: `flutter test test/host_swap_service_test.dart --plain-name "G6b"`

Expected: FAIL porque las líneas que intercambian `tileX`/`tileY` cambian ambas geometrías.

- [ ] **Step 3: Reducir la mutación a roles y asociación de ocupante**

Conservar el clonado de `oldHostClone` y `newHostClone`, y conservar estas escrituras:

```dart
ctx.player.children
  ..clear()
  ..addAll(newHostClone.children.map((child) => child.copy()));
_setElementValue(ctx.player, 'homeLocation', 'FarmHouse');
_setElementValue(ctx.player, 'slotCanHost', 'true');

ctx.target.children
  ..clear()
  ..addAll(oldHostClone.children.map((child) => child.copy()));
_setElementValue(ctx.target, 'homeLocation', ctx.targetHome);
_setElementValue(ctx.target, 'slotCanHost', 'false');
```

Eliminar todo el bloque que intercambia `tileX`/`tileY`, todo uso de `_copyInteriorContent`, la mutación de `topFarmHouse` y la copia de interior Farmhouse/Cabin. Mantener `farmhandReference` de la Cabin únicamente si una prueba con save real confirma que debe apuntar al ID del nuevo farmhand; si no, dejarlo intacto en esta entrega. No mover `nonInstancedIndoorsName` sin una prueba que demuestre que el juego lo necesita.

- [ ] **Step 4: Ampliar la validación publicada**

Antes de mutar, capturar firmas de geometría y los XML canónicos de `FarmHouse` y `FarmCave`:

```dart
final farmhouseGeometry = _buildingGeometrySignature(ctx.farmhouseBuilding);
final cabinGeometry = _buildingGeometrySignature(ctx.targetCabinBuilding);
final farmhouseXml = ctx.topFarmHouse.toXmlString(pretty: false);
final farmCaveXml = _locationXml(doc.rootElement, 'FarmCave');
```

Pasar esos cuatro valores a `_isHostSwapIntegrityValid`. Tras parsear el destino, devolver `false` si una firma de geometría, `FarmHouse` o `FarmCave` difiere de la original. `_locationXml` devolverá `null` si esa ubicación no existe tanto antes como después; `null` frente a nodo existente también será fallo.

- [ ] **Step 5: Ejecutar tests específicos y completos**

Run: `flutter test test/host_swap_service_test.dart`

Expected: PASS; ningún test debe seguir esperando que la Farmhouse se mueva a la cabaña ni que se reubiquen objetos.

- [ ] **Step 6: Commit**

```bash
git add lib/core/services/host_swap_service.dart test/host_swap_service_test.dart
git commit -m "fix: preserva mapa y viviendas al cambiar anfitrión"
```

### Task 3: Preservar la decisión de la cueva para el nuevo host

**Files:**
- Modify: `lib/core/services/host_swap_service.dart:75-115`
- Modify: `lib/core/services/host_swap_service.dart:260-272`
- Modify: `lib/core/services/host_swap_service.dart:939-989`
- Modify: `test/fixtures/coop_save_fixture.dart:57-130`
- Modify: `test/host_swap_service_test.dart:330-530`

- [ ] **Step 1: Extender el fixture con el estado real de la cueva ya elegida**

En `CoopSaveFixture.mainXml`, incluir un nodo `FarmCave` con un objeto de prueba y hacer que el host inicial tenga:

```xml
<eventsSeen><int>65</int></eventsSeen>
```

El farmhand objetivo tendrá `<eventsSeen/>`. El `65` representa el evento de Demetrius que marca la elección de la cueva; es el estado mínimo que debe llegar al nuevo anfitrión sin copiar todos sus eventos personales.

- [ ] **Step 2: Escribir tests de preservación y de no contaminación de eventos personales**

```dart
test('G6c: la cueva y el evento 65 pasan al nuevo anfitrión', () async {
  final result = await service.execute(
    saveFolderPath: saveFolderPath,
    targetUniqueId: CoopSaveFixture.targetUniqueId,
    backupsDir: backupsDir,
  );
  expect(result.ok, isTrue);

  final doc = XmlDocument.parse(await File(
    mainFilePath(CoopSaveFixture.originalFolderName),
  ).readAsString());
  expect(_playerEventIds(doc, CoopSaveFixture.targetUniqueId), contains('65'));
  expect(_locationXml(doc.rootElement, 'FarmCave'),
      CoopSaveFixture.originalFarmCaveXml);
});

test('G6d: no añade 65 si el anfitrión original no lo tenía', () async {
  await File(mainFilePath(CoopSaveFixture.originalFolderName))
      .writeAsString(CoopSaveFixture.mainXmlWithoutFarmCaveChoice());
  final result = await service.execute(
    saveFolderPath: saveFolderPath,
    targetUniqueId: CoopSaveFixture.targetUniqueId,
    backupsDir: backupsDir,
  );
  expect(result.ok, isTrue);
  final doc = XmlDocument.parse(await File(
    mainFilePath(CoopSaveFixture.originalFolderName),
  ).readAsString());
  expect(_playerEventIds(doc, CoopSaveFixture.targetUniqueId),
      isNot(contains('65')));
});
```

- [ ] **Step 3: Ejecutar los tests para confirmar que fallan**

Run: `flutter test test/host_swap_service_test.dart --plain-name "G6c"`

Expected: FAIL porque el nodo nuevo `<player>` se clona desde el farmhand y pierde el `65` del host saliente.

- [ ] **Step 4: Implementar una transferencia mínima y explícita del evento de cueva**

Definir junto a las constantes del servicio:

```dart
static const _farmCaveEventId = '65';
```

Después de escribir `ctx.player` desde `newHostClone`, llamar:

```dart
_preserveFarmCaveEvent(
  sourceHost: oldHostClone,
  destinationHost: ctx.player,
);
```

Implementar `_preserveFarmCaveEvent` con estas reglas:

1. Leer solo hijos `<int>` de `<eventsSeen>`.
2. Si el host saliente no contiene `65`, no escribir nada.
3. Si el destino ya contiene `65`, no duplicarlo.
4. Si el destino carece de `<eventsSeen>`, crearlo como `<eventsSeen><int>65</int></eventsSeen>`.
5. No copiar ningún otro ID de evento ni `mailReceived`: esos datos pueden ser personales.

Extender `_isHostSwapIntegrityValid` con `required bool hadFarmCaveChoice`; cuando sea `true`, exigir que el jugador `targetUniqueId` tenga el `65` tras publicar.

- [ ] **Step 5: Ejecutar tests y análisis**

Run: `flutter test test/host_swap_service_test.dart && flutter analyze`

Expected: PASS y `No issues found!`.

- [ ] **Step 6: Commit**

```bash
git add lib/core/services/host_swap_service.dart test/fixtures/coop_save_fixture.dart test/host_swap_service_test.dart
git commit -m "fix: conserva elección de cueva al promover anfitrión"
```

### Task 4: Corregir el contrato visible y validar en Stardew real

**Files:**
- Modify: `lib/l10n/app_en.arb:692-698`
- Modify: `lib/l10n/app_es.arb:297-303`
- Generated: `lib/generated/app_localizations*.dart`
- Test: `test/host_swap_service_test.dart`

- [ ] **Step 1: Cambiar los textos para no prometer movimiento de casa**

En español, sustituir los mensajes por:

```json
"hiwHostSwapTipMove": "El mapa, los caminos y los objetos de la granja no se mueven durante el cambio.",
"hiwHostSwapTipHouse": "El nuevo anfitrión usa la casa grande ya existente; se conservan puerta, buzón y cueva de la granja."
```

Cambiar `makeHostHouseWarning` por la misma idea, sin afirmar que la casa del jugador se trasladará. Añadir equivalentes en inglés a `app_en.arb`; los demás idiomas pueden usar fallback inglés conforme a la constitución.

- [ ] **Step 2: Regenerar localizaciones**

Run: `flutter gen-l10n`

Expected: se actualizan los getters de `lib/generated/` sin importar `flutter_gen`.

- [ ] **Step 3: Prueba manual en el save Safe antes de release**

1. Hacer una copia externa del save y verificar que ValleySave crea `_pre-swap_`.
2. Promover a Hirieo.
3. Entrar a la granja: confirmar que Farmhouse, Cabin, puerta, buzón y rutas mantienen las coordenadas anteriores.
4. Abrir el buzón y comprobar correo del nuevo anfitrión.
5. Visitar FarmCave: confirmar que conserva murciélagos/champiñones y que Demetrius no vuelve a ofrecer la elección.
6. Dormir un día, cerrar y volver a cargar.
7. Revertir usando el zip pre-swap y repetir el caso una segunda vez para probar determinismo.

- [ ] **Step 4: Ejecutar la batería completa y compilar Windows**

Run: `flutter analyze && flutter test && flutter build windows --release`

Expected: análisis limpio, todos los tests verdes y ejecutable en `build/windows/x64/runner/Release/`.

- [ ] **Step 5: Commit**

```bash
git add lib/l10n/app_en.arb lib/l10n/app_es.arb lib/generated test/host_swap_service_test.dart
git commit -m "docs: aclara conservación de mapa en cambio de anfitrión"
```

## Cobertura de requisitos

- Buzón inaccesible: Task 2 evita mover la Farmhouse y valida puerta/geometría inmutables.
- Camino cerrado o ruta en C: Task 1 elimina la expansión de huella y la reubicación; no se infiere una colisión inexistente en el XML.
- Cueva ofrecida de nuevo: Task 3 conserva el evento `65` del host saliente y valida que FarmCave no cambia.
- Datos del usuario: cada task conserva `SaveReplaceService`, respaldo pre-swap y post-validación en el destino publicado.
- Save ya afectado: la sección de decisión prohíbe una reparación automática insegura y fija restaurar el respaldo pre-swap como recuperación.

## Revisión del plan

- Cobertura: incluye los tres fallos comunicados, recuperación segura y regresión de UI.
- Placeholders: no quedan pasos `TODO` ni decisiones delegadas sin criterio; la única condición investigable (`farmhandReference`) está explícitamente bloqueada tras una prueba real antes de mutarla.
- Consistencia: la función propuesta `_preserveFarmCaveEvent`, la constante `_farmCaveEventId` y los parámetros de validación se usan con el mismo nombre en todas las tareas.
