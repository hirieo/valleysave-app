import 'dart:io';
import 'dart:math' as math;

import 'package:archive/archive.dart';
import 'package:xml/xml.dart';

import 'backup_service.dart' show verifyBackupZipContents;
import 'farm_placement_service.dart';
import 'save_replace_service.dart';
import 'save_service.dart';

/// Motivo por el que `analyze`/`execute` no pudieron completarse.
enum HostSwapError {
  invalidSave,
  noFreeTile,
  writeFailure,
  postValidationFailed,
}

/// Resultado de la fase de solo lectura ([HostSwapService.analyze]).
class HostSwapAnalysis {
  const HostSwapAnalysis({
    required this.ok,
    this.error,
    this.itemsToRelocate = 0,
    this.targetName = '',
  });

  final bool ok;
  final HostSwapError? error;

  /// Nº total de objetos que realmente se moverán (Weeds/Grass excluidos),
  /// incluidos huella, corredor y posibles desalojos por prioridad. Es el
  /// "N" que ve el usuario en el diálogo antes de confirmar.
  final int itemsToRelocate;

  /// Nombre visible del farmhand objetivo (para el texto del diálogo).
  final String targetName;
}

/// Resultado de la fase de escritura ([HostSwapService.execute]).
class HostSwapResult {
  const HostSwapResult({
    required this.ok,
    this.error,
    this.backupZipPath,
    this.relocatedCount = 0,
  });

  final bool ok;
  final HostSwapError? error;

  /// Zip del ORIGINAL (formato `TransferService.exportSave`), presente solo
  /// si `ok` — spec 007: el swap ya no crea una carpeta nueva, reemplaza el
  /// save en sitio (mismo `folderName`/`uniqueIDForThisGame`) y preserva el
  /// original como respaldo restaurable con Importar.
  final String? backupZipPath;

  /// Objetos reubicados — igual a `itemsToRelocate` del análisis previo sobre
  /// el mismo save (contrato G10 de 005).
  final int relocatedCount;
}

/// Cambio de anfitrión 100% local: copia el save, reubica por prioridad los
/// objetos que colisionan con la vivienda o su acceso, intercambia los nodos
/// de jugador y los edificios, y valida el resultado antes de aceptarlo.
///
/// Puerto de `Test-HostSwap-PriorityRelocate.ps1` (validado en juego real —
/// ver docs/host-swap-research/). Deltas respecto al script de pruebas:
/// nunca renombra jugadores, borra `*_old` tras copiar, localiza el objetivo
/// por `UniqueMultiplayerID` (no por nombre), no fuerza `useSeparateWallets`,
/// y valida el resultado con [SaveService.parseFullSave] antes de aceptarlo.
///
/// Agnóstico de plataforma: opera sobre rutas de carpeta. En Windows el
/// caller pasa `SaveService.savesDirectory`; en Android (v2, sin implementar
/// aún) pasará la carpeta puente de `ShizukuService`.
class HostSwapService {
  static const _ignorableTypes = {'Weeds', 'Grass'};
  static const _closeRadius = 6;
  static const _farRadius = 20;
  static const _contentFields = [
    'buildings',
    'animals',
    'piecesOfHay',
    'characters',
    'objects',
    'resourceClumps',
    'largeTerrainFeatures',
    'terrainFeatures',
    'numberOfSpawnedObjectsOnMap',
    'miniJukeboxCount',
    'miniJukeboxTrack',
    'furniture',
    'Animals',
    'IsGreenhouse',
    'wallPaper',
    'appliedWallpaper',
    'floor',
    'appliedFloor',
    'fridge',
    'fridgePosition',
    'cribStyle',
  ];

  /// Campos de [SaveGameInfo] que pertenecen a la partida, no al jugador.
  /// El XML completo guarda el jugador anfitrión en `<player>`, pero estos
  /// valores solo viven en SaveGameInfo. Al convertir un farmhand en host no
  /// deben desaparecer: si lo hicieran, la copia se mostraría con otro día o
  /// sin versión aunque sea exactamente la misma partida.
  static const _saveInfoGameFields = {
    'seasonForSaveGame',
    'dayOfMonthForSaveGame',
    'yearForSaveGame',
    'gameVersion',
  };

  /// Solo lectura: nunca escribe ni crea nada en disco.
  Future<HostSwapAnalysis> analyze({
    required String saveFolderPath,
    required String targetUniqueId,
  }) async {
    try {
      final sep = Platform.pathSeparator;
      final folderName = saveFolderPath.split(sep).last;
      final mainFile = File('$saveFolderPath$sep$folderName');
      if (!await mainFile.exists()) {
        return const HostSwapAnalysis(
          ok: false,
          error: HostSwapError.invalidSave,
        );
      }

      final doc = XmlDocument.parse(await mainFile.readAsString());
      final ctx = _loadContext(doc, targetUniqueId);
      if (ctx == null) {
        return const HostSwapAnalysis(
          ok: false,
          error: HostSwapError.invalidSave,
        );
      }

      final plan = _planHostSwap(ctx);
      if (plan == null) {
        return HostSwapAnalysis(
          ok: false,
          error: HostSwapError.noFreeTile,
          targetName: ctx.targetName,
        );
      }

      return HostSwapAnalysis(
        ok: true,
        itemsToRelocate: plan.relocation.itemsInFootprint,
        targetName: ctx.targetName,
      );
    } catch (_) {
      return const HostSwapAnalysis(
        ok: false,
        error: HostSwapError.invalidSave,
      );
    }
  }

  /// Reemplaza el save EN SITIO (mismo `folderName`/`uniqueIDForThisGame` —
  /// spec 007, decisión 2026-07-12: el folderId de Drive debe ser estable
  /// para que los permisos de compartir y "Compartidas conmigo" sobrevivan
  /// al swap). El original se preserva SIEMPRE como zip en [backupsDir]
  /// (mismo formato que `TransferService.exportSave`) ANTES de tocar nada —
  /// en cualquier fallo, el original queda intacto en su carpeta original.
  Future<HostSwapResult> execute({
    required String saveFolderPath,
    required String targetUniqueId,
    required String backupsDir,
  }) async {
    final sep = Platform.pathSeparator;
    Directory? tempRoot;
    try {
      final folderName = saveFolderPath.split(sep).last;
      final sourceMain = File('$saveFolderPath$sep$folderName');
      if (!await sourceMain.exists()) {
        return const HostSwapResult(
          ok: false,
          error: HostSwapError.invalidSave,
        );
      }

      // Trabajo sobre una copia TEMPORAL (nunca sobre savesDir) — el
      // original en [saveFolderPath] no se toca hasta el paso 5. HERMANA de
      // saveFolderPath (mismo directorio padre), NUNCA Directory.systemTemp:
      // el paso 5 usa Directory.rename() para el swap final, y rename()
      // solo funciona dentro del MISMO sistema de archivos. En Android la
      // caché de la app (systemTemp) y la carpeta externa donde vive el
      // save puente pueden ser particiones distintas — rename() fallaba
      // ahí con "cross-device link" (2026-07-15, bug real reportado en la
      // beta: "no se pudo escribir la partida nueva, disco/permisos").
      // Mismo padre = mismo filesystem siempre, en cualquier plataforma.
      tempRoot = await Directory(
        saveFolderPath,
      ).parent.createTemp('.vs_swap_tmp_');
      final workDir = Directory('${tempRoot.path}$sep$folderName');
      await copyDirectory(Directory(saveFolderPath), workDir);

      // Delta: borrar *_old sobrantes (el juego los crea al jugar; lección
      // de la sesión de pruebas B3/B4).
      await for (final entity in workDir.list()) {
        if (entity is File && entity.path.endsWith('_old')) {
          await entity.delete();
        }
      }

      final newMain = File('${workDir.path}$sep$folderName');
      if (!await newMain.exists()) {
        await _safeDelete(tempRoot);
        return const HostSwapResult(
          ok: false,
          error: HostSwapError.writeFailure,
        );
      }
      final infoPath = File('${workDir.path}${sep}SaveGameInfo');

      final doc = XmlDocument.parse(await newMain.readAsString());
      final root = doc.rootElement;
      // Spec 007: uniqueIDForThisGame YA NO se muta — no hay colisión que
      // evitar porque no se crea carpeta nueva. Menos mutación = más estable.
      final originalId = _text(root, 'uniqueIDForThisGame') ?? '';

      final ctx = _loadContext(doc, targetUniqueId);
      if (ctx == null) {
        await _safeDelete(tempRoot);
        return const HostSwapResult(
          ok: false,
          error: HostSwapError.invalidSave,
        );
      }

      final plan = _planHostSwap(ctx);
      if (plan == null) {
        await _safeDelete(tempRoot);
        return const HostSwapResult(ok: false, error: HostSwapError.noFreeTile);
      }
      final expectedCaveChoice = _intText(ctx.player, 'caveChoice') ?? 0;
      final originalFarmCaveXml = _locationXml(ctx.root, 'FarmCave');
      for (final m in plan.relocation.moves) {
        _moveItemTo(m.item, m.toX, m.toY);
      }

      // Clonar nodos ANTES de mutar (evita corrupción por referencias
      // compartidas al mutar in-place — lección de la investigación).
      final oldHostClone = ctx.player.copy();
      final newHostClone = ctx.target.copy();
      final oldHostId = _text(ctx.player, 'UniqueMultiplayerID') ?? '';
      final targetCabinInterior = ctx.targetCabinBuilding
          .findElements('indoors')
          .firstOrNull;
      if (targetCabinInterior == null) {
        await _safeDelete(tempRoot);
        return const HostSwapResult(
          ok: false,
          error: HostSwapError.invalidSave,
        );
      }
      final origFarmHouseInteriorClone = ctx.topFarmHouse.copy();

      // Nuevo host: <player> pasa a ser el farmhand objetivo. Delta: NO se
      // toca <name> (llega ya correcto en el clon) ni useSeparateWallets.
      ctx.player.children.clear();
      ctx.player.children.addAll(newHostClone.children.map((c) => c.copy()));
      _setElementValue(ctx.player, 'homeLocation', 'FarmHouse');
      _setElementValue(ctx.player, 'slotCanHost', 'true');
      _preserveFarmCaveChoice(oldHostClone, ctx.player);

      // Host saliente: el <Farmer> objetivo pasa a tener los datos del host.
      ctx.target.children.clear();
      ctx.target.children.addAll(oldHostClone.children.map((c) => c.copy()));
      _setElementValue(ctx.target, 'homeLocation', ctx.targetHome);
      _setElementValue(ctx.target, 'slotCanHost', 'false');

      // El intercambio físico sigue siendo obligatorio, pero se ancla por
      // puertas y se desplaza lo mínimo necesario para que buzón y salida
      // sean utilizables en el mapa real de la granja.
      _setElementValue(
        ctx.farmhouseBuilding,
        'tileX',
        plan.placement.farmhouse.origin.x.toString(),
      );
      _setElementValue(
        ctx.farmhouseBuilding,
        'tileY',
        plan.placement.farmhouse.origin.y.toString(),
      );
      _setElementValue(
        ctx.targetCabinBuilding,
        'tileX',
        plan.placement.cabin.origin.x.toString(),
      );
      _setElementValue(
        ctx.targetCabinBuilding,
        'tileY',
        plan.placement.cabin.origin.y.toString(),
      );

      // Copiar contenido de interior en ambos sentidos.
      _copyInteriorContent(
        source: targetCabinInterior,
        target: ctx.topFarmHouse,
      );
      _setElementValue(ctx.topFarmHouse, 'name', 'FarmHouse');
      _setElementValue(ctx.topFarmHouse, 'isStructure', 'false');

      _copyInteriorContent(
        source: origFarmHouseInteriorClone,
        target: targetCabinInterior,
      );
      _setElementValue(targetCabinInterior, 'name', 'Cabin');
      _setElementValue(targetCabinInterior, 'uniqueName', ctx.targetHome);
      _setElementValue(targetCabinInterior, 'isStructure', 'true');
      _setElementValue(targetCabinInterior, 'farmhandReference', oldHostId);
      _setNetStringNil(ctx.targetCabinBuilding, 'nonInstancedIndoorsName');

      final newHostName = _text(ctx.player, 'name') ?? '';

      await newMain.writeAsString(doc.toXmlString(pretty: false));

      // SaveGameInfo regenerado con el nombre REAL del nuevo host como raíz
      // (delta: nunca un nombre de "prueba" — producción no renombra a nadie).
      if (await infoPath.exists() && newHostName.isNotEmpty) {
        final infoDoc = XmlDocument.parse(await infoPath.readAsString());
        final oldInfoRoot = infoDoc.rootElement;
        // Partimos del SaveGameInfo existente para conservar los metadatos de
        // la partida (día, estación, año y versión), y solo sustituimos los
        // campos propios del nuevo anfitrión.
        final newInfoRoot = XmlElement(XmlName(newHostName));
        // Conserva las declaraciones xmlns del SaveGameInfo original. Sin
        // ellas los nodos `xsi:type` del jugador quedan inválidos y Stardew
        // (y nuestro parser) no puede leer el archivo resultante.
        newInfoRoot.attributes.addAll(
          oldInfoRoot.attributes.map((attribute) => attribute.copy()),
        );
        newInfoRoot.children.addAll(oldInfoRoot.children.map((c) => c.copy()));
        _mergePlayerIntoSaveInfo(newInfoRoot, ctx.player);
        // Estas cuatro propiedades pertenecen a la granja y su fuente de
        // verdad es el XML principal, no el nodo del jugador ni un
        // SaveGameInfo ya generado por una versión anterior del swap.
        _setElementValue(
          newInfoRoot,
          'seasonForSaveGame',
          _seasonForSaveGame(_text(root, 'currentSeason')),
        );
        _setElementValue(
          newInfoRoot,
          'dayOfMonthForSaveGame',
          _text(root, 'dayOfMonth') ?? '',
        );
        _setElementValue(
          newInfoRoot,
          'yearForSaveGame',
          _text(root, 'year') ?? '',
        );
        _setElementValue(
          newInfoRoot,
          'gameVersion',
          _text(root, 'gameVersion') ?? '',
        );
        _setElementValue(newInfoRoot, 'homeLocation', 'FarmHouse');
        _setElementValue(newInfoRoot, 'slotCanHost', 'true');
        final infoChildren = infoDoc.children;
        final idx = infoChildren.indexOf(oldInfoRoot);
        if (idx == -1) {
          infoChildren.add(newInfoRoot);
        } else {
          infoChildren
            ..removeAt(idx)
            ..insert(idx, newInfoRoot);
        }
        await infoPath.writeAsString(infoDoc.toXmlString(pretty: false));
      }

      // Validación post-swap (delta: automática, no manual). Extraída a
      // `_isHostSwapIntegrityValid` para poder re-ejecutarla también sobre
      // el destino YA PUBLICADO, no solo sobre esta copia de trabajo (ver
      // más abajo, `validate:` al núcleo — sugerencia de Codex, 2026-07-18:
      // así una corrupción durante la copia a staging o el rename final
      // también la detectaría esta validación específica, no solo la
      // genérica del núcleo).
      final integrityOk = await _isHostSwapIntegrityValid(
        workDir,
        folderName: folderName,
        targetUniqueId: targetUniqueId,
        oldHostId: oldHostId,
        originalId: originalId,
        targetHome: ctx.targetHome,
        expectedFarmhouseDoor: plan.placement.farmhouse.absoluteDoor,
        expectedCabinDoor: plan.placement.cabin.absoluteDoor,
        expectedCaveChoice: expectedCaveChoice,
        originalFarmCaveXml: originalFarmCaveXml,
      );

      if (!integrityOk) {
        await _safeDelete(tempRoot);
        return const HostSwapResult(
          ok: false,
          error: HostSwapError.postValidationFailed,
        );
      }

      // Paso 3-4 (spec 007, G1/G4): comprimir el ORIGINAL — todavía intacto
      // en [saveFolderPath] — y verificar que el zip es un save parseable
      // ANTES de reemplazar nada.
      final backupZip = await _zipFolder(
        saveFolderPath,
        folderName,
        backupsDir,
      );
      if (backupZip == null || !await _verifyBackupZip(backupZip, folderName)) {
        if (backupZip != null) await _safeDeleteFile(backupZip);
        await _safeDelete(tempRoot);
        return const HostSwapResult(
          ok: false,
          error: HostSwapError.writeFailure,
        );
      }

      // Paso 5-7: sustitución transaccional delegada en el núcleo compartido
      // (`SaveReplaceService`) — mismo respaldo+swap+rollback que descarga e
      // importación, sin duplicar la lógica (F9). El zip `_pre-swap_` ya
      // hecho y verificado se pasa como preverificado: conserva su nombre
      // permanente y la retención automática nunca lo poda. Integrado tras
      // ver la implementación paralela de Codex (2026-07-18); condición de
      // aceptación: los tests de host swap pasan sin modificarlos.
      final replace = await SaveReplaceService.instance.replaceSaveFolder(
        savesDir: Directory(saveFolderPath).parent.path,
        folderName: folderName,
        backupsDir: backupsDir,
        preverifiedBackupPath: backupZip.path,
        prepare: (staging) => copyDirectory(workDir, staging),
        // Se re-ejecuta sobre el staging (paso 3 del núcleo) Y sobre el
        // destino ya publicado (paso 5b) — la genérica del núcleo solo
        // comprueba que el save cargue; esta comprueba que el swap de
        // anfitrión en sí siga siendo correcto en la ruta final.
        validate: (dir) => _isHostSwapIntegrityValid(
          dir,
          folderName: folderName,
          targetUniqueId: targetUniqueId,
          oldHostId: oldHostId,
          originalId: originalId,
          targetHome: ctx.targetHome,
          expectedFarmhouseDoor: plan.placement.farmhouse.absoluteDoor,
          expectedCabinDoor: plan.placement.cabin.absoluteDoor,
          expectedCaveChoice: expectedCaveChoice,
          originalFarmCaveXml: originalFarmCaveXml,
        ),
      );
      await _safeDelete(tempRoot);
      if (!replace.ok) {
        await _safeDeleteFile(backupZip);
        return HostSwapResult(
          ok: false,
          error: replace.error == ReplaceError.postValidationFailed
              ? HostSwapError.postValidationFailed
              : HostSwapError.writeFailure,
        );
      }

      return HostSwapResult(
        ok: true,
        backupZipPath: backupZip.path,
        relocatedCount: plan.relocation.itemsInFootprint,
      );
    } catch (_) {
      if (tempRoot != null) await _safeDelete(tempRoot);
      return const HostSwapResult(ok: false, error: HostSwapError.writeFailure);
    }
  }

  static void _mergePlayerIntoSaveInfo(XmlElement infoRoot, XmlElement player) {
    for (final child in player.childElements) {
      if (_saveInfoGameFields.contains(child.name.local)) continue;
      final existing = infoRoot.findElements(child.name.local).firstOrNull;
      if (existing == null) {
        infoRoot.children.add(child.copy());
      } else {
        existing.replace(child.copy());
      }
    }
  }

  static String _seasonForSaveGame(String? season) => switch (season) {
    'spring' => '0',
    'summer' => '1',
    'fall' => '2',
    'winter' => '3',
    _ => '0',
  };
}

// ─────────────────────────────────────────────────────────────────────────
// Contexto del save (privado)
// ─────────────────────────────────────────────────────────────────────────

class _SwapContext {
  _SwapContext({
    required this.root,
    required this.player,
    required this.target,
    required this.targetHome,
    required this.targetName,
    required this.farm,
    required this.topFarmHouse,
    required this.farmhouseBuilding,
    required this.targetCabinBuilding,
  });

  final XmlElement root;
  final XmlElement player;
  final XmlElement target;
  final String targetHome;
  final String targetName;
  final XmlElement farm;
  final XmlElement topFarmHouse;
  final XmlElement farmhouseBuilding;
  final XmlElement targetCabinBuilding;
}

_SwapContext? _loadContext(XmlDocument doc, String targetUniqueId) {
  final root = doc.rootElement;
  final player = root.findElements('player').firstOrNull;
  final farmhandsEl = root.findElements('farmhands').firstOrNull;
  if (player == null || farmhandsEl == null) return null;

  XmlElement? target;
  for (final f in farmhandsEl.findElements('Farmer')) {
    if (_text(f, 'UniqueMultiplayerID') == targetUniqueId) {
      target = f;
      break;
    }
  }
  if (target == null) return null;
  final targetName = _text(target, 'name') ?? '';
  if (targetName.isEmpty) return null; // cabaña vacía, no es objetivo válido
  final targetHome = _text(target, 'homeLocation');
  if (targetHome == null || targetHome.isEmpty) return null;

  final locations = root.findElements('locations').firstOrNull;
  if (locations == null) return null;
  XmlElement? farm;
  XmlElement? topFarmHouse;
  for (final loc in locations.findElements('GameLocation')) {
    final name = _text(loc, 'name');
    if (name == 'Farm') farm = loc;
    if (name == 'FarmHouse') topFarmHouse = loc;
  }
  if (farm == null || topFarmHouse == null) return null;

  final buildingsEl = farm.findElements('buildings').firstOrNull;
  if (buildingsEl == null) return null;
  XmlElement? farmhouseBuilding;
  XmlElement? targetCabinBuilding;
  for (final b in buildingsEl.findElements('Building')) {
    final bt = _text(b, 'buildingType');
    if (bt == 'Farmhouse' && farmhouseBuilding == null) farmhouseBuilding = b;
    if (bt == 'Cabin') {
      final indoors = b.findElements('indoors').firstOrNull;
      final uniqueName = indoors != null ? _text(indoors, 'uniqueName') : null;
      if (uniqueName == targetHome) targetCabinBuilding = b;
    }
  }
  if (farmhouseBuilding == null || targetCabinBuilding == null) return null;

  return _SwapContext(
    root: root,
    player: player,
    target: target,
    targetHome: targetHome,
    targetName: targetName,
    farm: farm,
    topFarmHouse: topFarmHouse,
    farmhouseBuilding: farmhouseBuilding,
    targetCabinBuilding: targetCabinBuilding,
  );
}

// ─────────────────────────────────────────────────────────────────────────
// Planificación de reubicación (privado, sin mutar XML)
// ─────────────────────────────────────────────────────────────────────────

class _RelocationMove {
  const _RelocationMove(this.item, this.toX, this.toY);
  final XmlElement item;
  final int toX;
  final int toY;
}

class _RelocationPlan {
  const _RelocationPlan(this.itemsInFootprint, this.moves);

  /// Objetos que se moverán realmente (lo que ve el usuario).
  final int itemsInFootprint;

  /// Todos los movimientos a aplicar (incluye posibles víctimas desalojadas
  /// desde fuera de la huella para hacer sitio a un objeto prioritario).
  final List<_RelocationMove> moves;
}

class _Occupant {
  _Occupant(this.kind, {this.priority, this.item, this.type});
  final String kind; // building | footprint | item | relocated
  final String? priority; // alta | baja | ignorable
  final XmlElement? item;
  final String? type;
}

class _FootprintEntry {
  _FootprintEntry(this.item, this.type, this.priority, this.x, this.y);
  final XmlElement item;
  final String type;
  final String priority;
  final int x;
  final int y;
}

class _Candidate {
  const _Candidate(this.x, this.y, this.dist);
  final int x;
  final int y;
  final int dist;
}

class _HostSwapPlan {
  const _HostSwapPlan({required this.placement, required this.relocation});

  final HostSwapPlacement placement;
  final _RelocationPlan relocation;
}

_HostSwapPlan? _planHostSwap(_SwapContext ctx) {
  final whichFarm = _intText(ctx.root, 'whichFarm');
  if (whichFarm == null) return null;
  final surface = VanillaFarmSurfaceRepository.forWhichFarm(whichFarm);
  if (surface == null) return null;

  final farmhouse = _buildingGeometry(ctx.farmhouseBuilding, farmhouse: true);
  final cabin = _buildingGeometry(ctx.targetCabinBuilding, farmhouse: false);
  if (farmhouse == null || cabin == null) return null;

  final otherBuildingTiles = <TilePoint>{};
  final buildings = ctx.farm.findElements('buildings').firstOrNull;
  if (buildings == null) return null;
  for (final building in buildings.findElements('Building')) {
    if (identical(building, ctx.farmhouseBuilding) ||
        identical(building, ctx.targetCabinBuilding)) {
      continue;
    }
    final x = _intText(building, 'tileX');
    final y = _intText(building, 'tileY');
    final width = _intText(building, 'tilesWide');
    final height = _intText(building, 'tilesHigh');
    if (x == null || y == null || width == null || height == null) continue;
    for (var dx = 0; dx < width; dx++) {
      for (var dy = 0; dy < height; dy++) {
        otherBuildingTiles.add(TilePoint(x + dx, y + dy));
      }
    }
  }

  final placement = FarmPlacementService(surface).choose(
    farmhouse: farmhouse,
    cabin: cabin,
    otherBuildingTiles: otherBuildingTiles,
  );
  if (placement == null) return null;
  final relocation = _planRelocation(ctx, surface, placement);
  if (relocation == null) return null;
  return _HostSwapPlan(placement: placement, relocation: relocation);
}

BuildingGeometry? _buildingGeometry(
  XmlElement building, {
  required bool farmhouse,
}) {
  final x = _intText(building, 'tileX');
  final y = _intText(building, 'tileY');
  final width = _intText(building, 'tilesWide');
  final height = _intText(building, 'tilesHigh');
  final door = building.findElements('humanDoor').firstOrNull;
  final doorX = door == null ? null : _intText(door, 'X');
  final doorY = door == null ? null : _intText(door, 'Y');
  if (x == null ||
      y == null ||
      width == null ||
      height == null ||
      doorX == null ||
      doorY == null) {
    return null;
  }
  return BuildingGeometry(
    origin: TilePoint(x, y),
    width: width,
    height: height,
    doorOffset: TilePoint(doorX, doorY),
    collisionRows: farmhouse
        ? FarmPlacementService.farmhouseCollision
        : FarmPlacementService.cabinCollision,
    mailboxOffset: farmhouse ? const TilePoint(9, 4) : null,
    doorApproachOffset: farmhouse ? const TilePoint(5, 5) : null,
  );
}

/// Simula la reubicación completa (cascada de prioridad + dirección) sin
/// tocar el XML. Devuelve `null` si algún objeto no tiene hueco (noFreeTile).
_RelocationPlan? _planRelocation(
  _SwapContext ctx,
  FarmSurface surface,
  HostSwapPlacement placement,
) {
  final x0 = placement.farmhouse.origin.x;
  final y0 = placement.farmhouse.origin.y;
  final x1 = x0 + placement.farmhouse.width - 1;
  final y1 = y0 + placement.farmhouse.height - 1;
  final reserved = placement.reservedTiles;

  final occupancy = <String, _Occupant>{};
  void setOcc(int x, int y, _Occupant o) => occupancy['$x,$y'] = o;
  _Occupant? getOcc(int x, int y) => occupancy['$x,$y'];
  bool isFree(int x, int y) {
    final tile = TilePoint(x, y);
    return surface.isBuildable(tile) &&
        surface.isPassable(tile) &&
        !surface.isWater(tile) &&
        !reserved.contains(tile) &&
        !occupancy.containsKey('$x,$y');
  }

  final buildingsEl = ctx.farm.findElements('buildings').firstOrNull;
  if (buildingsEl == null) return null;
  for (final b in buildingsEl.findElements('Building')) {
    if (identical(b, ctx.farmhouseBuilding) ||
        identical(b, ctx.targetCabinBuilding)) {
      continue;
    }
    final bx = _intText(b, 'tileX');
    final by = _intText(b, 'tileY');
    final bw = _intText(b, 'tilesWide');
    final bh = _intText(b, 'tilesHigh');
    if (bx == null || by == null || bw == null || bh == null) continue;
    for (var ix = bx; ix < bx + bw; ix++) {
      for (var iy = by; iy < by + bh; iy++) {
        setOcc(ix, iy, _Occupant('building'));
      }
    }
  }
  for (final tile in reserved) {
    setOcc(tile.x, tile.y, _Occupant('footprint'));
  }

  final registered = <_FootprintEntry>[];
  void registerContainer(String containerName) {
    final container = ctx.farm.findElements(containerName).firstOrNull;
    if (container == null) return;
    for (final item in container.findElements('item')) {
      final vec = item
          .findElements('key')
          .firstOrNull
          ?.findElements('Vector2')
          .firstOrNull;
      if (vec == null) continue;
      final tx = _intText(vec, 'X');
      final ty = _intText(vec, 'Y');
      if (tx == null || ty == null) continue;
      final existing = getOcc(tx, ty);
      if (existing != null && existing.kind == 'building') continue;
      final valChild = item
          .findElements('value')
          .firstOrNull
          ?.children
          .whereType<XmlElement>()
          .firstOrNull;
      if (valChild == null) continue;
      final type = _itemType(valChild);
      final priority = _itemPriority(valChild, type);
      final entry = _FootprintEntry(item, type, priority, tx, ty);
      registered.add(entry);
      setOcc(
        tx,
        ty,
        _Occupant('item', priority: priority, item: item, type: type),
      );
    }
  }

  registerContainer('objects');
  registerContainer('terrainFeatures');
  registerContainer('largeTerrainFeatures');

  final furniture = ctx.farm.findElements('furniture').firstOrNull;
  if (furniture != null) {
    for (final item in furniture.children.whereType<XmlElement>()) {
      final tile = item.findElements('tileLocation').firstOrNull;
      final box = item.findElements('boundingBox').firstOrNull;
      final tx = tile == null ? null : _intText(tile, 'X');
      final ty = tile == null ? null : _intText(tile, 'Y');
      final width = box == null ? null : _intText(box, 'Width');
      final height = box == null ? null : _intText(box, 'Height');
      // El plan actual reubica por casilla. Si aparece mobiliario exterior
      // de varias casillas, abortamos en vez de recortarlo o solaparlo.
      if (tx == null ||
          ty == null ||
          width == null ||
          height == null ||
          width <= 0 ||
          height <= 0 ||
          width > 64 ||
          height > 64) {
        return null;
      }
      final existing = getOcc(tx, ty);
      if (existing != null && existing.kind == 'building') continue;
      final type = _text(item, 'name') ?? 'Furniture';
      final entry = _FootprintEntry(item, type, 'alta', tx, ty);
      registered.add(entry);
      setOcc(
        tx,
        ty,
        _Occupant('item', priority: 'alta', item: item, type: type),
      );
    }
  }

  final toMove = registered
      .where(
        (entry) =>
            reserved.contains(TilePoint(entry.x, entry.y)) &&
            entry.priority != 'ignorable',
      )
      .toList(growable: false);
  for (final entry in toMove) {
    final current = getOcc(entry.x, entry.y);
    if (identical(current?.item, entry.item)) {
      occupancy.remove('${entry.x},${entry.y}');
      setOcc(entry.x, entry.y, _Occupant('footprint'));
    }
  }
  final high = toMove.where((e) => e.priority == 'alta').toList();
  final low = toMove.where((e) => e.priority == 'baja').toList();

  int directionalScore(int tx, int ty) {
    if (ty < y0) return 1000; // norte / detrás: el sprite lo tapa
    if (ty > y1) return 0; // sur / delante: preferido
    if (tx < x0 || tx > x1) return 10; // lado, misma franja Y: aceptable
    return 500;
  }

  List<_Candidate> areaCandidates(int fromX, int fromY, int maxRadius) {
    final area = <_Candidate>[];
    for (var dx = -maxRadius; dx <= maxRadius; dx++) {
      for (var dy = -maxRadius; dy <= maxRadius; dy++) {
        if (dx == 0 && dy == 0) continue;
        final dist = math.max(dx.abs(), dy.abs());
        area.add(_Candidate(fromX + dx, fromY + dy, dist));
      }
    }
    area.sort((a, b) {
      final sa = directionalScore(a.x, a.y);
      final sb = directionalScore(b.x, b.y);
      if (sa != sb) return sa.compareTo(sb);
      return a.dist.compareTo(b.dist);
    });
    return area;
  }

  _Candidate? findFreeTile(int fromX, int fromY, int maxRadius) {
    for (final c in areaCandidates(fromX, fromY, maxRadius)) {
      if (isFree(c.x, c.y)) return c;
    }
    return null;
  }

  ({_Candidate tile, _FootprintEntry? evict})? findCloseTileWithEviction(
    int fromX,
    int fromY,
    int maxRadius,
  ) {
    final area = areaCandidates(fromX, fromY, maxRadius);
    for (final c in area) {
      if (isFree(c.x, c.y)) return (tile: c, evict: null);
    }
    for (final c in area) {
      final occ = getOcc(c.x, c.y);
      if (occ != null && occ.kind == 'item' && occ.priority == 'baja') {
        return (
          tile: c,
          evict: _FootprintEntry(occ.item!, occ.type!, occ.priority!, c.x, c.y),
        );
      }
    }
    return null;
  }

  final moves = <_RelocationMove>[];

  for (final entry in high) {
    final result = findCloseTileWithEviction(
      entry.x,
      entry.y,
      HostSwapService._closeRadius,
    );
    if (result == null) return null;
    final dest = result.tile;
    final evict = result.evict;
    if (evict != null) {
      final farDest = findFreeTile(
        evict.x,
        evict.y,
        HostSwapService._farRadius,
      );
      if (farDest == null) return null;
      moves.add(_RelocationMove(evict.item, farDest.x, farDest.y));
      occupancy.remove('${evict.x},${evict.y}');
      setOcc(farDest.x, farDest.y, _Occupant('relocated'));
    }
    moves.add(_RelocationMove(entry.item, dest.x, dest.y));
    setOcc(dest.x, dest.y, _Occupant('relocated'));
  }

  for (final entry in low) {
    final dest = findFreeTile(entry.x, entry.y, HostSwapService._farRadius);
    if (dest == null) return null;
    moves.add(_RelocationMove(entry.item, dest.x, dest.y));
    occupancy.remove('${entry.x},${entry.y}');
    setOcc(dest.x, dest.y, _Occupant('relocated'));
  }

  // El aviso debe corresponder a todo lo que realmente se moverá, incluidas
  // las posibles víctimas de baja prioridad desalojadas para salvar un cofre
  // o cultivo importante.
  return _RelocationPlan(moves.length, moves);
}

String _itemType(XmlElement valChild) {
  final xsiType = valChild.attributes
      .where((a) => a.name.qualified == 'xsi:type')
      .firstOrNull
      ?.value;
  return xsiType ?? _text(valChild, 'name') ?? valChild.name.local;
}

String _itemPriority(XmlElement valChild, String type) {
  if (HostSwapService._ignorableTypes.contains(type)) return 'ignorable';
  if (type == 'Chest') return 'alta';
  if (valChild.findElements('crop').isNotEmpty) return 'alta';
  return 'baja';
}

// ─────────────────────────────────────────────────────────────────────────
// Mutación XML (privado — solo se llama desde execute)
// ─────────────────────────────────────────────────────────────────────────

void _moveItemTo(XmlElement item, int newX, int newY) {
  final vec = item
      .findElements('key')
      .firstOrNull
      ?.findElements('Vector2')
      .firstOrNull;
  if (vec != null) {
    _setElementValue(vec, 'X', newX.toString());
    _setElementValue(vec, 'Y', newY.toString());
  }
  final val = item.name.local == 'Furniture'
      ? item
      : item
            .findElements('value')
            .firstOrNull
            ?.children
            .whereType<XmlElement>()
            .firstOrNull;
  if (val == null) return;

  final tileLoc = val.findElements('tileLocation').firstOrNull;
  if (tileLoc != null) {
    _setElementValue(tileLoc, 'X', newX.toString());
    _setElementValue(tileLoc, 'Y', newY.toString());
  }

  // Objetos "grandes" (Chest y similares) guardan también su posición en
  // píxeles — sin este fix el objeto se mueve en los datos pero el punto de
  // clic se queda en el sitio viejo (inaccesible). Verificado en juego real.
  final bbox = val.findElements('boundingBox').firstOrNull;
  if (bbox != null) {
    final pxX = newX * 64;
    final pxY = newY * 64;
    _setElementValue(bbox, 'X', pxX.toString());
    _setElementValue(bbox, 'Y', pxY.toString());
    final loc = bbox.findElements('Location').firstOrNull;
    if (loc != null) {
      _setElementValue(loc, 'X', pxX.toString());
      _setElementValue(loc, 'Y', pxY.toString());
    }
  }
  final defaultBox = val.findElements('defaultBoundingBox').firstOrNull;
  if (defaultBox != null) {
    final pxX = newX * 64;
    final pxY = newY * 64;
    _setElementValue(defaultBox, 'X', pxX.toString());
    _setElementValue(defaultBox, 'Y', pxY.toString());
    final loc = defaultBox.findElements('Location').firstOrNull;
    if (loc != null) {
      _setElementValue(loc, 'X', pxX.toString());
      _setElementValue(loc, 'Y', pxY.toString());
    }
  }
}

/// La elección de la cueva es estado de la granja, aunque Stardew la guarda
/// dentro del anfitrión. Solo transferimos ese dato global y su evento 65;
/// nunca copiamos el historial personal completo del host saliente.
void _preserveFarmCaveChoice(XmlElement oldHost, XmlElement newHost) {
  final choice = _intText(oldHost, 'caveChoice') ?? 0;
  _setElementValue(newHost, 'caveChoice', choice > 0 ? '$choice' : '0');

  var events = newHost.findElements('eventsSeen').firstOrNull;
  if (events == null) {
    events = XmlElement(XmlName('eventsSeen'));
    newHost.children.add(events);
  }
  final caveEvents = events
      .findElements('int')
      .where((event) => event.innerText.trim() == '65')
      .toList(growable: false);
  if (choice > 0 && caveEvents.isEmpty) {
    events.children.add(XmlElement(XmlName('int'), [], [XmlText('65')]));
  } else if (choice <= 0) {
    for (final event in caveEvents) {
      event.parent?.children.remove(event);
    }
  }
}

void _copyInteriorContent({
  required XmlElement source,
  required XmlElement target,
}) {
  for (final field in HostSwapService._contentFields) {
    final sourceNode = source.findElements(field).firstOrNull;
    final targetNode = target.findElements(field).firstOrNull;
    if (sourceNode == null || targetNode == null) continue;
    _replaceElement(targetNode, sourceNode.copy());
  }
}

void _replaceElement(XmlElement oldEl, XmlElement newEl) {
  final parent = oldEl.parent;
  if (parent == null) return;
  final idx = parent.children.indexOf(oldEl);
  if (idx == -1) return;
  parent.children
    ..removeAt(idx)
    ..insert(idx, newEl);
}

void _setElementValue(XmlElement parent, String name, String value) {
  final existing = parent.findElements(name).firstOrNull;
  if (existing == null) {
    final newEl = XmlElement(XmlName(name));
    _setText(newEl, value);
    parent.children.add(newEl);
  } else {
    _setText(existing, value);
  }
}

void _setText(XmlElement el, String value) {
  el.children.clear();
  el.children.add(XmlText(value));
}

void _setNetStringNil(XmlElement parent, String name) {
  var e = parent.findElements(name).firstOrNull;
  if (e == null) {
    e = XmlElement(XmlName(name));
    parent.children.add(e);
  } else {
    e.children.clear();
  }
  final s = XmlElement(XmlName('string'));
  s.attributes.add(XmlAttribute(XmlName('nil', 'xsi'), 'true'));
  e.children.add(s);
}

// ─────────────────────────────────────────────────────────────────────────
// Helpers de archivo/XML genéricos
// ─────────────────────────────────────────────────────────────────────────

String? _text(XmlElement parent, String childName) =>
    parent.findElements(childName).firstOrNull?.innerText;

int? _intText(XmlElement parent, String childName) {
  final t = _text(parent, childName);
  if (t == null) return null;
  return double.tryParse(t)?.toInt();
}

/// Zipea [folderPath] (solo archivos de primer nivel) con [folderName] como
/// raíz — MISMO formato que `TransferService.exportSave` (spec 007, D5:
/// un solo pipeline de import para cualquier origen de zip).
Future<File?> _zipFolder(
  String folderPath,
  String folderName,
  String backupsDir,
) async {
  try {
    final sourceDir = Directory(folderPath);
    final archive = Archive();
    await for (final entity in sourceDir.list(recursive: false)) {
      if (entity is! File) continue;
      final name = entity.uri.pathSegments.last;
      final bytes = await entity.readAsBytes();
      archive.addFile(ArchiveFile.bytes('$folderName/$name', bytes));
    }
    final zipBytes = ZipEncoder().encodeBytes(archive);
    final dir = Directory(backupsDir);
    await dir.create(recursive: true);
    final sep = Platform.pathSeparator;
    final outFile = File(
      '$backupsDir$sep${folderName}_pre-swap_${_backupTimestamp()}.zip',
    );
    await outFile.writeAsBytes(zipBytes);
    return outFile;
  } catch (_) {
    return null;
  }
}

/// Confirma que el zip generado es un save real ANTES de reemplazar el
/// original (G4) — mismo criterio mínimo que `TransferService.importArchive`.
/// Delega en [verifyBackupZipContents] (FR-002: un solo sitio que lo haga).
Future<bool> _verifyBackupZip(File zipFile, String folderName) =>
    verifyBackupZipContents(zipFile.path, folderName);

/// Integridad ESPECÍFICA del swap de anfitrión (no la genérica de "esto es
/// un save cargable", que ya cubre `SaveReplaceService`): el nuevo host es
/// realmente host, el anterior deja de serlo, el número de jugadores no
/// cambia, `uniqueIDForThisGame` se conserva, y no quedan `_old` sobrantes
/// en [dir]. Extraída para poder correrla tanto sobre la copia de trabajo
/// ANTES del swap como, vía el `validate` de `replaceSaveFolder`, sobre el
/// destino ya publicado — una corrupción durante la copia a staging o el
/// rename final la detectaría esta comprobación, no solo la genérica del
/// núcleo (integrado tras sugerencia de la implementación paralela de
/// Codex, 2026-07-18).
Future<bool> _isHostSwapIntegrityValid(
  Directory dir, {
  required String folderName,
  required String targetUniqueId,
  required String oldHostId,
  required String originalId,
  required String targetHome,
  required TilePoint expectedFarmhouseDoor,
  required TilePoint expectedCabinDoor,
  required int expectedCaveChoice,
  required String? originalFarmCaveXml,
}) async {
  final sep = Platform.pathSeparator;
  final mainFile = File('${dir.path}$sep$folderName');
  if (!await mainFile.exists()) return false;
  try {
    final verifyRaw = await mainFile.readAsString();
    final players = SaveService.parseFullSave(verifyRaw);
    final newHost = players
        .where((p) => p.uniqueId == targetUniqueId)
        .firstOrNull;
    final oldHostVerify = players
        .where((p) => p.uniqueId == oldHostId)
        .firstOrNull;
    final verifyDoc = XmlDocument.parse(verifyRaw);
    final verifyId = _text(verifyDoc.rootElement, 'uniqueIDForThisGame');
    final locations = verifyDoc.rootElement
        .findElements('locations')
        .firstOrNull;
    if (locations == null) return false;
    final farm = locations
        .findElements('GameLocation')
        .where((location) => _text(location, 'name') == 'Farm')
        .firstOrNull;
    final buildings = farm?.findElements('buildings').firstOrNull;
    if (farm == null || buildings == null) return false;
    final farmhouse = buildings
        .findElements('Building')
        .where((building) => _text(building, 'buildingType') == 'Farmhouse')
        .firstOrNull;
    final cabin = buildings.findElements('Building').where((building) {
      if (_text(building, 'buildingType') != 'Cabin') return false;
      final indoors = building.findElements('indoors').firstOrNull;
      return indoors != null && _text(indoors, 'uniqueName') == targetHome;
    }).firstOrNull;
    if (farmhouse == null || cabin == null) return false;
    final newHostXml = verifyDoc.rootElement.findElements('player').firstOrNull;
    if (newHostXml == null) return false;
    final caveChoice = _intText(newHostXml, 'caveChoice') ?? 0;
    final hasCaveEvent = newHostXml
        .findElements('eventsSeen')
        .expand((events) => events.findElements('int'))
        .any((event) => event.innerText.trim() == '65');
    final caveEventOk = expectedCaveChoice > 0 ? hasCaveEvent : !hasCaveEvent;
    final caveLocationOk =
        _locationXml(verifyDoc.rootElement, 'FarmCave') == originalFarmCaveXml;

    var hasOldFiles = false;
    await for (final e in dir.list()) {
      if (e is File && e.path.endsWith('_old')) {
        hasOldFiles = true;
        break;
      }
    }

    return newHost != null &&
        newHost.isHost &&
        oldHostVerify != null &&
        !oldHostVerify.isHost &&
        players.length >= 2 &&
        verifyId == originalId &&
        _absoluteBuildingDoor(farmhouse) == expectedFarmhouseDoor &&
        _absoluteBuildingDoor(cabin) == expectedCabinDoor &&
        caveChoice == expectedCaveChoice &&
        caveEventOk &&
        caveLocationOk &&
        !hasOldFiles;
  } catch (_) {
    return false;
  }
}

TilePoint? _absoluteBuildingDoor(XmlElement building) {
  final x = _intText(building, 'tileX');
  final y = _intText(building, 'tileY');
  final door = building.findElements('humanDoor').firstOrNull;
  if (x == null || y == null || door == null) return null;
  final doorX = _intText(door, 'X');
  final doorY = _intText(door, 'Y');
  if (doorX == null || doorY == null) return null;
  return TilePoint(x + doorX, y + doorY);
}

String? _locationXml(XmlElement root, String name) => root
    .findElements('locations')
    .firstOrNull
    ?.findElements('GameLocation')
    .where((location) => _text(location, 'name') == name)
    .firstOrNull
    ?.toXmlString(pretty: false);

String _backupTimestamp() {
  final now = DateTime.now();
  String p(int n) => n.toString().padLeft(2, '0');
  return '${now.year}${p(now.month)}${p(now.day)}-${p(now.hour)}${p(now.minute)}${p(now.second)}';
}

Future<void> _safeDeleteFile(File file) async {
  try {
    if (await file.exists()) await file.delete();
  } catch (_) {
    // best-effort
  }
}

/// Pública para que otros callers (p. ej. el puente de Shizuku/root en
/// Android) puedan preparar su propia copia de trabajo sin duplicar esta
/// lógica — [HostSwapService] la usa internamente para su copia temporal.
Future<void> copyDirectory(Directory src, Directory dst) async {
  await dst.create(recursive: true);
  await for (final entity in src.list(recursive: false)) {
    final name = entity.path.split(Platform.pathSeparator).last;
    final newPath = '${dst.path}${Platform.pathSeparator}$name';
    if (entity is Directory) {
      await copyDirectory(entity, Directory(newPath));
    } else if (entity is File) {
      await entity.copy(newPath);
    }
  }
}

Future<void> _safeDelete(Directory dir) async {
  try {
    if (await dir.exists()) await dir.delete(recursive: true);
  } catch (_) {
    // best-effort: si no se puede borrar, el error original ya se reporta
  }
}
