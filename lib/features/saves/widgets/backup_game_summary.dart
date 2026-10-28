import 'package:intl/intl.dart';

import '../../../core/services/backup_service.dart';
import '../../../generated/app_localizations.dart';

/// Texto de la fila de un backup (spec 012, D6): «Año 3 · Otoño 12 · 248.310 g»,
/// con la estación traducida y el dinero con el separador de miles del idioma.
String formatBackupGameSummary(
  BackupGameSummary summary,
  AppLocalizations l10n,
) => l10n.backupsGameSummary(
  summary.year,
  _seasonLabel(summary.season, l10n),
  summary.day,
  _money(summary.money, l10n.localeName),
);

String _seasonLabel(String season, AppLocalizations l10n) =>
    switch (season.toLowerCase()) {
      'spring' => l10n.seasonSpring,
      'summer' => l10n.seasonSummer,
      'fall' => l10n.seasonFall,
      'winter' => l10n.seasonWinter,
      _ => season,
    };

String _money(int amount, String localeName) {
  try {
    return NumberFormat.decimalPattern(localeName).format(amount);
  } catch (_) {
    // Locale sin datos de números en intl: formato neutro.
    return NumberFormat.decimalPattern('en').format(amount);
  }
}
