import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;

import '../models/mod_info.dart';

/// Resultado de comprobar versiones nuevas de mods (spec 010 F4). Igual que
/// el autoactualizador de la app (regla del proyecto, 2026-08-03): un fallo
/// NUNCA se presenta como "al día" — llega como fallo, con motivo.
class ModUpdateResult {
  const ModUpdateResult.ok(this.updates) : error = null;
  const ModUpdateResult.failed(String this.error) : updates = const {};

  /// `UniqueID` en minúsculas → versión nueva sugerida.
  final Map<String, String> updates;
  final String? error;

  bool get failed => error != null;
}

/// Consulta la API pública de SMAPI (`smapi.io`, research §4): todos los mods
/// en una sola petición y cacheado una hora, como hace Stardrop.
class ModUpdateService {
  ModUpdateService._();
  static final instance = ModUpdateService._();

  static const _cacheFor = Duration(hours: 1);

  ({DateTime at, String signature, ModUpdateResult result})? _cache;

  Future<ModUpdateResult> check(
    List<ModInfo> mods, {
    required String? smapiVersion,
    http.Client? client,
  }) async {
    final candidates = [
      for (final m in mods)
        if (m.kind != ModKind.invalid) m,
    ];
    if (candidates.isEmpty) return const ModUpdateResult.ok({});
    final signature = candidates.map((m) => '${m.key}@${m.version}').join('|');
    final cached = _cache;
    if (cached != null &&
        cached.signature == signature &&
        DateTime.now().difference(cached.at) < _cacheFor) {
      return cached.result;
    }

    final apiVersion = smapiVersion ?? '4.0.0';
    final body = jsonEncode({
      'mods': [
        for (final m in candidates)
          {
            'id': m.uniqueId,
            'updateKeys': m.updateKeys,
            'installedVersion': m.version,
            'isBroken': false,
          },
      ],
      'apiVersion': apiVersion,
      'platform': Platform.isWindows
          ? 'Windows'
          : Platform.isMacOS
          ? 'Mac'
          : Platform.isLinux
          ? 'Linux'
          : 'Android',
      'includeExtendedMetadata': false,
    });

    final c = client ?? http.Client();
    ModUpdateResult result;
    try {
      final res = await c
          .post(
            Uri.parse('https://smapi.io/api/v$apiVersion/mods'),
            headers: {
              'Content-Type': 'application/json',
              'User-Agent': 'ValleySave',
            },
            body: body,
          )
          .timeout(const Duration(seconds: 15));
      result = res.statusCode == 200
          ? parseResponse(res.body)
          : ModUpdateResult.failed('HTTP ${res.statusCode}');
    } catch (e) {
      result = ModUpdateResult.failed(e.runtimeType.toString());
    } finally {
      if (client == null) c.close();
    }
    if (!result.failed) {
      _cache = (at: DateTime.now(), signature: signature, result: result);
    }
    return result;
  }

  static ModUpdateResult parseResponse(String body) {
    try {
      final json = jsonDecode(body);
      if (json is! List) return const ModUpdateResult.failed('format');
      final updates = <String, String>{};
      for (final item in json) {
        if (item is! Map) continue;
        final id = item['id'];
        final suggested = item['suggestedUpdate'];
        if (id is String && suggested is Map && suggested['version'] is String) {
          updates[id.toLowerCase()] = suggested['version'] as String;
        }
      }
      return ModUpdateResult.ok(updates);
    } on FormatException {
      return const ModUpdateResult.failed('format');
    }
  }
}
