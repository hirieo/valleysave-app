import 'dart:io';

import 'package:path_provider/path_provider.dart';

/// Puente manual (sin Shizuku). ValleySave usa su PROPIA carpeta en
/// `/Android/data/<pkg>/files` — accesible con File API normal — como punto de
/// intercambio. El usuario cruza la frontera `/Android/data` con su app de
/// Archivos del sistema (privilegiada), que sí puede entrar en ambas carpetas.
///
/// - `bridge_out`: ValleySave deja aquí las partidas descargadas de Drive.
///   El usuario las copia con Archivos a la carpeta del juego.
/// - `bridge_in`: el usuario deja aquí (con Archivos) las partidas del juego
///   que quiere subir. ValleySave las lee y las sube a Drive.
class BridgeService {
  BridgeService._();
  static final BridgeService instance = BridgeService._();

  Future<Directory> _ensure(String sub) async {
    final ext = await getExternalStorageDirectory(); // /Android/data/<pkg>/files
    final dir = Directory('${ext!.path}/$sub');
    if (!await dir.exists()) await dir.create(recursive: true);
    return dir;
  }

  Future<Directory> outDir() => _ensure('bridge_out');
  Future<Directory> inDir() => _ensure('bridge_in');

  /// Ruta legible de cada carpeta (para mostrar y copiar al portapapeles).
  Future<String> outPath() async => (await outDir()).path;
  Future<String> inPath() async => (await inDir()).path;

  /// Prepara `bridge_out/<folderName>` vacío y devuelve su ruta, para que el
  /// caller descargue ahí la partida de Drive antes de que el usuario la copie.
  Future<String> prepareOut(String folderName) async {
    final parent = await outDir();
    final dir = Directory('${parent.path}/$folderName');
    if (await dir.exists()) await dir.delete(recursive: true);
    await dir.create(recursive: true);
    return dir.path;
  }
}
