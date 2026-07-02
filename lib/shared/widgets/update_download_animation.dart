import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../../core/models/season_state.dart';

Color _ringColor(SeasonState s) => switch (s) {
  SeasonState.spring  => const Color(0xFFE8608A),
  SeasonState.summer  => const Color(0xFFF5A623),
  SeasonState.fall    => const Color(0xFFD4722A),
  SeasonState.winter  => const Color(0xFF3A9BE3),
  SeasonState.initial => const Color(0xFF4A6FA5),
};

/// Muestra un diálogo oscuro con la animación D (círculo + partículas estacionales).
/// Se cierra solo cuando [progressNotifier] llega a 1.0 o en error.
void showUpdateDownloadDialog(
  BuildContext context, {
  required ValueNotifier<double> progressNotifier,
  required SeasonState season,
  required String version,
}) {
  showDialog<void>(
    context: context,
    barrierDismissible: false,
    barrierColor: Colors.black.withValues(alpha: 0.80),
    builder: (ctx) => _UpdateDownloadDialog(
      progressNotifier: progressNotifier,
      season: season,
      version: version,
    ),
  );
}

class _UpdateDownloadDialog extends StatefulWidget {
  const _UpdateDownloadDialog({
    required this.progressNotifier,
    required this.season,
    required this.version,
  });
  final ValueNotifier<double> progressNotifier;
  final SeasonState season;
  final String version;

  @override
  State<_UpdateDownloadDialog> createState() => _UpdateDownloadDialogState();
}

class _UpdateDownloadDialogState extends State<_UpdateDownloadDialog> {
  @override
  void initState() {
    super.initState();
    widget.progressNotifier.addListener(_checkDone);
  }

  void _checkDone() {
    if (widget.progressNotifier.value >= 1.0 && mounted) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) Navigator.of(context, rootNavigator: true).maybePop();
      });
    }
  }

  @override
  void dispose() {
    widget.progressNotifier.removeListener(_checkDone);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Material(
        color: Colors.transparent,
        child: ValueListenableBuilder<double>(
          valueListenable: widget.progressNotifier,
          builder: (_, p, _) => UpdateDownloadAnimation(
            progress: p,
            season: widget.season,
            version: widget.version,
          ),
        ),
      ),
    );
  }
}

/// Widget autónomo: anillo de progreso circular con partículas estacionales orbitando.
/// [progress] 0.0–1.0. [season] determina color del anillo y tipo de partícula.
class UpdateDownloadAnimation extends StatefulWidget {
  const UpdateDownloadAnimation({
    super.key,
    required this.progress,
    required this.season,
    this.version = '',
    this.totalMB = 56.1,
  });

  final double progress;
  final SeasonState season;
  final String version;
  final double totalMB;

  @override
  State<UpdateDownloadAnimation> createState() => _UpdateDownloadAnimationState();
}

class _UpdateDownloadAnimationState extends State<UpdateDownloadAnimation>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 20),
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
        size: const Size(220, 260),
        painter: _DAnimPainter(
          progress: widget.progress,
          season: widget.season,
          t: _ctrl.value * math.pi * 2 * 20,
          version: widget.version,
          totalMB: widget.totalMB,
        ),
      ),
    );
  }
}

class _DAnimPainter extends CustomPainter {
  const _DAnimPainter({
    required this.progress,
    required this.season,
    required this.t,
    required this.version,
    required this.totalMB,
  });

  final double progress, t, totalMB;
  final SeasonState season;
  final String version;

  static const double _kR    = 60.0;
  static const int    _kN    = 12;
  static const double _kWRAP = 16.0; // amplitud helix
  static const double _kTube =  9.0; // semiancho del tubo

  @override
  void paint(Canvas canvas, Size size) {
    final cx  = size.width / 2;
    final cy  = size.height * 0.43;
    final acc = _ringColor(season);
    final pct = progress.clamp(0.0, 1.0);

    // fondo glow
    canvas.drawCircle(Offset(cx, cy), _kR + 24,
        Paint()..color = acc.withValues(alpha: 0.07));

    // posiciones helix: cada partícula orbita alrededor del grosor del tubo
    final parts = List.generate(_kN, (i) {
      final a     = i * math.pi * 2 / _kN + t * 0.10;
      final phi   = i * (math.pi / 2) + t * 0.6;
      final rr    = _kR + _kWRAP * math.cos(phi);
      final depth = math.sin(phi);              // >0 delante, <0 detrás
      final sc    = 0.62 + 0.38 * (0.5 + 0.5 * depth); // perspectiva
      final al    = season == SeasonState.summer
          ? 0.70 + 0.30 * math.sin(t * 1.8 + i * 0.9)
          : 0.92;
      return (
        px: cx + math.cos(a) * rr,
        py: cy + math.sin(a) * rr,
        a: a, al: al, sc: sc, depth: depth,
      );
    });
    parts.sort((x, y) => x.depth.compareTo(y.depth));

    // pasada 1: partículas detrás del tubo
    for (final p in parts) {
      if (p.depth < 0) _drawParticle(canvas, Offset(p.px, p.py), p.a, p.al, p.sc);
    }

    // máscara opaca — tapa físicamente las partículas de atrás
    canvas.drawCircle(
      Offset(cx, cy), _kR,
      Paint()
        ..color       = const Color(0xFF0A0A0B)
        ..style       = PaintingStyle.stroke
        ..strokeWidth = _kTube * 2 + 2,
    );

    // track
    canvas.drawCircle(
      Offset(cx, cy), _kR,
      Paint()
        ..color       = Colors.white.withValues(alpha: 0.10)
        ..style       = PaintingStyle.stroke
        ..strokeWidth = _kTube * 2
        ..strokeCap   = StrokeCap.round,
    );

    // arco de progreso
    if (pct > 0) {
      canvas.drawArc(
        Rect.fromCircle(center: Offset(cx, cy), radius: _kR),
        -math.pi / 2,
        math.pi * 2 * pct,
        false,
        Paint()
          ..color       = acc
          ..style       = PaintingStyle.stroke
          ..strokeWidth = _kTube * 2
          ..strokeCap   = StrokeCap.round,
      );
    }

    // punto líder
    if (pct > 0.015 && pct < 0.985) {
      final la = -math.pi / 2 + math.pi * 2 * pct;
      canvas.drawCircle(
        Offset(cx + math.cos(la) * _kR, cy + math.sin(la) * _kR),
        5,
        Paint()..color = Colors.white.withValues(alpha: 0.80 + 0.20 * math.sin(t * 7)),
      );
    }

    // pasada 2: partículas delante del tubo
    for (final p in parts) {
      if (p.depth >= 0) _drawParticle(canvas, Offset(p.px, p.py), p.a, p.al, p.sc);
    }

    // textos
    _txt(canvas, '${(pct * 100).round()}%',
        Offset(cx, cy - 9), 20, FontWeight.bold, Colors.white);
    _txt(canvas,
        '${(pct * totalMB).toStringAsFixed(1)} / ${totalMB.toStringAsFixed(1)} MB',
        Offset(cx, cy + 13), 10, FontWeight.normal,
        acc.withValues(alpha: 0.75));
    if (version.isNotEmpty) {
      _txt(canvas, 'ValleySave $version',
          Offset(cx, cy + _kR + 28), 10, FontWeight.normal,
          Colors.white.withValues(alpha: 0.30));
    }
  }

  void _drawParticle(Canvas canvas, Offset pos, double angle, double alpha, double scale) {
    canvas.save();
    canvas.translate(pos.dx, pos.dy);
    canvas.scale(scale, scale);
    switch (season) {
      case SeasonState.winter:  _snowflake(canvas, alpha);
      case SeasonState.spring:  _petal(canvas, angle, alpha);
      case SeasonState.summer:  _firefly(canvas, angle, alpha);
      case SeasonState.fall:    _leaf(canvas, angle, alpha);
      case SeasonState.initial: _star(canvas, alpha);
    }
    canvas.restore();
  }

  // ── INVIERNO: copo con ramas laterales ─────────────────
  void _snowflake(Canvas canvas, double alpha) {
    final spin = t * 0.12;
    canvas.drawCircle(Offset.zero, 11,
        Paint()..shader = RadialGradient(colors: [
          const Color(0xFF80C8FF).withValues(alpha: alpha * 0.22),
          const Color(0xFF80C8FF).withValues(alpha: 0),
        ]).createShader(Rect.fromCircle(center: Offset.zero, radius: 11)));
    final p = Paint()
      ..color       = const Color(0xFFE4F6FF).withValues(alpha: alpha * 0.95)
      ..strokeWidth = 1.8
      ..strokeCap   = StrokeCap.round;
    for (var k = 0; k < 3; k++) {
      final ka = k * math.pi / 3 + spin;
      canvas.drawLine(
        Offset(-math.cos(ka) * 7, -math.sin(ka) * 7),
        Offset( math.cos(ka) * 7,  math.sin(ka) * 7),
        p);
      for (final d in [-1.0, 1.0]) {
        final bf = ka + math.pi / 2;
        canvas.drawLine(
          Offset(math.cos(ka) * 3.5 * d,                         math.sin(ka) * 3.5 * d),
          Offset(math.cos(ka) * 3.5 * d + math.cos(bf) * 3,     math.sin(ka) * 3.5 * d + math.sin(bf) * 3),
          p);
      }
    }
    canvas.drawCircle(Offset.zero, 2.5,
        Paint()..color = Colors.white.withValues(alpha: alpha * 0.90));
  }

  // ── PRIMAVERA: pétalo teardrop con vena ────────────────
  void _petal(Canvas canvas, double angle, double alpha) {
    canvas.drawCircle(Offset.zero, 12,
        Paint()..shader = RadialGradient(colors: [
          const Color(0xFFFF80A8).withValues(alpha: alpha * 0.20),
          const Color(0xFFFF80A8).withValues(alpha: 0),
        ]).createShader(Rect.fromCircle(center: Offset.zero, radius: 12)));
    canvas.rotate(angle + t * 0.10);
    final path = Path()
      ..moveTo(0, 9)
      ..cubicTo(6, 4, 6, -5, 1.6, -8.5)
      ..quadraticBezierTo(0, -10, -1.6, -8.5)
      ..cubicTo(-6, -5, -6, 4, 0, 9);
    canvas.drawPath(path,
        Paint()..color = const Color(0xFFFFC2D6).withValues(alpha: alpha * 0.97));
    canvas.drawLine(const Offset(0, 7), const Offset(0, -6),
        Paint()
          ..color       = const Color(0xFFFF6B96).withValues(alpha: alpha * 0.40)
          ..strokeWidth = 0.8
          ..strokeCap   = StrokeCap.round);
  }

  // ── VERANO: luciérnaga cabeza delante, luz atrás ───────
  void _firefly(Canvas canvas, double angle, double alpha) {
    canvas.drawCircle(Offset.zero, 15,
        Paint()..shader = RadialGradient(colors: [
          const Color(0xFFCCFF66).withValues(alpha: alpha * 0.45),
          const Color(0xFFCCFF66).withValues(alpha: 0),
        ]).createShader(Rect.fromCircle(center: Offset.zero, radius: 15)));
    canvas.rotate(angle + math.pi); // cabeza hacia el sentido de avance
    // luz abdomen (atrás)
    canvas.drawCircle(const Offset(0, 4), 3.4,
        Paint()..color = const Color(0xFFCCFF00).withValues(alpha: alpha));
    canvas.drawCircle(const Offset(0, 4), 5.2,
        Paint()..color = const Color(0xFFAAEE00).withValues(alpha: alpha * 0.35));
    // tórax
    canvas.drawOval(
      Rect.fromCenter(center: const Offset(0, -1), width: 4.6, height: 8.4),
      Paint()..color = const Color(0xFF2A3A00).withValues(alpha: 0.92));
    // cabeza
    canvas.drawCircle(const Offset(0, -6.5), 2.0,
        Paint()..color = const Color(0xFF141F00).withValues(alpha: 0.92));
    // antenas
    final ant = Paint()
      ..color       = const Color(0xFF141F00).withValues(alpha: alpha * 0.70)
      ..strokeWidth = 0.9
      ..strokeCap   = StrokeCap.round;
    canvas.drawLine(const Offset(0, -7.5), const Offset(-2, -10), ant);
    canvas.drawLine(const Offset(0, -7.5), const Offset( 2, -10), ant);
  }

  // ── OTOÑO: hoja teardrop con venas ─────────────────────
  void _leaf(Canvas canvas, double angle, double alpha) {
    canvas.drawCircle(Offset.zero, 13,
        Paint()..shader = RadialGradient(colors: [
          const Color(0xFFE07030).withValues(alpha: alpha * 0.20),
          const Color(0xFFE07030).withValues(alpha: 0),
        ]).createShader(Rect.fromCircle(center: Offset.zero, radius: 13)));
    canvas.rotate(angle + t * 0.12 + math.pi / 2);
    final path = Path()
      ..moveTo(0, -10)
      ..cubicTo(7, -6, 7, 4, 0, 10)
      ..cubicTo(-7, 4, -7, -6, 0, -10);
    canvas.drawPath(path,
        Paint()..color = const Color(0xFFC85A18).withValues(alpha: alpha * 0.92));
    final vein = Paint()
      ..color       = const Color(0xFF8B2E00).withValues(alpha: alpha * 0.60)
      ..strokeWidth = 1.2
      ..strokeCap   = StrokeCap.round;
    canvas.drawLine(const Offset(0, -9), const Offset(0, 9), vein);
    for (final s in [-1.0, 1.0]) {
      canvas.drawLine(const Offset(0, -3), Offset(s * 5, 1), vein);
    }
  }

  // ── INICIAL: destello 4 puntas con gradiente ───────────
  void _star(Canvas canvas, double alpha) {
    canvas.drawCircle(Offset.zero, 12,
        Paint()..shader = RadialGradient(colors: [
          const Color(0xFFA8C8FF).withValues(alpha: alpha * 0.30),
          const Color(0xFFA8C8FF).withValues(alpha: 0),
        ]).createShader(Rect.fromCircle(center: Offset.zero, radius: 12)));
    canvas.rotate(t * 0.04);
    // rayo vertical (largo)
    canvas.drawPath(
      Path()..moveTo(0, -11)..lineTo(1.6, 0)..lineTo(0, 11)..lineTo(-1.6, 0)..close(),
      Paint()..shader = LinearGradient(
        begin: Alignment.topCenter,
        end:   Alignment.bottomCenter,
        colors: [
          const Color(0xFFEAF4FF).withValues(alpha: 0),
          const Color(0xFFEAF4FF).withValues(alpha: alpha * 0.95),
          const Color(0xFFEAF4FF).withValues(alpha: 0),
        ],
        stops: const [0.0, 0.5, 1.0],
      ).createShader(const Rect.fromLTWH(-1.6, -11, 3.2, 22)),
    );
    // rayo horizontal (corto)
    canvas.drawPath(
      Path()..moveTo(-7, 0)..lineTo(0, 1.2)..lineTo(7, 0)..lineTo(0, -1.2)..close(),
      Paint()..shader = LinearGradient(
        begin: Alignment.centerLeft,
        end:   Alignment.centerRight,
        colors: [
          const Color(0xFFEAF4FF).withValues(alpha: 0),
          const Color(0xFFEAF4FF).withValues(alpha: alpha * 0.95),
          const Color(0xFFEAF4FF).withValues(alpha: 0),
        ],
        stops: const [0.0, 0.5, 1.0],
      ).createShader(const Rect.fromLTWH(-7, -1.2, 14, 2.4)),
    );
    canvas.drawCircle(Offset.zero, 1.8,
        Paint()..color = Colors.white.withValues(alpha: alpha));
  }

  void _txt(Canvas canvas, String s, Offset center, double size,
      FontWeight weight, Color color) {
    final tp = TextPainter(
      text: TextSpan(
          text: s,
          style: TextStyle(fontSize: size, fontWeight: weight, color: color)),
      textAlign: TextAlign.center,
      textDirection: TextDirection.ltr,
    )..layout();
    tp.paint(canvas, center - Offset(tp.width / 2, tp.height / 2));
  }

  @override
  bool shouldRepaint(_DAnimPainter old) => true;
}
