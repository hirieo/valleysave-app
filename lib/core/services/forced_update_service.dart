import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:package_info_plus/package_info_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Actualización obligatoria, dormida por defecto (desde 0.4.3).
///
/// `min-version.json` en la rama `main` del repo fija la versión mínima por
/// plataforma. Con todo a `0.0.0` no hace nada: las actualizaciones siguen
/// siendo a elección (chip de bienvenida y Ajustes). Si un día se sube la
/// mínima de una plataforma, las versiones por debajo se actualizan solas al
/// abrir y no dejan usar la app hasta hacerlo.
///
/// Sin conexión se usa la última mínima conocida. Si nunca se pudo leer, se
/// deja entrar: un fallo de red nunca bloquea a nadie por error.
class ForcedUpdateService {
  ForcedUpdateService._();
  static final instance = ForcedUpdateService._();

  static const _url =
      'https://raw.githubusercontent.com/hirieo/valleysave-app/main/min-version.json';
  static const lastMinimumPrefKey = 'forced_update_last_minimum';

  /// Solo para probar el flujo en local:
  /// `--dart-define=FORCED_UPDATE_TEST_MIN=0.4.2`. Vacío en las releases.
  static const _testMinimum = String.fromEnvironment('FORCED_UPDATE_TEST_MIN');

  static String get platformKey => Platform.isAndroid
      ? 'android'
      : Platform.isWindows
      ? 'windows'
      : Platform.isLinux
      ? 'linux'
      : Platform.isMacOS
      ? 'macos'
      : 'other';

  /// ¿Obliga la última mínima conocida? Solo lee preferencias: rápido, para
  /// decidir la primera pantalla al arrancar.
  Future<bool> mustUpdateFromCache() async {
    if (_testMinimum.isNotEmpty) {
      return mustUpdate(await _installedVersion(), _testMinimum);
    }
    final prefs = await SharedPreferences.getInstance();
    final min = prefs.getString(lastMinimumPrefKey);
    if (min == null) return false;
    return mustUpdate(await _installedVersion(), min);
  }

  /// Lee `min-version.json`, recuerda la mínima de esta plataforma y dice si
  /// obliga. Si no se puede leer, decide con la última conocida.
  Future<bool> refresh({http.Client? client}) async {
    if (_testMinimum.isNotEmpty) {
      return mustUpdate(await _installedVersion(), _testMinimum);
    }
    final prefs = await SharedPreferences.getInstance();
    final c = client ?? http.Client();
    try {
      final res = await c
          .get(Uri.parse(_url))
          .timeout(const Duration(seconds: 8));
      if (res.statusCode == 200) {
        final min = minimumFor(res.body, platformKey);
        if (min != null) await prefs.setString(lastMinimumPrefKey, min);
      }
    } catch (_) {
      // Sin red: se decide con la última mínima conocida (abajo).
    } finally {
      if (client == null) c.close();
    }
    final min = prefs.getString(lastMinimumPrefKey);
    if (min == null) return false;
    return mustUpdate(await _installedVersion(), min);
  }

  /// Mínima de [platform] en el JSON, o `null` si no es válido.
  static String? minimumFor(String body, String platform) {
    try {
      final json = jsonDecode(body);
      if (json is! Map) return null;
      final v = json[platform];
      if (v is! String || !RegExp(r'^\d+\.\d+\.\d+$').hasMatch(v)) return null;
      return v;
    } on FormatException {
      return null;
    }
  }

  /// ¿[installed] es menor que [minimum]? Semver campo a campo
  /// (major → minor → patch), igual que el autoactualizador.
  static bool mustUpdate(String installed, String minimum) {
    int part(String v, int i) {
      final parts = v.split('+').first.split('.');
      return i < parts.length ? (int.tryParse(parts[i]) ?? 0) : 0;
    }
    for (var i = 0; i < 3; i++) {
      final m = part(minimum, i);
      final c = part(installed, i);
      if (m != c) return m > c;
    }
    return false;
  }

  static Future<String> _installedVersion() async =>
      (await PackageInfo.fromPlatform()).version;
}
