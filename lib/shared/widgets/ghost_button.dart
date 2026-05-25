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
  });

  final String label;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: onPressed,
      style: OutlinedButton.styleFrom(
        foregroundColor: AppColors.textMuted,
        side: const BorderSide(color: AppColors.border, width: 1.5),
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sp6),
        minimumSize: const Size(0, 52),
        shape: const RoundedRectangleBorder(borderRadius: AppRadius.brPill),
      ),
      child: Text(
        label,
        style: AppTypography.button(color: AppColors.textMuted)
            .copyWith(fontWeight: FontWeight.w600),
      ),
    );
  }
}
