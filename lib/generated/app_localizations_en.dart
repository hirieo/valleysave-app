// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'ValleySave';

  @override
  String get welcomeTitle => 'Never lose your farm, take it with you.';

  @override
  String get connectGoogleDrive => 'Connect Google Drive';

  @override
  String get connecting => 'Connecting…';

  @override
  String get mySaves => 'My Saves';

  @override
  String get howItWorks => 'How it works';

  @override
  String get settings => 'Settings';

  @override
  String get aboutSection => 'About';

  @override
  String get openSource => 'Available code';

  @override
  String get nonCommercial => 'Non-commercial';

  @override
  String get freeForever => 'Free forever';

  @override
  String get privacyTitle => 'Privacy and data usage';

  @override
  String get privacyDescription =>
      'ValleySave is an app for syncing your Stardew Valley saves with your own Google Drive account.';

  @override
  String get whatDataTitle => 'What data it uses';

  @override
  String get whatDataDesc =>
      'ValleySave only accesses the Stardew Valley save files necessary to make copies, sync them, or restore them.';

  @override
  String get googleDriveTitle => 'Google Drive';

  @override
  String get googleDriveDesc =>
      'Your saves are uploaded to your own Google Drive account. ValleySave doesn\'t use its own servers to store your games.';

  @override
  String get androidPermissionsTitle => 'Permissions on Android';

  @override
  String get androidPermissionsDesc =>
      'ValleySave may need storage permissions or tools like Shizuku to access save files.';

  @override
  String get adsTitle => 'Ads';

  @override
  String get adsDesc => 'ValleySave may show ads through Google AdMob.';

  @override
  String get responsibilityTitle => 'Responsibility';

  @override
  String get responsibilityDesc => 'Your save files are your responsibility.';

  @override
  String get deleteDataTitle => 'Delete data';

  @override
  String get deleteDataDesc =>
      'You can delete your synchronized copies by manually deleting the ValleySave folder from Google Drive.';

  @override
  String get sourceCodeTitle => 'Source code and contact';

  @override
  String get sourceCodeDesc =>
      'ValleySave is a project with available code under Polyform Noncommercial license.';

  @override
  String get upToDate => 'Up to date';

  @override
  String get checkingUpdates => 'Checking…';

  @override
  String get updateAvailable => 'Update available';

  @override
  String get application => 'Application';

  @override
  String version(Object version) {
    return 'Version $version';
  }

  @override
  String get checkForUpdates => 'Check for updates';

  @override
  String get shizukuRequired => 'Shizuku required';

  @override
  String get shizukuGuide => 'Shizuku Setup Guide';

  @override
  String get activateShizuku => 'Enable Shizuku to write the save in the game.';

  @override
  String deleteSaveTitle(Object saveName) {
    return 'Delete $saveName';
  }

  @override
  String get deleteSaveMessage =>
      'This will remove the save from this device. Do you want to continue?';

  @override
  String get deleteFromDrive => 'Delete from Drive';

  @override
  String confirmDelete(Object saveName) {
    return 'The $saveName will be moved to Google Drive Trash.';
  }

  @override
  String deleteFromDeviceMessage(Object saveName) {
    return 'The $saveName will be deleted permanently from this device.';
  }

  @override
  String restoreSaveTitle(Object saveName) {
    return 'Restore $saveName';
  }

  @override
  String restoreSaveMessage(Object saveName) {
    return 'Download $saveName to this device?';
  }

  @override
  String get restore => 'Restore';

  @override
  String get cancel => 'Cancel';

  @override
  String get error => 'Error';

  @override
  String get success => 'Success';

  @override
  String get loading => 'Loading…';

  @override
  String get disconnect => 'Disconnect';

  @override
  String get ok => 'OK';

  @override
  String get yes => 'Yes';

  @override
  String get no => 'No';
}
