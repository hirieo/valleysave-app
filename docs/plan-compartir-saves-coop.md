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

### F0 — Investigación y contrato del save (SIN código de producción)

Objetivo: eliminar las incógnitas del cambio de anfitrión ANTES de construir nada.
Todo sobre una COPIA del save real `Stardust_443121237`.

Preguntas que hay que responder empíricamente (con el juego real, SDV 1.6.x):

1. **SaveGameInfo vs `<player>`:** ¿el `SaveGameInfo` es exactamente el nodo `<Farmer>` del
   anfitrión serializado standalone, o difiere (elementos extra/omitidos, namespaces
   `xsi:type`)? Comparar byte a byte tras normalizar.
2. **Asignación de vivienda:** en 1.6 los farmhands viven en `<farmhands>` y la vivienda se
   asigna por campo (`homeLocation` u equivalente en el `<Farmer>`, y/o `owner`/`id` en la
   cabaña dentro de `<locations>`). Identificar EXACTAMENTE qué campos ligan
   jugador↔FarmHouse/cabaña en el save real.
3. **¿El juego carga un save cuya carpeta no coincide con el nombre del anfitrión?**
   Hipótesis: sí (la gente renombra carpetas). Si se confirma → **no renombrar la carpeta
   al cambiar anfitrión**, así el emparejamiento local↔Drive por `folderName`
   (`save_entry.dart:6`) no se rompe. Si se refuta → hay que renombrar carpeta + archivo
   grande y documentar que el save cambia de identidad en ValleySave.
4. **Cartera separada (1.6):** ¿dinero por jugador (`FarmerTeam`/`useSeparateWallets`)?
   ¿Qué pasa con el dinero al intercambiar nodos? Documentar.
5. **Casos que rompen:** matrimonio jugador-jugador, mascotas/caballo con dueño, eventos de
   anfitrión pendientes. Listar cuáles se detectan y se bloquean vs se avisan.
6. **Zip de Drive:** descargar la carpeta de un save desde Drive web y diseccionar el zip
   (¿carpeta en raíz? ¿nombres con sufijos?). El importador debe aceptar ese formato real.

Entregable: `docs/contrato-save-stardew.md` con las respuestas + procedimiento de swap
paso a paso verificado A MANO una vez (editar XML, lanzar el juego, cargar, guardar, comprobar).
**Criterio de salida: el swap manual funciona en el juego real. Si no funciona a mano, F3 se cancela.**

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

### F3 — Cambio de anfitrión (EXPERIMENTAL, gated por F0)

Solo si F0 valida el procedimiento a mano. Operación 100 % local (funciona sobre saves
importados o propios).

**Nuevo `lib/core/services/host_swap_service.dart`:**
1. Backup obligatorio: copiar carpeta a `<folder>.backup-<timestamp>` ANTES de tocar nada.
2. Parsear el archivo grande, localizar `<player>` y el `<Farmer>` elegido en `<farmhands>`.
3. Intercambiar los nodos completos + los campos de vivienda identificados en F0.2.
   Los `UniqueMultiplayerID` viajan CON su jugador (no se intercambian).
4. Regenerar `SaveGameInfo` desde el nuevo `<player>` según el contrato de F0.1.
5. Renombrar o no la carpeta según el resultado de F0.3 (preferencia: NO renombrar).
6. Validación post-swap: re-parsear con `SaveService`; el nuevo anfitrión aparece como
   `isHost=true`; nº de jugadores intacto. Si algo falla → restaurar backup automáticamente.
7. Detección de bloqueantes ANTES de ejecutar (matrimonio jugador-jugador, etc., lista de F0.5)
   → si se detecta, abortar con explicación.

**UI (preview obligatorio):** en la hoja de detalle, con el selector de jugador en un
farmhand → acción "Hacer anfitrión" con diálogo de advertencia fuerte (operación
experimental, se crea backup, el original queda en `.backup`). Badge "EXPERIMENTAL".

**Tests:** unit sobre copia del save Stardust (swap Hirieo⇄Eltestosteron y vuelta;
idempotencia del doble swap; validación de rollback). Verificación final: cargar el save
intercambiado EN EL JUEGO y jugar un día (manual, con el usuario).

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

## 8. Riesgos principales

| Riesgo | Mitigación |
|---|---|
| Zip malicioso (zip-slip, bomba de descompresión) | Saneo de rutas + límites de tamaño/nº archivos (F1.2). **Obligatorio, no recortable.** |
| Swap de anfitrión corrompe el save | F0 manual primero; backup automático + rollback; badge EXPERIMENTAL; validación post-swap |
| Receptor espera ver el save "aparecer" en su app | UX explícita + pantalla de ayuda (F2); email de notificación de Google |
| Rol writer mal entendido (receptor borra la copia del emisor) | Aviso explícito al conceder escritura |
| Renombrar carpeta rompe emparejamiento local↔Drive | Preferencia: no renombrar (validar en F0.3) |
| SDV cambia el formato del save en una versión futura | El contrato vive en `docs/contrato-save-stardew.md` con la versión del juego anotada |
