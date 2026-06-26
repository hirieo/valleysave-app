import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:package_info_plus/package_info_plus.dart';
import 'package:url_launcher/url_launcher.dart';

class UpdateService {
  static const _owner   = 'hirieo';
  static const _repo    = 'valleysave-app';
  static const _apiUrl  = 'https://api.github.com/repos/$_owner/$_repo/releases/latest';
  static const _htmlUrl = 'https://github.com/$_owner/$_repo/releases/latest';

  /// Returns the latest version string if newer than installed, null otherwise.
  /// Fails silently on any error (no internet, API down, etc.).
  static Future<String?> checkForUpdate() async {
    try {
      final info = await PackageInfo.fromPlatform();
      final current = info.version; // e.g. "0.1.0"

      final res = await http.get(
        Uri.parse(_apiUrl),
        headers: {'Accept': 'application/vnd.github+json'},
      ).timeout(const Duration(seconds: 8));

      if (res.statusCode != 200) return null;

      final data = json.decode(res.body) as Map<String, dynamic>;
      final tag  = (data['tag_name'] as String? ?? '').replaceFirst('v', '');
      if (tag.isEmpty) return null;

      return _isNewer(tag, current) ? tag : null;
    } catch (_) {
      return null;
    }
  }

  static bool _isNewer(String latest, String current) {
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

  static Future<void> openReleasePage() async {
    final uri = Uri.parse(_htmlUrl);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }
}
