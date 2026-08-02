import 'package:shared_preferences/shared_preferences.dart';

/// spec 009 (Capa 1, D4) — persistencia del interruptor GLOBAL de
/// auto-actualización (Ajustes → APLICACIÓN). Fuente única de la clave y el
/// valor por defecto para que `saves_screen.dart` (dueño del watcher/timer) y
/// `settings_screen.dart` (dueño del interruptor visual) nunca se
/// desincronicen por un typo de cadena.
///
/// Ámbito: SOLO gobierna la Capa 1 (refresco pasivo). No tiene relación con
/// [AutoSyncPrefs] (Capa 2, D7 — capas independientes a propósito).
class AutoRefreshPrefs {
  AutoRefreshPrefs._();

  static const key = 'autoRefreshEnabled';

  /// Default `true` (D4): auto-actualizar viene activado de fábrica.
  static Future<bool> isEnabled() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(key) ?? true;
  }

  static Future<void> setEnabled(bool enabled) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(key, enabled);
  }
}
