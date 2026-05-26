import 'package:flutter/material.dart';

import '../../core/models/season_state.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_typography.dart';
import '../../shared/widgets/ghost_button.dart';
import '../../shared/widgets/primary_button.dart';
import '../../shared/widgets/valley_canvas_widget.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg,
      body: Stack(
        children: [
          const Positioned.fill(
            child: ValleyCanvasWidget(season: SeasonState.initial),
          ),
          Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 760),
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: AppSpacing.sp8),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    RichText(
                      text: TextSpan(
                        style: AppTypography.hero(),
                        children: [
                          const TextSpan(text: 'Nunca pierdas\ntu '),
                          TextSpan(
                            text: 'granja,',
                            style: AppTypography.hero(color: AppColors.accent)
                                .copyWith(fontStyle: FontStyle.normal),
                          ),
                          const TextSpan(text: '\nllévala contigo.'),
                        ],
                      ),
                    ),
                    const SizedBox(height: AppSpacing.sp6),
                    Text(
                      'Sincroniza tus saves de Stardew Valley entre todos tus dispositivos. '
                      'Tus datos viven en tu Google Drive — sin servidores propios, sin suscripciones, bajo tu control.',
                      style: AppTypography.body(),
                    ),
                    const SizedBox(height: AppSpacing.sp8),
                    Wrap(
                      spacing: AppSpacing.sp4,
                      runSpacing: AppSpacing.sp4,
                      children: [
                        PrimaryButton(
                          label: 'Conectar Google Drive',
                          onPressed: () {},
                        ),
                        GhostButton(
                          label: 'Cómo funciona',
                          onPressed: () {},
                        ),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.sp6),
                    Text(
                      '· MIT · Código abierto · Gratis para siempre ·',
                      style: AppTypography.eyebrow(color: AppColors.textFaint),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
