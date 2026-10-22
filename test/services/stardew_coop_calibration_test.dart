import 'package:flutter_test/flutter_test.dart';
import 'package:valleysave/core/services/stardew_coop_calibration.dart';

void main() {
  group('StardewCoopCalibration', () {
    test('builds the official tap sequence from five session points', () {
      final calibration = StardewCoopCalibration.fromNative({
        'status': 'ready',
        'points': [10, 20, 30, 40, 50, 60, 70, 80, 90, 100],
        'width': 1080,
        'height': 2400,
        'rotation': 0,
      });

      expect(calibration, isNotNull);
      expect(calibration!.tapCoordinates, [
        10,
        20,
        10,
        20,
        30,
        40,
        30,
        40,
        50,
        60,
        70,
        80,
        50,
        60,
        70,
        80,
        90,
        100,
      ]);
    });

    test('rejects missing, out-of-bounds, or malformed calibration data', () {
      expect(StardewCoopCalibration.fromNative(null), isNull);
      expect(
        StardewCoopCalibration.fromNative({'status': 'cancelled'}),
        isNull,
      );
      expect(
        StardewCoopCalibration.fromNative({
          'status': 'ready',
          'points': [0, 0],
          'width': 1080,
          'height': 2400,
          'rotation': 0,
        }),
        isNull,
      );
      expect(
        StardewCoopCalibration.fromNative({
          'status': 'ready',
          'points': [10, 20, 30, 40, 50, 60, 70, 80, 1080, 100],
          'width': 1080,
          'height': 2400,
          'rotation': 0,
        }),
        isNull,
      );
      expect(
        StardewCoopCalibration.fromNative({
          'status': 'ready',
          'points': [10, 20, 30, 40, 50, 60, 70, 80, 90, 100],
          'width': 1080,
          'height': 2400,
          'rotation': 4,
        }),
        isNull,
      );
    });
  });
}
