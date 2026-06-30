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

  static const double _kR = 60.0;
  static const int    _kN = 12;

  @override
  void paint(Canvas canvas, Size size) {
    final cx  = size.width / 2;
    final cy  = size.height * 0.43;
    final acc = _ringColor(season);
    final p   = progress.clamp(0.0, 1.0);

    // bg glow sutil
    canvas.drawCircle(Offset(cx, cy), _kR + 24,
        Paint()..color = acc.withValues(alpha: 0.07));

    // track
    canvas.drawCircle(Offset(cx, cy), _kR,
        Paint()
          ..color     = Colors.white.withValues(alpha: 0.10)
          ..style     = PaintingStyle.stroke
          ..strokeWidth = 7
          ..strokeCap   = StrokeCap.round);

    // arco de progreso
    if (p > 0) {
      canvas.drawArc(
        Rect.fromCircle(center: Offset(cx, cy), radius: _kR),
        -math.pi / 2,
        math.pi * 2 * p,
        false,
        Paint()
          ..color     = acc
          ..style     = PaintingStyle.stroke
          ..strokeWidth = 7
          ..strokeCap   = StrokeCap.round,
      );
    }

    // punto líder en el extremo del arco
    if (p > 0.015 && p < 0.985) {
      final la = -math.pi / 2 + math.pi * 2 * p;
      canvas.drawCircle(
        Offset(cx + math.cos(la) * _kR, cy + math.sin(la) * _kR),
        5,
        Paint()..color = Colors.white.withValues(alpha: 0.80 + 0.20 * math.sin(t * 7)),
      );
    }

    // partículas orbitando
    for (var i = 0; i < _kN; i++) {
      if (i / _kN > p) continue;
      final a      = i * math.pi * 2 / _kN + t * (i.isEven ? 0.055 : -0.038);
      final orbit  = _kR + math.sin(t * 1.3 + i * 1.1) * 7;
      final px     = cx + math.cos(a) * orbit;
      final py     = cy + math.sin(a) * orbit;
      final pulse  = 0.45 + 0.55 * math.sin(t * 3.5 + i * 1.4);
      _drawParticle(canvas, Offset(px, py), a, pulse);
    }

    // porcentaje
    _txt(canvas, '${(p * 100).round()}%',
        Offset(cx, cy - 9), 20, FontWeight.bold, Colors.white);

    // MB descargados
    _txt(canvas,
        '${(p * totalMB).toStringAsFixed(1)} / ${totalMB.toStringAsFixed(1)} MB',
        Offset(cx, cy + 13), 10, FontWeight.normal,
        acc.withValues(alpha: 0.75));

    // barra fina
    final barY = cy + _kR + 28;
    const barW = 150.0;
    final barX = cx - barW / 2;
    canvas.drawRRect(
        RRect.fromRectAndRadius(Rect.fromLTWH(barX, barY, barW, 4),
            const Radius.circular(2)),
        Paint()..color = Colors.white.withValues(alpha: 0.08));
    if (p > 0) {
      canvas.drawRRect(
          RRect.fromRectAndRadius(Rect.fromLTWH(barX, barY, barW * p, 4),
              const Radius.circular(2)),
          Paint()..color = acc.withValues(alpha: 0.70));
    }

    // versión
    if (version.isNotEmpty) {
      _txt(canvas, 'ValleySave $version',
          Offset(cx, barY + 20), 10, FontWeight.normal,
          Colors.white.withValues(alpha: 0.30));
    }
  }

  void _drawParticle(Canvas canvas, Offset pos, double angle, double alpha) {
    canvas.save();
    switch (season) {
      case SeasonState.winter:  _snowflake(canvas, pos, alpha);
      case SeasonState.spring:  _petal(canvas, pos, angle, alpha);
      case SeasonState.summer:  _firefly(canvas, pos, alpha);
      case SeasonState.fall:    _leaf(canvas, pos, angle, alpha);
      case SeasonState.initial: _star(canvas, pos, alpha);
    }
    canvas.restore();
  }

  void _snowflake(Canvas canvas, Offset pos, double alpha) {
    final paint = Paint()
      ..color       = const Color(0xFFC8E8FF).withValues(alpha: alpha * 0.85)
      ..strokeWidth = 1.4
      ..strokeCap   = StrokeCap.round;
    for (var k = 0; k < 3; k++) {
      final ka = k * math.pi / 3 + t * 0.5;
      canvas.drawLine(
        Offset(pos.dx - math.cos(ka) * 4.5, pos.dy - math.sin(ka) * 4.5),
        Offset(pos.dx + math.cos(ka) * 4.5, pos.dy + math.sin(ka) * 4.5),
        paint,
      );
    }
    canvas.drawCircle(pos, 1.8,
        Paint()..color = const Color(0xFFE0F4FF).withValues(alpha: alpha));
  }

  void _petal(Canvas canvas, Offset pos, double angle, double alpha) {
    canvas.translate(pos.dx, pos.dy);
    canvas.rotate(angle + t * 0.4);
    final path = Path()
      ..moveTo(0, -5)
      ..cubicTo(3, -3, 3, 3, 0, 5)
      ..cubicTo(-3, 3, -3, -3, 0, -5);
    canvas.drawPath(path,
        Paint()..color = const Color(0xFFFFB7D0).withValues(alpha: alpha * 0.90));
    canvas.drawCircle(Offset.zero, 1.2,
        Paint()..color = const Color(0xFFFF8AB0).withValues(alpha: alpha * 0.55));
  }

  void _firefly(Canvas canvas, Offset pos, double alpha) {
    canvas.drawCircle(pos, 3.5,
        Paint()..color = const Color(0xFFFFE566).withValues(alpha: alpha * 0.90));
    final ray = Paint()
      ..color       = const Color(0xFFFFD700).withValues(alpha: alpha * 0.50)
      ..strokeWidth = 1.2
      ..strokeCap   = StrokeCap.round;
    for (var k = 0; k < 4; k++) {
      final ka = k * math.pi / 2 + t * 2;
      canvas.drawLine(
        Offset(pos.dx + math.cos(ka) * 3.5, pos.dy + math.sin(ka) * 3.5),
        Offset(pos.dx + math.cos(ka) * 6.5, pos.dy + math.sin(ka) * 6.5),
        ray,
      );
    }
  }

  void _leaf(Canvas canvas, Offset pos, double angle, double alpha) {
    canvas.translate(pos.dx, pos.dy);
    canvas.rotate(angle + t * 0.6);
    canvas.drawOval(Rect.fromCenter(center: Offset.zero, width: 11, height: 6),
        Paint()..color = const Color(0xFFD4722A).withValues(alpha: alpha * 0.90));
    canvas.drawOval(Rect.fromCenter(center: const Offset(1, 0), width: 7, height: 4),
        Paint()..color = const Color(0xFFC84B0A).withValues(alpha: alpha * 0.70));
  }

  void _star(Canvas canvas, Offset pos, double alpha) {
    canvas.drawCircle(pos, 2.5,
        Paint()..color = const Color(0xFFC0CFE8).withValues(alpha: alpha * 0.90));
    if (alpha > 0.7) {
      canvas.drawCircle(pos, 4.5,
          Paint()..color = Colors.white.withValues(alpha: (alpha - 0.7) * 0.30));
    }
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
