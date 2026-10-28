import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:valleysave/core/services/android_file_access.dart';

/// Shizuku (usuario shell) solo puede copiar lo que la app deja legible para
/// el grupo: se ejecuta `chmod -R g+rwX` sobre la carpeta de salida.
void main() {
  test('ejecuta chmod -R g+rwX sobre la carpeta y devuelve true', () async {
    String? exe;
    List<String>? args;
    final ok = await makeGroupAccessible(
      '/sdcard/Android/data/app/files/game_out',
      run: (e, a) async {
        exe = e;
        args = a;
        return ProcessResult(1, 0, '', '');
      },
    );

    expect(ok, isTrue);
    expect(exe, 'chmod');
    expect(args, ['-R', 'g+rwX', '/sdcard/Android/data/app/files/game_out']);
  });

  test('devuelve false si chmod falla', () async {
    final ok = await makeGroupAccessible(
      '/x',
      run: (e, a) async => ProcessResult(1, 1, '', 'Operation not permitted'),
    );

    expect(ok, isFalse);
  });

  test('devuelve false si no se puede lanzar chmod', () async {
    final ok = await makeGroupAccessible(
      '/x',
      run: (e, a) async => throw const ProcessException('chmod', []),
    );

    expect(ok, isFalse);
  });
}
