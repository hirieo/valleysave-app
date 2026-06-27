// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Chinese (`zh`).
class AppLocalizationsZh extends AppLocalizations {
  AppLocalizationsZh([String locale = 'zh']) : super(locale);

  @override
  String get appTitle => 'ValleySave';

  @override
  String get welcomeTitle => '永远不要失去你的农场，随身携带。';

  @override
  String get connectGoogleDrive => '连接 Google Drive';

  @override
  String get connecting => '正在连接…';

  @override
  String get mySaves => '我的存档';

  @override
  String get howItWorks => '工作原理';

  @override
  String get settings => '设置';

  @override
  String get aboutSection => '关于';

  @override
  String get openSource => '可用代码';

  @override
  String get nonCommercial => '非商业';

  @override
  String get freeForever => '永久免费';

  @override
  String get privacyTitle => '隐私和数据使用';

  @override
  String get privacyDescription =>
      'ValleySave 是一款应用，可将您的 Stardew Valley 存档与您自己的 Google Drive 账户同步。';

  @override
  String get whatDataTitle => '使用哪些数据';

  @override
  String get whatDataDesc => 'ValleySave 仅访问制作副本、同步或恢复所需的 Stardew Valley 存档文件。';

  @override
  String get googleDriveTitle => 'Google Drive';

  @override
  String get googleDriveDesc =>
      '您的存档被上传到您自己的 Google Drive 账户。ValleySave 不使用其自有服务器来存储您的游戏。';

  @override
  String get androidPermissionsTitle => 'Android 上的权限';

  @override
  String get androidPermissionsDesc =>
      'ValleySave 可能需要存储权限或 Shizuku 等工具来访问存档文件。';

  @override
  String get adsTitle => '广告';

  @override
  String get adsDesc => 'ValleySave 可能通过 Google AdMob 显示广告。';

  @override
  String get responsibilityTitle => '责任';

  @override
  String get responsibilityDesc => '您的存档文件是您的责任。';

  @override
  String get deleteDataTitle => '删除数据';

  @override
  String get deleteDataDesc =>
      '您可以通过从 Google Drive 手动删除 ValleySave 文件夹来删除同步的副本。';

  @override
  String get sourceCodeTitle => '源代码和联系';

  @override
  String get sourceCodeDesc =>
      'ValleySave 是一个在 Polyform Noncommercial 许可证下提供可用代码的项目。';

  @override
  String get upToDate => '最新';

  @override
  String get checkingUpdates => '正在检查…';

  @override
  String get updateAvailable => '有可用更新';

  @override
  String get application => '应用';

  @override
  String version(Object version) {
    return '版本 $version';
  }

  @override
  String get checkForUpdates => '检查更新';

  @override
  String get shizukuRequired => '需要 Shizuku';

  @override
  String get shizukuGuide => 'Shizuku 设置指南';

  @override
  String get activateShizuku => '启用 Shizuku 以在游戏中写入存档。';

  @override
  String deleteSaveTitle(Object saveName) {
    return '删除 $saveName';
  }

  @override
  String get deleteSaveMessage => '这将从此设备中删除存档。你想继续吗？';

  @override
  String get deleteFromDrive => '从 Drive 中删除';

  @override
  String confirmDelete(Object saveName) {
    return '存档 $saveName 将移至 Google Drive 回收站。';
  }

  @override
  String deleteFromDeviceMessage(Object saveName) {
    return '存档 $saveName 将从此设备中永久删除。';
  }

  @override
  String restoreSaveTitle(Object saveName) {
    return '恢复 $saveName';
  }

  @override
  String restoreSaveMessage(Object saveName) {
    return '将 $saveName 下载到此设备？';
  }

  @override
  String get restore => '恢复';

  @override
  String get cancel => '取消';

  @override
  String get error => '错误';

  @override
  String get success => '成功';

  @override
  String get loading => '正在加载…';

  @override
  String get disconnect => '断开连接';

  @override
  String get ok => '确定';

  @override
  String get yes => '是';

  @override
  String get no => '否';

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

  @override
  String get hiwComparePrimary => 'Total playtime';

  @override
  String get hiwCompareNoShown1 => 'Crop and animal status';

  @override
  String get hiwCompareNoShown2 => 'Inventory and items';

  @override
  String get hiwCompareNoShown3 => 'Individual relationships';

  @override
  String get hiwShizuku1 => 'Install Shizuku (Play Store or GitHub APK).';

  @override
  String get hiwShizuku2 =>
      'Activate it with Wireless Debugging — ValleySave guides you step by step.';

  @override
  String get hiwShizuku3 => 'Grant permission to ValleySave when prompted.';

  @override
  String get hiwBridge1 =>
      'Download from Drive: ValleySave leaves the save in its folder. You copy it with Files to Stardew\'s folder.';

  @override
  String get hiwBridge2 =>
      'Upload to Drive: copy the save from Stardew to ValleySave\'s folder. ValleySave detects it and uploads it.';

  @override
  String get snackShizukuBattery =>
      'Settings → Apps → Shizuku → Battery → Unrestricted.';

  @override
  String snackDriveError(String error) {
    return 'Drive: $error';
  }

  @override
  String get dlgDeleteLocalWarning =>
      '⚠️ If you haven\'t uploaded to Drive, it will be lost forever. No recovery.';

  @override
  String get dlgDelete => 'Delete';

  @override
  String get dlgDownloadButton => 'Download';

  @override
  String get dlgUploadButton => 'Upload';

  @override
  String get dlgBridgeCopyTitle => 'Copy save to game';

  @override
  String dlgBridgeCopyDesc(String saveName) {
    return 'Save is ready. With your Files app, copy the \"$saveName\" folder and paste it into the Stardew folder.';
  }

  @override
  String get labelFrom => 'From';

  @override
  String get labelTo => 'To';

  @override
  String dlgDownloadNewDesc(String saveName, int day, String playtime) {
    return '\"$saveName\" (Day $day, $playtime) will be copied to this device.';
  }

  @override
  String dlgDownloadOverwrite(String saveName) {
    return 'This OVERWRITES your local save of \"$saveName\".';
  }

  @override
  String dlgUploadNewDesc(String saveName, int day, String playtime) {
    return '\"$saveName\" (Day $day, $playtime) will be uploaded to your Drive.';
  }

  @override
  String dlgUploadOverwriteDrive(String saveName) {
    return 'This OVERWRITES the Drive version of \"$saveName\".';
  }

  @override
  String get pathLabelFromStardew => 'From (Stardew)';

  @override
  String get pathLabelToValleySave => 'To (ValleySave)';

  @override
  String get chooserDesc =>
      'Android protects the game folder. Choose how to give ValleySave access — you can change it anytime.';

  @override
  String get chooserShizukuDesc =>
      'Configured once. After that ValleySave syncs on its own, without you touching anything. Only reliable method on Android 13+.';

  @override
  String get chooserManualBadge => 'ONLY ANDROID 11-12';

  @override
  String get chooserBridgeDesc =>
      'Copy saves with your Files app. No extra install. Only on Android 11 and 12.';

  @override
  String get shizukuGateSubtitle => 'Configured once · first time only';

  @override
  String get shizukuStatusLabel => 'Shizuku active';

  @override
  String get shizukuStatusRunning => 'Connected and waiting.';

  @override
  String get shizukuStatusNotDetected => 'Not detected yet.';

  @override
  String get shizukuPermLabel => 'Permission granted';

  @override
  String get shizukuPermGranted => 'ValleySave already has access.';

  @override
  String get shizukuPermNotGranted => 'Need to authorize ValleySave.';

  @override
  String get shizukuGrant => 'grant';

  @override
  String get shizukuGuideHeader => 'STEP-BY-STEP GUIDE';

  @override
  String get shizukuStep1DescFull =>
      'Free. If Google Play blocks it on your phone, use the official GitHub APK.';

  @override
  String get btnPlayStore => 'Play Store';

  @override
  String get btnApkGithub => 'APK GitHub';

  @override
  String get shizukuStep2TitleFull => 'Enable Developer Options';

  @override
  String get shizukuStep2DescFull =>
      'Settings → Phone info → Software info → tap \"Build number\" 7 times.';

  @override
  String get shizukuStep3TitleFull => 'Enable Wireless Debugging';

  @override
  String get shizukuStep3DescFull =>
      'The button takes you there and highlights it. Enable it (ON). Then tap \"Pair device with pairing code\" — a 6-digit code will appear on screen.';

  @override
  String get btnOpenAndHighlight => 'Open and highlight';

  @override
  String get shizukuStep4Title => 'Pair and START Shizuku';

  @override
  String get shizukuStep4Desc =>
      'Open Shizuku → \"Start via Wireless Debugging\" → \"Pair with pairing code\". Shizuku will send a notification saying it\'s waiting. Enter the 6-digit code from the Wireless Debugging screen. After pairing, press START — without that last tap Shizuku won\'t be active.';

  @override
  String get btnOpenShizuku => 'Open Shizuku';

  @override
  String get shizukuStep5Title => 'Set Shizuku battery to Unrestricted';

  @override
  String get shizukuStep5Desc =>
      'Open app info → Battery → Unrestricted. If you don\'t, the system will close Shizuku in the background and you\'ll have to press Start again.';

  @override
  String get btnShizukuAppInfo => 'Shizuku app info';

  @override
  String get shizukuStep6DescActive =>
      'Shizuku is active. Tap the button to authorize.';

  @override
  String get shizukuStep6DescWaiting =>
      'Available once Shizuku is active (step 4).';

  @override
  String get btnGrantPermission => 'Grant permission';

  @override
  String get btnCheckShizuku => 'Done · Check';

  @override
  String get statusDone => 'done';

  @override
  String get statusPending => 'pending';

  @override
  String get latestBadge => '· LATEST SAVE ·';

  @override
  String saveDateLabel(String season, int year) {
    return '$season · Year $year';
  }

  @override
  String get petCat => 'Cat';

  @override
  String get petDog => 'Dog';

  @override
  String get houseBasic => 'Basic house';

  @override
  String get houseKitchen => 'With kitchen';

  @override
  String get houseBedroom => 'With bedroom';

  @override
  String get houseCellar => 'With cellar';

  @override
  String houseLevelN(int level) {
    return 'Lv. $level';
  }
}

/// The translations for Chinese, using the Han script (`zh_Hant`).
class AppLocalizationsZhHant extends AppLocalizationsZh {
  AppLocalizationsZhHant() : super('zh_Hant');

  @override
  String get appTitle => 'ValleySave';

  @override
  String get welcomeTitle => '永遠不要失去你的農場，隨身攜帶。';

  @override
  String get connectGoogleDrive => '連接 Google Drive';

  @override
  String get connecting => '正在連接…';

  @override
  String get mySaves => '我的存檔';

  @override
  String get howItWorks => '運作原理';

  @override
  String get settings => '設定';

  @override
  String get aboutSection => '關於';

  @override
  String get openSource => '可用代碼';

  @override
  String get nonCommercial => '非商業';

  @override
  String get freeForever => '永久免費';

  @override
  String get privacyTitle => '隱私和數據使用';

  @override
  String get privacyDescription =>
      'ValleySave 是一款應用，可將您的 Stardew Valley 存檔與您自己的 Google Drive 帳戶同步。';

  @override
  String get whatDataTitle => '使用哪些數據';

  @override
  String get whatDataDesc => 'ValleySave 僅訪問製作副本、同步或恢復所需的 Stardew Valley 存檔文件。';

  @override
  String get googleDriveTitle => 'Google Drive';

  @override
  String get googleDriveDesc =>
      '您的存檔被上傳到您自己的 Google Drive 帳戶。ValleySave 不使用其自有伺服器來儲存您的遊戲。';

  @override
  String get androidPermissionsTitle => 'Android 上的權限';

  @override
  String get androidPermissionsDesc =>
      'ValleySave 可能需要儲存權限或 Shizuku 等工具來訪問存檔文件。';

  @override
  String get adsTitle => '廣告';

  @override
  String get adsDesc => 'ValleySave 可能透過 Google AdMob 顯示廣告。';

  @override
  String get responsibilityTitle => '責任';

  @override
  String get responsibilityDesc => '您的存檔文件是您的責任。';

  @override
  String get deleteDataTitle => '刪除數據';

  @override
  String get deleteDataDesc =>
      '您可以透過從 Google Drive 手動刪除 ValleySave 文件夾來刪除同步的副本。';

  @override
  String get sourceCodeTitle => '源代碼和聯繫';

  @override
  String get sourceCodeDesc =>
      'ValleySave 是一個在 Polyform Noncommercial 許可證下提供可用代碼的項目。';

  @override
  String get upToDate => '最新';

  @override
  String get checkingUpdates => '正在檢查…';

  @override
  String get updateAvailable => '有可用更新';

  @override
  String get application => '應用';

  @override
  String version(Object version) {
    return '版本 $version';
  }

  @override
  String get checkForUpdates => '檢查更新';

  @override
  String get shizukuRequired => '需要 Shizuku';

  @override
  String get shizukuGuide => 'Shizuku 設定指南';

  @override
  String get activateShizuku => '啟用 Shizuku 以在遊戲中寫入存檔。';

  @override
  String deleteSaveTitle(Object saveName) {
    return '刪除 $saveName';
  }

  @override
  String get deleteSaveMessage => '這將從此設備中刪除存檔。你想繼續嗎？';

  @override
  String get deleteFromDrive => '從 Drive 中刪除';

  @override
  String confirmDelete(Object saveName) {
    return '存檔 $saveName 將移至 Google Drive 回收站。';
  }

  @override
  String deleteFromDeviceMessage(Object saveName) {
    return '存檔 $saveName 將從此設備中永久刪除。';
  }

  @override
  String restoreSaveTitle(Object saveName) {
    return '恢復 $saveName';
  }

  @override
  String restoreSaveMessage(Object saveName) {
    return '將 $saveName 下載到此設備？';
  }

  @override
  String get restore => '恢復';

  @override
  String get cancel => '取消';

  @override
  String get error => '錯誤';

  @override
  String get success => '成功';

  @override
  String get loading => '正在加載…';

  @override
  String get disconnect => '斷開連接';

  @override
  String get ok => '確定';

  @override
  String get yes => '是';

  @override
  String get no => '否';
}
