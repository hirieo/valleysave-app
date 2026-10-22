import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

/// Preferencias de mods que decide el usuario (spec 010 D6, D7, D10). Todo
/// por `UniqueID` en minúsculas. Nunca decide la app: sin elección explícita
/// un mod no viaja, salvo que esté marcado "llevar siempre".
class ModPrefs {
  ModPrefs._();
  static final instance = ModPrefs._();

  static const carryPrefKey = 'mods_carry_by_save';
  static const alwaysPrefKey = 'mods_always_carry';
  static const noConfigPrefKey = 'mods_without_config';
  static const autoPrefKey = 'mods_auto_sync_saves';

  /// folderName → (mod → viaja). Elección explícita por partida.
  Map<String, Map<String, bool>> _carry = {};
  Set<String> _always = {};
  Set<String> _noConfig = {};
  Set<String> _auto = {};
  bool _loaded = false;

  Future<void> ensureLoaded() async {
    if (_loaded) return;
    final prefs = await SharedPreferences.getInstance();
    _carry = decodeCarry(prefs.getString(carryPrefKey));
    _always = (prefs.getStringList(alwaysPrefKey) ?? []).toSet();
    _noConfig = (prefs.getStringList(noConfigPrefKey) ?? []).toSet();
    _auto = (prefs.getStringList(autoPrefKey) ?? []).toSet();
    _loaded = true;
  }

  /// ¿Viaja [modKey] con la partida [folderName]? La elección de la partida
  /// manda; si no la hay, "llevar siempre".
  bool carries(String folderName, String modKey) =>
      _carry[folderName]?[modKey] ?? _always.contains(modKey);

  bool alwaysCarry(String modKey) => _always.contains(modKey);
  bool includeConfig(String modKey) => !_noConfig.contains(modKey);
  bool autoSync(String folderName) => _auto.contains(folderName);

  Future<void> setCarries(String folderName, String modKey, bool value) async {
    (_carry[folderName] ??= {})[modKey] = value;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(carryPrefKey, encodeCarry(_carry));
  }

  Future<void> setAlwaysCarry(String modKey, bool value) =>
      _setFlag(_always, alwaysPrefKey, modKey, value);

  Future<void> setIncludeConfig(String modKey, bool value) =>
      _setFlag(_noConfig, noConfigPrefKey, modKey, !value);

  Future<void> setAutoSync(String folderName, bool value) =>
      _setFlag(_auto, autoPrefKey, folderName, value);

  Future<void> _setFlag(
    Set<String> set,
    String prefKey,
    String item,
    bool value,
  ) async {
    value ? set.add(item) : set.remove(item);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(prefKey, set.toList());
  }

  static Map<String, Map<String, bool>> decodeCarry(String? raw) {
    if (raw == null) return {};
    try {
      final map = jsonDecode(raw);
      if (map is! Map) return {};
      return {
        for (final e in map.entries)
          if (e.key is String && e.value is Map)
            e.key as String: {
              for (final m in (e.value as Map).entries)
                if (m.key is String && m.value is bool)
                  m.key as String: m.value as bool,
            },
      };
    } on FormatException {
      return {};
    }
  }

  static String encodeCarry(Map<String, Map<String, bool>> carry) =>
      jsonEncode(carry);
}
