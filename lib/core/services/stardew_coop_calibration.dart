/// Coordinates captured from one Stardew title screen; never persisted.
class StardewCoopCalibration {
  const StardewCoopCalibration({
    required this.points,
    required this.width,
    required this.height,
    required this.rotation,
  });

  /// Five x/y pairs in order: ↑ (W), ↓ (V), ← (S), → (Y), then ?.
  final List<int> points;
  final int width;
  final int height;
  final int rotation;

  static const targetOrder = <int>[0, 0, 1, 1, 2, 3, 2, 3, 4];

  static StardewCoopCalibration? fromNative(Map<Object?, Object?>? value) {
    if (value?['status'] != 'ready') return null;
    final rawPoints = value?['points'];
    final width = value?['width'];
    final height = value?['height'];
    final rotation = value?['rotation'];
    if (rawPoints is! List ||
        width is! int ||
        height is! int ||
        rotation is! int) {
      return null;
    }
    final points = rawPoints.whereType<int>().toList(growable: false);
    if (points.length != 10 ||
        width < 240 ||
        width > 10000 ||
        height < 240 ||
        height > 10000 ||
        rotation < 0 ||
        rotation > 3) {
      return null;
    }
    for (var i = 0; i < points.length; i += 2) {
      if (points[i] < 0 ||
          points[i] >= width ||
          points[i + 1] < 0 ||
          points[i + 1] >= height) {
        return null;
      }
    }
    return StardewCoopCalibration(
      points: List.unmodifiable(points),
      width: width,
      height: height,
      rotation: rotation,
    );
  }

  List<int> get tapCoordinates => [
    for (final target in targetOrder) ...[
      points[target * 2],
      points[target * 2 + 1],
    ],
  ];
}
