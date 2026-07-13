# Matriz de pruebas — Ampliacion de Robin vs cambio de anfitrion

> Documento vivo. Se actualiza en cada paso. Objetivo: entender con certeza como se
> comporta una ampliacion de casa de Robin (`daysUntilHouseUpgrade`) en coop, y en
> concreto que pasa cuando se cruza con nuestro cambio de anfitrion (swap). Ver el detalle
> tecnico completo en `stardew-host-swap-investigacion.md` (mismo directorio).

## Por que estas pruebas

En una partida normal el anfitrion es SIEMPRE el mismo, asi que su ampliacion siempre
progresa. Nuestro swap degrada al anfitrion a farmhand — un rol donde el juego trata el
progreso de forma distinta (parece congelarse si el jugador esta desconectado). Necesitamos
aislar: ¿el problema es de estar desconectado (comportamiento normal del juego), o
especifico de la transicion `<player>`→`<Farmer>` que hace el swap? Y cuando una ampliacion
SI se completa, ¿la casa queda bien (con los muebles/cama doble correctos) o corrupta?

## Datos de referencia (verificados)

- `daysUntilHouseUpgrade` se guarda POR jugador (cada `<player>`/`<Farmer>`), independiente.
  No hay nodo de equipo compartido (buscado, no existe).
- `daysOfConstructionLeft` (construccion de EDIFICIOS) es un sistema SEPARADO — la ampliacion
  de casa NO es un "edificio en construccion".
- Ampliar la casa NO cambia el tamaño EXTERIOR (9x5 en nivel 0 y en nivel 3).
- Señal de "completada bien" a mirar en el XML: `houseUpgradeLevel` sube (0→1) y
  `daysUntilHouseUpgrade` vuelve a `-1`; señal visual en juego: cama pasa de `Single` a
  `Double` (`bedType`), aparecen habitaciones nuevas. Un `houseUpgradeLevel` alto con cama
  individual = interior NO regenerado = mal.

## Convenciones

- **Nunca se juega el save "checkpoint" directamente.** Los dos checkpoints de la tabla de
  abajo (`StardustNormalMax_780186333` / `HirieoRico` y `StardustSwapPrioridad_406081014`
  / `EltestConAmpliacion`) se quedan INTACTOS, sin tocar, para siempre — son el "punto de
  partida" del que sale cada sub-prueba.
- **Cada fila de la matriz (A1, A2, A3, B1-B4) sale de una copia FRESCA del checkpoint
  correspondiente** (no de una copia ya jugada de otra fila). Ejemplo: A2 y A3 se copian
  otra vez desde `HirieoRico`, NO desde el resultado ya avanzado de A1 — cada sub-prueba
  necesita partir del mismo estado limpio (dia 5, ambos con `daysUntilHouseUpgrade=2`)
  para que los resultados sean comparables entre si.
- Copias creadas con `Copy-SaveAs.ps1` (aplica la checklist: id=carpeta, SaveGameInfo
  regenerado, sin `*_old`).
- **El nombre de la CARPETA es irrelevante para el usuario — en el menu del juego solo se
  ve el nombre del JUGADOR.** Cambiar solo la carpeta sin cambiar tambien el nombre del
  jugador anfitrion dentro del XML NO sirve para que el usuario identifique la partida.
  Toda copia nueva tiene que tener un nombre de jugador distinto y reconocible (por eso
  `Copy-SaveAs.ps1` exige `-NewPlayerName` como parametro obligatorio, no opcional).
- Save real intocable: `Stardust_443121237` (jugador Hirieo). Referencias intocables:
  `Mojomcio_418326337` (Bondi), `Pleyades_395187544` (Hirieo, otra partida).

## Estado de los saves "checkpoint" ahora mismo

| Rol | Carpeta | Jugador visible | Estado |
|---|---|---|---|
| Base SIN swap, ambos con ampliacion pendiente (multijugador real) | `StardustNormalMax_780186333` | `HirieoRico` | host Hirieo=2, farmhand Eltestosteron=2, dia 5 |
| CON swap ya hecho, Hirieo degradado con ampliacion pendiente | `StardustSwapPrioridad_406081014` | `EltestConAmpliacion` | host Eltest=2, farmhand Hirieo=2, dia 7 |

---

## BLOQUE A — desde la base SIN swap (ambos con ampliacion pendiente)

Punto de partida de todo el bloque: `HirieoRico` (`StardustNormalMax_780186333`) — host
Hirieo y farmhand Eltestosteron, ambos con `daysUntilHouseUpgrade=2`, dia 5. Cada sub-prueba
parte de una copia fresca de ese estado.

| # | Escenario | Accion del usuario | Que observar | Copia a usar | Resultado |
|---|---|---|---|---|---|
| A1 | Ambos con ampliacion pendiente | Duermen LOS DOS (tuvieron que dormir 2 veces, coincide con `daysUntilHouseUpgrade=2`) | ¿Se completan AMBAS casas a la vez? XML: ¿ambos `houseUpgradeLevel` 0→1 y `daysUntilHouseUpgrade`→-1? ¿camas dobles? | `StardustA1_421499893` (jugador `PruebaA1`) | ✅ **COMPLETO Y LIMPIO EN AMBOS.** Anfitrion: `houseUpgradeLevel=1`, `daysUntilHouseUpgrade=-1`, cama FarmHouse = `Double Bed`. Farmhand Eltestosteron: `houseUpgradeLevel=1`, `daysUntilHouseUpgrade=-1`, cama en su cabaña (5x3, tamaño exterior sin cambios) = tambien `Double Bed`. Sin swap de por medio, con los dos jugadores realmente conectados a la vez, todo funciona exactamente como se esperaria en el juego normal. **Esto confirma que el problema NO es "una ampliacion pendiente en un farmhand" en si misma — es especificamente la combinacion con el swap** (que cambia `<player>`↔`<Farmer>` y desconecta a la fuerza a quien baja de rol). |
| A2 | Ambos con ampliacion pendiente | Duerme SOLO el anfitrion (Hirieo) 2 dias, Eltestosteron NO conectado/NO duerme | ¿Que pasa con la casa de Eltestosteron? ¿se amplia igual? ¿tiene muebles? XML de ambos | `StardustA2_518677022` (jugador `PruebaA2`) | ✅ **CONGELADO, tal como se esperaba.** Anfitrion completo bien (`1`/`-1`, Double Bed, dia 5→7). Eltestosteron SIN CAMBIOS (`0`/`2`) — el mundo avanzo 2 dias pero su contador no bajo ni uno. Confirma: el contador de un farmhand solo avanza si ESE farmhand esta conectado y duerme, no basta con que pase tiempo en general. Coherente con A1 (los dos conectados → los dos avanzan), no es corrupcion ni comportamiento erratico. **Seguimiento resuelto:** el usuario reconecto a Eltestosteron sobre esta misma copia y durmieron 2 veces mas (dia 7→9). Resultado: Eltestosteron `houseUpgradeLevel=1`, `daysUntilHouseUpgrade=-1`, `Double Bed` en su cabaña — **retomo y completo con normalidad, exactamente igual que si nunca se hubiera pausado.** Confirmado: la pausa por desconexion es totalmente reversible, no es corrupcion ni perdida permanente. Esto es asi SIN swap de por medio (control limpio). |
| A3 | Copia fresca del checkpoint + SWAP | Swap Eltestosteron→host, Hirieo→farmhand, con ambas ampliaciones aun pendientes (`daysUntilHouseUpgrade=2` en los dos, confirmado tras el swap). Se conectaron LOS DOS (como en A1) y durmieron juntos. | ¿Se amplia la casa de Hirieo (ya farmhand)? ¿tiene muebles? XML antes/despues de dormir | `StardustSwapPrioridad_661081192` — anfitrion `PruebaA3` (era Eltestosteron), farmhand `PruebaA3pre` (era Hirieo) | ✅ **EXITO TOTAL, identico a A1.** Verificado en XML (no solo en el juego): anfitrion `houseUpgradeLevel=1`/`daysUntilHouseUpgrade=-1`/`Double Bed`. Farmhand (el que bajo de rol por el swap) `houseUpgradeLevel=1`/`daysUntilHouseUpgrade=-1`/`Double Bed` en su cabaña. **El swap NO corrompe ni bloquea la finalizacion de una ampliacion pendiente**, siempre que ambos jugadores esten conectados. Se comporta exactamente igual que un farmhand normal (A1): necesita estar conectado para avanzar, y si lo esta, completa perfecto — el cambio de rol (`<player>`↔`<Farmer>`) en si mismo no rompe nada. |

| A4 | **Escenario real de la feature**: swap y el degradado NO vuelve | Copia fresca del checkpoint → swap → jugar SOLO como nuevo anfitrion 3+ noches (el degradado no se conecta) → leer XML → despues reconectar al degradado y dormir 2 noches | Fase 1: ¿contador del degradado intacto, sin efectos raros (correo/evento de Robin, dinero, cascada)? Fase 2: ¿retoma y completa limpio pese al tiempo degradado? | `StardustSwapPrioridad_947257623` — anfitrion `PruebaA4` (era Eltestosteron), farmhand `PruebaA4pre` (era Hirieo) | ✅ **COMPLETA — EXITO TOTAL, verificado en XML en las dos fases.** Fase 1 (dia 5→7, 2 noches SOLO `PruebaA4`, `PruebaA4pre` desconectado): `PruebaA4pre` conservo `houseUpgradeLevel=0`/`daysUntilHouseUpgrade=2` intacto, sin cascada ni senales raras — el contador se congela limpio sin reconectar nunca. Fase 2 (dia 7→9, 2 noches con los dos conectados): `PruebaA4pre` completo perfecto — `houseUpgradeLevel` 0→1, `daysUntilHouseUpgrade=-1`, `Double Bed`. **Cierra el hueco #1 de la matriz**: el escenario real de la feature (degradado nunca reconecta, luego reconecta) no corrompe ni pierde la ampliacion pendiente. Alcance exacto: n=1, nivel 0→1, ~2 dias de juego degradado sin reconectar (no se probo un periodo mas largo), una sola ejecucion. Nota metodologica: hubo un falso inicio jugando por error la copia intermedia `StardustA4pre_230771670` (sin swap aplicado) — corregido, ver log. |

Esta es la PRIMERA VALIDACION segun el usuario (A1-A3), ampliada con A4 tras la revision.

---

## BLOQUE B — otra partida, ampliaciones cruzadas con desconexion y swap

Explora que pasa cuando una ampliacion queda "a medias" y entra en juego la desconexion o
el swap, en ambos sentidos.

| # | Escenario | Accion del usuario | Que observar | Copia a usar | Resultado |
|---|---|---|---|---|---|
| B1 | Eltestosteron con dinero+madera, pide ampliacion | Los dos duermen | Deberia ampliar la casa de Eltestosteron CON los muebles correctos. XML + cama | — | ✅ **Dado por cubierto por A1** (decision del usuario, 2026-07-10). Mismo patron exacto (los dos conectados, ambos completan perfecto) ya verificado en XML. No se ejecuta aparte. |
| B2 | Eltestosteron deja su casa ampliandose y SE DESCONECTA | Solo Hirieo (host) duerme | ¿Se amplia la casa de Eltestosteron aunque el este desconectado? XML | — | ✅ **Dado por cubierto por A2** (decision del usuario, 2026-07-10). Mismo patron exacto (farmhand desconectado se congela, reversible al reconectar) ya verificado en XML. No se ejecuta aparte. |
| B3 | Eltestosteron deja su casa en ampliacion | Se hace SWAP (Eltest pasa a host o a farmhand segun el caso) mientras su obra esta a medias | ¿Que pasa con su ampliacion tras el swap? XML | `StardustSwapPrioridad_187622988` — anfitrion `PruebaB3B4` (era Eltestosteron), farmhand `PruebaB3B4pre` (era Hirieo) | ✅ **COMPLETA — EXITO, verificado en XML.** Obra a medio construir (`daysUntilHouseUpgrade=1`, no 2 como A3) sobrevivio el swap intacta y completo perfecto al dormir 1 noche mas: host `PruebaB3B4` (Eltestosteron, ahora anfitrion) `houseUpgradeLevel` 0→1, `daysUntilHouseUpgrade=-1`, `Double Bed`. Alcance: n=1, nivel 0→1, obra decrementada UNA vez antes del swap. |
| B4 | Igual que B3 pero al reves: Hirieo deja su casa en ampliacion | Se hace SWAP | ¿Que pasa con la ampliacion de Hirieo tras el swap? XML | (misma ejecucion que B3, save `StardustSwapPrioridad_187622988`) | ✅ **COMPLETA — EXITO, verificado en XML.** Farmhand `PruebaB3B4pre` (Hirieo, ahora degradado) tambien completo perfecto: `houseUpgradeLevel` 0→1, `daysUntilHouseUpgrade=-1`, `Double Bed`. Confirma que la obra a medias sobrevive el swap EN LOS DOS SENTIDOS (el que sube a host y el que baja a farmhand). Alcance: n=1, nivel 0→1. |

---

## Hipotesis a confirmar/refutar con la matriz

1. El fin-de-dia del ANFITRION, ¿procesa el contador de TODOS los jugadores o solo del
   activo? (A1 vs A2 lo responden.)
2. Un farmhand DESCONECTADO, ¿ve avanzar su ampliacion cuando el host duerme? (B2.)
3. El swap, ¿rompe/congela/traslada correctamente una ampliacion a medias? (A3, B3, B4.)
4. Cuando una ampliacion SI se completa despues de nuestras manipulaciones, ¿el interior
   se regenera bien (cama doble, habitaciones) o corrupto (cama individual)?

## Decision de producto — CERRADA (2026-07-10): no bloquear el swap por ampliaciones pendientes

> **Decision del usuario (2026-07-10), textual:** "esta cerrado funciona bien, el swap lo
> podemos hacer con lo que hemos dicho con la prioridad y le mover los objetos". F3 (swap
> de anfitrion) se implementa CON reubicacion automatica por prioridad (cascada validada,
> ver `stardew-host-swap-investigacion.md`), y SIN ningun bloqueo/aviso especial por
> `daysUntilHouseUpgrade` pendiente — el swap se deja proceder igual haya o no obra en
> marcha en cualquiera de los dos jugadores implicados.

> **Historial:** una version anterior de esta seccion (2026-07-09) daba el Bloque A por
> "concluyente" tras solo A1-A3 y fue corregida como APRESURADA (cubria un solo camino).
> Se añadieron y ejecutaron A4 y B3/B4 para cerrar los huecos mas importantes antes de
> tomar la decision definitiva — ver tabla de resultados abajo.

**Lo que la matriz demuestra (hechos, cada uno verificado en XML):**

| Prueba | Swap | Conectados | Resultado |
|---|---|---|---|
| A1 | No | Los dos | Ambos completan perfecto (0→1, Double Bed) |
| A2 | No | Solo el anfitrion | El desconectado se congela (contador intacto) |
| A2 (seguimiento) | No | Los dos (tras reconectar) | El pausado retoma y completa perfecto |
| A3 | **Si** | Los dos, contador en 2 sin decrementar | Ambos completan perfecto, identico a A1 |
| A4 fase 1 | **Si** | Degradado desconectado 2 dias | Contador congelado limpio, sin efectos raros |
| A4 fase 2 | **Si** | Los dos, tras reconectar | Retoma y completa perfecto |
| B1, B2 | No | (cubiertos por A1/A2, mismo patron) | — |
| B3 | **Si** | Los dos, contador YA en 1 antes del swap | Completa perfecto (host→farmhand) |
| B4 | **Si** | Los dos, contador YA en 1 antes del swap | Completa perfecto (farmhand→host) |

**Alcance real de la decision (leer antes de generalizar mas alla de esto):** n=1 por
prueba, solo nivel de ampliacion 0→1, degradado probado sin reconectar durante ~2 dias
(no semanas), reubicacion de colisiones probada con 1 cofre + 2 arboles (no con
maquinas/muebles/mas densidad de objetos). Huecos NO probados, aceptados como riesgo
conocido al cerrar la decision (no bloqueantes segun el usuario, pero utiles si algo
falla en produccion):

- Ampliacion pedida DESPUES de estar ya degradado (B1v2, no ejecutada).
- Niveles de ampliacion 1→2 y 2→3 tras un swap (B5, no ejecutada).
- Casos del F0.5 del plan general nunca investigados: matrimonio jugador-jugador,
  mascotas con dueño, eventos de anfitrion pendientes en el momento del swap.
- Periodos de desconexion mucho mas largos que los ~2 dias probados en A4.

Si alguno de estos casos da problemas en uso real, revisar aqui primero antes de asumir
que es un bug nuevo — son huecos conocidos y aceptados, no sorpresas.

## Protocolo de continuacion — ordenes para CUALQUIER sesion nueva

> Pensado para ejecutarse con Sonnet 5 en esfuerzo alto. Este documento es la fuente de
> verdad; el contexto de chat se pierde. Leer tambien la seccion "⟶ RETOMAR AQUI" de
> `stardew-host-swap-investigacion.md` (mismo directorio) antes de tocar nada.

**Reglas fijas (no negociables):**

1. **Empirismo estricto:** ninguna fila se marca ✅/❌ sin leer el XML DESPUES de jugar
   (y antes, si el estado de partida no esta ya anotado en la tabla). El reporte visual
   del usuario complementa el XML, nunca lo sustituye. El usuario lo exige explicitamente.
2. **Copias frescas:** cada fila parte de una copia nueva del checkpoint correspondiente,
   creada con `Copy-SaveAs.ps1` (en `C:\Users\Hirieo\projects\ValleySave\stardew-dedicated-host-research\`;
   exige `-NewPlayerName`, aplica la checklist completa). Nunca reutilizar una copia ya
   jugada para otra fila. Nunca jugar los checkpoints (`HirieoRico`, `EltestConAmpliacion`).
3. **Swaps:** siempre con `Test-HostSwap-PriorityRelocate.ps1`, precedidos del detector de
   colisiones (`collision_check.dart` con dart run, o `Test-FootprintCollision.ps1`),
   mostrando al usuario que se detecto y a donde se reubico cada cosa. Tras cada swap:
   borrar `*_old`, verificar MAIN name == INFO root == INFO name, id == sufijo de carpeta.
4. **Nombres:** jugador visible unico y descriptivo por copia (`PruebaB1`, `PruebaB3pre`…).
   El usuario identifica partidas SOLO por nombre de jugador, jamas por carpeta.
5. **Trazabilidad:** tras cada resultado, actualizar EN EL MISMO TURNO la fila de la
   tabla + el log de este documento. Si un resultado contradice una fila anterior,
   anotar la contradiccion explicitamente, no sobreescribir.
6. **Alcance de las conclusiones:** toda afirmacion lleva su prueba al lado y su alcance
   exacto ("con ambos conectados", "nivel 0→1", "n=1"). Prohibido generalizar mas alla
   de lo ejecutado. Las decisiones de producto las toma el usuario, no la sesion.
7. **Al usuario se le dan instrucciones de juego concretas** (quien se conecta, cuantas
   veces dormir, que mirar) y UNA sola tanda de preguntas si falta un dato — no gotear
   preguntas turno a turno.

**Pasos concretos de las pruebas pendientes (en orden recomendado):**

- **A4 (primera — es el escenario real de la feature):** copia fresca de `HirieoRico` →
  swap (Eltestosteron→host) → el usuario juega SOLO como el nuevo anfitrion, el degradado
  NO se conecta → dormir 3+ noches → leer XML: ¿contador del degradado intacto en 2, sin
  efectos raros? → despues, reconectar al degradado y dormir 2 noches mas → ¿retoma y
  completa limpio (como A2-seguimiento) o algo se rompio por el tiempo pasado degradado?
- **B1:** copia fresca de `HirieoRico`… PERO OJO: en ese checkpoint la ampliacion de
  Eltestosteron ya esta pedida (es parte del estado). B1 tal como lo definio el usuario
  (Eltestosteron con dinero+madera pide su ampliacion y ambos duermen) quedo de facto
  cubierto por A1. Confirmar con el usuario si B1 se da por cubierto o si quiere
  ejecutarlo desde un estado sin ampliaciones pedidas (habria que crear un checkpoint
  nuevo desde el save original con dinero/madera y SIN ampliaciones).
- **B2:** cubierto en esencia por A2 (farmhand desconectado = congelado, reversible).
  Confirmar con el usuario si lo da por cubierto.
- **B3 (media obra + swap):** copia fresca de `HirieoRico` → el usuario duerme UNA noche
  con ambos conectados (contadores 2→1; verificar en XML antes de seguir) → swap → ambos
  se reconectan y duermen → ¿completan bien desde 1? XML + camas.
- **B4 (sentido contrario):** igual que B3 pero comprobando especificamente la ampliacion
  del que SUBE a anfitrion (la de Hirieo original). En la practica B3 y B4 se observan en
  la misma ejecucion porque ambos jugadores tienen obra pendiente — anotar los dos
  resultados por separado en sus filas.
- **B5 (opcional):** desde el resultado de A3 (ambos en nivel 1), pedir la segunda
  ampliacion y repetir el ciclo — ¿1→2 completa bien tras un swap previo? Decide el
  usuario si vale el tiempo de juego.

## Log de ejecucion (orden cronologico, lo mas reciente abajo)

- 2026-07-09: creada la matriz. Copia A1 lista: `StardustA1_421499893` (`PruebaA1`).
  Siguiente: el usuario juega A1 (dormir los dos, 2 dias) y avisa para leer XML.
- 2026-07-09: **A1 completada.** El usuario durmio 2 veces con los dos conectados.
  Resultado limpio en ambos (ver tabla). Creada copia A2 desde el checkpoint
  `HirieoRico` (no desde A1): `StardustA2_518677022` (`PruebaA2`). Siguiente: el
  usuario duerme SOLO como anfitrion, sin que Eltestosteron este conectado/duerma.
- 2026-07-09: **A2 completada** (congelado limpio) + **seguimiento A2** (reconecta y
  completa perfecto). **A3 completada** (swap + ambos conectados = identico a A1,
  verificado en XML). Copias usadas: `StardustA2_518677022`,
  `StardustSwapPrioridad_661081192` (`PruebaA3` / `PruebaA3pre`).
- 2026-07-09: **Correccion de rumbo a peticion del usuario:** la conclusion "no bloquear
  el swap" se marco como APRESURADA — Bloque A cubre un solo camino, n=1, nivel 0→1.
  Decision de producto reabierta. Añadida prueba A4 (escenario real: el degradado no
  vuelve) y escrito el "Protocolo de continuacion" con las ordenes completas para que
  cualquier sesion nueva (Sonnet 5 esfuerzo alto) siga la matriz con el mismo rigor.
  Siguiente accion: crear copia para A4 y ejecutarla.
- 2026-07-10: **A4 iniciada.** Colision check sobre `StardustNormalMax_780186333` con
  objetivo Eltestosteron: 1 Chest (critico) + 2 Tree (aviso) + 1 Weeds (ignorable),
  identico patron a swaps anteriores sobre el mismo checkpoint. Copia pre-swap
  `StardustA4pre_230771670` (Hirieo→`PruebaA4pre`) + swap con
  `Test-HostSwap-PriorityRelocate.ps1` → `StardustSwapPrioridad_947257623`
  (`PruebaA4` host / `PruebaA4pre` farmhand). XML verificado: swap limpio, ambos
  `daysUntilHouseUpgrade=2` (el degradado conserva su ampliacion pendiente, igual
  que A3). Siguiente: el usuario juega SOLO como `PruebaA4` (nuevo anfitrion),
  sin conectar `PruebaA4pre`, 3+ noches — luego se lee el XML (fase 1 de A4).
- 2026-07-10: **A4 fase 1 completada.** El usuario durmio 2 noches (dia 5→7) SOLO
  como `PruebaA4`, sin conectar `PruebaA4pre` en ningun momento. XML verificado:
  host `PruebaA4` completo su propia ampliacion con normalidad (`houseUpgradeLevel`
  0→1, `daysUntilHouseUpgrade=-1`, `Double Bed`) — esperado, sin sorpresa, es el
  jugador activo. Degradado `PruebaA4pre` conservo `daysUntilHouseUpgrade=2`
  intacto, sin cascada ni senales raras en el XML. Confirma que el contador de un
  degradado que NUNCA reconecta se congela limpio, igual que un farmhand desconectado
  normal (A2), ahora verificado especificamente en el escenario de swap real.
  Siguiente: fase 2 — reconectar `PruebaA4pre` y dormir 2 noches, comprobar si
  retoma y completa limpio pese al tiempo degradado.
- 2026-07-10: **Falso inicio de fase 2 — save equivocado, corregido.** El usuario
  cargo por error `StardustA4pre_230771670` (la copia INTERMEDIA pre-swap, sin el
  swap aplicado — Hirieo seguia siendo host normal, Eltestosteron farmhand normal).
  El menu del juego mostraba dos entradas parecidas (`PruebaA4pre` y `PruebaA4`) y
  cogio la que no era. Jugaron esa copia dia 5→9, ambos completaron su ampliacion
  con normalidad (`houseUpgradeLevel=1` los dos) — dato valido pero es solo un
  repetido de A1 (sin swap, los dos conectados), NO cuenta como fase 2 de A4.
  Copia borrada (con permiso explicito del usuario) para que no se repita la
  confusion en B1-B4. El save real del swap (`StardustSwapPrioridad_947257623`,
  visible como `PruebaA4` en el menu) seguia intacto en dia 7 — fase 2 sigue
  pendiente de jugar de verdad. **Leccion para futuras pruebas:** borrar SIEMPRE
  la copia intermedia en cuanto el script de swap termine de generar el resultado
  final, para eliminar el riesgo de nombres parecidos en el menu del juego.
- 2026-07-10: **A4 fase 2 completada — EXITO, matriz cerrada.** Con ambos personajes
  conectados (`PruebaA4` + `PruebaA4pre`) durmieron 2 noches (dia 7→9). XML
  verificado: `PruebaA4pre` (el degradado) completo su ampliacion pendiente con
  normalidad — `houseUpgradeLevel` 0→1, `daysUntilHouseUpgrade=-1`, `Double Bed`.
  Sin corrupcion, sin cascada, retomo exactamente donde se quedo pese a ~2 dias
  desconectado por el swap. **Cierra el hueco #1** (el escenario mas importante,
  antes sin probar). Bloque A (A1-A4) queda completo. Huecos que siguen abiertos
  para la decision de producto: obra a medio construir (B3/B4), ampliacion pedida
  DESPUES de degradar (B1v2), niveles 1→2/2→3 (B5, opcional), y repetir n=1 si
  algun resultado sorprende. Siguiente accion recomendada: Bloque B (B1-B4).
- 2026-07-10: **Bloque B iniciado.** Usuario decide dar B1 y B2 por cubiertos (A1/A2
  ya prueban el mismo patron). Copia fresca `StardustB3B4pre_312868126`
  (`PruebaB3B4pre`, checkpoint sin swap todavia) creada para B3/B4. Siguiente:
  el usuario duerme UNA noche con Hirieo y Eltestosteron conectados a la vez
  (contador 2→1 esperado en ambos) → verificar en XML → entonces se hace el swap
  con la obra ya a medio construir (a diferencia de A3, que partia de 2 sin
  decrementar nunca).
- 2026-07-10: **B3/B4 — swap ejecutado con obra a medio construir.** Usuario durmio
  1 noche con Hirieo y Eltestosteron conectados (dia 5→6, contador 2→1 en ambos,
  confirmado en XML antes de seguir). Colision check + swap sobre
  `StardustB3B4pre_312868126` → `StardustSwapPrioridad_187622988` (`PruebaB3B4`
  host / `PruebaB3B4pre` farmhand). **Hallazgo de proceso nuevo:** el swap arrastro
  archivos `*_old` (los creo el propio juego al guardar la copia pre-swap jugada;
  `Copy-SaveAs.ps1` los limpia pero el script de swap NO lo hacia al copiar una
  fuente ya jugada) — borrados a mano tras el swap. **Leccion:** revisar siempre
  `*_old` tras el swap si la copia origen se jugo antes de swapear (A4 no lo
  sufrio porque el swap se hizo inmediatamente tras `Copy-SaveAs.ps1`, sin jugar
  antes). XML verificado: ambos jugadores conservan `daysUntilHouseUpgrade=1`
  intacto tras el swap (la obra a medias viajo con cada uno, ninguno se rompio ni
  se reinicio). Copia intermedia borrada (con permiso del usuario). Siguiente:
  el usuario reconecta a los dos y duerme 1 noche mas — deberia completar ambas
  ampliaciones desde nivel 1.
- 2026-07-10: **B3/B4 completadas — EXITO en los dos sentidos, matriz cerrada.**
  Ambos reconectados, durmieron 1 noche mas (dia 6→7). XML verificado: host
  `PruebaB3B4` (Eltestosteron) `houseUpgradeLevel` 0→1/`daysUntilHouseUpgrade=-1`/
  `Double Bed`; farmhand `PruebaB3B4pre` (Hirieo, degradado) identico resultado.
  **Cierra el hueco #2**: obra a medio construir (contador ya decrementado antes
  del swap) sobrevive intacta y completa perfecto, tanto para quien sube a host
  como para quien baja a farmhand. Huecos que quedan abiertos: ampliacion pedida
  DESPUES de degradar (B1v2), niveles 1→2/2→3 (B5, opcional). Con A1-A4 y B3-B4
  todos limpios (n=1 cada uno), la evidencia acumulada apunta con fuerza a "no
  bloquear el swap por ampliaciones pendientes" — pero la decision final la toma
  el usuario, no queda cerrada aqui.
- 2026-07-10: **DECISION DE PRODUCTO CERRADA por el usuario.** Textual: "esta cerrado
  funciona bien, el swap lo podemos hacer con lo que hemos dicho con la prioridad y le
  mover los objetos". F3 se implementa con reubicacion automatica por prioridad
  (cascada validada) y SIN bloqueo/aviso especial por ampliaciones pendientes en
  ninguno de los dos jugadores. Huecos aceptados como riesgo conocido, no bloqueantes:
  B1v2 (ampliacion pedida ya degradado), B5 (niveles 1→2/2→3), casos F0.5 del plan
  general (matrimonio, mascotas, eventos pendientes), desconexiones mas largas que
  ~2 dias. Este documento queda como registro de la evidencia que sustenta la
  decision — no se necesitan mas pruebas de este bloque salvo que algo falle en uso
  real y haya que revisar los huecos de arriba.