import 'package:flutter_test/flutter_test.dart';
import 'package:valleysave/core/services/android_protected_commands.dart';
import 'package:valleysave/core/services/stardew_paths.dart';

/// Tests del constructor de comandos shell para el push transaccional en
/// Android root (candidato, NO activado — ver comentario de clase). Prueba
/// solo la CONSTRUCCIÓN del string, no la ejecución real (eso exige un
/// dispositivo rooteado que no tenemos en este entorno).
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
  });
}
