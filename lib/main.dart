import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'core/services/forced_update_service.dart';
import 'core/services/gamepad_service.dart';
import 'core/services/locale_controller.dart';
import 'core/services/season_controller.dart';
import 'core/theme/app_theme.dart';
import 'features/onboarding/privacy_screen.dart';
import 'features/update/forced_update_screen.dart';
import 'features/welcome/welcome_screen.dart';
import 'generated/app_localizations.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    await dotenv.load(fileName: '.env');
  } catch (_) {
    // .env no disponible (CI, build sin credenciales): continuar sin él
  }
  await SeasonController.instance.init();
  await LocaleController.instance.init();
  final accepted = await hasAcceptedPrivacy();
  // Actualización obligatoria dormida (0.4.3): solo actúa si `min-version.json`
  // sube la mínima de esta plataforma. Aquí solo la última conocida (rápido);
  // la comprobación en red va después, sin retrasar el arranque.
  final forced = await ForcedUpdateService.instance.mustUpdateFromCache();
  // Sin esperar: si el mando tarda en listarse o la plataforma no lo
  // soporta, la app arranca igual — es una capa de accesibilidad extra,
  // nunca un requisito para usar la app.
  unawaited(GamepadService.instance.start());
  runApp(ValleySaveApp(privacyAccepted: accepted, forcedUpdate: forced));
}

class ValleySaveApp extends StatefulWidget {
  const ValleySaveApp({
    super.key,
    required this.privacyAccepted,
    this.forcedUpdate = false,
  });
  final bool privacyAccepted;
  final bool forcedUpdate;

  @override
  State<ValleySaveApp> createState() => _ValleySaveAppState();
}

class _ValleySaveAppState extends State<ValleySaveApp> {
  late bool _accepted = widget.privacyAccepted;
  late bool _forced = widget.forcedUpdate;
  final _navigatorKey = GlobalKey<NavigatorState>();

  @override
  void initState() {
    super.initState();
    LocaleController.instance.locale.addListener(_onLocale);
    _checkForcedUpdate();
  }

  Future<void> _checkForcedUpdate() async {
    final must = await ForcedUpdateService.instance.refresh();
    if (!must || _forced || !mounted) return;
    _forced = true;
    _navigatorKey.currentState?.pushAndRemoveUntil(
      MaterialPageRoute<void>(builder: (_) => const ForcedUpdateScreen()),
      (_) => false,
    );
  }

  @override
  void dispose() {
    LocaleController.instance.locale.removeListener(_onLocale);
    super.dispose();
  }

  void _onLocale() => setState(() {});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ValleySave',
      navigatorKey: _navigatorKey,
      debugShowCheckedModeBanner: false,
      theme: AppTheme.dark(),
      navigatorObservers: [GamepadService.instance.navObserver],
      locale: LocaleController.instance.locale.value,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: _forced
          ? const ForcedUpdateScreen()
          : _accepted
          ? const WelcomeScreen()
          : PrivacyScreen(onAccepted: () => setState(() => _accepted = true)),
    );
  }
}
