import 'dart:collection';
import 'dart:convert';
import 'dart:typed_data';

import '../data/vanilla_farm_surfaces_data.dart';

class TilePoint {
  const TilePoint(this.x, this.y);

  final int x;
  final int y;

  TilePoint operator +(TilePoint other) => TilePoint(x + other.x, y + other.y);
  TilePoint operator -(TilePoint other) => TilePoint(x - other.x, y - other.y);

  int manhattanTo(TilePoint other) => (x - other.x).abs() + (y - other.y).abs();

  @override
  bool operator ==(Object other) =>
      other is TilePoint && other.x == x && other.y == y;

  @override
  int get hashCode => Object.hash(x, y);

  @override
  String toString() => '($x,$y)';
}

class FarmSurface {
  FarmSurface._({
    required this.name,
    required this.width,
    required this.height,
    required this._water,
    required this._passable,
    required this._buildable,
    required this._fishable,
    required this.anchors,
  });

  factory FarmSurface.fromData(Map<String, Object> data) {
    Uint8List decode(String key) => base64Decode(data[key]! as String);
    final width = data['width']! as int;
    final height = data['height']! as int;
    final expectedBytes = ((width * height) + 7) ~/ 8;
    final water = decode('water');
    final passable = decode('passable');
    final buildable = decode('buildable');
    final fishable = decode('fishable');
    if (water.length != expectedBytes ||
        passable.length != expectedBytes ||
        buildable.length != expectedBytes ||
        fishable.length != expectedBytes) {
      throw const FormatException('Invalid vanilla farm surface bitset');
    }
    return FarmSurface._(
      name: data['name']! as String,
      width: width,
      height: height,
      water: water,
      passable: passable,
      buildable: buildable,
      fishable: fishable,
      anchors: (data['anchors']! as List<int>)
          .map((index) => TilePoint(index % width, index ~/ width))
          .toList(growable: false),
    );
  }

  final String name;
  final int width;
  final int height;
  final Uint8List _water;
  final Uint8List _passable;
  final Uint8List _buildable;
  final Uint8List _fishable;
  final List<TilePoint> anchors;

  bool contains(TilePoint tile) =>
      tile.x >= 0 && tile.y >= 0 && tile.x < width && tile.y < height;

  bool isWater(TilePoint tile) => _read(_water, tile);
  bool isPassable(TilePoint tile) => _read(_passable, tile);
  bool isBuildable(TilePoint tile) => _read(_buildable, tile);
  bool isFishingAllowed(TilePoint tile) => _read(_fishable, tile);

  bool _read(Uint8List bytes, TilePoint tile) {
    if (!contains(tile)) return false;
    final index = tile.y * width + tile.x;
    return bytes[index ~/ 8] & (1 << (index % 8)) != 0;
  }
}

class VanillaFarmSurfaceRepository {
  VanillaFarmSurfaceRepository._();

  static final Map<int, FarmSurface> _surfaces = {
    for (final entry in vanillaFarmSurfaceData.entries)
      entry.key: FarmSurface.fromData(entry.value),
  };

  static FarmSurface? forWhichFarm(int whichFarm) => _surfaces[whichFarm];
}

class BuildingGeometry {
  const BuildingGeometry({
    required this.origin,
    required this.width,
    required this.height,
    required this.doorOffset,
    required this.collisionRows,
    this.mailboxOffset,
    this.doorApproachOffset,
  });

  final TilePoint origin;
  final int width;
  final int height;
  final TilePoint doorOffset;
  final List<String> collisionRows;
  final TilePoint? mailboxOffset;
  final TilePoint? doorApproachOffset;

  TilePoint get absoluteDoor => origin + doorOffset;

  BuildingGeometry at(TilePoint newOrigin) => BuildingGeometry(
    origin: newOrigin,
    width: width,
    height: height,
    doorOffset: doorOffset,
    collisionRows: collisionRows,
    mailboxOffset: mailboxOffset,
    doorApproachOffset: doorApproachOffset,
  );

  Set<TilePoint> collisionTiles() {
    final result = <TilePoint>{};
    for (var y = 0; y < collisionRows.length; y++) {
      final row = collisionRows[y];
      for (var x = 0; x < row.length; x++) {
        if (row[x] == 'X') result.add(origin + TilePoint(x, y));
      }
    }
    return result;
  }

  Set<TilePoint> walkableTiles() {
    final result = <TilePoint>{};
    for (var y = 0; y < collisionRows.length; y++) {
      final row = collisionRows[y];
      for (var x = 0; x < row.length; x++) {
        if (row[x] == 'O') result.add(origin + TilePoint(x, y));
      }
    }
    return result;
  }

  Set<TilePoint> footprintTiles() => {
    for (var y = 0; y < height; y++)
      for (var x = 0; x < width; x++) origin + TilePoint(x, y),
  };
}

class HostSwapPlacement {
  const HostSwapPlacement({
    required this.farmhouse,
    required this.cabin,
    required this.mailbox,
    required this.mailboxApproach,
    required this.doorApproach,
    required this.reservedTiles,
  });

  final BuildingGeometry farmhouse;
  final BuildingGeometry cabin;
  final TilePoint mailbox;
  final TilePoint mailboxApproach;
  final TilePoint doorApproach;

  /// Casillas que deben quedar libres de objetos dinámicos. Incluye ambas
  /// viviendas, buzón, salida y el camino corto entre puerta y buzón.
  final Set<TilePoint> reservedTiles;
}

class FarmPlacementService {
  const FarmPlacementService(this.surface);

  /// A building may force a small walk around its walls, but it must never
  /// seal a vanilla choke point and turn a nearby exit into a map-wide detour.
  static const _maxExitDetour = 12;
  static const farmhouseCollision = <String>[
    'XXXXXXXXX',
    'XXXXXXXXX',
    'XXXXXXXXX',
    'XOOOOOOOX',
    'XXXXOOOXXX',
  ];
  static const cabinCollision = <String>['XXXXX', 'XXXXX', 'OOOOX'];
  static const _directions = <TilePoint>[
    TilePoint(0, 1),
    TilePoint(1, 0),
    TilePoint(-1, 0),
    TilePoint(0, -1),
  ];

  final FarmSurface surface;

  HostSwapPlacement? choose({
    required BuildingGeometry farmhouse,
    required BuildingGeometry cabin,
    required Set<TilePoint> otherBuildingTiles,
  }) {
    final oldFarmhouseDoor = farmhouse.absoluteDoor;
    final oldCabinDoor = cabin.absoluteDoor;
    final oldCabinApproach =
        cabin.origin + TilePoint(cabin.doorOffset.x, cabin.height);
    final baselineBlocked = <TilePoint>{
      ...otherBuildingTiles,
      ...farmhouse.collisionTiles(),
      ...cabin.collisionTiles(),
    };
    final baselineReachable = _reachableTiles(
      oldCabinApproach,
      baselineBlocked,
    );
    if (baselineReachable.isEmpty) return null;
    final cabinDestination = cabin.at(oldFarmhouseDoor - cabin.doorOffset);
    final cabinBlocked = cabinDestination.collisionTiles();
    final routeBaselineBlocked = <TilePoint>{
      ...otherBuildingTiles,
      ...cabinBlocked,
    };
    final baselineExitDistances = {
      for (final anchor in surface.anchors)
        anchor: _distanceMap(anchor, routeBaselineBlocked),
    };
    if (!_buildingFits(cabinDestination, otherBuildingTiles) ||
        !_canStand(
          cabinDestination.origin + TilePoint(cabin.doorOffset.x, cabin.height),
          otherBuildingTiles.union(cabinBlocked),
        )) {
      return null;
    }

    final exactOrigin = oldCabinDoor - farmhouse.doorOffset;
    final candidateOrigins = <TilePoint>[
      for (var y = 0; y <= surface.height - farmhouse.height; y++)
        for (var x = 0; x <= surface.width - farmhouse.width; x++)
          TilePoint(x, y),
    ];
    candidateOrigins.sort((a, b) {
      final aDoor = farmhouse.at(a).absoluteDoor;
      final bDoor = farmhouse.at(b).absoluteDoor;
      final distance = aDoor
          .manhattanTo(oldCabinDoor)
          .compareTo(bDoor.manhattanTo(oldCabinDoor));
      if (distance != 0) return distance;
      final vertical = (aDoor.y - oldCabinDoor.y).abs().compareTo(
        (bDoor.y - oldCabinDoor.y).abs(),
      );
      if (vertical != 0) return vertical;
      final originDistance = a
          .manhattanTo(exactOrigin)
          .compareTo(b.manhattanTo(exactOrigin));
      if (originDistance != 0) return originDistance;
      final horizontal = a.x.compareTo(b.x);
      return horizontal != 0 ? horizontal : a.y.compareTo(b.y);
    });

    for (final origin in candidateOrigins) {
      final candidate = farmhouse.at(origin);
      final collision = candidate.collisionTiles();
      final blocked = <TilePoint>{
        ...otherBuildingTiles,
        ...cabinBlocked,
        ...collision,
      };
      if (!_buildingFits(candidate, otherBuildingTiles.union(cabinBlocked))) {
        continue;
      }

      final mailboxOffset = candidate.mailboxOffset;
      final doorApproachOffset = candidate.doorApproachOffset;
      if (mailboxOffset == null || doorApproachOffset == null) continue;
      final mailbox = candidate.origin + mailboxOffset;
      final doorApproach = candidate.origin + doorApproachOffset;
      // Default_Mailbox forma parte del CollisionMap de la propia Farmhouse;
      // por eso aparece en [blocked]. Solo debe rechazarse por el terreno o
      // por edificios ajenos, que ya comprueba [_buildingFits].
      if (!surface.isBuildable(mailbox)) {
        continue;
      }
      if (!_canStand(doorApproach, blocked)) {
        continue;
      }
      final navigationBlocked = {...blocked, mailbox};
      final frontCorridor = _frontCorridor(candidate, mailbox);
      if (frontCorridor.any((tile) => !_canStand(tile, navigationBlocked))) {
        continue;
      }

      List<TilePoint>? pathToMailbox;
      TilePoint? mailboxApproach;
      for (final direction in _directions) {
        final approach = mailbox + direction;
        if (!_canStand(approach, navigationBlocked)) continue;
        final path = _shortestPath(doorApproach, {approach}, navigationBlocked);
        if (path != null &&
            (pathToMailbox == null || path.length < pathToMailbox.length)) {
          pathToMailbox = path;
          mailboxApproach = approach;
        }
      }
      if (pathToMailbox == null || mailboxApproach == null) {
        continue;
      }
      final routeDistances = _distanceMap(doorApproach, navigationBlocked);
      final excessiveExitDetour = surface.anchors.any((anchor) {
        final baseline = baselineExitDistances[anchor]![doorApproach];
        if (baseline == null) return false;
        final finalDistance = routeDistances[anchor];
        return finalDistance == null ||
            finalDistance - baseline > _maxExitDetour;
      });
      if (excessiveExitDetour) {
        continue;
      }
      final reachable = routeDistances.keys.toSet();
      final baselineAnchors = surface.anchors.where(baselineReachable.contains);
      final losesExit = baselineAnchors.any(
        (anchor) => !reachable.contains(anchor),
      );
      final allowedLoss = collision.length + cabinBlocked.length + 8;
      if (losesExit ||
          reachable.length < baselineReachable.length - allowedLoss) {
        continue;
      }

      return HostSwapPlacement(
        farmhouse: candidate,
        cabin: cabinDestination,
        mailbox: mailbox,
        mailboxApproach: mailboxApproach,
        doorApproach: doorApproach,
        reservedTiles: {
          ...candidate.footprintTiles(),
          ...cabinDestination.footprintTiles(),
          mailbox,
          doorApproach,
          ...frontCorridor,
          ...pathToMailbox,
        },
      );
    }
    return null;
  }

  bool _buildingFits(BuildingGeometry building, Set<TilePoint> occupied) {
    for (final tile in building.collisionTiles()) {
      // En Riverland la parte trasera del sprite puede sobresalir sobre agua.
      // Lo obligatorio es permanecer dentro del mapa y no invadir edificios;
      // puerta, buzón y conectividad se validan por separado.
      if (!surface.contains(tile) || occupied.contains(tile)) return false;
    }
    // Las X son pared/tejado: pueden sobresalir sobre agua o desniveles
    // porque el jugador nunca camina por ellas. Las O son el porche y las
    // escaleras reales del edificio; deben ser transitables en el mapa base
    // o el granjero puede aparecer dentro y quedar encerrado por una cerca,
    // un acantilado o agua (caso reproducido en Four Corners).
    for (final tile in building.walkableTiles()) {
      if (!surface.isPassable(tile) || occupied.contains(tile)) return false;
    }
    return true;
  }

  bool _canStand(TilePoint tile, Set<TilePoint> blocked) =>
      surface.isPassable(tile) && !blocked.contains(tile);

  Set<TilePoint> _reachableTiles(TilePoint start, Set<TilePoint> blocked) {
    if (!_canStand(start, blocked)) return const {};
    final queue = Queue<TilePoint>()..add(start);
    final visited = <TilePoint>{start};
    while (queue.isNotEmpty) {
      final current = queue.removeFirst();
      for (final direction in _directions) {
        final next = current + direction;
        if (visited.contains(next) || !_canStand(next, blocked)) continue;
        visited.add(next);
        queue.add(next);
      }
    }
    return visited;
  }

  Map<TilePoint, int> _distanceMap(TilePoint start, Set<TilePoint> blocked) {
    if (!_canStand(start, blocked)) return const {};
    final queue = Queue<TilePoint>()..add(start);
    final distances = <TilePoint, int>{start: 0};
    while (queue.isNotEmpty) {
      final current = queue.removeFirst();
      for (final direction in _directions) {
        final next = current + direction;
        if (distances.containsKey(next) || !_canStand(next, blocked)) {
          continue;
        }
        distances[next] = distances[current]! + 1;
        queue.add(next);
      }
    }
    return distances;
  }

  Set<TilePoint> _frontCorridor(BuildingGeometry building, TilePoint mailbox) {
    final left = building.origin.x - 1;
    final right = building.origin.x + building.width;
    final bottom = building.origin.y + building.height;
    final doorY = building.absoluteDoor.y;
    return {
      for (var x = left; x <= right; x++) TilePoint(x, bottom),
      for (var y = doorY; y <= bottom; y++)
        if (TilePoint(left, y) != mailbox) TilePoint(left, y),
      for (var y = doorY; y <= bottom; y++)
        if (TilePoint(right, y) != mailbox) TilePoint(right, y),
    };
  }

  List<TilePoint>? _shortestPath(
    TilePoint start,
    Set<TilePoint> targets,
    Set<TilePoint> blocked,
  ) {
    if (!_canStand(start, blocked)) return null;
    final validTargets = targets
        .where((tile) => _canStand(tile, blocked))
        .toSet();
    if (validTargets.isEmpty) return null;
    final queue = Queue<TilePoint>()..add(start);
    final previous = <TilePoint, TilePoint?>{start: null};
    while (queue.isNotEmpty) {
      final current = queue.removeFirst();
      if (validTargets.contains(current)) {
        final path = <TilePoint>[];
        TilePoint? cursor = current;
        while (cursor != null) {
          path.add(cursor);
          cursor = previous[cursor];
        }
        return path.reversed.toList(growable: false);
      }
      for (final direction in _directions) {
        final next = current + direction;
        if (previous.containsKey(next) || !_canStand(next, blocked)) continue;
        previous[next] = current;
        queue.add(next);
      }
    }
    return null;
  }
}
