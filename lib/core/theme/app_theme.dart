import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'app_colors.dart';
import 'app_radius.dart';
import 'valley_theme_extension.dart';

class AppTheme {
  AppTheme._();

  static ThemeData dark() {
    final base = ThemeData.dark(useMaterial3: true);

    return base.copyWith(
      brightness: Brightness.dark,
      scaffoldBackgroundColor: AppColors.bg,
      canvasColor: AppColors.bg,
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.accent,
        brightness: Brightness.dark,
        primary:   AppColors.accent,
        secondary: AppColors.green,
        surface:   AppColors.surface,
        onPrimary: AppColors.greenTen,
        onSurface: AppColors.text,
      ),
      textTheme: GoogleFonts.urbanistTextTheme(base.textTheme).apply(
        bodyColor:    AppColors.text,
        displayColor: AppColors.text,
      ),
      dividerColor: AppColors.border,
      cardTheme: CardThemeData(
        color: AppColors.surface,
        elevation: 0,
        shape: const RoundedRectangleBorder(borderRadius: AppRadius.brLg),
      ),
      extensions: <ThemeExtension<dynamic>>[
        ValleyThemeExtension.dark,
      ],
    );
  }
}
