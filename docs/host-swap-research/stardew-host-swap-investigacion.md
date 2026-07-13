# Investigacion: cambio de anfitrion en Stardew Valley coop

Fecha: 2026-07-09
Proyecto relacionado: ValleySave
Save base analizado: `Stardust_443121237`

## ⟶ RETOMAR AQUI (chat nuevo, sin contexto previo)

**CERRADO (2026-07-10):** la matriz de pruebas de ampliacion de Robin vs swap —
ver [`matriz-pruebas-ampliacion.md`](matriz-pruebas-ampliacion.md) (mismo directorio) —
ya tiene decision de producto tomada por el usuario: **el swap se implementa CON
reubicacion automatica por prioridad y SIN bloqueo/aviso por ampliaciones pendientes.**
A1-A4 y B3/B4 completados y verificados en XML, todos limpios. Huecos aceptados como
riesgo conocido (no bloqueantes): B1v2, B5, casos F0.5 (matrimonio/mascotas/eventos),
desconexiones mas largas que ~2 dias — revisar la matriz si alguno da problemas en uso
real. No hace falta mas trabajo en este tema salvo que surja un fallo real.

**Ubicacion de todo:**
- Este documento: `docs/host-swap-research/stardew-host-swap-investigacion.md` (dentro del repo `valleysave-app`).
- Scripts PowerShell de prueba: `C:\Users\Hirieo\projects\ValleySave\stardew-dedicated-host-research\` (FUERA del repo, carpeta de trabajo aparte — no confundir).
- Detector de colisiones en Dart (para portar a la app real): `docs/host-swap-research/dart-poc/collision_check.dart`.
- Plan general de la feature (compartir saves + swap): `docs/plan-compartir-saves-coop.md` — este documento de investigacion es el detalle tecnico que sustenta la Fase F3 de ese plan.
- Saves de Windows: `C:\Users\Hirieo\AppData\Roaming\StardewValley\Saves\`.
  `Stardust_443121237` = el save REAL del usuario, NUNCA tocar directamente. Todo lo demas
  (`Stardust*_<8digitos>`) son copias de prueba desechables, se crean y se borran libremente.

**Estado actual (BLOQUEADO por un bug sin resolver, leer antes de seguir):**
Copia activa: `StardustLimpio_211624626` (jugador visible `HirieoLimpio`), con host y
farmhand Eltestosteron reseteados a `houseUpgradeLevel=0`, `daysUntilHouseUpgrade=-1`.
Al cargarla en el juego para pedirle la ampliacion real a Robin, el usuario se encontro:
**personaje invisible, no se podia mover, y la sala aparecia vacia (sin muebles) —
persistio tras cerrar el juego del todo y recargar.** El XML en disco NO muestra
corrupcion (muebles presentes, campos de apariencia con forma correcta comparados contra
`Mojomcio_418326337`) — es decir, lo que se ve en vivo no cuadra con lo que hay guardado.
Hipotesis sin confirmar (mas probable primero):
1. Relacionado con el bug de cascada de `houseUpgradeLevel` de la seccion anterior — puede
   que quedara algun campo relacionado (cola de construccion de Robin, evento pendiente)
   sin limpiar del todo al resetear solo `houseUpgradeLevel`/`daysUntilHouseUpgrade`.
2. Glitch de carga/streaming del motor sin relacion con nuestras ediciones (menos probable,
   ya se probo recargar completo y persistio).

**Actualizacion — bug ACOTADO (no resuelto del todo, pero ya no bloquea):** el usuario
cargo `Stardust_443121237old` (el save mas original posible, sin ninguna edicion nuestra)
y funciona bien — personaje visible, se puede mover con normalidad. Esto descarta la
hipotesis 2 (no es un glitch general del motor) y apunta a la hipotesis 1: algo especifico
de `StardustLimpio_211624626` (probablemente relacionado con el reset de
`houseUpgradeLevel`/`daysUntilHouseUpgrade`, o con algun resto del bug de cascada previo)
dejo ese save en mal estado. **`StardustLimpio_211624626` queda marcado como sospechoso —
no reutilizar sin analizarlo mas — pero ya NO es necesario bloquear el resto del trabajo
por esto.** Se sigue trabajando sobre `Stardust_443121237old` (funciona bien), aplicando
ahi mismo dinero/herramientas/recursos al maximo siguiendo el patron ya establecido
(clonar plantillas reales, esta vez desde `StardustFinal_699164485`/Eltestosteron que ya
tiene las herramientas Iridium).

**Nota de coordinacion (2026-07-09, tarde):** esta investigacion se esta llevando en
DOS chats en paralelo (uno enfocado en la parte tecnica/plan, otro haciendo las pruebas
en vivo con el usuario). Si retomas esto en un chat nuevo, comprueba primero el estado
real de los saves en disco (`Get-ChildItem` en la carpeta de Saves) antes de asumir nada
de lo escrito aqui — puede haber avanzado en el otro chat despues de esta nota. No edites
el mismo archivo de save que el usuario diga que esta usando en el otro chat a la vez.

**Estado de las copias de prueba en disco ahora mismo (limpieza ya hecha, no repetir):**
`Mojomcio_418326337` y `Pleyades_395187544` son partidas AJENAS a este proyecto, usadas
solo como referencia de datos reales — nunca borrar, nunca modificar.
`StardustFinal_699164485` (jugador `Eltestosteron`) — resultado antiguo, pendiente de
decidir si se conserva o se borra (preguntar al usuario, no asumir).
`Stardust_443121237old` — la copia mas original recien extraida, para el diagnostico de
arriba. El resto de copias de prueba anteriores (Bisect, Bisect2, Minimo, Reubica,
Sandbox, V3, Vuelta) YA SE BORRARON en la sesion anterior — no busques referencias a esos
nombres, no existen.

**Protocolo rapido de diagnostico (para no repetir una sesion lenta de preguntas):**
1. Antes de decir "cárgalo", correr SIEMPRE esta checklist en una sola pasada (no una
   pregunta a la vez): ¿el nombre del archivo principal coincide EXACTO con el nombre de
   la carpeta? ¿`SaveGameInfo` y el archivo principal tienen el mismo `<name>`/nodo raiz?
   ¿hay algun `*_old` sobrante que limpiar? ¿el XML parsea sin error? **¿`uniqueIDForThisGame`
   es distinto al de CUALQUIER otro save que ya exista en la carpeta Saves (sobre todo el
   original)?** — si dos copias comparten el mismo ID, el juego las confunde/solapa en el
   menu aunque esten en carpetas distintas con nombres distintos. Van ya varias veces que
   un script nuevo se olvida de regenerar este campo — es tan critico como el nombre de
   archivo, nunca omitirlo al copiar un save.
   **Ademas, no basta con que sea unico — tiene que ser EXACTAMENTE el mismo numero que
   el sufijo de la carpeta** (`NombreX_<numero>` → `uniqueIDForThisGame` = ese `<numero>`,
   confirmado en todos los saves reales que cargan bien). Un intento de arreglo puso un ID
   aleatorio que SI era unico pero NO coincidia con el sufijo de la carpeta, y el save
   siguio sin aparecer — solo funciono al usar el mismo numero que ya tenia la carpeta.
2. Si el usuario reporta algo raro EN VIVO (personaje invisible, no se puede mover, sala
   vacia, etc.) que el XML no explica: no asumir que es "solo un glitch de carga" a la
   primera. Pedir UN mensaje con todos los datos utiles de golpe (que se vio exactamente,
   en que copia, si persistio tras recargar) en vez de una pregunta por turno — el usuario
   ya lo dijo una vez, no repreguntar los mismos hechos de formas distintas.
3. Preferir comparar contra un save de referencia real (`Mojomcio`/`Pleyades`) para
   descartar corrupcion antes de sospechar del motor del juego.
4. **El nombre de la CARPETA no sirve para que el usuario identifique la partida en el
   juego — solo se ve el nombre del JUGADOR anfitrion en el menu.** Renombrar solo la
   carpeta (sin cambiar tambien `<player><name>` en el XML) deja al usuario sin forma de
   distinguir dos copias. Toda copia nueva de prueba TIENE que llevar un nombre de
   jugador distinto y reconocible, siempre.

**Conclusiones ya cerradas (no hace falta re-investigar):**
1. El cambio de anfitrion FUNCIONA, validado en juego real varias veces (ida y vuelta).
2. El host SIEMPRE vive en el building `Farmhouse` (9x5) — el motor no permite host en
   una `Cabin`. Por tanto el swap SIEMPRE intercambia fisicamente 2 buildings (Farmhouse
   ⇄ cabaña del objetivo).
3. Sin auto-limpieza, el motor NO borra nada al superponer un edificio — pero cualquier
   objeto que quede DENTRO de la huella solida se vuelve inaccesible (verificado con un
   cofre). Por eso la deteccion de colisiones es obligatoria, nunca opcional.
4. Reubicacion automatica con prioridades en cascada, validada en juego:
   - Edificios: intocables.
   - Cultivos/cofres (prioridad alta): deben quedar cerca (radio corto), pueden desalojar
     a la prioridad baja si hace falta.
   - Maleza/arboles/rocas (prioridad baja): ceden el sitio, se mandan mas lejos.
   - Los objetos SIEMPRE se reubican al SUR/lados de la huella nueva, nunca al norte
     (detras) — el sprite de la casa tapa visualmente esa zona. Bug ya corregido: la
     busqueda debe explorar TODO el radio antes de decidir, no parar en el primer anillo
     con hueco libre (si no, un hueco malo cercano gana a uno bueno lejano).
   - Objetos "grandes" (Chest, Furniture) tienen un `boundingBox` en PIXELES (tile*64)
     ADEMAS de la clave de tile — si se reubica sin actualizar tambien el boundingBox,
     el objeto se mueve en los datos pero el punto de clic se queda en el sitio viejo
     (cofre movido que no se puede abrir). Hay que actualizar SIEMPRE los dos.
5. Ampliar la casa (Robin) NO cambia el tamaño EXTERIOR del edificio (verificado:
   Farmhouse nivel 3 mide igual que nivel 0, 9x5) — irrelevante para el calculo de huella.
6. `houseUpgradeLevel` puesto a mano SIN gestionar `daysUntilHouseUpgrade` de forma
   consistente CAUSA UN BUG: Robin aplica varias mejoras en cascada de golpe (de nivel 0
   a nivel 3 durmiendo una sola vez). No volver a simular ampliaciones via flag suelto.
7. Patron de trabajo obligatorio en todos los scripts: clonar SIEMPRE objetos reales de
   un save existente (nunca inventar la estructura XML a mano — los xsi:type/campos
   ocultos son faciles de acertar mal). Despues de copiar una carpeta de save con
   `Copy-Item -Recurse`, borrar cualquier archivo `*_old` que venga arrastrado (son
   backups que el propio juego crea al jugar/guardar esa copia, y su presencia hace que
   el save NO aparezca en la lista del juego).

**Pendiente sin resolver (no bloqueante para F3, aceptado como riesgo conocido tras
cerrar la decision de producto el 2026-07-10 — ver `matriz-pruebas-ampliacion.md`):**
- F0.5 del plan general: casos que rompen el swap (matrimonio jugador-jugador, mascotas
  con dueño, eventos de anfitrion pendientes) — nunca investigado.
- ✅ RESUELTO: una ampliacion REAL de Robin (no simulada) SI sobrevive al swap, en
  ambos sentidos y con la obra en cualquier punto (0 o a medio decrementar) — ver
  matriz de pruebas, A3/A4/B3/B4.
- `useSeparateWallets`: el script original lo fuerza a `true` siempre; sigue sin decidirse
  si habria que preservar el valor original en vez de forzarlo.

## Resumen ejecutivo

El objetivo era convertir al jugador `Eltestosteron` en anfitrion de una partida coop de Stardew Valley, conservando lo maximo posible:

| Objetivo | Estado actual |
|---|---|
| Convertir a Eltestosteron en anfitrion | Logrado |
| Conservar `UniqueMultiplayerID` | Logrado |
| Conservar stats, inventario, dinero y progreso | Logrado |
| Conservar interior/items de su casa | Logrado |
| Conservar ubicacion original de su casa | Logrado |
| Evitar objetos/arboles atravesando la casa | Logrado con limpieza de huella |
| Conservar estetica exterior de cabaña | No logrado |

El mejor resultado estable es la copia:

```text
C:\Users\Hirieo\AppData\Roaming\StardewValley\Saves\StardustHostStable_347194893
```

Nombre visible en el juego:

```text
prueba11
```

Esta copia funciona correctamente en cuanto a anfitrion, ubicacion, stats e interior. Lo unico que no conserva es la estetica exterior original de la cabaña de Eltestosteron: se ve como la casa principal grande (`Farmhouse`).

## Conclusion principal

Stardew Valley parece separar dos conceptos:

1. El jugador que es anfitrion real de la partida.
2. El edificio visual/interactivo que representa su casa.

El anfitrion real esta fuertemente asociado a:

```xml
<homeLocation>FarmHouse</homeLocation>
```

y al edificio:

```xml
<buildingType>Farmhouse</buildingType>
```

La estetica exterior depende del `buildingType` del edificio:

| `buildingType` | Resultado visual |
|---|---|
| `Farmhouse` | Casa principal grande |
| `Cabin` | Cabaña |

El problema es que la `Farmhouse` no tiene skins de cabaña definidos por el juego, mientras que `Cabin` si los tiene.

Por tanto, sin mod o sin modificar datos internos del juego, el limite actual parece ser:

> Se puede cambiar quien es anfitrion, conservar stats, inventario, interior y ubicacion; pero no parece posible conservar al 100% la estetica exterior de cabaña si el jugador pasa a ser el host real usando `FarmHouse`.

## Save original: Stardust

Ruta original:

```text
C:\Users\Hirieo\AppData\Roaming\StardewValley\Saves\Stardust_443121237
```

Datos principales:

| Jugador | Rol original | ID | Casa logica | Exterior | Tile |
|---|---|---:|---|---|---|
| Hirieo | Host | `2321001960493971870` | `FarmHouse` | `Farmhouse` | `59,12` |
| Eltestosteron | Farmhand | `7315742846708293284` | `FarmHouse169206dd-231a-4ee3-b59a-3d291dae2883` | `Log Cabin` | `23,31` |
| Farmhand vacio | Farmhand | `5346915482428432340` | `FarmHouse0748c9bb-aab9-4a73-88d3-65f310ba1c51` | `Stone Cabin` | `66,37` |

Estructura conceptual del save original:

```xml
<SaveGame>
  <player>
    <name>Hirieo</name>
    <slotCanHost>true</slotCanHost>
    <homeLocation>FarmHouse</homeLocation>
    <UniqueMultiplayerID>2321001960493971870</UniqueMultiplayerID>
  </player>

  <farmhands>
    <Farmer>
      <name>Eltestosteron</name>
      <slotCanHost>false</slotCanHost>
      <homeLocation>FarmHouse169206dd-231a-4ee3-b59a-3d291dae2883</homeLocation>
      <UniqueMultiplayerID>7315742846708293284</UniqueMultiplayerID>
    </Farmer>
  </farmhands>
</SaveGame>
```

Edificios en el original:

| Edificio | `buildingType` | `skinId` | Tile | Tamaño | Puerta | Interior |
|---|---|---|---|---|---|---|
| Casa principal | `Farmhouse` | vacio | `59,12` | `9x5` | `5,2` | `FarmHouse` |
| Casa de Eltestosteron | `Cabin` | `Log Cabin` | `23,31` | `5x3` | `2,1` | `FarmHouse169206dd-231a-4ee3-b59a-3d291dae2883` |
| Casa vacia | `Cabin` | `Stone Cabin` | `66,37` | `5x3` | `2,1` | `FarmHouse0748c9bb-aab9-4a73-88d3-65f310ba1c51` |

## Comparativa: host vs farmhand

| Concepto | Anfitrion / Host | No anfitrion / Farmhand |
|---|---|---|
| Nodo del jugador | `<SaveGame><player>` | `<farmhands><Farmer>` |
| Puede alojar partida | `<slotCanHost>true</slotCanHost>` | `<slotCanHost>false</slotCanHost>` |
| ID real del jugador | `<UniqueMultiplayerID>...</UniqueMultiplayerID>` | `<UniqueMultiplayerID>...</UniqueMultiplayerID>` |
| Casa logica del jugador | `<homeLocation>FarmHouse</homeLocation>` | `<homeLocation>FarmHouseUUID</homeLocation>` |
| Tipo de edificio | `<buildingType>Farmhouse</buildingType>` | `<buildingType>Cabin</buildingType>` |
| Interior asociado | `nonInstancedIndoorsName = FarmHouse` | `<indoors xsi:type="Cabin">` |
| Nombre del interior | `FarmHouse` | `FarmHouse169206dd-...` |
| Estetica exterior | Casa grande principal | Cabaña |
| Skin visual | No tiene skins | `Log Cabin`, `Stone Cabin`, `Plank Cabin`, etc. |
| Tamaño exterior | `9x5` | `5x3` |
| Puerta | `5,2` | `2,1` |
| Items/interior | Puede copiarse del farmhand | Interior propio inline dentro del edificio |
| Stats/inventario | Se conservan al mover el nodo a `<player>` | Se conservan dentro de `<Farmer>` |
| Rol de red | Creador/host de la partida | Jugador conectado |
| Problema estetico | Al ser `Farmhouse`, se ve como casa grande | Si es `Cabin`, conserva estetica de cabaña |

## Datos internos del juego sobre edificios

Se cargo `Data/Buildings` desde los archivos locales del juego.

Resultado relevante:

| Campo | Farmhouse | Cabin |
|---|---|---|
| Nombre | `Farmhouse` | `Cabin` |
| Tamaño | `9x5` | `5x3` |
| Puerta | `5,2` | `2,1` |
| Textura | `Buildings\houses` | base `Buildings\Stone Cabin` |
| Interior | `NonInstancedIndoorLocation=FarmHouse` | `IndoorMap=FarmHouse` |
| Tipo interior | No inline | `StardewValley.Locations.Cabin` |
| Skins | `0` | `6` |

Skins disponibles para `Cabin`:

| Skin |
|---|
| `Plank Cabin` |
| `Log Cabin` |
| `Neighbor Cabin` |
| `Rustic Cabin` |
| `Beach Cabin` |
| `Trailer Cabin` |

Conclusion de esta parte:

```text
Farmhouse no tiene skins.
Cabin si tiene skins.
```

Por eso no basta con hacer:

```xml
<buildingType>Farmhouse</buildingType>
<skinId><string>Log Cabin</string></skinId>
```

El juego no define `Log Cabin` como skin valida de `Farmhouse`.

## Patron estable encontrado

El patron que funciona es:

1. Tomar el nodo de Eltestosteron dentro de `<farmhands><Farmer>`.
2. Convertirlo en el nodo principal `<player>`.
3. Mantener su `UniqueMultiplayerID`.
4. Poner `slotCanHost=true`.
5. Poner `homeLocation=FarmHouse`.
6. Mover la `Farmhouse` real a la ubicacion original de Eltestosteron (`23,31`).
7. Copiar el interior/items de la cabaña de Eltestosteron al `FarmHouse` global.
8. Convertir a Hirieo en farmhand.
9. Mover la cabaña que era de Eltestosteron a la antigua ubicacion de la casa principal (`59,12`) para que Hirieo tenga una casa asociada.
10. Limpiar objetos/terrainFeatures bajo la nueva huella de la `Farmhouse`.
11. Mantener en el archivo principal el nodo literal `<player>`, no un nodo con el nombre del jugador.
12. En `SaveGameInfo`, usar el nombre visible de la prueba como nodo raiz si se desea.

Resultado de `prueba11`:

| Elemento | Resultado |
|---|---|
| Host | `prueba11` / Eltestosteron |
| ID host | `7315742846708293284` |
| Casa logica host | `FarmHouse` |
| Edificio host | `Farmhouse` |
| Ubicacion host | `23,31` |
| Interior host | Interior original de Eltestosteron |
| Primer mueble del interior | `Bed@9,8` |
| Hirieo | Farmhand |
| Casa de Hirieo | `FarmHouse169206dd-231a-4ee3-b59a-3d291dae2883` |
| Ubicacion de la cabaña de Hirieo | `59,12` |
| Estetica host | Casa grande |

## Detalle del XML estable

Jugador host estable:

```xml
<SaveGame>
  <player>
    <name>prueba11</name>
    <slotCanHost>true</slotCanHost>
    <homeLocation>FarmHouse</homeLocation>
    <lastSleepLocation>FarmHouse</lastSleepLocation>
    <UniqueMultiplayerID>7315742846708293284</UniqueMultiplayerID>
  </player>
</SaveGame>
```

Edificio host estable:

```xml
<Building>
  <buildingType>Farmhouse</buildingType>
  <tileX>23</tileX>
  <tileY>31</tileY>
  <tilesWide>9</tilesWide>
  <tilesHigh>5</tilesHigh>
  <humanDoor>
    <X>5</X>
    <Y>2</Y>
  </humanDoor>
  <nonInstancedIndoorsName>
    <string>FarmHouse</string>
  </nonInstancedIndoorsName>
</Building>
```

Farmhand despues del cambio:

```xml
<farmhands>
  <Farmer>
    <name>Hirieo</name>
    <slotCanHost>false</slotCanHost>
    <homeLocation>FarmHouse169206dd-231a-4ee3-b59a-3d291dae2883</homeLocation>
    <UniqueMultiplayerID>2321001960493971870</UniqueMultiplayerID>
  </Farmer>
</farmhands>
```

Cabaña asociada al farmhand:

```xml
<Building>
  <buildingType>Cabin</buildingType>
  <skinId>
    <string>Log Cabin</string>
  </skinId>
  <tileX>59</tileX>
  <tileY>12</tileY>
  <tilesWide>5</tilesWide>
  <tilesHigh>3</tilesHigh>
  <humanDoor>
    <X>2</X>
    <Y>1</Y>
  </humanDoor>
  <indoors xsi:type="Cabin">
    <uniqueName>FarmHouse169206dd-231a-4ee3-b59a-3d291dae2883</uniqueName>
    <name>Cabin</name>
  </indoors>
</Building>
```

## Pruebas realizadas

| Prueba | Idea | Resultado |
|---|---|---|
| `StardustHostSwap_769063544` | Convertir a Eltester en host, mover Farmhouse a su sitio, copiar interiores | Funciono casi todo; casa grande |
| `prueba6` / `StardustAestheticHost_661315803` | Eltester host manteniendo su `homeLocation` de cabaña | Cargaba raro; jugador invisible / resolucion incorrecta |
| `prueba7` / `StardustHostCabin_659092390` | Renombrar interior de cabaña a `FarmHouse` | Stardew se cerro al cargar |
| `prueba8` / `StardustHostSwapClean_415168261` | Repetir enfoque estable con limpieza de huella | No aparecio inicialmente por problemas de metadatos/formato, no quedo como mejor base |
| `prueba9` / `StardustCabinDoor_766396107` | Mantener cabaña visual en `23,31` apuntando a `FarmHouse` | Aparecio tras corregir `<player>`, pero resolvio a la casa de Hirieo en `59,12` |
| `prueba10` / `StardustHostSwapCabinVisual_408190491` | Desde la segunda buena, cambiar solo el edificio host a `Cabin`/`Log Cabin` | No soluciono la estetica de forma util |
| `prueba11` / `StardustHostStable_347194893` | Volver al cambio estable sin tocar estetica | Funciona: host, ubicacion, interior y stats correctos; estetica no |

## Lecciones por prueba

### Segunda partida buena

Ruta:

```text
C:\Users\Hirieo\AppData\Roaming\StardewValley\Saves\StardustHostSwap_769063544
```

Funciono porque:

- Eltester paso a `<player>`.
- `slotCanHost=true`.
- `homeLocation=FarmHouse`.
- La `Farmhouse` real se movio a `23,31`.
- El interior global `FarmHouse` recibio los muebles de Eltester.

Fallo pendiente:

- El exterior se ve como `Farmhouse`, no como `Log Cabin`.

### Prueba7

Idea:

```xml
<Building>
  <buildingType>Cabin</buildingType>
  <skinId><string>Log Cabin</string></skinId>
  <indoors xsi:type="Cabin">
    <uniqueName>FarmHouse</uniqueName>
    <name>FarmHouse</name>
  </indoors>
</Building>
```

Resultado:

```text
Stardew se cerro al cargar.
```

Interpretacion:

Stardew no acepta que una ubicacion inline de tipo `Cabin` actue literalmente como `FarmHouse`. Hay expectativas internas sobre el tipo, nombre o localizacion.

### Prueba9

Idea:

```xml
<Building>
  <buildingType>Cabin</buildingType>
  <skinId><string>Log Cabin</string></skinId>
  <tileX>23</tileX>
  <tileY>31</tileY>
  <nonInstancedIndoorsName>
    <string>FarmHouse</string>
  </nonInstancedIndoorsName>
</Building>
```

Resultado:

- La partida acabo apareciendo tras corregir el nodo `<player>`.
- Eltester era host.
- El interior era el suyo.
- Pero aparecia en la casa de Hirieo / ubicacion de la `Farmhouse` real.

Interpretacion:

Aunque una cabaña apunte a `FarmHouse`, Stardew sigue resolviendo el `homeLocation=FarmHouse` contra la `Farmhouse` real/global, no contra cualquier `Cabin` que apunte a ese interior.

### Prueba10

Idea:

Partir de la segunda buena y cambiar:

```xml
<buildingType>Farmhouse</buildingType>
```

a:

```xml
<buildingType>Cabin</buildingType>
<skinId><string>Log Cabin</string></skinId>
```

manteniendo:

```xml
<nonInstancedIndoorsName>FarmHouse</nonInstancedIndoorsName>
```

Resultado:

No resolvio el problema visual de forma util.

Interpretacion:

El juego no parece aceptar que el edificio funcional del host sea una `Cabin` aunque apunte a `FarmHouse`, o lo resuelve de una manera que no conserva el comportamiento esperado.

### Prueba11

Idea:

No pelear la estetica. Hacer todo lo funcional bien.

Resultado confirmado por el usuario:

```text
Funciona: ubicacion, anfitrion, interior, etc.
```

Fallo unico:

```text
La casa se ve como casa grande.
```

## Problema del nodo `<player>`

Descubrimiento importante:

En el archivo principal del save, Stardew espera:

```xml
<SaveGame>
  <player>
    ...
  </player>
</SaveGame>
```

No debe quedar asi:

```xml
<SaveGame>
  <prueba9>
    ...
  </prueba9>
</SaveGame>
```

Si el archivo principal tiene `<prueba9>` en lugar de `<player>`, la partida puede no aparecer en el menu.

En cambio, en `SaveGameInfo` si puede tener un nodo raiz con el nombre del jugador:

```xml
<prueba9>
  <name>prueba9</name>
</prueba9>
```

Regla practica:

| Archivo | Nodo raiz del farmer |
|---|---|
| Save principal | Siempre `<player>` |
| `SaveGameInfo` | Puede ser `<NombreJugador>` |

## Sobre cambiar el nombre del jugador

Durante las pruebas se cambio el nombre visible a `prueba6`, `prueba7`, `prueba8`, etc. Esto se hizo solo para identificar cada intento dentro del juego.

Impacto del cambio de nombre:

| Campo | Impacto |
|---|---|
| `<name>` | Visible en menu, UI y dialogos |
| `<UniqueMultiplayerID>` | Identidad real del jugador |
| Stats/items | Se conservan si se conserva el nodo del farmer |
| Casa | Depende de `homeLocation` |
| Multiplayer | Depende principalmente del ID, no del nombre |

Para una funcionalidad real en ValleySave, no conviene depender del cambio de nombre. La app deberia crear una copia con nombre/ID identificable y mostrar un resumen propio.

## Limpieza de huella exterior

Cuando se mueve la `Farmhouse` a la antigua ubicacion de la cabaña, pueden quedar objetos del mapa bajo la nueva casa.

En el original habia elementos cerca de `23,31`:

| Tipo | Coordenadas |
|---|---|
| `objects` | `29,31` |
| `objects` | `24,34` |
| `terrainFeatures` | `29,33` |
| `terrainFeatures` | `31,32` |

En `prueba11` se limpio la huella completa:

```text
23,31..31,35
```

Esto evita problemas como arboles, maleza, piedras o cofres atravesando la casa.

## Algoritmo viable para ValleySave

Nombre sugerido de funcion:

```text
Promote farmhand to host
```

Entradas:

| Entrada | Descripcion |
|---|---|
| Save origen | Carpeta original del save |
| Jugador objetivo | Farmhand que pasara a host |
| Nombre de copia | Nombre interno/visible de la copia |
| Limpiar huella | Booleano recomendado en `true` |
| Mantener estetica | Mostrar como no soportado de forma estable sin mod |

Pasos:

1. Crear copia nueva del save original.
2. Renombrar el archivo principal para que coincida con la carpeta nueva.
3. Cargar XML principal y `SaveGameInfo`.
4. Localizar `<player>` actual.
5. Localizar farmhand objetivo por `UniqueMultiplayerID` o nombre.
6. Localizar su `homeLocation` original.
7. Localizar edificio `Cabin` cuyo `indoors.uniqueName` coincida con ese `homeLocation`.
8. Localizar edificio `Farmhouse` principal.
9. Clonar interior de la cabaña objetivo.
10. Clonar interior global `FarmHouse` original.
11. Crear nuevo `<player>` desde el farmhand objetivo.
12. Mantener `UniqueMultiplayerID` del objetivo.
13. Poner `slotCanHost=true`.
14. Poner `homeLocation=FarmHouse`.
15. Poner `lastSleepLocation=FarmHouse`.
16. Convertir el antiguo `<player>` en `<Farmer>` dentro de `<farmhands>`.
17. Poner al antiguo host `slotCanHost=false`.
18. Darle al antiguo host la antigua `homeLocation` del farmhand objetivo.
19. Intercambiar tiles de `Farmhouse` y cabaña objetivo.
20. Copiar interior de la cabaña objetivo al `FarmHouse` global.
21. Copiar interior original de Hirieo a la cabaña movida.
22. Limpiar objetos y terrain features bajo la nueva huella de la `Farmhouse`.
23. Actualizar `uniqueIDForThisGame`.
24. Regenerar `SaveGameInfo` desde el nuevo player.
25. Mantener `<player>` como nodo literal en el save principal.
26. Guardar.

## Advertencia que deberia mostrar ValleySave

Texto sugerido:

```text
Este cambio convierte al farmhand seleccionado en anfitrion real de la partida y conserva su progreso, inventario, dinero, interior de casa y ubicacion. Sin embargo, Stardew Valley asocia el anfitrion a la FarmHouse principal, por lo que la casa del nuevo anfitrion se vera como la casa grande del juego. La estetica original de cabaña no parece soportada de forma estable sin mods o sin modificar datos internos del juego.
```

## Estado final de la investigacion

Estado funcional actual:

| Area | Resultado |
|---|---|
| Host swap | Resuelto |
| Preservar stats | Resuelto |
| Preservar items/inventario | Resuelto |
| Preservar interior de casa | Resuelto |
| Preservar ubicacion | Resuelto |
| Limpiar objetos conflictivos | Resuelto |
| Preservar estetica exterior | No resuelto / probablemente limite sin mod |

Conclusion final:

```text
Lo funcional ya esta resuelto. Lo estetico esta ligado al sistema interno de edificios de Stardew: Farmhouse no tiene skins y Cabin no se comporta como FarmHouse host de forma estable.
```

---

## Continuacion (2026-07-09, sesion con Claude Code)

**Revision del estado anterior: `Promote-StardewHost.ps1` NO se considera valido para el
proyecto.** Funciona en el sentido de que carga en el juego, pero tiene un problema serio
de fondo detectado al revisar el algoritmo con mas calma:

### Problema real: destruccion de terreno al mover edificios

El modo `SwapExterior` (el unico que el script deja usar) intercambia las coordenadas de
tile entre la `Farmhouse` (9x5) y la cabaña objetivo (5x3). Al ser la Farmhouse mas grande,
su nueva huella en el sitio de la cabaña invade tiles que antes eran terreno libre del
jugador. `Clean-BuildingFootprint` "resuelve" esto BORRANDO objetos y terrainFeatures bajo
la huella nueva — es decir, el script destruye cultivos, rocas, arboles o cualquier cosa
que el jugador tuviera plantada alrededor de su cabaña. Esto es inaceptable en un producto
real: el jugador objetivo probablemente planifico sus cultivos alrededor de SU cabaña
pequeña, no alrededor de un hueco pensado para una casa grande.

No es solo un problema de posicion — es un problema de que la huella crece y se lleva por
delante lo que el jugador ya construyo.

### Hipotesis nuevas a probar (sin verificar todavia)

**Hipotesis A — no reubicar ningun edificio.**

En vez de intercambiar tiles, dejar la `Farmhouse` real y la cabaña objetivo cada una
EXACTAMENTE donde ya estaban. Solo cambiar:

- El nodo `<player>`/`<Farmer>` (igual que ahora).
- `homeLocation` de cada jugador (el nuevo host apunta a `FarmHouse` literal, el host
  saliente apunta al `uniqueName` de la cabaña objetivo — sin mover nada fisicamente).
- El contenido de interior (muebles, cofres, etc.) SI se sigue queriendo que cada jugador
  "se lleve sus cosas" a la ubicacion logica que le corresponde.

Apoyo a favor: la prueba9 del bloque anterior ya demostro que el motor resuelve
`homeLocation=FarmHouse` contra el building real con `buildingType=Farmhouse`,
independientemente de que otra cabaña apunte a ese mismo interior. Esto sugiere que el
motor no necesita que la Farmhouse "este" en un sitio concreto para funcionar — solo que
exista un building con `buildingType=Farmhouse`.

Contras a investigar: el nuevo host terminaria teniendo su casa en la ubicacion ORIGINAL
de la Farmhouse (donde estaba el host anterior), no en la ubicacion donde el objetivo tenia
su cabaña y sus cultivos. Es decir, resuelve el problema de destruccion de terreno, pero
no resuelve "el jugador sigue teniendo su casa donde el la puso" — su casa se traslada
igualmente, solo que sin destruir nada porque ninguna estructura fisica se mueve, solo
cambia de dueño logico.

Falta probar en juego real: ¿el jugador ve su casa saltar de sitio sin razon aparente?
¿los cultivos alrededor de la vieja Farmhouse (que ahora "pertenece" logicamente al nuevo
host) quedan igual de bien o mal emplazados que antes?

**Hipotesis B — mantener la cabaña, aceptar limpieza dirigida en vez de automatica.**

Si se opta por SI mover la Farmhouse al sitio de la cabaña (para que el nuevo host
conserve su ubicacion), no borrar automaticamente lo que estorba. En su lugar:

- Detectar que hay objetos/cultivos en la huella nueva.
- Si los hay, NO ejecutar el swap automaticamente — avisar al usuario y dejar que decida
  (mover sus propios cultivos antes en el juego, o aceptar la perdida explicitamente).
- Alternativa mas segura: en vez de agrandar la huella hacia fuera desde el centro,
  comprobar si hay espacio LIBRE alrededor de la cabaña antes de ofrecer el swap. Si no lo
  hay, bloquear la accion con una explicacion clara en vez de destruir nada.

Esto cambia el enfoque de "arreglarlo automaticamente borrando" a "detectar y avisar,
nunca borrar sin permiso explicito". Mas alineado con ser fiable en produccion.

### Sobre copias vs edicion in-situ

Las pruebas 6-11 siempre trabajaron sobre copias nuevas del save (carpeta nueva,
`uniqueIDForThisGame` nuevo) porque es la forma segura de experimentar sin arriesgar el
save real. Esto sigue siendo correcto PARA INVESTIGAR.

Para el producto final (ValleySave), sigue sin resolverse si el cambio de anfitrion debe:
- (a) generar siempre una entrada de save nueva (como hace el script), o
- (b) editar el save existente en el mismo sitio, conservando su identidad en ValleySave.

Pendiente de probar: si es tecnicamente valido regenerar `uniqueIDForThisGame` DENTRO de
la misma carpeta/nombre de archivo (edicion in-situ) sin que el juego se queje, en vez de
crear siempre una carpeta nueva. Si el juego lo acepta, (b) es mas fiable para producción
porque no duplica entradas de save cada vez que alguien cambia de anfitrion.

### Restriccion dura confirmada (base de todo el analisis)

El anfitrion SIEMPRE tiene que vivir en el edificio `Farmhouse` (9x5). El motor NO permite
que un host viva en una `Cabin` — las pruebas 7, 9 y 10 lo confirmaron (crash o
comportamiento incorrecto). Por tanto, como la casa del host es 9x5 y la cabaña del jugador
era 5x3, algo tiene que ceder SIEMPRE. Solo hay dos salidas reales:

- **A (no mover la Farmhouse):** el nuevo host hereda la Farmhouse en su ubicacion original.
  No se destruye nada, pero el hogar del nuevo host "se teletransporta" lejos de sus cultivos.
- **B (mover la Farmhouse al sitio de la cabaña):** el nuevo host conserva su zona, pero la
  huella 9x5 invade tiles que antes eran terreno libre del jugador.

No hay tercera via sin mods.

### Resultado de la prueba de Hipotesis A (copia `StardustHipA_*`, renombrada `PruebaHipA`)

Observacion del usuario sobre el estado resultante del enfoque A:

- La cabaña del jugador migrado (el que pasa a host) pasa a ser la cabaña del farmhand, en
  la localizacion donde estaba el farmhand original.
- La cabaña del jugador a migrar sigue fisicamente ahi, pero queda sin pertenecer ni al
  nuevo host ni al otro jugador (estado huerfano/confuso).

Conclusion parcial: A no destruye terreno, pero produce un reparto de casas confuso y
desplaza el hogar del nuevo host. Layout poco intuitivo.

### Analisis de footprint del enfoque B en la granja real (solo lectura, 2026-07-09)

Datos reales de `Stardust_443121237`:

| Edificio | tile | size | uniqueName |
|---|---|---|---|
| FarmHouse | 59,12 | 9x5 | (host) |
| Cabin (Eltestosteron) | 23,31 | 5x3 | FarmHouse169206dd-... |
| Cabin (vacia) | 66,37 | 5x3 | FarmHouse0748c9bb-... |

Si movemos la FarmHouse 9x5 al tile de la cabaña de Eltestosteron (23,31), la huella nueva
ocupa X 23..31, Y 31..35 (la cabaña original solo ocupaba X 23..27, Y 31..33). Elementos
del jugador que quedan bajo esa huella nueva:

| Tile | Tipo | Gravedad |
|---|---|---|
| 29,31 | Weeds (maleza) | Irrelevante |
| 24,34 | **Chest (cofre)** | **CRITICO — probablemente con items dentro** |
| 29,33 | Tree adulto (treeType 1, growthStage 6) | Perdida notable |
| 31,32 | Tree recien plantado (growthStage 0) | Perdida menor |

**Hallazgo clave:** el `Clean-BuildingFootprint` del script original habria BORRADO ese
cofre (`24,34`) y todo su contenido, sin aviso. Esto en una granja de PRUEBA casi vacia.
En una granja real, mover la casa y auto-limpiar destruiria estructuras y objetos valiosos
del jugador. **Conclusion firme: NUNCA auto-borrar. Cualquier enfoque B debe detectar la
huella, y si hay algo que no sea maleza/hierba, abortar y avisar — jamas destruir en silencio.**

### Resultado real de Enfoque B en juego (PruebaHipB2, confirmado por el usuario)

Se corrigieron dos bugs del script de prueba original (orden de guardado del nombre;
faltaban campos de identidad `name`/`isStructure`/`uniqueName`/`farmhandReference`/
`nonInstancedIndoorsName` tras mover los edificios — sin ellos el save no aparecia en la
lista de partidas). Con el fix, `StardustHipB2_197550152` carga correctamente.

**Resultado visual real, SIN ejecutar ninguna limpieza automatica:**

- El cofre (24,34) queda intacto y accesible delante de la casa. NO desaparecio.
- Las rocas visibles alrededor tampoco desaparecieron.
- Un arbol (el de growthStage 6, en 29,33) queda dibujado superpuesto con la esquina
  del tejado — visualmente raro, pero el usuario confirma que se puede talar con normalidad.
- Ninguna perdida de items ni de progreso.

**Conclusion importante — revisa la severidad asumida antes:** sin auto-limpieza, Stardew
NO borra nada al superponer un edificio sobre objetos/terrainFeatures existentes — el
motor simplemente dibuja el edificio encima. Lo que "sobra" queda ahi, interactuable. El
`Clean-BuildingFootprint` del script original NO era necesario para evitar perdida de datos
— sin el, el peor caso observado es un problema ESTETICO (arbol atravesando visualmente
la esquina de la casa), no un problema de INTEGRIDAD (nada se destruye).

Esto cambia el analisis: el riesgo real de Enfoque B no es "destruye cultivos/cofres", es
"puede verse mal en la esquina del edificio si hay algo alto (arbol) justo ahi". Mucho mas
aceptable como limitacion conocida que como riesgo de perdida de datos.

### Estado de esta continuacion

- Restriccion host=Farmhouse: confirmada.
- Enfoque A: probado, no destruye pero deja layout confuso (la cabaña que se libera no
  queda asociada intuitivamente a nadie hasta que el host saliente se muda).
- Enfoque B: **probado en juego real, funciona.** Conserva la zona de cultivos del nuevo
  host. Sin limpieza automatica no hay perdida de datos, solo posible solape visual con
  arboles/objetos altos en la esquina — cosmetico, no destructivo.
- Con este dato, B parece preferible a A: mismo nivel de seguridad (nada se pierde) pero
  el jugador conserva su ubicacion real, que es justo el problema que A no resolvia.
- Pendiente: probar guardar y volver a cargar tras talar el arbol solapado (confirmar que
  persiste bien); probar en una granja con MAS densidad de objetos alrededor de la cabaña
  para ver cuanto empeora el problema estetico cuando no es un caso casi vacio como este.

### Deteccion de colisiones — script generalizado y prueba del caso critico

Se escribio `Test-FootprintCollision.ps1` (solo lectura, sin tiles hardcodeados: lee
tamaños y posiciones directamente del save) para comprobar ANTES de mover nada que hay
en la huella donde caeria la Farmhouse. Contra `Stardust_443121237` con objetivo
Eltestosteron detecta correctamente: 1 Weeds (ignorable), 1 Chest, 2 Tree.

**Prueba critica — objeto en el CENTRO de la huella (no en el borde):** se genero una
copia (`StardustCentro_920219736`, save `PruebaCentro`) clonando el cofre real del save
(garantiza esquema XML valido) y reubicandolo en el centro geometrico exacto de la huella
nueva (tile 27,33 de 23..31 x 31..35). Resultado confirmado por el usuario en juego:

```text
El cofre NO se abre. No se puede interactuar con el.
```

**Esto corrige la lectura optimista anterior.** El cofre de la prueba `PruebaHipB2` (en
24,34, cerca del porche) parecia accesible porque probablemente cayo fuera de la parte
solida de la huella (zona de puerta/margen caminable), no porque los objetos bajo un
edificio sigan siendo utilizables en general. La realidad confirmada es:

> Un objeto que queda dentro de la huella solida de un edificio NO se borra del archivo,
> pero se vuelve INACCESIBLE en el juego — el jugador no puede interactuar con el. Es una
> perdida funcional aunque no sea una perdida de datos en el XML.

### Alternativa validada — reubicacion automatica en vez de solo bloquear (2026-07-09)

Probado en juego real (`StardustReubica_602876877` / `PruebaReubica`): en vez de bloquear
el swap y pedirle al jugador que despeje la zona a mano, se puede **reubicar
automaticamente** cada elemento bloqueante a un tile libre cercano (busqueda en anillos
crecientes desde su posicion original, evitando pisar buildings/otros objetos/la huella
nueva), sin borrar nada.

**Primer intento fallo a medias:** los 2 arboles reubicados funcionaron perfectamente
(se pueden talar en su nueva posicion), pero el cofre reubicado NO se podia abrir.

**Causa encontrada:** un `Chest` (y previsiblemente otros "big craftables": maquinas,
hornos, etc.) guarda su posicion en DOS sitios distintos dentro del XML:
- `key/Vector2` (la clave del diccionario `objects`, en coordenadas de tile) — esto SI se
  actualizaba.
- `value/Object/boundingBox` (coordenadas en PIXELES = tile*64, con un `Location` interno
  redundante) — esto NO se actualizaba. El juego usa este campo para detectar el clic/
  interaccion, asi que aunque el cofre "existiera" en la nueva posicion en los datos, el
  punto donde el juego detectaba el clic seguia en la posicion vieja (que ahora quedaba
  bajo la casa).

Los `TerrainFeature` (arboles) NO tienen este campo — su posicion es puramente la clave
del diccionario, por eso a ellos les funciono a la primera.

**Fix aplicado y confirmado en juego:** al reubicar, si el objeto tiene `boundingBox`,
actualizar tambien `boundingBox/X`, `boundingBox/Y`, `boundingBox/Location/X`,
`boundingBox/Location/Y` a `nuevoTileX*64`, `nuevoTileY*64` (mantener `Width`/`Height`/
`Size` sin tocar). Con el fix, el cofre reubicado se abre con normalidad.

### Conclusion de producto — dos estrategias validas para F3, a decidir

Con esto hay DOS caminos validados, no uno solo:

**A. Bloquear y pedir al jugador que despeje** (mas simple, cero riesgo de bug de
reubicacion, pero mas friccion: el jugador tiene que ir al juego a mano).

**B. Reubicar automaticamente a un tile libre cercano** (mejor experiencia, cero perdida,
pero mas codigo — hay que portar la logica de "buscar tile libre" y el fix de
`boundingBox`, y **verificar que no existan otros campos ocultos similares para OTROS
tipos de objeto** ya que el bug del cofre demuestra que no todos los objetos se mueven
igual de "limpio"; solo se ha probado Chest y Tree, no maquinas/muebles/otros cultivos).

Cualquiera de las dos es aceptable — ninguna pierde datos. B es mejor UX pero exige mas
cuidado al portar (más superficie de bugs como el de boundingBox). Decision de producto
pendiente de tomar, no cerrada todavia.

Lo que SÍ es una regla dura en ambos casos: **la deteccion de colisiones (ya construida y
validada, en PowerShell y en Dart) es obligatoria antes de tocar nada, y volver a
comprobar justo antes de ejecutar** — ya sea para bloquear o para reubicar.

### Prioridad en cascada al reubicar (2026-07-09) — decisión de producto tomada

En vez de tratar todos los elementos bloqueantes por igual, se define una jerarquia:

0. **Edificios** — intocables, nunca se mueven ni se pisan.
1. **Cultivos plantados y cofres** — importantes para el jugador. Deben quedar CERCA
   de su sitio original (radio corto, probado con 6 tiles). Si el hueco libre mas
   cercano esta ocupado por algo de prioridad 2, ESO se aparta primero (busqueda lejana,
   sin restriccion de cercania) para hacerle sitio. Nunca desplazan edificios ni a otros
   elementos de prioridad 1.
2. **Maleza/arboles/rocas/troncos** — ceden el sitio, se pueden mandar mas lejos
   (radio largo, probado con 20 tiles). `Weeds`/`Grass` ni siquiera se mueven, se ignoran.

Probado en juego real con una granja "sandbox" decorada a mano por el usuario
(3 cofres, 1 cultivo, 2 arboles dentro de la huella nueva): la cascada coloco los 2
cofres y el cultivo a poca distancia de la casa sin necesitar desalojar nada (habia
hueco libre suficiente), y los 2 arboles se mandaron mas lejos. Resultado pendiente de
verificacion final del usuario en el juego (swap `StardustSwapPrioridad_912597629`,
jugador `PruebaPrioridad`).

Scripts de referencia: `Test-DryRunRelocate2.ps1` (solo simula, no escribe — para
revisar antes de ejecutar) y `Test-HostSwap-PriorityRelocate.ps1` (version real).

### Preferencia direccional: nunca reubicar "detras" del edificio (2026-07-09)

Hallazgo del usuario jugando: los objetos reubicados al NORTE de la huella nueva (detras
del edificio, en la direccion opuesta a la puerta) quedan visualmente tapados por el
sprite de la casa en la vista isometrica del juego — la casa "dibuja" hacia arriba en
pantalla mas alla de su propia huella de tiles. Nunca hay que reubicar ahi si se puede
evitar.

Fix aplicado en `Test-HostSwap-PriorityRelocate.ps1`: se añade una puntuacion direccional
a cada tile candidato (norte=1000 muy malo, dentro del rango Y=500 no deberia pasar,
lado=10 aceptable, sur=0 preferido) y se ordena por (puntuacion, distancia).

**Primer intento del fix tenia un bug:** la busqueda seguia explorando anillo por anillo
por distancia creciente y se PARABA en el primer anillo con algun hueco libre, aunque ese
hueco fuera "malo" (norte) y hubiera uno "bueno" (sur) en un anillo ligeramente mas lejano
— nunca llegaba a compararlos. Corregido: ahora se recopilan TODOS los candidatos dentro
del radio maximo de una vez, se ordena por (puntuacion direccional, distancia), y se elige
el mejor global. Verificado en juego: con el fix, un cofre y un cartel que antes quedaban
al norte (detras, invisibles) ahora quedan los dos al sur (delante, visibles).

### Ampliacion de casa (Robin) — el exterior NO cambia de tamaño (2026-07-09)

Verificado con datos reales: en el save `Pleyades_395187544` (ajeno a este proyecto,
usado solo como referencia), el jugador tiene `houseUpgradeLevel=3` (maximo) y el
building `Farmhouse` mide **9x5 — exactamente igual que un Farmhouse nivel 0**
(`Mojomcio_418326337`, `houseUpgradeLevel=0`, tambien 9x5).

Conclusion: **las ampliaciones de Robin solo crecen el INTERIOR de la casa, nunca el
exterior/footprint en el mapa.** Esto es una buena noticia para el swap de anfitrion:
el nivel de ampliacion de cualquiera de los dos jugadores implicados NO afecta al
calculo de la huella ni al intercambio fisico de edificios — es irrelevante para la
logica de F3.

Los farmhands (cabañas) tambien tienen su propio campo `houseUpgradeLevel` en su nodo
`<Farmer>` (confirmado: existe y vale 0 por defecto) — es decir, Robin SI puede ampliar
tambien la cabaña de un farmhand, no solo la Farmhouse del host, tal como el usuario
recordaba. No se ha podido verificar en ningun save real si el interior de una cabaña
ampliada usa una plantilla distinta (no hay ningun save de referencia con cabaña en
nivel >0) — pendiente de comprobar visualmente cuando el usuario amplie una en juego.

**Simular `houseUpgradeLevel` solo con el campo NO es suficiente — la cama lo demuestra.**
Se probo poner `houseUpgradeLevel=1` a un farmhand (sin hacer nada mas) y, al convertirlo
en host, la cama del FarmHouse seguia siendo individual — parecia un bug ("no esta
conectado"?). Verificado con datos reales (`Pleyades_395187544`, ampliacion nivel 3 de
verdad via Robin, jugador SOLTERO): la cama es `Blue Pinstripe Double Bed`
(`bedType=Double`) — doble, y NO depende de estar casado. Ademas hay 2 `Child Bed`
(las habitaciones infantiles que desbloquea el nivel 3).

Conclusion: la cama doble/habitaciones extra son parte de lo que Robin CONSTRUYE de
verdad (muebles nuevos, paredes nuevas) — nuestro flag-only NUNCA lo replico, solo
copiamos el contenido de interior que YA existia entre ubicaciones durante el swap. El
campo `houseUpgradeLevel` por si solo no basta para simular una ampliacion real.
**Implicacion para F3:** el swap de anfitrion en si mismo no necesita tocar
`houseUpgradeLevel` ni el mobiliario — solo mueve lo que YA hay. Simular una ampliacion
de Robin completa (con el mobiliario/habitaciones correctas por nivel) seria una feature
aparte, no resuelta ni necesaria para el cambio de anfitrion.

**Campo clave encontrado: `daysUntilHouseUpgrade`.** Cada `<player>`/`<Farmer>` lo tiene.
`-1` = nada pendiente (ya terminado o nunca empezado). Un numero positivo N = quedan N
dias reales (dormir) para que la construccion de Robin termine. Verificado en el save
original intacto (`Stardust_443121237`): Hirieo y Eltestosteron ambos en `-1` (limpio,
sin nada nuestro tocado). En la copia de pruebas actual, el anfitrion tiene
`daysUntilHouseUpgrade=1` — probablemente de una ampliacion real que el usuario pidio a
Robin durante las pruebas de gameplay, nunca completada porque solo hemos jugado copias
sueltas sin dejar pasar el dia. Hipotesis a confirmar: si esto llega a `-1` (durmiendo una
vez en el juego), el interior deberia regenerarse de verdad (cama doble, habitaciones) —
seria la prueba de que `daysUntilHouseUpgrade` llegando a 0 es lo que dispara el cambio
real, no el flag `houseUpgradeLevel` por si solo. **PENDIENTE de confirmar por el usuario
jugando la copia `StardustSwapPrioridad_106244387` (jugador `HirieoV3`).**

**Resultado: BUG confirmado, no solo confirmacion simple.** El usuario durmio una vez
esperando pasar de nivel 1 a nivel 2 (una mejora), y broke — desde una copia donde nunca
habia tenido NINGUNA mejora real, tras dormir una vez aparecio en nivel 3 (maxima) de
golpe. Hipotesis: la inconsistencia que dejamos (flag `houseUpgradeLevel` puesto a mano
sin que `daysUntilHouseUpgrade` reflejara el mismo estado real) confundio la logica de
Robin, que interpreto que habia VARIAS mejoras encadenadas pendientes y las aplico todas
de golpe/en cascada. **Conclusion practica: NUNCA tocar `houseUpgradeLevel` a mano sin
gestionar tambien `daysUntilHouseUpgrade` de forma consistente — mejor no simular
ampliaciones via flag en absoluto, dejar que Robin las haga siempre de verdad.** Para F3
esto no es un problema (el swap no necesita tocar ninguno de los dos campos, solo mover
lo que ya hay), pero es una trampa a evitar si en el futuro se quiere ofrecer "simular
ampliacion" como atajo de testing.

### Resultado: la ampliacion pendiente SI viaja con el jugador, no con el "puesto"

Confirmado en juego (copia `StardustSwapPrioridad_406081014`): tras el swap, Hirieo
(ahora farmhand) conservo su `daysUntilHouseUpgrade=2` intacto — no se quedo pegado al
puesto de anfitrion, viajo con la persona. El nuevo anfitrion (Eltestosteron) quedo
limpio (`0`/`-1`), como se esperaba.

**CORRECCION (2026-07-09, revision con el usuario):** en la respuesta anterior se dijo
"CONFIRMADO / no es bug nuestro / no bloquea" — ERROR de criterio, corregido aqui. El
usuario tiene razon: aunque cada comportamiento por separado sea normal del juego, la
SITUACION la creamos nosotros. En una partida normal el anfitrion es SIEMPRE el mismo, asi
que su ampliacion siempre progresa (el mundo corre en su maquina). Al hacer el swap cogemos
a un jugador con una obra en marcha —que avanzaba con normalidad— y lo degradamos a
farmhand, un rol donde el juego NUNCA espero que hubiera una ampliacion en curso. Que el
motor "congele" el estado de un farmhand desconectado es normal; que ese farmhand TENGA una
obra pendiente al degradarlo NO es una situacion natural del juego — es consecuencia directa
de nuestro swap. Es un bug nuestro, no una limitacion ajena.

**Mecanismo confirmado por el XML (`StardustSwapPrioridad_406081014`, dia 7):**
- `daysUntilHouseUpgrade` se guarda POR FARMER. Estado actual: anfitrion (Eltestosteron)=2,
  Hirieo (farmhand)=2, farmhand vacio=-1.
- `daysOfConstructionLeft` (construccion fisica de EDIFICIOS de Robin) = todo 0 → la
  ampliacion de casa es un sistema SEPARADO, puramente el contador en el Farmer; Robin solo
  se dibuja martillando donde esta el jugador activo.

**Lo que sigue SIN confirmar (era prematuro darlo por cerrado con un solo snapshot):**
¿el bucle de fin-de-dia del anfitrion decrementa el contador de TODOS los farmers, o solo
el del jugador activo? Con anfitrion y Hirieo ambos a 2, hay un experimento natural montado:
dormir 2-3 noches como anfitrion y releer el XML.
- Si el contador de Hirieo BAJA junto al del anfitrion → no hay bug real, lo de "no sale
  Robin en la cabaña" era solo cosmetico. Nada que arreglar.
- Si se QUEDA en 2 → en single-player la obra de un farmhand desconectado queda congelada
  para siempre (no se puede jugar como Hirieo para desatascarla). Bug real provocado por
  el swap.

**Solucion propuesta — EN EVALUACION en la matriz de pruebas dedicada
(`matriz-pruebas-ampliacion.md`, mismo directorio — ESA es la fuente de verdad para este
tema, no esta seccion).** Estado al cierre de esta seccion: el Bloque A (A1/A2/A3, todo
verificado en XML) mostro que con ambos jugadores conectados una ampliacion pendiente
completa perfecto tras el swap — pero eso cubre UN solo camino (contador sin decrementar,
nivel 0→1, n=1). La decision bloquear/avisar sigue ABIERTA hasta completar A4 (escenario
real: el degradado no vuelve a conectarse) y B3/B4 (obra a medio construir + swap). Lo que
si esta descartado con evidencia: forzar la finalizacion a mano (cascada + cama individual,
ver seccion del bug de `houseUpgradeLevel`).

### Linea base real SIN swap (2026-07-09) — multijugador de verdad, no simulado

Aparte de la prueba con swap, el usuario jugo una partida NORMAL sin ningun swap
(`StardustNormalMax_780186333`, jugador `HirieoRico`) en **multijugador real: dos
dispositivos conectados a la vez**, Hirieo como host y Eltestosteron conectado como
farmhand de verdad. Ambos le pidieron a Robin ampliar su casa el mismo dia — esto NO fue
tocado por ningun script nuestro, es 100% gameplay real. Resultado en el XML: ambos
`daysUntilHouseUpgrade=2` (host y farmhand), confirmando que el campo SI es independiente
por jugador (no hay ningun nodo de equipo/`farmerTeam` compartiendo este estado — buscado
explicitamente en el XML, no existe tal elemento en el documento).

Esto da una linea base perfecta para comparar contra el caso con swap: dejar que el
usuario siga jugando esta partida normalmente (los dos conectados, o probar que pasa si
Eltestosteron se desconecta antes de que termine la construccion) y ver si el contador
avanza con normalidad para ambos. Si en el caso SIN swap todo avanza bien incluso con
desconexiones temporales, y en el caso CON swap se queda parado, eso aislaria
definitivamente que el problema es especifico de la transicion anfitrion→farmhand via
swap (cambio de `<player>` a `<Farmer>` en el XML), no del hecho de estar desconectado
en si.

### Siguiente prueba: swap con una ampliacion REAL en curso

Para probar como se comporta el swap con un caso de verdad (no un flag inventado), se
resetean ambos jugadores a estado limpio (`houseUpgradeLevel=0`,
`daysUntilHouseUpgrade=-1`) y el usuario pide una ampliacion real a Robin jugando como
Hirieo. Con la mejora pendiente (dias > 0, sin completar todavia), se hace el swap y se
observa: ¿la mejora pendiente sigue asociada al mismo jugador tras cambiar de rol
(anfitrion -> farmhand)? ¿se completa con normalidad al dormir el dia que tocaba? ¿se
pierde o se rompe por el cambio de `<player>` a `<Farmer>`?