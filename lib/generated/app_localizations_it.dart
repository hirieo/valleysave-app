// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Italian (`it`).
class AppLocalizationsIt extends AppLocalizations {
  AppLocalizationsIt([String locale = 'it']) : super(locale);

  @override
  String get appTitle => 'ValleySave';

  @override
  String get welcomeTitle => 'Non perdere mai la tua fattoria, portala con te.';

  @override
  String get connectGoogleDrive => 'Connetti Google Drive';

  @override
  String get connecting => 'Connessione in corso…';

  @override
  String get mySaves => 'I miei salvataggi';

  @override
  String get howItWorks => 'Come funziona';

  @override
  String get settings => 'Impostazioni';

  @override
  String get aboutSection => 'Informazioni';

  @override
  String get openSource => 'Codice disponibile';

  @override
  String get nonCommercial => 'Non commerciale';

  @override
  String get freeForever => 'Gratuito per sempre';

  @override
  String get privacyTitle => 'Privacy e utilizzo dei dati';

  @override
  String get privacyDescription =>
      'ValleySave è un\'app per sincronizzare i tuoi salvataggi di Stardew Valley con il tuo account Google Drive.';

  @override
  String get whatDataTitle => 'Quali dati utilizza';

  @override
  String get whatDataDesc =>
      'ValleySave accede solo ai file di salvataggio di Stardew Valley necessari per fare copie, sincronizzarli o ripristinarli.';

  @override
  String get googleDriveTitle => 'Google Drive';

  @override
  String get googleDriveDesc =>
      'I tuoi salvataggi vengono caricati sul tuo account Google Drive. ValleySave non utilizza server propri per archiviare i tuoi giochi.';

  @override
  String get androidPermissionsTitle => 'Autorizzazioni su Android';

  @override
  String get androidPermissionsDesc =>
      'ValleySave potrebbe aver bisogno di autorizzazioni di archiviazione o strumenti come Shizuku per accedere ai file di salvataggio.';

  @override
  String get adsTitle => 'Annunci';

  @override
  String get adsDesc =>
      'ValleySave può visualizzare annunci tramite Google AdMob.';

  @override
  String get responsibilityTitle => 'Responsabilità';

  @override
  String get responsibilityDesc =>
      'I tuoi file di salvataggio sono tuia responsabilità.';

  @override
  String get deleteDataTitle => 'Elimina dati';

  @override
  String get deleteDataDesc =>
      'Puoi eliminare le tue copie sincronizzate eliminando manualmente la cartella ValleySave da Google Drive.';

  @override
  String get sourceCodeTitle => 'Codice sorgente e contatti';

  @override
  String get sourceCodeDesc =>
      'ValleySave è un progetto con codice disponibile sotto licenza Polyform Noncommercial.';

  @override
  String get upToDate => 'Aggiornato';

  @override
  String get checkingUpdates => 'Verifica in corso…';

  @override
  String get updateAvailable => 'Aggiornamento disponibile';

  @override
  String get application => 'Applicazione';

  @override
  String version(Object version) {
    return 'Versione $version';
  }

  @override
  String get checkForUpdates => 'Controlla aggiornamenti';

  @override
  String get shizukuRequired => 'Shizuku richiesto';

  @override
  String get shizukuGuide => 'Guida alla configurazione di Shizuku';

  @override
  String get activateShizuku =>
      'Attiva Shizuku per scrivere il salvataggio nel gioco.';

  @override
  String deleteSaveTitle(Object saveName) {
    return 'Elimina $saveName';
  }

  @override
  String get deleteSaveMessage =>
      'Questo eliminerà il salvataggio da questo dispositivo. Vuoi continuare?';

  @override
  String get deleteFromDrive => 'Elimina da Drive';

  @override
  String confirmDelete(Object saveName) {
    return 'Il salvataggio $saveName verrà spostato nel Cestino di Google Drive.';
  }

  @override
  String deleteFromDeviceMessage(Object saveName) {
    return 'Il salvataggio $saveName verrà eliminato permanentemente da questo dispositivo.';
  }

  @override
  String restoreSaveTitle(Object saveName) {
    return 'Ripristina $saveName';
  }

  @override
  String restoreSaveMessage(Object saveName) {
    return 'Scaricare $saveName su questo dispositivo?';
  }

  @override
  String get restore => 'Ripristina';

  @override
  String get cancel => 'Annulla';

  @override
  String get error => 'Errore';

  @override
  String get success => 'Successo';

  @override
  String get loading => 'Caricamento…';

  @override
  String get disconnect => 'Disconnetti';

  @override
  String get ok => 'OK';

  @override
  String get yes => 'Sì';

  @override
  String get no => 'No';

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
