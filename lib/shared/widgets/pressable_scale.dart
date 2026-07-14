import 'package:flutter/material.dart';

/// Feedback de presión reutilizable para controles que antes eran estáticos.
///
/// No sustituye animaciones existentes: se aplica únicamente a superficies
/// que no tenían respuesta al pulsar. Respeta la preferencia del sistema de
/// reducir animaciones.
class PressableScale extends StatefulWidget {
  const PressableScale({
    super.key,
    required this.onTap,
    required this.child,
    this.pressedScale = 0.97,
    this.behavior = HitTestBehavior.opaque,
    this.semanticLabel,
  });

  final VoidCallback? onTap;
  final Widget child;
  final double pressedScale;
  final HitTestBehavior behavior;
  final String? semanticLabel;

  @override
  State<PressableScale> createState() => _PressableScaleState();
}

class _PressableScaleState extends State<PressableScale> {
  bool _pressed = false;

  void _setPressed(bool value) {
    if (_pressed == value || widget.onTap == null) return;
    setState(() => _pressed = value);
  }

  @override
  Widget build(BuildContext context) {
    final reduceMotion =
        MediaQuery.maybeOf(context)?.disableAnimations ?? false;
    final enabled = widget.onTap != null;
    final content = GestureDetector(
      behavior: widget.behavior,
      onTap: widget.onTap,
      onTapDown: enabled ? (_) => _setPressed(true) : null,
      onTapUp: enabled ? (_) => _setPressed(false) : null,
      onTapCancel: enabled ? () => _setPressed(false) : null,
      child: AnimatedScale(
        scale: enabled && _pressed ? widget.pressedScale : 1,
        duration: reduceMotion
            ? Duration.zero
            : const Duration(milliseconds: 120),
        curve: const Cubic(0.23, 1, 0.32, 1),
        child: widget.child,
      ),
    );

    if (widget.semanticLabel == null) return content;
    return Semantics(
      button: true,
      enabled: enabled,
      label: widget.semanticLabel,
      child: ExcludeSemantics(child: content),
    );
  }
}
