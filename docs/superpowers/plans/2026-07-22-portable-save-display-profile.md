# Perfil visual portátil PC ↔ móvil Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Permitir que el mismo save viaje entre PC, móvil, Mi Drive y un Drive compartido sin transportar escalas, barra, reloj, resolución ni controles propios del dispositivo de origen.

**Architecture:** El contenido de Drive y de los backups sigue siendo una copia íntegra y agnóstica respecto a su próximo destino; nunca se modifica al subir porque todavía no se sabe dónde se abrirá. La adaptación ocurre únicamente al materializar el save en la carpeta del juego del dispositivo destino: se extrae un perfil visual del save local que va a reemplazarse —o de las preferencias locales de Stardew— y se superpone al XML entrante dentro del staging transaccional. Si no existe perfil local, se retiran solo los campos dependientes del dispositivo para que la versión nativa de Stardew aplique sus valores por defecto.

**Tech Stack:** Dart, `xml`, `dart:io`, `SaveReplaceService`, puente root/Shizuku, Flutter tests.

---

## Regla central

**Se adapta al descargar/restaurar/importar en el destino; nunca al subir.**

Esto evita adivinar si una copia subida desde PC acabará en otro PC, Android, Mi Drive o un Drive compartido. También impide que un jugador cambie la interfaz de los demás al escribir en una partida compartida.

## Flujo completo

| Operación | Copia remota/zip | Acción en destino |
|---|---|---|
| PC → Mi Drive/Drive compartido | Se sube sin normalizar | Ninguna todavía |
| Móvil → Mi Drive/Drive compartido | Se sube sin normalizar | Ninguna todavía |
| Drive → PC | Remoto intacto | Superponer perfil PC en staging y publicar |
| Drive → móvil | Remoto intacto | Superponer perfil móvil en `game_out` y empujar vía root/Shizuku |
| Backup → PC/móvil | Zip intacto | Adaptar únicamente la copia extraída |
| Importación manual | Archivo intacto | Adaptar únicamente la copia que entra al juego |
| Compartida por otro jugador | Drive del dueño intacto | Cada receptor aplica su propio perfil local |

Un cambio de escala no cuenta como progreso: la comparación de sincronización sigue basándose en calendario/días del juego.

## Fuente del perfil destino

Prioridad:

1. El mismo save ya presente en el dispositivo destino.
2. Perfil visual local almacenado por ValleySave, capturado de un save válido de ese dispositivo.
3. Preferencias nativas de Stardew (`startup_preferences`/`default_options`) cuando sean accesibles.
4. Sin referencia: quitar del staging los campos dependientes del dispositivo y dejar que Stardew los regenere.

El perfil es local; nunca se sube ni se comparte.

## Campos del perfil

Solo nodos dentro de `<options>`:

- Escala/HUD: `uiScale`, `zoomLevel`, `dateTimeScale`, `dialogueFontScale`.
- Barra: `toolbarSlotSize`, `toolbarPadding`, `verticalToolbar`, `pinToolbarToggle`.
- Interacción visual: `pinchZoom`, `zoomButtons`, `hardwareCursor`, `snappyMenus`.
- Pantalla: `preferredResolutionX/Y`, `fullscreenResolutionX/Y`, `fullscreen`, `windowedBorderlessFullscreen`.
- Entrada: `gamepadMode`, `gamepadControls`, `mouseControls`, `keyboardControls`, `showPlacementTileForGamepad`.
- Cooperativo local: `localCoopBaseZoomLevel`, `localCoopDesiredUIScale`.

No se toca ningún nodo fuera de `<options>`: jugador, inventario, hora de juego, día, eventos, mapa, dinero y progreso quedan idénticos.

## Estructura de archivos

- Create: `lib/core/services/save_display_profile_service.dart` — extraer, guardar localmente y aplicar perfiles.
- Create: `test/save_display_profile_service_test.dart` — tests XML y matriz PC/móvil.
- Modify: `lib/core/services/transfer_service.dart` — importación/restauración en staging.
- Modify: `lib/features/saves/saves_screen.dart` — descarga normal y compartida, escritorio y Android.
- Modify: `lib/core/services/shizuku_service.dart` solo si hace falta exponer preferencias nativas; no cambiar comandos de reemplazo.
- Modify: `test/transfer_service_test.dart` y tests de widgets/descarga correspondientes.

### Task 1: Perfil visual aislado del progreso

- [ ] Crear tests que prueben que extraer/aplicar un perfil solo cambia `<options>`.
- [ ] Probar perfiles PC y móvil con los valores observados en saves reales.
- [ ] Probar que el mismo save conserva día, dinero, inventario y bytes de todos los nodos ajenos a `<options>`.
- [ ] Implementar `SaveDisplayProfile` inmutable y serializable localmente.
- [ ] Implementar extracción desde archivo principal y aplicación a principal + `_old`.
- [ ] Implementar eliminación segura de campos del perfil cuando no haya referencia.
- [ ] Ejecutar `flutter test --no-pub test/save_display_profile_service_test.dart`.

### Task 2: Escritorio — descarga, importación y restore

- [ ] En `TransferService`, capturar el perfil del destino antes de reemplazarlo.
- [ ] Dentro de `prepare`, copiar/extractar y aplicar el perfil al staging.
- [ ] En descarga de Drive, hacer lo mismo después de `downloadSaveToDir` y antes de validar/publicar.
- [ ] Si el save no existe, consultar preferencias Stardew locales; si no son utilizables, retirar campos dependientes del dispositivo.
- [ ] Probar que zip, Drive simulado y auto-backup quedan sin modificar.
- [ ] Ejecutar tests de transferencias, backups y descarga.

### Task 3: Android root/Shizuku

- [ ] Usar `entry.local.folderPath` —la copia ya obtenida por `pullSaves`/`pullSavesAsRoot`— como perfil del dispositivo antes de descargar.
- [ ] Aplicar el perfil al directorio `game_out/<save>` antes de `_isValidStagedSave` y `pushSave`/`pushSaveAsRoot`.
- [ ] Si es un save nuevo, reutilizar un perfil móvil local ya capturado; sin referencia, retirar campos portátiles y dejar que Stardew Android inicialice sus valores.
- [ ] No cambiar la transacción root/Shizuku ni escribir fuera de `game_out` hasta que la validación pase.
- [ ] Añadir tests del adaptador independientes del dispositivo y conservar como pendiente explícita la validación física Android.

### Task 4: Compartidas y conflictos

- [ ] Confirmar que descargar desde Mi Drive y desde Drive del dueño pasan por el mismo adaptador de destino.
- [ ] Confirmar que subir desde cualquier dispositivo nunca aplica el perfil de otro dispositivo al remoto.
- [ ] Confirmar que un receptor no modifica el Drive compartido solo por adaptar su interfaz local.
- [ ] Confirmar que las diferencias de perfil no crean un falso avance porque la decisión usa calendario del juego.
- [ ] Ejecutar pruebas de `SharedSyncState`, picker compartido y cards.

### Task 5: Reparación de saves ya afectados

- [ ] Detectar en escritorio un save local con firma móvil sin mutarlo al listar.
- [ ] Mostrar acción explícita `Ajustar interfaz a este equipo` únicamente cuando exista desajuste.
- [ ] Al confirmar: crear backup, aplicar perfil local en staging y publicar con `SaveReplaceService`.
- [ ] Nunca modificar automáticamente un save solo por abrir ValleySave.

### Task 6: Verificación final

- [ ] Ejecutar `flutter analyze --no-pub`.
- [ ] Ejecutar `flutter test --no-pub`.
- [ ] Probar físicamente PC → Android → PC con el mismo save.
- [ ] Probar el mismo recorrido usando una partida compartida sin cambiar la UI del propietario.

## Decisiones de seguridad

- Subir no transforma: el destino todavía es desconocido.
- Listar no transforma: abrir ValleySave no autoriza una escritura.
- Descargar/restaurar/importar sí puede transformar el staging porque el usuario ya autorizó reemplazar la copia local y existe rollback.
- El perfil visual nunca se mezcla con la lógica de progreso ni con `players.json`.
- Los saves modded conservan nodos desconocidos; solo se editan nombres de opción incluidos en la lista blanca.
