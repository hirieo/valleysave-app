import 'package:flutter/material.dart';

/// ValleySave color tokens.
///
/// Source of truth: `valleysave-design` skill (oklch values).
/// These are sRGB approximations of those oklch tokens.
class AppColors {
  AppColors._();

  // Tier 1 — literal palette
  static const Color goldThree = Color(0xFFF0CC72);
  static const Color goldFour  = Color(0xFFE8B84A); // accent
  static const Color goldFive  = Color(0xFFC79318);

  static const Color greenThree = Color(0xFF5DC97E);
  static const Color greenFour  = Color(0xFF3FB866);
  static const Color greenFive  = Color(0xFF1F9D4D);
  static const Color greenEight = Color(0xFF1A3D24);
  static const Color greenNine  = Color(0xFF0E2415);
  static const Color greenTen   = Color(0xFF071A0D);

  static const Color sandOne   = Color(0xFFEFE7D2);
  static const Color sandTwo   = Color(0xFFDDD0A8);
  static const Color sandThree = Color(0xFFC0A980);

  // Tier 2 — semantic
  static const Color bg         = greenTen;
  static const Color bgAlt      = Color(0xFF0B2013);
  static const Color surface    = Color(0xFF0D2417);
  static const Color surfaceTwo = Color(0xFF13301D);
  static const Color text       = sandOne;
  static const Color textMuted  = sandThree;
  static const Color textFaint  = Color(0xFF8B7B5C);
  static const Color accent     = goldFour;
  static const Color green      = greenThree;
  static const Color border     = Color(0xFF1F4128);
  static const Color borderSub  = Color(0xFF152F1B);

  // Status
  static const Color statusOk   = Color(0xFF4FB870);
  static const Color statusPend = goldFour;
  static const Color statusErr  = Color(0xFFE25D4A);

  // Glows / dim variants (alpha applied)
  static Color accentDim  = goldFour.withValues(alpha: 0.12);
  static Color accentGlow = goldFour.withValues(alpha: 0.22);
  static Color greenDim   = greenFour.withValues(alpha: 0.10);
}
