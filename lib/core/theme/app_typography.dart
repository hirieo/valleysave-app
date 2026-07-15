import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'app_colors.dart';

/// ValleySave typography tokens.
///
/// Bodoni Moda (itálica) para display, Fira Code para todo lo demás —
/// mismo par en toda la app (tarjetas, diálogos, cabeceras).
class AppTypography {
  AppTypography._();

  // ----- Display (Bodoni Moda italic) -----
  static TextStyle hero({Color color = AppColors.text}) =>
      GoogleFonts.bodoniModa(
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
      GoogleFonts.bodoniModa(
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
      GoogleFonts.bodoniModa(
        textStyle: TextStyle(
          color: color,
          fontSize: 36,
          fontStyle: FontStyle.italic,
          fontWeight: FontWeight.w700,
        ),
      );

  // ----- Body (Fira Code) -----
  static TextStyle body({Color color = AppColors.textMuted}) =>
      GoogleFonts.firaCode(
        textStyle: TextStyle(
          color: color,
          fontSize: 15,
          fontWeight: FontWeight.w400,
          height: 1.5,
        ),
      );

  static TextStyle bodyStrong({Color color = AppColors.text}) =>
      GoogleFonts.firaCode(
        textStyle: TextStyle(
          color: color,
          fontSize: 15,
          fontWeight: FontWeight.w500,
          height: 1.5,
        ),
      );

  // ----- Mono (Fira Code) -----
  static TextStyle mono({Color color = AppColors.textFaint, double size = 12}) =>
      GoogleFonts.firaCode(
        textStyle: TextStyle(
          color: color,
          fontSize: size,
          fontWeight: FontWeight.w400,
          letterSpacing: 0.8,
        ),
      );

  static TextStyle button({Color color = AppColors.text}) =>
      GoogleFonts.firaCode(
        textStyle: TextStyle(
          color: color,
          fontSize: 13,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.2,
        ),
      );

  static TextStyle eyebrow({Color color = AppColors.green}) =>
      GoogleFonts.firaCode(
        textStyle: TextStyle(
          color: color,
          fontSize: 11,
          fontWeight: FontWeight.w700,
          letterSpacing: 1.6,
        ),
      );
}
