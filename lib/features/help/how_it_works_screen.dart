import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../core/models/season_state.dart';
import '../../core/services/season_controller.dart';
import '../../core/theme/app_colors.dart';
import '../../shared/widgets/valley_canvas_widget.dart';

/// Pantalla informativa: explica las dos vías de acceso a los saves en Android
/// (Shizuku automático · Puente manual con la app de Archivos).
class HowItWorksScreen extends StatelessWidget {
  const HowItWorksScreen({super.key});

  // Rutas reales (se actualizan si cambia el package name).
  static const _gamePath =
      'Android/data/com.chucklefish.stardewvalley/files/Saves';
  static const _bridgePath = 'Android/data/com.hirieo.valleysave/files';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg,
      body: ValueListenableBuilder<SeasonState>(
        valueListenable: SeasonController.instance.season,
        builder: (_, season, _) => Stack(
          children: [
            Positioned.fill(child: ValleyCanvasWidget(season: season)),
            Positioned.fill(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    stops: const [0.0, 0.40, 1.0],
                    colors: [
                      Colors.transparent,
                      Colors.black.withValues(alpha: 0.28),
                      Colors.black.withValues(alpha: 0.62),
                    ],
                  ),
                ),
              ),
            ),
            SafeArea(
              child: Column(
                children: [
                  _header(context),
                  Expanded(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.fromLTRB(20, 4, 20, 40),
                      child: Center(
                        child: ConstrainedBox(
                          constraints: const BoxConstraints(maxWidth: 460),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              _intro(),
                              const SizedBox(height: 24),
                              _shizukuCard(season),
                              const SizedBox(height: 16),
                              _bridgeCard(season),
                              const SizedBox(height: 24),
                              _footerNote(),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ── Cabecera ──────────────────────────────────────────────────────────────

  Widget _header(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 10, 12, 6),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: Colors.black.withValues(alpha: 0.30),
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white.withValues(alpha: 0.15)),
              ),
              child: Icon(Icons.arrow_back_rounded,
                  size: 18, color: Colors.white.withValues(alpha: 0.70)),
            ),
          ),
          const SizedBox(width: 14),
          Text(
            'Cómo funciona',
            style: GoogleFonts.fraunces(
              fontSize: 19,
              fontStyle: FontStyle.italic,
              fontWeight: FontWeight.w700,
              color: Colors.white.withValues(alpha: 0.92),
            ),
          ),
        ],
      ),
    );
  }

  // ── Intro ─────────────────────────────────────────────────────────────────

  Widget _intro() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 8),
        Text(
          'Android protege la carpeta de partidas de Stardew: ninguna app puede '
          'leerla directamente. ValleySave te ofrece dos formas de darle acceso. '
          'Elige la que prefieras.',
          style: GoogleFonts.dmMono(
            fontSize: 12.5,
            height: 1.6,
            color: Colors.white.withValues(alpha: 0.80),
          ),
        ),
      ],
    );
  }

  // ── Vía 1: Shizuku ─────────────────────────────────────────────────────────

  Widget _shizukuCard(SeasonState season) {
    return _viaCard(
      seasonColor: SeasonData.data[season]!.accentColor,
      icon: Icons.bolt_rounded,
      accent: AppColors.accent,
      badge: 'AUTOMÁTICO · RECOMENDADO',
      title: 'Con Shizuku',
      subtitle:
          'Se configura una sola vez. Después ValleySave sincroniza sola, sin '
          'que toques nada nunca más.',
      steps: const [
        'Instala Shizuku (Play Store o APK desde GitHub).',
        'Actívala con "Depuración inalámbrica" — ValleySave te guía paso a paso.',
        'Concede permiso a ValleySave cuando te lo pida.',
      ],
      closing: '✓  Listo. A partir de ahí, descargar y subir partidas es '
          'directo, igual que en el ordenador.',
      footnote: 'El emparejamiento es solo la primera vez. Las versiones nuevas '
          'de Shizuku se reactivan solas tras reiniciar el móvil.',
    );
  }

  // ── Vía 2: Puente manual ─────────────────────────────────────────────────────

  Widget _bridgeCard(SeasonState season) {
    return _viaCard(
      seasonColor: SeasonData.data[season]!.accentColor,
      icon: Icons.swap_horiz_rounded,
      accent: AppColors.green,
      badge: 'ALTERNATIVA MANUAL · ANDROID 11-12',
      title: 'Puente manual',
      subtitle:
          'Solo funciona en Android 11 y 12. No instalas nada extra; a cambio, '
          'copias la partida a mano con tu app de Archivos cada vez que sincronizas.',
      steps: const [
        'Descargar de Drive: ValleySave deja la partida en su carpeta. '
            'Tú la copias con Archivos a la carpeta de Stardew.',
        'Subir a Drive: copias la partida de Stardew a la carpeta de ValleySave. '
            'ValleySave la detecta y la sube.',
      ],
      pathLabelA: 'Carpeta de Stardew',
      pathA: _gamePath,
      pathLabelB: 'Carpeta de ValleySave',
      pathB: _bridgePath,
      footnote: 'Funciona porque tu app de Archivos del sistema sí puede entrar '
          'en esas carpetas (ValleySave no).',
    );
  }

  // ── Card genérica de vía ─────────────────────────────────────────────────────

  Widget _viaCard({
    required Color seasonColor,
    required IconData icon,
    required Color accent,
    required String badge,
    required String title,
    required String subtitle,
    required List<String> steps,
    String? closing,
    String? footnote,
    String? pathLabelA,
    String? pathA,
    String? pathLabelB,
    String? pathB,
  }) {
    return Container(
      padding: const EdgeInsets.fromLTRB(18, 16, 18, 18),
      decoration: BoxDecoration(
        color: Color.alphaBlend(
          seasonColor.withValues(alpha: 0.22),
          const Color(0xFF040405),
        ).withValues(alpha: 0.80),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: accent.withValues(alpha: 0.28)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 38,
                height: 38,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: accent.withValues(alpha: 0.14),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, size: 20, color: accent),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      badge,
                      style: GoogleFonts.dmMono(
                        fontSize: 8.5,
                        letterSpacing: 1.1,
                        fontWeight: FontWeight.w700,
                        color: accent.withValues(alpha: 0.85),
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      title,
                      style: GoogleFonts.fraunces(
                        fontSize: 19,
                        fontStyle: FontStyle.italic,
                        fontWeight: FontWeight.w700,
                        color: AppColors.text,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Text(
            subtitle,
            style: GoogleFonts.dmMono(
              fontSize: 12,
              height: 1.55,
              color: Colors.white.withValues(alpha: 0.78),
            ),
          ),
          const SizedBox(height: 16),
          for (var i = 0; i < steps.length; i++) ...[
            _step(i + 1, steps[i], accent),
            if (i < steps.length - 1) const SizedBox(height: 10),
          ],
          if (pathA != null) ...[
            const SizedBox(height: 16),
            _pathChip(pathLabelA!, pathA),
            const SizedBox(height: 8),
            _pathChip(pathLabelB!, pathB!),
          ],
          if (closing != null) ...[
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              decoration: BoxDecoration(
                color: accent.withValues(alpha: 0.10),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                closing,
                style: GoogleFonts.dmMono(
                  fontSize: 11.5,
                  height: 1.5,
                  fontWeight: FontWeight.w500,
                  color: accent,
                ),
              ),
            ),
          ],
          if (footnote != null) ...[
            const SizedBox(height: 14),
            Text(
              footnote,
              style: GoogleFonts.dmMono(
                fontSize: 10.5,
                height: 1.5,
                color: AppColors.textFaint,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _step(int n, String text, Color accent) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 22,
          height: 22,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: accent.withValues(alpha: 0.14),
            shape: BoxShape.circle,
          ),
          child: Text(
            '$n',
            style: GoogleFonts.dmMono(
              fontSize: 10.5,
              fontWeight: FontWeight.w700,
              color: accent,
            ),
          ),
        ),
        const SizedBox(width: 11),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(top: 2),
            child: Text(
              text,
              style: GoogleFonts.dmMono(
                fontSize: 11.5,
                height: 1.5,
                color: Colors.white.withValues(alpha: 0.85),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _pathChip(String label, String path) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 9),
      decoration: BoxDecoration(
        color: AppColors.bgAlt,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.borderSub),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label.toUpperCase(),
                  style: GoogleFonts.dmMono(
                    fontSize: 8,
                    letterSpacing: 0.8,
                    color: AppColors.textFaint,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  path,
                  style: GoogleFonts.dmMono(
                    fontSize: 10,
                    color: AppColors.textMuted,
                  ),
                ),
              ],
            ),
          ),
          GestureDetector(
            onTap: () => Clipboard.setData(ClipboardData(text: path)),
            child: Icon(
              Icons.copy_rounded,
              size: 15,
              color: AppColors.textFaint,
            ),
          ),
        ],
      ),
    );
  }

  Widget _footerNote() {
    return Text(
      'No es una limitación de ValleySave: Google bloqueó este acceso para todas '
      'las apps. Por eso hace falta una de las dos vías.',
      textAlign: TextAlign.center,
      style: GoogleFonts.dmMono(
        fontSize: 10.5,
        height: 1.55,
        color: AppColors.textFaint.withValues(alpha: 0.8),
      ),
    );
  }
}
