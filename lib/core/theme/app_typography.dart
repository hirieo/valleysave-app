import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'app_colors.dart';

/// ValleySave typography tokens.
///
/// Fraunces (italic) for display, DM Sans for body, DM Mono for stats/labels.
class AppTypography {
  AppTypography._();

  // ----- Display (Fraunces italic) -----
  static TextStyle hero({Color color = AppColors.text}) =>
      GoogleFonts.fraunces(
        textStyle: TextStyle(
          color: color,
          fontSize: 84,
          fontStyle: FontStyle.italic,
          fontWeight: FontWeight.w700,
          height: 0.92,
          letterSpacing: -2,
        ),
      );

  static TextStyle h2({Color color = AppColors.text}) =>
      GoogleFonts.fraunces(
        textStyle: TextStyle(
          color: color,
          fontSize: 40,
          fontStyle: FontStyle.italic,
          fontWeight: FontWeight.w700,
          height: 1.05,
          letterSpacing: -0.6,
        ),
      );

  static TextStyle stat({Color color = AppColors.accent}) =>
      GoogleFonts.fraunces(
        textStyle: TextStyle(
          color: color,
          fontSize: 36,
          fontStyle: FontStyle.italic,
          fontWeight: FontWeight.w700,
        ),
      );

  // ----- Body (DM Sans) -----
  static TextStyle body({Color color = AppColors.textMuted}) =>
      GoogleFonts.dmSans(
        textStyle: TextStyle(
          color: color,
          fontSize: 17,
          fontWeight: FontWeight.w400,
          height: 1.5,
        ),
      );

  static TextStyle bodyStrong({Color color = AppColors.text}) =>
      GoogleFonts.dmSans(
        textStyle: TextStyle(
          color: color,
          fontSize: 17,
          fontWeight: FontWeight.w500,
          height: 1.5,
        ),
      );

  static TextStyle button({Color color = AppColors.text}) =>
      GoogleFonts.dmSans(
        textStyle: TextStyle(
          color: color,
          fontSize: 17,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.2,
        ),
      );

  // ----- Mono (DM Mono) -----
  static TextStyle mono({Color color = AppColors.textFaint, double size = 12}) =>
      GoogleFonts.dmMono(
        textStyle: TextStyle(
          color: color,
          fontSize: size,
          fontWeight: FontWeight.w400,
          letterSpacing: 0.8,
        ),
      );

  static TextStyle eyebrow({Color color = AppColors.green}) =>
      GoogleFonts.dmSans(
        textStyle: TextStyle(
          color: color,
          fontSize: 12,
          fontWeight: FontWeight.w700,
          letterSpacing: 1.6,
        ),
      );
}
