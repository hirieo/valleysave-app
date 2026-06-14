import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../core/models/season_state.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_typography.dart';
import '../../shared/widgets/ghost_button.dart';
import '../../shared/widgets/primary_button.dart';
import '../../shared/widgets/season_click_effect.dart';
import '../../shared/widgets/valley_canvas_widget.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  SeasonState _season = SeasonState.initial;

  @override
  void initState() {
    super.initState();
    HardwareKeyboard.instance.addHandler(_onKey);
  }

  @override
  void dispose() {
    HardwareKeyboard.instance.removeHandler(_onKey);
    super.dispose();
  }

  bool _onKey(KeyEvent event) {
    if (event is KeyDownEvent) {
      switch (event.logicalKey) {
        case LogicalKeyboardKey.digit1:
          setState(() => _season = SeasonState.initial);
        case LogicalKeyboardKey.digit2:
          setState(() => _season = SeasonState.spring);
        case LogicalKeyboardKey.digit3:
          setState(() => _season = SeasonState.summer);
        case LogicalKeyboardKey.digit4:
          setState(() => _season = SeasonState.fall);
        case LogicalKeyboardKey.digit5:
          setState(() => _season = SeasonState.winter);
      }
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg,
      body: Stack(
        children: [
          // z=0: fondo
          Positioned.fill(
            child: ValleyCanvasWidget(season: _season),
          ),
          // z=0.5: scrim — oscurece colinas para contraste del subtítulo
          Positioned.fill(
            child: DecoratedBox(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  stops: [0.0, 0.40, 1.0],
                  colors: [
                    Colors.transparent,
                    Color(0x26000000),
                    Color(0x73000000),
                  ],
                ),
              ),
            ),
          ),
          // z=1: columna central
          Center(
            child: LayoutBuilder(
              builder: (context, constraints) {
                final compact = constraints.maxHeight < 480;
                return ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 760),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sp8),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        RichText(
                          text: TextSpan(
                            style: AppTypography.hero().copyWith(
                              fontSize: compact ? 44 : 84,
                            ),
                            children: [
                              const TextSpan(text: 'Nunca pierdas\ntu '),
                              TextSpan(
                                text: 'granja,',
                                style: AppTypography.hero(color: AppColors.accent)
                                    .copyWith(
                                  fontStyle: FontStyle.normal,
                                  fontSize: compact ? 44 : 84,
                                ),
                              ),
                              const TextSpan(text: '\nllévala contigo.'),
                            ],
                          ),
                        ),
                        SizedBox(height: compact ? AppSpacing.sp2 : AppSpacing.sp6),
                        Text(
                          'Sincroniza tus saves de Stardew Valley entre todos tus dispositivos. '
                          'Tus datos viven en tu Google Drive — sin servidores propios, sin suscripciones, bajo tu control.',
                          style: AppTypography.body(
                            color: Colors.white.withValues(alpha: 0.90),
                          ).copyWith(
                            shadows: const [
                              Shadow(
                                color: Color(0x8C000000),
                                blurRadius: 8,
                                offset: Offset(0, 1),
                              ),
                              Shadow(
                                color: Color(0x40000000),
                                blurRadius: 24,
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: compact ? AppSpacing.sp3 : AppSpacing.sp8),
                        Wrap(
                          spacing: AppSpacing.sp4,
                          runSpacing: AppSpacing.sp4,
                          children: [
                            SeasonClickEffect(
                              season: _season,
                              child: PrimaryButton(
                                label: 'Conectar Google Drive',
                                onPressed: () {},
                                color: SeasonData.data[_season]!.accentColor,
                              ),
                            ),
                            SeasonClickEffect(
                              season: _season,
                              child: GhostButton(
                                label: 'Cómo funciona',
                                onPressed: () {},
                                foregroundColor: Colors.white,
                                borderColor: SeasonData.data[_season]!.accentColor.withValues(alpha: 0.80),
                                backgroundColor: Colors.black.withValues(
                                  alpha: _season == SeasonState.winter ? 0.45 : 0.32,
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: compact ? AppSpacing.sp2 : AppSpacing.sp6),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                          decoration: BoxDecoration(
                            color: Colors.black.withValues(alpha: 0.35),
                            borderRadius: BorderRadius.circular(999),
                          ),
                          child: Text(
                            '· MIT · Código abierto · Gratis para siempre ·',
                            style: AppTypography.eyebrow(
                              color: Colors.white.withValues(alpha: 0.80),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          // z=2: chips — sobre todo lo demás, reciben eventos primero
          Positioned(
            bottom: 24,
            left: 0,
            right: 0,
            child: Center(
              child: Wrap(
                spacing: 8,
                children: [
                  _seasonChip(SeasonState.initial, '✨ Inicial'),
                  _seasonChip(SeasonState.spring, '🌸 Primavera'),
                  _seasonChip(SeasonState.summer, '☀️ Verano'),
                  _seasonChip(SeasonState.fall, '🍂 Otoño'),
                  _seasonChip(SeasonState.winter, '❄️ Invierno'),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _seasonChip(SeasonState s, String label) {
    final active = _season == s;
    final accent = SeasonData.data[s]!.accentColor;
    return GestureDetector(
      onTap: () => setState(() => _season = s),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
        decoration: BoxDecoration(
          color: active
              ? accent.withValues(alpha: 0.22)
              : accent.withValues(alpha: 0.12),
          borderRadius: BorderRadius.circular(999),
          border: Border.all(
            color: active
                ? accent.withValues(alpha: 0.90)
                : accent.withValues(alpha: 0.50),
          ),
        ),
        child: Text(
          label,
          style: AppTypography.eyebrow(
            color: active ? accent : accent.withValues(alpha: 0.70),
          ),
        ),
      ),
    );
  }
}
