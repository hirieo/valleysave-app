import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:valleysave/core/services/android_protected_commands.dart';
import 'package:valleysave/core/services/stardew_paths.dart';

/// Tests del constructor de comandos shell para el push transaccional en
/// Android root (candidato, NO activado — ver comentario de clase). La
/// mayoría prueba solo la CONSTRUCCIÓN del string (no hay dispositivo
/// rooteado en este entorno), pero el grupo "ejecución real en bash" corre
/// el script de verdad contra un directorio temporal (vía el [baseDir]
/// inyectable) — la única forma de probar el `trap rollback EXIT` como
/// comportamiento, no como texto.
void main() {
  test('replace() contiene todas las fases y temporales dentro de Saves', () {
    final command = AndroidProtectedCommands.replace(
      src: "/data/user/0/app/files/stage's copy",
      folderName: 'Farm_123',
      transactionId: 'tx_1',
    );

    expect(command, isNotNull);
    for (final phase in <String>[
      'preparing',
      'prepared',
      'backupVerified',
      'movingOriginal',
      'originalMoved',
      'replacementPublished',
      'verified',
      'completed',
    ]) {
      expect(command, contains('"phase":"$phase"'));
    }
    expect(command, contains('$gameSavesPath/.vs_tmp_tx_1'));
    expect(command, contains('$gameSavesPath/.vs_rollback_tx_1'));
    expect(command, contains('trap rollback EXIT'));
    expect(command, contains("stage'\\''s copy"));
  });

  test('nombre de save inseguro (traversal) → null, no construye comando', () {
    expect(
      AndroidProtectedCommands.replace(
        src: '/tmp/stage',
        folderName: '../escape',
        transactionId: 'tx',
      ),
      isNull,
    );
  });

  test('transactionId inseguro (metacaracteres) → null', () {
    expect(
      AndroidProtectedCommands.replace(
        src: '/tmp/stage',
        folderName: 'Farm_1',
        transactionId: 'tx;rm -rf /',
      ),
      isNull,
    );
  });

  test('rollback() en el script restaura el respaldo y limpia el temporal', () {
    final command = AndroidProtectedCommands.replace(
      src: '/tmp/stage',
      folderName: 'Farm_1',
      transactionId: 'tx_2',
    )!;

    expect(command, contains("mv '$gameSavesPath/.vs_rollback_tx_2'"));
    expect(
      command.indexOf('trap rollback EXIT'),
      lessThan(command.indexOf('"phase":"preparing"')),
    );
    expect(
      command,
      contains('if [ "\$swap_done" = "1" ]; then'),
      reason:
          'el destino solo se borra incondicionalmente si el swap YA '
          'ocurrió — antes de eso, rollback() no debe tocar un destino '
          'que nunca se llegó a mover (ver test de ejecución real).',
    );
    expect(
      command,
      contains(
        'if [ ! -s "$gameSavesPath/.vs_tmp_tx_2/Farm_1" ]; then exit 1; fi',
      ),
    );
    expect(
      command,
      contains('if [ ! -s "$gameSavesPath/Farm_1/Farm_1" ]; then exit 1; fi'),
    );
  });

  test("las fases describen el orden destructivo real", () {
    final command = AndroidProtectedCommands.replace(
      src: "/tmp/stage",
      folderName: "Farm_1",
      transactionId: "tx_3",
    )!;
    final moving = command.indexOf('"phase":"movingOriginal"');
    final moveOriginal = command.indexOf(
      "mv '$gameSavesPath/Farm_1' '$gameSavesPath/.vs_rollback_tx_3'",
    );
    final originalMoved = command.indexOf('"phase":"originalMoved"');
    final publish = command.indexOf(
      "mv '$gameSavesPath/.vs_tmp_tx_3' '$gameSavesPath/Farm_1'",
    );
    final published = command.indexOf('"phase":"replacementPublished"');
    expect(moving, lessThan(moveOriginal));
    expect(moveOriginal, lessThan(originalMoved));
    expect(originalMoved, lessThan(publish));
    expect(publish, lessThan(published));
  });

  group('ejecución real en bash (contra directorio temporal)', () {
    late Directory tempDir;
    late String sep;

    setUp(() async {
      tempDir = await Directory.systemTemp.createTemp('android_protected_');
      sep = Platform.pathSeparator;
    });

    tearDown(() async {
      if (await tempDir.exists()) await tempDir.delete(recursive: true);
    });

    Future<ProcessResult> run(String command) =>
        Process.run('bash', ['-c', command]);

    test(
      'origen inválido (falla ANTES del swap) → el destino existente NO se toca',
      () async {
        if (Platform.isWindows) return;

        final base = tempDir.path;
        final destDir = Directory('$base${sep}Farm_1')
          ..createSync(recursive: true);
        await File('${destDir.path}${sep}SaveGameInfo')
            .writeAsString('destino-original-info');
        await File('${destDir.path}${sep}Farm_1')
            .writeAsString('destino-original-main');

        final srcDir = Directory('$base${sep}src_invalido')
          ..createSync(recursive: true);
        // SaveGameInfo vacío → falla el check "-s" del paso "prepared",
        // ANTES de que el script toque el destino.
        await File('${srcDir.path}${sep}SaveGameInfo').writeAsString('');
        await File('${srcDir.path}${sep}Farm_1').writeAsString('src-main');

        final command = AndroidProtectedCommands.replace(
          src: srcDir.path,
          folderName: 'Farm_1',
          transactionId: 'real1',
          baseDir: base,
        )!;

        final result = await run(command);

        expect(result.exitCode, isNot(0));
        expect(
          await File('${destDir.path}${sep}SaveGameInfo').readAsString(),
          'destino-original-info',
          reason: 'el destino original no debe perderse si el fallo ocurre '
              'antes de que el script empiece a moverlo',
        );
        expect(
          await File('${destDir.path}${sep}Farm_1').readAsString(),
          'destino-original-main',
        );
        expect(await Directory('$base$sep.vs_tmp_real1').exists(), isFalse);
        expect(
          await Directory('$base$sep.vs_rollback_real1').exists(),
          isFalse,
        );
      },
    );

    test(
      'origen válido → publica el nuevo contenido y limpia los temporales',
      () async {
        if (Platform.isWindows) return;

        final base = tempDir.path;
        final destDir = Directory('$base${sep}Farm_1')
          ..createSync(recursive: true);
        await File('${destDir.path}${sep}SaveGameInfo')
            .writeAsString('destino-viejo-info');
        await File('${destDir.path}${sep}Farm_1')
            .writeAsString('destino-viejo-main');

        final srcDir = Directory('$base${sep}src_valido')
          ..createSync(recursive: true);
        await File('${srcDir.path}${sep}SaveGameInfo')
            .writeAsString('nuevo-info');
        await File('${srcDir.path}${sep}Farm_1').writeAsString('nuevo-main');

        final command = AndroidProtectedCommands.replace(
          src: srcDir.path,
          folderName: 'Farm_1',
          transactionId: 'real2',
          baseDir: base,
        )!;

        final result = await run(command);

        expect(result.exitCode, 0, reason: result.stderr.toString());
        expect(
          await File('${destDir.path}${sep}SaveGameInfo').readAsString(),
          'nuevo-info',
        );
        expect(
          await File('${destDir.path}${sep}Farm_1').readAsString(),
          'nuevo-main',
        );
        expect(await Directory('$base$sep.vs_tmp_real2').exists(), isFalse);
        expect(
          await Directory('$base$sep.vs_rollback_real2').exists(),
          isFalse,
        );
      },
    );
  });
}
