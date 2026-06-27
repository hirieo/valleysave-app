// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for German (`de`).
class AppLocalizationsDe extends AppLocalizations {
  AppLocalizationsDe([String locale = 'de']) : super(locale);

  @override
  String get appTitle => 'ValleySave';

  @override
  String get welcomeTitle =>
      'Verlieren Sie Ihren Bauernhof niemals, nehmen Sie ihn überall hin.';

  @override
  String get connectGoogleDrive => 'Mit Google Drive verbinden';

  @override
  String get connecting => 'Verbindung wird hergestellt…';

  @override
  String get mySaves => 'Meine Speicherstände';

  @override
  String get howItWorks => 'So funktioniert es';

  @override
  String get settings => 'Einstellungen';

  @override
  String get aboutSection => 'Über';

  @override
  String get openSource => 'Code verfügbar';

  @override
  String get nonCommercial => 'Nicht kommerziell';

  @override
  String get freeForever => 'Immer kostenlos';

  @override
  String get privacyTitle => 'Datenschutz und Datennutzung';

  @override
  String get privacyDescription =>
      'ValleySave ist eine App zum Synchronisieren Ihrer Stardew Valley-Speicherstände mit Ihrem eigenen Google Drive-Konto.';

  @override
  String get whatDataTitle => 'Welche Daten werden verwendet';

  @override
  String get whatDataDesc =>
      'ValleySave greift nur auf die Stardew Valley-Speicherdateien zu, die zum Erstellen von Kopien, Synchronisieren oder Wiederherstellen erforderlich sind.';

  @override
  String get googleDriveTitle => 'Google Drive';

  @override
  String get googleDriveDesc =>
      'Ihre Speicherstände werden auf Ihr eigenes Google Drive-Konto hochgeladen. ValleySave verwendet keine eigenen Server zum Speichern Ihrer Spiele.';

  @override
  String get androidPermissionsTitle => 'Berechtigungen auf Android';

  @override
  String get androidPermissionsDesc =>
      'ValleySave benötigt möglicherweise Speicherberechtigungen oder Tools wie Shizuku, um auf Speicherdateien zuzugreifen.';

  @override
  String get adsTitle => 'Anzeigen';

  @override
  String get adsDesc => 'ValleySave kann Anzeigen über Google AdMob anzeigen.';

  @override
  String get responsibilityTitle => 'Verantwortung';

  @override
  String get responsibilityDesc =>
      'Ihre Speicherdateien sind Ihre Verantwortung.';

  @override
  String get deleteDataTitle => 'Daten löschen';

  @override
  String get deleteDataDesc =>
      'Sie können Ihre synchronisierten Kopien löschen, indem Sie den Ordner ValleySave manuell aus Google Drive löschen.';

  @override
  String get sourceCodeTitle => 'Quellcode und Kontakt';

  @override
  String get sourceCodeDesc =>
      'ValleySave ist ein Projekt mit verfügbarem Code unter der Polyform Noncommercial-Lizenz.';

  @override
  String get upToDate => 'Aktuell';

  @override
  String get checkingUpdates => 'Wird überprüft…';

  @override
  String get updateAvailable => 'Update verfügbar';

  @override
  String get application => 'Anwendung';

  @override
  String version(Object version) {
    return 'Version $version';
  }

  @override
  String get checkForUpdates => 'Nach Updates suchen';

  @override
  String get shizukuRequired => 'Shizuku erforderlich';

  @override
  String get shizukuGuide => 'Shizuku-Einrichtungsleitfaden';

  @override
  String get activateShizuku =>
      'Aktivieren Sie Shizuku, um den Speicherstand im Spiel zu schreiben.';

  @override
  String deleteSaveTitle(Object saveName) {
    return 'Löschen $saveName';
  }

  @override
  String get deleteSaveMessage =>
      'Dies löscht den Speicherstand von diesem Gerät. Möchten Sie fortfahren?';

  @override
  String get deleteFromDrive => 'Aus Drive löschen';

  @override
  String confirmDelete(Object saveName) {
    return 'Der Speicherstand $saveName wird in den Google Drive-Papierkorb verschoben.';
  }

  @override
  String deleteFromDeviceMessage(Object saveName) {
    return 'Der Speicherstand $saveName wird dauerhaft von diesem Gerät gelöscht.';
  }

  @override
  String restoreSaveTitle(Object saveName) {
    return 'Wiederherstellen $saveName';
  }

  @override
  String restoreSaveMessage(Object saveName) {
    return 'Auf dieses Gerät herunterladen $saveName?';
  }

  @override
  String get restore => 'Wiederherstellen';

  @override
  String get cancel => 'Abbrechen';

  @override
  String get error => 'Fehler';

  @override
  String get success => 'Erfolg';

  @override
  String get loading => 'Wird geladen…';

  @override
  String get disconnect => 'Trennen';

  @override
  String get ok => 'OK';

  @override
  String get yes => 'Ja';

  @override
  String get no => 'Nein';

  @override
  String get welcomeHeroPre => 'Never lose\nyour ';

  @override
  String get welcomeHeroAccent => 'farm,';

  @override
  String get welcomeHeroPost => '\ntake it with you.';

  @override
  String get welcomeSubtitle =>
      'Sync your Stardew Valley saves across all your devices. Your data lives in your own Google Drive — no servers, no subscriptions, under your control.';

  @override
  String get welcomeDriveConnected => 'Drive connected';

  @override
  String get welcomeFooterTagline => '· Non-commercial · Free forever ·';

  @override
  String updateVersionAvailable(String version) {
    return 'v$version available';
  }
}
