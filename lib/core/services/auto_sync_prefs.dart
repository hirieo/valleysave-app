import 'package:shared_preferences/shared_preferences.dart';

/// spec 009 (Capa 2, D7-D9) — persistencia del auto-sync POR PARTIDA (chip
/// `⚡ AUTO` en la cabecera de la card). Sin precedente de ajuste por-partida
/// en el código: patrón nuevo pero mínimo, un `Set<String>` de `folderName`
/// serializado en `SharedPreferences` (clave `autoSyncEnabledSaves`).
///
/// Apagado por defecto para cada save nueva (D9). Independiente de
/// [AutoRefreshPrefs] — apagar el interruptor global (Capa 1) NO apaga estos
/// chips, y viceversa (D7).
class AutoSyncPrefs {
  AutoSyncPrefs._();

  static const key = 'autoSyncEnabledSaves';

  /// ¿El usuario pidió expresamente no volver a ver el aviso de auto-sync
  /// PARA ESTA PARTIDA? El chip por sí solo no explica que la app va a
  /// subir/bajar SIN preguntar (feedback 2026-07-31), así que CADA
  /// activación abre un diálogo que lo explica y pide confirmar, salvo que
  /// se marque "no volver a mostrar" (2026-08-01, desmarcado por defecto).
  /// Por partida, no global (feedback 2026-08-02): marcarlo en una partida
  /// no silencia el aviso en las demás.
  ///
  /// Clave renombrada a propósito: la anterior (`autoSyncExplainerSeen`)
  /// significaba "ya se mostró una vez, en toda la app" y quedó a `true` en
  /// instalaciones de prueba, lo que silenciaba el aviso nuevo desde el
  /// primer arranque.
  static const explainerKey = 'autoSyncExplainerDismissedSaves';

  /// Todo el conjunto activado — usado por `saves_screen.dart` para cachear
  /// en memoria y no releer prefs en cada build de cada card.
  static Future<Set<String>> loadAll() async {
    final prefs = await SharedPreferences.getInstance();
    return (prefs.getStringList(key) ?? const []).toSet();
  }

  static Future<bool> isEnabled(String folderName) async {
    final all = await loadAll();
    return all.contains(folderName);
  }

  static Future<bool> explainerDismissed(String folderName) async {
    final prefs = await SharedPreferences.getInstance();
    final dismissed = prefs.getStringList(explainerKey) ?? const [];
    return dismissed.contains(folderName);
  }

  static Future<void> markExplainerDismissed(String folderName) async {
    final prefs = await SharedPreferences.getInstance();
    final dismissed = (prefs.getStringList(explainerKey) ?? const []).toSet();
    dismissed.add(folderName);
    await prefs.setStringList(explainerKey, dismissed.toList());
  }

  static Future<void> setEnabled(String folderName, bool enabled) async {
    final prefs = await SharedPreferences.getInstance();
    final all = await loadAll();
    if (enabled) {
      all.add(folderName);
    } else {
      all.remove(folderName);
    }
    await prefs.setStringList(key, all.toList());
  }
}
