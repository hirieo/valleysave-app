import 'dart:convert';
import 'dart:io';
import 'dart:math' as math;

import 'package:archive/archive.dart';
import 'package:xml/xml.dart';

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

  /// Nº de objetos NO ignorables (Weeds/Grass excluidos) dentro de la huella
  /// nueva de la casa — es el "N" que ve el usuario en el diálogo.
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

  /// Objetos reubicados dentro de la huella — igual a `itemsToRelocate` del
  /// análisis previo sobre el mismo save (contrato G10 de 005).
  final int relocatedCount;
}

/// Cambio de anfitrión 100% local: copia el save, reubica por prioridad los
/// objetos que colisionan con la huella nueva de la Farmhouse, intercambia los
/// nodos de jugador y los edificios, y valida el resultado antes de aceptarlo.
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

      final plan = _planRelocation(ctx);
      if (plan == null) {
        return HostSwapAnalysis(
          ok: false,
          error: HostSwapError.noFreeTile,
          targetName: ctx.targetName,
        );
      }

      return HostSwapAnalysis(
        ok: true,
        itemsToRelocate: plan.itemsInFootprint,
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
      // original en [saveFolderPath] no se toca hasta el paso 5.
      tempRoot = await Directory.systemTemp.createTemp('vs_swap_');
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

      final plan = _planRelocation(ctx);
      if (plan == null) {
        await _safeDelete(tempRoot);
        return const HostSwapResult(ok: false, error: HostSwapError.noFreeTile);
      }
      for (final m in plan.moves) {
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

      // Host saliente: el <Farmer> objetivo pasa a tener los datos del host.
      ctx.target.children.clear();
      ctx.target.children.addAll(oldHostClone.children.map((c) => c.copy()));
      _setElementValue(ctx.target, 'homeLocation', ctx.targetHome);
      _setElementValue(ctx.target, 'slotCanHost', 'false');

      // Intercambiar tiles de los 2 edificios (único modo viable — ver
      // investigación: el host SIEMPRE vive en buildingType=Farmhouse).
      final fx = _text(ctx.farmhouseBuilding, 'tileX') ?? '0';
      final fy = _text(ctx.farmhouseBuilding, 'tileY') ?? '0';
      final cx = _text(ctx.targetCabinBuilding, 'tileX') ?? '0';
      final cy = _text(ctx.targetCabinBuilding, 'tileY') ?? '0';
      _setElementValue(ctx.farmhouseBuilding, 'tileX', cx);
      _setElementValue(ctx.farmhouseBuilding, 'tileY', cy);
      _setElementValue(ctx.targetCabinBuilding, 'tileX', fx);
      _setElementValue(ctx.targetCabinBuilding, 'tileY', fy);

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

      // Validación post-swap (delta: automática, no manual).
      final verifyRaw = await newMain.readAsString();
      final players = SaveService.parseFullSave(verifyRaw);
      final newHost = players
          .where((p) => p.uniqueId == targetUniqueId)
          .firstOrNull;
      final oldHostVerify = players
          .where((p) => p.uniqueId == oldHostId)
          .firstOrNull;
      final verifyDoc = XmlDocument.parse(verifyRaw);
      final verifyId = _text(verifyDoc.rootElement, 'uniqueIDForThisGame');

      var hasOldFiles = false;
      await for (final e in workDir.list()) {
        if (e is File && e.path.endsWith('_old')) {
          hasOldFiles = true;
          break;
        }
      }

      final integrityOk =
          newHost != null &&
          newHost.isHost &&
          oldHostVerify != null &&
          !oldHostVerify.isHost &&
          players.length >= 2 &&
          verifyId == originalId &&
          !hasOldFiles;

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

      // Paso 5-7: rename dance. Si el segundo rename falla, se revierte el
      // primero — el original NUNCA queda sin nombre válido (G1).
      final originalDir = Directory(saveFolderPath);
      final oldTmp = Directory(
        '${originalDir.parent.path}$sep${folderName}_old_tmp',
      );
      if (await oldTmp.exists()) await oldTmp.delete(recursive: true);
      await originalDir.rename(oldTmp.path);
      try {
        await workDir.rename(saveFolderPath);
      } catch (_) {
        await oldTmp.rename(saveFolderPath);
        await _safeDeleteFile(backupZip);
        await _safeDelete(tempRoot);
        return const HostSwapResult(
          ok: false,
          error: HostSwapError.writeFailure,
        );
      }
      await _safeDelete(oldTmp);
      await _safeDelete(tempRoot);

      return HostSwapResult(
        ok: true,
        backupZipPath: backupZip.path,
        relocatedCount: plan.itemsInFootprint,
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
    required this.player,
    required this.target,
    required this.targetHome,
    required this.targetName,
    required this.farm,
    required this.topFarmHouse,
    required this.farmhouseBuilding,
    required this.targetCabinBuilding,
  });

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

  /// Objetos NO ignorables dentro de la huella nueva (lo que ve el usuario).
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

/// Simula la reubicación completa (cascada de prioridad + dirección) sin
/// tocar el XML. Devuelve `null` si algún objeto no tiene hueco (noFreeTile).
_RelocationPlan? _planRelocation(_SwapContext ctx) {
  final fw = _intText(ctx.farmhouseBuilding, 'tilesWide');
  final fh = _intText(ctx.farmhouseBuilding, 'tilesHigh');
  final x0 = _intText(ctx.targetCabinBuilding, 'tileX');
  final y0 = _intText(ctx.targetCabinBuilding, 'tileY');
  if (fw == null || fh == null || x0 == null || y0 == null) return null;
  final x1 = x0 + fw - 1;
  final y1 = y0 + fh - 1;

  final occupancy = <String, _Occupant>{};
  void setOcc(int x, int y, _Occupant o) => occupancy['$x,$y'] = o;
  _Occupant? getOcc(int x, int y) => occupancy['$x,$y'];
  bool isFree(int x, int y) => !occupancy.containsKey('$x,$y');

  final buildingsEl = ctx.farm.findElements('buildings').firstOrNull;
  if (buildingsEl == null) return null;
  for (final b in buildingsEl.findElements('Building')) {
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
  for (var ix = x0; ix <= x1; ix++) {
    for (var iy = y0; iy <= y1; iy++) {
      setOcc(ix, iy, _Occupant('footprint'));
    }
  }

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

  final toMove = <_FootprintEntry>[];
  for (var ix = x0; ix <= x1; ix++) {
    for (var iy = y0; iy <= y1; iy++) {
      final occ = getOcc(ix, iy);
      if (occ != null && occ.kind == 'item') {
        toMove.add(
          _FootprintEntry(occ.item!, occ.type!, occ.priority!, ix, iy),
        );
      }
    }
  }
  final high = toMove.where((e) => e.priority == 'alta').toList();
  final low = toMove.where((e) => e.priority == 'baja').toList();
  final itemsInFootprint =
      high.length + low.length; // ignorable: ni se mueve ni se cuenta

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
    if (isFree(entry.x, entry.y)) continue; // ya reubicado como víctima
    final occNow = getOcc(entry.x, entry.y);
    if (occNow == null || occNow.kind != 'item') continue;
    final dest = findFreeTile(entry.x, entry.y, HostSwapService._farRadius);
    if (dest == null) return null;
    moves.add(_RelocationMove(entry.item, dest.x, dest.y));
    occupancy.remove('${entry.x},${entry.y}');
    setOcc(dest.x, dest.y, _Occupant('relocated'));
  }

  return _RelocationPlan(itemsInFootprint, moves);
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
  final val = item
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
Future<bool> _verifyBackupZip(File zipFile, String folderName) async {
  try {
    final bytes = await zipFile.readAsBytes();
    final archive = ZipDecoder().decodeBytes(bytes);
    ArchiveFile? info;
    ArchiveFile? main;
    for (final f in archive.files) {
      final name = f.name.replaceAll('\\', '/');
      if (name == '$folderName/SaveGameInfo') info = f;
      if (name == '$folderName/$folderName') main = f;
    }
    if (info == null || main == null) return false;
    final infoXml = utf8.decode(info.content, allowMalformed: true);
    final parsed = SaveService.parseSaveGameInfo(
      infoXml,
      folderName: folderName,
      lastModified: DateTime.now(),
    );
    return parsed != null;
  } catch (_) {
    return false;
  }
}

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
