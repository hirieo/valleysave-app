import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../generated/app_localizations.dart';
import '../../core/models/season_state.dart';
import '../../core/services/season_controller.dart';
import '../../core/theme/app_colors.dart';
import '../../shared/widgets/icon_circle_button.dart';
import '../../shared/widgets/valley_canvas_widget.dart';

const _kAcceptedKey = 'privacy_accepted';

class PrivacyScreen extends StatefulWidget {
  const PrivacyScreen({super.key, this.onAccepted, this.viewOnly = false});
  final VoidCallback? onAccepted;
  final bool viewOnly;

  @override
  State<PrivacyScreen> createState() => _PrivacyScreenState();
}

class _PrivacyScreenState extends State<PrivacyScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _entranceCtrl;
  late final Animation<double> _headerAnim;
  late final Animation<double> _ctaAnim;
  bool _ctaPressed = false;

  @override
  void initState() {
    super.initState();
    _entranceCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 380),
    );
    if (WidgetsBinding.instance.platformDispatcher.accessibilityFeatures.disableAnimations) {
      _entranceCtrl.value = 1.0;
    } else {
      _entranceCtrl.forward();
    }
    _headerAnim = CurvedAnimation(
      parent: _entranceCtrl,
      curve: const Interval(0.0, 0.64, curve: Cubic(0.23, 1, 0.32, 1)),
    );
    _ctaAnim = CurvedAnimation(
      parent: _entranceCtrl,
      curve: const Interval(0.24, 0.84, curve: Cubic(0.23, 1, 0.32, 1)),
    );
  }

  @override
  void dispose() {
    _entranceCtrl.dispose();
    super.dispose();
  }

  Future<void> _accept() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_kAcceptedKey, true);
    widget.onAccepted?.call();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
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
                  AnimatedBuilder(
                    animation: _headerAnim,
                    builder: (_, child) => Opacity(
                      opacity: _headerAnim.value,
                      child: Transform.translate(
                        offset: Offset(0, 12 * (1 - _headerAnim.value)),
                        child: child,
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(12, 10, 12, 0),
                      child: Center(
                        child: ConstrainedBox(
                          constraints: const BoxConstraints(maxWidth: 492),
                          child: Stack(
                            alignment: Alignment.centerLeft,
                            children: [
                              if (widget.viewOnly)
                                IconCircleButton(
                                  icon: Icons.arrow_back_rounded,
                                  onTap: () => Navigator.pop(context),
                                ),
                              Center(
                                child: Column(
                                  children: [
                                    Text(
                                      widget.viewOnly ? l10n.privacyPolicyTitle : l10n.privacyBeforeStartTitle,
                                      style: GoogleFonts.bodoniModa(
                                        fontSize: 24,
                                        fontStyle: FontStyle.italic,
                                        fontWeight: FontWeight.w700,
                                        color: Colors.white.withValues(alpha: 0.95),
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      l10n.privacyLastUpdated,
                                      style: GoogleFonts.firaCode(
                                        fontSize: 11,
                                        color: Colors.white.withValues(alpha: 0.45),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
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
                              _section(l10n.privacyTitle, l10n.privacyDescription, accent: SeasonData.data[season]!.accentColor),
                              _section(l10n.whatDataTitle, l10n.whatDataDesc, accent: SeasonData.data[season]!.accentColor),
                              _section(l10n.googleDriveTitle, l10n.googleDriveDesc, accent: SeasonData.data[season]!.accentColor),
                              _section(l10n.androidPermissionsTitle, l10n.androidPermissionsDesc, accent: SeasonData.data[season]!.accentColor),
                              _section(l10n.adsTitle, l10n.adsDesc, accent: SeasonData.data[season]!.accentColor),
                              _section(l10n.responsibilityTitle, l10n.responsibilityDesc, highlight: true, accent: SeasonData.data[season]!.accentColor),
                              _section(l10n.deleteDataTitle, l10n.deleteDataDesc, accent: SeasonData.data[season]!.accentColor),
                              _section(l10n.sourceCodeTitle, l10n.sourceCodeDesc, accent: SeasonData.data[season]!.accentColor),
                              const SizedBox(height: 8),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  if (!widget.viewOnly)
                    AnimatedBuilder(
                      animation: _ctaAnim,
                      builder: (_, child) => Opacity(
                        opacity: _ctaAnim.value,
                        child: Transform.translate(
                          offset: Offset(0, 10 * (1 - _ctaAnim.value)),
                          child: child,
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(24, 8, 24, 24),
                        child: Center(
                          child: ConstrainedBox(
                            constraints: const BoxConstraints(maxWidth: 480),
                            child: GestureDetector(
                              onTap: _accept,
                              onTapDown: (_) => setState(() => _ctaPressed = true),
                              onTapUp: (_) => setState(() => _ctaPressed = false),
                              onTapCancel: () => setState(() => _ctaPressed = false),
                              child: AnimatedScale(
                                scale: _ctaPressed ? 0.97 : 1.0,
                                duration: _ctaPressed
                                    ? const Duration(milliseconds: 100)
                                    : const Duration(milliseconds: 200),
                                curve: const Cubic(0.23, 1, 0.32, 1),
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
                                    l10n.privacyAccept,
                                    style: GoogleFonts.firaCode(
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

  Widget _section(String title, String body,
      {bool highlight = false, Color accent = Colors.white}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: highlight
              ? Colors.black.withValues(alpha: 0.55)
              : Color.alphaBlend(
                  accent.withValues(alpha: 0.06),
                  Colors.black.withValues(alpha: 0.55)),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: highlight
                ? const Color(0xFFE05252).withValues(alpha: 0.50)
                : accent.withValues(alpha: 0.12),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: GoogleFonts.bodoniModa(
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
              style: GoogleFonts.firaCode(
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
