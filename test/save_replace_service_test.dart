import 'dart:async';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

import 'package:valleysave/core/models/backup_entry.dart';
import 'package:valleysave/core/services/save_replace_service.dart';

/// Tests del núcleo transaccional (spec 001-integridad-transaccional-saves,
/// T005). Cubre los caminos de fallo exigidos por la constitución (principio
/// V): el destino queda intacto byte a byte en cualquier fallo salvo el swap
/// mismo, que si falla revierte al original.
///
/// Estilo: filesystem temporal real (como `host_swap_service_test.dart`),
/// sin mocks — el propio patrón de renames es lo que se está probando.

String _infoXml({String money = '500'}) =>
    '''<?xml version="1.0" encoding="utf-8"?>
<Farmer>
  <name>Ana</name>
  <farmName>Granja Test</farmName>
  <slotCanHost>false</slotCanHost>
  <money>$money</money>
</Farmer>''';

String _mainXml() => '''<?xml version="1.0" encoding="utf-8"?>
<SaveGame xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">
  <uniqueIDForThisGame>123456789</uniqueIDForThisGame>
  <player><name>Ana</name></player>
  <locations/>
</SaveGame>''';

/// Escribe un save mínimo válido en `<parent>/<folderName>`, con [money]
/// como marcador para distinguir versiones "antes"/"después" en los tests.
Future<Directory> _writeSave(
  Directory parent,
  String folderName, {
  String money = '500',
}) async {
  final sep = Platform.pathSeparator;
  final dir = Directory('${parent.path}$sep$folderName');
  await dir.create(recursive: true);
  await File(
    '${dir.path}${sep}SaveGameInfo',
  ).writeAsString(_infoXml(money: money));
  await File('${dir.path}$sep$folderName').writeAsString(_mainXml());
  return dir;
}

Future<Map<String, List<int>>> _snapshot(Directory dir) async {
  final out = <String, List<int>>{};
  if (!await dir.exists()) return out;
  await for (final e in dir.list(recursive: true)) {
    if (e is File) out[e.path] = await e.readAsBytes();
  }
  return out;
}

/// Nombres de entrada de nivel superior en [dir] (para comprobar que no
/// quedan `.vs_tmp_*`/`.vs_rollback_*` huérfanas tras una operación).
Future<List<String>> _topLevelNames(Directory dir) async {
  if (!await dir.exists()) return [];
  final sep = Platform.pathSeparator;
  return [
    await for (final e in dir.list(recursive: false)) e.path.split(sep).last,
  ];
}

void main() {
  late Directory tempDir;
  late String savesDir;
  late String backupsDir;
  // Con guion bajo a propósito: los nombres de save reales de Stardew ya
  // llevan `_` (p. ej. `Pleyades_395187544`) — ver nota en replaceSaveFolder
  // sobre por qué el rollback usa estructura anidada en vez de parsear esto.
  const folderName = 'Pleyades_395187544';

  final service = SaveReplaceService.instance;

  setUp(() async {
    tempDir = await Directory.systemTemp.createTemp('save_replace_test_');
    savesDir = '${tempDir.path}${Platform.pathSeparator}Saves';
    backupsDir = '${tempDir.path}${Platform.pathSeparator}Backups';
    await Directory(savesDir).create(recursive: true);
  });

  tearDown(() async {
    // Por si algún test dejó una carpeta sin permisos de escritura (test de
    // fallo de rename) — sin esto tearDown no podría borrar tempDir entero.
    if (Platform.isLinux || Platform.isMacOS) {
      await Process.run('chmod', ['-R', '755', tempDir.path]);
    }
    if (await tempDir.exists()) await tempDir.delete(recursive: true);
  });

  group('replaceSaveFolder — éxito', () {
    test('destino nuevo: no hay respaldo, contenido final es el preparado', () async {
      final result = await service.replaceSaveFolder(
        savesDir: savesDir,
        folderName: folderName,
        backupsDir: backupsDir,
        prepare: (dir) => _writeSave(dir.parent, folderName, money: '777')
            .then((_) => null),
      );

      expect(result.ok, isTrue);
      expect(result.autoBackup, isNull);

      final finalMain = File(
        '$savesDir${Platform.pathSeparator}$folderName${Platform.pathSeparator}$folderName',
      );
      expect(await finalMain.exists(), isTrue);

      // Sin huérfanas: solo la carpeta del save queda en savesDir.
      expect(await _topLevelNames(Directory(savesDir)), [folderName]);
    });

    test(
      'destino existente: respaldo automático creado y verificado, contenido final es el nuevo',
      () async {
        await _writeSave(Directory(savesDir), folderName, money: '500');

        final result = await service.replaceSaveFolder(
          savesDir: savesDir,
          folderName: folderName,
          backupsDir: backupsDir,
          prepare: (dir) =>
              _writeSave(dir.parent, folderName, money: '999').then((_) => null),
        );

        expect(result.ok, isTrue);
        expect(result.autoBackup, isNotNull);
        expect(result.autoBackup!.origin, BackupOrigin.auto);
        expect(await File(result.autoBackup!.localPath!).exists(), isTrue);

        final infoContent = await File(
          '$savesDir${Platform.pathSeparator}$folderName${Platform.pathSeparator}SaveGameInfo',
        ).readAsString();
        expect(infoContent, contains('<money>999</money>'));

        expect(await _topLevelNames(Directory(savesDir)), [folderName]);
      },
    );
  });

  group('replaceSaveFolder — fallos, destino intacto', () {
    test('prepare lanza a mitad → destino intacto, sin temporales', () async {
      await _writeSave(Directory(savesDir), folderName, money: '500');
      final before = await _snapshot(Directory(savesDir));

      final result = await service.replaceSaveFolder(
        savesDir: savesDir,
        folderName: folderName,
        backupsDir: backupsDir,
        prepare: (dir) async {
          await File(
            '${dir.path}${Platform.pathSeparator}SaveGameInfo',
          ).writeAsString('a medias');
          throw StateError('fallo simulado a mitad de prepare');
        },
      );

      expect(result.ok, isFalse);
      expect(result.error, ReplaceError.prepareFailed);
      expect(await _snapshot(Directory(savesDir)), before);
      expect(await _topLevelNames(Directory(savesDir)), [folderName]);
    });

    test(
      'prepare no deja SaveGameInfo + archivo principal → prepareFailed, destino intacto',
      () async {
        await _writeSave(Directory(savesDir), folderName, money: '500');
        final before = await _snapshot(Directory(savesDir));

        final result = await service.replaceSaveFolder(
          savesDir: savesDir,
          folderName: folderName,
          backupsDir: backupsDir,
          prepare: (dir) async {
            await File(
              '${dir.path}${Platform.pathSeparator}SaveGameInfo',
            ).writeAsString(_infoXml());
            // Nunca escribe el archivo principal.
          },
        );

        expect(result.ok, isFalse);
        expect(result.error, ReplaceError.prepareFailed);
        expect(await _snapshot(Directory(savesDir)), before);
      },
    );

    test('XML remoto corrupto → validationFailed, destino intacto', () async {
      await _writeSave(Directory(savesDir), folderName, money: '500');
      final before = await _snapshot(Directory(savesDir));

      final result = await service.replaceSaveFolder(
        savesDir: savesDir,
        folderName: folderName,
        backupsDir: backupsDir,
        prepare: (dir) async {
          final sep = Platform.pathSeparator;
          await File('${dir.path}$sep$folderName').writeAsString(_mainXml());
          await File(
            '${dir.path}${sep}SaveGameInfo',
          ).writeAsString('esto no es xml');
        },
      );

      expect(result.ok, isFalse);
      expect(result.error, ReplaceError.validationFailed);
      expect(await _snapshot(Directory(savesDir)), before);
    });

    test(
      '[validate] adicional rechaza el contenido → validationFailed, destino intacto',
      () async {
        await _writeSave(Directory(savesDir), folderName, money: '500');
        final before = await _snapshot(Directory(savesDir));

        final result = await service.replaceSaveFolder(
          savesDir: savesDir,
          folderName: folderName,
          backupsDir: backupsDir,
          prepare: (dir) =>
              _writeSave(dir.parent, folderName, money: '1').then((_) => null),
          validate: (_) async => false,
        );

        expect(result.ok, isFalse);
        expect(result.error, ReplaceError.validationFailed);
        expect(await _snapshot(Directory(savesDir)), before);
      },
    );

    test(
      'respaldo automático no creable (backupsDir inescribible) → backupFailed, destino intacto',
      () async {
        await _writeSave(Directory(savesDir), folderName, money: '500');
        final before = await _snapshot(Directory(savesDir));

        // backupsDir apunta DENTRO de un archivo (no un directorio) — crearlo
        // falla de forma determinista en cualquier plataforma POSIX/Windows.
        final blocker = File(
          '${tempDir.path}${Platform.pathSeparator}blocker',
        );
        await blocker.writeAsString('no soy un directorio');
        final unwritableBackupsDir =
            '${blocker.path}${Platform.pathSeparator}Backups';

        final result = await service.replaceSaveFolder(
          savesDir: savesDir,
          folderName: folderName,
          backupsDir: unwritableBackupsDir,
          prepare: (dir) =>
              _writeSave(dir.parent, folderName, money: '999').then((_) => null),
        );

        expect(result.ok, isFalse);
        expect(result.error, ReplaceError.backupFailed);
        expect(await _snapshot(Directory(savesDir)), before);
      },
    );

    test(
      'reentrada: segunda llamada mientras la primera está en curso → busy',
      () async {
        final gate = Completer<void>();

        final call1 = service.replaceSaveFolder(
          savesDir: savesDir,
          folderName: folderName,
          backupsDir: backupsDir,
          prepare: (dir) async {
            await _writeSave(dir.parent, folderName, money: '42');
            await gate.future;
          },
        );

        final result2 = await service.replaceSaveFolder(
          savesDir: savesDir,
          folderName: folderName,
          backupsDir: backupsDir,
          prepare: (dir) async {},
        );
        expect(result2.error, ReplaceError.busy);

        gate.complete();
        final result1 = await call1;
        expect(result1.ok, isTrue);
      },
    );
  });

  group('replaceSaveFolder — fallo del swap final', () {
    test(
      'segundo rename falla → el original se restaura desde el rollback',
      () async {
        if (Platform.isWindows) return; // técnica de chmod es POSIX-only.

        await _writeSave(Directory(savesDir), folderName, money: '500');
        final before = await _snapshot(Directory(savesDir));

        final result = await service.replaceSaveFolder(
          savesDir: savesDir,
          folderName: folderName,
          backupsDir: backupsDir,
          prepare: (dir) async {
            await _writeSave(dir.parent, folderName, money: '999');
            // Quita permiso de escritura al padre de la staging dir DESPUÉS
            // de prepararla — el segundo rename (stagingDir → destino) deja
            // de poder desligar la entrada de su directorio padre, así que
            // falla, sin afectar al primer rename (que ya se completó sobre
            // savesDir, un directorio distinto).
            final r = await Process.run('chmod', ['555', dir.parent.path]);
            expect(r.exitCode, 0, reason: r.stderr.toString());
          },
        );

        expect(result.ok, isFalse);
        expect(result.error, ReplaceError.swapFailed);

        // El original (money=500) sigue en su sitio, byte a byte.
        final after = await _snapshot(Directory(savesDir));
        expect(
          after['$savesDir${Platform.pathSeparator}$folderName${Platform.pathSeparator}SaveGameInfo'],
          before['$savesDir${Platform.pathSeparator}$folderName${Platform.pathSeparator}SaveGameInfo'],
        );
      },
    );
  });

  group('sweepOrphans', () {
    test('borra temporales .vs_tmp_* huérfanas sin tocar saves reales', () async {
      await _writeSave(Directory(savesDir), folderName, money: '500');
      final orphanTmp = Directory(
        '$savesDir${Platform.pathSeparator}.vs_tmp_orphan123',
      );
      await orphanTmp.create(recursive: true);
      await _writeSave(orphanTmp, 'Irrelevante_1');

      await service.sweepOrphans(savesDir, backupsDir: backupsDir);

      expect(await orphanTmp.exists(), isFalse);
      expect(
        await Directory(
          '$savesDir${Platform.pathSeparator}$folderName',
        ).exists(),
        isTrue,
      );
    });

    test(
      'rollback huérfano SIN destino vivo → se restaura a su sitio original',
      () async {
        final rollbackRoot = Directory(
          '$savesDir${Platform.pathSeparator}.vs_rollback_orphan456',
        );
        await _writeSave(rollbackRoot, folderName, money: '321');

        await service.sweepOrphans(savesDir, backupsDir: backupsDir);

        expect(await rollbackRoot.exists(), isFalse);
        final restoredInfo = File(
          '$savesDir${Platform.pathSeparator}$folderName${Platform.pathSeparator}SaveGameInfo',
        );
        expect(await restoredInfo.exists(), isTrue);
        expect(await restoredInfo.readAsString(), contains('<money>321</money>'));
      },
    );

    test(
      'rollback huérfano CON destino vivo → se archiva como respaldo automático, nunca se pierde',
      () async {
        await _writeSave(Directory(savesDir), folderName, money: '999');
        final rollbackRoot = Directory(
          '$savesDir${Platform.pathSeparator}.vs_rollback_orphan789',
        );
        await _writeSave(rollbackRoot, folderName, money: '321');

        await service.sweepOrphans(savesDir, backupsDir: backupsDir);

        expect(await rollbackRoot.exists(), isFalse);
        // El destino vivo (999) no se tocó.
        final liveInfo = File(
          '$savesDir${Platform.pathSeparator}$folderName${Platform.pathSeparator}SaveGameInfo',
        );
        expect(await liveInfo.readAsString(), contains('<money>999</money>'));
        // El contenido del rollback (321) sobrevive como respaldo automático.
        final backups = await Directory(backupsDir).list().toList();
        expect(backups, isNotEmpty);
      },
    );
  });
}
