import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../core/models/season_settings.dart';
import '../../core/models/season_state.dart';
import '../../core/services/season_controller.dart';
import '../../core/services/season_service.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../shared/widgets/valley_canvas_widget.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key, this.showDisconnect = false});
  final bool showDisconnect;

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final _service  = SeasonService();
  SeasonSettings _settings = const SeasonSettings();
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final s = await _service.loadSettings();
    if (mounted) {
      setState(() {
        _settings = s;
        _loading  = false;
      });
    }
  }

  Future<void> _save(SeasonSettings s) async {
    setState(() => _settings = s);
    await _service.saveSettings(s);
    SeasonController.instance.init();
  }

  Future<void> _showDisconnectDialog() async {
    final confirm = await showDialog<bool>(
      context: context,
      barrierColor: Colors.black.withValues(alpha: 0.60),
      builder: (ctx) => Dialog(
        backgroundColor: Colors.transparent,
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 340),
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.black.withValues(alpha: 0.75),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.white.withValues(alpha: 0.10)),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '¿Desconectar Drive?',
                  style: AppTypography.bodyStrong(color: AppColors.text),
                ),
                const SizedBox(height: 6),
                Text(
                  'Tus saves en Drive no se borran. Podrás reconectarte cuando quieras.',
                  style: AppTypography.mono(color: AppColors.textMuted, size: 12),
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => Navigator.pop(ctx, false),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: Colors.white.withValues(alpha: 0.60),
                          side: BorderSide(color: Colors.white.withValues(alpha: 0.15)),
                          minimumSize: const Size(0, 40),
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          shape: const StadiumBorder(),
                        ),
                        child: Text(
                          'Cancelar',
                          style: AppTypography.mono(
                            size: 12,
                            color: Colors.white.withValues(alpha: 0.60),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => Navigator.pop(ctx, true),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: const Color(0xFFC06050),
                          side: BorderSide(
                            color: const Color(0xFFC06050).withValues(alpha: 0.45),
                          ),
                          backgroundColor: const Color(0xFFC06050).withValues(alpha: 0.08),
                          minimumSize: const Size(0, 40),
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          shape: const StadiumBorder(),
                        ),
                        child: Text(
                          'Desconectar',
                          style: AppTypography.mono(
                            size: 12,
                            color: const Color(0xFFC06050),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
    if (confirm == true && mounted) {
      Navigator.pop(context, 'disconnect');
    }
  }

  @override
  Widget build(BuildContext context) {
    final top = MediaQuery.of(context).padding.top;
    return Scaffold(
      backgroundColor: AppColors.bg,
      body: Stack(
        children: [
          // Canvas animado
          Positioned.fill(
            child: ValueListenableBuilder<SeasonState>(
              valueListenable: SeasonController.instance.season,
              builder: (_, season, _) => ValleyCanvasWidget(season: season),
            ),
          ),
          // Scrim igual que saves_screen
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
          if (!_loading)
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: top + 8),
                Padding(
                  padding: const EdgeInsets.fromLTRB(12, 10, 12, 6),
                  child: Center(
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 492),
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
                                border: Border.all(
                                  color: Colors.white.withValues(alpha: 0.15),
                                ),
                              ),
                              child: Icon(
                                Icons.arrow_back_rounded,
                                size: 18,
                                color: Colors.white.withValues(alpha: 0.70),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Center(
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(maxWidth: 480),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Opciones',
                          style: GoogleFonts.fraunces(
                            fontSize: 24,
                            fontStyle: FontStyle.italic,
                            fontWeight: FontWeight.w700,
                            color: Colors.white.withValues(alpha: 0.95),
                          ),
                        ),
                        const SizedBox(height: 24),
                        Text('MODO', style: AppTypography.eyebrow()),
                        const SizedBox(height: 12),
                        _modeTile(
                          SeasonMode.auto,
                          'Automático',
                          'Sigue tu partida activa y, sin partidas, tu ubicación real.',
                        ),
                        const SizedBox(height: 8),
                        _modeTile(
                          SeasonMode.savesOnly,
                          'Según partida',
                          'Usa siempre la estación de tu partida más reciente.',
                        ),
                        const SizedBox(height: 8),
                        _modeTile(
                          SeasonMode.geoOnly,
                          'Según ubicación',
                          'Usa siempre la estación real de tu ubicación.',
                        ),
                        const SizedBox(height: 8),
                        _modeTile(
                          SeasonMode.fixed,
                          'Fijar estación',
                          'Muestra siempre la misma estación.',
                        ),
                        const SizedBox(height: 8),
                        _modeTile(
                          SeasonMode.random,
                          'Aleatoria',
                          'Elige una estación diferente al abrir la app.',
                        ),
                        if (_settings.mode == SeasonMode.fixed) ...[
                          const SizedBox(height: 32),
                          Text('ESTACIÓN', style: AppTypography.eyebrow()),
                          const SizedBox(height: 12),
                          _seasonPicker(),
                        ],
                        if (_settings.mode == SeasonMode.auto) ...[
                          const SizedBox(height: 32),
                          _autoExplainer(),
                        ],
                        if (widget.showDisconnect) ...[
                          const SizedBox(height: 32),
                          GestureDetector(
                            onTap: _showDisconnectDialog,
                            child: Container(
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: const Color(0xFFC06050).withValues(alpha: 0.07),
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: const Color(0xFFC06050).withValues(alpha: 0.55),
                                  width: 1.5,
                                ),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.logout_rounded,
                                    size: 16,
                                    color: const Color(0xFFDC7864),
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    'Desconectar Drive',
                                    style: AppTypography.bodyStrong(
                                      color: const Color(0xFFDC7864),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                        const SizedBox(height: 48),
                      ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
        ],
      ),
    );
  }

  Widget _modeTile(SeasonMode mode, String label, String description) {
    final selected = _settings.mode == mode;
    return GestureDetector(
      onTap: () {
        SeasonSettings next;
        if (mode == SeasonMode.fixed) {
          next = SeasonSettings(
            mode: mode,
            fixedSeason: _settings.fixedSeason ?? SeasonState.initial,
          );
        } else {
          next = _settings.copyWith(mode: mode);
        }
        _save(next);
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: selected
              ? Color.alphaBlend(
                  AppColors.accent.withValues(alpha: 0.16),
                  const Color(0xFF040405),
                ).withValues(alpha: 0.68)
              : Colors.black.withValues(alpha: 0.45),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: selected
                ? AppColors.accent.withValues(alpha: 0.60)
                : Colors.white.withValues(alpha: 0.10),
          ),
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: AppTypography.bodyStrong(
                      color: selected ? AppColors.accent : AppColors.text,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(description, style: AppTypography.body()),
                ],
              ),
            ),
            const SizedBox(width: 16),
            _radio(selected),
          ],
        ),
      ),
    );
  }

  Widget _radio(bool selected) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      width: 20,
      height: 20,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: selected ? AppColors.accent : Colors.transparent,
        border: Border.all(
          color: selected ? AppColors.accent : Colors.white.withValues(alpha: 0.20),
          width: selected ? 0 : 2,
        ),
      ),
      child: selected
          ? const Icon(Icons.check_rounded, size: 13, color: Colors.black)
          : null,
    );
  }

  Widget _seasonPicker() {
    const seasons = [
      (SeasonState.initial, '✨ Inicial'),
      (SeasonState.spring,  '🌸 Primavera'),
      (SeasonState.summer,  '☀️ Verano'),
      (SeasonState.fall,    '🍂 Otoño'),
      (SeasonState.winter,  '❄️ Invierno'),
    ];
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: seasons.map((entry) {
        final (s, label) = entry;
        final selected = _settings.fixedSeason == s;
        final accent   = SeasonData.data[s]!.accentColor;
        return GestureDetector(
          onTap: () => _save(SeasonSettings(
            mode: SeasonMode.fixed,
            fixedSeason: s,
          )),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 180),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            decoration: BoxDecoration(
              color: selected
                  ? Color.alphaBlend(
                      accent.withValues(alpha: 0.20),
                      const Color(0xFF040405),
                    ).withValues(alpha: 0.70)
                  : Colors.black.withValues(alpha: 0.45),
              borderRadius: BorderRadius.circular(999),
              border: Border.all(
                color: selected
                    ? accent.withValues(alpha: 0.75)
                    : Colors.white.withValues(alpha: 0.10),
              ),
            ),
            child: Text(
              label,
              style: AppTypography.eyebrow(
                color: selected ? accent : AppColors.textMuted,
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _autoExplainer() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.45),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Orden de prioridad', style: AppTypography.eyebrow()),
          const SizedBox(height: 12),
          _step('1', 'Primera apertura', 'Muestra el estado inicial.'),
          const SizedBox(height: 10),
          _step('2', 'Partida activa', 'Usa la estación de tu última partida sincronizada.'),
          const SizedBox(height: 10),
          _step('3', 'Ubicación', 'Detecta tu hemisferio y la estación real de tu región.'),
          const SizedBox(height: 10),
          _step('4', 'Por defecto', 'Inicial (modo nocturno) si no hay ningún dato disponible.'),
        ],
      ),
    );
  }

  Widget _step(String num, String title, String desc) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 20,
          height: 20,
          decoration: BoxDecoration(
            color: AppColors.accent.withValues(alpha: 0.12),
            shape: BoxShape.circle,
            border: Border.all(color: AppColors.accent.withValues(alpha: 0.35)),
          ),
          child: Center(
            child: Text(
              num,
              style: AppTypography.mono(
                color: AppColors.accent,
                size: 10,
              ),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: AppTypography.bodyStrong()),
              Text(desc,  style: AppTypography.body()),
            ],
          ),
        ),
      ],
    );
  }
}
