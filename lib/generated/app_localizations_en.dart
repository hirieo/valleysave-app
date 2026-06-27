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
  String get openSource => 'Source available';

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
  String get updateCheckedNow => 'Just checked';

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
  String get languageAuto => 'System language';

  @override
  String get languageAutoDesc => 'Uses your system language';

  @override
  String get privacyPolicyTitle => 'Privacy policy';

  @override
  String get privacyBeforeStartTitle => 'Before you start';

  @override
  String get privacyLastUpdated => 'Last updated: June 2026';

  @override
  String get privacyAccept => 'Got it, continue';

  @override
  String get cardSynced => 'Synced';

  @override
  String get cardLocalAhead => 'Local ahead';

  @override
  String get cardDriveAhead => 'Drive ahead';

  @override
  String get cardLocalOnly => 'Local only';

  @override
  String get cardDriveOnly => 'Drive only';

  @override
  String get cardTimeNow => 'now';

  @override
  String cardTimeMinutesAgo(int minutes) {
    return '$minutes min ago';
  }

  @override
  String cardTimeHoursAgo(int hours) {
    return '${hours}h ago';
  }

  @override
  String cardTimeDaysAgo(int days) {
    return '${days}d ago';
  }

  @override
  String cardTimeMonthsAgo(int months) {
    return '${months}mo ago';
  }

  @override
  String get cardDetailLocalTitle => 'On this device';

  @override
  String get cardDetailRemoteTitle => 'On Drive';

  @override
  String get cardDetailUpload => 'Upload to Drive';

  @override
  String get cardDetailDownload => 'Download save';

  @override
  String get cardDetailDeleteLabel => 'Delete';

  @override
  String get cardDetailDeleteLocal => 'Delete from this device';

  @override
  String get cardDetailDeleteRemote => 'Delete from Drive';

  @override
  String get cardCloseBarrier => 'Close';

  @override
  String statDayYear(int day, int year) {
    return 'Day $day · Year $year';
  }

  @override
  String statDayOnly(int day) {
    return 'Day $day';
  }

  @override
  String get statPlaytime => 'Playtime';

  @override
  String get statMoney => 'Coins';

  @override
  String get statTotal => 'Total';

  @override
  String get statMineUnexplored => 'Unexplored';

  @override
  String get statMine => 'Mine';

  @override
  String get statMineLvl => 'Mine · Lv';

  @override
  String get skillFarming => 'Farming';

  @override
  String get skillForaging => 'Foraging';

  @override
  String get skillMining => 'Mining';

  @override
  String get skillFishing => 'Fishing';

  @override
  String get skillCombat => 'Combat';

  @override
  String get cardLocalPresence => 'On this device';

  @override
  String get cardRemotePresence => 'On Drive';

  @override
  String get cardNotPresent => 'Not here';

  @override
  String get cardActionSynced => 'Synced';

  @override
  String get cardActionUpload => 'Upload';

  @override
  String get cardActionDownload => 'Download';

  @override
  String get pillMonsters => 'monsters';

  @override
  String get pillFriends => 'friends';

  @override
  String get pillFaints => 'faints';

  @override
  String get pillSleeps => 'Sleeps';

  @override
  String get hiwTitle => 'How it works';

  @override
  String get hiwSyncTitle => 'How sync works';

  @override
  String get hiwSyncIntro =>
      'ValleySave uses your own Google Drive to move saves between devices. No intermediary servers: the files are yours.';

  @override
  String get hiwSyncDevice => 'Your\ndevice';

  @override
  String get hiwSyncCloud => 'Google\nDrive';

  @override
  String get hiwSyncOtherDevice => 'Other\ndevice';

  @override
  String get hiwUploadTitle => 'Upload a save';

  @override
  String get hiwUploadDesc =>
      'When you upload, ValleySave copies both save files (SaveGameInfo + farm file) to your ValleySave/ folder on Drive.';

  @override
  String get hiwDownloadTitle => 'Download a save';

  @override
  String get hiwDownloadDesc =>
      'When you download, ValleySave brings the files from Drive and places them directly in the game folder.';

  @override
  String get hiwCompareTitle => 'What does it compare?';

  @override
  String get hiwCompareIntro =>
      'To know which version is ahead, ValleySave uses total playtime — the only data that can only grow.';

  @override
  String get hiwCompareNote =>
      'Before confirming you\'ll also see, so you can decide:';

  @override
  String get hiwCompareMoney => 'Current money and total earned';

  @override
  String get hiwCompareMine => 'Mine level';

  @override
  String get hiwCompareSkills => 'Skills (farming, mining, combat…)';

  @override
  String get hiwCompareRelations => 'Friends, monsters killed, faints';

  @override
  String get hiwCompareStamina => 'Stamina and health';

  @override
  String get hiwCompareNotShown =>
      'These are not shown — they change in any direction and don\'t indicate which save is ahead.';

  @override
  String get hiwCompareNotShownExamples =>
      'Crop and animal status, inventory and items, individual relationships';

  @override
  String get hiwCompareWarning =>
      'They\'re not shown — they change in any direction and don\'t indicate which save is ahead.';

  @override
  String get hiwConflictTitle => 'If you play without syncing';

  @override
  String get hiwConflictDesc =>
      'If you advance on mobile and PC without syncing between sessions, you end up with two versions of the same save.';

  @override
  String get hiwConflictNoMerge =>
      'They can\'t be merged. ValleySave always shows you both versions so you can choose which to keep.';

  @override
  String get hiwConflictMobile => 'Mobile';

  @override
  String get hiwConflictVersionA => 'version A';

  @override
  String get hiwConflictPC => 'PC';

  @override
  String get hiwConflictVersionB => 'version B';

  @override
  String get hiwDeleteTitle => 'If a save is deleted';

  @override
  String get hiwDeleteDesc =>
      'When you delete a save from Drive, it doesn\'t disappear immediately: it goes to Google Drive Trash.';

  @override
  String get hiwCompatTitle => 'Platform compatibility';

  @override
  String get hiwCompatAndroidAccess => 'ACCESS ON ANDROID';

  @override
  String get hiwShizukuTitle => 'With Shizuku';

  @override
  String get hiwShizukuSubtitle =>
      'Set up once. After that, ValleySave syncs by itself, without you ever touching it again.';

  @override
  String get hiwShizukuBadge => 'AUTOMATIC · RECOMMENDED';

  @override
  String get hiwShizukuDone =>
      '✓  Done. From then on, downloading and uploading saves is direct, just like on a computer.';

  @override
  String get hiwShizukuNote =>
      'Pairing is only the first time. New Shizuku versions reactivate by themselves after restarting your phone.';

  @override
  String get hiwBridgeTitle => 'Manual bridge';

  @override
  String get hiwBridgeSubtitle =>
      'Only works on Android 11 and 12. You don\'t install anything extra; instead, you copy the save by hand with your Files app every time you sync.';

  @override
  String get hiwBridgeBadge => 'MANUAL ALTERNATIVE · ANDROID 11-12';

  @override
  String get hiwBridgeSaveFolder => 'Stardew\'s folder';

  @override
  String get hiwBridgeValleySaveFolder => 'ValleySave\'s folder';

  @override
  String get hiwBridgeNote =>
      'It works because your system Files app can access those folders (ValleySave can\'t).';

  @override
  String get hiwTipAlwaysShow =>
      'You\'ll always see what\'s on Drive before overwriting, so you can compare.';

  @override
  String get hiwTipWithoutUpload =>
      'Without uploading, no other device will see your recent progress.';

  @override
  String get hiwTipComparison =>
      'You\'ll see the comparison between local and Drive before confirming.';

  @override
  String get hiwTipDownloadOverwrite =>
      'Downloading overwrites your local save. Any unsynced progress will be lost.';

  @override
  String get hiwTipSync =>
      'Always upload before switching devices, and download when you arrive.';

  @override
  String get hiwTipDeletion =>
      'You have 30 days to restore it from Drive Trash before it\'s permanently deleted.';

  @override
  String get hiwPrivacyLink => 'Privacy policy and usage';

  @override
  String get emptyNoSaves => 'No saves found';

  @override
  String get emptyNoSavesHint => 'No local saves can be read on this device';

  @override
  String get bridgeTitle => 'Bring your saves';

  @override
  String get bridgeDesc =>
      'To see and upload your local saves, copy them with your Files app from the Stardew folder to this ValleySave folder. Then swipe to refresh.';

  @override
  String get bridgeRefresh => 'Refresh';

  @override
  String get bridgeChangeMode => 'Change method';

  @override
  String get loaderLoading => 'LOADING';

  @override
  String get loaderConnecting => 'connecting to Drive…';

  @override
  String get chooserTitle => 'Choose how to connect';

  @override
  String get chooserAutomatic => 'Automatic · Recommended';

  @override
  String get chooserManual => 'Manual alternative · Android 11-12';

  @override
  String get shizukuStepTitle => 'Set up Shizuku';

  @override
  String get shizukuStep1Title => 'Install Shizuku';

  @override
  String get shizukuStep1Desc => 'Download from Play Store or GitHub';

  @override
  String get shizukuStep2Title => 'Activate Shizuku';

  @override
  String get shizukuStep2Desc => 'Run the app and grant permissions';

  @override
  String get shizukuStep3Title => 'Grant permission';

  @override
  String get shizukuStep3Desc => 'ValleySave will ask for access';

  @override
  String get shizukuDone =>
      '✓  Done. From then on, downloading and uploading saves works directly, like on a computer.';

  @override
  String get dlgDeleteDriveTitle => 'Delete from Drive';

  @override
  String get dlgDeleteLocalTitle => 'Delete from this device';

  @override
  String get dlgDownloadTitle => 'Download save';

  @override
  String get dlgUploadTitle => 'Upload save';

  @override
  String get dlgUploadOverwrite => 'This will overwrite your local save';

  @override
  String get dlgGotIt => 'Got it';

  @override
  String get dlgCopyDest => 'Copy destination';

  @override
  String get previewColDayYear => 'Day/Year';

  @override
  String get previewColTime => 'Playtime';

  @override
  String get previewColMoney => 'Coins';

  @override
  String get previewColTotal => 'Total';

  @override
  String get previewColFarming => 'Farming';

  @override
  String get previewColForaging => 'Foraging';

  @override
  String get previewColMining => 'Mining';

  @override
  String get previewColFishing => 'Fishing';

  @override
  String get previewColCombat => 'Combat';

  @override
  String get previewColFriends => 'Friends';

  @override
  String get previewColMonsters => 'Monsters';

  @override
  String get previewColFaints => 'Faints';

  @override
  String get previewColMine => 'Mine';

  @override
  String get previewColUnexplored => 'Unexplored';

  @override
  String get previewLocalLabel => 'ON THIS DEVICE';

  @override
  String get previewDriveLabel => 'ON DRIVE';

  @override
  String get previewFromDrive => 'FROM DRIVE';

  @override
  String get previewFromDevice => 'FROM THIS DEVICE';

  @override
  String versionMismatch(String local, String drive) {
    return 'Different versions: local $local · Drive $drive…';
  }

  @override
  String get snackPathCopied => 'Path copied';

  @override
  String get snackDestCopied => 'Destination path copied';

  @override
  String get snackDownloaded => 'Save downloaded to the game';

  @override
  String get snackSessionExpired => 'Drive session expired. Reconnect';

  @override
  String snackUploadError(String error) {
    return 'Upload error: $error';
  }

  @override
  String snackDownloadError(String error) {
    return 'Download error: $error';
  }

  @override
  String snackDeleteError(String error) {
    return 'Delete error: $error';
  }

  @override
  String snackTrashed(String saveName) {
    return '\"$saveName\" moved to Drive Trash. You have 30 days to restore it.';
  }

  @override
  String snackDeletedLocal(String saveName) {
    return '\"$saveName\" deleted from this device';
  }

  @override
  String get snackShizukuRequired => 'Enable Shizuku…';

  @override
  String get snackWriteError =>
      'Could not write to the game. Some phones block /Android/data even with Shizuku.';

  @override
  String get snackPlatformNotSupported =>
      'This platform doesn\'t support writing local saves yet.';

  @override
  String get snackWirelessDebugHint =>
      'Open manually: Settings → Developer options → Wireless debugging.';

  @override
  String get snackOpenShizukuApp => 'Open Shizuku from your app drawer.';

  @override
  String get hiwTipDeletePermanent =>
      'ValleySave can\'t recover permanently deleted saves. Drive files are your responsibility.';

  @override
  String get hiwCompatAchievements =>
      'Steam and Google Play achievements don\'t transfer. Each platform only tracks achievements that happen in real time — the save file doesn\'t trigger them retroactively.';

  @override
  String get hiwCompatOverwrite =>
      'If you sync from two devices without a set order, one save can overwrite the other. Always upload before downloading.';

  @override
  String get hiwCompatVersions =>
      'Saves from different game versions may not load correctly. ValleySave warns you if it detects a version mismatch before downloading.';

  @override
  String get hiwCompatMods =>
      'SMAPI mods add extra data to the save. If you load a modded save on a device where those mods aren\'t installed, the game may crash or lose mod data.\n\nOn Android, SMAPI can also be installed to use mods.';
}
