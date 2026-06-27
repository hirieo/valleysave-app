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
