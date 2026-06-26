import 'dart:math';
import 'package:flutter/material.dart';
import '../../core/models/season_state.dart';

/// Dibuja la capa base del valle: cielo, estrellas, montañas y colinas.
class ValleyBasePainter extends CustomPainter {
  ValleyBasePainter({
    required this.season,
    required this.t,
    required this.stars,
    required this.clouds,
  });

  final SeasonState season;
  final double t;
  final List<ValleyStar> stars;
  final List<ValleyCloud> clouds;

  @override
  void paint(Canvas canvas, Size size) {
    final d = SeasonData.data[season]!;
    final W = size.width, H = size.height;

    _drawSky(canvas, size, d);
    _drawStars(canvas, W, H, d, t);

    if (season == SeasonState.summer) {
      _drawMoon(canvas, W, H, t, d.accentColor);
    }
    if (season == SeasonState.fall) {
      _drawFallMoon(canvas, W, H);
    }

    if (season == SeasonState.initial) {
      _drawShootingStar(canvas, W, H, t);
      _drawTwilightGlow(canvas, W, H);
    }

    _drawMountains(canvas, W, H, d);

    _drawClouds(canvas, W, H, t);

    _drawHills(canvas, W, H, d);

    if (season == SeasonState.spring) {
      _drawSpringGlow(canvas, W, H);
    }
  }

  // ── Sky ───────────────────────────────────────────────────────────────────

  void _drawSky(Canvas canvas, Size size, SeasonData d) {
    final List<Color> colors;
    final List<double> stops;

    if (season == SeasonState.initial) {
      colors = const [
        Color(0xFF093375), // noche profunda
        Color(0xFF1970C2), // cobalto vibrante
        Color(0xFF2E9DE6), // cerúleo
        Color(0xFF55C5F0), // cian brillante
        Color(0xFF7DF1E1), // aguamarina horizonte
      ];
      stops = const [0.0, 0.25, 0.50, 0.75, 1.0];
    } else {
      colors = [d.skyTop, d.skyMid, d.skyBottom];
      stops = const [0.0, 0.50, 1.0];
    }

    final paint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: colors,
        stops: stops,
      ).createShader(Offset.zero & size);
    canvas.drawRect(Offset.zero & size, paint);
  }

  // ── Stars ─────────────────────────────────────────────────────────────────

  void _drawStars(Canvas canvas, double W, double H, SeasonData d, double t) {
    final paint = Paint();
    for (final s in stars) {
      final twinkle = 0.05 + 0.95 * ((sin(t * s.speed + s.phase) + 1) / 2);
      final alpha = (d.starOpacity * twinkle * s.baseOpacity).clamp(0.0, 1.0);
      final r = s.radius * (0.65 + 0.35 * twinkle);
      final cx = s.xFrac * W;
      final cy = s.yFrac * H * 0.62;

      // Glow halo — solo en inicial, estrellas brillantes
      if (season == SeasonState.initial && alpha > 0.45 && r > 0.9) {
        final glowPaint = Paint()
          ..shader = RadialGradient(
            colors: [
              const Color(0xFFC8E6FF).withValues(alpha: alpha * 0.38),
              Colors.transparent,
            ],
          ).createShader(Rect.fromCircle(center: Offset(cx, cy), radius: r * 5.5 * twinkle));
        canvas.drawCircle(Offset(cx, cy), r * 5.5 * twinkle, glowPaint);
      }

      // Core dot
      paint.color = Colors.white.withValues(alpha: alpha);
      canvas.drawCircle(Offset(cx, cy), r, paint);

      // Sparkle arms on bright stars
      if (s.hasCross && r > 1.0 && alpha > 0.50) {
        final armPaint = Paint()
          ..color = Colors.white.withValues(alpha: alpha * 0.55)
          ..strokeWidth = r * 0.22
          ..strokeCap = StrokeCap.round;
        final armLen = r * 3.5;
        canvas.save();
        canvas.translate(cx, cy);
        // two passes: 0° and 45°
        canvas.drawLine(Offset(0, -armLen), Offset(0, armLen), armPaint);
        canvas.drawLine(Offset(-armLen, 0), Offset(armLen, 0), armPaint);
        canvas.rotate(pi / 4);
        canvas.drawLine(
            Offset(0, -armLen * 0.65), Offset(0, armLen * 0.65), armPaint);
        canvas.drawLine(
            Offset(-armLen * 0.65, 0), Offset(armLen * 0.65, 0), armPaint);
        canvas.restore();
      }
    }
  }

  // ── Moon ──────────────────────────────────────────────────────────────────

  void _drawMoon(Canvas canvas, double W, double H, double t, Color accent) {
    final cx = W * 0.82, cy = H * 0.14;
    final r = (W < H ? W : H) * 0.06;
    final pulse = 0.95 + 0.05 * sin(t * 0.4);
    // Halo
    final haloPaint = Paint()
      ..shader = RadialGradient(
        colors: [accent.withValues(alpha: 0.12), Colors.transparent],
      ).createShader(
          Rect.fromCircle(center: Offset(cx, cy), radius: r * 3.5 * pulse));
    canvas.drawCircle(Offset(cx, cy), r * 3.5 * pulse, haloPaint);
    // Core
    final moonPaint = Paint()
      ..shader = RadialGradient(
        center: const Alignment(-0.3, -0.3),
        colors: [
          Colors.white.withValues(alpha: 0.9),
          accent.withValues(alpha: 0.75),
        ],
      ).createShader(Rect.fromCircle(center: Offset(cx, cy), radius: r));
    canvas.drawCircle(Offset(cx, cy), r, moonPaint);
  }

  void _drawFallMoon(Canvas canvas, double W, double H) {
    final cx = W * 0.88, cy = H * 0.12;
    const mr = 22.0;
    canvas.drawCircle(
      Offset(cx, cy),
      mr + 18,
      Paint()
        ..color = const Color(0xFFe8d060).withValues(alpha: 0.15)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 18),
    );
    final moonPaint = Paint()
      ..shader = RadialGradient(
        center: const Alignment(-0.25, -0.25),
        colors: [const Color(0xFFfff8d8), const Color(0xFFe8d870)],
      ).createShader(Rect.fromCircle(center: Offset(cx, cy), radius: mr));
    canvas.drawCircle(Offset(cx, cy), mr, moonPaint);
  }

  // ── Shooting star ─────────────────────────────────────────────────────────

  void _drawShootingStar(Canvas canvas, double W, double H, double t) {
    const period = 13.0;
    const visible = 2.5;
    final cycle = t % period;
    if (cycle > visible) return;
    final progress = cycle / visible;
    final cycleIdx = (t / period).floor();
    final startX = W * (0.08 + (cycleIdx * 0.4273 % 1.0) * 0.55);
    final startY = H * (0.04 + (cycleIdx * 0.6719 % 1.0) * 0.18);
    final endX = startX + W * 0.28;
    final endY = startY + H * 0.13;
    final cx = startX + (endX - startX) * progress;
    final cy = startY + (endY - startY) * progress;
    final alpha = (progress < 0.12
            ? progress / 0.12
            : progress > 0.75
                ? (1.0 - progress) / 0.25
                : 1.0)
        .clamp(0.0, 1.0);
    final tailProgress = (progress - 0.25).clamp(0.0, 1.0);
    final tailX = startX + (endX - startX) * tailProgress;
    final tailY = startY + (endY - startY) * tailProgress;
    canvas.drawLine(
      Offset(tailX, tailY),
      Offset(cx, cy),
      Paint()
        ..shader = LinearGradient(
          colors: [
            Colors.white.withValues(alpha: 0.0),
            Colors.white.withValues(alpha: alpha * 0.75),
          ],
        ).createShader(Rect.fromPoints(Offset(tailX, tailY), Offset(cx, cy)))
        ..strokeWidth = 1.2
        ..strokeCap = StrokeCap.round
        ..style = PaintingStyle.stroke,
    );
    canvas.drawCircle(
      Offset(cx, cy),
      1.4,
      Paint()..color = Colors.white.withValues(alpha: alpha * 0.95),
    );
  }

  // ── Twilight horizon glow ─────────────────────────────────────────────────

  void _drawTwilightGlow(Canvas canvas, double W, double H) {
    // Franja cálida muy sutil en el horizonte — da sensación de crepúsculo
    final warmGlow = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          Colors.transparent,
          const Color(0xFFa06820).withValues(alpha: 0.10),
          const Color(0xFF6040a0).withValues(alpha: 0.08),
        ],
        stops: const [0.55, 0.80, 1.0],
      ).createShader(Offset.zero & Size(W, H));
    canvas.drawRect(Offset.zero & Size(W, H), warmGlow);
  }

  // ── Mountains ─────────────────────────────────────────────────────────────

  void _drawMountains(Canvas canvas, double W, double H, SeasonData d) {
    _drawMountainLayer(
        canvas, W, H, d.mountainFar.withValues(alpha: 0.82), 0.53, 0.058, 0.032, 2.6, 0.5);
    _drawMountainLayer(
        canvas, W, H, d.mountainNear.withValues(alpha: 0.90), 0.58, 0.068, 0.040, 2.0, 1.8);
  }

  void _drawMountainLayer(Canvas canvas, double W, double H, Color color,
      double baseY, double amp1, double amp2, double freq, double offset) {
    final path = Path()..moveTo(0, H);
    for (double x = 0; x <= W; x += 3) {
      final y = H * baseY
          - H * amp1 * sin(x / W * pi * freq + offset)
          - H * amp2 * sin(x / W * pi * freq * 1.7 + offset + 1.4);
      path.lineTo(x, y);
    }
    path.lineTo(W, H);
    path.close();
    canvas.drawPath(path, Paint()..color = color);
  }

  // ── Clouds ────────────────────────────────────────────────────────────────

  void _drawClouds(Canvas canvas, double W, double H, double t) {
    final paint = Paint()..color = Colors.white.withValues(alpha: 0.07);
    for (final c in clouds) {
      final x = (c.xFrac * W + t * c.speed * 3) % (W + 300) - 150;
      final y = c.yFrac * H * 0.45;
      _drawCloudBlob(canvas, x, y, c.width, paint);
    }
  }

  void _drawCloudBlob(
      Canvas canvas, double x, double y, double w, Paint paint) {
    final h = w * 0.38;
    canvas.drawOval(
        Rect.fromCenter(center: Offset(x, y), width: w, height: h), paint);
    canvas.drawOval(
        Rect.fromCenter(
            center: Offset(x - w * 0.28, y + h * 0.15),
            width: w * 0.62,
            height: h * 0.8),
        paint);
    canvas.drawOval(
        Rect.fromCenter(
            center: Offset(x + w * 0.28, y + h * 0.1),
            width: w * 0.58,
            height: h * 0.75),
        paint);
  }

  // ── Hills ─────────────────────────────────────────────────────────────────

  void _drawHills(Canvas canvas, double W, double H, SeasonData d) {
    // Colina trasera — más clara, da profundidad
    _drawHillLayer(canvas, W, H, d.hillBack, 0.62, 0.055, 0.038, 1.2);
    if (season == SeasonState.winter) {
      _drawHillLayer(
          canvas, W, H,
          const Color(0xFFccddf8).withValues(alpha: 0.18),
          0.60, 0.055, 0.038, 1.2);
    }
    // Colina delantera — más oscura
    _drawHillLayer(canvas, W, H, d.hillColor, 0.72, 0.07, 0.045, 0.8);
  }

  void _drawHillLayer(Canvas canvas, double W, double H, Color color,
      double baseY, double amp1, double amp2, double freq) {
    final path = Path()..moveTo(0, H);
    for (double x = 0; x <= W; x += 4) {
      final y = H * baseY
          - H * amp1 * sin(x / W * pi * freq * 2 + 0.5)
          - H * amp2 * sin(x / W * pi * freq * 3.7 + 1.2);
      path.lineTo(x, y);
    }
    path.lineTo(W, H);
    path.close();
    canvas.drawPath(path, Paint()..color = color);
  }

  // ── Spring glow ───────────────────────────────────────────────────────────

  void _drawSpringGlow(Canvas canvas, double W, double H) {
    final paint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          Colors.transparent,
          const Color(0xFFf0a0c0).withValues(alpha: 0.09),
          const Color(0xFFe080b0).withValues(alpha: 0.06),
        ],
        stops: const [0.50, 0.78, 1.0],
      ).createShader(Offset.zero & Size(W, H));
    canvas.drawRect(Offset.zero & Size(W, H), paint);
  }

  @override
  bool shouldRepaint(ValleyBasePainter old) =>
      old.t != t || old.season != season;
}

// ─── Data types ───────────────────────────────────────────────────────────────

class ValleyStar {
  ValleyStar({
    required this.xFrac,
    required this.yFrac,
    required this.radius,
    required this.speed,
    required this.phase,
    required this.baseOpacity,
    required this.hasCross,
  });

  final double xFrac, yFrac, radius, speed, phase, baseOpacity;
  final bool hasCross;
}

class ValleyCloud {
  ValleyCloud({
    required this.xFrac,
    required this.yFrac,
    required this.width,
    required this.speed,
  });

  final double xFrac, yFrac, width, speed;
}

// ─── Generators ───────────────────────────────────────────────────────────────

List<ValleyStar> generateStars(int n, Random rng) => List.generate(
      n,
      (_) => ValleyStar(
        xFrac:       rng.nextDouble(),
        yFrac:       rng.nextDouble() * rng.nextDouble(),
        radius:      0.6 + rng.nextDouble() * 1.2,
        speed:       0.4 + rng.nextDouble() * 1.2,
        phase:       rng.nextDouble() * 2 * pi,
        baseOpacity: 0.4 + rng.nextDouble() * 0.6,
        hasCross:    rng.nextDouble() > 0.5,
      ),
    );

List<ValleyCloud> generateClouds(int n, Random rng) => List.generate(
      n,
      (_) => ValleyCloud(
        xFrac: rng.nextDouble(),
        yFrac: rng.nextDouble(),
        width: 180 + rng.nextDouble() * 220,
        speed: 0.015 + rng.nextDouble() * 0.025,
      ),
    );

