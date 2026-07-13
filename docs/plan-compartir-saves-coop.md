# Plan — Compartir saves entre usuarios + cambio de anfitrión

> **Para quien ejecute este plan** (cualquier modelo de Claude Code, sesión nueva sin contexto):
> este documento es autocontenido. Léelo entero antes de tocar código. Las afirmaciones
> sobre el código actual están verificadas con `archivo:línea` a fecha 2026-07-09
> (rama `licendev`, post v0.1.18). Revalida las referencias si el código ha cambiado.

---

## 1. Contexto del proyecto (mínimo necesario)

ValleySave sincroniza saves de Stardew Valley entre dispositivos del MISMO usuario vía
Google Drive. Flutter multiplataforma (Windows + Android activos). Serverless: no hay
backend propio, solo la API de Drive con OAuth del usuario.

Hechos verificados que condicionan este plan:

| Hecho | Dónde |
|---|---|
| Scope OAuth = `drive.file` (solo archivos creados por la app o abiertos con Picker) | `lib/core/services/auth_service.dart:14` |
| Estructura en Drive: carpeta raíz `ValleySave/` → subcarpeta por save → archivos + `players.json` | `lib/core/services/drive_service.dart` (`ensureFolder`, `uploadSave`, `_playersJsonName`) |
| Emparejamiento local↔Drive por `folderName` (= `NombreHost_uniqueIDForThisGame`) | `lib/core/models/save_entry.dart:6-15` |
| Parser del save grande ya existe: extrae `<player>` (anfitrión) + `<farmhands><Farmer>` (SDV 1.6), incluye `UniqueMultiplayerID` | `lib/core/services/save_service.dart:189-252` |
| Modelo por-jugador ya existe (`PlayerStats`, con `isHost`, `uniqueId`, JSON) | `lib/core/models/player_stats.dart` |
| Android escribe en la carpeta del juego vía root/Shizuku (`pushSaveAsRoot`) | `lib/core/services/shizuku_service.dart:83`, `MainActivity.kt` |
| Feature coop (mostrar todos los jugadores + selector) COMPLETA y publicada (v0.1.18) | tarjeta, hoja de detalle, diálogo de comparación |

Save de prueba real (coop): `C:\Users\Hirieo\AppData\Roaming\StardewValley\Saves\Stardust_443121237`
— anfitrión "Hirieo" + farmhand "Eltestosteron" + 1 cabaña vacía. **Usar este save para toda validación.**

Reglas del proyecto que el ejecutor DEBE respetar (de `CLAUDE.md` y `.claude/rules/`):
- Rama única de desarrollo `licendev`. Nunca a `main` sin pregunta explícita.
- Ningún cambio sin aprobación previa del usuario. Cambios estéticos: SIEMPRE preview
  renderizado (HTML/SVG) de cada opción antes de implementar.
- No compilar/lanzar la app sin orden directa.
- i18n: cada string nueva va a los 14 ARB de `lib/l10n/` y se regenera. Import de
  AppLocalizations por ruta relativa (`../../generated/app_localizations.dart`), nunca `flutter_gen`.
- No tocar `*.env`, claves, keystore.

---

## 2. Análisis de valor — ¿por qué existe esta feature?

**Solitario:** valor bajo. La app ya resuelve "mi partida en mis dispositivos". Mandar tu
save en solitario a otra persona es un regalo/rescate puntual — está bien tenerlo, no
justifica la feature por sí solo.

**Cooperativo:** valor alto y es el motivo real. En Stardew coop **solo existe el save del
anfitrión** — los farmhands no tienen copia de la granja. Si el anfitrión desaparece
(deja de jugar, pierde el PC, se enfada), el grupo entero pierde la granja. Esta feature
rompe esa dependencia:

1. El anfitrión comparte el save desde Drive.
2. Otro jugador lo importa a su ValleySave.
3. Ese jugador **se convierte en anfitrión** (cambio de anfitrión, Fase 3) y el grupo sigue jugando.

**¿Integrado en la app o aparte?** Integrado. Reutiliza DriveService, SaveService (parser),
la UI de tarjetas/detalle y el canal root/Shizuku de Android. Una herramienta aparte
duplicaría auth + parser + UI. Además encaja con la identidad del producto: "gestor de
partidas", no solo "sincronizador". El transporte para solitario sale gratis del mismo
mecanismo; no se construye nada extra para ese caso.

---

## 3. Restricciones duras (no negociables sin decisión del usuario)

1. **Solo se comparte desde Drive.** El save debe estar subido a Drive antes de poder
   compartirse (restricción de producto elegida por el usuario + limitación técnica:
   con `drive.file` la app solo puede gestionar permisos de archivos que ella creó).
   Si el save solo existe en local → la UI ofrece "Subir primero".
2. **No hay "compartidos conmigo" automático.** `drive.file` no permite listar lo que otros
   compartieron contigo. El receptor NO verá el save aparecer solo en su app. Recepción v1:
   el receptor descarga desde la web/app de Google Drive ("Compartido conmigo" → Descargar →
   Drive genera un `.zip` él solo) y lo importa en ValleySave. Google Picker embebido = v2, no v1.
3. **Ampliar el scope OAuth está descartado** (decisión cerrada previa: assessment CASA de
   Google, meses, contradice scope mínimo). No proponerlo de nuevo.
4. **Permisos reales solo mientras el archivo vive en Drive.** Cuando el receptor tiene los
   bytes, puede hacer lo que quiera con su copia. "Lectura vs escritura" aplica a la copia
   en Drive del emisor (roles `reader`/`writer` de la API de permisos), no a la copia
   descargada. Documentarlo en la UI para no vender humo.

---

## 4. Arquitectura de la feature

Tres piezas independientes que convergen:

```
EMISOR                                    RECEPTOR
──────                                    ────────
save subido a Drive                       Drive web/app: "Compartido conmigo"
   │                                         │  (descarga → Drive lo zipea solo)
   ▼                                         ▼
[F2] Compartir permiso                    zip en el dispositivo
   permissions.create(email, role)           │
   gestión: listar / cambiar rol /           ▼
   revocar (descompartir)                 [F1] Importar zip
                                             validar → sanear → extraer →
                                             colocar en Saves/ local
                                             │
                                             ▼
                                          [F3] Cambio de anfitrión (opcional, local)
                                             farmhand elegido ⇄ <player>
                                             │
                                             ▼
                                          jugar + subir a SU Drive (botón ya existente)
```

Además [F1-export]: botón "Exportar" que genera el mismo zip localmente (share sheet en
Android, "Guardar como…" en Windows). Sirve para mandar por WhatsApp/email sin pasar por
permisos de Drive, y para probar el importador. Mismo formato de zip que genera Drive
(carpeta del save en la raíz del zip) para que el importador sea ÚNICO.

**Regla de oro:** el importador no distingue el origen del zip (Drive nativo, export
nuestro, email). Un solo código de importación.

---

## 5. Fases

### F0 — Investigación y contrato del save — **HECHA, gate superado**

> Investigación realizada el 2026-07-08/09 por el usuario con asistencia de otra IA,
> **validada en el juego real** (no solo en teoría) sobre copias de `Stardust_443121237`.
> Documentos completos en [`docs/host-swap-research/`](host-swap-research/):
> - [`stardew-host-swap-investigacion.md`](host-swap-research/stardew-host-swap-investigacion.md) — hallazgos, 6 pruebas iterativas (`prueba6`-`prueba11`), conclusión validada por el usuario en partida real.
> - [`Promote-StardewHost.ps1`](host-swap-research/Promote-StardewHost.ps1) — script PowerShell **funcional y probado**, hace el swap completo. Es la referencia de la que F3 debe portar la lógica a Dart, no reinventarla.
>
> **Hay un tercer documento relacionado que NO se copió a este repo a propósito:**
> `stardew-dedicated-host-investigacion.md` explora un concepto DISTINTO (un "dedicated
> host" / servidor automatizado sin jugador humano, usando `Game1.dedicatedServer` /
> `IsDedicatedHost` internos del juego). Esa investigación se enmarca explícitamente como
> *"posible proyecto independiente de ValleySave App"* — **no es parte de este plan.** Si
> se retoma, es un proyecto aparte (servidor 24/7), no una feature de la app. No confundir
> ambos documentos en sesiones futuras.

**Resultado de las 6 preguntas originales:**

1. **SaveGameInfo vs `<player>`** — Respondida indirectamente: el script regenera
   `SaveGameInfo` copiando los nodos del nuevo `<player>` y fijando explícitamente
   `homeLocation=FarmHouse`, `slotCanHost=true`, `useSeparateWallets=true`, y usa el
   nombre del jugador como nodo raíz. Esto ya es el contrato — no hace falta comparación
   byte a byte adicional, el script demuestra qué campos hay que sincronizar.
2. **Asignación de vivienda** — Respondida y confirmada en juego real. El vínculo es:
   `farmhand.homeLocation == cabin.indoors.uniqueName`. El host SIEMPRE vive en
   `homeLocation=FarmHouse` (literal, no una cabaña). El edificio `Farmhouse` no tiene
   `skinId`; los `Cabin` sí (`Log Cabin`, `Stone Cabin`, etc. — 6 skins).
3. **¿Renombrar carpeta rompe el emparejamiento?** — **Resuelta, y al revés de la hipótesis
   original.** El script SIEMPRE crea una copia nueva con `uniqueIDForThisGame` distinto
   (`Set-ElementValue $root "uniqueIDForThisGame" ([string]$new.Id)`) y carpeta con nombre
   nuevo. No es una limitación técnica evitable — cambiar quién es el host cambia la
   identidad de la partida a nivel de motor. **Decisión para F3: el swap SIEMPRE produce
   un save local nuevo (nueva entrada en ValleySave), nunca modifica en sitio.** Esto de
   hecho simplifica F3 (no hace falta lógica de backup/rollback in-place — el original
   queda intacto por diseño, ver algoritmo actualizado abajo).
4. **Cartera separada** — Parcialmente respondida: el script fija `useSeparateWallets=true`
   siempre en la copia, sin preservar el valor original. **Esto es una decisión de diseño
   del script, no una investigación exhaustiva** — sigue abierto si `useSeparateWallets=false`
   original debería preservarse en vez de forzarse (añadido a §7).
5. **Casos que rompen (matrimonio jugador-jugador, mascotas, eventos pendientes)** —
   **NO investigado.** Sigue abierto, bloqueante antes de que F3 pierda el badge EXPERIMENTAL.
6. **Zip de Drive** — No relacionado con el swap, sigue abierto para F1 (ver F1).

**Nota sobre la restricción de "2 cabañas" del primer script (superada):** el script
original (`Promote-StardewHost.ps1`) requería una cabaña de repuesto para realojar al host
saliente. La versión simplificada y validada (`Test-HostSwap-HipB.ps1`, ver "Continuación
2026-07-09" más abajo) NO necesita una segunda cabaña — el host saliente hereda
directamente la cabaña del objetivo (que solo cambia de tile). Esta restricción ya NO
aplica al diseño actual de F3. La restricción real que sí aplica es la de colisiones de
huella, ver más abajo.

**Hallazgo nuevo — límite estético confirmado, no un "quizás":** el script tiene
`KeepExterior` (intentar que el nuevo host conserve la estética de cabaña) explícitamente
**desactivado con `throw`**, con el comentario: *"la prueba valida mostró que Stardew
convierte/ubica la FarmHouse según su lógica interna y no conserva la cabaña visual
original"*. `SwapExterior` (intercambiar los edificios físicamente) es el ÚNICO modo
viable. La casa del nuevo anfitrión SIEMPRE se verá como la Farmhouse grande, no como
cabaña. Es una limitación del juego, no de la implementación — se acepta y se comunica.

**Texto de aviso ya redactado (reusar en la UI de F3):**
> *"Este cambio convierte al farmhand seleccionado en anfitrión real de la partida y
> conserva su progreso, inventario, dinero, interior de casa y ubicación. Sin embargo,
> Stardew Valley asocia el anfitrión a la Farmhouse principal, por lo que la casa del
> nuevo anfitrión se verá como la casa grande del juego. La estética original de cabaña
> no está soportada sin mods."*

**Criterio de salida cumplido:** el swap funciona en el juego real, confirmado por el
usuario jugando la copia (`prueba11` / `StardustHostStable_347194893`). F3 queda
desbloqueada, con las restricciones y decisiones abiertas listadas arriba.

**F0.6 — Interacción con ampliaciones de casa de Robin (`daysUntilHouseUpgrade`),
CERRADA (2026-07-10):** investigación aparte tras detectar que el swap podía dejar a un
jugador con obra pendiente colgado sin forma de completarla. Matriz completa de pruebas
en [`matriz-pruebas-ampliacion.md`](host-swap-research/matriz-pruebas-ampliacion.md):
validado en juego real y verificado en XML que una ampliación pendiente sobrevive el
swap sin corrupción en todos los escenarios probados (ambos conectados, degradado
desconectado y reconectado después, obra a medio construir en los dos sentidos).
Decisión del usuario: no hace falta bloqueo ni aviso especial por este motivo.

### F1 — Exportar + Importar (una sola entrega, inseparables)

> Exportar sin importar no sirve: el zip llega muerto. Las dos mitades salen juntas.

**Nuevo `lib/core/services/transfer_service.dart`:**
- `Future<File> exportSave(String folderPath)` — zipea la carpeta del save (paquete `archive`),
  carpeta en la raíz del zip. Nombre: `<folderName>.zip`.
- `Future<ImportResult> importSave(String zipPath)` — pipeline:
  1. Abrir zip, localizar la carpeta del save (tolerar zip de Drive y zip propio).
  2. **Seguridad (no opcional):** rechazar entradas con `..`, rutas absolutas, symlinks;
     límite de tamaño descomprimido (p.ej. 500 MB); límite de nº de archivos.
  3. Validar que es un save real: existe `SaveGameInfo` + archivo grande con `<SaveGame>`
     parseable por `SaveService.parseFullSave` (reutilizar, no duplicar).
  4. Extraer a directorio temporal → mover atómicamente a `Saves/`
     (Windows: copia directa; Android: `pushSaveAsRoot`/Shizuku existente).
  5. Conflicto (ya existe `folderName`): diálogo sobrescribir/cancelar. Reutilizar el
     diálogo de confirmación rediseñado de `saves_screen.dart` (fondo negro, `ActionBtn`).
     "Importar como copia" queda FUERA de v1 (renombrar carpeta tiene implicaciones de
     emparejamiento — anotado en §7 Decisiones abiertas).

**Dependencias nuevas:** `archive` (zip puro Dart), `file_picker` (elegir zip),
`share_plus` (share sheet Android). En Windows, exportar = diálogo "Guardar como…"
(`file_picker` saveFile), no share sheet. Verificar compatibilidad de versiones con el
`pubspec.lock` actual antes de añadir.

**UI (preview obligatorio antes de implementar):**
- Acción "Exportar" en la hoja de detalle (cara local).
- Botón/acción "Importar partida" en la pantalla de Saves (ubicación pendiente de
  decisión del usuario — preguntar con preview de opciones).

**Tests:** unit del pipeline de import (zip válido, zip con `../`, zip sin SaveGameInfo,
zip gigante, zip de Drive real de F0.6). Golden path con copia del save Stardust.

### F2 — Compartir desde Drive (emisor) + gestión de permisos

**Ampliar `drive_service.dart`:**
- `shareSave(String saveFolderId, String email, {required bool canWrite})` →
  `permissions.create` (type `user`, role `reader`|`writer`, `sendNotificationEmail: true`
  — el receptor recibe email de Google, así descubre el save sin que la app pueda listarlo).
- `listPermissions(saveFolderId)` → `permissions.list` ($fields: id, emailAddress,
  displayName, role). Filtrar al propio owner.
- `unshareSave(saveFolderId, permissionId)` → `permissions.delete` (descompartir).
- `updatePermission(saveFolderId, permissionId, role)` → cambiar lectura⇄escritura.

Todo opera sobre la subcarpeta del save dentro de `ValleySave/` — creada por la app,
por tanto permitido con `drive.file`.

**UI (preview obligatorio):**
- Acción "Compartir" en tarjeta/hoja de detalle — SOLO habilitada si el save está en Drive
  (si no: CTA "Subir primero").
- Sheet de gestión: lista de personas con acceso (nombre/email + rol), añadir por email
  con selector lectura/escritura, revocar, cambiar rol.
- Texto honesto en la UI: "El permiso controla tu copia en Drive. Si le das el archivo,
  la copia descargada es suya."
- Pantalla/sección de ayuda para el receptor (cómo descargar de "Compartido conmigo" e
  importar). Añadir tarjeta en `how_it_works_screen.dart`.

**Advertencia rol escritura:** `writer` sobre la carpeta del emisor permite al receptor
MODIFICAR/BORRAR la copia en Drive del emisor. Mostrar aviso explícito al elegirlo.

**Tests:** mocks de la API de permisos; validación de email; estados de la sheet.

### F3 — Cambio de anfitrión (EXPERIMENTAL, gate de F0 superado)

Operación 100 % local (funciona sobre saves importados o propios). El algoritmo YA está
validado en juego real por el usuario, en varias iteraciones:

- [`Promote-StardewHost.ps1`](host-swap-research/Promote-StardewHost.ps1) — primer script,
  de otra investigación. **Descartado como base**: usa una "cabaña de repuesto" (3er
  edificio) y auto-limpia (`Clean-BuildingFootprint`) sin avisar, lo que en pruebas
  posteriores demostró que puede dejar objetos INACCESIBLES (ver hallazgo de colisiones
  abajo). No portar este script tal cual.
- [`Test-HostSwap-HipB.ps1`](host-swap-research/Test-HostSwap-HipB.ps1) — versión simplificada
  y validada en juego real (`PruebaHipB2`): swap directo de 2 edificios (Farmhouse ⇄ cabaña
  del objetivo), sin cabaña de repuesto, sin auto-limpieza. Superada por la siguiente.
- [`Test-HostSwap-PriorityRelocate.ps1`](host-swap-research/Test-HostSwap-PriorityRelocate.ps1) —
  **esta es la base a portar a Dart.** Añade sobre HipB la reubicación automática por
  prioridad (cultivos/cofres cerca, maleza/árboles lejos, nunca al norte de la casa — el
  sprite los tapa visualmente) y el fix de `boundingBox` para objetos "grandes" (`Chest` y
  previsiblemente otros big-craftables), sin el cual el objeto reubicado queda inaccesible
  al clic aunque los datos digan que se movió. Validado en juego real (`StardustReubica_*`,
  `StardustSwapPrioridad_912597629`/`PruebaPrioridad`).
- [`Test-FootprintCollision.ps1`](host-swap-research/Test-FootprintCollision.ps1) — detector
  de colisiones de solo lectura, generalizado (sin tiles hardcodeados). Sigue siendo la
  precondición obligatoria — ya no para bloquear, sino para saber qué reubicar.

Todo el razonamiento y las pruebas están en
[`stardew-host-swap-investigacion.md`](host-swap-research/stardew-host-swap-investigacion.md)
(secciones "Continuacion 2026-07-09" en adelante) — léelo antes de portar código, contiene
los hallazgos que invalidan partes del primer script.

**Restricción dura confirmada en juego real:** el host SIEMPRE vive en el edificio
`Farmhouse` (9x5) — el motor no permite host en una `Cabin` (crashea o falla). Como la
cabaña del jugador es más pequeña (5x3), mover la Farmhouse a su sitio invade tiles
vecinos. **Confirmado también en juego:** sin limpieza automática, el motor NO borra nada
al superponer el edificio — pero **cualquier objeto que caiga dentro de la huella sólida
del edificio (no solo cerca) se vuelve inaccesible** (probado con un cofre en el centro
exacto de la huella: no se puede abrir). No es pérdida de datos en el XML, pero sí pérdida
funcional para el jugador — inaceptable sin más.

**Precondiciones bloqueantes (verificar ANTES de ofrecer la acción en la UI, y otra vez
justo antes de ejecutar):**
1. La cabaña del objetivo existe y su `indoors.uniqueName` coincide con su `homeLocation`.
2. **Detección de colisiones** (`Test-FootprintCollision.ps1` portado): calcular la huella
   que ocuparía la Farmhouse en el tile de la cabaña del objetivo, y escanear
   `objects`/`terrainFeatures`/`largeTerrainFeatures`/`resourceClumps` de la location `Farm`
   dentro de esa huella. **Decisión validada en juego real (2026-07-09, superó la idea
   original de bloquear):** si hay elementos que no sean `Weeds`/`Grass`, **reubicarlos
   automáticamente** por prioridad (cultivos/cofres a radio corto, pueden desalojar a
   maleza/árboles/rocas si hace falta; estos ceden el sitio a radio largo) en vez de
   bloquear el swap. Mostrar siempre al jugador qué se detectó y a dónde se reubicó cada
   cosa — transparencia, nunca silencio. Nunca borrar nada (ver algoritmo, paso 11).

**Nuevo `lib/core/services/host_swap_service.dart`, algoritmo (adaptado de
`Test-HostSwap-PriorityRelocate.ps1`, validado):**
1. **Siempre produce una copia nueva**, nunca modifica el save original in situ (`Copy-Item`
   a carpeta con ID aleatorio nuevo). El save original queda intacto — no hace falta
   backup/rollback separado, la copia ES el mecanismo de seguridad.
2. Nuevo `uniqueIDForThisGame` aleatorio para la copia → nuevo `folderName` → aparece en
   ValleySave como una **entrada de save distinta**, no sustituye a la original.
3. Ejecutar la detección de colisiones (precondición de arriba). Si hay elementos que
   reubicar, ejecutar la cascada de prioridad (paso 11) ANTES de tocar el swap en sí —
   mostrar al usuario qué se movió y a dónde antes de continuar.
4. Localizar en el archivo grande: `<player>` (host actual), `<farmhands><Farmer>` objetivo,
   location `Farm`, location `FarmHouse` de nivel superior, building `Farmhouse`, building
   `Cabin` del objetivo (por `indoors.uniqueName == target.homeLocation`).
5. Clonar ambos nodos de jugador completos ANTES de tocar nada — evita corrupción por
   referencias compartidas al mutar in-place.
6. Nuevo host: reemplazar contenido de `<player>` con el nodo del farmhand objetivo; fijar
   `homeLocation=FarmHouse`, `slotCanHost=true`. `useSeparateWallets`: recomendación de este
   plan es preservar el valor original del save en vez de forzarlo a `true` (a diferencia
   del script de referencia original) — **sigue como decisión abierta, ver §7 punto 6,
   pendiente de confirmar con el usuario.**
7. Host saliente: reemplazar el `<Farmer>` objetivo con el nodo del host antiguo (con su
   `UniqueMultiplayerID` — el ID SIEMPRE viaja con su jugador, nunca se reasigna); asignar
   como `homeLocation` el `uniqueName` de la cabaña del objetivo (la misma cabaña, ahora
   físicamente en otro tile); `slotCanHost=false`.
8. Intercambiar físicamente los tiles de los 2 edificios (Farmhouse ⇄ cabaña del objetivo).
   Es el único modo viable (`SwapExterior`; `KeepExterior` crashea, ver hallazgo F0).
9. Copiar el contenido de interior (lista exacta de campos, ver `$ContentFields` en
   `Test-HostSwap-PriorityRelocate.ps1`: `buildings, animals, piecesOfHay, characters, objects,
   resourceClumps, largeTerrainFeatures, terrainFeatures, numberOfSpawnedObjectsOnMap,
   miniJukeboxCount, miniJukeboxTrack, furniture, Animals, IsGreenhouse, wallPaper,
   appliedWallpaper, floor, appliedFloor, fridge, fridgePosition, cribStyle`) entre la
   cabaña del objetivo y el `FarmHouse` global, en ambos sentidos.
10. Fijar los campos de identidad tras copiar contenido — **paso que faltó en el primer
    intento de prueba y causó que el save no apareciera en el juego, no saltar**: en el
    `FarmHouse` global, `name="FarmHouse"` + `isStructure="false"`; en el `indoors` de la
    cabaña (ahora en el tile de la vieja Farmhouse), `name="Cabin"` + `uniqueName` (sin
    cambiar, sigue siendo el mismo) + `isStructure="true"` + `farmhandReference` = ID del
    host saliente + `nonInstancedIndoorsName` nil.
11. **Reubicación por prioridad, nunca borrado.** Portar la cascada de
    `Test-HostSwap-PriorityRelocate.ps1`: prioridad alta (cultivos/cofres) a radio corto
    (probado 6 tiles), pueden desalojar a prioridad baja (maleza/árboles/rocas) que se
    manda a radio largo (probado 20 tiles); `Weeds`/`Grass` ni se mueven. Puntuación
    direccional obligatoria (norte=1000 evitar, sur=0 preferido, lado=10 aceptable) —
    explorar TODO el radio antes de elegir, no parar en el primer hueco libre (bug ya
    corregido en el script: un hueco cercano malo no debe ganarle a uno lejano bueno).
    **Crítico:** si el objeto tiene `boundingBox` (Chest y previsiblemente otros
    big-craftables), actualizar también `boundingBox/X`, `boundingBox/Y`,
    `boundingBox/Location/X`, `boundingBox/Location/Y` a `nuevoTileX*64`/`nuevoTileY*64` —
    si no, el objeto se mueve en los datos pero el punto de clic se queda en el sitio
    viejo (inaccesible). No portar `Clean-BuildingFootprint` (el borrado automático del
    script original) — nunca borrar, solo mover. Solo se ha validado con `Chest` y
    `Tree`; verificar antes de asumir que otros tipos (máquinas, muebles) se comportan
    igual de "limpio".
12. Regenerar `SaveGameInfo` desde el nuevo `<player>`: nodo raíz con el nombre del nuevo
    host, mismos campos fijados que en el paso 6.
13. Guardar el archivo grande y `SaveGameInfo` (UTF-8 sin BOM, sin indentado, ANTES de
    cualquier lectura posterior — el bug del primer intento fue guardar antes de aplicar
    el cambio de nombre; aplicar todos los cambios al documento en memoria antes de guardar).
14. Validación post-swap: re-parsear la copia con `SaveService.parseFullSave`; el nuevo
    host debe aparecer con `isHost=true`; nº de jugadores intacto. Si algo falla, la copia
    se descarta (el original, intacto, nunca se tocó).
15. Bloqueantes NO cubiertos todavía (F0.5, sigue sin investigar): matrimonio
    jugador-jugador, mascotas con dueño, eventos de anfitrión pendientes. Avisar
    genéricamente en la UI en vez de prometer detección automática hasta investigarlo.

**UI (preview obligatorio):** en la hoja de detalle, con el selector de jugador en un
farmhand → acción "Hacer anfitrión". Diálogo de advertencia con el texto de F0 (arriba),
dejando claro que se crea una partida NUEVA (no se modifica la actual). Si la detección de
colisiones encuentra bloqueantes, mostrar la lista (tile + tipo) en vez del botón de
confirmar — el jugador debe despejarlo en el juego y volver a intentarlo. Badge "EXPERIMENTAL".

**Tests:** unit sobre copia del save Stardust (swap Hirieo⇄Eltestosteron; validar contra
los valores conocidos de `stardew-host-swap-investigacion.md` §"Detalle del XML estable").
Verificación final: cargar la copia resultante EN EL JUEGO (manual, con el usuario) —
ya validado una vez con el script; repetir tras portar a Dart para confirmar equivalencia.

### F4 — Fuera de alcance (registrado, no planificado)

- Google Picker embebido para importar desde Drive sin salir de la app (webview; evaluar solo si F1/F2 se quedan cortas).
- "Granja compartida viva": emisor y receptor sincronizando LA MISMA carpeta de Drive con
  rol writer. Potente para grupos coop estables, pero sin locking hay pisadas de datos.
  Requiere diseño propio de conflictos. No abordar sin spec dedicada.

---

## 6. Orden de ejecución y entregas

```
F0 (investigación, sin riesgo) ──► decide viabilidad de F3
F1 (export+import juntos)      ──► release: transferencia funciona end-to-end vía zip
F2 (compartir Drive + gestión) ──► release: flujo "desde Drive" completo del emisor
F3 (cambio de anfitrión)       ──► release: valor coop completo. EXPERIMENTAL.
```

F1 y F2 son independientes entre sí (F2 puede adelantarse), pero ninguna entrega tiene
sentido de cara al usuario sin F1 (sin importador nada se puede recibir). F0 puede
ejecutarse en paralelo a F1/F2.

---

## 7. Decisiones abiertas (preguntar al usuario en su momento, no asumir)

1. Ubicación del botón "Importar partida" en la pantalla de Saves (con preview de opciones).
2. Rol por defecto al compartir: ¿solo lectura y escritura como opción avanzada con aviso?
3. Conflicto de importación: v1 = sobrescribir/cancelar. ¿Se quiere "importar como copia"
   más adelante? (implica renombrar carpeta → nuevo `folderName` → save "distinto" para el sync).
4. ¿Exportar también desde la cara Drive (descargando primero a temp) o solo desde local? (v1: solo local.)
5. Nomenclatura visible: "Compartir" (Drive) vs "Exportar" (zip) — validar que el usuario
   distingue ambas en la UI sin confusión.
6. **`useSeparateWallets` en F3:** el script de referencia lo fuerza siempre a `true` en la
   copia. ¿Se preserva el valor original del save en vez de forzarlo? Necesita
   investigación adicional (F0.4 quedó sin cerrar del todo) antes de decidir.
7. **F0.5 sin investigar** (matrimonio jugador-jugador, mascotas con dueño, eventos de
   anfitrión pendientes): ¿se investiga antes de lanzar F3, o se lanza con aviso genérico
   de "casos no probados" y badge EXPERIMENTAL más fuerte? Afecta cuánto se puede prometer
   en la UI de F3.
8. **Nombre/identidad visible de la copia tras el swap:** el script pide nombre de jugador
   pero no un nombre de "prueba" para identificar la copia en ValleySave. ¿Cómo se etiqueta
   la nueva entrada de save para que el usuario entienda que es "la misma partida, con otro
   anfitrión" y no un save totalmente nuevo sin relación?

## 8. Riesgos principales

| Riesgo | Mitigación |
|---|---|
| Zip malicioso (zip-slip, bomba de descompresión) | Saneo de rutas + límites de tamaño/nº archivos (F1.2). **Obligatorio, no recortable.** |
| Swap de anfitrión corrompe el save | Algoritmo validado en juego real (`Test-HostSwap-PriorityRelocate.ps1`, no el script original); siempre produce copia nueva, original intacto; validación post-swap antes de aceptar la copia |
| Objeto/cultivo/cofre bajo la huella nueva queda inaccesible (confirmado en juego, no destruido pero sí inutilizable) | Detección de colisiones OBLIGATORIA antes de ejecutar — reubicación automática por prioridad (nunca borra, nunca bloquea), con el fix de `boundingBox` para objetos con ese campo (§F3, ver `Test-HostSwap-PriorityRelocate.ps1`) |
| Ampliación de Robin (`daysUntilHouseUpgrade`) pendiente en cualquiera de los dos jugadores durante el swap | Investigado a fondo y CERRADO (2026-07-10): sobrevive el swap intacta en todos los escenarios probados (ambos conectados, degradado desconectado y reconectado después, obra a medio construir en los dos sentidos) — ver `matriz-pruebas-ampliacion.md`. Sin bloqueo especial necesario. |
| Receptor espera ver el save "aparecer" en su app | UX explícita + pantalla de ayuda (F2); email de notificación de Google |
| Rol writer mal entendido (receptor borra la copia del emisor) | Aviso explícito al conceder escritura |
| Casos no investigados rompen el swap (matrimonio, mascotas, eventos pendientes) | F0.5 sin cerrar — badge EXPERIMENTAL + aviso genérico hasta investigarlo (decisión abierta #7) |
| SDV cambia el formato del save en una versión futura | Los documentos de investigación en `docs/host-swap-research/` anotan la versión del juego (1.6.15.x); revalidar si SDV publica una actualización mayor |
| Confundir esta feature con la investigación de "dedicated host" (servidor 24/7) | Son proyectos distintos — ver nota en F0. No mezclar alcance. |
