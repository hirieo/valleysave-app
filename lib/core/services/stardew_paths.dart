import 'package:shared_preferences/shared_preferences.dart';

/// Carpeta de saves de Stardew Valley en Android (protegida desde Android 11)
/// por defecto: usuario 0, paquete oficial. Ya NO es la ruta usada
/// directamente — la ruta real es [AndroidSavesPath.current], que vale esto
/// salvo que el usuario haya elegido otra (Samsung Dual Messenger, perfil de
/// trabajo, usuarios secundarios...).
const defaultGameSavesPath =
    '/storage/emulated/0/Android/data/com.chucklefish.stardewvalley/files/Saves';

/// Clave de SharedPreferences con la ruta de saves elegida por el usuario.
const androidSavesPathPrefKey = 'android_saves_path';

final _safeSavesPathRe = RegExp(r'^/[A-Za-z0-9_./ -]{1,512}$');

/// ¿[path] es seguro para interpolarse (siempre entre comillas simples) en un
/// comando shell que corre como root/shell? Absoluta, sin segmentos `..`,
/// sin caracteres de control/NUL/salto de línea, y solo
/// `^/[A-Za-z0-9_./ -]{1,512}$`. Se valida al guardar Y antes de cada uso.
bool isValidSavesPath(String? path) {
  if (path == null) return false;
  if (!_safeSavesPathRe.hasMatch(path)) return false;
  if (path.split('/').contains('..')) return false;
  return true;
}

/// Ruta de saves de Android resuelta en tiempo de ejecución (persistida).
/// Cargar con [ensureLoaded] antes de usar [current] fuera de la UI de
/// ajustes; si nunca se cargó o el valor guardado es inválido, devuelve el
/// valor por defecto.
class AndroidSavesPath {
  AndroidSavesPath._();
  static final AndroidSavesPath instance = AndroidSavesPath._();

  String _current = defaultGameSavesPath;
  bool _loaded = false;

  /// Siempre válida (o la ruta por defecto).
  String get current => _current;

  bool get isDefault => _current == defaultGameSavesPath;

  Future<void> ensureLoaded() async {
    if (_loaded) return;
    await reload();
  }

  Future<void> reload() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final saved = prefs.getString(androidSavesPathPrefKey);
      _current = isValidSavesPath(saved) ? saved! : defaultGameSavesPath;
    } catch (_) {
      _current = defaultGameSavesPath;
    }
    _loaded = true;
  }

  /// Guarda [path]. `false` (sin tocar nada) si no es válida.
  Future<bool> set(String path) async {
    final normalized = path.length > 1 && path.endsWith('/')
        ? path.substring(0, path.length - 1)
        : path;
    if (!isValidSavesPath(normalized)) return false;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(androidSavesPathPrefKey, normalized);
    _current = normalized;
    _loaded = true;
    return true;
  }

  Future<void> reset() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(androidSavesPathPrefKey);
    _current = defaultGameSavesPath;
    _loaded = true;
  }
}
