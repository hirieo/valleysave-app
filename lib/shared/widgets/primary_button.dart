import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_radius.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_typography.dart';

class PrimaryButton extends StatefulWidget {
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
  State<PrimaryButton> createState() => _PrimaryButtonState();
}

class _PrimaryButtonState extends State<PrimaryButton> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    final bg = widget.color ?? AppColors.accent;
    final glowColor = bg.withValues(alpha: 0.35);
    return Listener(
      onPointerDown: widget.onPressed != null ? (_) => setState(() => _pressed = true) : null,
      onPointerUp: (_) => setState(() => _pressed = false),
      onPointerCancel: (_) => setState(() => _pressed = false),
      child: AnimatedScale(
        scale: _pressed ? 0.97 : 1.0,
        duration: _pressed
            ? const Duration(milliseconds: 100)
            : const Duration(milliseconds: 200),
        curve: const Cubic(0.23, 1, 0.32, 1),
        child: DecoratedBox(
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
            onPressed: widget.onPressed,
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
                if (widget.leading != null) ...[
                  widget.leading!,
                  const SizedBox(width: 8),
                ],
                Text(widget.label, style: AppTypography.button(color: AppColors.greenTen)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
