import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

import '../../core/models/season_state.dart';
import 'valley_base_painter.dart';
import 'season_particles_painter.dart';

class ValleyCanvasWidget extends StatefulWidget {
  const ValleyCanvasWidget({super.key, required this.season});

  final SeasonState season;

  @override
  State<ValleyCanvasWidget> createState() => _ValleyCanvasWidgetState();
}

class _ValleyCanvasWidgetState extends State<ValleyCanvasWidget>
    with SingleTickerProviderStateMixin {
  late final Ticker _ticker;
  late final List<ValleyStar> _stars;
  late final List<ValleyCloud> _clouds;
  late List<Particle> _particles;

  final _startTime = DateTime.now();
  double _t = 0;

  @override
  void initState() {
    super.initState();
    final rng = Random();
    _stars = generateStars(80, rng);
    _clouds = generateClouds(6, rng);
    _particles = [];

    _ticker = createTicker((_) {
      final now =
          DateTime.now().difference(_startTime).inMicroseconds / 1e6;
      if (mounted) setState(() => _t = now);
    })
      ..start();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _initParticles();
  }

  @override
  void didUpdateWidget(ValleyCanvasWidget old) {
    super.didUpdateWidget(old);
    if (old.season != widget.season) _initParticles();
  }

  void _initParticles() {
    final size = MediaQuery.sizeOf(context);
    _particles = createParticles(widget.season, size.width, size.height);
  }

  @override
  void dispose() {
    _ticker.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: CustomPaint(
        painter: ValleyBasePainter(
          season: widget.season,
          t: _t,
          stars: _stars,
          clouds: _clouds,
        ),
        foregroundPainter: SeasonParticlesPainter(
          season: widget.season,
          t: _t,
          particles: _particles,
        ),
        size: Size.infinite,
      ),
    );
  }
}
