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
import '../../shared/widgets/update_download_animation.dart';
import '../../shared/widgets/valley_canvas_widget.dart';

enum _UpdateState { idle, checking, upToDate, available, downloading, error }

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
  UpdateInfo? _updateInfo;
  double _downloadProgress = 0;
  final _progressNotifier = ValueNotifier<double>(0);
  bool _updateTilePressed = false;

  late final AnimationController _entranceCtrl;
  late final Animation<double> _contentAnim;
  bool _disconnectPressed = false;
  bool _langTilePressed = false;
  bool _modeDropdownOpen = false;
  bool _ddTrigPressed = false;
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
    _progressNotifier.dispose();
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
    final info = await UpdateService.checkForUpdate();
    if (!mounted) return;
    if (info != null) {
      setState(() {
        _updateState = _UpdateState.available;
        _updateInfo  = info;
      });
    } else {
      setState(() => _updateState = _UpdateState.upToDate);
    }
  }

  Future<void> _startInstall() async {
    final info = _updateInfo;
    if (info == null) return;
    _progressNotifier.value = 0;
    setState(() {
      _updateState      = _UpdateState.downloading;
      _downloadProgress = 0;
    });
    showUpdateDownloadDialog(
      context,
      progressNotifier: _progressNotifier,
      season: SeasonController.instance.season.value,
      version: info.version,
    );
    await UpdateService.installUpdate(
      info,
      onProgress: (p) {
        _progressNotifier.value = p;
        if (mounted) setState(() => _downloadProgress = p);
      },
      onError: (e) {
        if (mounted) {
          Navigator.of(context, rootNavigator: true).maybePop();
          setState(() => _updateState = _UpdateState.error);
        }
      },
    );
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
                  l10n.disconnectTitle,
                  style: AppTypography.bodyStrong(color: AppColors.text),
                ),
                const SizedBox(height: 6),
                Text(
                  l10n.disconnectBody,
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
    final accent = SeasonData.data[SeasonController.instance.season.value]!.accentColor;
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
                              l10n.settings.toUpperCase(),
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
                          Text(l10n.sectionLanguage.toUpperCase(), style: AppTypography.eyebrow()),
                          const SizedBox(height: 12),
                          ValueListenableBuilder<Locale?>(
                            valueListenable: LocaleController.instance.locale,
                            builder: (_, current, _) => _languageTile(current, l10n),
                          ),
                          const SizedBox(height: 32),
                          Text(l10n.sectionMode.toUpperCase(), style: AppTypography.eyebrow()),
                          const SizedBox(height: 12),
                          _modeDropdown(accent, l10n),
                          _modeExplainer(accent, l10n),
                          if (_settings.mode == SeasonMode.fixed) ...[
                            const SizedBox(height: 32),
                            Text(l10n.sectionSeason.toUpperCase(), style: AppTypography.eyebrow()),
                            const SizedBox(height: 12),
                            _seasonPicker(l10n),
                          ],
                          const SizedBox(height: 32),
                          Text(l10n.application.toUpperCase(), style: AppTypography.eyebrow()),
                          const SizedBox(height: 12),
                          _versionTile(l10n),
                          const SizedBox(height: 8),
                          _updateTile(SeasonData.data[SeasonController.instance.season.value]!.accentColor, l10n),
                          if (widget.showDisconnect) ...[
                            const SizedBox(height: 32),
                            _disconnectButton(l10n),
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

  Widget _modeDropdown(Color accent, AppLocalizations l10n) {
    final modes = [
      (SeasonMode.auto,      'AUT', l10n.modeAutoTitle),
      (SeasonMode.savesOnly, 'SAV', l10n.modeSavesTitle),
      (SeasonMode.geoOnly,   'GEO', l10n.modeGeoTitle),
      (SeasonMode.fixed,     'FIX', l10n.modeFixedTitle),
      (SeasonMode.random,    'RND', l10n.modeRandomTitle),
    ];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        GestureDetector(
          onTap: () => setState(() => _modeDropdownOpen = !_modeDropdownOpen),
          onTapDown: (_) => setState(() => _ddTrigPressed = true),
          onTapUp: (_) => setState(() => _ddTrigPressed = false),
          onTapCancel: () => setState(() => _ddTrigPressed = false),
          child: AnimatedScale(
            scale: _ddTrigPressed ? 0.97 : 1.0,
            duration: _ddTrigPressed
                ? const Duration(milliseconds: 100)
                : const Duration(milliseconds: 200),
            curve: const Cubic(0.23, 1, 0.32, 1),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 250),
              curve: Curves.easeOut,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              decoration: BoxDecoration(
                color: _modeDropdownOpen
                    ? Colors.black.withValues(alpha: 0.70)
                    : Colors.black.withValues(alpha: 0.45),
                borderRadius: BorderRadius.only(
                  topLeft: const Radius.circular(12),
                  topRight: const Radius.circular(12),
                  bottomLeft: Radius.circular(_modeDropdownOpen ? 0 : 12),
                  bottomRight: Radius.circular(_modeDropdownOpen ? 0 : 12),
                ),
                border: Border.all(
                  color: _modeDropdownOpen
                      ? accent.withValues(alpha: 0.45)
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
                          l10n.sectionMode.toUpperCase(),
                          style: AppTypography.mono(color: AppColors.textFaint, size: 9),
                        ),
                        const SizedBox(height: 3),
                        Text(
                          _currentModeLabel(l10n),
                          style: AppTypography.bodyStrong(color: accent),
                        ),
                      ],
                    ),
                  ),
                  AnimatedRotation(
                    turns: _modeDropdownOpen ? 0.5 : 0.0,
                    duration: const Duration(milliseconds: 350),
                    curve: const Cubic(0.23, 1, 0.32, 1),
                    child: Icon(
                      Icons.keyboard_arrow_down_rounded,
                      color: _modeDropdownOpen
                          ? accent
                          : Colors.white.withValues(alpha: 0.28),
                      size: 22,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        AnimatedSize(
          duration: const Duration(milliseconds: 420),
          curve: const Cubic(0.23, 1, 0.32, 1),
          alignment: Alignment.topCenter,
          child: _modeDropdownOpen
              ? Container(
                  decoration: BoxDecoration(
                    color: const Color(0xFF03080A).withValues(alpha: 0.97),
                    borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(14),
                      bottomRight: Radius.circular(14),
                    ),
                    border: Border(
                      top: BorderSide(color: accent, width: 1.5),
                      left: BorderSide(color: accent.withValues(alpha: 0.28)),
                      right: BorderSide(color: accent.withValues(alpha: 0.28)),
                      bottom: BorderSide(color: accent.withValues(alpha: 0.28)),
                    ),
                  ),
                  child: Column(
                    children: [
                      for (int i = 0; i < modes.length; i++) ...[
                        if (i > 0)
                          Divider(
                            height: 0,
                            thickness: 0.5,
                            color: Colors.white.withValues(alpha: 0.05),
                          ),
                        _modeListItem(
                          modes[i].$1,
                          modes[i].$2,
                          modes[i].$3,
                          _settings.mode == modes[i].$1,
                          accent,
                        ),
                      ],
                    ],
                  ),
                )
              : const SizedBox.shrink(),
        ),
      ],
    );
  }

  Widget _modeListItem(
      SeasonMode mode, String badge, String label, bool selected, Color accent) {
    return GestureDetector(
      onTap: () {
        final next = mode == SeasonMode.fixed
            ? SeasonSettings(
                mode: mode,
                fixedSeason: _settings.fixedSeason ?? SeasonState.initial,
              )
            : _settings.copyWith(mode: mode);
        setState(() => _modeDropdownOpen = false);
        _save(next);
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeOut,
        decoration: BoxDecoration(
          color: selected ? Colors.white.withValues(alpha: 0.05) : Colors.transparent,
        ),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 11),
        child: Row(
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              curve: Curves.easeOut,
              width: 34,
              height: 20,
              decoration: BoxDecoration(
                color: selected
                    ? accent.withValues(alpha: 0.15)
                    : Colors.white.withValues(alpha: 0.06),
                borderRadius: BorderRadius.circular(4),
                border: Border.all(
                  color: selected
                      ? accent.withValues(alpha: 0.45)
                      : Colors.white.withValues(alpha: 0.10),
                ),
              ),
              child: Center(
                child: Text(
                  badge,
                  style: AppTypography.mono(
                    color: selected ? accent : AppColors.textFaint,
                    size: 9,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                label,
                style: selected
                    ? AppTypography.bodyStrong(color: accent)
                    : AppTypography.body(color: AppColors.text.withValues(alpha: 0.55)),
              ),
            ),
            AnimatedOpacity(
              opacity: selected ? 1.0 : 0.0,
              duration: const Duration(milliseconds: 200),
              child: Icon(Icons.check_rounded, size: 16, color: accent),
            ),
          ],
        ),
      ),
    );
  }

  Widget _modeExplainer(Color accent, AppLocalizations l10n) {
    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 280),
        transitionBuilder: (child, anim) => FadeTransition(opacity: anim, child: child),
        child: _settings.mode == SeasonMode.auto
            ? KeyedSubtree(
                key: const ValueKey('auto'),
                child: _autoExplainer(accent, l10n),
              )
            : Container(
                key: ValueKey(_settings.mode),
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: accent.withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: accent.withValues(alpha: 0.30)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _currentModeLabel(l10n).toUpperCase(),
                      style: AppTypography.mono(color: accent, size: 9),
                    ),
                    const SizedBox(height: 6),
                    Text(_currentModeDesc(l10n), style: AppTypography.body()),
                  ],
                ),
              ),
      ),
    );
  }

  String _currentModeLabel(AppLocalizations l10n) => switch (_settings.mode) {
    SeasonMode.auto      => l10n.modeAutoTitle,
    SeasonMode.savesOnly => l10n.modeSavesTitle,
    SeasonMode.geoOnly   => l10n.modeGeoTitle,
    SeasonMode.fixed     => l10n.modeFixedTitle,
    SeasonMode.random    => l10n.modeRandomTitle,
  };

  String _currentModeDesc(AppLocalizations l10n) => switch (_settings.mode) {
    SeasonMode.auto      => l10n.modeAutoDesc,
    SeasonMode.savesOnly => l10n.modeSavesDesc,
    SeasonMode.geoOnly   => l10n.modeGeoDesc,
    SeasonMode.fixed     => l10n.modeFixedDesc,
    SeasonMode.random    => l10n.modeRandomDesc,
  };

  Widget _seasonPicker(AppLocalizations l10n) {
    final seasons = [
      (SeasonState.initial, '✨', l10n.seasonInitial),
      (SeasonState.spring,  '🌸', l10n.seasonSpring),
      (SeasonState.summer,  '☀️', l10n.seasonSummer),
      (SeasonState.fall,    '🍂', l10n.seasonFall),
      (SeasonState.winter,  '❄️', l10n.seasonWinter),
    ];
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: seasons.map((entry) {
        final (s, emoji, label) = entry;
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
                '$emoji $label',
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

  Widget _autoExplainer(Color accent, AppLocalizations l10n) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: accent.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: accent.withValues(alpha: 0.30)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(l10n.autoPriorityTitle, style: AppTypography.eyebrow(color: accent)),
          const SizedBox(height: 12),
          _step('1', l10n.autoStep1Title, l10n.autoStep1Desc),
          const SizedBox(height: 10),
          _step('2', l10n.autoStep2Title, l10n.autoStep2Desc),
          const SizedBox(height: 10),
          _step('3', l10n.autoStep3Title, l10n.autoStep3Desc),
          const SizedBox(height: 10),
          _step('4', l10n.autoStep4Title, l10n.autoStep4Desc),
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

  Widget _versionTile(AppLocalizations l10n) {
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
            child: Text(l10n.versionInstalled, style: AppTypography.bodyStrong()),
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
                  Text(l10n.updateNeverChecked, style: AppTypography.mono(color: AppColors.textFaint, size: 11)),
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
                  Text(l10n.updateCheckedNow, style: AppTypography.mono(color: AppColors.textFaint, size: 11)),
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
                  Text(l10n.updateVersionAvailable(_updateInfo!.version), style: AppTypography.bodyStrong(color: accent)),
                  Text(l10n.updateOutdatedDownload, style: AppTypography.mono(color: AppColors.textFaint, size: 11)),
                ],
              ),
            ),
            const SizedBox(width: 12),
            Icon(Icons.download_rounded, size: 16, color: accent),
          ],
        );
      case _UpdateState.downloading:
        content = Row(
          children: [
            SizedBox(
              width: 13, height: 13,
              child: CircularProgressIndicator(strokeWidth: 1.5, color: accent),
            ),
            const SizedBox(width: 10),
            Expanded(child: Text(l10n.updateDownloading,
                style: AppTypography.bodyStrong(color: accent))),
            Text('${(_downloadProgress * 100).round()}%',
                style: AppTypography.mono(color: accent, size: 11)),
          ],
        );
      case _UpdateState.error:
        content = Row(
          children: [
            Expanded(child: Text(l10n.updateError, style: AppTypography.bodyStrong(color: const Color(0xFFE05252)))),
            const SizedBox(width: 12),
            const Icon(Icons.error_outline_rounded, size: 16, color: Color(0xFFE05252)),
          ],
        );
    }

    final isTappable = _updateState == _UpdateState.idle || _updateState == _UpdateState.available;

    return GestureDetector(
      onTap: _updateState == _UpdateState.available
          ? _startInstall
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

  (String, String) _langLabel(Locale? current, AppLocalizations l10n) {
    if (current == null) return ('🌐', l10n.languageAuto);
    for (final (locale, flag, label) in _kLangs) {
      if (locale != null && locale.languageCode == current.languageCode) {
        return (flag, label);
      }
    }
    return ('🌐', l10n.languageAuto);
  }

  Widget _languageTile(Locale? current, AppLocalizations l10n) {
    final (flag, label) = _langLabel(current, l10n);
    final accent = SeasonData.data[SeasonController.instance.season.value]!.accentColor;
    return GestureDetector(
      onTap: () => _openLanguageDialog(context, l10n),
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
                child: Text(l10n.languageTileLabel, style: AppTypography.bodyStrong()),
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

  void _openLanguageDialog(BuildContext context, AppLocalizations l10n) {
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
        l10n: l10n,
      ),
    );
  }

  Widget _disconnectButton(AppLocalizations l10n) {
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
                l10n.disconnectButton,
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
    required this.l10n,
  });

  final Locale? current;
  final List<(Locale?, String, String)> langs;
  final void Function(Locale?) onSelect;
  final bool Function(Locale?, Locale?) langMatch;
  final Color accent;
  final AppLocalizations l10n;

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
      final label = e.$1 == null ? widget.l10n.languageAuto : e.$3;
      return label.toLowerCase().contains(_query);
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
                    Text(widget.l10n.languageDialogTitle.toUpperCase(), style: AppTypography.eyebrow()),
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
                            hintText: widget.l10n.searchHint,
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
                      label: locale == null ? widget.l10n.languageAuto : label,
                      isAuto: locale == null,
                      selected: selected,
                      accent: widget.accent,
                      staggerIndex: i,
                      staggerCtrl: _staggerCtrl,
                      onTap: () => widget.onSelect(locale),
                      l10n: widget.l10n,
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
    required this.l10n,
  });

  final String flag;
  final String label;
  final bool isAuto;
  final bool selected;
  final Color accent;
  final int staggerIndex;
  final AnimationController staggerCtrl;
  final VoidCallback onTap;
  final AppLocalizations l10n;

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
                          widget.l10n.languageAutoDesc,
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
