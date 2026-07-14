import 'package:flutter_test/flutter_test.dart';
import 'package:valleysave/core/services/auth_service.dart';

void main() {
  test('rechaza credenciales antiguas limitadas a drive.file', () {
    expect(
      hasRequiredDriveScopes(const [
        'https://www.googleapis.com/auth/drive.file',
      ]),
      isFalse,
    );
  });

  test('acepta credenciales con scope Drive completo', () {
    expect(
      hasRequiredDriveScopes(const ['https://www.googleapis.com/auth/drive']),
      isTrue,
    );
  });
}
