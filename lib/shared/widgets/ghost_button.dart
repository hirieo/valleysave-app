import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_radius.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_typography.dart';

class GhostButton extends StatefulWidget {
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
  State<GhostButton> createState() => _GhostButtonState();
}

class _GhostButtonState extends State<GhostButton> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    final fg = widget.foregroundColor ?? AppColors.textMuted;
    final border = widget.borderColor ?? AppColors.border;
    final bg = widget.backgroundColor ?? Colors.transparent;

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
        child: OutlinedButton(
          onPressed: widget.onPressed,
          style: OutlinedButton.styleFrom(
            foregroundColor: fg,
            backgroundColor: bg,
            side: BorderSide(color: border, width: 1.5),
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sp6),
            minimumSize: const Size(0, 52),
            shape: const RoundedRectangleBorder(borderRadius: AppRadius.brPill),
          ),
          child: Text(
            widget.label,
            style: AppTypography.button(color: fg)
                .copyWith(fontWeight: FontWeight.w600),
          ),
        ),
      ),
    );
  }
}
