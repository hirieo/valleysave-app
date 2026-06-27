import 'dart:ui';

import 'package:flutter/foundation.dart';

import 'language_service.dart';

class LocaleController {
  static final instance = LocaleController._();
  LocaleController._();

  final ValueNotifier<Locale?> locale = ValueNotifier(null);

  Future<void> init() async {
    locale.value = await LanguageService().load();
  }

  Future<void> set(Locale? l) async {
    locale.value = l;
    await LanguageService().save(l);
  }
}
