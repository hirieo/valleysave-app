import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../core/models/season_state.dart';
import '../../core/services/auth_service.dart';
import '../../core/services/drive_service.dart';
import '../../core/services/season_service.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_typography.dart';
import '../../shared/widgets/ghost_button.dart';
import '../../shared/widgets/primary_button.dart';
import '../../shared/widgets/season_click_effect.dart';
import '../../shared/widgets/valley_canvas_widget.dart';
import '../saves/saves_screen.dart';
import '../settings/settings_screen.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen>
    with TickerProviderStateMixin {
  SeasonState _season = SeasonState.initial;
  bool _authLoading = false;
  bool _authConnected = false;
  // ignore: unused_field — se pasará a la SyncScreen cuando esté implementada
  DriveService? _drive;

  late final AnimationController _pulseCtrl;
  late final Animation<double> _pulseAnim;

  @override
  void initState() {
    super.initState();
    HardwareKeyboard.instance.addHandler(_onKey);
    _resolveInitialSeason();
    _tryRestoreAuth();
    _pulseCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    )..repeat(reverse: true);
    _pulseAnim = Tween<double>(begin: 0.10, end: 0.55).animate(
      CurvedAnimation(parent: _pulseCtrl, curve: Curves.easeInOut),
    );
  }

  Future<void> _tryRestoreAuth() async {
    final client = await AuthService.instance.tryRestore();
    if (!mounted || client == null) return;
    final drive = DriveService(client);
    _initDrive(drive);
    setState(() => _authConnected = true);
    WidgetsBinding.instance.addPostFrameCallback((_) => _goToSaves(drive));
  }

  Future<void> _connectDrive() async {
    if (_authConnected || _authLoading) return;
    setState(() => _authLoading = true);
    try {
      final client = await AuthService.instance.signIn();
      if (mounted && client != null) {
        setState(() => _authConnected = true);
        final drive = DriveService(client);
        _initDrive(drive);
        _goToSaves(drive);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: $e'),
            backgroundColor: const Color(0xFFC06050),
            duration: const Duration(seconds: 10),
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _authLoading = false);
    }
  }

  void _initDrive(DriveService drive) {
    _drive = drive;
    drive.ensureFolder().ignore();
  }

  Future<void> _goToSaves(DriveService drive) async {
    if (!mounted) return;
    final disconnected = await Navigator.push<bool>(
      context,
      MaterialPageRoute(builder: (_) => SavesScreen(drive: drive)),
    );
    if (mounted && disconnected == true) {
      setState(() {
        _authConnected = false;
        _drive = null;
      });
    }
  }

  Future<void> _resolveInitialSeason() async {
    final season = await SeasonService().resolve();
    if (mounted) setState(() => _season = season);
  }

  Future<void> _openSettings() async {
    final result = await Navigator.push<String?>(
      context,
      MaterialPageRoute(
        builder: (_) => SettingsScreen(showDisconnect: _authConnected),
      ),
    );
    if (mounted && result == 'disconnect') {
      await AuthService.instance.signOut();
      setState(() {
        _authConnected = false;
        _drive = null;
      });
    }
    if (mounted) _resolveInitialSeason();
  }

  @override
  void dispose() {
    HardwareKeyboard.instance.removeHandler(_onKey);
    _pulseCtrl.dispose();
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
                final mobile = constraints.maxWidth < 600;
                final heroSize = mobile ? 52.0 : 84.0;
                return ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 760),
                  child: SingleChildScrollView(
                    padding: EdgeInsets.fromLTRB(
                      mobile ? AppSpacing.sp6 : AppSpacing.sp8,
                      mobile ? AppSpacing.sp4 : 0,
                      mobile ? AppSpacing.sp6 : AppSpacing.sp8,
                      mobile ? 80.0 : 0,
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        RichText(
                          text: TextSpan(
                            style: AppTypography.hero().copyWith(
                              fontSize: heroSize,
                            ),
                            children: [
                              const TextSpan(text: 'Nunca pierdas\ntu '),
                              TextSpan(
                                text: 'granja,',
                                style: AppTypography.hero(color: AppColors.accent)
                                    .copyWith(
                                  fontStyle: FontStyle.normal,
                                  fontSize: heroSize,
                                ),
                              ),
                              const TextSpan(text: '\nllévala contigo.'),
                            ],
                          ),
                        ),
                        SizedBox(height: mobile ? AppSpacing.sp2 : AppSpacing.sp6),
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
                        SizedBox(height: mobile ? AppSpacing.sp4 : AppSpacing.sp8),
                        if (_authConnected) ...[
                          Wrap(
                            spacing: AppSpacing.sp4,
                            runSpacing: AppSpacing.sp4,
                            crossAxisAlignment: WrapCrossAlignment.start,
                            children: [
                              Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  AnimatedBuilder(
                                    animation: _pulseAnim,
                                    builder: (context, child) => DecoratedBox(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(999),
                                        boxShadow: [
                                          BoxShadow(
                                            color: SeasonData.data[_season]!.accentColor
                                                .withValues(alpha: _pulseAnim.value),
                                            blurRadius: 32,
                                            spreadRadius: 6,
                                          ),
                                        ],
                                      ),
                                      child: child,
                                    ),
                                    child: SeasonClickEffect(
                                      season: _season,
                                      child: PrimaryButton(
                                        label: 'Mis partidas',
                                        onPressed: () => _goToSaves(_drive!),
                                        color: SeasonData.data[_season]!.accentColor,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 6),
                                  Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      SvgPicture.asset(
                                        'assets/icons/google_drive.svg',
                                        width: 12,
                                        height: 12,
                                      ),
                                      const SizedBox(width: 5),
                                      Text(
                                        'Drive conectado',
                                        style: AppTypography.mono(
                                          color: Colors.white.withValues(alpha: 0.50),
                                          size: 11,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              SeasonClickEffect(
                                season: _season,
                                child: GhostButton(
                                  label: 'Cómo funciona',
                                  onPressed: () {},
                                  foregroundColor: Colors.white,
                                  borderColor: SeasonData.data[_season]!.accentColor
                                      .withValues(alpha: 0.80),
                                  backgroundColor: Colors.black.withValues(
                                    alpha: _season == SeasonState.winter ? 0.45 : 0.32,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ] else ...[
                          Wrap(
                            spacing: AppSpacing.sp4,
                            runSpacing: AppSpacing.sp4,
                            children: [
                              SeasonClickEffect(
                                season: _season,
                                child: PrimaryButton(
                                  label: _authLoading
                                      ? 'Conectando…'
                                      : 'Conectar Google Drive',
                                  onPressed: _authLoading ? null : _connectDrive,
                                  color: SeasonData.data[_season]!.accentColor,
                                ),
                              ),
                              SeasonClickEffect(
                                season: _season,
                                child: GhostButton(
                                  label: 'Cómo funciona',
                                  onPressed: () {},
                                  foregroundColor: Colors.white,
                                  borderColor: SeasonData.data[_season]!.accentColor
                                      .withValues(alpha: 0.80),
                                  backgroundColor: Colors.black.withValues(
                                    alpha: _season == SeasonState.winter ? 0.45 : 0.32,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                        SizedBox(height: mobile ? AppSpacing.sp2 : AppSpacing.sp6),
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
          // z=2: settings button — alineado con el área de contenido
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(12, 10, 12, 6),
                child: Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 760),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        GestureDetector(
                          onTap: _openSettings,
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
                              Icons.settings_rounded,
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
            ),
          ),
          // z=3: chips — sobre todo lo demás, reciben eventos primero
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
