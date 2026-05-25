import 'package:flutter/material.dart';

import 'app_colors.dart';

/// ValleySave-specific theme tokens that don't fit standard Material ThemeData.
///
/// Access via `Theme.of(context).extension<ValleyThemeExtension>()!`
@immutable
class ValleyThemeExtension extends ThemeExtension<ValleyThemeExtension> {
  const ValleyThemeExtension({
    required this.accent,
    required this.accentDim,
    required this.accentGlow,
    required this.green,
    required this.greenDim,
    required this.surface,
    required this.surfaceTwo,
    required this.border,
    required this.borderSub,
    required this.textFaint,
    required this.statusOk,
    required this.statusPend,
    required this.statusErr,
  });

  final Color accent;
  final Color accentDim;
  final Color accentGlow;
  final Color green;
  final Color greenDim;
  final Color surface;
  final Color surfaceTwo;
  final Color border;
  final Color borderSub;
  final Color textFaint;
  final Color statusOk;
  final Color statusPend;
  final Color statusErr;

  static final ValleyThemeExtension dark = ValleyThemeExtension(
    accent:     AppColors.accent,
    accentDim:  AppColors.accentDim,
    accentGlow: AppColors.accentGlow,
    green:      AppColors.green,
    greenDim:   AppColors.greenDim,
    surface:    AppColors.surface,
    surfaceTwo: AppColors.surfaceTwo,
    border:     AppColors.border,
    borderSub:  AppColors.borderSub,
    textFaint:  AppColors.textFaint,
    statusOk:   AppColors.statusOk,
    statusPend: AppColors.statusPend,
    statusErr:  AppColors.statusErr,
  );

  @override
  ValleyThemeExtension copyWith({
    Color? accent,
    Color? accentDim,
    Color? accentGlow,
    Color? green,
    Color? greenDim,
    Color? surface,
    Color? surfaceTwo,
    Color? border,
    Color? borderSub,
    Color? textFaint,
    Color? statusOk,
    Color? statusPend,
    Color? statusErr,
  }) {
    return ValleyThemeExtension(
      accent:     accent     ?? this.accent,
      accentDim:  accentDim  ?? this.accentDim,
      accentGlow: accentGlow ?? this.accentGlow,
      green:      green      ?? this.green,
      greenDim:   greenDim   ?? this.greenDim,
      surface:    surface    ?? this.surface,
      surfaceTwo: surfaceTwo ?? this.surfaceTwo,
      border:     border     ?? this.border,
      borderSub:  borderSub  ?? this.borderSub,
      textFaint:  textFaint  ?? this.textFaint,
      statusOk:   statusOk   ?? this.statusOk,
      statusPend: statusPend ?? this.statusPend,
      statusErr:  statusErr  ?? this.statusErr,
    );
  }

  @override
  ValleyThemeExtension lerp(ThemeExtension<ValleyThemeExtension>? other, double t) {
    if (other is! ValleyThemeExtension) return this;
    return ValleyThemeExtension(
      accent:     Color.lerp(accent,     other.accent,     t)!,
      accentDim:  Color.lerp(accentDim,  other.accentDim,  t)!,
      accentGlow: Color.lerp(accentGlow, other.accentGlow, t)!,
      green:      Color.lerp(green,      other.green,      t)!,
      greenDim:   Color.lerp(greenDim,   other.greenDim,   t)!,
      surface:    Color.lerp(surface,    other.surface,    t)!,
      surfaceTwo: Color.lerp(surfaceTwo, other.surfaceTwo, t)!,
      border:     Color.lerp(border,     other.border,     t)!,
      borderSub:  Color.lerp(borderSub,  other.borderSub,  t)!,
      textFaint:  Color.lerp(textFaint,  other.textFaint,  t)!,
      statusOk:   Color.lerp(statusOk,   other.statusOk,   t)!,
      statusPend: Color.lerp(statusPend, other.statusPend, t)!,
      statusErr:  Color.lerp(statusErr,  other.statusErr,  t)!,
    );
  }
}
