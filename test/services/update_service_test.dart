import 'package:flutter_test/flutter_test.dart';
import 'package:valleysave/core/services/update_service.dart';

void main() {
  group('UpdateService.isNewer', () {
    test('detecta versión más nueva por patch', () {
      expect(UpdateService.isNewer('0.1.15', '0.1.14'), isTrue);
    });

    test('detecta versión más nueva por minor', () {
      expect(UpdateService.isNewer('0.2.0', '0.1.14'), isTrue);
    });

    test('detecta versión más nueva por major', () {
      expect(UpdateService.isNewer('1.0.0', '0.9.9'), isTrue);
    });

    test('devuelve false si son iguales', () {
      expect(UpdateService.isNewer('0.1.15', '0.1.15'), isFalse);
    });

    test('devuelve false si la remota es más vieja', () {
      expect(UpdateService.isNewer('0.1.14', '0.1.15'), isFalse);
    });

    test('trata las partes de versión que faltan como cero', () {
      expect(UpdateService.isNewer('0.2', '0.1.15'), isTrue);
    });
  });
}
