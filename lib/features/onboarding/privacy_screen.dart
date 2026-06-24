import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../core/models/season_state.dart';
import '../../core/services/season_controller.dart';
import '../../core/theme/app_colors.dart';
import '../../shared/widgets/valley_canvas_widget.dart';

const _kAcceptedKey = 'privacy_accepted';

class PrivacyScreen extends StatelessWidget {
  const PrivacyScreen({super.key, this.onAccepted, this.viewOnly = false});
  final VoidCallback? onAccepted;
  final bool viewOnly;

  Future<void> _accept(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_kAcceptedKey, true);
    onAccepted?.call();
  }

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
                      Colors.black.withValues(alpha: 0.72),
                    ],
                  ),
                ),
              ),
            ),
            SafeArea(
              child: Column(
                children: [
                  // Header
                  Padding(
                    padding: const EdgeInsets.fromLTRB(24, 20, 24, 0),
                    child: Center(
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(maxWidth: 480),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Antes de empezar',
                              style: GoogleFonts.fraunces(
                                fontSize: 24,
                                fontStyle: FontStyle.italic,
                                fontWeight: FontWeight.w700,
                                color: Colors.white.withValues(alpha: 0.95),
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Lee y acepta la política de uso para continuar. · Última actualización: junio 2026',
                              style: GoogleFonts.dmMono(
                                fontSize: 11,
                                color: Colors.white.withValues(alpha: 0.45),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  // Content
                  Expanded(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.fromLTRB(24, 4, 24, 24),
                      child: Center(
                        child: ConstrainedBox(
                          constraints: const BoxConstraints(maxWidth: 480),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _section(
                                'Privacidad y uso de datos',
                                'ValleySave es una app open source para sincronizar tus partidas de Stardew Valley con tu propia cuenta de Google Drive.',
                              ),
                              _section(
                                'Qué datos usa',
                                'ValleySave accede únicamente a los archivos de guardado de Stardew Valley necesarios para hacer copias, sincronizarlas o restaurarlas.\n\nLa app no analiza tus partidas, no vende tus datos y no almacena información personal en servidores propios.',
                              ),
                              _section(
                                'Google Drive',
                                'Tus partidas se suben a tu propia cuenta de Google Drive. ValleySave no usa servidores propios para guardar tus partidas.\n\nLa app crea o utiliza la carpeta ValleySave/ en tu Drive. El acceso a Google Drive se usa solo para guardar, leer, actualizar o restaurar tus copias de seguridad.',
                              ),
                              _section(
                                'Permisos en Android',
                                'ValleySave puede necesitar permisos de almacenamiento o herramientas como Shizuku para acceder a los archivos de guardado. Estos permisos se usan solo para que la sincronización funcione.',
                              ),
                              _section(
                                'Anuncios',
                                'ValleySave puede mostrar anuncios mediante Google AdMob. AdMob puede usar el identificador de publicidad de tu dispositivo (GAID) para personalizar anuncios según la política de privacidad de Google (policies.google.com/privacy).\n\nPuedes desactivar la personalización de anuncios en Ajustes > Google > Anuncios.',
                              ),
                              _section(
                                'Responsabilidad',
                                'Tus archivos de guardado son responsabilidad tuya.\n\nAunque ValleySave intenta sincronizar de forma segura, no puede garantizar que no haya pérdidas o corrupciones en situaciones imprevistas. Por ejemplo, sincronizar desde dos dispositivos sin orden puede hacer que una partida sobrescriba a otra.\n\nRevisa siempre qué versión estás descargando antes de sobrescribir una partida local.',
                                highlight: true,
                              ),
                              _section(
                                'Eliminar datos',
                                'Puedes borrar tus copias sincronizadas eliminando manualmente la carpeta ValleySave/ de Google Drive.\n\nTambién puedes borrar los datos locales desde los ajustes de Android o desinstalar la app.',
                              ),
                              _section(
                                'Código abierto y contacto',
                                'ValleySave es un proyecto de código abierto bajo licencia Polyform Noncommercial. Puedes ver el código, estudiar cómo funciona y contribuir — pero no usarlo con fines comerciales.\n\ngithub.com/hirieo/valleysave-app',
                              ),
                              const SizedBox(height: 8),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  if (!viewOnly)
                  Padding(
                    padding: const EdgeInsets.fromLTRB(24, 8, 24, 24),
                    child: Center(
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(maxWidth: 480),
                        child: GestureDetector(
                          onTap: () => _accept(context),
                          child: Container(
                            width: double.infinity,
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: AppColors.accent.withValues(alpha: 0.15),
                              border: Border.all(
                                color: AppColors.accent.withValues(alpha: 0.55),
                              ),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              'Entendido, continuar',
                              style: GoogleFonts.dmMono(
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                                color: AppColors.accent,
                              ),
                            ),
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

  Widget _section(String title, String body, {bool highlight = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: highlight
              ? const Color(0xFFE05252).withValues(alpha: 0.07)
              : Colors.black.withValues(alpha: 0.38),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: highlight
                ? const Color(0xFFE05252).withValues(alpha: 0.25)
                : Colors.white.withValues(alpha: 0.07),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: GoogleFonts.fraunces(
                fontSize: 13,
                fontStyle: FontStyle.italic,
                fontWeight: FontWeight.w700,
                color: highlight
                    ? const Color(0xFFE05252).withValues(alpha: 0.90)
                    : AppColors.accent.withValues(alpha: 0.85),
              ),
            ),
            const SizedBox(height: 6),
            Text(
              body,
              style: GoogleFonts.dmMono(
                fontSize: 11,
                height: 1.6,
                color: Colors.white.withValues(alpha: 0.65),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

Future<bool> hasAcceptedPrivacy() async {
  final prefs = await SharedPreferences.getInstance();
  return prefs.getBool(_kAcceptedKey) ?? false;
}
