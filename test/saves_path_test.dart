import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:valleysave/core/services/android_protected_commands.dart';
import 'package:valleysave/core/services/saves_folder_scan.dart';
import 'package:valleysave/core/services/stardew_paths.dart';

String q(String v) => "'${v.replaceAll("'", "'\\''")}'";

void main() {
  group('isValidSavesPath', () {
    test('acepta la ruta por defecto y variantes de usuario', () {
      expect(isValidSavesPath(defaultGameSavesPath), isTrue);
      expect(
        isValidSavesPath(
          '/storage/emulated/95/Android/data/com.chucklefish.stardewvalley/files/Saves',
        ),
        isTrue,
      );
      expect(isValidSavesPath('/storage/emulated/0/My Saves-1_a.b'), isTrue);
    });

    test('rechaza relativas, vacías y null', () {
      expect(isValidSavesPath(null), isFalse);
      expect(isValidSavesPath(''), isFalse);
      expect(isValidSavesPath('/'), isFalse);
      expect(isValidSavesPath('storage/emulated/0'), isFalse);
      expect(isValidSavesPath('./x'), isFalse);
    });

    test('rechaza traversal', () {
      expect(isValidSavesPath('/storage/../data'), isFalse);
      expect(isValidSavesPath('/a/b/..'), isFalse);
      expect(isValidSavesPath('/..'), isFalse);
      expect(isValidSavesPath('/a/..b/c'), isTrue); // ".." solo como segmento
    });

    test('rechaza metacaracteres de shell y de control', () {
      for (final bad in [
        '/a;rm -rf /',
        '/a\$(id)',
        '/a`id`',
        '/a|b',
        '/a&b',
        "/a'b",
        '/a"b',
        '/a\\b',
        '/a\nb',
        '/a\rb',
        '/a\u0000b',
        '/a\tb',
        '/a*b',
        '/a?b',
        '/a>b',
        '/ñ',
      ]) {
        expect(isValidSavesPath(bad), isFalse, reason: bad);
      }
    });

    test('longitud máxima 512 tras la barra inicial', () {
      expect(isValidSavesPath('/${'a' * 512}'), isTrue);
      expect(isValidSavesPath('/${'a' * 513}'), isFalse);
    });
  });

  group('AndroidSavesPath', () {
    setUp(() => SharedPreferences.setMockInitialValues({}));

    test('por defecto sin preferencia', () async {
      await AndroidSavesPath.instance.reload();
      expect(AndroidSavesPath.instance.current, defaultGameSavesPath);
      expect(AndroidSavesPath.instance.isDefault, isTrue);
    });

    test('guarda y recarga una ruta válida (quita barra final)', () async {
      expect(await AndroidSavesPath.instance.set('/storage/emulated/95/x/'), isTrue);
      expect(AndroidSavesPath.instance.current, '/storage/emulated/95/x');
      final prefs = await SharedPreferences.getInstance();
      expect(prefs.getString(androidSavesPathPrefKey), '/storage/emulated/95/x');
      await AndroidSavesPath.instance.reload();
      expect(AndroidSavesPath.instance.current, '/storage/emulated/95/x');
    });

    test('rechaza guardar una ruta inválida y no cambia nada', () async {
      await AndroidSavesPath.instance.reset();
      expect(await AndroidSavesPath.instance.set('/a/../b'), isFalse);
      expect(await AndroidSavesPath.instance.set('/a;b'), isFalse);
      expect(AndroidSavesPath.instance.current, defaultGameSavesPath);
    });

    test('valor guardado inválido → vuelve al defecto', () async {
      SharedPreferences.setMockInitialValues({
        androidSavesPathPrefKey: '/x/\$(id)',
      });
      await AndroidSavesPath.instance.reload();
      expect(AndroidSavesPath.instance.current, defaultGameSavesPath);
    });

    test('reset borra la preferencia', () async {
      await AndroidSavesPath.instance.set('/storage/emulated/10/x');
      await AndroidSavesPath.instance.reset();
      final prefs = await SharedPreferences.getInstance();
      expect(prefs.containsKey(androidSavesPathPrefKey), isFalse);
      expect(AndroidSavesPath.instance.current, defaultGameSavesPath);
    });
  });

  group('AndroidProtectedCommands con baseDir', () {
    test('usa el baseDir personalizado en todas las rutas', () {
      const base = '/storage/emulated/95/Android/data/x/files/Saves';
      final cmd = AndroidProtectedCommands.replace(
        src: '/tmp/stage',
        folderName: 'Farm_1',
        transactionId: 'tx1',
        baseDir: base,
      )!;
      expect(cmd, contains("'$base/.vs_tmp_tx1'"));
      expect(cmd, contains("'$base/Farm_1'"));
      expect(cmd, isNot(contains(defaultGameSavesPath)));
    });

    test('baseDir inválido → null', () {
      for (final bad in ['rel/path', '/a/../b', "/a'; rm -rf /; '", '/a\nb']) {
        expect(
          AndroidProtectedCommands.replace(
            src: '/tmp/stage',
            folderName: 'Farm_1',
            transactionId: 'tx1',
            baseDir: bad,
          ),
          isNull,
          reason: bad,
        );
      }
    });

    test('sin baseDir usa la ruta resuelta (defecto)', () async {
      SharedPreferences.setMockInitialValues({});
      await AndroidSavesPath.instance.reset();
      final cmd = AndroidProtectedCommands.replace(
        src: '/tmp/stage',
        folderName: 'Farm_1',
        transactionId: 'tx1',
      )!;
      expect(cmd, contains(defaultGameSavesPath));
    });
  });

  group('parseDetectOutput', () {
    test('parsea ruta|n, descarta basura e inválidas', () {
      const out = '''
/storage/emulated/0/Android/data/com.chucklefish.stardewvalley/files/Saves|3
/storage/emulated/95/Android/data/com.chucklefish.stardewvalley/files/Saves|0
garbage line
/storage/emulated/1/../evil|2
/storage/emulated/2/a;b|1
/storage/emulated/0/Android/data/com.chucklefish.stardewvalley/files/Saves|3
/x|notanumber
''';
      final r = parseDetectOutput(out);
      expect(r.length, 2);
      expect(r[0].saveCount, 3);
      expect(r[1].path, contains('/emulated/95/'));
      expect(r[1].saveCount, 0);
    });

    test('/data/media duplicado de /storage/emulated se descarta', () {
      const out = '''
/storage/emulated/0/Android/data/com.chucklefish.stardewvalley/files/Saves|2
/data/media/0/Android/data/com.chucklefish.stardewvalley/files/Saves|2
/data/media/10/Android/data/com.chucklefish.stardewvalley/files/Saves|1
''';
      final r = parseDetectOutput(out);
      expect(r.map((c) => c.path), [
        '/storage/emulated/0/Android/data/com.chucklefish.stardewvalley/files/Saves',
        '/data/media/10/Android/data/com.chucklefish.stardewvalley/files/Saves',
      ]);
    });

    test('salida vacía → lista vacía', () {
      expect(parseDetectOutput(''), isEmpty);
    });

    test('detectScript: /data/media solo con root', () {
      expect(detectScript(root: false), isNot(contains('/data/media')));
      expect(detectScript(root: true), contains('/data/media/*/'));
      expect(detectScript(root: false), contains('/storage/emulated/*/'));
    });
  });

  group('explorador', () {
    test('parseLsDirs: solo directorios, seguros, ordenados', () {
      const out = 'zeta/\nfile.txt\nAlpha/\nbad;dir/\n\$(x)/\nmy dir/\n../\n./\n\n';
      expect(parseLsDirs(out, '/storage/emulated/0'), ['Alpha', 'my dir', 'zeta']);
    });

    test('parseLsDirs: tolera CRLF y nombre con barra', () {
      expect(parseLsDirs('a/\r\nb/c/\r\n', '/x'), ['a']);
    });

    test('listDirCommand valida y entrecomilla', () {
      expect(listDirCommand('/storage/emulated/0', q), "ls -1p '/storage/emulated/0'");
      expect(listDirCommand('/a/../b', q), isNull);
      expect(listDirCommand('/a;b', q), isNull);
      expect(listDirCommand('/', q), isNull);
    });

    test('parentDir / childDir', () {
      expect(parentDir('/a/b/c'), '/a/b');
      expect(parentDir('/a'), '/');
      expect(parentDir('/'), '/');
      expect(parentDir('/a/b/'), '/a');
      expect(childDir('/a', 'b'), '/a/b');
      expect(childDir('/', 'b'), '/b');
    });

    test('looksLikeSavesFolder', () {
      expect(looksLikeSavesFolder('/x/files/Saves'), isTrue);
      expect(
        looksLikeSavesFolder('/s/Android/data/com.chucklefish.stardewvalley/files'),
        isFalse,
      );
      expect(looksLikeSavesFolder('/storage/emulated/0/Download'), isFalse);
    });

    test('verifyScript / parseVerifyOutput', () {
      final s = verifyScript('/a b/Saves', q)!;
      expect(s, contains("'/a b/Saves'"));
      expect(verifyScript('/a\$(id)', q), isNull);
      expect(parseVerifyOutput('COUNT=4\n'), 4);
      expect(parseVerifyOutput('COUNT=0'), 0);
      expect(parseVerifyOutput('NODIR\n'), isNull);
      expect(parseVerifyOutput('permission denied'), isNull);
    });
  });
}
