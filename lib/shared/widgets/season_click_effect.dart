import 'dart:math';
import 'package:flutter/material.dart';
import '../../core/models/season_state.dart';

class SeasonClickEffect extends StatefulWidget {
  const SeasonClickEffect({
    super.key,
    required this.child,
    required this.season,
  });

  final Widget child;
  final SeasonState season;

  @override
  State<SeasonClickEffect> createState() => _SeasonClickEffectState();
}

class _SeasonClickEffectState extends State<SeasonClickEffect>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  Offset _tapPos = Offset.zero;
  List<_Particle> _particles = [];

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 5000),
    )..addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Listener(
          onPointerDown: (PointerDownEvent e) {
            setState(() {
              _tapPos = e.localPosition;
              _particles = _buildParticles(widget.season, _tapPos);
            });
            _ctrl.forward(from: 0);
          },
          behavior: HitTestBehavior.deferToChild,
          child: widget.child,
        ),
        if (_ctrl.isAnimating || _ctrl.value > 0)
          Positioned.fill(
            child: IgnorePointer(
              child: CustomPaint(
                painter: _BurstPainter(
                  particles: _particles,
                  progress: _ctrl.value,
                ),
              ),
            ),
          ),
      ],
    );
  }
}

// ── Particle model ──────────────────────────────────────────────────────────

enum _Shape { star, petal, drop, leaf, snowflake }

class _Particle {
  const _Particle({
    required this.start,
    required this.vx,
    required this.vy,
    required this.size,
    required this.color,
    required this.angle,
    required this.rotSpeed,
    required this.shape,
  });

  final Offset start;
  final double vx, vy, size, angle, rotSpeed;
  final Color color;
  final _Shape shape;
}

List<_Particle> _buildParticles(SeasonState season, Offset origin) {
  final rng = Random();
  const count = 35;
  final list = <_Particle>[];

  for (int i = 0; i < count; i++) {
    final a = (i / count) * 2 * pi + rng.nextDouble() * 0.6;
    final spd = 80.0 + rng.nextDouble() * 120.0;

    switch (season) {
      case SeasonState.initial:
        list.add(_Particle(
          start: origin,
          vx: cos(a) * spd,
          vy: sin(a) * spd,
          size: 12 + rng.nextDouble() * 14,
          color: rng.nextBool()
              ? const Color(0xFFFFD060)
              : const Color(0xFF90d8c0),
          angle: a,
          rotSpeed: (rng.nextDouble() - 0.5) * 4,
          shape: _Shape.star,
        ));

      case SeasonState.spring:
        list.add(_Particle(
          start: origin,
          vx: cos(a) * spd * 0.8,
          vy: sin(a) * spd * 0.8 - 25,
          size: 14 + rng.nextDouble() * 16,
          color: Color.fromRGBO(
            245, 150 + rng.nextInt(50), 170 + rng.nextInt(40), 1),
          angle: a,
          rotSpeed: (rng.nextDouble() - 0.5) * 4,
          shape: _Shape.petal,
        ));

      case SeasonState.summer:
        list.add(_Particle(
          start: origin,
          vx: cos(a) * spd,
          vy: sin(a) * spd,
          size: 10 + rng.nextDouble() * 14,
          color: Color.fromRGBO(
            60 + rng.nextInt(60), 160 + rng.nextInt(60), 220 + rng.nextInt(35), 1),
          angle: a,
          rotSpeed: 0,
          shape: _Shape.drop,
        ));

      case SeasonState.fall:
        list.add(_Particle(
          start: origin,
          vx: cos(a) * spd * 0.7 + (rng.nextDouble() - 0.5) * 30,
          vy: sin(a) * spd * 0.6,
          size: 14 + rng.nextDouble() * 16,
          color: [
            const Color(0xFFc8602a),
            const Color(0xFFe8783a),
            const Color(0xFFd4a030),
            const Color(0xFF9b3520),
          ][rng.nextInt(4)],
          angle: a,
          rotSpeed: (rng.nextDouble() - 0.5) * 5,
          shape: _Shape.leaf,
        ));

      case SeasonState.winter:
        list.add(_Particle(
          start: origin,
          vx: cos(a) * spd * 0.45,
          vy: sin(a) * spd * 0.45 - 15,
          size: 13 + rng.nextDouble() * 15,
          color: Color.fromRGBO(
            210 + rng.nextInt(45), 230 + rng.nextInt(25), 252, 1),
          angle: rng.nextDouble() * pi,
          rotSpeed: (rng.nextDouble() - 0.5) * 1.0,
          shape: _Shape.snowflake,
        ));
    }
  }
  return list;
}

// ── Painter ─────────────────────────────────────────────────────────────────

class _BurstPainter extends CustomPainter {
  const _BurstPainter({required this.particles, required this.progress});

  final List<_Particle> particles;
  final double progress;

  static const _gravity = 55.0;

  @override
  void paint(Canvas canvas, Size size) {
    final t = progress * 1.2;
    final fadeProgress = progress < 0.60 ? 0.0 : (progress - 0.60) / 0.40;
    final fade = 1.0 - Curves.easeIn.transform(fadeProgress);

    for (final p in particles) {
      final alpha = (fade * 255).clamp(0, 255).toInt();
      if (alpha <= 0) continue;

      final x = p.start.dx + p.vx * t;
      final y = p.start.dy + p.vy * t + 0.5 * _gravity * t * t;
      final rot = p.angle + p.rotSpeed * t;

      final paint = Paint()..color = p.color.withAlpha(alpha);

      canvas.save();
      canvas.translate(x, y);
      canvas.rotate(rot);
      _draw(canvas, paint, p.shape, p.size, alpha);
      canvas.restore();
    }
  }

  void _draw(Canvas canvas, Paint paint, _Shape shape, double s, int alpha) {
    switch (shape) {
      case _Shape.star:
        final path = Path();
        for (int i = 0; i < 6; i++) {
          final a = i / 6 * 2 * pi;
          final b = a + pi / 6;
          final op = Offset(cos(a) * s, sin(a) * s);
          final ip = Offset(cos(b) * s * 0.38, sin(b) * s * 0.38);
          i == 0 ? path.moveTo(op.dx, op.dy) : path.lineTo(op.dx, op.dy);
          path.lineTo(ip.dx, ip.dy);
        }
        path.close();
        canvas.drawPath(path, paint);

      case _Shape.petal:
        final petalPath = Path()
          ..moveTo(0, s * 0.9)
          ..cubicTo(-s * 0.7, s * 0.4, -s * 0.85, -s * 0.2, -s * 0.5, -s * 0.6)
          ..cubicTo(-s * 0.25, -s * 0.85, -s * 0.08, -s * 0.75, 0, -s * 0.65)
          ..cubicTo(s * 0.08, -s * 0.75, s * 0.25, -s * 0.85, s * 0.5, -s * 0.6)
          ..cubicTo(s * 0.85, -s * 0.2, s * 0.7, s * 0.4, 0, s * 0.9)
          ..close();
        canvas.drawPath(petalPath, paint);

      case _Shape.drop:
        final path = Path()
          ..moveTo(0, -s)
          ..cubicTo(s * 0.6, -s * 0.3, s * 0.6, s * 0.5, 0, s)
          ..cubicTo(-s * 0.6, s * 0.5, -s * 0.6, -s * 0.3, 0, -s);
        canvas.drawPath(path, paint);

      case _Shape.leaf:
        final path = Path()
          ..moveTo(0, -s)
          ..cubicTo(s * 0.7, -s * 0.4, s * 0.7, s * 0.4, 0, s * 0.85)
          ..cubicTo(-s * 0.7, s * 0.4, -s * 0.7, -s * 0.4, 0, -s);
        canvas.drawPath(path, paint);

      case _Shape.snowflake:
        paint
          ..style = PaintingStyle.stroke
          ..strokeWidth = s > 8 ? 1.5 : 1.0
          ..strokeCap = StrokeCap.round;
        for (int i = 0; i < 6; i++) {
          canvas.rotate(pi / 3);
          canvas.drawLine(Offset.zero, Offset(0, s), paint);
          if (s > 6) {
            canvas.drawLine(
              Offset(0, s * 0.5), Offset(s * 0.3, s * 0.25), paint);
            canvas.drawLine(
              Offset(0, s * 0.5), Offset(-s * 0.3, s * 0.25), paint);
          }
        }
        paint.style = PaintingStyle.fill;
    }
  }

  @override
  bool shouldRepaint(_BurstPainter old) => old.progress != progress;
}
