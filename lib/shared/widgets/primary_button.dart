import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_radius.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_typography.dart';

class PrimaryButton extends StatelessWidget {
  const PrimaryButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.color,
    this.leading,
  });

  final String label;
  final VoidCallback? onPressed;
  final Color? color;
  final Widget? leading;

  @override
  Widget build(BuildContext context) {
    final bg = color ?? AppColors.accent;
    final glowColor = bg.withValues(alpha: 0.35);
    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: AppRadius.brPill,
        boxShadow: [
          BoxShadow(
            color: glowColor,
            blurRadius: 22,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: bg,
          disabledBackgroundColor: bg.withValues(alpha: 0.4),
          foregroundColor: AppColors.greenTen,
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sp8),
          minimumSize: const Size(0, 52),
          shape: const RoundedRectangleBorder(borderRadius: AppRadius.brPill),
          elevation: 0,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (leading != null) ...[
              leading!,
              const SizedBox(width: 8),
            ],
            Text(label, style: AppTypography.button(color: AppColors.greenTen)),
          ],
        ),
      ),
    );
  }
}
