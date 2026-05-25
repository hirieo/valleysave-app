import 'package:flutter/material.dart';

import 'core/theme/app_theme.dart';
import 'features/welcome/welcome_screen.dart';

void main() {
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
