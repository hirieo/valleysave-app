import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

void main() {
  for (final fileName in [
    'macos/Runner/DebugProfile.entitlements',
    'macos/Runner/Release.entitlements',
  ]) {
    test('$fileName permite OAuth local y credenciales de Keychain', () {
      final contents = File(fileName).readAsStringSync();

      expect(contents, contains('com.apple.security.network.client'));
      expect(contents, contains('com.apple.security.network.server'));
      expect(contents, contains('keychain-access-groups'));
    });
  }
}
