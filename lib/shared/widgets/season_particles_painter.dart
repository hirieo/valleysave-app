import 'dart:math';
import 'package:flutter/material.dart';
import '../../core/models/season_state.dart';

/// Dibuja las partículas estacionales sobre la capa base.
class SeasonParticlesPainter extends CustomPainter {
  SeasonParticlesPainter({
    required this.season,
    required this.t,
    required this.particles,
  });

  final SeasonState season;
  final double t;
  final List<Particle> particles;

  @override
  void paint(Canvas canvas, Size size) {
    final W = size.width, H = size.height;
    for (final p in particles) {
      updateParticle(p, W, H, t);
      _drawParticle(canvas, p);
    }
  }

  void _drawParticle(Canvas canvas, Particle p) {
    switch (p.type) {
      case ParticleType.petal:
        _drawPetal(canvas, p);
      case ParticleType.rain:
        _drawRain(canvas, p);
      case ParticleType.leaf:
        _drawLeaf(canvas, p);
      case ParticleType.snow:
        _drawSnow(canvas, p);
      case ParticleType.firefly:
        _drawFirefly(canvas, p);
      case ParticleType.pollen:
        _drawPollen(canvas, p);
    }
  }

  void _drawPetal(Canvas canvas, Particle p) {
    canvas.save();
    canvas.translate(p.x, p.y);
    canvas.rotate(p.angle);
    canvas.drawOval(
      Rect.fromCenter(
          center: Offset.zero, width: p.size * 0.76, height: p.size * 2),
      Paint()..color = p.color.withValues(alpha: p.opacity),
    );
    canvas.restore();
  }

  void _drawRain(Canvas canvas, Particle p) {
    canvas.drawLine(
      Offset(p.x, p.y),
      Offset(p.x + p.len * 0.18, p.y + p.len),
      Paint()
        ..color = const Color(0xFF8ab0d0).withValues(alpha: p.opacity)
        ..strokeWidth = 0.6,
    );
  }

  void _drawLeaf(Canvas canvas, Particle p) {
    canvas.save();
    canvas.translate(p.x, p.y);
    canvas.rotate(p.angle);
    final path = Path()
      ..moveTo(0, -p.size)
      ..cubicTo(p.size * .72, -p.size * .4, p.size * .72, p.size * .4, 0,
          p.size * .85)
      ..cubicTo(-p.size * .72, p.size * .4, -p.size * .72, -p.size * .4, 0,
          -p.size);
    canvas.drawPath(path, Paint()..color = p.color.withValues(alpha: p.opacity));
    canvas.drawLine(
      Offset(0, -p.size * .7),
      Offset(0, p.size * .85),
      Paint()
        ..color = Colors.black.withValues(alpha: 0.18)
        ..strokeWidth = 0.7,
    );
    canvas.restore();
  }

  void _drawSnow(Canvas canvas, Particle p) {
    canvas.save();
    canvas.translate(p.x, p.y);
    canvas.rotate(p.angle);
    final paint = Paint()
      ..color = const Color(0xFFe8f4ff).withValues(alpha: p.opacity)
      ..strokeWidth = p.size > 6 ? 1.0 : 0.7;
    for (int i = 0; i < 6; i++) {
      canvas.rotate(pi / 3);
      canvas.drawLine(Offset.zero, Offset(0, p.size), paint);
      if (p.size > 5) {
        canvas.drawLine(
            Offset(0, p.size * .5), Offset(p.size * .3, p.size * .25), paint);
        canvas.drawLine(
            Offset(0, p.size * .5), Offset(-p.size * .3, p.size * .25), paint);
      }
    }
    canvas.restore();
  }

  void _drawFirefly(Canvas canvas, Particle p) {
    final pulse = 0.5 + 0.5 * sin(t * p.pulseSpeed + p.phase);
    final glowR = p.size * 5 * pulse;
    // Glow
    canvas.drawCircle(
      Offset(p.x, p.y),
      glowR,
      Paint()
        ..color = p.color.withValues(alpha: p.opacity * pulse * 0.35)
        ..maskFilter = MaskFilter.blur(BlurStyle.normal, glowR * 0.5),
    );
    // Core
    canvas.drawCircle(
      Offset(p.x, p.y),
      p.size,
      Paint()
        ..color = p.color.withValues(alpha: p.opacity * (0.4 + pulse * 0.6)),
    );
  }

  void _drawPollen(Canvas canvas, Particle p) {
    canvas.drawCircle(
      Offset(p.x, p.y),
      p.size,
      Paint()..color = p.color.withValues(alpha: p.opacity),
    );
  }

  @override
  bool shouldRepaint(SeasonParticlesPainter old) => true;
}

// ─── Particle types ───────────────────────────────────────────────────────────

enum ParticleType { petal, rain, leaf, snow, firefly, pollen }

class Particle {
  Particle({
    required this.type,
    required this.x,
    required this.y,
    required this.color,
    this.vx = 0,
    this.vy = 0,
    this.size = 6,
    this.angle = 0,
    this.rotSpeed = 0,
    this.opacity = 0.8,
    this.drift = 0,
    this.phase = 0,
    this.len = 12,
    this.pulseSpeed = 2,
    this.driftPhase = 0,
  });

  final ParticleType type;
  double x, y, angle;
  final Color color;
  final double vx, vy, size, rotSpeed, opacity, drift, phase, len, pulseSpeed,
      driftPhase;
}

// ─── Update ───────────────────────────────────────────────────────────────────

void updateParticle(Particle p, double W, double H, double t) {
  switch (p.type) {
    case ParticleType.rain:
      p.y += p.vy;
      p.x += 1.8;
      if (p.y > H || p.x > W + 20) {
        p.y = _rand(-60, -5);
        p.x = _rand(-20, W);
      }
    case ParticleType.petal:
      p.angle += p.rotSpeed;
      p.x += p.vx + sin(t * .5 + p.phase) * p.drift * .5;
      p.y += p.vy;
      if (p.y > H + 20) {
        p.y = -20;
        p.x = _rand(0, W);
      }
    case ParticleType.leaf:
      p.angle += p.rotSpeed;
      p.x += p.vx + sin(t * .7 + p.phase) * p.drift;
      p.y += p.vy;
      if (p.y > H + 20 || p.x > W + 30) {
        p.y = _rand(-80, -10);
        p.x = _rand(-30, W * .4);
      }
    case ParticleType.snow:
      p.angle += p.rotSpeed;
      p.x += p.vx + sin(t * .3 + p.phase) * p.drift;
      p.y += p.vy;
      if (p.y > H + 10) {
        p.y = -10;
        p.x = _rand(0, W);
      }
    case ParticleType.firefly:
      p.x += p.vx + sin(t * .6 + p.driftPhase) * p.drift;
      p.y += p.vy;
      if (p.y < -10) {
        p.y = H * .95;
        p.x = _rand(0, W);
      }
      if (p.x < 0) p.x = W;
      if (p.x > W) p.x = 0;
    case ParticleType.pollen:
      p.x += p.vx + sin(t * .4 + p.phase) * .2;
      p.y += p.vy;
      if (p.y < -10) {
        p.y = H;
        p.x = _rand(0, W);
      }
  }
}

// ─── Factory ──────────────────────────────────────────────────────────────────

final _rng = Random();
double _rand(double a, double b) => a + _rng.nextDouble() * (b - a);
Color _pick(List<Color> list) => list[_rng.nextInt(list.length)];

const _petalColors = [
  Color(0xFFffb7c5),
  Color(0xFFffd0dc),
  Color(0xFFffe4ec),
  Color(0xFFff9eb5),
  Color(0xFFfff5f8),
];
const _leafColors = [
  Color(0xFFc8602a),
  Color(0xFFe8783a),
  Color(0xFFd4a030),
  Color(0xFF8b2520),
  Color(0xFFc84818),
  Color(0xFFe8b030),
];
const _fireColors = [
  Color(0xFFffe87a),
  Color(0xFFa8ff78),
  Color(0xFF78ffd6),
  Color(0xFFe8d848),
];

List<Particle> createParticles(SeasonState season, double W, double H) {
  final ps = <Particle>[];
  switch (season) {
    case SeasonState.spring:
      for (int i = 0; i < 55; i++) {
        ps.add(Particle(
          type: ParticleType.petal,
          color: _pick(_petalColors),
          x: _rand(0, W),
          y: _rand(-H, H),
          vx: _rand(-.5, .5),
          vy: _rand(.8, 1.8),
          size: _rand(4, 9),
          rotSpeed: _rand(-.045, .045),
          opacity: _rand(.45, .9),
          drift: _rand(.5, 1.2),
          phase: _rand(0, 2 * pi),
        ));
      }
      for (int i = 0; i < 130; i++) {
        ps.add(Particle(
          type: ParticleType.rain,
          color: Colors.transparent,
          x: _rand(0, W),
          y: _rand(-H, H),
          vy: _rand(10, 18),
          len: _rand(8, 18),
          opacity: _rand(.05, .18),
        ));
      }
    case SeasonState.summer:
      for (int i = 0; i < 48; i++) {
        ps.add(Particle(
          type: ParticleType.firefly,
          color: _pick(_fireColors),
          x: _rand(0, W),
          y: _rand(H * .2, H * .95),
          vx: _rand(-.3, .3),
          vy: _rand(-.5, -.2),
          size: _rand(2, 4.5),
          opacity: _rand(.7, 1),
          phase: _rand(0, 2 * pi),
          pulseSpeed: _rand(1.5, 3.5),
          drift: _rand(.2, .6),
          driftPhase: _rand(0, 2 * pi),
        ));
      }
      for (int i = 0; i < 70; i++) {
        ps.add(Particle(
          type: ParticleType.pollen,
          color: _rng.nextBool()
              ? const Color(0xFFf8f0b0)
              : const Color(0xFFd8f0a0),
          x: _rand(0, W),
          y: _rand(0, H),
          vx: _rand(-.15, .15),
          vy: _rand(-.4, -.1),
          size: _rand(1.2, 2.8),
          opacity: _rand(.2, .55),
          phase: _rand(0, 2 * pi),
        ));
      }
    case SeasonState.fall:
      for (int i = 0; i < 68; i++) {
        ps.add(Particle(
          type: ParticleType.leaf,
          color: _pick(_leafColors),
          x: _rand(-20, W + 20),
          y: _rand(-H, H * .5),
          vx: _rand(1.5, 4.5),
          vy: _rand(.8, 2.5),
          size: _rand(5, 14),
          rotSpeed: _rand(-.07, .07),
          opacity: _rand(.55, .92),
          drift: _rand(.8, 2.2),
          phase: _rand(0, 2 * pi),
        ));
      }
    case SeasonState.winter:
      for (int i = 0; i < 110; i++) {
        final big = _rng.nextDouble() > 0.65;
        ps.add(Particle(
          type: ParticleType.snow,
          color: Colors.transparent,
          x: _rand(0, W),
          y: _rand(-H, H),
          vx: _rand(-.3, .3),
          vy: _rand(big ? .8 : .3, big ? 1.8 : .9),
          size: _rand(big ? 5 : 1.5, big ? 11 : 4),
          rotSpeed: _rand(-.02, .02),
          opacity: _rand(.4, big ? .9 : .6),
          drift: _rand(.2, .7),
          phase: _rand(0, 2 * pi),
        ));
      }
    case SeasonState.initial:
      // Estado inicial: sin partículas — solo la capa base
      break;
  }
  return ps;
}
