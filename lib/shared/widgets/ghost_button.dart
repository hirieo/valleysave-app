import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_radius.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_typography.dart';

class GhostButton extends StatelessWidget {
  const GhostButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.foregroundColor,
    this.borderColor,
    this.backgroundColor,
  });

  final String label;
  final VoidCallback? onPressed;
  final Color? foregroundColor;
  final Color? borderColor;
  final Color? backgroundColor;

  @override
  Widget build(BuildContext context) {
    final fg = foregroundColor ?? AppColors.textMuted;
    final border = borderColor ?? AppColors.border;
    final bg = backgroundColor ?? Colors.transparent;

    return OutlinedButton(
      onPressed: onPressed,
      style: OutlinedButton.styleFrom(
        foregroundColor: fg,
        backgroundColor: bg,
        side: BorderSide(color: border, width: 1.5),
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sp6),
        minimumSize: const Size(0, 52),
        shape: const RoundedRectangleBorder(borderRadius: AppRadius.brPill),
      ),
      child: Text(
        label,
        style: AppTypography.button(color: fg)
            .copyWith(fontWeight: FontWeight.w600),
      ),
    );
  }
}
