import 'package:xml/xml.dart';

import 'farm_placement_service.dart';

enum FarmContentKind {
  keyedItem,
  resourceClump,
  largeTerrainFeature,
  character,
  furniture,
}

class FarmContentMove {
  const FarmContentMove({
    required this.node,
    required this.kind,
    required this.from,
    required this.to,
    required this.width,
    required this.height,
  });

  final XmlElement node;
  final FarmContentKind kind;
  final TilePoint from;
  final TilePoint to;
  final int width;
  final int height;
}

class FarmContentRelocationPlan {
  const FarmContentRelocationPlan({
    required this.moves,
    required this.unsupportedNodes,
  });

  final List<FarmContentMove> moves;
  final List<String> unsupportedNodes;
  bool get isSafe => unsupportedNodes.isEmpty;
}

class FarmContentRelocator {
  const FarmContentRelocator(this.surface);

  final FarmSurface surface;

  FarmContentRelocationPlan plan({
    required XmlElement farm,
    required Set<TilePoint> reserved,
  }) {
    final protected = <TilePoint>{
      ...reserved,
      for (final anchor in surface.anchors)
        for (var dy = -2; dy <= 2; dy++)
          for (var dx = -2; dx <= 2; dx++)
            if (dx.abs() + dy.abs() <= 2) anchor + TilePoint(dx, dy),
    };
    final unsupported = <String>[];
    final entries = <_ContentEntry>[];

    void readKeyed(String containerName) {
      final container = farm.findElements(containerName).firstOrNull;
      if (container == null) return;
      var index = 0;
      for (final item in container.findElements('item')) {
        final vector = item
            .findElements('key')
            .firstOrNull
            ?.findElements('Vector2')
            .firstOrNull;
        final x = vector == null ? null : _int(vector, 'X');
        final y = vector == null ? null : _int(vector, 'Y');
        if (x == null || y == null) {
          unsupported.add('$containerName[$index]');
        } else {
          entries.add(
            _ContentEntry(
              node: item,
              kind: FarmContentKind.keyedItem,
              origin: TilePoint(x, y),
              width: 1,
              height: 1,
              priority: _keyedPriority(item),
            ),
          );
        }
        index++;
      }
    }

    readKeyed('objects');
    readKeyed('terrainFeatures');

    final furniture = farm.findElements('furniture').firstOrNull;
    if (furniture != null) {
      var index = 0;
      for (final item in furniture.children.whereType<XmlElement>()) {
        final tile = item.findElements('tileLocation').firstOrNull;
        final box = item.findElements('boundingBox').firstOrNull;
        final x = tile == null ? null : _int(tile, 'X');
        final y = tile == null ? null : _int(tile, 'Y');
        final pixelWidth = box == null ? null : _int(box, 'Width');
        final pixelHeight = box == null ? null : _int(box, 'Height');
        if (x == null ||
            y == null ||
            pixelWidth == null ||
            pixelHeight == null ||
            pixelWidth <= 0 ||
            pixelHeight <= 0) {
          unsupported.add('furniture[$index]');
        } else {
          entries.add(
            _ContentEntry(
              node: item,
              kind: FarmContentKind.furniture,
              origin: TilePoint(x, y),
              width: (pixelWidth + 63) ~/ 64,
              height: (pixelHeight + 63) ~/ 64,
              priority: 0,
            ),
          );
        }
        index++;
      }
    }

    final clumps = farm.findElements('resourceClumps').firstOrNull;
    if (clumps != null) {
      var index = 0;
      for (final clump in clumps.findElements('ResourceClump')) {
        final tile = clump.findElements('tile').firstOrNull;
        final x = tile == null ? null : _int(tile, 'X');
        final y = tile == null ? null : _int(tile, 'Y');
        final width = _int(clump, 'width');
        final height = _int(clump, 'height');
        if (x == null || y == null || width == null || height == null) {
          unsupported.add('resourceClumps[$index]');
        } else {
          entries.add(
            _ContentEntry(
              node: clump,
              kind: FarmContentKind.resourceClump,
              origin: TilePoint(x, y),
              width: width,
              height: height,
              priority: 0,
            ),
          );
        }
        index++;
      }
    }

    final large = farm.findElements('largeTerrainFeatures').firstOrNull;
    if (large != null) {
      var index = 0;
      for (final feature in large.children.whereType<XmlElement>()) {
        final tile = feature.findElements('tilePosition').firstOrNull;
        final x = tile == null ? null : _int(tile, 'X');
        final y = tile == null ? null : _int(tile, 'Y');
        final dimensions = _largeFeatureDimensions(feature);
        if (x == null || y == null || dimensions == null) {
          unsupported.add('largeTerrainFeatures[$index]');
        } else {
          entries.add(
            _ContentEntry(
              node: feature,
              kind: FarmContentKind.largeTerrainFeature,
              origin: TilePoint(x, y),
              width: dimensions.$1,
              height: dimensions.$2,
              priority: 1,
            ),
          );
        }
        index++;
      }
    }

    final characters = farm.findElements('characters').firstOrNull;
    if (characters != null) {
      var index = 0;
      for (final character in characters.children.whereType<XmlElement>()) {
        final position = character.findElements('Position').firstOrNull;
        final px = position == null ? null : _int(position, 'X');
        final py = position == null ? null : _int(position, 'Y');
        if (px == null || py == null) {
          unsupported.add('characters[$index]');
        } else {
          entries.add(
            _ContentEntry(
              node: character,
              kind: FarmContentKind.character,
              origin: TilePoint(px ~/ 64, py ~/ 64),
              width: 1,
              height: 1,
              priority: 0,
            ),
          );
        }
        index++;
      }
    }

    final animals = farm.findElements('animals').firstOrNull;
    if (animals != null &&
        animals.descendants.whereType<XmlElement>().any(
          (element) => element.name.local == 'item',
        )) {
      unsupported.add('animals');
    }

    if (unsupported.isNotEmpty) {
      return FarmContentRelocationPlan(
        moves: const [],
        unsupportedNodes: List.unmodifiable(unsupported),
      );
    }

    entries.sort((a, b) {
      final priority = a.priority.compareTo(b.priority);
      if (priority != 0) return priority;
      final vertical = a.origin.y.compareTo(b.origin.y);
      if (vertical != 0) return vertical;
      return a.origin.x.compareTo(b.origin.x);
    });

    final occupancy = <TilePoint, int>{};
    void occupy(_ContentEntry entry, TilePoint origin) {
      for (final tile in entry.tilesAt(origin)) {
        occupancy[tile] = (occupancy[tile] ?? 0) + 1;
      }
    }

    bool staticFit(_ContentEntry entry, TilePoint origin) => entry
        .tilesAt(origin)
        .every(
          (tile) =>
              surface.isBuildable(tile) &&
              !surface.isWater(tile) &&
              !protected.contains(tile),
        );

    final toMove = <_ContentEntry>[];
    for (final entry in entries) {
      if (staticFit(entry, entry.origin)) {
        occupy(entry, entry.origin);
      } else {
        toMove.add(entry);
      }
    }

    bool freeFit(_ContentEntry entry, TilePoint origin) =>
        staticFit(entry, origin) &&
        entry.tilesAt(origin).every((tile) => (occupancy[tile] ?? 0) == 0);

    final moves = <FarmContentMove>[];
    for (final entry in toMove) {
      final destination = _findNearest(entry, freeFit);
      if (destination == null) {
        unsupported.add(
          'noFreeTile:${entry.kind.name}@${entry.origin.x},${entry.origin.y}',
        );
        continue;
      }
      occupy(entry, destination);
      moves.add(
        FarmContentMove(
          node: entry.node,
          kind: entry.kind,
          from: entry.origin,
          to: destination,
          width: entry.width,
          height: entry.height,
        ),
      );
    }
    return FarmContentRelocationPlan(
      moves: List.unmodifiable(moves),
      unsupportedNodes: List.unmodifiable(unsupported),
    );
  }

  void apply(FarmContentRelocationPlan plan) {
    if (!plan.isSafe) {
      throw StateError('Unsafe farm content relocation plan');
    }
    for (final move in plan.moves) {
      switch (move.kind) {
        case FarmContentKind.keyedItem:
          _moveKeyedItem(move.node, move.to);
        case FarmContentKind.resourceClump:
          _setVector(move.node.findElements('tile').first, move.to);
        case FarmContentKind.largeTerrainFeature:
          _setVector(move.node.findElements('tilePosition').first, move.to);
        case FarmContentKind.character:
          final pixels = TilePoint(move.to.x * 64, move.to.y * 64);
          _setVector(move.node.findElements('Position').first, pixels);
          final defaultPosition = move.node
              .findElements('DefaultPosition')
              .firstOrNull;
          if (defaultPosition != null) {
            _setVector(defaultPosition, pixels);
          }
        case FarmContentKind.furniture:
          _moveFurniture(move);
      }
    }
  }

  TilePoint? _findNearest(
    _ContentEntry entry,
    bool Function(_ContentEntry entry, TilePoint origin) fits,
  ) {
    final candidates = <TilePoint>[];
    for (var y = 0; y <= surface.height - entry.height; y++) {
      for (var x = 0; x <= surface.width - entry.width; x++) {
        candidates.add(TilePoint(x, y));
      }
    }
    candidates.sort((a, b) {
      final distance = a
          .manhattanTo(entry.origin)
          .compareTo(b.manhattanTo(entry.origin));
      if (distance != 0) return distance;
      final vertical = a.y.compareTo(b.y);
      return vertical != 0 ? vertical : a.x.compareTo(b.x);
    });
    return candidates.where((origin) => fits(entry, origin)).firstOrNull;
  }

  static int _keyedPriority(XmlElement item) {
    final value = item
        .findElements('value')
        .firstOrNull
        ?.children
        .whereType<XmlElement>()
        .firstOrNull;
    if (value == null) return 3;
    final type = value.attributes
        .where((attribute) => attribute.name.qualified == 'xsi:type')
        .firstOrNull
        ?.value;
    if (type == 'Chest' || value.findElements('crop').isNotEmpty) return 0;
    final name = value.findElements('name').firstOrNull?.innerText;
    if (name == 'Weeds' || type == 'Grass') return 3;
    return 2;
  }

  static (int, int)? _largeFeatureDimensions(XmlElement feature) {
    final type = feature.attributes
        .where((attribute) => attribute.name.qualified == 'xsi:type')
        .firstOrNull
        ?.value;
    if (type != 'Bush') return const (1, 1);
    return switch (_int(feature, 'size')) {
      0 => const (1, 1),
      1 => const (2, 1),
      2 => const (3, 2),
      _ => null,
    };
  }

  static void _moveKeyedItem(XmlElement item, TilePoint destination) {
    final vector = item.findElements('key').first.findElements('Vector2').first;
    _setVector(vector, destination);
    final value = item
        .findElements('value')
        .firstOrNull
        ?.children
        .whereType<XmlElement>()
        .firstOrNull;
    if (value == null) return;
    for (final name in ['tileLocation', 'Tile']) {
      final tile = value.findElements(name).firstOrNull;
      if (tile != null) _setVector(tile, destination);
    }
    final box = value.findElements('boundingBox').firstOrNull;
    if (box != null) {
      final pixels = TilePoint(destination.x * 64, destination.y * 64);
      _setVector(box, pixels);
      final location = box.findElements('Location').firstOrNull;
      if (location != null) _setVector(location, pixels);
    }
  }

  static void _moveFurniture(FarmContentMove move) {
    final tile = move.node.findElements('tileLocation').first;
    _setVector(tile, move.to);
    final oldPixels = TilePoint(move.from.x * 64, move.from.y * 64);
    final newPixels = TilePoint(move.to.x * 64, move.to.y * 64);
    for (final name in ['boundingBox', 'defaultBoundingBox']) {
      final box = move.node.findElements(name).firstOrNull;
      if (box == null) continue;
      final oldX = _int(box, 'X');
      final oldY = _int(box, 'Y');
      if (oldX == null || oldY == null) {
        throw StateError('Invalid furniture $name');
      }
      final position = TilePoint(
        newPixels.x + oldX - oldPixels.x,
        newPixels.y + oldY - oldPixels.y,
      );
      _setText(box, 'X', position.x.toString());
      _setText(box, 'Y', position.y.toString());
      final location = box.findElements('Location').firstOrNull;
      if (location != null) _setVector(location, position);
    }
  }

  static void _setVector(XmlElement vector, TilePoint value) {
    _setText(vector, 'X', value.x.toString());
    _setText(vector, 'Y', value.y.toString());
  }

  static void _setText(XmlElement parent, String name, String value) {
    final element = parent.findElements(name).firstOrNull;
    if (element == null) throw StateError('Missing $name');
    element.children
      ..clear()
      ..add(XmlText(value));
  }

  static int? _int(XmlElement parent, String name) =>
      int.tryParse(parent.findElements(name).firstOrNull?.innerText ?? '');
}

class _ContentEntry {
  const _ContentEntry({
    required this.node,
    required this.kind,
    required this.origin,
    required this.width,
    required this.height,
    required this.priority,
  });

  final XmlElement node;
  final FarmContentKind kind;
  final TilePoint origin;
  final int width;
  final int height;
  final int priority;

  Iterable<TilePoint> tilesAt(TilePoint value) sync* {
    for (var y = 0; y < height; y++) {
      for (var x = 0; x < width; x++) {
        yield value + TilePoint(x, y);
      }
    }
  }
}
