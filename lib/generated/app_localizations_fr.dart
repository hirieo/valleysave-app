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
}
