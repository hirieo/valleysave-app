import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../../core/models/season_state.dart';

Color _busyColor(SeasonState s) => switch (s) {
  SeasonState.spring  => const Color(0xFFE8608A),
  SeasonState.summer  => const Color(0xFFF5A623),
  SeasonState.fall    => const Color(0xFFD4722A),
  SeasonState.winter  => const Color(0xFF3A9BE3),
  SeasonState.initial => const Color(0xFF4A6FA5),
};

class SaveBusyIndicator extends StatefulWidget {
  const SaveBusyIndicator({super.key, required this.season, this.size = 20});
  final SeasonState season;
  final double size;

  @override
  State<SaveBusyIndicator> createState() => _SaveBusyIndicatorState();
}

class _SaveBusyIndicatorState extends State<SaveBusyIndicator>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 12),
    )..repeat();
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _ctrl,
      builder: (_, _) => CustomPaint(
        size: Size(widget.size, widget.size),
        painter: _BusyPainter(
          season: widget.season,
          t: _ctrl.value * math.pi * 2 * 12,
        ),
      ),
    );
  }
}

class _BusyPainter extends CustomPainter {
  const _BusyPainter({required this.season, required this.t});
  final SeasonState season;
  final double t;

  @override
  void paint(Canvas canvas, Size size) {
    final cx = size.width / 2;
    final cy = size.height / 2;
    final r  = size.width * 0.34;
    final color = _busyColor(season);

    // anillo sutil
    canvas.drawCircle(
      Offset(cx, cy), r,
      Paint()
        ..color = color.withValues(alpha: 0.15)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.2,
    );

    // 3 partículas orbitando
    const offsets = [0.0, math.pi * 2 / 3, math.pi * 4 / 3];
    for (var i = 0; i < 3; i++) {
      final a     = t * 0.85 + offsets[i];
      final orbit = r + math.sin(t * 1.3 + i) * (size.width * 0.07);
      final px    = cx + math.cos(a) * orbit;
      final py    = cy + math.sin(a) * orbit;
      final pulse = 0.40 + 0.60 * ((math.sin(t * 3.0 + i * 1.4) + 1) / 2);

      canvas.save();
      switch (season) {
        case SeasonState.initial:
          _star(canvas, Offset(px, py), 4.2, 1.8, t * 0.3 + offsets[i], color, pulse);
        case SeasonState.spring:
          _petal(canvas, Offset(px, py), a + t * 0.5, color, pulse);
        case SeasonState.summer:
          _firefly(canvas, Offset(px, py), color, pulse);
        case SeasonState.fall:
          _leaf(canvas, Offset(px, py), a + t * 0.6, color, pulse);
        case SeasonState.winter:
          _snowflake(canvas, Offset(px, py), color, pulse);
      }
      canvas.restore();
    }
  }

  // ── partículas ──────────────────────────────────────────────

  void _star(Canvas canvas, Offset pos, double outer, double inner,
      double rot, Color color, double alpha) {
    final path = Path();
    for (var i = 0; i < 10; i++) {
      final a = rot + (i * math.pi / 5) - math.pi / 2;
      final r = i.isEven ? outer : inner;
      final x = pos.dx + math.cos(a) * r;
      final y = pos.dy + math.sin(a) * r;
      i == 0 ? path.moveTo(x, y) : path.lineTo(x, y);
    }
    path.close();
    canvas.drawPath(
      path,
      Paint()..color = _busyColor(season).withValues(alpha: alpha),
    );
  }

  void _petal(Canvas canvas, Offset pos, double angle, Color color, double alpha) {
    canvas.translate(pos.dx, pos.dy);
    canvas.rotate(angle);
    final path = Path()
      ..moveTo(0, -3.5)
      ..cubicTo(2.5, -2, 2.5, 2, 0, 3.5)
      ..cubicTo(-2.5, 2, -2.5, -2, 0, -3.5);
    canvas.drawPath(path, Paint()..color = color.withValues(alpha: alpha));
  }

  void _firefly(Canvas canvas, Offset pos, Color color, double alpha) {
    // halo difuso
    canvas.drawCircle(pos, 5.0,
        Paint()..color = color.withValues(alpha: alpha * 0.20));
    canvas.drawCircle(pos, 2.8,
        Paint()..color = color.withValues(alpha: alpha * 0.55));
    // núcleo
    canvas.drawCircle(pos, 1.5,
        Paint()..color = color.withValues(alpha: alpha));
    // brillo blanco
    canvas.drawCircle(
      Offset(pos.dx - 0.5, pos.dy - 0.5), 0.6,
      Paint()..color = Colors.white.withValues(alpha: alpha * 0.65),
    );
  }

  void _leaf(Canvas canvas, Offset pos, double angle, Color color, double alpha) {
    canvas.translate(pos.dx, pos.dy);
    canvas.rotate(angle);
    canvas.drawOval(
      Rect.fromCenter(center: Offset.zero, width: 8, height: 4.5),
      Paint()..color = color.withValues(alpha: alpha),
    );
    canvas.drawOval(
      Rect.fromCenter(center: const Offset(0.8, 0), width: 5, height: 3),
      Paint()..color = color.withValues(alpha: alpha * 0.65),
    );
  }

  void _snowflake(Canvas canvas, Offset pos, Color color, double alpha) {
    final paint = Paint()
      ..color       = color.withValues(alpha: alpha * 0.85)
      ..strokeWidth = 1.1
      ..strokeCap   = StrokeCap.round;
    for (var k = 0; k < 3; k++) {
      final ka = k * math.pi / 3 + t * 0.4;
      canvas.drawLine(
        Offset(pos.dx - math.cos(ka) * 3.5, pos.dy - math.sin(ka) * 3.5),
        Offset(pos.dx + math.cos(ka) * 3.5, pos.dy + math.sin(ka) * 3.5),
        paint,
      );
    }
    canvas.drawCircle(pos, 1.2,
        Paint()..color = color.withValues(alpha: alpha));
  }

  @override
  bool shouldRepaint(_BusyPainter old) => true;
}
