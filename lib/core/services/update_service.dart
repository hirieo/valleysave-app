import 'dart:convert';
import 'dart:io';

import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:meta/meta.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:path_provider/path_provider.dart';

class UpdateInfo {
  const UpdateInfo({
    required this.version,
    this.windowsUrl,
    this.androidUrl,
  });
  final String version;
  final String? windowsUrl;
  final String? androidUrl;
}

class UpdateService {
  static const _owner  = 'hirieo';
  static const _repo   = 'valleysave-app';
  static const _apiUrl = 'https://api.github.com/repos/$_owner/$_repo/releases/latest';

  /// Returns [UpdateInfo] if a newer version exists, null otherwise.
  static Future<UpdateInfo?> checkForUpdate() async {
    try {
      final info = await PackageInfo.fromPlatform();
      final res = await http.get(
        Uri.parse(_apiUrl),
        headers: {'Accept': 'application/vnd.github+json'},
      ).timeout(const Duration(seconds: 8));

      if (res.statusCode != 200) return null;

      final data = json.decode(res.body) as Map<String, dynamic>;
      final tag  = (data['tag_name'] as String? ?? '').replaceFirst('v', '');
      if (tag.isEmpty || !isNewer(tag, info.version)) return null;

      String? windowsUrl;
      String? androidUrl;
      for (final asset in (data['assets'] as List<dynamic>? ?? [])) {
        final name = (asset['name'] as String? ?? '').toLowerCase();
        final url  = asset['browser_download_url'] as String? ?? '';
        if (name.endsWith('.zip')) windowsUrl = url;
        if (name.endsWith('.apk')) androidUrl = url;
      }

      return UpdateInfo(version: tag, windowsUrl: windowsUrl, androidUrl: androidUrl);
    } catch (_) {
      return null;
    }
  }

  /// Install the update. On Android opens the APK in the browser/download manager.
  /// On Windows downloads the zip, writes a PS1 updater, and exits the app.
  static Future<void> installUpdate(
    UpdateInfo info, {
    required void Function(double progress) onProgress,
    required void Function(String error) onError,
  }) async {
    if (Platform.isAndroid) {
      await _installAndroid(info.androidUrl, onProgress: onProgress, onError: onError);
    } else if (Platform.isWindows) {
      await _installWindows(info.windowsUrl, onProgress: onProgress, onError: onError);
    }
  }

  // ── Android ──────────────────────────────────────────────────────────────────

  static Future<void> _installAndroid(
    String? apkUrl, {
    required void Function(double) onProgress,
    required void Function(String) onError,
  }) async {
    if (apkUrl == null) { onError('APK not found in release assets'); return; }
    try {
      final tmp     = await getTemporaryDirectory();
      final apkPath = '${tmp.path}/valleysave_update.apk';

      final client = http.Client();
      try {
        final res      = await client.send(http.Request('GET', Uri.parse(apkUrl)));
        final total    = res.contentLength ?? 0;
        final bytes    = <int>[];
        var   received = 0;
        await for (final chunk in res.stream) {
          bytes.addAll(chunk);
          received += chunk.length;
          if (total > 0) onProgress((received / total).clamp(0.0, 0.99));
        }
        await File(apkPath).writeAsBytes(bytes);
      } finally {
        client.close();
      }

      const channel = MethodChannel('valleysave/apk_installer');
      await channel.invokeMethod<void>('install', {'path': apkPath});
      onProgress(1.0); // cierra el diálogo justo cuando el instalador del sistema abre
    } catch (e) {
      onError(e.toString());
    }
  }

  // ── Windows ──────────────────────────────────────────────────────────────────

  static Future<void> _installWindows(
    String? zipUrl, {
    required void Function(double) onProgress,
    required void Function(String) onError,
  }) async {
    if (zipUrl == null) { onError('Windows zip not found in release assets'); return; }
    try {
      final tmp     = await getTemporaryDirectory();
      final zipPath = '${tmp.path}\\valleysave_update.zip';

      // Download with progress
      final client = http.Client();
      try {
        final res      = await client.send(http.Request('GET', Uri.parse(zipUrl)));
        final total    = res.contentLength ?? 0;
        final bytes    = <int>[];
        var   received = 0;

        await for (final chunk in res.stream) {
          bytes.addAll(chunk);
          received += chunk.length;
          if (total > 0) onProgress(received / total);
        }
        onProgress(1.0);
        await File(zipPath).writeAsBytes(bytes);
      } finally {
        client.close();
      }

      // Write PS1 updater. Clave: esperar a que ESTE proceso muera (por PID, no
      // un sleep a ciegas) para que los archivos se desbloqueen; reintentar la
      // extracción por si el lock tarda en soltarse; loguear fallos; relanzar.
      final exe     = Platform.resolvedExecutable;
      final appDir  = File(exe).parent.path;
      final ps1Path = '${tmp.path}\\vs_update.ps1';
      final logPath = '${tmp.path}\\vs_update.log';
      await File(ps1Path).writeAsString([
        r"$ErrorActionPreference = 'Stop'",
        '\$log = "$logPath"',
        'try {',
        '  Wait-Process -Id $pid -Timeout 30 -ErrorAction SilentlyContinue',
        '  \$done = \$false',
        '  for (\$i = 0; \$i -lt 15; \$i++) {',
        '    try {',
        '      Expand-Archive -Force -Path "$zipPath" -DestinationPath "$appDir"',
        '      \$done = \$true; break',
        '    } catch { Start-Sleep -Milliseconds 700 }',
        '  }',
        '  if (-not \$done) {',
        '    "No se pudo extraer la actualizacion: archivos aun bloqueados." | Out-File -FilePath \$log -Encoding utf8',
        '    exit 1',
        '  }',
        '  Start-Process "$exe"',
        '} catch {',
        '  \$_ | Out-File -FilePath \$log -Encoding utf8',
        '}',
      ].join('\r\n'));

      await Process.start(
        'powershell',
        ['-ExecutionPolicy', 'Bypass', '-WindowStyle', 'Hidden', '-File', ps1Path],
        mode: ProcessStartMode.detached,
      );

      exit(0);
    } catch (e) {
      onError(e.toString());
    }
  }

  // ── Helpers ──────────────────────────────────────────────────────────────────

  @visibleForTesting
  static bool isNewer(String latest, String current) {
    int part(String v, int i) {
      final parts = v.split('.');
      return i < parts.length ? (int.tryParse(parts[i]) ?? 0) : 0;
    }
    for (var i = 0; i < 3; i++) {
      final l = part(latest, i);
      final c = part(current, i);
      if (l > c) return true;
      if (l < c) return false;
    }
    return false;
  }
}
