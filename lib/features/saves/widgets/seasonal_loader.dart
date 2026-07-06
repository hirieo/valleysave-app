import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../generated/app_localizations.dart';
import '../../../core/models/season_state.dart';

class SeasonalLoader extends StatefulWidget {
  const SeasonalLoader({super.key, required this.season});
  final SeasonState season;

  @override
  State<SeasonalLoader> createState() => _SeasonalLoaderState();
}

class _SeasonalLoaderState extends State<SeasonalLoader>
    with TickerProviderStateMixin {
  late final List<AnimationController> _ctrls;

  int get _count {
    switch (widget.season) {
      case SeasonState.initial:
        return 1;
      case SeasonState.spring:
      case SeasonState.fall:
        return 3;
      case SeasonState.summer:
      case SeasonState.winter:
        return 5;
    }
  }

  @override
  void initState() {
    super.initState();
    _ctrls = List.generate(_count, (i) {
      final c = AnimationController(
        vsync: this,
        duration: const Duration(milliseconds: 1400),
      );
      Future.delayed(Duration(milliseconds: i * 200), () {
        if (mounted) c.repeat();
      });
      return c;
    });
  }

  @override
  void dispose() {
    for (final c in _ctrls) { c.dispose(); }
    super.dispose();
  }

  Color get _accent => SeasonData.data[widget.season]!.accentColor;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: 60,
            height: 52,
            child: Stack(
              clipBehavior: Clip.none,
              children: _particles(),
            ),
          ),
          const SizedBox(height: 12),
          Text(
            l10n.loaderLoading,
            style: GoogleFonts.firaCode(
              fontSize: 8,
              letterSpacing: .14,
              color: _accent.withValues(alpha: .80),
            ),
          ),
          const SizedBox(height: 3),
          Text(
            l10n.loaderConnecting,
            style: GoogleFonts.firaCode(
              fontSize: 7,
              letterSpacing: .05,
              color: Colors.white.withValues(alpha: .28),
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _particles() {
    switch (widget.season) {
      case SeasonState.initial:
        return [_star()];
      case SeasonState.spring:
        return _petals();
      case SeasonState.summer:
        return _fireflies();
      case SeasonState.fall:
        return _leaves();
      case SeasonState.winter:
        return _snow();
    }
  }

  // ── Inicial: estrella pulsante ──
  Widget _star() => Center(
        child: AnimatedBuilder(
          animation: _ctrls[0],
          builder: (_, _) {
            final v = _ctrls[0].value;
            final t = Curves.easeInOut
                .transform(v <= 0.5 ? v * 2 : (1 - v) * 2);
            return Opacity(
              opacity: 0.3 + 0.7 * t,
              child: Transform.scale(
                scale: 0.7 + 0.45 * t,
                child: Text(
                  '✦',
                  style: TextStyle(fontSize: 22, color: _accent),
                ),
              ),
            );
          },
        ),
      );

  // ── Primavera: pétalos cayendo ──
  List<Widget> _petals() {
    const xs = [8.0, 24.0, 42.0];
    return List.generate(3, (i) => AnimatedBuilder(
          animation: _ctrls[i],
          builder: (_, _) {
            final t = _ctrls[i].value;
            final op = (t < 0.15 ? t / 0.15 : t > 0.85 ? (1 - t) / 0.15 : 1.0)
                .clamp(0.0, 1.0);
            return Positioned(
              left: xs[i],
              top: t * 52,
              child: Opacity(
                opacity: op,
                child: Transform.rotate(
                  angle: t * math.pi,
                  child: Container(
                    width: 7,
                    height: 7,
                    decoration: BoxDecoration(
                      color: _accent.withValues(alpha: .85),
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(7),
                        bottomRight: Radius.circular(7),
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
        ));
  }

  // ── Verano: luciérnagas parpadeando ──
  List<Widget> _fireflies() {
    const positions = [
      Offset(6, 18), Offset(26, 6), Offset(44, 22),
      Offset(16, 36), Offset(38, 32),
    ];
    return List.generate(5, (i) => AnimatedBuilder(
          animation: _ctrls[i],
          builder: (_, _) {
            final v = _ctrls[i].value;
            final t = Curves.easeInOut
                .transform(v <= 0.5 ? v * 2 : (1 - v) * 2);
            return Positioned(
              left: positions[i].dx,
              top: positions[i].dy,
              child: Opacity(
                opacity: 0.1 + 0.9 * t,
                child: Transform.scale(
                  scale: 0.5 + 0.5 * t,
                  child: Container(
                    width: 5,
                    height: 5,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: _accent,
                      boxShadow: [
                        BoxShadow(
                          color: _accent.withValues(alpha: t * 0.6),
                          blurRadius: 4,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ));
  }

  // ── Otoño: hojas cayendo con rotación ──
  List<Widget> _leaves() {
    const xs = [8.0, 24.0, 40.0];
    return List.generate(3, (i) => AnimatedBuilder(
          animation: _ctrls[i],
          builder: (_, _) {
            final t = _ctrls[i].value;
            final op = (t < 0.15 ? t / 0.15 : t > 0.85 ? (1 - t) / 0.15 : 0.9)
                .clamp(0.0, 1.0);
            final drift = math.sin(t * math.pi * 2) * 5;
            return Positioned(
              left: xs[i] + drift,
              top: t * 52,
              child: Opacity(
                opacity: op,
                child: Transform.rotate(
                  angle: t * math.pi * 1.5,
                  child: Container(
                    width: 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: _accent.withValues(alpha: .85),
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(8),
                        topRight: Radius.circular(8),
                        bottomLeft: Radius.circular(8),
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
        ));
  }

  // ── Invierno: copos de nieve ──
  List<Widget> _snow() {
    const xs = [6.0, 18.0, 32.0, 46.0, 13.0];
    return List.generate(5, (i) => AnimatedBuilder(
          animation: _ctrls[i],
          builder: (_, _) {
            final t = _ctrls[i].value;
            final op = (t < 0.1 ? t / 0.1 : t > 0.9 ? (1 - t) / 0.1 : 0.8)
                .clamp(0.0, 1.0);
            final drift = math.sin(t * math.pi * 2) * 3;
            return Positioned(
              left: xs[i] + drift,
              top: t * 52,
              child: Opacity(
                opacity: op,
                child: Container(
                  width: 4,
                  height: 4,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: _accent.withValues(alpha: .90),
                  ),
                ),
              ),
            );
          },
        ));
  }
}
