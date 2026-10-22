import 'dart:convert';
import 'dart:io';

import '../models/mod_info.dart';

/// Lee los mods de una carpeta `Mods` igual que SMAPI (research §3): cada
/// carpeta con `manifest.json` es un mod; una carpeta sin él se recorre como
/// contenedor; las subcarpetas que empiezan por `.` están desactivadas y se
/// ignoran. Solo lee.
class ModScanner {
  /// Versión de SMAPI para Android de referencia (research §2: 4.3.2.1 beta).
  static const androidSmapiVersion = '4.3.2';

  static const _maxDepth = 5;

  static Future<List<ModInfo>> scan(String modsDir) async {
    final root = Directory(modsDir);
    if (!await root.exists()) return [];
    final mods = <ModInfo>[];
    await _walk(root, root.path, 0, mods);
    mods.sort((a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()));
    return mods;
  }

  static Future<void> _walk(
    Directory dir,
    String rootPath,
    int depth,
    List<ModInfo> out,
  ) async {
    if (depth > _maxDepth) return;
    final List<FileSystemEntity> children;
    try {
      children = await dir.list(followLinks: false).toList();
    } on FileSystemException {
      return;
    }
    for (final child in children) {
      if (child is! Directory) continue;
      final name = child.path.split(Platform.pathSeparator).last;
      if (name.startsWith('.') || name == '__MACOSX') continue;
      final manifest = File('${child.path}${Platform.pathSeparator}manifest.json');
      if (await manifest.exists()) {
        final mod = await _read(manifest, child.path, rootPath);
        if (mod != null) out.add(mod);
      } else {
        await _walk(child, rootPath, depth + 1, out);
      }
    }
  }

  static Future<ModInfo?> _read(
    File manifest,
    String folderPath,
    String rootPath,
  ) async {
    final Map<String, dynamic> json;
    try {
      final parsed = parseLenientJson(
        utf8.decode(await manifest.readAsBytes(), allowMalformed: true),
      );
      if (parsed is! Map<String, dynamic>) return null;
      json = {for (final e in parsed.entries) e.key.toLowerCase(): e.value};
    } on FormatException {
      return null;
    } on FileSystemException {
      return null;
    }

    String? str(String key) {
      final v = json[key];
      return v is String && v.trim().isNotEmpty ? v.trim() : null;
    }

    final uniqueId = str('uniqueid');
    if (uniqueId == null) return null;

    final entryDll = str('entrydll');
    final cpf = json['contentpackfor'];
    String? contentPackFor;
    if (cpf is Map) {
      for (final e in cpf.entries) {
        if ('${e.key}'.toLowerCase() == 'uniqueid' && e.value is String) {
          contentPackFor = (e.value as String).trim();
        }
      }
    }
    final isCode = entryDll != null;
    final isPack = contentPackFor != null && contentPackFor.isNotEmpty;
    final kind = isCode == isPack
        ? ModKind.invalid
        : (isCode ? ModKind.csharp : ModKind.contentPack);

    final deps = <String>[];
    final rawDeps = json['dependencies'];
    if (rawDeps is List) {
      for (final d in rawDeps) {
        if (d is! Map) continue;
        String? id;
        var required = true;
        for (final e in d.entries) {
          final k = '${e.key}'.toLowerCase();
          if (k == 'uniqueid' && e.value is String) id = e.value as String;
          if (k == 'isrequired' && e.value == false) required = false;
        }
        if (id != null && required) deps.add(id);
      }
    }

    final sep = Platform.pathSeparator;
    var relative = folderPath.startsWith(rootPath)
        ? folderPath.substring(rootPath.length)
        : folderPath;
    if (relative.startsWith(sep)) relative = relative.substring(1);

    return ModInfo(
      uniqueId: uniqueId,
      name: str('name') ?? uniqueId,
      author: str('author') ?? '',
      version: str('version') ?? '?',
      kind: kind,
      folderPath: folderPath,
      relativePath: relative.replaceAll(sep, '/'),
      minimumApiVersion: str('minimumapiversion'),
      contentPackFor: contentPackFor,
      updateKeys: [
        if (json['updatekeys'] is List)
          for (final k in json['updatekeys'] as List)
            if (k is String) k,
      ],
      dependencies: deps,
      hasConfig: await File('$folderPath${sep}config.json').exists(),
    );
  }

  /// Compatibilidad en PC: funciona si el SMAPI local cumple su mínimo.
  static ModCompat pcCompat(ModInfo mod, String? smapiVersion) {
    if (mod.kind == ModKind.invalid) return ModCompat.unsupported;
    final min = mod.minimumApiVersion;
    if (min == null || smapiVersion == null) return ModCompat.works;
    return compareVersions(smapiVersion, min) >= 0
        ? ModCompat.works
        : ModCompat.unsupported;
  }

  /// Compatibilidad orientativa en Android (research §2): pide un SMAPI que
  /// Android no tiene → ✗; contenido → ✓; código C# → ⚠.
  static ModCompat androidCompat(ModInfo mod) {
    if (mod.kind == ModKind.invalid) return ModCompat.unsupported;
    final min = mod.minimumApiVersion;
    if (min != null && compareVersions(androidSmapiVersion, min) < 0) {
      return ModCompat.unsupported;
    }
    return mod.kind == ModKind.contentPack
        ? ModCompat.works
        : ModCompat.mayFail;
  }

  /// Compara versiones tipo semver (`1.2.3-beta`); el sufijo cuenta menos que
  /// la versión limpia. Partes no numéricas valen 0.
  static int compareVersions(String a, String b) {
    List<int> nums(String v) => v
        .split(RegExp(r'[-+]'))
        .first
        .split('.')
        .map((p) => int.tryParse(p.trim()) ?? 0)
        .toList();
    final x = nums(a);
    final y = nums(b);
    for (var i = 0; i < 4; i++) {
      final d = (i < x.length ? x[i] : 0) - (i < y.length ? y[i] : 0);
      if (d != 0) return d.sign;
    }
    final preA = a.contains('-');
    final preB = b.contains('-');
    if (preA == preB) return 0;
    return preA ? -1 : 1;
  }

  /// JSON con comentarios (`//`, `/* */`) y comas finales, como los
  /// `manifest.json` que SMAPI acepta. Lanza [FormatException] si no parsea.
  static Object? parseLenientJson(String source) {
    final out = StringBuffer();
    var i = 0;
    var inString = false;
    if (source.startsWith('﻿')) i = 1;
    while (i < source.length) {
      final c = source[i];
      if (inString) {
        out.write(c);
        if (c == r'\' && i + 1 < source.length) {
          out.write(source[i + 1]);
          i += 2;
          continue;
        }
        if (c == '"') inString = false;
        i++;
        continue;
      }
      if (c == '"') {
        inString = true;
        out.write(c);
        i++;
      } else if (c == '/' && i + 1 < source.length && source[i + 1] == '/') {
        while (i < source.length && source[i] != '\n') {
          i++;
        }
      } else if (c == '/' && i + 1 < source.length && source[i + 1] == '*') {
        final end = source.indexOf('*/', i + 2);
        i = end < 0 ? source.length : end + 2;
      } else {
        out.write(c);
        i++;
      }
    }
    final cleaned = out.toString().replaceAllMapped(
      RegExp(r',(\s*[}\]])'),
      (m) => m[1]!,
    );
    return jsonDecode(cleaned);
  }
}
