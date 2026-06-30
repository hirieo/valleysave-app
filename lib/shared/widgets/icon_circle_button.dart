import 'dart:math' as math;
import 'package:flutter/material.dart';

class IconCircleButton extends StatefulWidget {
  const IconCircleButton({
    super.key,
    required this.icon,
    required this.onTap,
    this.spinning = false,
  });
  final IconData icon;
  final VoidCallback onTap;
  final bool spinning;

  @override
  State<IconCircleButton> createState() => _IconCircleButtonState();
}

class _IconCircleButtonState extends State<IconCircleButton>
    with SingleTickerProviderStateMixin {
  bool _pressed = false;
  late final AnimationController _spin;

  @override
  void initState() {
    super.initState();
    _spin = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );
    if (widget.spinning) _spin.repeat();
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
  }

  @override
  void dispose() {
    _spin.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      onTapDown: (_) => setState(() => _pressed = true),
      onTapUp: (_) => setState(() => _pressed = false),
      onTapCancel: () => setState(() => _pressed = false),
      child: AnimatedScale(
        scale: _pressed ? 0.90 : 1.0,
        duration: _pressed
            ? const Duration(milliseconds: 100)
            : const Duration(milliseconds: 200),
        curve: const Cubic(0.23, 1, 0.32, 1),
        child: Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            color: Colors.transparent,
            shape: BoxShape.circle,
            border: Border.all(color: Colors.white.withValues(alpha: 0.45), width: 1.0),
          ),
          child: AnimatedBuilder(
            animation: _spin,
            builder: (_, child) => Transform.rotate(
              angle: widget.spinning ? _spin.value * 2 * math.pi : 0,
              child: child,
            ),
            child: Icon(widget.icon, size: 18, color: Colors.white.withValues(alpha: 0.88)),
          ),
        ),
      ),
    );
  }
}
