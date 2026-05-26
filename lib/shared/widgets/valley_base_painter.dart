import 'dart:math';
import 'package:flutter/material.dart';
import '../../core/models/season_state.dart';

/// Dibuja la capa base del valle: cielo, estrellas, nubes, colinas.
class ValleyBasePainter extends CustomPainter {
  ValleyBasePainter({
    required this.season,
    required this.t,
    required this.stars,
    required this.clouds,
  });

  final SeasonState season;
  final double t; // seconds elapsed
  final List<ValleyStar> stars;
  final List<ValleyCloud> clouds;

  @override
  void paint(Canvas canvas, Size size) {
    final d = SeasonData.data[season]!;
    final W = size.width, H = size.height;

    _drawSky(canvas, size, d);
    _drawStars(canvas, W, H, d, t);
    if (season == SeasonState.summer || season == SeasonState.initial) {
      _drawMoon(canvas, W, H, t, d.accentColor);
    }
    if (season == SeasonState.fall) {
      _drawFallMoon(canvas, W, H);
    }
    _drawClouds(canvas, W, H, t);
    _drawHills(canvas, W, H, d);
  }

  void _drawSky(Canvas canvas, Size size, SeasonData d) {
    final paint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [d.skyTop, d.skyBottom],
      ).createShader(Offset.zero & size);
    canvas.drawRect(Offset.zero & size, paint);
  }

  void _drawStars(Canvas canvas, double W, double H, SeasonData d, double t) {
    final paint = Paint();
    for (final s in stars) {
      final twinkle = 0.4 + 0.6 * ((sin(t * s.speed + s.phase) + 1) / 2);
      paint.color =
          Colors.white.withValues(alpha: d.starOpacity * twinkle * s.baseOpacity);
      canvas.drawCircle(Offset(s.xFrac * W, s.yFrac * H * 0.65), s.radius, paint);
    }
  }

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
    // Glow halo
    canvas.drawCircle(
      Offset(cx, cy),
      mr + 18,
      Paint()
        ..color = const Color(0xFFe8d060).withValues(alpha: 0.15)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 18),
    );
    // Moon disc
    final moonPaint = Paint()
      ..shader = RadialGradient(
        center: const Alignment(-0.25, -0.25),
        colors: [const Color(0xFFfff8d8), const Color(0xFFe8d870)],
      ).createShader(Rect.fromCircle(center: Offset(cx, cy), radius: mr));
    canvas.drawCircle(Offset(cx, cy), mr, moonPaint);
  }

  void _drawClouds(Canvas canvas, double W, double H, double t) {
    final paint = Paint()..color = Colors.white.withValues(alpha: 0.07);
    for (final c in clouds) {
      final x = (c.xFrac * W + t * c.speed * 12) % (W + 300) - 150;
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

  void _drawHills(Canvas canvas, double W, double H, SeasonData d) {
    // Back hill (lighter)
    _drawHillLayer(
        canvas, W, H, d.hillColor.withValues(alpha: 0.7), 0.62, 0.055, 0.038, 1.2);
    // Snow cap in winter
    if (season == SeasonState.winter) {
      _drawHillLayer(
          canvas,
          W,
          H,
          const Color(0xFFccddf8).withValues(alpha: 0.18),
          0.60,
          0.055,
          0.038,
          1.2);
    }
    // Front hill (full)
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
  });

  final double xFrac, yFrac, radius, speed, phase, baseOpacity;
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

/// Genera [n] estrellas con propiedades aleatorias.
List<ValleyStar> generateStars(int n, Random rng) => List.generate(
      n,
      (_) => ValleyStar(
        xFrac:       rng.nextDouble(),
        yFrac:       rng.nextDouble(),
        radius:      0.6 + rng.nextDouble() * 1.2,
        speed:       0.4 + rng.nextDouble() * 1.2,
        phase:       rng.nextDouble() * 2 * pi,
        baseOpacity: 0.4 + rng.nextDouble() * 0.6,
      ),
    );

/// Genera [n] nubes con propiedades aleatorias.
List<ValleyCloud> generateClouds(int n, Random rng) => List.generate(
      n,
      (_) => ValleyCloud(
        xFrac: rng.nextDouble(),
        yFrac: rng.nextDouble(),
        width: 180 + rng.nextDouble() * 220,
        speed: 0.015 + rng.nextDouble() * 0.025,
      ),
    );
