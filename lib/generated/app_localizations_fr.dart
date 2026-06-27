// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for French (`fr`).
class AppLocalizationsFr extends AppLocalizations {
  AppLocalizationsFr([String locale = 'fr']) : super(locale);

  @override
  String get appTitle => 'ValleySave';

  @override
  String get welcomeTitle =>
      'Ne perdez jamais votre ferme, emportez-la partout.';

  @override
  String get connectGoogleDrive => 'Connecter Google Drive';

  @override
  String get connecting => 'Connexion…';

  @override
  String get mySaves => 'Mes sauvegardes';

  @override
  String get howItWorks => 'Comment ça marche';

  @override
  String get settings => 'Paramètres';

  @override
  String get aboutSection => 'À propos';

  @override
  String get openSource => 'Code disponible';

  @override
  String get nonCommercial => 'Non commercial';

  @override
  String get freeForever => 'Gratuit pour toujours';

  @override
  String get privacyTitle => 'Confidentialité et utilisation des données';

  @override
  String get privacyDescription =>
      'ValleySave est une application pour synchroniser vos sauvegardes Stardew Valley avec votre propre compte Google Drive.';

  @override
  String get whatDataTitle => 'Quelles données sont utilisées';

  @override
  String get whatDataDesc =>
      'ValleySave n\'accède qu\'aux fichiers de sauvegarde Stardew Valley nécessaires pour faire des copies, les synchroniser ou les restaurer.';

  @override
  String get googleDriveTitle => 'Google Drive';

  @override
  String get googleDriveDesc =>
      'Vos sauvegardes sont téléchargées sur votre propre compte Google Drive. ValleySave n\'utilise pas ses propres serveurs pour stocker vos jeux.';

  @override
  String get androidPermissionsTitle => 'Permissions sur Android';

  @override
  String get androidPermissionsDesc =>
      'ValleySave peut avoir besoin de permissions de stockage ou d\'outils comme Shizuku pour accéder aux fichiers de sauvegarde.';

  @override
  String get adsTitle => 'Publicités';

  @override
  String get adsDesc =>
      'ValleySave peut afficher des publicités via Google AdMob.';

  @override
  String get responsibilityTitle => 'Responsabilité';

  @override
  String get responsibilityDesc =>
      'Vos fichiers de sauvegarde sont votre responsabilité.';

  @override
  String get deleteDataTitle => 'Supprimer les données';

  @override
  String get deleteDataDesc =>
      'Vous pouvez supprimer vos copies synchronisées en supprimant manuellement le dossier ValleySave de Google Drive.';

  @override
  String get sourceCodeTitle => 'Code source et contact';

  @override
  String get sourceCodeDesc =>
      'ValleySave est un projet avec code disponible sous licence Polyform Noncommercial.';

  @override
  String get upToDate => 'À jour';

  @override
  String get checkingUpdates => 'Vérification…';

  @override
  String get updateAvailable => 'Mise à jour disponible';

  @override
  String get application => 'Application';

  @override
  String version(Object version) {
    return 'Version $version';
  }

  @override
  String get checkForUpdates => 'Vérifier les mises à jour';

  @override
  String get shizukuRequired => 'Shizuku requis';

  @override
  String get shizukuGuide => 'Guide de configuration de Shizuku';

  @override
  String get activateShizuku =>
      'Activez Shizuku pour écrire la sauvegarde dans le jeu.';

  @override
  String deleteSaveTitle(Object saveName) {
    return 'Supprimer $saveName';
  }

  @override
  String get deleteSaveMessage =>
      'Cela supprimera la sauvegarde de cet appareil. Voulez-vous continuer?';

  @override
  String get deleteFromDrive => 'Supprimer de Drive';

  @override
  String confirmDelete(Object saveName) {
    return 'La sauvegarde $saveName sera déplacée vers la Corbeille de Google Drive.';
  }

  @override
  String deleteFromDeviceMessage(Object saveName) {
    return 'La sauvegarde $saveName sera supprimée définitivement de cet appareil.';
  }

  @override
  String restoreSaveTitle(Object saveName) {
    return 'Restaurer $saveName';
  }

  @override
  String restoreSaveMessage(Object saveName) {
    return 'Télécharger $saveName sur cet appareil?';
  }

  @override
  String get restore => 'Restaurer';

  @override
  String get cancel => 'Annuler';

  @override
  String get error => 'Erreur';

  @override
  String get success => 'Succès';

  @override
  String get loading => 'Chargement…';

  @override
  String get disconnect => 'Déconnecter';

  @override
  String get ok => 'OK';

  @override
  String get yes => 'Oui';

  @override
  String get no => 'Non';

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

  @override
  String get sectionMode => 'Mode';

  @override
  String get sectionSeason => 'Season';

  @override
  String get sectionLanguage => 'Language';

  @override
  String get modeAutoTitle => 'Automatic';

  @override
  String get modeAutoDesc =>
      'Follows your active save and, if no saves, your real location.';

  @override
  String get modeSavesTitle => 'By save';

  @override
  String get modeSavesDesc =>
      'Always uses the season from your most recent save.';

  @override
  String get modeGeoTitle => 'By location';

  @override
  String get modeGeoDesc => 'Always uses the real season of your location.';

  @override
  String get modeFixedTitle => 'Fixed season';

  @override
  String get modeFixedDesc => 'Always shows the same season.';

  @override
  String get modeRandomTitle => 'Random';

  @override
  String get modeRandomDesc =>
      'Picks a different season each time you open the app.';

  @override
  String get seasonInitial => 'Initial';

  @override
  String get seasonSpring => 'Spring';

  @override
  String get seasonSummer => 'Summer';

  @override
  String get seasonFall => 'Fall';

  @override
  String get seasonWinter => 'Winter';

  @override
  String get autoPriorityTitle => 'Priority order';

  @override
  String get autoStep1Title => 'First launch';

  @override
  String get autoStep1Desc => 'Shows the initial state.';

  @override
  String get autoStep2Title => 'Active save';

  @override
  String get autoStep2Desc => 'Uses the season from your last synced save.';

  @override
  String get autoStep3Title => 'Location';

  @override
  String get autoStep3Desc =>
      'Detects your hemisphere and the real season of your region.';

  @override
  String get autoStep4Title => 'Default';

  @override
  String get autoStep4Desc => 'Initial (night mode) if no data is available.';

  @override
  String get versionInstalled => 'Installed version';

  @override
  String get updateNeverChecked => 'Never checked';

  @override
  String get updateCheckedNow => 'Checked now';

  @override
  String get updateOutdatedDownload => 'Not up to date · Download';

  @override
  String get disconnectTitle => 'Disconnect Drive?';

  @override
  String get disconnectBody =>
      'Your saves on Drive won\'t be deleted. You can reconnect anytime.';

  @override
  String get disconnectButton => 'Disconnect Drive';

  @override
  String get languageTileLabel => 'Language';

  @override
  String get languageDialogTitle => 'App language';

  @override
  String get searchHint => 'Search…';

  @override
  String get languageAuto => 'Auto · system';

  @override
  String get languageAutoDesc => 'Uses your system language';
}
