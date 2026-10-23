import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/models/save_area.dart';
import '../../../core/models/season_state.dart';
import '../../../core/services/season_controller.dart';
import '../../../generated/app_localizations.dart';

/// Color de la temporada activa de la app: lo usan las pestañas, las
/// ventanas de mods y sus botones (mockup estacional aprobado 2026-10-23,
/// mismo criterio que la insignia «ÚLTIMA PARTIDA»).
Color get currentSeasonAccent =>
    SeasonData.data[SeasonController.instance.season.value]!.accentColor;

/// Pestañas Normal / SMAPI de la pantalla de partidas (spec 010 D1, opción A
/// del mockup). Casi transparentes para no tapar el paisaje; la activa lleva
/// el color de la temporada.
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
    return ValueListenableBuilder<SeasonState>(
      valueListenable: SeasonController.instance.season,
      builder: (_, season, _) {
        final accent = SeasonData.data[season]!.accentColor;
        return Container(
          padding: const EdgeInsets.all(4),
          decoration: BoxDecoration(
            color: Colors.black.withValues(alpha: 0.22),
            border: Border.all(color: accent.withValues(alpha: 0.20)),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              _tab(SaveArea.normal, l10n.saveAreaNormal, accent),
              const SizedBox(width: 4),
              _tab(SaveArea.smapi, '🧩 ${l10n.saveAreaSmapi}', accent),
            ],
          ),
        );
      },
    );
  }

  Widget _tab(SaveArea area, String label, Color accent) {
    final on = area == selected;
    final count = counts[area];
    final textColor = on ? accent : Colors.white.withValues(alpha: 0.45);
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
              color: on ? accent.withValues(alpha: 0.12) : Colors.transparent,
              border: Border.all(
                color: on
                    ? accent.withValues(alpha: 0.35)
                    : Colors.transparent,
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
                      color: textColor,
                    ),
                  ),
                  if (count != null)
                    TextSpan(
                      text: '  $count',
                      style: GoogleFonts.firaCode(
                        fontSize: 11,
                        color: textColor.withValues(alpha: 0.6),
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
