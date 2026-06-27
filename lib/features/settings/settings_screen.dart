import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:package_info_plus/package_info_plus.dart';

import '../../generated/app_localizations.dart';

import '../../core/models/season_settings.dart';
import '../../core/models/season_state.dart';
import '../../core/services/locale_controller.dart';
import '../../core/services/season_controller.dart';
import '../../core/services/season_service.dart';
import '../../core/services/update_service.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../shared/widgets/icon_circle_button.dart';
import '../../shared/widgets/valley_canvas_widget.dart';

enum _UpdateState { idle, checking, upToDate, available }

const _kLangs = [
  (null,            '🌐', 'Auto · sistema'),
  (Locale('es'),    '🇪🇸', 'Español'),
  (Locale('en'),    '🇬🇧', 'English'),
  (Locale('fr'),    '🇫🇷', 'Français'),
  (Locale('de'),    '🇩🇪', 'Deutsch'),
  (Locale('it'),    '🇮🇹', 'Italiano'),
  (Locale('pt'),    '🇵🇹', 'Português'),
  (Locale('ru'),    '🇷🇺', 'Русский'),
  (Locale('uk'),    '🇺🇦', 'Українська'),
  (Locale('ja'),    '🇯🇵', '日本語'),
  (Locale('zh'),    '🇨🇳', '中文'),
  (Locale('th'),    '🇹🇭', 'ไทย'),
  (Locale('ko'),    '🇰🇷', '한국어'),
];

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key, this.showDisconnect = false});
  final bool showDisconnect;

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen>
    with TickerProviderStateMixin {
  final _service  = SeasonService();
  SeasonSettings _settings = const SeasonSettings();
  bool _loading = true;
  _UpdateState _updateState = _UpdateState.idle;
  String _appVersion = '';
  String? _availableVersion;
  bool _updateTilePressed = false;

  late final AnimationController _entranceCtrl;
  late final Animation<double> _contentAnim;
  bool _disconnectPressed = false;
  bool _langTilePressed = false;
  SeasonMode? _pressedMode;
  SeasonState? _pressedSeason;

  @override
  void initState() {
    super.initState();
    _load();
    _loadVersion();
    _entranceCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 480),
    )..forward();
    _contentAnim = CurvedAnimation(
      parent: _entranceCtrl,
      curve: const Cubic(0.23, 1, 0.32, 1),
    );
  }

  @override
  void dispose() {
    _entranceCtrl.dispose();
    super.dispose();
  }

  Future<void> _loadVersion() async {
    final info = await PackageInfo.fromPlatform();
    if (mounted) setState(() => _appVersion = info.version);
  }

  Future<void> _checkUpdateFromSettings() async {
    if (_updateState == _UpdateState.checking) return;
    setState(() => _updateState = _UpdateState.checking);
    final version = await UpdateService.checkForUpdate();
    if (!mounted) return;
    if (version != null) {
      setState(() {
        _updateState    = _UpdateState.available;
        _availableVersion = version;
      });
    } else {
      setState(() => _updateState = _UpdateState.upToDate);
    }
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
    final l10n = AppLocalizations.of(context)!;
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
                          l10n.cancel,
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
                          l10n.disconnect,
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
    final l10n = AppLocalizations.of(context)!;
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
            AnimatedBuilder(
              animation: _contentAnim,
              builder: (_, child) => Opacity(
                opacity: _contentAnim.value,
                child: Transform.translate(
                  offset: Offset(0, 10 * (1 - _contentAnim.value)),
                  child: child,
                ),
              ),
              child: Column(
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
                            IconCircleButton(
                              icon: Icons.arrow_back_rounded,
                              onTap: () => Navigator.pop(context),
                            ),
                            const Spacer(),
                            Text(
                              'Opciones',
                              style: GoogleFonts.bodoniModa(
                                fontSize: 24,
                                fontStyle: FontStyle.italic,
                                fontWeight: FontWeight.w700,
                                color: Colors.white.withValues(alpha: 0.92),
                              ),
                            ),
                            const Spacer(),
                            const SizedBox(width: 36),
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
                          const SizedBox(height: 32),
                          Text('IDIOMA', style: AppTypography.eyebrow()),
                          const SizedBox(height: 12),
                          ValueListenableBuilder<Locale?>(
                            valueListenable: LocaleController.instance.locale,
                            builder: (_, current, _) => _languageTile(current),
                          ),
                          const SizedBox(height: 32),
                          Text(l10n.application.toUpperCase(), style: AppTypography.eyebrow()),
                          const SizedBox(height: 12),
                          _versionTile(),
                          const SizedBox(height: 8),
                          _updateTile(SeasonData.data[SeasonController.instance.season.value]!.accentColor, l10n),
                          if (widget.showDisconnect) ...[
                            const SizedBox(height: 32),
                            _disconnectButton(),
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
      onTapDown: (_) => setState(() => _pressedMode = mode),
      onTapUp: (_) => setState(() => _pressedMode = null),
      onTapCancel: () => setState(() => _pressedMode = null),
      child: AnimatedScale(
        scale: _pressedMode == mode ? 0.97 : 1.0,
        duration: _pressedMode == mode
            ? const Duration(milliseconds: 100)
            : const Duration(milliseconds: 200),
        curve: const Cubic(0.23, 1, 0.32, 1),
        child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeOut,
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
      ),
    );
  }

  Widget _radio(bool selected) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      curve: Curves.easeOut,
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
          onTapDown: (_) => setState(() => _pressedSeason = s),
          onTapUp: (_) => setState(() => _pressedSeason = null),
          onTapCancel: () => setState(() => _pressedSeason = null),
          child: AnimatedScale(
            scale: _pressedSeason == s ? 0.95 : 1.0,
            duration: _pressedSeason == s
                ? const Duration(milliseconds: 100)
                : const Duration(milliseconds: 200),
            curve: const Cubic(0.23, 1, 0.32, 1),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 180),
              curve: Curves.easeOut,
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

  Widget _versionTile() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.45),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white.withValues(alpha: 0.10)),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text('Versión instalada', style: AppTypography.bodyStrong()),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.06),
              borderRadius: BorderRadius.circular(6),
              border: Border.all(color: Colors.white.withValues(alpha: 0.10)),
            ),
            child: Text(
              _appVersion.isEmpty ? '—' : _appVersion,
              style: AppTypography.mono(color: AppColors.textFaint, size: 12),
            ),
          ),
        ],
      ),
    );
  }

  Widget _updateTile(Color accent, AppLocalizations l10n) {
    final Widget content;
    switch (_updateState) {
      case _UpdateState.idle:
        content = Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(l10n.checkForUpdates, style: AppTypography.bodyStrong()),
                  Text('Nunca comprobado', style: AppTypography.mono(color: AppColors.textFaint, size: 11)),
                ],
              ),
            ),
            const SizedBox(width: 12),
            Icon(Icons.refresh_rounded, size: 16, color: AppColors.textFaint),
          ],
        );
      case _UpdateState.checking:
        content = Row(
          children: [
            Expanded(child: Text(l10n.checkingUpdates, style: AppTypography.bodyStrong())),
            const SizedBox(
              width: 16, height: 16,
              child: CircularProgressIndicator(strokeWidth: 1.5, color: AppColors.textFaint),
            ),
          ],
        );
      case _UpdateState.upToDate:
        content = Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(l10n.upToDate, style: AppTypography.bodyStrong(color: AppColors.statusOk)),
                  Text('Comprobado ahora', style: AppTypography.mono(color: AppColors.textFaint, size: 11)),
                ],
              ),
            ),
            const SizedBox(width: 12),
            Icon(Icons.check_rounded, size: 16, color: AppColors.statusOk),
          ],
        );
      case _UpdateState.available:
        content = Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('v$_availableVersion disponible', style: AppTypography.bodyStrong(color: accent)),
                  Text('No está al día · Descargar', style: AppTypography.mono(color: AppColors.textFaint, size: 11)),
                ],
              ),
            ),
            const SizedBox(width: 12),
            Icon(Icons.download_rounded, size: 16, color: accent),
          ],
        );
    }

    final isTappable = _updateState == _UpdateState.idle || _updateState == _UpdateState.available;

    return GestureDetector(
      onTap: _updateState == _UpdateState.available
          ? () => UpdateService.openReleasePage()
          : _updateState == _UpdateState.idle
              ? _checkUpdateFromSettings
              : null,
      onTapDown: isTappable ? (_) => setState(() => _updateTilePressed = true) : null,
      onTapUp:   isTappable ? (_) => setState(() => _updateTilePressed = false) : null,
      onTapCancel: isTappable ? () => setState(() => _updateTilePressed = false) : null,
      child: AnimatedScale(
        scale: _updateTilePressed ? 0.97 : 1.0,
        duration: _updateTilePressed
            ? const Duration(milliseconds: 100)
            : const Duration(milliseconds: 200),
        curve: const Cubic(0.23, 1, 0.32, 1),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeOut,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: _updateState == _UpdateState.available
                ? Color.alphaBlend(accent.withValues(alpha: 0.06), Colors.black.withValues(alpha: 0.45))
                : Colors.black.withValues(alpha: 0.45),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: _updateState == _UpdateState.available
                  ? accent.withValues(alpha: 0.38)
                  : Colors.white.withValues(alpha: 0.10),
            ),
          ),
          child: content,
        ),
      ),
    );
  }

  bool _langMatch(Locale? a, Locale? b) {
    if (a == null && b == null) return true;
    if (a == null || b == null) return false;
    return a.languageCode == b.languageCode;
  }

  (String, String) _langLabel(Locale? current) {
    if (current == null) return ('🌐', 'Auto');
    for (final (locale, flag, label) in _kLangs) {
      if (locale != null && locale.languageCode == current.languageCode) {
        return (flag, label);
      }
    }
    return ('🌐', 'Auto');
  }

  Widget _languageTile(Locale? current) {
    final (flag, label) = _langLabel(current);
    final accent = SeasonData.data[SeasonController.instance.season.value]!.accentColor;
    return GestureDetector(
      onTap: () => _openLanguageDialog(context),
      onTapDown: (_) => setState(() => _langTilePressed = true),
      onTapUp: (_) => setState(() => _langTilePressed = false),
      onTapCancel: () => setState(() => _langTilePressed = false),
      child: AnimatedScale(
        scale: _langTilePressed ? 0.97 : 1.0,
        duration: _langTilePressed
            ? const Duration(milliseconds: 100)
            : const Duration(milliseconds: 200),
        curve: const Cubic(0.23, 1, 0.32, 1),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.black.withValues(alpha: 0.45),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.white.withValues(alpha: 0.10)),
          ),
          child: Row(
            children: [
              Expanded(
                child: Text('Idioma', style: AppTypography.bodyStrong()),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                  color: accent.withValues(alpha: 0.10),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: accent.withValues(alpha: 0.35)),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(flag, style: const TextStyle(fontSize: 13)),
                    const SizedBox(width: 6),
                    Text(label, style: AppTypography.mono(color: accent, size: 12)),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              Icon(Icons.chevron_right_rounded, size: 18, color: AppColors.textFaint),
            ],
          ),
        ),
      ),
    );
  }

  void _openLanguageDialog(BuildContext context) {
    final accent = SeasonData.data[SeasonController.instance.season.value]!.accentColor;
    showGeneralDialog<void>(
      context: context,
      barrierDismissible: true,
      barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
      barrierColor: Colors.black.withValues(alpha: 0.60),
      transitionDuration: const Duration(milliseconds: 240),
      transitionBuilder: (ctx, anim, _, child) {
        final curved = CurvedAnimation(
          parent: anim,
          curve: const Cubic(0.23, 1, 0.32, 1),
          reverseCurve: const Cubic(0.23, 1, 0.32, 1),
        );
        return ScaleTransition(
          scale: Tween<double>(begin: 0.95, end: 1.0).animate(curved),
          child: FadeTransition(opacity: curved, child: child),
        );
      },
      pageBuilder: (ctx, _, _) => _LanguageDialog(
        current: LocaleController.instance.locale.value,
        langs: _kLangs,
        onSelect: (locale) {
          LocaleController.instance.set(locale);
          Navigator.pop(ctx);
        },
        langMatch: _langMatch,
        accent: accent,
      ),
    );
  }

  Widget _disconnectButton() {
    return GestureDetector(
      onTap: _showDisconnectDialog,
      onTapDown: (_) => setState(() => _disconnectPressed = true),
      onTapUp: (_) => setState(() => _disconnectPressed = false),
      onTapCancel: () => setState(() => _disconnectPressed = false),
      child: AnimatedScale(
        scale: _disconnectPressed ? 0.97 : 1.0,
        duration: _disconnectPressed
            ? const Duration(milliseconds: 100)
            : const Duration(milliseconds: 200),
        curve: const Cubic(0.23, 1, 0.32, 1),
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
    );
  }
}

// ── Language dialog ───────────────────────────────────────────────────────────

class _LanguageDialog extends StatefulWidget {
  const _LanguageDialog({
    required this.current,
    required this.langs,
    required this.onSelect,
    required this.langMatch,
    required this.accent,
  });

  final Locale? current;
  final List<(Locale?, String, String)> langs;
  final void Function(Locale?) onSelect;
  final bool Function(Locale?, Locale?) langMatch;
  final Color accent;

  @override
  State<_LanguageDialog> createState() => _LanguageDialogState();
}

class _LanguageDialogState extends State<_LanguageDialog>
    with SingleTickerProviderStateMixin {
  final _search = TextEditingController();
  String _query = '';
  late final AnimationController _staggerCtrl;

  @override
  void initState() {
    super.initState();
    _staggerCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    )..forward();
  }

  @override
  void dispose() {
    _search.dispose();
    _staggerCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final filtered = widget.langs.where((e) {
      if (_query.isEmpty) return true;
      return e.$3.toLowerCase().contains(_query);
    }).toList();

    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 32, vertical: 48),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 340),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.black.withValues(alpha: 0.55),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: widget.accent.withValues(alpha: 0.35)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 14, 12, 10),
                child: Row(
                  children: [
                    Text('IDIOMA', style: AppTypography.eyebrow()),
                    const Spacer(),
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: Icon(
                        Icons.close_rounded,
                        size: 18,
                        color: AppColors.textFaint,
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: 0.40),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Colors.white.withValues(alpha: 0.10)),
                  ),
                  child: Row(
                    children: [
                      const SizedBox(width: 12),
                      Icon(Icons.search_rounded, size: 16, color: AppColors.textFaint),
                      const SizedBox(width: 8),
                      Expanded(
                        child: TextField(
                          controller: _search,
                          onChanged: (v) => setState(() => _query = v.toLowerCase()),
                          style: AppTypography.body(color: AppColors.text),
                          decoration: InputDecoration(
                            hintText: 'Buscar idioma…',
                            hintStyle: AppTypography.body(color: AppColors.textFaint),
                            border: InputBorder.none,
                            contentPadding: const EdgeInsets.symmetric(vertical: 10),
                          ),
                        ),
                      ),
                      if (_query.isNotEmpty)
                        GestureDetector(
                          onTap: () {
                            _search.clear();
                            setState(() => _query = '');
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(8),
                            child: Icon(
                              Icons.close_rounded,
                              size: 14,
                              color: AppColors.textFaint,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 4),
              ConstrainedBox(
                constraints: BoxConstraints(
                  maxHeight: MediaQuery.of(context).size.height * 0.45,
                ),
                child: ListView.builder(
                  shrinkWrap: true,
                  padding: const EdgeInsets.fromLTRB(8, 2, 8, 12),
                  itemCount: filtered.length,
                  itemBuilder: (_, i) {
                    final (locale, flag, label) = filtered[i];
                    final selected = widget.langMatch(widget.current, locale);
                    return _LangRow(
                      flag: flag,
                      label: label,
                      isAuto: locale == null,
                      selected: selected,
                      accent: widget.accent,
                      staggerIndex: i,
                      staggerCtrl: _staggerCtrl,
                      onTap: () => widget.onSelect(locale),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _LangRow extends StatefulWidget {
  const _LangRow({
    required this.flag,
    required this.label,
    required this.isAuto,
    required this.selected,
    required this.accent,
    required this.staggerIndex,
    required this.staggerCtrl,
    required this.onTap,
  });

  final String flag;
  final String label;
  final bool isAuto;
  final bool selected;
  final Color accent;
  final int staggerIndex;
  final AnimationController staggerCtrl;
  final VoidCallback onTap;

  @override
  State<_LangRow> createState() => _LangRowState();
}

class _LangRowState extends State<_LangRow> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    final start = (widget.staggerIndex * 0.06).clamp(0.0, 0.9);
    final end = (start + 0.50).clamp(start + 0.1, 1.0);
    final staggerAnim = CurvedAnimation(
      parent: widget.staggerCtrl,
      curve: Interval(start, end, curve: const Cubic(0.23, 1, 0.32, 1)),
    );

    return AnimatedBuilder(
      animation: staggerAnim,
      builder: (_, child) => Opacity(
        opacity: staggerAnim.value,
        child: Transform.translate(
          offset: Offset(0, 5 * (1 - staggerAnim.value)),
          child: child,
        ),
      ),
      child: GestureDetector(
        onTap: widget.onTap,
        onTapDown: (_) => setState(() => _pressed = true),
        onTapUp: (_) => setState(() => _pressed = false),
        onTapCancel: () => setState(() => _pressed = false),
        child: AnimatedScale(
          scale: _pressed ? 0.985 : 1.0,
          duration: _pressed
              ? const Duration(milliseconds: 80)
              : const Duration(milliseconds: 200),
          curve: const Cubic(0.23, 1, 0.32, 1),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 160),
            curve: Curves.easeOut,
            margin: const EdgeInsets.symmetric(vertical: 2),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 13),
            decoration: BoxDecoration(
              color: widget.selected
                  ? widget.accent.withValues(alpha: 0.10)
                  : _pressed
                      ? Colors.white.withValues(alpha: 0.04)
                      : Colors.transparent,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              children: [
                Text(widget.flag, style: const TextStyle(fontSize: 18)),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.label,
                        style: AppTypography.bodyStrong(
                          color: widget.selected ? widget.accent : AppColors.text,
                        ),
                      ),
                      if (widget.isAuto)
                        Text(
                          'Usa el idioma del sistema',
                          style: AppTypography.mono(
                            color: AppColors.textFaint,
                            size: 11,
                          ),
                        ),
                    ],
                  ),
                ),
                AnimatedOpacity(
                  opacity: widget.selected ? 1.0 : 0.0,
                  duration: const Duration(milliseconds: 180),
                  child: AnimatedScale(
                    scale: widget.selected ? 1.0 : 0.5,
                    duration: const Duration(milliseconds: 200),
                    curve: const Cubic(0.23, 1, 0.32, 1),
                    child: Icon(
                      Icons.check_rounded,
                      size: 18,
                      color: widget.accent,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
