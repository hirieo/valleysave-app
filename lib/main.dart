import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'core/services/season_controller.dart';
import 'core/theme/app_theme.dart';
import 'features/welcome/welcome_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    await dotenv.load(fileName: '.env');
  } catch (_) {
    // .env no disponible (CI, build sin credenciales): continuar sin él
  }
  await SeasonController.instance.init();
  runApp(const ValleySaveApp());
}

class ValleySaveApp extends StatelessWidget {
  const ValleySaveApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ValleySave',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.dark(),
      home: const WelcomeScreen(),
    );
  }
}
