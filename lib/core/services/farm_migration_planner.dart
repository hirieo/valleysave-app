import 'dart:collection';

import 'farm_placement_service.dart';

enum FarmMoveReason { invalidTerrain, protectedExit, overlap, unreachableDoor }

class MigrationBuilding {
  const MigrationBuilding({
    required this.id,
    required this.type,
    required this.origin,
    required this.width,
    required this.height,
    this.doorOffset,
    this.mailboxOffset,
  });

  final String id;
  final String type;
  final TilePoint origin;
  final int width;
  final int height;
  final TilePoint? doorOffset;
  final TilePoint? mailboxOffset;

  Set<TilePoint> get everyTile => {
    for (var y = 0; y < height; y++)
      for (var x = 0; x < width; x++) origin + TilePoint(x, y),
  };

  TilePoint? get doorApproach =>
      doorOffset == null ? null : origin + TilePoint(doorOffset!.x, height);

  TilePoint? get mailbox =>
      mailboxOffset == null ? null : origin + mailboxOffset!;

  MigrationBuilding at(TilePoint value) => MigrationBuilding(
    id: id,
    type: type,
    origin: value,
    width: width,
    height: height,
    doorOffset: doorOffset,
    mailboxOffset: mailboxOffset,
  );
}

class PlannedBuildingMove {
  const PlannedBuildingMove({
    required this.building,
    required this.from,
    required this.to,
    required this.reason,
  });

  final MigrationBuilding building;
  final TilePoint from;
  final TilePoint to;
  final FarmMoveReason reason;
}

class FarmMigrationPlan {
  const FarmMigrationPlan({required this.placements, required this.moves});

  final Map<String, TilePoint> placements;
  final List<PlannedBuildingMove> moves;
}

/// Plans a deterministic, conservative placement for every persisted farm
/// building on a different vanilla map. It never mutates XML.
class FarmMigrationPlanner {
  FarmMigrationPlanner(this.surface)
    : _protectedTiles = _buildProtectedTiles(surface);

  final FarmSurface surface;
  final Set<TilePoint> _protectedTiles;

  FarmMigrationPlan? plan(List<MigrationBuilding> buildings) {
    if (buildings.isEmpty ||
        buildings.any(
          (building) =>
              building.id.isEmpty ||
              building.width <= 0 ||
              building.height <= 0,
        ) ||
        buildings.map((building) => building.id).toSet().length !=
            buildings.length) {
      return null;
    }

    final ordered = [...buildings]..sort(_compareBuildingPriority);
    final placements = <String, TilePoint>{};
    final occupied = <TilePoint>{};
    TilePoint? farmhouseApproach;
    final placedDoorApproaches = <TilePoint>[];
    var requiredAnchors = <TilePoint>[];

    for (final building in ordered) {
      MigrationBuilding? selected;
      for (final origin in _candidateOrigins(building)) {
        final candidate = building.at(origin);
        if (!_fits(candidate, occupied)) continue;
        final candidateBlocked = {...occupied, ...candidate.everyTile};
        if (candidate.mailbox != null) {
          candidateBlocked.add(candidate.mailbox!);
        }
        final candidateRoot = candidate.type == 'Farmhouse'
            ? candidate.doorApproach
            : farmhouseApproach;
        if (candidateRoot != null) {
          final candidateAnchors = candidate.type == 'Farmhouse'
              ? _anchorsReachableFrom(candidateRoot)
              : requiredAnchors;
          final reachable = _reachable(candidateRoot, candidateBlocked);
          final required = <TilePoint>[
            ...placedDoorApproaches,
            if (candidate.doorApproach != null) candidate.doorApproach!,
            ...candidateAnchors,
          ];
          if (!required.every(reachable.contains)) continue;
        }
        selected = candidate;
        break;
      }
      if (selected == null) return null;
      placements[building.id] = selected.origin;
      occupied.addAll(selected.everyTile);
      if (selected.mailbox != null) occupied.add(selected.mailbox!);
      if (selected.type == 'Farmhouse') {
        farmhouseApproach = selected.doorApproach;
        if (farmhouseApproach != null) {
          requiredAnchors = _anchorsReachableFrom(farmhouseApproach);
        }
      }
      if (selected.doorApproach != null) {
        placedDoorApproaches.add(selected.doorApproach!);
      }
    }

    if (!_connected(buildings, placements)) return null;

    final moves = <PlannedBuildingMove>[
      for (final building in buildings)
        if (placements[building.id] != building.origin)
          PlannedBuildingMove(
            building: building,
            from: building.origin,
            to: placements[building.id]!,
            reason: _reasonAtOriginal(building, buildings),
          ),
    ];
    return FarmMigrationPlan(
      placements: Map.unmodifiable(placements),
      moves: List.unmodifiable(moves),
    );
  }

  bool validate(
    List<MigrationBuilding> buildings,
    Map<String, TilePoint> placements,
  ) {
    if (placements.length != buildings.length ||
        !placements.keys.toSet().containsAll(
          buildings.map((building) => building.id),
        )) {
      return false;
    }
    final occupied = <TilePoint>{};
    final ordered = [...buildings]..sort(_compareBuildingPriority);
    for (final building in ordered) {
      final origin = placements[building.id];
      if (origin == null) return false;
      final candidate = building.at(origin);
      if (!_fits(candidate, occupied)) return false;
      occupied.addAll(candidate.everyTile);
      if (candidate.mailbox != null) occupied.add(candidate.mailbox!);
    }
    return _connected(buildings, placements);
  }

  /// Returns deterministic walkable corridors from the farmhouse to every
  /// building entrance, mailbox and target-map exit that is reachable on the
  /// untouched map. Dynamic farm content must stay outside this set.
  Set<TilePoint>? navigationCorridors(
    List<MigrationBuilding> buildings,
    Map<String, TilePoint> placements,
  ) {
    if (!validate(buildings, placements)) return null;
    final placed = [
      for (final building in buildings) building.at(placements[building.id]!),
    ];
    final blocked = <TilePoint>{
      for (final building in placed) ...building.everyTile,
      for (final building in placed)
        if (building.mailbox != null) building.mailbox!,
    };
    final farmhouse = placed
        .where((building) => building.type == 'Farmhouse')
        .firstOrNull;
    final start = farmhouse?.doorApproach;
    if (start == null || !_canWalk(start, blocked)) return null;

    final targets = <TilePoint>{};
    for (final building in placed) {
      final approach = building.doorApproach;
      if (approach != null) targets.add(approach);
      final mailbox = building.mailbox;
      if (mailbox != null) {
        final mailboxApproach = _nearestWalkable(
          mailbox,
          blocked,
          maxDistance: 2,
        );
        if (mailboxApproach == null) return null;
        targets.add(mailboxApproach);
      }
    }

    final baselineReachable = _reachable(start, const {});
    for (final anchor in surface.anchors) {
      final baseline = _nearestWalkable(anchor, const {}, maxDistance: 3);
      if (baseline == null || !baselineReachable.contains(baseline)) continue;
      final target = _nearestWalkable(anchor, blocked, maxDistance: 3);
      if (target == null) return null;
      targets.add(target);
    }

    final corridors = <TilePoint>{start};
    for (final target in targets) {
      final path = _shortestPath(start, target, blocked);
      if (path == null) return null;
      corridors.addAll(path);
    }
    return Set.unmodifiable(corridors);
  }

  Iterable<TilePoint> _candidateOrigins(MigrationBuilding building) sync* {
    if (_originInBounds(building, building.origin)) yield building.origin;
    final candidates = <TilePoint>[];
    for (var y = 0; y <= surface.height - building.height; y++) {
      for (var x = 0; x <= surface.width - building.width; x++) {
        final point = TilePoint(x, y);
        if (point != building.origin) candidates.add(point);
      }
    }
    candidates.sort((a, b) {
      final distance = a
          .manhattanTo(building.origin)
          .compareTo(b.manhattanTo(building.origin));
      if (distance != 0) return distance;
      final vertical = a.y.compareTo(b.y);
      if (vertical != 0) return vertical;
      return a.x.compareTo(b.x);
    });
    yield* candidates;
  }

  bool _originInBounds(MigrationBuilding building, TilePoint origin) =>
      origin.x >= 0 &&
      origin.y >= 0 &&
      origin.x + building.width <= surface.width &&
      origin.y + building.height <= surface.height;

  bool _fits(MigrationBuilding building, Set<TilePoint> occupied) {
    if (!_originInBounds(building, building.origin)) return false;
    final tiles = building.everyTile;
    if (tiles.any(
      (tile) =>
          !surface.isBuildable(tile) ||
          _protectedTiles.contains(tile) ||
          occupied.contains(tile),
    )) {
      return false;
    }

    final approach = building.doorApproach;
    if (approach != null &&
        (!surface.isPassable(approach) ||
            tiles.contains(approach) ||
            occupied.contains(approach) ||
            _protectedTiles.contains(approach))) {
      return false;
    }

    final mailbox = building.mailbox;
    if (mailbox != null) {
      if (!surface.isBuildable(mailbox) ||
          occupied.contains(mailbox) ||
          _protectedTiles.contains(mailbox)) {
        return false;
      }
      final blocked = {...occupied, ...tiles, mailbox};
      if (_cardinalNeighbors(
        mailbox,
      ).every((tile) => !surface.isPassable(tile) || blocked.contains(tile))) {
        return false;
      }
    }
    return true;
  }

  bool _connected(
    List<MigrationBuilding> buildings,
    Map<String, TilePoint> placements,
  ) {
    final placed = [
      for (final building in buildings) building.at(placements[building.id]!),
    ];
    final blocked = <TilePoint>{
      for (final building in placed) ...building.everyTile,
      for (final building in placed)
        if (building.mailbox != null) building.mailbox!,
    };
    final doorTargets = <TilePoint>[];
    for (final building in placed) {
      final approach = building.doorApproach;
      if (approach != null) doorTargets.add(approach);
      final mailbox = building.mailbox;
      if (mailbox != null) {
        final approach = _nearestWalkable(mailbox, blocked, maxDistance: 2);
        if (approach == null) return false;
        doorTargets.add(approach);
      }
    }
    if (doorTargets.isEmpty) return false;
    final farmhouse = placed
        .where((building) => building.type == 'Farmhouse')
        .firstOrNull;
    final start = farmhouse?.doorApproach ?? doorTargets.first;
    if (!_canWalk(start, blocked)) return false;

    // Some vanilla maps contain warp anchors in distinct static components.
    // A conversion must preserve every exit reachable from the farmhouse on
    // the untouched target map, but it must not reject the map merely because
    // two vanilla components are intentionally disconnected.
    final baselineReachable = _reachable(start, const {});
    final anchorTargets = <TilePoint>[];
    for (final anchor in surface.anchors) {
      final baseline = _nearestWalkable(anchor, const {}, maxDistance: 3);
      if (baseline == null || !baselineReachable.contains(baseline)) continue;
      final finalTile = _nearestWalkable(anchor, blocked, maxDistance: 3);
      if (finalTile == null) return false;
      anchorTargets.add(finalTile);
    }
    final reachable = _reachable(start, blocked);
    return [...doorTargets, ...anchorTargets].every(reachable.contains);
  }

  List<TilePoint> _anchorsReachableFrom(TilePoint start) {
    if (!_canWalk(start, const {})) return const [];
    final reachable = _reachable(start, const {});
    final result = <TilePoint>[];
    for (final anchor in surface.anchors) {
      final walkable = _nearestWalkable(anchor, const {}, maxDistance: 3);
      if (walkable != null && reachable.contains(walkable)) {
        result.add(walkable);
      }
    }
    return result;
  }

  Set<TilePoint> _reachable(TilePoint start, Set<TilePoint> blocked) {
    final queue = Queue<TilePoint>()..add(start);
    final seen = <TilePoint>{start};
    while (queue.isNotEmpty) {
      final current = queue.removeFirst();
      for (final next in _cardinalNeighbors(current)) {
        if (seen.contains(next) || !_canWalk(next, blocked)) continue;
        seen.add(next);
        queue.add(next);
      }
    }
    return seen;
  }

  List<TilePoint>? _shortestPath(
    TilePoint start,
    TilePoint target,
    Set<TilePoint> blocked,
  ) {
    if (!_canWalk(start, blocked) || !_canWalk(target, blocked)) return null;
    final queue = Queue<TilePoint>()..add(start);
    final previous = <TilePoint, TilePoint?>{start: null};
    while (queue.isNotEmpty) {
      final current = queue.removeFirst();
      if (current == target) {
        final path = <TilePoint>[];
        TilePoint? cursor = current;
        while (cursor != null) {
          path.add(cursor);
          cursor = previous[cursor];
        }
        return path.reversed.toList(growable: false);
      }
      for (final next in _cardinalNeighbors(current)) {
        if (previous.containsKey(next) || !_canWalk(next, blocked)) continue;
        previous[next] = current;
        queue.add(next);
      }
    }
    return null;
  }

  TilePoint? _nearestWalkable(
    TilePoint origin,
    Set<TilePoint> blocked, {
    required int maxDistance,
  }) {
    final candidates = <TilePoint>[];
    for (var dy = -maxDistance; dy <= maxDistance; dy++) {
      for (var dx = -maxDistance; dx <= maxDistance; dx++) {
        if (dx.abs() + dy.abs() > maxDistance) continue;
        candidates.add(origin + TilePoint(dx, dy));
      }
    }
    candidates.sort((a, b) {
      final distance = a.manhattanTo(origin).compareTo(b.manhattanTo(origin));
      if (distance != 0) return distance;
      final vertical = a.y.compareTo(b.y);
      return vertical != 0 ? vertical : a.x.compareTo(b.x);
    });
    return candidates.where((tile) => _canWalk(tile, blocked)).firstOrNull;
  }

  bool _canWalk(TilePoint tile, Set<TilePoint> blocked) =>
      surface.isPassable(tile) && !blocked.contains(tile);

  FarmMoveReason _reasonAtOriginal(
    MigrationBuilding building,
    List<MigrationBuilding> all,
  ) {
    if (!_originInBounds(building, building.origin) ||
        building.everyTile.any((tile) => !surface.isBuildable(tile))) {
      return FarmMoveReason.invalidTerrain;
    }
    if (building.everyTile.any(_protectedTiles.contains)) {
      return FarmMoveReason.protectedExit;
    }
    for (final other in all) {
      if (other.id == building.id) continue;
      if (building.everyTile.any(other.everyTile.contains)) {
        return FarmMoveReason.overlap;
      }
    }
    return FarmMoveReason.unreachableDoor;
  }

  static int _compareBuildingPriority(
    MigrationBuilding a,
    MigrationBuilding b,
  ) {
    int priority(MigrationBuilding building) => switch (building.type) {
      'Farmhouse' => 0,
      'Greenhouse' => 1,
      'Shipping Bin' => 2,
      'Cabin' => 3,
      _ when building.doorOffset != null => 4,
      _ => 5,
    };
    final byKind = priority(a).compareTo(priority(b));
    if (byKind != 0) return byKind;
    final byArea = (b.width * b.height).compareTo(a.width * a.height);
    if (byArea != 0) return byArea;
    return a.id.compareTo(b.id);
  }

  static Set<TilePoint> _buildProtectedTiles(FarmSurface surface) => {
    for (final anchor in surface.anchors)
      for (var dy = -2; dy <= 2; dy++)
        for (var dx = -2; dx <= 2; dx++)
          if (dx.abs() + dy.abs() <= 2 &&
              surface.contains(anchor + TilePoint(dx, dy)))
            anchor + TilePoint(dx, dy),
  };

  static Iterable<TilePoint> _cardinalNeighbors(TilePoint tile) sync* {
    yield tile + const TilePoint(0, 1);
    yield tile + const TilePoint(1, 0);
    yield tile + const TilePoint(-1, 0);
    yield tile + const TilePoint(0, -1);
  }
}
