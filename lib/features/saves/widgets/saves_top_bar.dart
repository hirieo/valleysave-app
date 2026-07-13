import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../generated/app_localizations.dart';
import '../../../shared/widgets/icon_circle_button.dart';

class SavesTopBar extends StatelessWidget {
  const SavesTopBar({
    super.key,
    required this.onBack,
    required this.onSettings,
    required this.onRefresh,
    required this.refreshing,
    required this.canLaunchGame,
    required this.onLaunch,
    required this.onImport,
  });

  final VoidCallback onBack;
  final VoidCallback onSettings;
  final VoidCallback onRefresh;
  final bool refreshing;
  final bool canLaunchGame;
  final VoidCallback onLaunch;
  final VoidCallback onImport;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 10, 12, 6),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 492),
          child: Row(
            children: [
              IconCircleButton(
                icon: Icons.arrow_back_rounded,
                onTap: onBack,
              ),
              const Spacer(),
              Text(
                l10n.mySaves,
                style: GoogleFonts.bodoniModa(
                  fontSize: 24,
                  fontStyle: FontStyle.italic,
                  fontWeight: FontWeight.w700,
                  color: Colors.white.withValues(alpha: 0.92),
                ),
              ),
              const Spacer(),
              if (canLaunchGame) ...[
                TweenAnimationBuilder<double>(
                  tween: Tween(begin: 0.0, end: 1.0),
                  duration: const Duration(milliseconds: 260),
                  curve: const Cubic(0.23, 1, 0.32, 1),
                  builder: (_, t, child) => Opacity(
                    opacity: t.clamp(0.0, 1.0),
                    child: Transform.scale(scale: 0.8 + 0.2 * t, child: child),
                  ),
                  child: IconCircleButton(
                    icon: Icons.play_arrow_rounded,
                    onTap: onLaunch,
                    tooltip: l10n.tooltipLaunchGame,
                  ),
                ),
                const SizedBox(width: 8),
              ],
              IconCircleButton(
                icon: Icons.upload_file_rounded,
                onTap: onImport,
                tooltip: l10n.importAction,
              ),
              const SizedBox(width: 8),
              IconCircleButton(
                icon: Icons.refresh_rounded,
                onTap: onRefresh,
                spinning: refreshing,
              ),
              const SizedBox(width: 8),
              IconCircleButton(icon: Icons.settings_rounded, onTap: onSettings),
            ],
          ),
        ),
      ),
    );
  }
}
