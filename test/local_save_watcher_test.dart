// spec 009 (T924) — test puro de Dart, sin widget: debounce de
// `LocalSaveWatcher` (G1). Escribe varios archivos seguidos en una carpeta
// temporal real y comprueba que el callback se dispara UNA sola vez.
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:valleysave/core/services/local_save_watcher.dart';

void main() {
  late Directory tempDir;

  setUp(() async {
    tempDir = await Directory.systemTemp.createTemp('local_save_watcher_test_');
  });

  tearDown(() async {
    if (await tempDir.exists()) {
      await tempDir.delete(recursive: true);
    }
  });

  test('G1: varios FileSystemEvent seguidos disparan un solo onChange', () async {
    var callCount = 0;
    final watcher = LocalSaveWatcher(
      path: tempDir.path,
      onChange: () => callCount++,
      debounce: const Duration(milliseconds: 200),
    );
    watcher.start();
    addTearDown(watcher.stop);

    // Ráfaga de escrituras — mismo escenario que un guardado real de Stardew
    // Valley (varios archivos por guardado).
    for (var i = 0; i < 5; i++) {
      await File(
        '${tempDir.path}/save_$i.xml',
      ).writeAsString('contenido $i');
      await Future<void>.delayed(const Duration(milliseconds: 20));
    }

    // Antes de que venza el debounce, el callback todavía no debe haberse
    // disparado (cada escritura reinicia el temporizador).
    await Future<void>.delayed(const Duration(milliseconds: 80));
    expect(callCount, 0);

    // Tras el debounce completo desde la ÚLTIMA escritura, se dispara UNA
    // sola vez.
    await Future<void>.delayed(const Duration(milliseconds: 300));
    expect(callCount, 1);
  });

  test('stop() cancela el debounce pendiente — no dispara tras parar', () async {
    var callCount = 0;
    final watcher = LocalSaveWatcher(
      path: tempDir.path,
      onChange: () => callCount++,
      debounce: const Duration(milliseconds: 150),
    );
    watcher.start();

    await File('${tempDir.path}/save.xml').writeAsString('x');
    await Future<void>.delayed(const Duration(milliseconds: 30));
    watcher.stop();

    await Future<void>.delayed(const Duration(milliseconds: 300));
    expect(callCount, 0);
  });

  test('carpeta inexistente: start() no lanza y no queda activo', () async {
    final missing = '${tempDir.path}/no_existe';
    final watcher = LocalSaveWatcher(path: missing, onChange: () {});
    expect(() => watcher.start(), returnsNormally);
    expect(watcher.isActive, isFalse);
    watcher.stop();
  });
}
