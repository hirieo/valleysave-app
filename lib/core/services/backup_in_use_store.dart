import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

/// Backup «en uso» de una partida (spec 012, D3): el último que se restauró
/// sobre ella. [contentHash] es la huella del contenido que quedó en la
/// partida al restaurar; sirve para saber cuándo la marca deja de valer
/// (la partida cambió porque se jugó o se sincronizó).
class InUseBackup {
  const InUseBackup({required this.fileName, required this.contentHash});

  final String fileName;
  final String contentHash;
}

/// Persistencia de [InUseBackup] por partida en `SharedPreferences`: un mapa
/// JSON `folderName → {fileName, contentHash}` bajo la clave [key].
class BackupInUseStore {
  const BackupInUseStore();

  static const key = 'backup_in_use';

  Future<InUseBackup?> get(String folderName) async {
    final all = await _load();
    return all[folderName];
  }

  Future<void> set(
    String folderName,
    String fileName,
    String contentHash,
  ) async {
    final all = await _load();
    all[folderName] = InUseBackup(fileName: fileName, contentHash: contentHash);
    await _save(all);
  }

  Future<void> clear(String folderName) async {
    final all = await _load();
    if (all.remove(folderName) != null) await _save(all);
  }

  /// «Conservar» renombra el zip: si [oldFileName] es el que está en uso en
  /// [folderName], la marca pasa a [newFileName] con la misma huella.
  /// Devuelve `true` si había marca que mover.
  Future<bool> rename(
    String folderName,
    String oldFileName,
    String newFileName,
  ) async {
    final all = await _load();
    final current = all[folderName];
    if (current == null || current.fileName != oldFileName) return false;
    all[folderName] = InUseBackup(
      fileName: newFileName,
      contentHash: current.contentHash,
    );
    await _save(all);
    return true;
  }

  Future<Map<String, InUseBackup>> _load() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(key);
    final out = <String, InUseBackup>{};
    if (raw == null || raw.isEmpty) return out;
    try {
      final decoded = jsonDecode(raw);
      if (decoded is! Map) return out;
      decoded.forEach((folder, value) {
        if (folder is! String || value is! Map) return;
        final fileName = value['fileName'];
        final contentHash = value['contentHash'];
        if (fileName is String && contentHash is String) {
          out[folder] = InUseBackup(
            fileName: fileName,
            contentHash: contentHash,
          );
        }
      });
    } catch (_) {
      // Prefs corruptas: sin marca. Peor caso, un backup deja de estar
      // protegido y entra en la retención normal.
    }
    return out;
  }

  Future<void> _save(Map<String, InUseBackup> all) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(
      key,
      jsonEncode({
        for (final e in all.entries)
          e.key: {
            'fileName': e.value.fileName,
            'contentHash': e.value.contentHash,
          },
      }),
    );
  }
}
