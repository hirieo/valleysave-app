import 'dart:io';

import 'package:xml/xml.dart';

import 'farm_content_relocation.dart';
import 'farm_migration_planner.dart';
import 'farm_placement_service.dart';
import 'save_replace_service.dart';

enum FarmTypeChangeError {
  invalidSave,
  unsupportedSource,
  unsupportedTarget,
  sameFarm,
  noSafePlacement,
  unsupportedFarmContent,
  writeFailure,
  postValidationFailed,
}

class FarmTypeChangeAnalysis {
  const FarmTypeChangeAnalysis({
    required this.ok,
    this.error,
    this.sourceWhichFarm,
    this.targetWhichFarm,
    this.buildingMoves = const [],
    this.contentMoves = 0,
    this.contentMoveCounts = const {},
  });

  final bool ok;
  final FarmTypeChangeError? error;
  final int? sourceWhichFarm;
  final int? targetWhichFarm;
  final List<PlannedBuildingMove> buildingMoves;
  final int contentMoves;
  final Map<FarmContentKind, int> contentMoveCounts;

  Map<String, Object?> toJson() => {
    'ok': ok,
    'error': error?.name,
    'sourceWhichFarm': sourceWhichFarm,
    'targetWhichFarm': targetWhichFarm,
    'buildingMoves': [
      for (final move in buildingMoves)
        {
          'id': move.building.id,
          'type': move.building.type,
          'from': {'x': move.from.x, 'y': move.from.y},
          'to': {'x': move.to.x, 'y': move.to.y},
          'reason': move.reason.name,
        },
    ],
    'contentMoves': contentMoves,
    'contentMoveCounts': {
      for (final entry in contentMoveCounts.entries)
        entry.key.name: entry.value,
    },
  };
}

class FarmTypeChangeResult {
  const FarmTypeChangeResult({
    required this.ok,
    this.error,
    this.backupPath,
    this.buildingsMoved = 0,
    this.contentMoved = 0,
    this.contentMoveCounts = const {},
  });

  final bool ok;
  final FarmTypeChangeError? error;
  final String? backupPath;
  final int buildingsMoved;
  final int contentMoved;
  final Map<FarmContentKind, int> contentMoveCounts;

  Map<String, Object?> toJson() => {
    'ok': ok,
    'error': error?.name,
    'backupPath': backupPath,
    'buildingsMoved': buildingsMoved,
    'contentMoved': contentMoved,
    'contentMoveCounts': {
      for (final entry in contentMoveCounts.entries)
        entry.key.name: entry.value,
    },
  };
}

/// Converts only vanilla farm types (0..7). The live save is replaced solely
/// through [SaveReplaceService], after a complete dry-run on the target map.
class FarmTypeChangeService {
  const FarmTypeChangeService();

  Future<FarmTypeChangeAnalysis> analyze({
    required String saveFolderPath,
    required int targetWhichFarm,
  }) async {
    try {
      final folder = Directory(saveFolderPath);
      final folderName = _basename(folder.path);
      final main = File('${folder.path}${Platform.pathSeparator}$folderName');
      if (!await main.exists()) {
        return const FarmTypeChangeAnalysis(
          ok: false,
          error: FarmTypeChangeError.invalidSave,
        );
      }
      final document = XmlDocument.parse(await main.readAsString());
      final sourceValue = _text(document.rootElement, 'whichFarm');
      final source = VanillaFarmSurfaceRepository.whichFarmFromSaveValue(
        sourceValue,
      );
      if (source == null) {
        return const FarmTypeChangeAnalysis(
          ok: false,
          error: FarmTypeChangeError.invalidSave,
        );
      }
      if (VanillaFarmSurfaceRepository.forWhichFarm(source) == null) {
        return FarmTypeChangeAnalysis(
          ok: false,
          error: FarmTypeChangeError.unsupportedSource,
          sourceWhichFarm: source,
          targetWhichFarm: targetWhichFarm,
        );
      }
      if (VanillaFarmSurfaceRepository.forWhichFarm(targetWhichFarm) == null) {
        return FarmTypeChangeAnalysis(
          ok: false,
          error: FarmTypeChangeError.unsupportedTarget,
          sourceWhichFarm: source,
          targetWhichFarm: targetWhichFarm,
        );
      }
      final expectedTargetValue =
          VanillaFarmSurfaceRepository.saveValueForWhichFarm(targetWhichFarm);
      if (source == targetWhichFarm && sourceValue == expectedTargetValue) {
        return FarmTypeChangeAnalysis(
          ok: false,
          error: FarmTypeChangeError.sameFarm,
          sourceWhichFarm: source,
          targetWhichFarm: targetWhichFarm,
        );
      }
      final bundle = _buildPlan(document, targetWhichFarm);
      if (bundle.error != null) {
        return FarmTypeChangeAnalysis(
          ok: false,
          error: bundle.error,
          sourceWhichFarm: source,
          targetWhichFarm: targetWhichFarm,
        );
      }
      return FarmTypeChangeAnalysis(
        ok: true,
        sourceWhichFarm: source,
        targetWhichFarm: targetWhichFarm,
        buildingMoves: bundle.buildingPlan!.moves,
        contentMoves: bundle.contentPlan!.moves.length,
        contentMoveCounts: _countContentMoves(bundle.contentPlan!.moves),
      );
    } catch (_) {
      return const FarmTypeChangeAnalysis(
        ok: false,
        error: FarmTypeChangeError.invalidSave,
      );
    }
  }

  Future<FarmTypeChangeResult> execute({
    required String saveFolderPath,
    required int targetWhichFarm,
    required String backupsDir,
  }) async {
    final analysis = await analyze(
      saveFolderPath: saveFolderPath,
      targetWhichFarm: targetWhichFarm,
    );
    if (!analysis.ok) {
      return FarmTypeChangeResult(ok: false, error: analysis.error);
    }

    final source = Directory(saveFolderPath);
    final folderName = _basename(source.path);
    final main = File('${source.path}${Platform.pathSeparator}$folderName');
    try {
      final originalDocument = XmlDocument.parse(await main.readAsString());
      final snapshot = _FarmSnapshot.fromDocument(originalDocument);
      final replace = await SaveReplaceService.instance.replaceSaveFolder(
        savesDir: source.parent.path,
        folderName: folderName,
        backupsDir: backupsDir,
        prepare: (staging) async {
          await _copyDirectory(source, staging);
          await for (final entity in staging.list(recursive: false)) {
            if (entity is File && entity.path.endsWith('_old')) {
              await entity.delete();
            }
          }
          final stagedMain = File(
            '${staging.path}${Platform.pathSeparator}$folderName',
          );
          final document = XmlDocument.parse(await stagedMain.readAsString());
          final bundle = _buildPlan(document, targetWhichFarm);
          if (bundle.error != null) throw StateError(bundle.error!.name);
          _applyPlan(document, bundle, targetWhichFarm);
          await stagedMain.writeAsString(document.toXmlString(pretty: false));
        },
        validate: (directory) => _validatePublished(
          directory,
          folderName: folderName,
          targetWhichFarm: targetWhichFarm,
          snapshot: snapshot,
        ),
      );
      if (!replace.ok) {
        return FarmTypeChangeResult(
          ok: false,
          error: switch (replace.error) {
            ReplaceError.postValidationFailed =>
              FarmTypeChangeError.postValidationFailed,
            _ => FarmTypeChangeError.writeFailure,
          },
        );
      }
      return FarmTypeChangeResult(
        ok: true,
        backupPath: replace.autoBackup?.localPath,
        buildingsMoved: analysis.buildingMoves.length,
        contentMoved: analysis.contentMoves,
        contentMoveCounts: analysis.contentMoveCounts,
      );
    } catch (_) {
      return const FarmTypeChangeResult(
        ok: false,
        error: FarmTypeChangeError.writeFailure,
      );
    }
  }

  static _PlanBundle _buildPlan(XmlDocument document, int targetWhichFarm) {
    final surface = VanillaFarmSurfaceRepository.forWhichFarm(targetWhichFarm);
    final farm = _farm(document);
    if (surface == null || farm == null) {
      return const _PlanBundle(error: FarmTypeChangeError.invalidSave);
    }
    final records = _buildingRecords(farm);
    if (records == null || records.isEmpty) {
      return const _PlanBundle(error: FarmTypeChangeError.invalidSave);
    }
    final buildings = records.map((record) => record.model).toList();
    final migrationPlanner = FarmMigrationPlanner(surface);
    final buildingPlan = migrationPlanner.plan(buildings);
    if (buildingPlan == null) {
      return const _PlanBundle(error: FarmTypeChangeError.noSafePlacement);
    }
    final reserved = <TilePoint>{};
    for (final building in buildings) {
      final placed = building.at(buildingPlan.placements[building.id]!);
      reserved.addAll(placed.everyTile);
      if (placed.mailbox != null) reserved.add(placed.mailbox!);
      if (placed.doorApproach != null) reserved.add(placed.doorApproach!);
    }
    final navigation = migrationPlanner.navigationCorridors(
      buildings,
      buildingPlan.placements,
    );
    if (navigation == null) {
      return const _PlanBundle(error: FarmTypeChangeError.noSafePlacement);
    }
    reserved.addAll(navigation);
    final relocator = FarmContentRelocator(surface);
    final contentPlan = relocator.plan(farm: farm, reserved: reserved);
    if (!contentPlan.isSafe) {
      return const _PlanBundle(
        error: FarmTypeChangeError.unsupportedFarmContent,
      );
    }
    return _PlanBundle(
      farm: farm,
      records: records,
      buildingPlan: buildingPlan,
      contentPlan: contentPlan,
      relocator: relocator,
    );
  }

  static Map<FarmContentKind, int> _countContentMoves(
    Iterable<FarmContentMove> moves,
  ) {
    final result = <FarmContentKind, int>{};
    for (final move in moves) {
      result[move.kind] = (result[move.kind] ?? 0) + 1;
    }
    return Map.unmodifiable(result);
  }

  static void _applyPlan(
    XmlDocument document,
    _PlanBundle bundle,
    int targetWhichFarm,
  ) {
    _setText(
      document.rootElement,
      'whichFarm',
      VanillaFarmSurfaceRepository.saveValueForWhichFarm(targetWhichFarm),
    );
    for (final record in bundle.records!) {
      final origin = bundle.buildingPlan!.placements[record.model.id]!;
      _setText(record.node, 'tileX', origin.x.toString());
      _setText(record.node, 'tileY', origin.y.toString());
    }
    bundle.relocator!.apply(bundle.contentPlan!);
  }

  static Future<bool> _validatePublished(
    Directory directory, {
    required String folderName,
    required int targetWhichFarm,
    required _FarmSnapshot snapshot,
  }) async {
    try {
      final main = File(
        '${directory.path}${Platform.pathSeparator}$folderName',
      );
      final document = XmlDocument.parse(await main.readAsString());
      final actualWhichFarm = document.rootElement
          .findElements('whichFarm')
          .firstOrNull
          ?.innerText;
      if (actualWhichFarm !=
          VanillaFarmSurfaceRepository.saveValueForWhichFarm(targetWhichFarm)) {
        return false;
      }
      final current = _FarmSnapshot.fromDocument(document);
      if (!snapshot.sameIdentityAndCounts(current)) return false;
      final bundle = _buildPlan(document, targetWhichFarm);
      if (bundle.error != null ||
          bundle.buildingPlan!.moves.isNotEmpty ||
          bundle.contentPlan!.moves.isNotEmpty) {
        return false;
      }
      return FarmMigrationPlanner(
        VanillaFarmSurfaceRepository.forWhichFarm(targetWhichFarm)!,
      ).validate(
        bundle.records!.map((record) => record.model).toList(),
        bundle.buildingPlan!.placements,
      );
    } catch (_) {
      return false;
    }
  }

  static XmlElement? _farm(XmlDocument document) {
    final locations = document.rootElement
        .findElements('locations')
        .firstOrNull;
    if (locations == null) return null;
    for (final location in locations.findElements('GameLocation')) {
      if (location.findElements('name').firstOrNull?.innerText == 'Farm') {
        return location;
      }
    }
    return null;
  }

  static List<_BuildingRecord>? _buildingRecords(XmlElement farm) {
    final container = farm.findElements('buildings').firstOrNull;
    if (container == null) return null;
    final result = <_BuildingRecord>[];
    var index = 0;
    for (final node in container.findElements('Building')) {
      final type = node.findElements('buildingType').firstOrNull?.innerText;
      final x = _int(node, 'tileX');
      final y = _int(node, 'tileY');
      final width = _int(node, 'tilesWide');
      final height = _int(node, 'tilesHigh');
      if (type == null ||
          type.isEmpty ||
          x == null ||
          y == null ||
          width == null ||
          height == null) {
        return null;
      }
      final guid = node
          .findElements('buildingId')
          .firstOrNull
          ?.findElements('Guid')
          .firstOrNull
          ?.innerText;
      final door = node.findElements('humanDoor').firstOrNull;
      final doorX = door == null ? null : _int(door, 'X');
      final doorY = door == null ? null : _int(door, 'Y');
      final hasDoor =
          doorX != null && doorY != null && doorX >= 0 && doorY >= 0;
      final id = guid == null || guid.isEmpty ? '$index:$type' : guid;
      result.add(
        _BuildingRecord(
          node,
          MigrationBuilding(
            id: id,
            type: type,
            origin: TilePoint(x, y),
            width: width,
            height: height,
            doorOffset: hasDoor ? TilePoint(doorX, doorY) : null,
            mailboxOffset: type == 'Farmhouse' ? const TilePoint(9, 4) : null,
          ),
        ),
      );
      index++;
    }
    return result;
  }

  static int? _int(XmlElement parent, String name) => double.tryParse(
    parent.findElements(name).firstOrNull?.innerText ?? '',
  )?.toInt();

  static String? _text(XmlElement parent, String name) =>
      parent.findElements(name).firstOrNull?.innerText.trim();

  static void _setText(XmlElement parent, String name, String value) {
    final element = parent.findElements(name).firstOrNull;
    if (element == null) throw StateError('Missing $name');
    element.children
      ..clear()
      ..add(XmlText(value));
  }

  static String _basename(String path) =>
      path.split(Platform.pathSeparator).where((part) => part.isNotEmpty).last;

  static Future<void> _copyDirectory(
    Directory source,
    Directory destination,
  ) async {
    await destination.create(recursive: true);
    await for (final entity in source.list(recursive: false)) {
      final name = _basename(entity.path);
      if (entity is File) {
        await entity.copy('${destination.path}${Platform.pathSeparator}$name');
      } else if (entity is Directory) {
        await _copyDirectory(
          entity,
          Directory('${destination.path}${Platform.pathSeparator}$name'),
        );
      }
    }
  }
}

class _BuildingRecord {
  const _BuildingRecord(this.node, this.model);
  final XmlElement node;
  final MigrationBuilding model;
}

class _PlanBundle {
  const _PlanBundle({
    this.error,
    this.farm,
    this.records,
    this.buildingPlan,
    this.contentPlan,
    this.relocator,
  });

  final FarmTypeChangeError? error;
  final XmlElement? farm;
  final List<_BuildingRecord>? records;
  final FarmMigrationPlan? buildingPlan;
  final FarmContentRelocationPlan? contentPlan;
  final FarmContentRelocator? relocator;
}

class _FarmSnapshot {
  const _FarmSnapshot({
    required this.uniqueId,
    required this.buildingIds,
    required this.containerCounts,
  });

  factory _FarmSnapshot.fromDocument(XmlDocument document) {
    final farm = FarmTypeChangeService._farm(document);
    final records = farm == null
        ? const <_BuildingRecord>[]
        : FarmTypeChangeService._buildingRecords(farm) ?? const [];
    int count(String name) =>
        farm
            ?.findElements(name)
            .firstOrNull
            ?.children
            .whereType<XmlElement>()
            .length ??
        0;
    return _FarmSnapshot(
      uniqueId:
          document.rootElement
              .findElements('uniqueIDForThisGame')
              .firstOrNull
              ?.innerText ??
          '',
      buildingIds: records.map((record) => record.model.id).toList(),
      containerCounts: {
        'buildings': count('buildings'),
        'objects': count('objects'),
        'terrainFeatures': count('terrainFeatures'),
        'resourceClumps': count('resourceClumps'),
        'largeTerrainFeatures': count('largeTerrainFeatures'),
        'characters': count('characters'),
        'furniture': count('furniture'),
      },
    );
  }

  final String uniqueId;
  final List<String> buildingIds;
  final Map<String, int> containerCounts;

  bool sameIdentityAndCounts(_FarmSnapshot other) =>
      uniqueId == other.uniqueId &&
      _listEquals(buildingIds, other.buildingIds) &&
      _mapEquals(containerCounts, other.containerCounts);

  static bool _listEquals<T>(List<T> a, List<T> b) {
    if (a.length != b.length) return false;
    for (var i = 0; i < a.length; i++) {
      if (a[i] != b[i]) return false;
    }
    return true;
  }

  static bool _mapEquals<K, V>(Map<K, V> a, Map<K, V> b) {
    if (a.length != b.length) return false;
    for (final entry in a.entries) {
      if (b[entry.key] != entry.value) return false;
    }
    return true;
  }
}
