import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'core/services/locale_controller.dart';
import 'core/services/season_controller.dart';
import 'core/theme/app_theme.dart';
import 'features/onboarding/privacy_screen.dart';
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
  runApp(ValleySaveApp(privacyAccepted: accepted));
}

class ValleySaveApp extends StatefulWidget {
  const ValleySaveApp({super.key, required this.privacyAccepted});
  final bool privacyAccepted;

  @override
  State<ValleySaveApp> createState() => _ValleySaveAppState();
}

class _ValleySaveAppState extends State<ValleySaveApp> {
  late bool _accepted = widget.privacyAccepted;

  @override
  void initState() {
    super.initState();
    LocaleController.instance.locale.addListener(_onLocale);
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
      debugShowCheckedModeBanner: false,
      theme: AppTheme.dark(),
      locale: LocaleController.instance.locale.value,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: _accepted
          ? const WelcomeScreen()
          : PrivacyScreen(onAccepted: () => setState(() => _accepted = true)),
    );
  }
}
