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

/// Tamaño del zip para la línea de la fila: «12,4 MB» con el decimal del
/// idioma; por debajo de 1 MB en KB, y por debajo de 1 KB en bytes. El
/// espacio entre número y unidad es irrompible (U+00A0): en una fila estrecha
/// la línea no debe partirse entre «12,4» y «MB».
String formatBackupSize(int bytes, String localeName) {
  if (bytes < 1024) return '$bytes B';
  if (bytes < 1024 * 1024) return '${(bytes / 1024).round()} KB';
  final mb = bytes / (1024 * 1024);
  try {
    return '${NumberFormat('0.0', localeName).format(mb)} MB';
  } catch (_) {
    return '${mb.toStringAsFixed(1)} MB';
  }
}

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
