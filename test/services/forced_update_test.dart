import 'package:flutter_test/flutter_test.dart';
import 'package:valleysave/core/services/forced_update_service.dart';

void main() {
  test('min-version.json dormido (0.0.0) nunca obliga', () {
    final min = ForcedUpdateService.minimumFor(
      '{"schema":1,"android":"0.0.0","windows":"0.0.0"}',
      'android',
    );
    expect(min, '0.0.0');
    expect(ForcedUpdateService.mustUpdate('0.4.3', min!), isFalse);
  });

  test('obliga solo por debajo de la mínima', () {
    expect(ForcedUpdateService.mustUpdate('0.4.3', '0.5.0'), isTrue);
    expect(ForcedUpdateService.mustUpdate('0.5.0', '0.5.0'), isFalse);
    expect(ForcedUpdateService.mustUpdate('0.5.1', '0.5.0'), isFalse);
    expect(ForcedUpdateService.mustUpdate('0.4.10', '0.4.9'), isFalse);
  });

  test('JSON roto, plataforma ausente o versión rara → sin mínima', () {
    expect(ForcedUpdateService.minimumFor('nope', 'android'), isNull);
    expect(ForcedUpdateService.minimumFor('{"windows":"1.0.0"}', 'android'), isNull);
    expect(ForcedUpdateService.minimumFor('{"android":"latest"}', 'android'), isNull);
  });
}
