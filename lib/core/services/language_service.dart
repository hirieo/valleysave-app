import 'dart:ui';

import 'package:shared_preferences/shared_preferences.dart';

class LanguageService {
  static const _key = 'app_locale';

  Future<Locale?> load() async {
    final prefs = await SharedPreferences.getInstance();
    final code = prefs.getString(_key);
    if (code == null) return null;
    if (code.contains('_')) {
      final parts = code.split('_');
      return Locale(parts[0], parts[1]);
    }
    return Locale(code);
  }

  Future<void> save(Locale? locale) async {
    final prefs = await SharedPreferences.getInstance();
    if (locale == null) {
      await prefs.remove(_key);
    } else {
      final code = locale.countryCode != null
          ? '${locale.languageCode}_${locale.countryCode}'
          : locale.languageCode;
      await prefs.setString(_key, code);
    }
  }
}
