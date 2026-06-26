import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../core/models/season_state.dart';
import '../../core/services/auth_service.dart';
import '../../core/services/drive_service.dart';
import '../../core/services/season_controller.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_typography.dart';
import '../../shared/utils/app_page_route.dart';
import '../../shared/widgets/icon_circle_button.dart';
import '../../shared/widgets/ghost_button.dart';
import '../../shared/widgets/primary_button.dart';
import '../../shared/widgets/valley_canvas_widget.dart';
import '../help/how_it_works_screen.dart';
import '../saves/saves_screen.dart';
import '../settings/settings_screen.dart';
import '../../core/services/update_service.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen>
    with TickerProviderStateMixin {
  bool _restoring = true;
  bool _authLoading = false;
  bool _authConnected = false;
  String? _updateVersion;
  bool _updateChipPressed = false;
  // ignore: unused_field — se pasará a la SyncScreen cuando esté implementada
  DriveService? _drive;

  late final AnimationController _pulseCtrl;
  late final Animation<double> _pulseAnim;

  late final AnimationController _entranceCtrl;
  late final Animation<double> _settingsAnim;
  late final Animation<double> _heroAnim;
  late final Animation<double> _subAnim;
  late final Animation<double> _btnsAnim;
  late final Animation<double> _chipAnim;

  @override
  void initState() {
    super.initState();
    _tryRestoreAuth();
    _checkUpdate();
    _pulseCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    )..repeat(reverse: true);
    _pulseAnim = Tween<double>(begin: 0.10, end: 0.55).animate(
      CurvedAnimation(parent: _pulseCtrl, curve: Curves.easeInOut),
    );
    _entranceCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 660),
    )..forward();
    _settingsAnim = _makeInterval(0, 320);
    _heroAnim = _makeInterval(80, 500);
    _subAnim = _makeInterval(160, 540);
    _btnsAnim = _makeInterval(240, 600);
    _chipAnim = _makeInterval(320, 660);
  }

  Animation<double> _makeInterval(int startMs, int endMs) {
    const total = 660.0;
    return CurvedAnimation(
      parent: _entranceCtrl,
      curve: Interval(startMs / total, endMs / total, curve: const Cubic(0.23, 1, 0.32, 1)),
    );
  }

  Future<void> _tryRestoreAuth() async {
    AuthClient? client;
    try {
      client = await AuthService.instance
          .tryRestore()
          .timeout(const Duration(seconds: 6));
    } catch (_) {
      client = null; // timeout o error → tratar como sin sesión
    }
    if (!mounted) return;
    if (client == null) {
      setState(() => _restoring = false);
      return;
    }
    final drive = DriveService(client);
    _initDrive(drive);
    setState(() { _authConnected = true; _restoring = false; });
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
      AppPageRoute(builder: (_) => SavesScreen(drive: drive)),
    );
    if (mounted) {
      _entranceCtrl.forward(from: 0);
      if (disconnected == true) {
        setState(() {
          _authConnected = false;
          _drive = null;
        });
      }
    }
  }

  Future<void> _checkUpdate() async {
    final version = await UpdateService.checkForUpdate();
    if (mounted && version != null) setState(() => _updateVersion = version);
  }

  Widget _buildUpdateChip(SeasonState season) {
    final accent = SeasonData.data[season]!.accentColor;
    return Listener(
      onPointerDown: (_) => setState(() => _updateChipPressed = true),
      onPointerUp: (_) => setState(() => _updateChipPressed = false),
      onPointerCancel: (_) => setState(() => _updateChipPressed = false),
      child: GestureDetector(
        onTap: () => UpdateService.openReleasePage(),
        child: AnimatedScale(
          scale: _updateChipPressed ? 0.97 : 1.0,
          duration: _updateChipPressed
              ? const Duration(milliseconds: 100)
              : const Duration(milliseconds: 200),
          curve: const Cubic(0.23, 1, 0.32, 1),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: Colors.black.withValues(alpha: 0.42),
              borderRadius: BorderRadius.circular(999),
              border: Border.all(
                color: accent.withValues(alpha: 0.48),
                width: 1.5,
              ),
            ),
            child: Row(
              children: [
                Icon(Icons.arrow_upward_rounded, size: 14, color: accent.withValues(alpha: 0.85)),
                const SizedBox(width: 8),
                Text(
                  'v$_updateVersion disponible',
                  style: AppTypography.bodyStrong(
                    color: Colors.white.withValues(alpha: 0.90),
                  ).copyWith(fontSize: 14),
                ),
                const Spacer(),
                Icon(Icons.open_in_new_rounded, size: 13, color: accent.withValues(alpha: 0.60)),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _openSettings() async {
    final result = await Navigator.push<String?>(
      context,
      AppPageRoute(
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
    if (mounted) SeasonController.instance.init();
  }

  @override
  void dispose() {
    _pulseCtrl.dispose();
    _entranceCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg,
      body: ValueListenableBuilder<SeasonState>(
        valueListenable: SeasonController.instance.season,
        builder: (_, season, _) => Stack(
          children: [
            // z=0: fondo
            Positioned.fill(child: ValleyCanvasWidget(season: season)),
            // z=0.5: scrim
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
                          AnimatedBuilder(
                            animation: _heroAnim,
                            builder: (_, child) => Opacity(
                              opacity: _heroAnim.value,
                              child: Transform.translate(
                                offset: Offset(0, 16 * (1 - _heroAnim.value)),
                                child: child,
                              ),
                            ),
                            child: RichText(
                              text: TextSpan(
                                style: AppTypography.hero().copyWith(fontSize: heroSize),
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
                          ),
                          SizedBox(height: mobile ? AppSpacing.sp2 : AppSpacing.sp6),
                          AnimatedBuilder(
                            animation: _subAnim,
                            builder: (_, child) => Opacity(
                              opacity: _subAnim.value,
                              child: Transform.translate(
                                offset: Offset(0, 14 * (1 - _subAnim.value)),
                                child: child,
                              ),
                            ),
                            child: Text(
                              'Sincroniza tus saves de Stardew Valley entre todos tus dispositivos. '
                              'Tus datos viven en tu Google Drive — sin servidores propios, sin suscripciones, bajo tu control.',
                              style: AppTypography.body(
                                color: Colors.white.withValues(alpha: 0.90),
                              ).copyWith(
                                shadows: const [
                                  Shadow(color: Color(0x8C000000), blurRadius: 8, offset: Offset(0, 1)),
                                  Shadow(color: Color(0x40000000), blurRadius: 24),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(height: mobile ? AppSpacing.sp4 : AppSpacing.sp8),
                          AnimatedBuilder(
                            animation: _btnsAnim,
                            builder: (_, child) => Opacity(
                              opacity: _btnsAnim.value,
                              child: Transform.translate(
                                offset: Offset(0, 12 * (1 - _btnsAnim.value)),
                                child: child,
                              ),
                            ),
                            child: AnimatedSwitcher(
                              duration: const Duration(milliseconds: 300),
                              transitionBuilder: (child, anim) {
                                final slide = Tween<Offset>(
                                  begin: const Offset(0, 0.08),
                                  end: Offset.zero,
                                ).animate(CurvedAnimation(
                                  parent: anim,
                                  curve: const Cubic(0.23, 1, 0.32, 1),
                                ));
                                return FadeTransition(
                                  opacity: anim,
                                  child: SlideTransition(position: slide, child: child),
                                );
                              },
                              child: _restoring
                                  ? const SizedBox(key: ValueKey('r'), height: 52)
                                  : _authConnected
                                      ? Wrap(
                                          key: const ValueKey('c'),
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
                                                          color: SeasonData.data[season]!.accentColor
                                                              .withValues(alpha: _pulseAnim.value),
                                                          blurRadius: 32,
                                                          spreadRadius: 6,
                                                        ),
                                                      ],
                                                    ),
                                                    child: child,
                                                  ),
                                                  child: PrimaryButton(
                                                    label: 'Mis partidas',
                                                    onPressed: () => _goToSaves(_drive!),
                                                    color: SeasonData.data[season]!.accentColor,
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
                                            GhostButton(
                                              label: 'Cómo funciona',
                                              onPressed: () => Navigator.push(
                                                context,
                                                AppPageRoute(builder: (_) => const HowItWorksScreen()),
                                              ),
                                              foregroundColor: Colors.white,
                                              borderColor: SeasonData.data[season]!.accentColor
                                                  .withValues(alpha: 0.80),
                                              backgroundColor: Colors.black.withValues(
                                                alpha: season == SeasonState.winter ? 0.45 : 0.32,
                                              ),
                                            ),
                                          ],
                                        )
                                      : Wrap(
                                          key: const ValueKey('d'),
                                          spacing: AppSpacing.sp4,
                                          runSpacing: AppSpacing.sp4,
                                          children: [
                                            PrimaryButton(
                                              label: _authLoading ? 'Conectando…' : 'Conectar Google Drive',
                                              onPressed: _authLoading ? null : _connectDrive,
                                              color: SeasonData.data[season]!.accentColor,
                                            ),
                                            GhostButton(
                                              label: 'Cómo funciona',
                                              onPressed: () => Navigator.push(
                                                context,
                                                AppPageRoute(builder: (_) => const HowItWorksScreen()),
                                              ),
                                              foregroundColor: Colors.white,
                                              borderColor: SeasonData.data[season]!.accentColor
                                                  .withValues(alpha: 0.80),
                                              backgroundColor: Colors.black.withValues(
                                                alpha: season == SeasonState.winter ? 0.45 : 0.32,
                                              ),
                                            ),
                                          ],
                                        ),
                            ),
                          ),
                          SizedBox(height: mobile ? AppSpacing.sp2 : AppSpacing.sp6),
                          AnimatedSize(
                            duration: const Duration(milliseconds: 250),
                            curve: const Cubic(0.23, 1, 0.32, 1),
                            child: _updateVersion != null
                                ? Padding(
                                    padding: const EdgeInsets.only(bottom: 8),
                                    child: _buildUpdateChip(season),
                                  )
                                : const SizedBox.shrink(),
                          ),
                          AnimatedBuilder(
                            animation: _chipAnim,
                            builder: (_, child) => Opacity(
                              opacity: _chipAnim.value,
                              child: Transform.translate(
                                offset: Offset(0, 10 * (1 - _chipAnim.value)),
                                child: child,
                              ),
                            ),
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                              decoration: BoxDecoration(
                                color: Colors.black.withValues(alpha: 0.35),
                                borderRadius: BorderRadius.circular(999),
                              ),
                              child: Text(
                                '· No comercial · Gratis para siempre ·',
                                style: AppTypography.eyebrow(
                                  color: Colors.white.withValues(alpha: 0.80),
                                ),
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
            // z=2: settings button
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: SafeArea(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(12, 10, 12, 6),
                  child: Center(
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 492),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          AnimatedBuilder(
                            animation: _settingsAnim,
                            builder: (_, child) => Opacity(
                              opacity: _settingsAnim.value,
                              child: Transform.translate(
                                offset: Offset(0, -6 * (1 - _settingsAnim.value)),
                                child: child,
                              ),
                            ),
                            child: IconCircleButton(
                              icon: Icons.settings_rounded,
                              onTap: _openSettings,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
