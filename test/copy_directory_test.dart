import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:valleysave/core/services/host_swap_service.dart'
    show copyDirectory;

/// Android restaura e importa copiando la carpeta preparada al directorio
/// externo (un `rename` entre discos falla con errno 18): la copia debe
/// conservar subcarpetas y contenido, y dejar el origen intacto.
void main() {
  late Directory root;

  setUp(() async {
    root = await Directory.systemTemp.createTemp('vs_copydir_');
  });

  tearDown(() async {
    if (await root.exists()) await root.delete(recursive: true);
  });

  test('copia archivos y subcarpetas al destino nuevo', () async {
    final src = Directory('${root.path}/src')..createSync();
    File('${src.path}/save').writeAsStringSync('datos');
    Directory('${src.path}/sub').createSync();
    File('${src.path}/sub/info').writeAsStringSync('otro');
    final dst = Directory('${root.path}/out/Granja_1');

    await copyDirectory(src, dst);

    expect(File('${dst.path}/save').readAsStringSync(), 'datos');
    expect(File('${dst.path}/sub/info').readAsStringSync(), 'otro');
    expect(File('${src.path}/save').existsSync(), isTrue);
  });
}
