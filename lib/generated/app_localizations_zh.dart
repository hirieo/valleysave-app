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
  String get ok => 'OK';

  @override
  String get yes => '是';

  @override
  String get no => '否';

  @override
  String get welcomeHeroPre => '永远不要\n失去你的';

  @override
  String get welcomeHeroAccent => '农场，';

  @override
  String get welcomeHeroPost => '\n随身携带。';

  @override
  String get welcomeSubtitle =>
      '将您的 Stardew Valley 存档在所有设备上同步。您的数据存放在您自己的 Google Drive 中——没有服务器，没有订阅，由您掌控。';

  @override
  String get welcomeDriveConnected => 'Drive 已连接';

  @override
  String get welcomeFooterTagline => '· 非商业 · 永久免费 ·';

  @override
  String updateVersionAvailable(String version) {
    return 'v$version 可用';
  }

  @override
  String get sectionMode => '模式';

  @override
  String get sectionSeason => '季节';

  @override
  String get sectionLanguage => '语言';

  @override
  String get modeAutoTitle => '自动';

  @override
  String get modeAutoDesc => '跟随您的活动存档，如果没有存档，则跟随您的实际位置。';

  @override
  String get modeSavesTitle => '按存档';

  @override
  String get modeSavesDesc => '始终使用您最近存档的季节。';

  @override
  String get modeGeoTitle => '按位置';

  @override
  String get modeGeoDesc => '始终使用您位置的实际季节。';

  @override
  String get modeFixedTitle => '固定季节';

  @override
  String get modeFixedDesc => '始终显示相同的季节。';

  @override
  String get modeRandomTitle => '随机';

  @override
  String get modeRandomDesc => '每次打开应用时选择不同的季节。';

  @override
  String get seasonInitial => '初始';

  @override
  String get seasonSpring => '春季';

  @override
  String get seasonSummer => '夏季';

  @override
  String get seasonFall => '秋季';

  @override
  String get seasonWinter => '冬季';

  @override
  String get autoPriorityTitle => '优先级顺序';

  @override
  String get autoStep1Title => '首次启动';

  @override
  String get autoStep1Desc => '显示初始状态。';

  @override
  String get autoStep2Title => '活动存档';

  @override
  String get autoStep2Desc => '使用您最后同步的存档中的季节。';

  @override
  String get autoStep3Title => '位置';

  @override
  String get autoStep3Desc => '检测您的半球和您所在地区的实际季节。';

  @override
  String get autoStep4Title => '默认值';

  @override
  String get autoStep4Desc => '如果没有可用数据，则为初始（夜间模式）。';

  @override
  String get versionInstalled => '已安装版本';

  @override
  String get updateNeverChecked => '从未检查';

  @override
  String get updateCheckedNow => '刚刚检查';

  @override
  String get updateOutdatedDownload => '不是最新的 · 下载';

  @override
  String get updateDownloading => '正在下载更新…';

  @override
  String get updateError => '错误 — 点击重试';

  @override
  String get updateNeedsPermission => '为 ValleySave 启用\"安装未知应用\"，然后再次点击\"更新\"';

  @override
  String get disconnectTitle => '断开连接 Drive？';

  @override
  String disconnectBody(String email) {
    return '您的 Drive 上的存档不会被删除。您可以随时重新连接。';
  }

  @override
  String get disconnectButton => '断开连接 Drive';

  @override
  String disconnectButtonEmail(String email) {
    return 'Disconnect from $email';
  }

  @override
  String get connectedAsPrefix => 'Connected as';

  @override
  String get languageTileLabel => '语言';

  @override
  String get languageDialogTitle => '应用语言';

  @override
  String get searchHint => '搜索…';

  @override
  String get languageAuto => '系统语言';

  @override
  String get languageAutoDesc => '使用您的系统语言';

  @override
  String get privacyPolicyTitle => '隐私政策';

  @override
  String get privacyBeforeStartTitle => '开始前';

  @override
  String get privacyLastUpdated => '最后更新时间：2026 年 6 月';

  @override
  String get privacyAccept => '明白了，继续';

  @override
  String get cardSynced => '已同步';

  @override
  String get cardLocalAhead => '本地领先';

  @override
  String get cardDriveAhead => 'Drive 领先';

  @override
  String get cardLocalOnly => '仅本地';

  @override
  String get cardDriveOnly => '仅 Drive';

  @override
  String get cardTimeNow => '现在';

  @override
  String cardTimeMinutesAgo(int minutes) {
    return '$minutes 分钟前';
  }

  @override
  String cardTimeHoursAgo(int hours) {
    return '$hours 小时前';
  }

  @override
  String cardTimeDaysAgo(int days) {
    return '$days 天前';
  }

  @override
  String cardTimeMonthsAgo(int months) {
    return '$months 个月前';
  }

  @override
  String get cardDetailLocalTitle => '在此设备上';

  @override
  String get cardDetailRemoteTitle => '在 Drive 上';

  @override
  String get cardDetailUpload => '上传到 Drive';

  @override
  String get cardDetailDownload => '下载存档';

  @override
  String get cardDetailDeleteLabel => '删除';

  @override
  String get cardDetailDeleteLocal => '从此设备中删除';

  @override
  String get cardDetailDeleteRemote => '从 Drive 中删除';

  @override
  String get cardCloseBarrier => '关闭';

  @override
  String get exportAction => 'Export';

  @override
  String get exportSuccess => 'Save exported.';

  @override
  String exportError(String error) {
    return 'Couldn\'t export the save: $error';
  }

  @override
  String get importAction => 'Import save';

  @override
  String importSuccess(String playerName) {
    return '$playerName\'s save imported.';
  }

  @override
  String get importErrInvalidZip => 'This isn\'t a valid zip file.';

  @override
  String get importErrUnsafePath =>
      'This file has an unsafe structure and was rejected.';

  @override
  String get importErrTooLarge => 'This file is too large to import.';

  @override
  String get importErrNotASave =>
      'This file doesn\'t contain a recognizable save.';

  @override
  String get importErrWrite =>
      'Couldn\'t write the imported save (disk/permissions).';

  @override
  String get importErrBackupFailed =>
      'Couldn\'t create a safety backup. Nothing was imported.';

  @override
  String get importConflictTitle => 'A save with this name already exists';

  @override
  String get importConflictBody =>
      'Importing will replace the existing local copy. This can\'t be undone.';

  @override
  String get importConflictConfirm => 'Overwrite';

  @override
  String get shareAction => 'Share';

  @override
  String get shareUploadFirstCta => 'Upload first';

  @override
  String get shareDialogTitle => 'Share save';

  @override
  String get shareEmailPlaceholder => 'name@example.com';

  @override
  String get shareInfoNote =>
      'Sharing gives view-and-download access only. Only you can edit or delete your copy in Drive.';

  @override
  String get shareRoleReader => 'Read only';

  @override
  String get shareRoleWriter => 'Allow sync';

  @override
  String get shareInfoNoteCoop =>
      'Read only lets them view and download. Allow sync lets them overwrite your copy in Drive — they can never delete it.';

  @override
  String get shareConfirmButton => 'Share';

  @override
  String shareSuccess(String email) {
    return 'Shared with $email.';
  }

  @override
  String get manageAccessTitle => 'People with access';

  @override
  String get manageAccessEmpty => 'Nobody else has access yet.';

  @override
  String get manageAccessRoleLabel => 'Access';

  @override
  String get manageAccessRevoke => 'Revoke';

  @override
  String manageAccessRevokeConfirm(String email) {
    return 'Remove $email\'s access? Any local copy they already downloaded is theirs to keep.';
  }

  @override
  String get driveOnlyControlsYourCopy =>
      'Sharing controls your copy in Drive. If someone downloads it, that copy is theirs.';

  @override
  String get driveOnlyControlsYourCopyCoop =>
      'Sync controls your copy in Drive — it can be overwritten, but never deleted, by people you allow to sync.';

  @override
  String get sharedWithMeTitle => 'Shared with me';

  @override
  String get sharedWithMeEmpty => 'Nothing shared with you yet.';

  @override
  String get sharedWithMeAdd => 'Add shared save';

  @override
  String sharedWithMeOwnedBy(String email) {
    return 'Shared by $email';
  }

  @override
  String get sharedWithMeRoleSync => 'Sync';

  @override
  String get sharedWithMeRoleRead => 'Read only';

  @override
  String get sharedWithMeSync => 'Sync';

  @override
  String get sharedWithMeDownload => 'Download';

  @override
  String get sharedWithMeRemove => 'Remove from list';

  @override
  String sharedWithMeRemoveConfirm(String email) {
    return 'You\'ll stop syncing with $email\'s Drive, but you can add it back anytime — it stays shared. Your local copy remains a normal coop save.';
  }

  @override
  String sharedLeaveConfirm(Object email) {
    return 'You\'ll lose access to this save for real. You won\'t be able to add it back unless $email shares it with you again. Your local copy remains a normal coop save.';
  }

  @override
  String get sharedManageButton => 'Manage';

  @override
  String get sharedManageDialogTitle => 'Manage shared saves';

  @override
  String get sharedManageDialogHint =>
      'Here you can really leave a shared save.';

  @override
  String get sharedLeaveButton => 'Leave shared save';

  @override
  String sharedLeaveSuccess(Object email) {
    return 'You left $email\'s shared save.';
  }

  @override
  String sharedWithMeSyncConfirm(String email) {
    return 'Overwrite $email\'s copy in Drive with your local save?';
  }

  @override
  String sharedAccessReadOnly(String email) {
    return '$email set your access to read-only — you can view and download, but not sync to their Drive.';
  }

  @override
  String get sharedWithMeRevoked => 'You no longer have access';

  @override
  String sharedRevokedDialogBody(String email, String farmName) {
    return '$email stopped sharing $farmName with you. Your local copy and the one on your Drive stay as they are, now under My saves.';
  }

  @override
  String get sharedRevokedAccept => 'Accept';

  @override
  String get sharedSelfCleanupTitle => 'Record fixed';

  @override
  String sharedSelfCleanupBody(String farmName) {
    return '$farmName showed up as shared with you by mistake — it\'s actually yours. It\'s been fixed, now it\'s under My saves.';
  }

  @override
  String get sharedWithMeUploadOwn => 'Upload to my Drive';

  @override
  String get sharedDownloadOwn => 'Download from my Drive';

  @override
  String get sharedStatusOwnDriveAhead => 'Your Drive is ahead — bring it down';

  @override
  String get sharedSyncBoth => 'Sync both';

  @override
  String get sharedSideMyDrive => 'MY DRIVE';

  @override
  String sharedSideOwnerDrive(String email) {
    return '$email\'s DRIVE';
  }

  @override
  String sharedSideDate(int day, int year) {
    return 'Day $day · Year $year';
  }

  @override
  String get sharedStatusSyncedNoOwnDrive =>
      'Synced with the owner · no copy in your Drive';

  @override
  String get sharedStatusAheadNoOwnDrive =>
      'You\'re ahead · no copy in your Drive';

  @override
  String sharedStatusOwnerAheadNoOwnDrive(String email) {
    return '$email is ahead · no copy in your Drive';
  }

  @override
  String get sharedStatusAllSynced => 'Synced (local + both Drives)';

  @override
  String get sharedStatusAheadBoth => 'You\'re ahead on both Drives';

  @override
  String get sharedStatusMixed => 'Out of sync — check each Drive';

  @override
  String get sharedStatusFullySynced => 'Fully synchronized';

  @override
  String get sharedStatusSyncedOwn => 'My Drive synchronized';

  @override
  String get sharedStatusSyncedOwner => 'Shared Drive synchronized';

  @override
  String get sharedStatusNotCloud => 'Only on this device';

  @override
  String sharedStatusOwnerAhead(Object email) {
    return 'Drive at $email is ahead';
  }

  @override
  String get sharedStatusBothAhead => 'Both Drives are ahead';

  @override
  String get sharedStatusLocalMissing => 'Not on this device';

  @override
  String sharedStatusOwnerUnavailable(Object email) {
    return 'Could not check Drive at $email';
  }

  @override
  String get sharedStatusWorking => 'Synchronizing…';

  @override
  String get sharedSideUnavailable => 'Could not check';

  @override
  String get sharedSyncChooseTitle => 'Where do you want to synchronize?';

  @override
  String get sharedSyncChooseBody =>
      'Choose which cloud copies to update from this device.';

  @override
  String get sharedSyncTargetOwn => 'My Drive';

  @override
  String sharedSyncTargetOwner(Object email) {
    return 'Drive at $email';
  }

  @override
  String get sharedSyncTargetBoth => 'Both Drives';

  @override
  String get sharedDownloadChooseTitle => 'Which copy do you want to download?';

  @override
  String get sharedDownloadChooseBody =>
      'More than one copy is ahead. Choose which one to bring to this device.';

  @override
  String get sharedDownloadSourceOwn => 'From My Drive';

  @override
  String sharedDownloadSourceOwner(Object email) {
    return 'From Drive at $email';
  }

  @override
  String get sharedWithMePickerTitle => 'Add shared save';

  @override
  String get sharedPickerEmptyHint =>
      'Folders another player shares with you from Drive show up here.';

  @override
  String get sharedPickerAddButton => 'Add';

  @override
  String get sharedOriginBadge => 'Shared';

  @override
  String sharedOriginFrom(String email) {
    return 'from $email';
  }

  @override
  String get swapBackupDialogTitle => 'Backup created';

  @override
  String get swapBackupDialogBody =>
      'The previous version was saved as a zip. What do you want to do with it?';

  @override
  String get swapBackupUpload => 'Upload to Drive';

  @override
  String get swapBackupLocalOnly => 'Keep on this device';

  @override
  String get swapBackupDeleteNow => 'Delete now';

  @override
  String get swapBackupUploadOk => 'Backup uploaded to Drive.';

  @override
  String swapBackupUploadErr(String error) {
    return 'Couldn\'t upload the backup: $error';
  }

  @override
  String get swapBackupLocalOnlySnack => 'Backup saved on this device.';

  @override
  String get backupsAction => 'Backups';

  @override
  String backupsScreenTitle(String farmName) {
    return 'Backups of $farmName';
  }

  @override
  String get backupsEmpty => 'No backups yet.';

  @override
  String get backupsRestore => 'Restore';

  @override
  String get backupsRestoreConfirmTitle => 'Restore this backup?';

  @override
  String get backupsRestoreConfirmBody =>
      'This overwrites your current save with this earlier version. This can\'t be undone.';

  @override
  String get backupsDelete => 'Delete';

  @override
  String get backupsDeleteConfirmTitle => 'Delete this backup?';

  @override
  String get backupsDeleteConfirmBody =>
      'Deletes it everywhere it exists (this device and Drive, if uploaded). This can\'t be undone.';

  @override
  String get backupsRestoreOk => 'Backup restored.';

  @override
  String get backupsRestoreManualTitle => 'Restore manually';

  @override
  String get backupsRestoreManualBody =>
      'In bridge mode, ValleySave can\'t write to the game folder automatically. Extract this backup\'s .zip into Stardew Valley\'s Saves folder yourself, or switch to Root/Shizuku mode in Settings for automatic restore.';

  @override
  String backupsRestoreErr(String error) {
    return 'Couldn\'t restore the backup: $error';
  }

  @override
  String backupsDeleteErr(String error) {
    return 'Couldn\'t delete the backup: $error';
  }

  @override
  String get backupsCreate => 'Create local backup';

  @override
  String get backupsCreateLocalHint =>
      'Backups are created on this device first. You can upload them to Drive afterwards.';

  @override
  String get backupsCreateOk => 'Backup created.';

  @override
  String backupsCreateErr(String error) {
    return 'Couldn\'t create the backup: $error';
  }

  @override
  String get backupsDownload => 'Download';

  @override
  String get backupsDownloadOk => 'Backup downloaded to this device.';

  @override
  String backupsDownloadErr(String error) {
    return 'Couldn\'t download the backup: $error';
  }

  @override
  String get backupsCopyOwn => 'Copy to my Drive';

  @override
  String get backupsUploadOwn => 'To my Drive';

  @override
  String get backupsUploadShared => 'To shared Drive';

  @override
  String get backupsUploadOk => 'Backup uploaded.';

  @override
  String backupsUploadErr(String error) {
    return 'Couldn\'t upload the backup: $error';
  }

  @override
  String get backupsLocationLocal => 'This device';

  @override
  String get backupsLocationOwnDrive => 'My Drive';

  @override
  String get backupsLocationSharedDrive => 'Shared Drive';

  @override
  String get backupsDeleteChooseBody =>
      'Choose exactly where to delete it. Only locations where this backup exists are shown.';

  @override
  String get backupsDeleteLocalOnly => 'Only from this device';

  @override
  String get backupsDeleteOwnOnly => 'Only from my Drive';

  @override
  String get backupsDeleteSharedOnly => 'Only from shared Drive';

  @override
  String get backupsDeleteAll => 'From all copies';

  @override
  String deleteUnifiedTitle(String farmName) {
    return 'Delete $farmName?';
  }

  @override
  String get deleteChooseLocationBody =>
      'Choose where. Your device copy is deleted forever; the Drive copy goes to Trash (30 days).';

  @override
  String deleteDriveContextTitle(String farmName) {
    return 'Delete $farmName from Drive?';
  }

  @override
  String get deleteDriveContextBody =>
      'The Drive copy will move to Trash, where it can be recovered for 30 days.';

  @override
  String get deleteDriveLocalKept =>
      'The copy on this device will remain unchanged.';

  @override
  String deleteLocalContextTitle(String farmName) {
    return 'Delete $farmName from this device?';
  }

  @override
  String get deleteLocalContextBody =>
      'The copy on this device will be deleted permanently.';

  @override
  String deleteLocalDriveCurrent(String date) {
    return 'Your Drive copy is up to date ($date) and will remain available.';
  }

  @override
  String deleteLocalDriveAhead(String date) {
    return 'Your Drive copy is newer ($date) and will remain available.';
  }

  @override
  String deleteLocalDriveOlder(String driveDate, String localDate) {
    return 'Your Drive copy is older ($driveDate); this device is at $localDate.';
  }

  @override
  String deleteLocalBackupAvailable(int count) {
    return 'There are $count local backups available if you need an earlier copy.';
  }

  @override
  String get deleteLocalNoRecovery =>
      'There is no Drive copy or local backup to recover this game from.';

  @override
  String get deleteOptionLocalOnly => 'Only from this device';

  @override
  String get deleteOptionDriveOnly => 'Only from Drive';

  @override
  String get deleteOptionBoth => 'From both (device + Drive)';

  @override
  String get viewPlayersHint => 'View players';

  @override
  String snackDeletedBoth(String saveName) {
    return '\"$saveName\" deleted from this device and moved to Drive Trash.';
  }

  @override
  String statDayYear(int day, int year) {
    return '第 $day 天 · 第 $year 年';
  }

  @override
  String statDayOnly(int day) {
    return '第 $day 天';
  }

  @override
  String get statPlaytime => '游玩时间';

  @override
  String get statMoney => '金币';

  @override
  String get statTotal => '总计';

  @override
  String get statMineUnexplored => '未探索';

  @override
  String get statMine => '矿山';

  @override
  String get statMineLvl => '矿山 · 等级';

  @override
  String get skillFarming => '农业';

  @override
  String get skillForaging => '采集';

  @override
  String get skillMining => '采矿';

  @override
  String get skillFishing => '钓鱼';

  @override
  String get skillCombat => '战斗';

  @override
  String get cardLocalPresence => '在此设备上';

  @override
  String get cardRemotePresence => '在 Drive 上';

  @override
  String get cardNotPresent => '不在这里';

  @override
  String get cardActionSynced => '已同步';

  @override
  String get cardActionUpload => '上传';

  @override
  String get cardActionDownload => '下载';

  @override
  String get pillMonsters => '怪物';

  @override
  String get pillFriends => '朋友';

  @override
  String get pillFaints => '昏迷';

  @override
  String get pillSleeps => '睡眠';

  @override
  String get hiwTitle => '工作原理';

  @override
  String get hiwConnectTitle => 'Connect your account';

  @override
  String get hiwConnectDesc =>
      'ValleySave uses your Google account to store your saves in a private ValleySave folder on your own Drive.';

  @override
  String get hiwConnectStepGoogle => 'Google\naccount';

  @override
  String get hiwConnectStepDrive => 'ValleySave\nfolder created';

  @override
  String get hiwConnectStepReady => 'Ready to\nsync';

  @override
  String get hiwConnectTipOwnership =>
      'Only you can edit or delete your copies on Drive — ValleySave only reads and writes inside its own folder.';

  @override
  String get hiwSyncTitle => '同步原理';

  @override
  String get hiwSyncIntro =>
      'ValleySave 使用您自己的 Google Drive 在设备间移动存档。没有中介服务器：文件是您的。';

  @override
  String get hiwSyncDevice => '您的\n设备';

  @override
  String get hiwSyncCloud => 'Google\nDrive';

  @override
  String get hiwSyncOtherDevice => '其他\n设备';

  @override
  String get hiwUploadTitle => '上传存档';

  @override
  String get hiwUploadDesc =>
      '上传时，ValleySave 会将两个存档文件（SaveGameInfo + 农场文件）复制到您 Drive 上的 ValleySave/ 文件夹。';

  @override
  String get hiwDownloadTitle => '下载存档';

  @override
  String get hiwDownloadDesc => '下载时，ValleySave 从 Drive 获取文件并将其直接放在游戏文件夹中。';

  @override
  String get hiwCompareTitle => '它比较什么？';

  @override
  String get hiwCompareIntro => '为了确定哪个版本领先，ValleySave 使用总游玩时间——唯一只能增长的数据。';

  @override
  String get hiwCompareNote => '在确认之前，您也会看到，以便您可以决定：';

  @override
  String get hiwCompareMoney => '当前金钱和总收入';

  @override
  String get hiwCompareMine => '矿山等级';

  @override
  String get hiwCompareSkills => '技能（农业、采矿、战斗等）';

  @override
  String get hiwCompareRelations => '朋友、已杀死的怪物、昏迷次数';

  @override
  String get hiwCompareStamina => '体力和血量';

  @override
  String get hiwCompareNotShown => '这些不会显示——它们可以向任何方向改变，不表示哪个存档领先。';

  @override
  String get hiwCompareNotShownExamples => '作物和动物状态、库存和物品、个别关系';

  @override
  String get hiwCompareWarning => '它们不会显示——它们可以向任何方向改变，不表示哪个存档领先。';

  @override
  String get hiwConflictTitle => '如果您不进行同步就玩游戏';

  @override
  String get hiwConflictDesc =>
      '如果您在移动设备和 PC 上进行了游戏但没有在会话间进行同步，最终会得到同一存档的两个版本。';

  @override
  String get hiwConflictNoMerge => '它们无法合并。ValleySave 始终向您显示两个版本，以便您可以选择保留哪一个。';

  @override
  String get hiwConflictMobile => '移动设备';

  @override
  String get hiwConflictVersionA => '版本 A';

  @override
  String get hiwConflictPC => 'PC';

  @override
  String get hiwConflictVersionB => '版本 B';

  @override
  String get hiwDeleteTitle => '如果删除存档';

  @override
  String get hiwDeleteDesc => '从 Drive 中删除存档时，它不会立即消失：它会进入 Google Drive 回收站。';

  @override
  String get hiwCompatTitle => '平台兼容性';

  @override
  String get hiwCompatAndroidAccess => '在 Android 上访问';

  @override
  String get hiwShizukuTitle => '使用 Shizuku';

  @override
  String get hiwShizukuSubtitle => '设置一次。之后，ValleySave 自动同步，无需您再触摸它。';

  @override
  String get hiwShizukuBadge => '自动 · 推荐';

  @override
  String get hiwShizukuDone => '✓ 完成。从那时起，下载和上传存档是直接的，就像在计算机上一样。';

  @override
  String get hiwShizukuNote => '配对只有第一次。新的 Shizuku 版本在重启手机后会自动重新激活。';

  @override
  String get hiwBridgeTitle => '手动桥接';

  @override
  String get hiwBridgeSubtitle =>
      '仅在 Android 11 和 12 上有效。您无需安装任何额外的东西；相反，您需要每次同步时使用您的文件应用手动复制存档。';

  @override
  String get hiwBridgeBadge => '手动替代方案 · Android 11-12';

  @override
  String get hiwBridgeSaveFolder => 'Stardew 文件夹';

  @override
  String get hiwBridgeValleySaveFolder => 'ValleySave 文件夹';

  @override
  String get hiwBridgeNote => '它之所以有效是因为您的系统文件应用可以访问这些文件夹（ValleySave 不能）。';

  @override
  String get hiwTipAlwaysShow => '您总是会看到 Drive 上的内容然后再覆盖，这样您可以进行比较。';

  @override
  String get hiwTipWithoutUpload => '不上传，其他设备将看不到您的最新进度。';

  @override
  String get hiwTipComparison => '您将在确认之前看到本地和 Drive 之间的比较。';

  @override
  String get hiwTipDownloadOverwrite => '下载会覆盖您的本地存档。任何未同步的进度都会丢失。';

  @override
  String get hiwTipSync => '始终在切换设备之前上传，并在到达时下载。';

  @override
  String get hiwTipDeletion => '您有 30 天时间从 Drive 回收站恢复它，然后它将被永久删除。';

  @override
  String get hiwPrivacyLink => '隐私政策和使用';

  @override
  String get emptyNoSaves => '未找到存档';

  @override
  String get emptyNoSavesHint => '无法在此设备上读取本地存档';

  @override
  String get bridgeTitle => '带上您的存档';

  @override
  String get bridgeDesc =>
      '要查看和上传您的本地存档，请使用您的文件应用从 Stardew 文件夹复制它们到此 ValleySave 文件夹。然后向下滑动刷新。';

  @override
  String get bridgeRefresh => '刷新';

  @override
  String get bridgeChangeMode => '更改方法';

  @override
  String get loaderLoading => '加载中';

  @override
  String get loaderConnecting => '正在连接 Drive…';

  @override
  String get chooserTitle => '选择连接方式';

  @override
  String get chooserAutomatic => '自动 · 推荐';

  @override
  String get chooserManual => '手动替代方案 · Android 11-12';

  @override
  String get shizukuStepTitle => '设置 Shizuku';

  @override
  String get shizukuStep1Title => '安装 Shizuku';

  @override
  String get shizukuStep1Desc => '从 Play Store 或 GitHub 下载';

  @override
  String get shizukuStep2Title => '激活 Shizuku';

  @override
  String get shizukuStep2Desc => '运行应用并授予权限';

  @override
  String get shizukuStep3Title => '授予权限';

  @override
  String get shizukuStep3Desc => 'ValleySave 将要求访问权限';

  @override
  String get shizukuDone => '✓ 完成。从那时起，下载和上传存档直接工作，就像在计算机上一样。';

  @override
  String get dlgDeleteDriveTitle => '从 Drive 中删除';

  @override
  String get dlgDeleteLocalTitle => '从此设备中删除';

  @override
  String get dlgDownloadTitle => '下载存档';

  @override
  String get dlgUploadTitle => '上传存档';

  @override
  String get dlgUploadOverwrite => '这将覆盖您的本地存档';

  @override
  String get dlgGotIt => '明白了';

  @override
  String get dlgCopyDest => '复制目标';

  @override
  String get previewColDayYear => '天/年份';

  @override
  String get previewColTime => '游玩时间';

  @override
  String get previewColMoney => '金币';

  @override
  String get previewColTotal => '总计';

  @override
  String get previewColFarming => '农业';

  @override
  String get previewColForaging => '采集';

  @override
  String get previewColMining => '采矿';

  @override
  String get previewColFishing => '钓鱼';

  @override
  String get previewColCombat => '战斗';

  @override
  String get previewColFriends => '朋友';

  @override
  String get previewColMonsters => '怪物';

  @override
  String get previewColFaints => '昏迷';

  @override
  String get previewColMine => '矿山';

  @override
  String get previewColUnexplored => '未探索';

  @override
  String get previewLocalLabel => '在此设备上';

  @override
  String get previewDriveLabel => '在 DRIVE 上';

  @override
  String get previewFromDrive => '来自 DRIVE';

  @override
  String get previewFromDevice => '来自此设备';

  @override
  String versionMismatch(String local, String drive) {
    return '不同的版本：本地 $local · Drive $drive…';
  }

  @override
  String get snackPathCopied => '路径已复制';

  @override
  String get snackDestCopied => '目标路径已复制';

  @override
  String get snackDownloaded => '存档已下载到游戏';

  @override
  String get snackReplacePrepareFailed =>
      'Could not prepare the save. Nothing on disk was changed';

  @override
  String get snackReplaceValidationFailed =>
      'The downloaded save looks invalid or incomplete. Nothing on disk was changed';

  @override
  String get snackReplaceBackupFailed =>
      'Could not create a safety backup. Nothing on disk was changed';

  @override
  String get snackReplaceSwapFailed =>
      'The swap failed, but the original save was restored from backup';

  @override
  String get snackReplaceBusy =>
      'There\'s already an operation in progress for this save';

  @override
  String get snackUploadIncomplete =>
      'The local save is incomplete or corrupted. Nothing was uploaded';

  @override
  String get snackDownloadIncomplete =>
      'Can\'t download: this save is missing content on Drive';

  @override
  String get cardIncomplete => 'Incomplete on Drive';

  @override
  String get snackSessionExpired => 'Drive 会话已过期。重新连接';

  @override
  String snackUploadError(String error) {
    return '上传错误：$error';
  }

  @override
  String snackDownloadError(String error) {
    return '下载错误：$error';
  }

  @override
  String snackDeleteError(String error) {
    return '删除错误：$error';
  }

  @override
  String snackTrashed(String saveName) {
    return '\"$saveName\" 已移至 Drive 回收站。您有 30 天时间恢复它。';
  }

  @override
  String snackDeletedLocal(String saveName) {
    return '\"$saveName\" 已从此设备中删除';
  }

  @override
  String get snackShizukuRequired => '启用 Shizuku…';

  @override
  String get snackWriteError => '无法写入游戏。某些手机即使使用 Shizuku 也会阻止 /Android/data。';

  @override
  String get snackPlatformNotSupported => '此平台尚不支持写入本地存档。';

  @override
  String get snackWirelessDebugHint => '手动打开：设置 → 开发者选项 → 无线调试。';

  @override
  String get snackOpenShizukuApp => '从您的应用抽屉打开 Shizuku。';

  @override
  String get hiwTipDeletePermanent => 'ValleySave 无法恢复永久删除的存档。Drive 文件是您的责任。';

  @override
  String get hiwCompatAchievements =>
      'Steam 和 Google Play 成就不会转移。每个平台只跟踪实时发生的成就——存档文件不会以回溯方式触发它们。';

  @override
  String get hiwCompatOverwrite =>
      '如果您在没有设定顺序的情况下从两个设备同步，一个存档可能会覆盖另一个。始终在下载之前上传。';

  @override
  String get hiwCompatVersions =>
      '来自不同游戏版本的存档可能无法正确加载。如果在下载之前检测到版本不匹配，ValleySave 会提醒您。';

  @override
  String get hiwCompatMods =>
      'SMAPI 模组会向存档添加额外数据。如果您在未安装这些模组的设备上加载已修改的存档，游戏可能会崩溃或丢失模组数据。\n\n在 Android 上，也可以安装 SMAPI 来使用模组。';

  @override
  String get hiwCompatIncomplete =>
      'If you see \"Incomplete on Drive\" on a save, it\'s missing a required file in the cloud — it can\'t be downloaded until it\'s uploaded properly again from another device.';

  @override
  String get hiwShareTitle => 'Share with others';

  @override
  String get hiwShareDesc =>
      'Share a save with another player by email. They\'ll see it under Shared with me on their own device.';

  @override
  String get hiwShareStepYourSave => 'Your\nsave';

  @override
  String get hiwShareStepShare => 'Share by\nemail';

  @override
  String get hiwShareStepFriend => 'Shared\nwith me';

  @override
  String get hiwShareTipRoles =>
      'Two roles: Read-only lets them view and download. Allow sync lets them overwrite your copy on Drive. Either way they can never delete it — only you, the owner, can delete your save.';

  @override
  String get hiwShareTipDisconnect =>
      'Disconnecting just stops syncing on their end — the share stays active until you leave it for real from Manage shares.';

  @override
  String get hiwHostSwapTitle => 'Host swap';

  @override
  String get hiwHostSwapDesc =>
      'Change which farmhand hosts the save, replacing it in place — same save slot, same sharing permissions.';

  @override
  String get hiwHostSwapStepPick => 'Pick a\nfarmhand';

  @override
  String get hiwHostSwapStepConfirm => 'Confirm';

  @override
  String get hiwHostSwapStepDone => 'New save\ncreated';

  @override
  String get hiwHostSwapTipMove =>
      'Some farm objects may be relocated to make room for the house — nothing is deleted.';

  @override
  String get hiwHostSwapTipHouse =>
      'The new host\'s house will look like the game\'s default big house — cabin styling isn\'t supported without mods.';

  @override
  String get hiwBackupsTitle => 'Backups';

  @override
  String get hiwBackupsDesc =>
      'A backup is a snapshot of a save you can restore later. Create one manually anytime, or let ValleySave create one automatically before overwriting a save (downloading, importing, restoring, or a host swap).';

  @override
  String get hiwBackupsStepSave => 'Your\nsave';

  @override
  String get hiwBackupsStepSnapshot => 'Backup\nsnapshot';

  @override
  String get hiwBackupsStepStore => 'Local and/or\nDrive';

  @override
  String get hiwBackupsTipRestore =>
      'Restoring overwrites your current save with that earlier version — this can\'t be undone.';

  @override
  String get hiwBackupsTipDelete =>
      'Deleting a backup removes it everywhere it exists (this device and Drive, if uploaded) — this can\'t be undone.';

  @override
  String get hiwBackupsTipExport =>
      'You can also Export a save as a zip file to keep wherever you like, and Import it back later — a fully manual, portable alternative to the built-in backups.';

  @override
  String get hiwBackupsTipRetention =>
      'ValleySave keeps the 5 most recent automatic backups per save; the ones you create manually are never deleted on their own.';

  @override
  String get hiwBackupsTipRestoreBridge =>
      'In Bridge mode (Android without root/Shizuku), restoring a backup asks you to extract the .zip by hand into Stardew\'s folder — same as downloading.';

  @override
  String get hiwComparePrimary => '总游玩时间';

  @override
  String get hiwCompareNoShown1 => '作物和动物状态';

  @override
  String get hiwCompareNoShown2 => '库存和物品';

  @override
  String get hiwCompareNoShown3 => '个别关系';

  @override
  String get hiwShizuku1 => '安装 Shizuku（Play Store 或 GitHub APK）。';

  @override
  String get hiwShizuku2 => '通过无线调试激活它——ValleySave 将逐步指导您。';

  @override
  String get hiwShizuku3 => '在提示时授予 ValleySave 权限。';

  @override
  String get hiwBridge1 =>
      '从 Drive 下载：ValleySave 将存档保留在其文件夹中。您使用文件应用将其复制到 Stardew 的文件夹。';

  @override
  String get hiwBridge2 =>
      '上传到 Drive：从 Stardew 复制存档到 ValleySave 的文件夹。ValleySave 检测它并上传它。';

  @override
  String get snackShizukuBattery => '设置 → 应用 → Shizuku → 电池 → 不受限制。';

  @override
  String snackDriveError(String error) {
    return 'Drive：$error';
  }

  @override
  String get dlgDeleteLocalWarning => '⚠️ 如果您尚未上传到 Drive，它将永久丢失。无法恢复。';

  @override
  String get dlgDelete => '删除';

  @override
  String get dlgDownloadButton => '下载';

  @override
  String get dlgUploadButton => '上传';

  @override
  String get dlgBridgeCopyTitle => '复制存档到游戏';

  @override
  String dlgBridgeCopyDesc(String saveName) {
    return '存档已准备好。使用您的文件应用，复制 \"$saveName\" 文件夹并将其粘贴到 Stardew 文件夹中。';
  }

  @override
  String get labelFrom => '来自';

  @override
  String get labelTo => '到';

  @override
  String dlgDownloadNewDesc(String saveName, int day, String playtime) {
    return '\"$saveName\"（第 $day 天，$playtime）将被复制到此设备。';
  }

  @override
  String dlgDownloadOverwrite(String saveName) {
    return '这将覆盖您本地的 \"$saveName\" 存档。';
  }

  @override
  String dlgUploadNewDesc(String saveName, int day, String playtime) {
    return '\"$saveName\"（第 $day 天，$playtime）将被上传到您的 Drive。';
  }

  @override
  String dlgUploadOverwriteDrive(String saveName) {
    return '这将覆盖 \"$saveName\" 的 Drive 版本。';
  }

  @override
  String get pathLabelFromStardew => '来自 (Stardew)';

  @override
  String get pathLabelToValleySave => '到 (ValleySave)';

  @override
  String get chooserDesc => 'Android 保护游戏文件夹。选择如何给 ValleySave 访问权限——您可以随时更改。';

  @override
  String get chooserShizukuDesc =>
      '配置一次。之后 ValleySave 自动同步，无需您触摸任何东西。仅在 Android 13+ 上的可靠方法。';

  @override
  String get chooserManualBadge => '仅 Android 11-12';

  @override
  String get chooserBridgeDesc => '使用您的文件应用复制存档。无需额外安装。仅在 Android 11 和 12 上。';

  @override
  String get chooserRootBadge => 'ROOT';

  @override
  String get chooserRootTitle => 'Root 访问';

  @override
  String get chooserRootDesc =>
      '适用于已 Root 的设备（Magisk / SuperSU）。批准一次 Root 权限请求，之后自动生效。';

  @override
  String get snackRootDenied => 'Root 访问被拒绝。请尝试 Shizuku。';

  @override
  String get shizukuGateSubtitle => '已配置一次 · 仅首次';

  @override
  String get shizukuStatusLabel => 'Shizuku 活跃';

  @override
  String get shizukuStatusRunning => '已连接，等待中。';

  @override
  String get shizukuStatusNotDetected => '尚未检测到。';

  @override
  String get shizukuPermLabel => '权限已授予';

  @override
  String get shizukuPermGranted => 'ValleySave 已有访问权限。';

  @override
  String get shizukuPermNotGranted => '需要授权 ValleySave。';

  @override
  String get shizukuGrant => '授予';

  @override
  String get shizukuGuideHeader => '分步指南';

  @override
  String get shizukuStep1DescFull =>
      '免费。如果 Google Play 在您的手机上阻止它，请使用官方 GitHub APK。';

  @override
  String get btnPlayStore => 'Play Store';

  @override
  String get btnApkGithub => 'APK GitHub';

  @override
  String get shizukuStep2TitleFull => '启用开发者选项';

  @override
  String get shizukuStep2DescFull =>
      '设置 → 关于手机 → 软件信息 → 点击 \"Build number\" 7 次。';

  @override
  String get shizukuStep3TitleFull => '启用无线调试';

  @override
  String get shizukuStep3DescFull =>
      '该按钮将带您到那里并高亮显示它。启用它（开启）。然后点击 \"使用配对码配对设备\"——屏幕上会出现 6 位数代码。';

  @override
  String get btnOpenAndHighlight => '打开并高亮';

  @override
  String get shizukuStep4Title => '配对并启动 Shizuku';

  @override
  String get shizukuStep4Desc =>
      '打开 Shizuku → \"通过无线调试启动\" → \"使用配对码配对\"。Shizuku 将发送通知说它在等待。输入无线调试屏幕上的 6 位数代码。配对后，按启动——没有最后一次点击 Shizuku 将不会激活。';

  @override
  String get btnOpenShizuku => '打开 Shizuku';

  @override
  String get shizukuStep5Title => '将 Shizuku 电池设置为不受限制';

  @override
  String get shizukuStep5Desc =>
      '打开应用信息 → 电池 → 不受限制。如果您不这样做，系统将在后台关闭 Shizuku，您必须再次按启动。';

  @override
  String get btnShizukuAppInfo => 'Shizuku 应用信息';

  @override
  String get shizukuStep6DescActive => 'Shizuku 已激活。点击按钮授权。';

  @override
  String get shizukuStep6DescWaiting => '一旦 Shizuku 激活（第 4 步），就可用。';

  @override
  String get btnGrantPermission => '授予权限';

  @override
  String get btnCheckShizuku => '完成 · 检查';

  @override
  String get statusDone => '完成';

  @override
  String get statusPending => '待定';

  @override
  String get latestBadge => '· 最新存档 ·';

  @override
  String saveDateLabel(String season, int year) {
    return '$season · 第 $year 年';
  }

  @override
  String get petCat => '猫';

  @override
  String get petDog => '狗';

  @override
  String get houseBasic => '基础房屋';

  @override
  String get houseKitchen => '带厨房';

  @override
  String get houseBedroom => '带卧室';

  @override
  String get houseCellar => '带地下室';

  @override
  String houseLevelN(int level) {
    return '等级 $level';
  }

  @override
  String get tooltipLaunchGame => '开始游戏';

  @override
  String get hiwLaunchTitle => '启动游戏';

  @override
  String get hiwLaunchDesc => '在“我的存档”上方栏点击 ▶ 按鈕，可直接从应用启动 Stardew Valley。';

  @override
  String get hiwLaunchTipWindows =>
      '在 Windows 上，若未自动检测到游戏，请在设置 → 游戏中设置可执行文件路径。';

  @override
  String get hiwLaunchTipAndroid => '在 Android 上，若已安装游戏则直接启动。';

  @override
  String get hiwLaunchTipLinux =>
      'On Linux, if the game isn’t detected automatically, set the executable path in Settings → Game.';

  @override
  String get hiwSaveLocationsTitle => 'Where your saves live';

  @override
  String get hiwSaveLocationsDesc =>
      'ValleySave reads and writes directly to the game\'s save folder on each platform.';

  @override
  String get hiwSaveLocationWindows =>
      'Windows: %AppData%\\StardewValley\\Saves';

  @override
  String get hiwSaveLocationAndroid =>
      'Android: protected folder, accessed via Shizuku or the Bridge';

  @override
  String get hiwSaveLocationLinux =>
      'Linux: ~/.config/StardewValley/Saves (or ~/snap/steam/common/.config/StardewValley/Saves if Steam is installed via snap)';

  @override
  String get settingsGameSection => '游戏';

  @override
  String get settingsGameExePath => 'Stardew Valley 可执行文件';

  @override
  String get settingsGameExeNotFound => '未自动找到';

  @override
  String get settingsGameExeBrowse => '浏览…';

  @override
  String get settingsGameExeSaved => '路径已保存';

  @override
  String get snackLaunchError => '无法打开游戏';

  @override
  String get makeHostAction => '设为房主';

  @override
  String get makeHostExperimental => '实验性功能';

  @override
  String get makeHostDialogTitle => '更换房主';

  @override
  String makeHostDialogIntro(String playerName, String farmName) {
    return '$playerName将成为$farmName的房主。';
  }

  @override
  String get makeHostNewCopyNote => '将创建一个新存档。之后由你决定如何处理原始存档。';

  @override
  String makeHostMoveCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '农场中的$count个物体将被移动以为房屋腾出空间。不会删除任何东西。',
    );
    return '$_temp0';
  }

  @override
  String get makeHostHouseWarning => '新房主的房子看起来会像游戏中的主农舍。没有模组的情况下不支持小屋外观。';

  @override
  String get makeHostConfirmButton => '设为房主';

  @override
  String makeHostSuccess(String playerName) {
    return '已创建新存档：$playerName现在是房主。';
  }

  @override
  String get hostSwapErrInvalid => '此存档的结构异常，未做任何更改。';

  @override
  String get hostSwapErrNoSpace => '农场没有可用空间来重新放置物体，未做任何更改。';

  @override
  String get hostSwapErrWrite => '无法写入新存档（磁盘/权限问题），未做任何更改。';

  @override
  String get hostSwapErrValidation => '新存档的验证失败，已被丢弃。原始存档完好无损。';
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

  @override
  String get welcomeHeroPre => '永遠不要失去\n你的 ';

  @override
  String get welcomeHeroAccent => '農場，';

  @override
  String get welcomeHeroPost => '\n隨身攜帶。';

  @override
  String get welcomeSubtitle =>
      '在所有設備上同步您的 Stardew Valley 存檔。您的數據存儲在您自己的 Google Drive 中 — 無伺服器、無訂閱、完全由您控制。';

  @override
  String get welcomeDriveConnected => 'Drive 已連接';

  @override
  String get welcomeFooterTagline => '· 非商業 · 永久免費 ·';

  @override
  String updateVersionAvailable(String version) {
    return 'v$version 可用';
  }

  @override
  String get sectionMode => '模式';

  @override
  String get sectionSeason => '季節';

  @override
  String get sectionLanguage => '語言';

  @override
  String get modeAutoTitle => '自動';

  @override
  String get modeAutoDesc => '跟隨您的活躍存檔，如無存檔則跟隨您的實際位置。';

  @override
  String get modeSavesTitle => '按存檔';

  @override
  String get modeSavesDesc => '始終使用您最新存檔的季節。';

  @override
  String get modeGeoTitle => '按位置';

  @override
  String get modeGeoDesc => '始終使用您位置的真實季節。';

  @override
  String get modeFixedTitle => '固定季節';

  @override
  String get modeFixedDesc => '始終顯示相同的季節。';

  @override
  String get modeRandomTitle => '隨機';

  @override
  String get modeRandomDesc => '每次打開應用時選擇不同的季節。';

  @override
  String get seasonInitial => '初始';

  @override
  String get seasonSpring => '春';

  @override
  String get seasonSummer => '夏';

  @override
  String get seasonFall => '秋';

  @override
  String get seasonWinter => '冬';

  @override
  String get autoPriorityTitle => '優先順序';

  @override
  String get autoStep1Title => '首次啟動';

  @override
  String get autoStep1Desc => '顯示初始狀態。';

  @override
  String get autoStep2Title => '活躍存檔';

  @override
  String get autoStep2Desc => '使用您最後同步的存檔的季節。';

  @override
  String get autoStep3Title => '位置';

  @override
  String get autoStep3Desc => '檢測您的半球和您所在地區的真實季節。';

  @override
  String get autoStep4Title => '預設';

  @override
  String get autoStep4Desc => '如無數據可用，則使用初始（夜間模式）。';

  @override
  String get versionInstalled => '已安裝版本';

  @override
  String get updateNeverChecked => '從未檢查';

  @override
  String get updateCheckedNow => '剛檢查過';

  @override
  String get updateOutdatedDownload => '不是最新 · 下載';

  @override
  String get updateDownloading => '正在下載更新…';

  @override
  String get updateError => '錯誤 — 點擊重試';

  @override
  String get updateNeedsPermission => '為 ValleySave 啟用「安裝未知應用程式」，然後再次點擊「更新」';

  @override
  String get disconnectTitle => '斷開 Drive 連接？';

  @override
  String disconnectBody(String email) {
    return '您在 Drive 上的存檔不會被刪除。您可以隨時重新連接。';
  }

  @override
  String get disconnectButton => '斷開 Drive 連接';

  @override
  String get languageTileLabel => '語言';

  @override
  String get languageDialogTitle => '應用語言';

  @override
  String get searchHint => '搜索…';

  @override
  String get languageAuto => '系統語言';

  @override
  String get languageAutoDesc => '使用您的系統語言';

  @override
  String get privacyPolicyTitle => '隱私政策';

  @override
  String get privacyBeforeStartTitle => '開始前';

  @override
  String get privacyLastUpdated => '最後更新：2026年6月';

  @override
  String get privacyAccept => '已了解，繼續';

  @override
  String get cardSynced => '已同步';

  @override
  String get cardLocalAhead => '本地領先';

  @override
  String get cardDriveAhead => 'Drive 領先';

  @override
  String get cardLocalOnly => '本地專用';

  @override
  String get cardDriveOnly => 'Drive 專用';

  @override
  String get cardTimeNow => '現在';

  @override
  String cardTimeMinutesAgo(int minutes) {
    return '$minutes 分鐘前';
  }

  @override
  String cardTimeHoursAgo(int hours) {
    return '$hours 小時前';
  }

  @override
  String cardTimeDaysAgo(int days) {
    return '$days 天前';
  }

  @override
  String cardTimeMonthsAgo(int months) {
    return '$months 月前';
  }

  @override
  String get cardDetailLocalTitle => '在此設備上';

  @override
  String get cardDetailRemoteTitle => '在 Drive 上';

  @override
  String get cardDetailUpload => '上傳到 Drive';

  @override
  String get cardDetailDownload => '下載存檔';

  @override
  String get cardDetailDeleteLabel => '刪除';

  @override
  String get cardDetailDeleteLocal => '從此設備刪除';

  @override
  String get cardDetailDeleteRemote => '從 Drive 刪除';

  @override
  String get cardCloseBarrier => '關閉';

  @override
  String statDayYear(int day, int year) {
    return '第 $day 天 · 第 $year 年';
  }

  @override
  String statDayOnly(int day) {
    return '第 $day 天';
  }

  @override
  String get statPlaytime => '遊戲時間';

  @override
  String get statMoney => '金幣';

  @override
  String get statTotal => '總計';

  @override
  String get statMineUnexplored => '未探索';

  @override
  String get statMine => '礦山';

  @override
  String get statMineLvl => '礦山 · 等級';

  @override
  String get skillFarming => '農業';

  @override
  String get skillForaging => '採集';

  @override
  String get skillMining => '採礦';

  @override
  String get skillFishing => '釣魚';

  @override
  String get skillCombat => '戰鬥';

  @override
  String get cardLocalPresence => '在此設備上';

  @override
  String get cardRemotePresence => '在 Drive 上';

  @override
  String get cardNotPresent => '不在此處';

  @override
  String get cardActionSynced => '已同步';

  @override
  String get cardActionUpload => '上傳';

  @override
  String get cardActionDownload => '下載';

  @override
  String get pillMonsters => '怪物';

  @override
  String get pillFriends => '朋友';

  @override
  String get pillFaints => '昏迷';

  @override
  String get pillSleeps => '睡眠';

  @override
  String get hiwTitle => '運作原理';

  @override
  String get hiwSyncTitle => '同步如何運作';

  @override
  String get hiwSyncIntro =>
      'ValleySave 使用您自己的 Google Drive 在設備間移動存檔。沒有中間伺服器：文件是您的。';

  @override
  String get hiwSyncDevice => '您的\n設備';

  @override
  String get hiwSyncCloud => 'Google\nDrive';

  @override
  String get hiwSyncOtherDevice => '其他\n設備';

  @override
  String get hiwUploadTitle => '上傳存檔';

  @override
  String get hiwUploadDesc =>
      '上傳時，ValleySave 將兩個存檔文件（SaveGameInfo + 農場文件）複製到您在 Drive 上的 ValleySave/ 文件夾。';

  @override
  String get hiwDownloadTitle => '下載存檔';

  @override
  String get hiwDownloadDesc => '下載時，ValleySave 從 Drive 取出文件並直接放入遊戲文件夾。';

  @override
  String get hiwCompareTitle => '它比較什麼？';

  @override
  String get hiwCompareIntro => '為了知道哪個版本領先，ValleySave 使用總遊戲時間 — 唯一只能增加的數據。';

  @override
  String get hiwCompareNote => '確認前，您還將看到，以便您可以決定：';

  @override
  String get hiwCompareMoney => '當前金幣和總收入';

  @override
  String get hiwCompareMine => '礦山等級';

  @override
  String get hiwCompareSkills => '技能（農業、採礦、戰鬥…）';

  @override
  String get hiwCompareRelations => '朋友、殺死的怪物、昏迷次數';

  @override
  String get hiwCompareStamina => '體力和生命值';

  @override
  String get hiwCompareNotShown => '這些不顯示 — 它們可以在任何方向改變，不能表明哪個存檔領先。';

  @override
  String get hiwCompareNotShownExamples => '作物和動物狀態、物品欄和物品、個人關係';

  @override
  String get hiwCompareWarning => '它們不顯示 — 它們可以在任何方向改變，不能表明哪個存檔領先。';

  @override
  String get hiwConflictTitle => '如果您不同步就玩遊戲';

  @override
  String get hiwConflictDesc => '如果您在移動設備和電腦上不進行同步就繼續遊戲，最終會有兩個版本的相同存檔。';

  @override
  String get hiwConflictNoMerge => '它們無法合併。ValleySave 始終向您顯示兩個版本，以便您可以選擇保留哪一個。';

  @override
  String get hiwConflictMobile => '移動設備';

  @override
  String get hiwConflictVersionA => '版本 A';

  @override
  String get hiwConflictPC => '電腦';

  @override
  String get hiwConflictVersionB => '版本 B';

  @override
  String get hiwDeleteTitle => '如果刪除了存檔';

  @override
  String get hiwDeleteDesc => '從 Drive 刪除存檔時，它不會立即消失：它會進入 Google Drive 回收站。';

  @override
  String get hiwCompatTitle => '平台兼容性';

  @override
  String get hiwCompatAndroidAccess => 'ANDROID 上的訪問';

  @override
  String get hiwShizukuTitle => '使用 Shizuku';

  @override
  String get hiwShizukuSubtitle => '設置一次。之後，ValleySave 可自動同步，您無需再次觸碰。';

  @override
  String get hiwShizukuBadge => '自動 · 推薦';

  @override
  String get hiwShizukuDone => '✓ 完成。之後，下載和上傳存檔就像在電腦上一樣直接。';

  @override
  String get hiwShizukuNote => '配對僅在第一次。新的 Shizuku 版本在重新啟動手機後會自動重新激活。';

  @override
  String get hiwBridgeTitle => '手動橋接';

  @override
  String get hiwBridgeSubtitle =>
      '僅適用於 Android 11 和 12。您無需安裝任何額外內容；相反，您每次同步時都使用 Files 應用手動複製存檔。';

  @override
  String get hiwBridgeBadge => '手動替代方案 · ANDROID 11-12';

  @override
  String get hiwBridgeSaveFolder => 'Stardew 文件夾';

  @override
  String get hiwBridgeValleySaveFolder => 'ValleySave 文件夾';

  @override
  String get hiwBridgeNote => '之所以有效是因為您的系統 Files 應用可以訪問這些文件夾（ValleySave 不能）。';

  @override
  String get hiwTipAlwaysShow => '您將始終在覆蓋前看到 Drive 上的內容，以便您可以比較。';

  @override
  String get hiwTipWithoutUpload => '不上傳，其他設備將看不到您最近的進度。';

  @override
  String get hiwTipComparison => '確認前，您將看到本地和 Drive 之間的比較。';

  @override
  String get hiwTipDownloadOverwrite => '下載會覆蓋您的本地存檔。任何未同步的進度將丟失。';

  @override
  String get hiwTipSync => '始終在切換設備前上傳，到達時下載。';

  @override
  String get hiwTipDeletion => '您有 30 天時間從 Drive 回收站恢復它，之後將永久刪除。';

  @override
  String get hiwPrivacyLink => '隱私政策和使用';

  @override
  String get emptyNoSaves => '未找到存檔';

  @override
  String get emptyNoSavesHint => '無法讀取此設備上的本地存檔';

  @override
  String get bridgeTitle => '帶上您的存檔';

  @override
  String get bridgeDesc =>
      '要查看和上傳您的本地存檔，請使用 Files 應用從 Stardew 文件夾將它們複製到此 ValleySave 文件夾。然後刷新。';

  @override
  String get bridgeRefresh => '刷新';

  @override
  String get bridgeChangeMode => '更改方法';

  @override
  String get loaderLoading => '正在加載';

  @override
  String get loaderConnecting => '正在連接 Drive…';

  @override
  String get chooserTitle => '選擇連接方式';

  @override
  String get chooserAutomatic => '自動 · 推薦';

  @override
  String get chooserManual => '手動替代方案 · Android 11-12';

  @override
  String get shizukuStepTitle => '設置 Shizuku';

  @override
  String get shizukuStep1Title => '安裝 Shizuku';

  @override
  String get shizukuStep1Desc => '從 Play Store 或 GitHub 下載';

  @override
  String get shizukuStep2Title => '啟用 Shizuku';

  @override
  String get shizukuStep2Desc => '運行應用並授予權限';

  @override
  String get shizukuStep3Title => '授予權限';

  @override
  String get shizukuStep3Desc => 'ValleySave 將要求訪問權限';

  @override
  String get shizukuDone => '✓ 完成。之後，下載和上傳存檔就像在電腦上一樣直接工作。';

  @override
  String get dlgDeleteDriveTitle => '從 Drive 刪除';

  @override
  String get dlgDeleteLocalTitle => '從此設備刪除';

  @override
  String get dlgDownloadTitle => '下載存檔';

  @override
  String get dlgUploadTitle => '上傳存檔';

  @override
  String get dlgUploadOverwrite => '這將覆蓋您的本地存檔';

  @override
  String get dlgGotIt => '已了解';

  @override
  String get dlgCopyDest => '複製目的地';

  @override
  String get previewColDayYear => '天/年';

  @override
  String get previewColTime => '遊戲時間';

  @override
  String get previewColMoney => '金幣';

  @override
  String get previewColTotal => '總計';

  @override
  String get previewColFarming => '農業';

  @override
  String get previewColForaging => '採集';

  @override
  String get previewColMining => '採礦';

  @override
  String get previewColFishing => '釣魚';

  @override
  String get previewColCombat => '戰鬥';

  @override
  String get previewColFriends => '朋友';

  @override
  String get previewColMonsters => '怪物';

  @override
  String get previewColFaints => '昏迷';

  @override
  String get previewColMine => '礦山';

  @override
  String get previewColUnexplored => '未探索';

  @override
  String get previewLocalLabel => '在此設備上';

  @override
  String get previewDriveLabel => '在 DRIVE 上';

  @override
  String get previewFromDrive => '來自 DRIVE';

  @override
  String get previewFromDevice => '來自此設備';

  @override
  String versionMismatch(String local, String drive) {
    return '版本不同：本地 $local · Drive $drive…';
  }

  @override
  String get snackPathCopied => '路徑已複製';

  @override
  String get snackDestCopied => '目的地路徑已複製';

  @override
  String get snackDownloaded => '存檔已下載到遊戲';

  @override
  String get snackSessionExpired => 'Drive 會話已過期。重新連接';

  @override
  String snackUploadError(String error) {
    return '上傳錯誤：$error';
  }

  @override
  String snackDownloadError(String error) {
    return '下載錯誤：$error';
  }

  @override
  String snackDeleteError(String error) {
    return '刪除錯誤：$error';
  }

  @override
  String snackTrashed(String saveName) {
    return '\"$saveName\" 已移至 Drive 回收站。您有 30 天時間恢復它。';
  }

  @override
  String snackDeletedLocal(String saveName) {
    return '\"$saveName\" 已從此設備刪除';
  }

  @override
  String get snackShizukuRequired => '啟用 Shizuku…';

  @override
  String get snackWriteError => '無法寫入遊戲。某些手機即使使用 Shizuku 也會阻止 /Android/data。';

  @override
  String get snackPlatformNotSupported => '此平台尚不支持寫入本地存檔。';

  @override
  String get snackWirelessDebugHint => '手動打開：設定 → 開發者選項 → 無線調試。';

  @override
  String get snackOpenShizukuApp => '從應用抽屜打開 Shizuku。';

  @override
  String get hiwTipDeletePermanent => 'ValleySave 無法恢復永久刪除的存檔。Drive 文件是您的責任。';

  @override
  String get hiwCompatAchievements =>
      'Steam 和 Google Play 成就不會轉移。每個平台僅跟踪實時發生的成就 — 存檔文件不會觸發它們回顧。';

  @override
  String get hiwCompatOverwrite => '如果您從兩個設備同步而沒有設置順序，一個存檔可能會覆蓋另一個。始終在下載前上傳。';

  @override
  String get hiwCompatVersions =>
      '來自不同遊戲版本的存檔可能無法正確加載。ValleySave 將在檢測到版本不匹配時在下載前警告您。';

  @override
  String get hiwCompatMods =>
      'SMAPI mod 會向存檔添加額外數據。如果您在未安裝這些 mod 的設備上加載已修改的存檔，遊戲可能會崩潰或丟失 mod 數據。\n\n在 Android 上，也可以安裝 SMAPI 來使用 mod。';

  @override
  String get hiwComparePrimary => '總遊戲時間';

  @override
  String get hiwCompareNoShown1 => '作物和動物狀態';

  @override
  String get hiwCompareNoShown2 => '物品欄和物品';

  @override
  String get hiwCompareNoShown3 => '個人關係';

  @override
  String get hiwShizuku1 => '安裝 Shizuku（Play Store 或 GitHub APK）。';

  @override
  String get hiwShizuku2 => '使用無線調試激活它 — ValleySave 會一步步引導您。';

  @override
  String get hiwShizuku3 => '當提示時，授予 ValleySave 權限。';

  @override
  String get hiwBridge1 =>
      '從 Drive 下載：ValleySave 將存檔留在其文件夾中。您使用 Files 將其複製到 Stardew 的文件夾。';

  @override
  String get hiwBridge2 =>
      '上傳到 Drive：從 Stardew 複製存檔到 ValleySave 的文件夾。ValleySave 檢測到它並上傳它。';

  @override
  String get snackShizukuBattery => '設定 → 應用 → Shizuku → 電池 → 不受限制。';

  @override
  String snackDriveError(String error) {
    return 'Drive：$error';
  }

  @override
  String get dlgDeleteLocalWarning => '⚠️ 如果您未上傳到 Drive，它將永遠丟失。無法恢復。';

  @override
  String get dlgDelete => '刪除';

  @override
  String get dlgDownloadButton => '下載';

  @override
  String get dlgUploadButton => '上傳';

  @override
  String get dlgBridgeCopyTitle => '複製存檔到遊戲';

  @override
  String dlgBridgeCopyDesc(String saveName) {
    return '存檔已準備就緒。使用 Files 應用，複製 \"$saveName\" 文件夾並將其粘貼到 Stardew 文件夾。';
  }

  @override
  String get labelFrom => '來自';

  @override
  String get labelTo => '到';

  @override
  String dlgDownloadNewDesc(String saveName, int day, String playtime) {
    return '\"$saveName\"（第 $day 天，$playtime）將被複製到此設備。';
  }

  @override
  String dlgDownloadOverwrite(String saveName) {
    return '這將覆蓋您的 \"$saveName\" 本地存檔。';
  }

  @override
  String dlgUploadNewDesc(String saveName, int day, String playtime) {
    return '\"$saveName\"（第 $day 天，$playtime）將上傳到您的 Drive。';
  }

  @override
  String dlgUploadOverwriteDrive(String saveName) {
    return '這將覆蓋 \"$saveName\" 的 Drive 版本。';
  }

  @override
  String get pathLabelFromStardew => '來自（Stardew）';

  @override
  String get pathLabelToValleySave => '到（ValleySave）';

  @override
  String get chooserDesc => 'Android 保護遊戲文件夾。選擇如何給予 ValleySave 訪問權限 — 您可以隨時更改。';

  @override
  String get chooserShizukuDesc =>
      '配置一次。之後 ValleySave 可自動同步，無需您觸碰任何東西。Android 13+ 上的唯一可靠方法。';

  @override
  String get chooserManualBadge => '僅 ANDROID 11-12';

  @override
  String get chooserBridgeDesc =>
      '使用 Files 應用複製存檔。無需額外安裝。僅適用於 Android 11 和 12。';

  @override
  String get chooserRootBadge => 'ROOT';

  @override
  String get chooserRootTitle => 'Root 存取';

  @override
  String get chooserRootDesc =>
      '適用於已 Root 的裝置（Magisk / SuperSU）。批准一次 Root 權限請求，之後自動生效。';

  @override
  String get snackRootDenied => 'Root 存取遭拒。請嘗試 Shizuku。';

  @override
  String get shizukuGateSubtitle => '已配置一次 · 僅第一次';

  @override
  String get shizukuStatusLabel => 'Shizuku 活躍';

  @override
  String get shizukuStatusRunning => '已連接並等待中。';

  @override
  String get shizukuStatusNotDetected => '尚未檢測到。';

  @override
  String get shizukuPermLabel => '已授予權限';

  @override
  String get shizukuPermGranted => 'ValleySave 已有訪問權限。';

  @override
  String get shizukuPermNotGranted => '需要授權 ValleySave。';

  @override
  String get shizukuGrant => '授予';

  @override
  String get shizukuGuideHeader => '逐步指南';

  @override
  String get shizukuStep1DescFull =>
      '免費。如果 Google Play 在您的手機上阻止它，請使用官方 GitHub APK。';

  @override
  String get btnPlayStore => 'Play Store';

  @override
  String get btnApkGithub => 'APK GitHub';

  @override
  String get shizukuStep2TitleFull => '啟用開發者選項';

  @override
  String get shizukuStep2DescFull => '設定 → 關於手機 → 軟件信息 → 點擊「版本號」7 次。';

  @override
  String get shizukuStep3TitleFull => '啟用無線調試';

  @override
  String get shizukuStep3DescFull =>
      '該按鈕將帶您到那裡並高亮它。啟用它（開啟）。然後點擊「使用配對代碼配對設備」— 屏幕上將出現 6 位數代碼。';

  @override
  String get btnOpenAndHighlight => '打開並高亮';

  @override
  String get shizukuStep4Title => '配對並啟動 SHIZUKU';

  @override
  String get shizukuStep4Desc =>
      '打開 Shizuku → 「通過無線調試啟動」→ 「使用配對代碼配對」。Shizuku 將發送一條通知，表明它正在等待。從無線調試屏幕輸入 6 位數代碼。配對後，按啟動 — 沒有最後這一步，Shizuku 將不會活躍。';

  @override
  String get btnOpenShizuku => '打開 Shizuku';

  @override
  String get shizukuStep5Title => '將 Shizuku 電池設置為不受限制';

  @override
  String get shizukuStep5Desc =>
      '打開應用信息 → 電池 → 不受限制。如果您不這樣做，系統將在後台關閉 Shizuku，您將必須再次按啟動。';

  @override
  String get btnShizukuAppInfo => 'Shizuku 應用信息';

  @override
  String get shizukuStep6DescActive => 'Shizuku 已活躍。點擊按鈕進行授權。';

  @override
  String get shizukuStep6DescWaiting => 'Shizuku 活躍後可用（第 4 步）。';

  @override
  String get btnGrantPermission => '授予權限';

  @override
  String get btnCheckShizuku => '完成 · 檢查';

  @override
  String get statusDone => '完成';

  @override
  String get statusPending => '待定';

  @override
  String get latestBadge => '· 最新存檔 ·';

  @override
  String saveDateLabel(String season, int year) {
    return '$season · 第 $year 年';
  }

  @override
  String get petCat => '貓';

  @override
  String get petDog => '狗';

  @override
  String get houseBasic => '基本房子';

  @override
  String get houseKitchen => '帶廚房';

  @override
  String get houseBedroom => '帶臥室';

  @override
  String get houseCellar => '帶地下室';

  @override
  String houseLevelN(int level) {
    return '等級 $level';
  }

  @override
  String get makeHostAction => '設為房主';

  @override
  String get makeHostExperimental => '實驗性功能';

  @override
  String get makeHostDialogTitle => '更換房主';

  @override
  String makeHostDialogIntro(String playerName, String farmName) {
    return '$playerName將成為$farmName的房主。';
  }

  @override
  String get makeHostNewCopyNote => '將建立一個新存檔。之後由你決定如何處理原始存檔。';

  @override
  String makeHostMoveCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '農場中的$count個物體將被移動以為房屋騰出空間。不會刪除任何東西。',
    );
    return '$_temp0';
  }

  @override
  String get makeHostHouseWarning => '新房主的房子看起來會像遊戲中的主農舍。沒有模組的情況下不支援小屋外觀。';

  @override
  String get makeHostConfirmButton => '設為房主';

  @override
  String makeHostSuccess(String playerName) {
    return '已建立新存檔：$playerName現在是房主。';
  }

  @override
  String get hostSwapErrInvalid => '此存檔的結構異常，未做任何變更。';

  @override
  String get hostSwapErrNoSpace => '農場沒有可用空間來重新放置物體，未做任何變更。';

  @override
  String get hostSwapErrWrite => '無法寫入新存檔（磁碟/權限問題），未做任何變更。';

  @override
  String get hostSwapErrValidation => '新存檔的驗證失敗，已被捨棄。原始存檔完好無損。';
}
