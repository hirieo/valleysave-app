import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../../core/models/season_state.dart';
import '../../core/services/season_controller.dart';

Color _seasonAccent(SeasonState s) => switch (s) {
  SeasonState.spring  => const Color(0xFFE8608A),
  SeasonState.summer  => const Color(0xFFF5A623),
  SeasonState.fall    => const Color(0xFFD4722A),
  SeasonState.winter  => const Color(0xFF3A9BE3),
  SeasonState.initial => const Color(0xFF4A6FA5),
};

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
    return ValueListenableBuilder<SeasonState>(
      valueListenable: SeasonController.instance.season,
      builder: (_, season, _) {
        final acc = _seasonAccent(season);
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
                color: acc.withValues(alpha: 0.18),
                shape: BoxShape.circle,
                border: Border.all(color: acc.withValues(alpha: 0.42)),
              ),
              child: AnimatedBuilder(
                animation: _spin,
                builder: (_, child) => Transform.rotate(
                  angle: widget.spinning ? _spin.value * 2 * math.pi : 0,
                  child: child,
                ),
                child: Icon(widget.icon, size: 18, color: acc.withValues(alpha: 0.85)),
              ),
            ),
          ),
        );
      },
    );
  }
}
