import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_radius.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_typography.dart';

class ChipBadge extends StatelessWidget {
  const ChipBadge({
    super.key,
    required this.label,
    this.icon = '✦',
  });

  final String label;
  final String icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 5),
      decoration: BoxDecoration(
        color: AppColors.greenNine.withValues(alpha: 0.85),
        border: Border.all(color: AppColors.greenFive.withValues(alpha: 0.4)),
        borderRadius: AppRadius.brPill,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(icon, style: AppTypography.eyebrow()),
          const SizedBox(width: AppSpacing.sp2),
          Text(label.toUpperCase(), style: AppTypography.eyebrow()),
        ],
      ),
    );
  }
}
