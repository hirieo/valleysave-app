import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../../core/models/season_state.dart';

/// Color de "trabajando" para la estación actual — pétalo rosa en
/// primavera, hoja naranja en otoño, etc. Público para que cualquier texto
/// junto al indicador (p. ej. "Sincronizando…") pueda usar el MISMO color,
/// en vez de un dorado fijo que no combina con el icono.
Color seasonBusyColor(SeasonState s) => switch (s) {
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
    final color = seasonBusyColor(season);

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
          _firefly(canvas, Offset(px, py), a + t * 0.4, color, pulse);
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
    canvas.drawPath(path, Paint()..color = color.withValues(alpha: alpha));

    // Destellos finos en las 4 direcciones cardinales — vende "brillo",
    // no solo silueta plana (2026-07-15, refinado de partículas).
    final sparkPaint = Paint()
      ..color = Color.lerp(color, Colors.white, 0.55)!.withValues(alpha: alpha * 0.9)
      ..strokeWidth = 0.9
      ..strokeCap = StrokeCap.round;
    final sparkGap = outer * 1.15;
    final sparkLen = outer * 1.7;
    for (final da in [0.0, math.pi / 2, math.pi, math.pi * 3 / 2]) {
      final dx = math.cos(da + rot);
      final dy = math.sin(da + rot);
      canvas.drawLine(
        Offset(pos.dx + dx * sparkGap, pos.dy + dy * sparkGap),
        Offset(pos.dx + dx * sparkLen, pos.dy + dy * sparkLen),
        sparkPaint,
      );
    }
    canvas.drawCircle(
      pos, inner * 0.55,
      Paint()..color = Colors.white.withValues(alpha: alpha * 0.7),
    );
  }

  void _petal(Canvas canvas, Offset pos, double angle, Color color, double alpha) {
    canvas.translate(pos.dx, pos.dy);
    canvas.rotate(angle);
    // Muesca en la punta — silueta de flor de cerezo, no una lágrima
    // genérica (2026-07-15, refinado de partículas).
    final path = Path()
      ..moveTo(-1.1, -3.4)
      ..cubicTo(-2.6, -2.2, -2.4, 1.7, 0, 3.5)
      ..cubicTo(2.4, 1.7, 2.6, -2.2, 1.1, -3.4)
      ..cubicTo(0.6, -3.0, -0.6, -3.0, -1.1, -3.4)
      ..close();
    canvas.drawPath(path, Paint()..color = color.withValues(alpha: alpha));
    canvas.drawLine(
      const Offset(0, 3.2), const Offset(0, -2.2),
      Paint()
        ..color = Colors.white.withValues(alpha: alpha * 0.25)
        ..strokeWidth = 0.5,
    );
  }

  void _firefly(Canvas canvas, Offset pos, double angle, Color color, double alpha) {
    // Cuerpo alargado + alas + brillo concentrado en la cola (el abdomen
    // bioluminiscente) — antes era un punto de luz simétrico indistinguible
    // de una chispa cualquiera (2026-07-15, refinado de partículas).
    canvas.save();
    canvas.translate(pos.dx, pos.dy);
    canvas.rotate(angle);

    final wingPaint = Paint()..color = color.withValues(alpha: alpha * 0.18);
    canvas.drawOval(
      Rect.fromCenter(center: const Offset(-2.2, -2.6), width: 3.0, height: 1.7),
      wingPaint,
    );
    canvas.drawOval(
      Rect.fromCenter(center: const Offset(2.2, -2.6), width: 3.0, height: 1.7),
      wingPaint,
    );

    canvas.drawOval(
      Rect.fromCenter(center: Offset.zero, width: 2.4, height: 5.0),
      Paint()..color = Color.lerp(color, Colors.black, 0.72)!.withValues(alpha: alpha),
    );

    const tail = Offset(0, 2.2);
    canvas.drawCircle(tail, 3.2, Paint()..color = color.withValues(alpha: alpha * 0.28));
    canvas.drawCircle(tail, 1.6, Paint()..color = color.withValues(alpha: alpha * 0.75));
    canvas.drawCircle(
      tail, 0.75,
      Paint()..color = Color.lerp(color, Colors.white, 0.5)!.withValues(alpha: alpha),
    );

    canvas.restore();
  }

  void _leaf(Canvas canvas, Offset pos, double angle, Color color, double alpha) {
    canvas.translate(pos.dx, pos.dy);
    canvas.rotate(angle);
    // Silueta de hoja de verdad (nervio + tallo) en vez de dos óvalos
    // superpuestos, que a tamaño pequeño se leían como un borrón
    // (2026-07-15, refinado de partículas — la mejora más notable).
    final path = Path()
      ..moveTo(0, -4.6)
      ..cubicTo(2.6, -3.0, 2.6, 3.0, 0, 4.6)
      ..cubicTo(-2.6, 3.0, -2.6, -3.0, 0, -4.6)
      ..close();
    canvas.drawPath(path, Paint()..color = color.withValues(alpha: alpha));

    final veinPaint = Paint()
      ..color = Color.lerp(color, Colors.black, 0.4)!.withValues(alpha: alpha * 0.7)
      ..strokeWidth = 0.5
      ..strokeCap = StrokeCap.round;
    canvas.drawLine(const Offset(0, -4.2), const Offset(0, 5.6), veinPaint);
    canvas.drawLine(const Offset(0, -1.6), const Offset(1.6, -0.4), veinPaint);
    canvas.drawLine(const Offset(0, -1.6), const Offset(-1.6, -0.4), veinPaint);
    canvas.drawLine(const Offset(0, 1.0), const Offset(1.3, 2.0), veinPaint);
    canvas.drawLine(const Offset(0, 1.0), const Offset(-1.3, 2.0), veinPaint);
  }

  void _snowflake(Canvas canvas, Offset pos, Color color, double alpha) {
    // 6 brazos con dendritas — antes eran 3 líneas cruzadas (solo 6
    // "medios brazos" sin ramificar), se veía a medias (2026-07-15,
    // refinado de partículas).
    final paint = Paint()
      ..color       = color.withValues(alpha: alpha * 0.85)
      ..strokeWidth = 0.85
      ..strokeCap   = StrokeCap.round;
    for (var k = 0; k < 6; k++) {
      final ka = k * math.pi / 3 + t * 0.3;
      final dx = math.cos(ka);
      final dy = math.sin(ka);
      final tip = Offset(pos.dx + dx * 3.6, pos.dy + dy * 3.6);
      canvas.drawLine(pos, tip, paint);

      const midR = 2.2;
      final mid = Offset(pos.dx + dx * midR, pos.dy + dy * midR);
      const branchLen = 1.1;
      final perpA = ka + math.pi / 2.6;
      canvas.drawLine(
        mid,
        Offset(mid.dx + math.cos(perpA) * branchLen, mid.dy + math.sin(perpA) * branchLen),
        paint,
      );
      canvas.drawLine(
        mid,
        Offset(mid.dx - math.cos(perpA) * branchLen, mid.dy - math.sin(perpA) * branchLen),
        paint,
      );
    }
    canvas.drawCircle(
      pos, 1.0,
      Paint()..color = Color.lerp(color, Colors.white, 0.4)!.withValues(alpha: alpha),
    );
  }

  @override
  bool shouldRepaint(_BusyPainter old) => true;
}
