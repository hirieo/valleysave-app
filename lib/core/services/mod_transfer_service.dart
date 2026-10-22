import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:archive/archive.dart';

import '../models/mod_info.dart';
import 'mod_scanner.dart';

/// Motivo por el que [ModTransferService.installMod] no pudo completarse. En
/// todos los casos la carpeta del mod instalada antes queda intacta.
enum ModInstallError { invalidZip, unsafePath, wrongMod, writeFailure }

class ModInstallResult {
  const ModInstallResult({required this.ok, this.error, this.backupPath});
  final bool ok;
  final ModInstallError? error;

  /// Copia del mod sustituido, si había uno.
  final String? backupPath;
}

/// Un mod que viaja con una partida SMAPI (`mods.json` en Drive, spec 010).
class SaveModEntry {
  const SaveModEntry({
    required this.uniqueId,
    required this.name,
    required this.version,
    required this.kind,
    required this.relativePath,
    required this.includeConfig,
    this.pageUrl,
  });

  factory SaveModEntry.fromMod(ModInfo mod, {required bool includeConfig}) =>
      SaveModEntry(
        uniqueId: mod.uniqueId,
        name: mod.name,
        version: mod.version,
        kind: mod.kind,
        relativePath: mod.relativePath,
        includeConfig: includeConfig,
        pageUrl: mod.pageUrl,
      );

  final String uniqueId;
  final String name;
  final String version;
  final ModKind kind;
  final String relativePath;
  final bool includeConfig;
  final String? pageUrl;

  String get key => uniqueId.toLowerCase();

  Map<String, Object?> toJson() => {
    'uniqueId': uniqueId,
    'name': name,
    'version': version,
    'kind': kind.name,
    'relativePath': relativePath,
    'includeConfig': includeConfig,
    if (pageUrl != null) 'pageUrl': pageUrl,
  };

  static SaveModEntry? fromJson(Object? json) {
    if (json is! Map) return null;
    final id = json['uniqueId'];
    final version = json['version'];
    final rel = json['relativePath'];
    if (id is! String || version is! String || rel is! String) return null;
    final kindName = json['kind'];
    return SaveModEntry(
      uniqueId: id,
      name: json['name'] is String ? json['name'] as String : id,
      version: version,
      kind: ModKind.values.firstWhere(
        (k) => k.name == kindName,
        orElse: () => ModKind.invalid,
      ),
      relativePath: rel,
      includeConfig: json['includeConfig'] != false,
      pageUrl: json['pageUrl'] is String ? json['pageUrl'] as String : null,
    );
  }

  static String encodeList(List<SaveModEntry> mods) => const JsonEncoder.withIndent(
    '  ',
  ).convert({'schema': 1, 'mods': [for (final m in mods) m.toJson()]});

  static List<SaveModEntry> decodeList(String? raw) {
    if (raw == null) return [];
    try {
      final json = jsonDecode(raw);
      if (json is! Map || json['mods'] is! List) return [];
      return [
        for (final m in json['mods'] as List) ?SaveModEntry.fromJson(m),
      ];
    } on FormatException {
      return [];
    }
  }
}

/// Empaqueta e instala mods de forma segura (spec 010 "Seguridad"):
/// preparar → validar → respaldar → sustituir → verificar, con vuelta atrás.
/// Nunca toca otros mods ni nada fuera de la carpeta `Mods`.
class ModTransferService {
  /// Tope de tamaño de un mod empaquetado: evita subir por error una carpeta
  /// enorme que no es un mod.
  static const maxModBytes = 400 * 1024 * 1024;

  static final _segmentRe = RegExp(r'^[^\\/:*?"<>|\x00-\x1F]{1,120}$');

  /// ¿[relativePath] (con `/`) es una ruta segura dentro de `Mods`?
  static bool isSafeRelativePath(String relativePath) {
    if (relativePath.isEmpty || relativePath.length > 400) return false;
    if (relativePath.startsWith('/') || relativePath.contains('\\')) {
      return false;
    }
    final parts = relativePath.split('/');
    for (final p in parts) {
      if (p == '.' || p == '..' || p.startsWith('.')) return false;
      if (!_segmentRe.hasMatch(p) || p.trim() != p) return false;
    }
    return true;
  }

  static bool _isSafeEntryName(String name) {
    final n = name.replaceAll('\\', '/');
    if (n.startsWith('/') || RegExp(r'^[a-zA-Z]:').hasMatch(n)) return false;
    return !n.split('/').contains('..');
  }

  /// Zip con el contenido de la carpeta del mod (raíz = carpeta del mod).
  /// Sin `config.json` de la raíz si [includeConfig] es `false`.
  static Future<List<int>> zipMod(
    ModInfo mod, {
    required bool includeConfig,
  }) async {
    final root = Directory(mod.folderPath);
    final archive = Archive();
    var total = 0;
    await for (final e in root.list(recursive: true, followLinks: false)) {
      if (e is! File) continue;
      var rel = e.path.substring(root.path.length);
      rel = rel.replaceAll('\\', '/');
      if (rel.startsWith('/')) rel = rel.substring(1);
      if (!includeConfig && rel.toLowerCase() == 'config.json') continue;
      final bytes = await e.readAsBytes();
      total += bytes.length;
      if (total > maxModBytes) {
        throw const FileSystemException('Mod too large');
      }
      archive.addFile(ArchiveFile.bytes(rel, bytes));
    }
    return ZipEncoder().encodeBytes(archive);
  }

  /// Instala el mod de [zipBytes] en [modsDir]. Si ya hay un mod con ese
  /// `UniqueID` en [existingFolder] se sustituye ahí (respetando dónde lo
  /// tiene el usuario); si no, se crea en `Mods/<relativePath>`. Si el zip
  /// no trae `config.json`, se conserva el del mod instalado.
  static Future<ModInstallResult> installMod(
    List<int> zipBytes, {
    required String modsDir,
    required String relativePath,
    required String expectedUniqueId,
    String? existingFolder,
    String? backupsDir,
  }) async {
    final sep = Platform.pathSeparator;
    if (existingFolder == null && !isSafeRelativePath(relativePath)) {
      return const ModInstallResult(
        ok: false,
        error: ModInstallError.unsafePath,
      );
    }
    final target =
        existingFolder ?? '$modsDir$sep${relativePath.replaceAll('/', sep)}';
    if (!_isInside(modsDir, target)) {
      return const ModInstallResult(
        ok: false,
        error: ModInstallError.unsafePath,
      );
    }

    final Archive archive;
    try {
      archive = ZipDecoder().decodeBytes(zipBytes);
    } catch (_) {
      return const ModInstallResult(
        ok: false,
        error: ModInstallError.invalidZip,
      );
    }
    ArchiveFile? manifest;
    for (final f in archive.files) {
      if (!_isSafeEntryName(f.name)) {
        return const ModInstallResult(
          ok: false,
          error: ModInstallError.unsafePath,
        );
      }
      if (f.isFile && f.name.toLowerCase() == 'manifest.json') manifest = f;
    }
    if (manifest == null || !_manifestMatches(manifest, expectedUniqueId)) {
      return const ModInstallResult(
        ok: false,
        error: ModInstallError.wrongMod,
      );
    }

    final id = _shortId();
    // Con punto delante: SMAPI ignora estas carpetas si quedan huérfanas.
    final staging = Directory('$modsDir$sep.vs_tmp_$id');
    final old = Directory('$modsDir$sep.vs_old_$id');
    String? backupPath;
    try {
      await staging.create(recursive: true);
      for (final f in archive.files) {
        if (!f.isFile) continue;
        final out = File(
          '${staging.path}$sep${f.name.replaceAll('/', sep).replaceAll('\\', sep)}',
        );
        await out.parent.create(recursive: true);
        await out.writeAsBytes(f.readBytes() ?? const []);
      }
      final targetDir = Directory(target);
      final hasConfigInZip = archive.files.any(
        (f) => f.isFile && f.name.toLowerCase() == 'config.json',
      );
      if (await targetDir.exists()) {
        final existingConfig = File('$target${sep}config.json');
        if (!hasConfigInZip && await existingConfig.exists()) {
          await existingConfig.copy('${staging.path}${sep}config.json');
        }
        if (backupsDir != null) {
          backupPath = await _backup(targetDir, backupsDir, expectedUniqueId);
        }
        await targetDir.rename(old.path);
      } else {
        await targetDir.parent.create(recursive: true);
      }
      try {
        await staging.rename(target);
      } catch (_) {
        if (await old.exists()) await old.rename(target);
        rethrow;
      }
      final installed = await ModScanner.scan(Directory(target).parent.path);
      final ok = installed.any(
        (m) => m.key == expectedUniqueId.toLowerCase(),
      );
      if (!ok) {
        await Directory(target).delete(recursive: true);
        if (await old.exists()) await old.rename(target);
        return const ModInstallResult(
          ok: false,
          error: ModInstallError.wrongMod,
        );
      }
      if (await old.exists()) await old.delete(recursive: true);
      return ModInstallResult(ok: true, backupPath: backupPath);
    } catch (_) {
      if (await staging.exists()) await staging.delete(recursive: true);
      return const ModInstallResult(
        ok: false,
        error: ModInstallError.writeFailure,
      );
    }
  }

  static bool _manifestMatches(ArchiveFile manifest, String uniqueId) {
    try {
      final json = ModScanner.parseLenientJson(
        utf8.decode(manifest.readBytes() ?? const [], allowMalformed: true),
      );
      if (json is! Map) return false;
      for (final e in json.entries) {
        if ('${e.key}'.toLowerCase() == 'uniqueid' && e.value is String) {
          return (e.value as String).trim().toLowerCase() ==
              uniqueId.toLowerCase();
        }
      }
    } on FormatException {
      return false;
    }
    return false;
  }

  static bool _isInside(String root, String path) {
    final r = Directory(root).absolute.path.toLowerCase();
    final p = Directory(path).absolute.path.toLowerCase();
    final sep = Platform.pathSeparator;
    return p.startsWith(r.endsWith(sep) ? r : '$r$sep') && !p.contains('..');
  }

  static Future<String> _backup(
    Directory modDir,
    String backupsDir,
    String uniqueId,
  ) async {
    final archive = Archive();
    await for (final e in modDir.list(recursive: true, followLinks: false)) {
      if (e is! File) continue;
      var rel = e.path.substring(modDir.path.length).replaceAll('\\', '/');
      if (rel.startsWith('/')) rel = rel.substring(1);
      archive.addFile(ArchiveFile.bytes(rel, await e.readAsBytes()));
    }
    await Directory(backupsDir).create(recursive: true);
    final safeId = uniqueId.replaceAll(RegExp(r'[^A-Za-z0-9._-]'), '_');
    final stamp = DateTime.now().toUtc().millisecondsSinceEpoch;
    final path = '$backupsDir${Platform.pathSeparator}mod_${safeId}_$stamp.zip';
    await File(path).writeAsBytes(ZipEncoder().encodeBytes(archive));
    return path;
  }

  static String _shortId() {
    final r = Random();
    return List.generate(8, (_) => r.nextInt(36).toRadixString(36)).join();
  }
}
