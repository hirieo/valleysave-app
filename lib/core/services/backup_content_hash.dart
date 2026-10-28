import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:archive/archive.dart';
import 'package:crypto/crypto.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Huella de contenido de una partida (spec 012, D4): SHA-256 de, para cada
/// archivo ordenado por nombre, su nombre y sus bytes. Las funciones de
/// carpeta y de zip usan la MISMA definición para que un backup recién
/// creado de una carpeta tenga la misma huella que la carpeta.
///
/// Los archivos son los de primer nivel de la carpeta, igual que
/// `TransferService.exportSave` (que no filtra nada). Cada archivo se
/// alimenta como `nombre UTF-8 · 0x00 · longitud (8 bytes) · bytes`, así
/// «a»+«bc» nunca colisiona con «ab»+«c».
class _Digest {
  final _sink = _DigestSink();
  late final ByteConversionSink _input = sha256.startChunkedConversion(_sink);

  void addFile(String name, List<int> bytes) {
    _input.add(utf8.encode(name));
    _input.add(const [0]);
    final length = ByteData(8)..setUint64(0, bytes.length);
    _input.add(length.buffer.asUint8List());
    _input.add(bytes);
  }

  String finish() {
    _input.close();
    return _sink.digest.toString();
  }
}

class _DigestSink implements Sink<Digest> {
  late Digest digest;

  @override
  void add(Digest data) => digest = data;

  @override
  void close() {}
}

/// Huella de los archivos de primer nivel de [folderPath].
Future<String> hashSaveFolder(String folderPath) async {
  final files = <String, File>{};
  await for (final entity in Directory(folderPath).list(recursive: false)) {
    if (entity is! File) continue;
    files[entity.uri.pathSegments.last] = entity;
  }
  final digest = _Digest();
  for (final name in (files.keys.toList()..sort())) {
    digest.addFile(name, await files[name]!.readAsBytes());
  }
  return digest.finish();
}

/// Huella del contenido de [zipPath] bajo la carpeta raíz [folderName], con
/// la misma definición que [hashSaveFolder]. `null` si el zip no se puede
/// leer o no trae archivos de esa carpeta.
Future<String?> hashBackupZip(String zipPath, String folderName) async {
  try {
    final archive = ZipDecoder().decodeBytes(await File(zipPath).readAsBytes());
    final prefix = '$folderName/';
    final files = <String, List<int>>{};
    for (final f in archive.files) {
      if (!f.isFile) continue;
      final name = f.name.replaceAll('\\', '/');
      if (!name.startsWith(prefix)) continue;
      final relative = name.substring(prefix.length);
      if (relative.isEmpty || relative.contains('/')) continue;
      files[relative] = f.content;
    }
    if (files.isEmpty) return null;
    final digest = _Digest();
    for (final name in (files.keys.toList()..sort())) {
      digest.addFile(name, files[name]!);
    }
    return digest.finish();
  } catch (_) {
    return null;
  }
}

/// Caché `fileName → huella` en `SharedPreferences` (clave [key]). El nombre
/// del backup ya es único por partida y operación, así que basta como clave.
/// Nunca lanza: si las prefs no están disponibles, se comporta como vacía.
class BackupHashCache {
  const BackupHashCache();

  static const key = 'backup_content_hashes';

  Future<String?> get(String fileName) async => (await _load())[fileName];

  Future<void> put(String fileName, String hash) async {
    final all = await _load();
    all[fileName] = hash;
    await _save(all);
  }

  Future<void> remove(String fileName) async {
    final all = await _load();
    if (all.remove(fileName) != null) await _save(all);
  }

  /// Renombrado de «Conservar»: la huella sigue siendo la misma.
  Future<void> rename(String oldFileName, String newFileName) async {
    final all = await _load();
    final hash = all.remove(oldFileName);
    if (hash == null) return;
    all[newFileName] = hash;
    await _save(all);
  }

  Future<Map<String, String>> _load() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final raw = prefs.getString(key);
      if (raw == null || raw.isEmpty) return {};
      final decoded = jsonDecode(raw);
      if (decoded is! Map) return {};
      return {
        for (final e in decoded.entries)
          if (e.key is String && e.value is String)
            e.key as String: e.value as String,
      };
    } catch (_) {
      return {};
    }
  }

  Future<void> _save(Map<String, String> all) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(key, jsonEncode(all));
    } catch (_) {
      // Caché: perderla solo cuesta recalcular.
    }
  }
}
