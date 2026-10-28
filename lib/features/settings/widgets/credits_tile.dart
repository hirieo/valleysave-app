import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../generated/app_localizations.dart';
import '../../../shared/widgets/pressable_scale.dart';

const kCreditsName = 'Hirieo';
const kCreditsRealName = 'Licendey Nuñez';
const kCreditsGithubUrl = 'https://github.com/hirieo';
const kCreditsLinkedinUrl = 'https://www.linkedin.com/in/licendey/';
const kCreditsEmail = 'lhirieo@gmail.com';

/// Créditos de Ajustes: tarjeta desplegable con el autor y sus enlaces.
/// Cerrada enseña solo el nombre; al pulsar se abre (mismo tiempo y curva
/// que las secciones de Backups) y respeta «reducir animaciones».
class CreditsTile extends StatefulWidget {
  const CreditsTile({super.key, required this.accent});

  final Color accent;

  @override
  State<CreditsTile> createState() => _CreditsTileState();
}

class _CreditsTileState extends State<CreditsTile> {
  bool _open = false;

  Future<void> _openUrl(String url) =>
      launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);

  Future<void> _copyEmail(String message) async {
    await Clipboard.setData(const ClipboardData(text: kCreditsEmail));
    if (!mounted) return;
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final reduce = MediaQuery.of(context).disableAnimations;
    final duration = reduce ? Duration.zero : const Duration(milliseconds: 200);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.45),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white.withValues(alpha: 0.10)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          PressableScale(
            key: const ValueKey('credits-header'),
            semanticLabel: l10n.settingsCreditsSection,
            onTap: () => setState(() => _open = !_open),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        kCreditsName,
                        style: GoogleFonts.bodoniModa(
                          fontSize: 28,
                          fontStyle: FontStyle.italic,
                          fontWeight: FontWeight.w700,
                          color: AppColors.text,
                          height: 1.05,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        kCreditsRealName,
                        style: AppTypography.mono(
                          color: AppColors.sandThree,
                          size: 13,
                        ),
                      ),
                    ],
                  ),
                ),
                AnimatedRotation(
                  turns: _open ? 0.5 : 0,
                  duration: duration,
                  curve: Curves.easeOutCubic,
                  child: const Icon(
                    Icons.expand_more_rounded,
                    color: AppColors.textFaint,
                  ),
                ),
              ],
            ),
          ),
          _Collapsible(
            animate: !reduce,
            child: _open
                ? Padding(
                    padding: const EdgeInsets.only(top: 14),
                    child: Column(
                      key: const ValueKey('credits-links'),
                      children: [
                        _CreditLink(
                          keyName: 'github',
                          badge: 'GH',
                          label: 'GitHub',
                          value: 'github.com/hirieo',
                          trailing: Icons.north_east_rounded,
                          accent: widget.accent,
                          onTap: () => _openUrl(kCreditsGithubUrl),
                        ),
                        _CreditLink(
                          keyName: 'linkedin',
                          badge: 'in',
                          label: 'LinkedIn',
                          value: 'linkedin.com/in/licendey',
                          trailing: Icons.north_east_rounded,
                          accent: widget.accent,
                          onTap: () => _openUrl(kCreditsLinkedinUrl),
                        ),
                        _CreditLink(
                          keyName: 'email',
                          badge: '@',
                          label: l10n.creditsEmail,
                          value: kCreditsEmail,
                          trailing: Icons.copy_rounded,
                          accent: widget.accent,
                          last: true,
                          onTap: () => _copyEmail(l10n.creditsEmailCopied),
                        ),
                      ],
                    ),
                  )
                : const SizedBox(width: double.infinity),
          ),
        ],
      ),
    );
  }
}

/// `AnimatedSize` con duración cero lanza una aserción: sin animación se
/// pinta el hijo directamente.
class _Collapsible extends StatelessWidget {
  const _Collapsible({required this.animate, required this.child});

  final bool animate;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    if (!animate) return child;
    return AnimatedSize(
      duration: const Duration(milliseconds: 200),
      curve: Curves.easeOutCubic,
      alignment: Alignment.topCenter,
      child: child,
    );
  }
}

class _CreditLink extends StatelessWidget {
  const _CreditLink({
    required this.keyName,
    required this.badge,
    required this.label,
    required this.value,
    required this.trailing,
    required this.accent,
    required this.onTap,
    this.last = false,
  });

  final String keyName;
  final String badge;
  final String label;
  final String value;
  final IconData trailing;
  final Color accent;
  final VoidCallback onTap;
  final bool last;

  @override
  Widget build(BuildContext context) {
    return PressableScale(
      key: ValueKey('credits-link-$keyName'),
      semanticLabel: '$label $value',
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.fromLTRB(2, 12, 2, last ? 2 : 12),
        decoration: BoxDecoration(
          border: Border(
            top: BorderSide(color: Colors.white.withValues(alpha: 0.08)),
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 28,
              height: 28,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: accent.withValues(alpha: 0.16),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                badge,
                style: GoogleFonts.firaCode(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  color: accent,
                ),
              ),
            ),
            const SizedBox(width: 12),
            Text(
              label,
              style: AppTypography.bodyStrong().copyWith(fontSize: 13),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                value,
                textAlign: TextAlign.end,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppTypography.mono(color: AppColors.textFaint, size: 11),
              ),
            ),
            const SizedBox(width: 8),
            Icon(trailing, size: 16, color: AppColors.textFaint),
          ],
        ),
      ),
    );
  }
}
