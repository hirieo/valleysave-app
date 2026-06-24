import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../core/models/season_state.dart';
import '../../core/services/season_controller.dart';
import '../../core/theme/app_colors.dart';
import '../../shared/widgets/valley_canvas_widget.dart';
import '../onboarding/privacy_screen.dart';

class HowItWorksScreen extends StatefulWidget {
  const HowItWorksScreen({super.key, this.scrollToSection});
  final String? scrollToSection;

  @override
  State<HowItWorksScreen> createState() => _HowItWorksScreenState();
}

class _HowItWorksScreenState extends State<HowItWorksScreen> {
  static const _gamePath =
      'Android/data/com.chucklefish.stardewvalley/files/Saves';
  static const _bridgePath = 'Android/data/com.hirieo.valleysave/files';

  final _shizukuKey = GlobalKey();
  late ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (widget.scrollToSection == 'shizuku') {
        _scrollToShizuku();
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToShizuku() {
    final context = _shizukuKey.currentContext;
    if (context != null) {
      Scrollable.ensureVisible(context,
          duration: const Duration(milliseconds: 400),
          curve: Curves.easeInOut);
    }
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
                      controller: _scrollController,
                      padding: const EdgeInsets.fromLTRB(20, 8, 20, 48),
                      child: Center(
                        child: ConstrainedBox(
                          constraints: const BoxConstraints(maxWidth: 460),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              _sectionSync(),
                              const SizedBox(height: 12),
                              _sectionUpload(),
                              const SizedBox(height: 12),
                              _sectionDownload(),
                              const SizedBox(height: 12),
                              _sectionCompares(),
                              const SizedBox(height: 12),
                              _sectionConflicts(),
                              const SizedBox(height: 12),
                              _sectionDeletion(),
                              const SizedBox(height: 12),
                              _sectionCompatibility(),
                              const SizedBox(height: 28),
                              _androidDivider(),
                              const SizedBox(height: 16),
                              KeyedSubtree(
                                key: _shizukuKey,
                                child: _shizukuCard(season),
                              ),
                              const SizedBox(height: 16),
                              _bridgeCard(season),
                              const SizedBox(height: 28),
                              _privacyLink(context),
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

  // ── Header ────────────────────────────────────────────────────────────────

  Widget _header(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 10, 12, 6),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 492),
          child: Stack(
        alignment: Alignment.center,
        children: [
          const SizedBox(height: 36, width: double.infinity),
          Align(
            alignment: Alignment.centerLeft,
            child: GestureDetector(
              onTap: () => Navigator.pop(context),
              child: Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: Colors.black.withValues(alpha: 0.30),
                  shape: BoxShape.circle,
                  border:
                      Border.all(color: Colors.white.withValues(alpha: 0.15)),
                ),
                child: Icon(Icons.arrow_back_rounded,
                    size: 18, color: Colors.white.withValues(alpha: 0.70)),
              ),
            ),
          ),
          Text(
            'Cómo funciona',
            style: GoogleFonts.fraunces(
              fontSize: 24,
              fontStyle: FontStyle.italic,
              fontWeight: FontWeight.w700,
              color: Colors.white.withValues(alpha: 0.95),
            ),
          ),
        ],
          ),
        ),
      ),
    );
  }

  // ── Section: sync overview ────────────────────────────────────────────────

  Widget _sectionSync() {
    return _infoCard(
      icon: Icons.sync_rounded,
      color: AppColors.accent,
      title: 'Cómo se sincroniza',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'ValleySave usa tu propio Google Drive para mover partidas entre '
            'dispositivos. No hay servidores intermedios: los archivos son tuyos.',
            style: _body(),
          ),
          const SizedBox(height: 18),
          _flowDiagram(),
        ],
      ),
    );
  }

  Widget _flowDiagram() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _flowNode(Icons.smartphone_rounded, 'Tu\ndispositivo', AppColors.accent),
        _flowArrows(),
        _flowNode(Icons.cloud_rounded, 'Google\nDrive', const Color(0xFF4A90D9)),
        _flowArrows(),
        _flowNode(Icons.devices_rounded, 'Otro\ndispositivo', AppColors.green),
      ],
    );
  }

  Widget _flowNode(IconData icon, String label, Color color) {
    return Column(
      children: [
        Container(
          width: 52,
          height: 52,
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.12),
            borderRadius: BorderRadius.circular(13),
            border: Border.all(color: color.withValues(alpha: 0.30)),
          ),
          alignment: Alignment.center,
          child: Icon(icon, size: 24, color: color),
        ),
        const SizedBox(height: 7),
        Text(
          label,
          textAlign: TextAlign.center,
          style: GoogleFonts.dmMono(
            fontSize: 9.5,
            height: 1.4,
            color: Colors.white.withValues(alpha: 0.60),
          ),
        ),
      ],
    );
  }

  Widget _flowArrows() {
    return Padding(
      padding: const EdgeInsets.only(top: 15),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.arrow_back_rounded,
              size: 11, color: Colors.white.withValues(alpha: 0.22)),
          const SizedBox(width: 2),
          Icon(Icons.arrow_forward_rounded,
              size: 11, color: Colors.white.withValues(alpha: 0.22)),
        ],
      ),
    );
  }

  // ── Section: upload ───────────────────────────────────────────────────────

  Widget _sectionUpload() {
    return _infoCard(
      icon: Icons.cloud_upload_outlined,
      color: AppColors.accent,
      title: 'Subir una partida',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Al subir, ValleySave copia los dos archivos del save (SaveGameInfo '
            '+ archivo de granja) a tu carpeta ValleySave/ en Drive.',
            style: _body(),
          ),
          const SizedBox(height: 12),
          _tip(
            icon: Icons.visibility_outlined,
            text: 'Siempre se te muestra qué hay en Drive antes de sobrescribir, '
                'para que puedas comparar.',
          ),
          const SizedBox(height: 8),
          _tip(
            icon: Icons.warning_amber_rounded,
            color: AppColors.accent,
            text: 'Sin subir, ningún otro dispositivo verá tus avances recientes.',
          ),
        ],
      ),
    );
  }

  // ── Section: download ─────────────────────────────────────────────────────

  Widget _sectionDownload() {
    const blue = Color(0xFF4A90D9);
    return _infoCard(
      icon: Icons.cloud_download_outlined,
      color: blue,
      title: 'Descargar una partida',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Al descargar, ValleySave trae los archivos de Drive y los coloca '
            'directamente en la carpeta del juego.',
            style: _body(),
          ),
          const SizedBox(height: 12),
          _tip(
            icon: Icons.compare_arrows_rounded,
            color: blue,
            text: 'Verás la comparación entre local y Drive antes de confirmar.',
          ),
          const SizedBox(height: 8),
          _tip(
            icon: Icons.warning_amber_rounded,
            color: AppColors.accent,
            text: 'Descargar sobrescribe tu partida local. Si tienes avances '
                'que no has subido, los perderás.',
          ),
        ],
      ),
    );
  }

  // ── Section: what's compared ──────────────────────────────────────────────

  Widget _sectionCompares() {
    return _infoCard(
      icon: Icons.timer_outlined,
      color: AppColors.green,
      title: '¿Qué se compara?',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Para saber qué versión va más adelante, ValleySave usa el tiempo '
            'total jugado — el único dato que solo puede crecer.',
            style: _body(),
          ),
          const SizedBox(height: 14),
          _compareRow(true, 'Tiempo total jugado'),
          Divider(height: 18, color: Colors.white.withValues(alpha: 0.07)),
          Text(
            'Antes de confirmar también verás, para que lo valores tú:',
            style: GoogleFonts.dmMono(
              fontSize: 10.5,
              height: 1.4,
              color: Colors.white.withValues(alpha: 0.40),
            ),
          ),
          const SizedBox(height: 10),
          _shownRow('Dinero actual y total ganado'),
          const SizedBox(height: 6),
          _shownRow('Nivel de la mina'),
          const SizedBox(height: 6),
          _shownRow('Habilidades (cultivo, minería, combate...)'),
          const SizedBox(height: 6),
          _shownRow('Amigos, monstruos eliminados, desmayos'),
          const SizedBox(height: 6),
          _shownRow('Stamina y salud'),
          Divider(height: 18, color: Colors.white.withValues(alpha: 0.07)),
          _compareRow(false, 'Estado de cultivos y animales'),
          const SizedBox(height: 6),
          _compareRow(false, 'Inventario y objetos'),
          const SizedBox(height: 6),
          _compareRow(false, 'Relaciones individuales'),
          const SizedBox(height: 12),
          Text(
            'Estos no se muestran — cambian en cualquier dirección y no '
            'indican cuál save va más adelante.',
            style: GoogleFonts.dmMono(
              fontSize: 10.5,
              height: 1.5,
              fontStyle: FontStyle.italic,
              color: AppColors.textFaint,
            ),
          ),
        ],
      ),
    );
  }

  Widget _shownRow(String label) {
    const shownColor = Color(0xFF64AADC);
    return Row(
      children: [
        Icon(Icons.visibility_outlined,
            size: 14, color: shownColor.withValues(alpha: 0.80)),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            label,
            style: GoogleFonts.dmMono(
              fontSize: 11.5,
              color: shownColor.withValues(alpha: 0.80),
            ),
          ),
        ),
      ],
    );
  }

  Widget _compareRow(bool ok, String label) {
    const noColor = Color(0xFFB86060);
    final color = ok ? AppColors.green : noColor;
    return Row(
      children: [
        Icon(
          ok ? Icons.check_circle_rounded : Icons.cancel_rounded,
          size: 15,
          color: color,
        ),
        const SizedBox(width: 10),
        Text(
          label,
          style: GoogleFonts.dmMono(
            fontSize: 11.5,
            color: ok ? AppColors.green : noColor.withValues(alpha: 0.85),
            fontWeight: ok ? FontWeight.w600 : FontWeight.w400,
          ),
        ),
      ],
    );
  }

  // ── Section: conflicts ────────────────────────────────────────────────────

  Widget _sectionConflicts() {
    const orange = Color(0xFFE8783A);
    return _infoCard(
      icon: Icons.call_split_rounded,
      color: orange,
      title: 'Si juegas sin sincronizar',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Si avanzas en el móvil y en el PC sin sincronizar entre sesiones, '
            'acabas con dos versiones distintas del mismo save.',
            style: _body(),
          ),
          const SizedBox(height: 14),
          _conflictDiagram(orange),
          const SizedBox(height: 12),
          Text(
            'No se pueden mezclar. ValleySave siempre te muestra ambas versiones '
            'para que elijas cuál conservar.',
            style: _body(),
          ),
          const SizedBox(height: 10),
          _tip(
            icon: Icons.tips_and_updates_rounded,
            color: AppColors.accent,
            text: 'Sube siempre antes de cambiar de dispositivo y descarga al llegar.',
          ),
        ],
      ),
    );
  }

  Widget _conflictDiagram(Color orange) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: orange.withValues(alpha: 0.07),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: orange.withValues(alpha: 0.18)),
      ),
      child: Row(
        children: [
          Expanded(
            child: _conflictBox(
              icon: Icons.smartphone_rounded,
              platform: 'Móvil',
              version: 'versión A',
              color: orange,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Column(
              children: [
                Icon(Icons.compare_arrows_rounded,
                    size: 20, color: orange.withValues(alpha: 0.50)),
                const SizedBox(height: 4),
                Text(
                  '≠',
                  style: GoogleFonts.dmMono(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: orange.withValues(alpha: 0.55),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: _conflictBox(
              icon: Icons.computer_rounded,
              platform: 'PC',
              version: 'versión B',
              color: orange,
            ),
          ),
        ],
      ),
    );
  }

  Widget _conflictBox({
    required IconData icon,
    required String platform,
    required String version,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.20),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withValues(alpha: 0.28)),
      ),
      child: Column(
        children: [
          Icon(icon, size: 20, color: color),
          const SizedBox(height: 5),
          Text(
            platform,
            style: GoogleFonts.dmMono(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: color,
            ),
          ),
          Text(
            version,
            style: GoogleFonts.dmMono(
              fontSize: 9.5,
              color: color.withValues(alpha: 0.65),
            ),
          ),
        ],
      ),
    );
  }

  // ── Section: deletion ─────────────────────────────────────────────────────

  Widget _sectionDeletion() {
    const red = Color(0xFFE05252);
    return _infoCard(
      icon: Icons.delete_outline_rounded,
      color: red,
      title: 'Si se borra una partida',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Al eliminar una partida de Drive, no desaparece inmediatamente: '
            'va a la Papelera de Google Drive.',
            style: _body(),
          ),
          const SizedBox(height: 12),
          _tip(
            icon: Icons.restore_from_trash_rounded,
            color: AppColors.green,
            text: 'Tienes 30 días para restaurarla desde la Papelera de Drive '
                'antes de que se elimine definitivamente.',
          ),
          const SizedBox(height: 8),
          _tip(
            icon: Icons.block_rounded,
            color: red,
            text: 'ValleySave no puede recuperar partidas borradas definitivamente. '
                'Los archivos en Drive son tu responsabilidad.',
          ),
        ],
      ),
    );
  }

  // ── Section: compatibility ────────────────────────────────────────────────

  Widget _sectionCompatibility() {
    const amber = Color(0xFFE09020);
    return _infoCard(
      icon: Icons.warning_amber_rounded,
      color: amber,
      title: 'Compatibilidad entre plataformas',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _tip(
            icon: Icons.emoji_events_outlined,
            color: amber,
            text: 'Los logros de Steam y Google Play no se transfieren. '
                'Cada plataforma solo registra los logros que ocurren en ella '
                'en tiempo real — el save no los activa retroactivamente.',
          ),
          const SizedBox(height: 8),
          _tip(
            icon: Icons.sync_problem_rounded,
            color: amber,
            text: 'Si sincronizas desde dos dispositivos sin orden, una partida '
                'puede sobrescribir a otra. Sube siempre antes de descargar.',
          ),
          const SizedBox(height: 8),
          _tip(
            icon: Icons.system_update_alt_rounded,
            color: amber,
            text: 'Las partidas de versiones distintas del juego pueden no cargarse '
                'correctamente. ValleySave avisa si detecta una diferencia de '
                'versión antes de descargar.',
          ),
          const SizedBox(height: 8),
          _tip(
            icon: Icons.extension_rounded,
            color: amber,
            text: 'Los mods de SMAPI añaden datos extra al save. Si cargas una '
                'partida con mods en un dispositivo donde esos mods no están '
                'instalados, el juego puede fallar o perder datos del mod.\n\n'
                'En Android, SMAPI también puede instalarse para usar mods.',
          ),
        ],
      ),
    );
  }

  // ── Android divider ───────────────────────────────────────────────────────

  Widget _androidDivider() {
    return Row(
      children: [
        Expanded(child: Divider(color: Colors.white.withValues(alpha: 0.10))),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Text(
            'ACCESO EN ANDROID',
            style: GoogleFonts.dmMono(
              fontSize: 9,
              letterSpacing: 1.2,
              color: Colors.white.withValues(alpha: 0.35),
            ),
          ),
        ),
        Expanded(child: Divider(color: Colors.white.withValues(alpha: 0.10))),
      ],
    );
  }

  // ── Shizuku card ─────────────────────────────────────────────────────────

  Widget _shizukuCard(SeasonState season) {
    return _viaCard(
      seasonColor: SeasonData.data[season]!.accentColor,
      icon: Icons.bolt_rounded,
      accent: AppColors.accent,
      badge: 'AUTOMÁTICO · RECOMENDADO',
      title: 'Con Shizuku',
      subtitle: 'Se configura una sola vez. Después ValleySave sincroniza sola, '
          'sin que toques nada nunca más.',
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

  // ── Bridge card ───────────────────────────────────────────────────────────

  Widget _bridgeCard(SeasonState season) {
    return _viaCard(
      seasonColor: SeasonData.data[season]!.accentColor,
      icon: Icons.swap_horiz_rounded,
      accent: AppColors.green,
      badge: 'ALTERNATIVA MANUAL · ANDROID 11-12',
      title: 'Puente manual',
      subtitle: 'Solo funciona en Android 11 y 12. No instalas nada extra; '
          'a cambio, copias la partida a mano con tu app de Archivos cada vez '
          'que sincronizas.',
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

  // ── Generic info card ─────────────────────────────────────────────────────

  Widget _infoCard({
    required IconData icon,
    required Color color,
    required String title,
    required Widget child,
  }) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 16),
      decoration: BoxDecoration(
        color: Color.alphaBlend(
          color.withValues(alpha: 0.08),
          const Color(0xFF040405),
        ).withValues(alpha: 0.82),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withValues(alpha: 0.22)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 36,
                height: 36,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.12),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, size: 18, color: color),
              ),
              const SizedBox(width: 10),
              Text(
                title,
                style: GoogleFonts.fraunces(
                  fontSize: 17,
                  fontStyle: FontStyle.italic,
                  fontWeight: FontWeight.w700,
                  color: Colors.white.withValues(alpha: 0.95),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          child,
        ],
      ),
    );
  }

  Widget _tip({required IconData icon, required String text, Color? color}) {
    final c = color ?? Colors.white.withValues(alpha: 0.38);
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 1.5),
          child: Icon(icon, size: 14, color: c),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            text,
            style: GoogleFonts.dmMono(
              fontSize: 11,
              height: 1.5,
              color: Colors.white.withValues(alpha: 0.72),
            ),
          ),
        ),
      ],
    );
  }

  TextStyle _body() => GoogleFonts.dmMono(
        fontSize: 12,
        height: 1.55,
        color: Colors.white.withValues(alpha: 0.80),
      );

  // ── Via card (Shizuku / Bridge) ───────────────────────────────────────────

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
            _pathChip(pathLabelA!, pathA, accent),
            const SizedBox(height: 8),
            _pathChip(pathLabelB!, pathB!, accent),
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

  Widget _pathChip(String label, String path, Color accent) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 9),
      decoration: BoxDecoration(
        color: accent.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: accent.withValues(alpha: 0.22)),
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
            child: Icon(Icons.copy_rounded, size: 15, color: AppColors.textFaint),
          ),
        ],
      ),
    );
  }

  Widget _privacyLink(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => PrivacyScreen(onAccepted: () => Navigator.pop(context)),
        ),
      ),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.04),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.white.withValues(alpha: 0.10)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.shield_outlined,
              size: 15,
              color: Colors.white.withValues(alpha: 0.50),
            ),
            const SizedBox(width: 8),
            Text(
              'Política de privacidad y uso',
              style: GoogleFonts.dmMono(
                fontSize: 12,
                color: Colors.white.withValues(alpha: 0.50),
              ),
            ),
            const SizedBox(width: 6),
            Icon(
              Icons.chevron_right_rounded,
              size: 15,
              color: Colors.white.withValues(alpha: 0.30),
            ),
          ],
        ),
      ),
    );
  }
}
