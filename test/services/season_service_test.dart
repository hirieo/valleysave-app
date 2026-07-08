import 'package:flutter_test/flutter_test.dart';
import 'package:valleysave/core/models/season_state.dart';
import 'package:valleysave/core/services/season_service.dart';

void main() {
  final service = SeasonService();

  group('SeasonService.seasonFromMonth — hemisferio norte', () {
    test('marzo-mayo → primavera', () {
      expect(service.seasonFromMonth(3, isNorthern: true), SeasonState.spring);
      expect(service.seasonFromMonth(4, isNorthern: true), SeasonState.spring);
      expect(service.seasonFromMonth(5, isNorthern: true), SeasonState.spring);
    });

    test('junio-agosto → verano', () {
      expect(service.seasonFromMonth(6, isNorthern: true), SeasonState.summer);
      expect(service.seasonFromMonth(7, isNorthern: true), SeasonState.summer);
      expect(service.seasonFromMonth(8, isNorthern: true), SeasonState.summer);
    });

    test('septiembre-noviembre → otoño', () {
      expect(service.seasonFromMonth(9, isNorthern: true), SeasonState.fall);
      expect(service.seasonFromMonth(10, isNorthern: true), SeasonState.fall);
      expect(service.seasonFromMonth(11, isNorthern: true), SeasonState.fall);
    });

    test('diciembre-febrero → invierno', () {
      expect(service.seasonFromMonth(12, isNorthern: true), SeasonState.winter);
      expect(service.seasonFromMonth(1, isNorthern: true), SeasonState.winter);
      expect(service.seasonFromMonth(2, isNorthern: true), SeasonState.winter);
    });
  });

  group('SeasonService.seasonFromMonth — hemisferio sur (invertido)', () {
    test('marzo (primavera norte) → otoño', () {
      expect(service.seasonFromMonth(3, isNorthern: false), SeasonState.fall);
    });

    test('junio (verano norte) → invierno', () {
      expect(service.seasonFromMonth(6, isNorthern: false), SeasonState.winter);
    });

    test('septiembre (otoño norte) → primavera', () {
      expect(service.seasonFromMonth(9, isNorthern: false), SeasonState.spring);
    });

    test('diciembre (invierno norte) → verano', () {
      expect(service.seasonFromMonth(12, isNorthern: false), SeasonState.summer);
    });
  });
}
