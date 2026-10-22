import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/models/save_area.dart';
import '../../../core/theme/app_colors.dart';
import '../../../generated/app_localizations.dart';

/// Color de la sección SMAPI (mockup aprobado 2026-10-23, spec 010).
const smapiAccent = Color(0xFF8FA8E0);

/// Pestañas Normal / SMAPI de la pantalla de partidas (spec 010 D1, opción A
/// del mockup). Solo se muestra cuando la sección SMAPI es visible.
class SaveAreaTabs extends StatelessWidget {
  const SaveAreaTabs({
    super.key,
    required this.selected,
    required this.counts,
    required this.onSelect,
  });

  final SaveArea selected;

  /// Número de partidas por pestaña; `null` = aún sin contar.
  final Map<SaveArea, int?> counts;
  final ValueChanged<SaveArea> onSelect;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: AppColors.bgAlt.withValues(alpha: 0.85),
        border: Border.all(color: AppColors.borderSub),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          _tab(SaveArea.normal, l10n.saveAreaNormal, AppColors.text),
          const SizedBox(width: 4),
          _tab(SaveArea.smapi, l10n.saveAreaSmapi, smapiAccent),
        ],
      ),
    );
  }

  Widget _tab(SaveArea area, String label, Color activeColor) {
    final on = area == selected;
    final count = counts[area];
    return Expanded(
      child: Semantics(
        selected: on,
        button: true,
        child: InkWell(
          onTap: on ? null : () => onSelect(area),
          borderRadius: BorderRadius.circular(9),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 160),
            curve: Curves.easeOut,
            padding: const EdgeInsets.symmetric(vertical: 8),
            decoration: BoxDecoration(
              color: on ? AppColors.surfaceTwo : Colors.transparent,
              border: Border.all(
                color: on ? AppColors.border : Colors.transparent,
              ),
              borderRadius: BorderRadius.circular(9),
            ),
            child: Text.rich(
              TextSpan(
                children: [
                  TextSpan(
                    text: label,
                    style: GoogleFonts.firaCode(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      color: on ? activeColor : AppColors.textFaint,
                    ),
                  ),
                  if (count != null)
                    TextSpan(
                      text: '  $count',
                      style: GoogleFonts.firaCode(
                        fontSize: 11,
                        color: AppColors.textFaint,
                      ),
                    ),
                ],
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ),
    );
  }
}
