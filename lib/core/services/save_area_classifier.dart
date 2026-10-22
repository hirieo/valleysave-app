import 'dart:convert';
import 'dart:io';

import 'package:shared_preferences/shared_preferences.dart';

import '../models/save_area.dart';
import 'drive_service.dart' show isModSidecarName;

/// Decide en qué pestaña va una partida LOCAL de escritorio, donde Normal y
/// SMAPI comparten carpeta (spec 010, "Clasificación de partidas en PC"):
///
/// 1. Elección manual del usuario (persistida por `folderName`).
/// 2. Rastro de mods: claves `smapi/mod-data/` en el archivo de partida
///    (research §5) o datos de mod `.json` junto a ella.
/// 3. Si no, Normal.
///
/// Solo lee; nunca modifica la partida.
class SaveAreaClassifier {
  SaveAreaClassifier._();
  static final instance = SaveAreaClassifier._();

  static const overridesPrefKey = 'save_area_overrides';
  static final _marker = ascii.encode('smapi/mod-data/');

  Map<String, SaveArea> _overrides = {};
  bool _loaded = false;

  /// Resultado de la búsqueda del marcador por archivo, invalidado si
  /// cambian tamaño o fecha — el archivo de partida pesa varios MB.
  final _markerCache = <String, ({int size, DateTime modified, bool found})>{};

  Future<void> ensureLoaded() async {
    if (_loaded) return;
    final prefs = await SharedPreferences.getInstance();
    _overrides = decodeOverrides(prefs.getString(overridesPrefKey));
    _loaded = true;
  }

  SaveArea? overrideFor(String folderName) => _overrides[folderName];

  /// Fija (o con `null` quita) la pestaña elegida a mano para [folderName].
  Future<void> setOverride(String folderName, SaveArea? area) async {
    await ensureLoaded();
    if (area == null) {
      _overrides.remove(folderName);
    } else {
      _overrides[folderName] = area;
    }
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(overridesPrefKey, encodeOverrides(_overrides));
  }

  Future<SaveArea> classify(String savesDir, String folderName) async {
    await ensureLoaded();
    final manual = _overrides[folderName];
    if (manual != null) return manual;
    final folder = '$savesDir${Platform.pathSeparator}$folderName';
    return await hasModTraces(folder, folderName)
        ? SaveArea.smapi
        : SaveArea.normal;
  }

  Future<bool> hasModTraces(String folderPath, String folderName) async {
    final dir = Directory(folderPath);
    if (!await dir.exists()) return false;
    await for (final e in dir.list(followLinks: false)) {
      final name = e.path.split(Platform.pathSeparator).last;
      if (e is File && isModSidecarName(name)) return true;
    }
    final main = File('$folderPath${Platform.pathSeparator}$folderName');
    if (!await main.exists()) return false;
    final stat = await main.stat();
    final cached = _markerCache[main.path];
    if (cached != null &&
        cached.size == stat.size &&
        cached.modified == stat.modified) {
      return cached.found;
    }
    final found = await containsBytes(main.openRead(), _marker);
    _markerCache[main.path] = (
      size: stat.size,
      modified: stat.modified,
      found: found,
    );
    return found;
  }

  /// Busca [needle] en un flujo sin cargarlo entero, también cuando cae
  /// partido entre dos bloques.
  static Future<bool> containsBytes(
    Stream<List<int>> stream,
    List<int> needle,
  ) async {
    var carry = <int>[];
    await for (final chunk in stream) {
      final data = carry.isEmpty ? chunk : [...carry, ...chunk];
      if (_indexOf(data, needle) >= 0) return true;
      final keep = needle.length - 1;
      carry = data.length > keep ? data.sublist(data.length - keep) : data;
    }
    return false;
  }

  static int _indexOf(List<int> data, List<int> needle) {
    outer:
    for (var i = 0; i <= data.length - needle.length; i++) {
      for (var j = 0; j < needle.length; j++) {
        if (data[i + j] != needle[j]) continue outer;
      }
      return i;
    }
    return -1;
  }

  static Map<String, SaveArea> decodeOverrides(String? raw) {
    if (raw == null) return {};
    try {
      final map = jsonDecode(raw);
      if (map is! Map) return {};
      return {
        for (final e in map.entries)
          if (e.key is String && SaveArea.values.any((a) => a.name == e.value))
            e.key as String: SaveArea.values.byName(e.value as String),
      };
    } on FormatException {
      return {};
    }
  }

  static String encodeOverrides(Map<String, SaveArea> overrides) =>
      jsonEncode({for (final e in overrides.entries) e.key: e.value.name});
}
