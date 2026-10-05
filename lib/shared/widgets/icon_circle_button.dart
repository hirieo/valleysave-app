import 'dart:math' as math;
import 'package:flutter/material.dart';

import '../../core/services/gamepad_service.dart';
import '../../core/theme/app_colors.dart';

class IconCircleButton extends StatefulWidget {
  const IconCircleButton({
    super.key,
    required this.icon,
    required this.onTap,
    this.spinning = false,
    this.tooltip,
    this.color,
    this.gamepadKey,
  });
  final IconData icon;
  final VoidCallback onTap;
  final bool spinning;
  final String? tooltip;
  final Color? color;

  /// Nombre estable para que LB/RB/View/Start puedan enfocar o activar este
  /// botón directamente desde `GamepadService`, sin depender del foco
  /// actual — ver `GamepadService.kTopbar*`. `null` = no se registra, sigue
  /// siendo alcanzable con D-pad/stick como cualquier otro control.
  final String? gamepadKey;

  @override
  State<IconCircleButton> createState() => _IconCircleButtonState();
}

class _IconCircleButtonState extends State<IconCircleButton>
    with SingleTickerProviderStateMixin {
  bool _pressed = false;
  bool _hovered = false;
  bool _focused = false;
  late final AnimationController _spin;
  late final _focusNode = FocusNode(
    debugLabel: 'IconCircleButton${widget.gamepadKey != null ? ':${widget.gamepadKey}' : ''}',
  );

  @override
  void initState() {
    super.initState();
    _spin = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );
    if (widget.spinning) _spin.repeat();
    _registerGamepadTarget();
  }

  @override
  void didUpdateWidget(IconCircleButton old) {
    super.didUpdateWidget(old);
    if (widget.spinning && !old.spinning) {
      _spin.repeat();
    } else if (!widget.spinning && old.spinning) {
      _spin.stop();
      _spin.value = 0;
    }
    if (old.gamepadKey != null && old.gamepadKey != widget.gamepadKey) {
      GamepadService.instance.unregisterTarget(old.gamepadKey!);
    }
    _registerGamepadTarget();
  }

  void _registerGamepadTarget() {
    final key = widget.gamepadKey;
    if (key == null) return;
    GamepadService.instance.registerTarget(
      key,
      focusNode: _focusNode,
      onTap: widget.onTap,
    );
  }

  @override
  void dispose() {
    _spin.dispose();
    _focusNode.dispose();
    if (widget.gamepadKey != null) {
      GamepadService.instance.unregisterTarget(widget.gamepadKey!);
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final baseColor = widget.color ?? Colors.white;
    final borderColor = baseColor.withValues(
      alpha: widget.color != null
          ? (_hovered ? 0.85 : 0.55)
          : (_hovered ? 0.7 : 0.45),
    );
    final iconColor = widget.color != null
        ? widget.color!
        : Colors.white.withValues(alpha: 0.88);

    Widget button = FocusableActionDetector(
      focusNode: _focusNode,
      onShowFocusHighlight: (v) => setState(() => _focused = v),
      onShowHoverHighlight: (v) => setState(() => _hovered = v),
      mouseCursor: SystemMouseCursors.click,
      actions: {
        ActivateIntent: CallbackAction<ActivateIntent>(
          onInvoke: (_) => widget.onTap(),
        ),
      },
      child: GestureDetector(
        onTap: widget.onTap,
        onTapDown: (_) => setState(() => _pressed = true),
        onTapUp: (_) => setState(() => _pressed = false),
        onTapCancel: () => setState(() => _pressed = false),
        child: AnimatedScale(
          scale: _pressed ? 0.90 : (_hovered ? 1.06 : 1.0),
          duration: _pressed
              ? const Duration(milliseconds: 100)
              : const Duration(milliseconds: 160),
          curve: const Cubic(0.23, 1, 0.32, 1),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 140),
            curve: Curves.easeOut,
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: _hovered
                  ? baseColor.withValues(alpha: 0.08)
                  : Colors.transparent,
              shape: BoxShape.circle,
              border: Border.all(
                color: _focused ? AppColors.accent : borderColor,
                width: _focused ? 1.6 : 1.0,
              ),
              boxShadow: _focused
                  ? [
                      BoxShadow(
                        color: AppColors.accentGlow,
                        blurRadius: 12,
                        spreadRadius: 1,
                      ),
                    ]
                  : null,
            ),
            child: AnimatedBuilder(
              animation: _spin,
              builder: (_, child) => Transform.rotate(
                angle: widget.spinning ? _spin.value * 2 * math.pi : 0,
                child: child,
              ),
              child: Icon(widget.icon, size: 18, color: iconColor),
            ),
          ),
        ),
      ),
    );

    if (widget.tooltip != null) {
      button = Tooltip(
        message: widget.tooltip!,
        preferBelow: false,
        child: button,
      );
    }

    return button;
  }
}
