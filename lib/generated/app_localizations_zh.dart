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
    return '断开与 $email 的连接';
  }

  @override
  String get connectedAsPrefix => '已连接为';

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
  String get exportAction => '导出';

  @override
  String get exportSuccess => '存档已导出。';

  @override
  String exportError(String error) {
    return '无法导出存档：$error';
  }

  @override
  String get importAction => '导入存档';

  @override
  String importSuccess(String playerName) {
    return '已导入 $playerName 的存档。';
  }

  @override
  String get importErrInvalidZip => '此文件不是有效的 zip 文件。';

  @override
  String get importErrUnsafePath => '此文件的结构不安全，已被拒绝。';

  @override
  String get importErrTooLarge => '此文件过大，无法导入。';

  @override
  String get importErrNotASave => '此文件不包含可识别的存档。';

  @override
  String get importErrWrite => '无法写入导入的存档（磁盘/权限问题）。';

  @override
  String get importErrBackupFailed => '无法创建备份。未导入任何内容。';

  @override
  String get importConflictTitle => '已存在同名存档';

  @override
  String get importConflictBody => '导入将替换现有的本地副本。此操作无法撤销。';

  @override
  String get importConflictConfirm => '覆盖';

  @override
  String get shareAction => '共享';

  @override
  String get shareUploadFirstCta => '先上传';

  @override
  String get shareDialogTitle => '共享存档';

  @override
  String get shareEmailPlaceholder => 'name@example.com';

  @override
  String get shareInfoNote => '共享只提供查看和下载权限。只有你能编辑或删除 Drive 中的副本。';

  @override
  String get shareRoleReader => '只读';

  @override
  String get shareRoleWriter => '允许同步';

  @override
  String get shareInfoNoteCoop =>
      '只读权限允许查看和下载。允许同步权限允许覆盖你 Drive 上的副本——但永远无法删除它。';

  @override
  String get shareConfirmButton => '共享';

  @override
  String shareSuccess(String email) {
    return '已与 $email 共享。';
  }

  @override
  String get manageAccessTitle => '有权访问的人';

  @override
  String get manageAccessEmpty => '目前还没有其他人可以访问。';

  @override
  String get manageAccessRoleLabel => '访问权限';

  @override
  String get manageAccessRevoke => '撤销';

  @override
  String manageAccessRevokeConfirm(String email) {
    return '要取消 $email 的访问权限吗？已经下载的任何本地副本仍然归他们所有。';
  }

  @override
  String get driveOnlyControlsYourCopy =>
      '共享只控制你在 Drive 上的副本。如果有人下载了它，那份副本就是他们的了。';

  @override
  String get driveOnlyControlsYourCopyCoop =>
      '同步只控制你在 Drive 上的副本——你授权的人可以覆盖它，但永远无法删除。';

  @override
  String get sharedWithMeTitle => '与我共享的';

  @override
  String get sharedWithMeEmpty => '目前还没有人与你共享任何内容。';

  @override
  String get sharedWithMeAdd => '添加共享存档';

  @override
  String sharedWithMeOwnedBy(String email) {
    return '由 $email 共享';
  }

  @override
  String get sharedWithMeRoleSync => '同步';

  @override
  String get sharedWithMeRoleRead => '只读';

  @override
  String get sharedWithMeSync => '同步';

  @override
  String get sharedWithMeDownload => '下载';

  @override
  String get sharedWithMeRemove => '断开连接';

  @override
  String sharedWithMeRemoveConfirm(String email) {
    return '你将不再与 $email 的 Drive 同步，但可以随时重新添加——它仍然是共享的。你的本地副本会变成一个普通的合作存档。';
  }

  @override
  String sharedLeaveConfirm(Object email) {
    return '你将真正失去对此存档的访问权限。除非 $email 再次与你共享，否则你无法重新添加它。你的本地副本会变成一个普通的合作存档。';
  }

  @override
  String get sharedManageButton => '管理';

  @override
  String get sharedManageDialogTitle => '管理共享';

  @override
  String get sharedManageDialogHint => '在这里你可以真正退出一个共享存档。';

  @override
  String get sharedLeaveButton => '退出共享';

  @override
  String sharedLeaveSuccess(Object email) {
    return '你已退出 $email 的共享。';
  }

  @override
  String sharedWithMeSyncConfirm(String email) {
    return '要用你的本地存档覆盖 $email 在 Drive 上的副本吗？';
  }

  @override
  String sharedAccessReadOnly(String email) {
    return '$email 已将你设为只读模式——你可以查看和下载，但无法同步到他们的 Drive。';
  }

  @override
  String get sharedWithMeRevoked => '你已不再拥有访问权限';

  @override
  String sharedRevokedDialogBody(String email, String farmName) {
    return '$email 已停止与你共享 $farmName。你的本地副本和 Drive 副本保持不变，现在会出现在\"我的存档\"中。';
  }

  @override
  String get sharedRevokedAccept => '确定';

  @override
  String get sharedSelfCleanupTitle => '记录已修正';

  @override
  String sharedSelfCleanupBody(String farmName) {
    return '$farmName 曾被错误地显示为与你共享——实际上它是你自己的。现在已修正，它在\"我的存档\"中。';
  }

  @override
  String get sharedWithMeUploadOwn => '上传到我的 Drive';

  @override
  String get sharedDownloadOwn => '从我的 Drive 下载';

  @override
  String get sharedStatusOwnDriveAhead => '你的 Drive 领先——下载它';

  @override
  String get sharedSyncBoth => '上传到两个 Drive';

  @override
  String get sharedSideMyDrive => '我的 DRIVE';

  @override
  String sharedSideOwnerDrive(String email) {
    return '$email 的 DRIVE';
  }

  @override
  String sharedSideDate(int day, int year) {
    return '第 $day 天 · 第 $year 年';
  }

  @override
  String get sharedStatusSyncedNoOwnDrive => '已与所有者同步 · 你的 Drive 中无副本';

  @override
  String get sharedStatusAheadNoOwnDrive => '你领先 · 你的 Drive 中无副本';

  @override
  String sharedStatusOwnerAheadNoOwnDrive(String email) {
    return '$email 领先 · 你的 Drive 中无副本';
  }

  @override
  String get sharedStatusAllSynced => '已同步（本地 + 两个 Drive）';

  @override
  String get sharedStatusAheadBoth => '你在两个 Drive 上都领先';

  @override
  String get sharedStatusMixed => '未同步——请检查各个 Drive';

  @override
  String get sharedStatusFullySynced => '完全同步';

  @override
  String get sharedStatusSyncedOwn => '我的 Drive 已同步';

  @override
  String get sharedStatusSyncedOwner => '共享 Drive 已同步';

  @override
  String get sharedStatusNotCloud => '仅在本设备';

  @override
  String sharedStatusOwnerAhead(Object email) {
    return '$email 的 Drive 领先';
  }

  @override
  String get sharedStatusBothAhead => '两个 Drive 都领先';

  @override
  String get sharedStatusLocalMissing => '不在此设备上';

  @override
  String sharedStatusOwnerUnavailable(Object email) {
    return '无法检查 $email 的 Drive';
  }

  @override
  String get sharedStatusWorking => '正在同步…';

  @override
  String get sharedSideUnavailable => '无法检查';

  @override
  String get sharedSyncChooseTitle => '你想同步到哪里？';

  @override
  String get sharedSyncChooseBody => '选择你想用本设备的存档更新哪些云端副本。';

  @override
  String get sharedSyncTargetOwn => '我的 Drive';

  @override
  String sharedSyncTargetOwner(Object email) {
    return '$email 的 Drive';
  }

  @override
  String get sharedSyncTargetBoth => '两个 Drive';

  @override
  String get sharedDownloadChooseTitle => '你想下载哪个副本？';

  @override
  String get sharedDownloadChooseBody => '有多个副本领先。请选择你想要下载到本设备的那个。';

  @override
  String get sharedDownloadSourceOwn => '来自我的 Drive';

  @override
  String sharedDownloadSourceOwner(Object email) {
    return '来自 $email 的 Drive';
  }

  @override
  String get sharedWithMePickerTitle => '添加共享存档';

  @override
  String get sharedPickerEmptyHint => '其他玩家从 Drive 与你共享的内容会显示在这里。';

  @override
  String get sharedPickerAddButton => '添加';

  @override
  String get sharedOriginBadge => '共享';

  @override
  String sharedOriginFrom(String email) {
    return '来自 $email';
  }

  @override
  String get swapBackupDialogTitle => '备份已创建';

  @override
  String get swapBackupDialogBody => '之前的版本已保存为 zip 文件。你想如何处理它？';

  @override
  String get swapBackupUpload => '上传到 Drive';

  @override
  String get swapBackupLocalOnly => '保留在本设备';

  @override
  String get swapBackupDeleteNow => '立即删除';

  @override
  String get swapBackupUploadOk => '备份已上传到 Drive。';

  @override
  String swapBackupUploadErr(String error) {
    return '无法上传备份：$error';
  }

  @override
  String get swapBackupLocalOnlySnack => '备份已保存在本设备。';

  @override
  String get backupsAction => '备份';

  @override
  String backupsScreenTitle(String farmName) {
    return '$farmName 的备份';
  }

  @override
  String get backupsEmpty => '暂无备份。';

  @override
  String get backupsRestore => '恢复';

  @override
  String get backupsRestoreConfirmTitle => '要恢复此备份吗？';

  @override
  String get backupsRestoreConfirmBody => '这会用此前的版本覆盖你当前的存档。此操作无法撤销。';

  @override
  String get backupsDelete => '删除';

  @override
  String get backupsDeleteConfirmTitle => '要删除此备份吗？';

  @override
  String get backupsDeleteConfirmBody =>
      '将从存在的所有位置删除（本设备和 Drive，如果已上传）。此操作无法撤销。';

  @override
  String get backupsRestoreOk => '备份已恢复。';

  @override
  String get backupsRestoreManualTitle => '手动恢复';

  @override
  String get backupsRestoreManualBody =>
      '在桥接模式下，ValleySave 无法自动写入游戏文件夹。请自行将此备份的 .zip 解压到 Stardew Valley 的 Saves 文件夹，或在设置中切换到 Root/Shizuku 模式以自动恢复。';

  @override
  String backupsRestoreErr(String error) {
    return '无法恢复备份：$error';
  }

  @override
  String backupsDeleteErr(String error) {
    return '无法删除备份：$error';
  }

  @override
  String get backupsCreate => '创建本地备份';

  @override
  String get backupsCreateLocalHint => '备份会先在本设备上创建。之后你可以将它们上传到 Drive。';

  @override
  String get backupsCreateOk => '备份已创建。';

  @override
  String backupsCreateErr(String error) {
    return '无法创建备份：$error';
  }

  @override
  String get backupsDownload => '下载';

  @override
  String get backupsDownloadOk => '备份已下载到本设备。';

  @override
  String backupsDownloadErr(String error) {
    return '无法下载备份：$error';
  }

  @override
  String get backupsCopyOwn => '复制到我的 Drive';

  @override
  String get backupsUploadOwn => '到我的 Drive';

  @override
  String get backupsUploadShared => '到共享 Drive';

  @override
  String get backupsUploadOk => '备份已上传。';

  @override
  String backupsUploadErr(String error) {
    return '无法上传备份：$error';
  }

  @override
  String get backupsLocationLocal => '本设备';

  @override
  String get backupsLocationOwnDrive => '我的 Drive';

  @override
  String get backupsLocationSharedDrive => '共享 Drive';

  @override
  String get backupsDeleteChooseBody => '请选择要从哪里删除它。只会显示存在此备份的位置。';

  @override
  String get backupsDeleteLocalOnly => '仅从本设备';

  @override
  String get backupsDeleteOwnOnly => '仅从我的 Drive';

  @override
  String get backupsDeleteSharedOnly => '仅从共享 Drive';

  @override
  String get backupsDeleteAll => '从所有副本';

  @override
  String deleteUnifiedTitle(String farmName) {
    return '要删除 $farmName 吗？';
  }

  @override
  String get deleteChooseLocationBody =>
      '选择从哪里删除。本设备的副本将被永久删除；Drive 上的副本会进入回收站（30 天）。';

  @override
  String deleteDriveContextTitle(String farmName) {
    return '要从 Drive 中删除 $farmName 吗？';
  }

  @override
  String get deleteDriveContextBody => 'Drive 上的副本将进入回收站，你可以在 30 天内恢复它。';

  @override
  String get deleteDriveLocalKept => '本设备的副本将保持不变。';

  @override
  String deleteLocalContextTitle(String farmName) {
    return '要从本设备中删除 $farmName 吗？';
  }

  @override
  String get deleteLocalContextBody => '本设备的副本将被永久删除。';

  @override
  String deleteLocalDriveCurrent(String date) {
    return '你的 Drive 副本是最新的（$date），仍将可用。';
  }

  @override
  String deleteLocalDriveAhead(String date) {
    return '你的 Drive 副本更新（$date），仍将可用。';
  }

  @override
  String deleteLocalDriveOlder(String driveDate, String localDate) {
    return '你的 Drive 副本较旧（$driveDate）；本设备的进度是 $localDate。';
  }

  @override
  String deleteLocalBackupAvailable(int count) {
    return '有 $count 个本地备份可用，以防你需要之前的版本。';
  }

  @override
  String get deleteLocalNoRecovery => '没有 Drive 副本，也没有本地备份可以恢复此存档。';

  @override
  String get deleteOptionLocalOnly => '仅从本设备';

  @override
  String get deleteOptionDriveOnly => '仅从我的 Drive';

  @override
  String get deleteOptionBoth => '从两份副本';

  @override
  String get viewPlayersHint => '查看玩家';

  @override
  String snackDeletedBoth(String saveName) {
    return '\"$saveName\" 已从本设备删除，并移至 Drive 回收站。';
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
  String get hiwConnectTitle => '连接你的账号';

  @override
  String get hiwConnectDesc =>
      'ValleySave 使用你的 Google 账号，把存档保存在你自己 Drive 中的 ValleySave 专属文件夹里。';

  @override
  String get hiwConnectStepGoogle => 'Google\n账号';

  @override
  String get hiwConnectStepDrive => 'ValleySave 文件夹\n已创建';

  @override
  String get hiwConnectStepReady => '准备好\n同步了';

  @override
  String get hiwConnectTipOwnership =>
      '只有你能编辑或删除 Drive 中的副本——ValleySave 只在自己的文件夹内读写。';

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
  String get overwriteWhatChanges => '有什么变化';

  @override
  String get overwriteTagOverwritten => '将被覆盖';

  @override
  String get overwriteNewCopyTag => '新';

  @override
  String overwriteDeltaPhrase(int days, String time) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: '$days 天又 $time',
      zero: '$time',
    );
    return '$_temp0';
  }

  @override
  String overwriteVerdictAhead(String delta) {
    return '你领先 $delta。可以放心。';
  }

  @override
  String get overwriteVerdictMoneySpent =>
      '💰 当前金钱变少了，但整体进度在前进——你可能是把钱花在了什么东西上。这不是真正的损失。';

  @override
  String overwriteVerdictNegligible(String delta) {
    return '差异极小（$delta）。两个副本用哪个都可以。';
  }

  @override
  String overwriteVerdictDanger(String delta, String target) {
    return '⚠️ 你将丢失 $target 中 $delta 的进度。继续前请先检查。';
  }

  @override
  String get overwriteConfirmTitleUpload => '确认上传吗？';

  @override
  String get overwriteConfirmTitleDownload => '确认下载吗？';

  @override
  String overwriteConfirmBody(String delta, String target) {
    return '你将丢失 $target 中的 $delta。此操作无法撤销。';
  }

  @override
  String get overwriteConfirmButtonUpload => '确认上传';

  @override
  String get overwriteConfirmButtonDownload => '确认下载';

  @override
  String get overwriteDangerButtonUpload => '⚠️ 仍然上传';

  @override
  String get overwriteDangerButtonDownload => '⚠️ 仍然下载';

  @override
  String overwriteIdenticalSummary(int count, String list) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '✓ 相同 $count 个',
    );
    return '$_temp0 — $list';
  }

  @override
  String overwriteUploadToOwner(String email) {
    return '上传到 $email 的 Drive';
  }

  @override
  String get overwriteUploadBoth => '上传到两个 Drive';

  @override
  String get overwriteConfirmTitleBoth => '确认这两次上传吗？';

  @override
  String overwriteConfirmBodyBoth(String delta, String targets) {
    return '你将丢失 $targets 中的 $delta。此操作无法撤销。';
  }

  @override
  String overwriteBothDestinationsLabel(String first, String second) {
    return '$first 和 $second';
  }

  @override
  String get sharedTargetOwnDrive => '你的 Drive';

  @override
  String sharedStatusLocalAhead(String targets) {
    return '你在 $targets 领先';
  }

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
  String get snackReplacePrepareFailed => '无法准备存档。磁盘上未做任何修改';

  @override
  String get snackReplaceValidationFailed => '下载的存档似乎无效或不完整。磁盘上未做任何修改';

  @override
  String get snackReplaceBackupFailed => '无法创建备份。磁盘上未做任何修改';

  @override
  String get snackReplaceSwapFailed => '交换失败，但原始存档已从备份中恢复';

  @override
  String get snackReplaceBusy => '此存档已有正在进行的操作';

  @override
  String get snackUploadIncomplete => '本地存档不完整或已损坏。未上传任何内容';

  @override
  String get snackDownloadIncomplete => '无法下载：Drive 上缺少内容';

  @override
  String get cardIncomplete => 'Drive 上不完整';

  @override
  String get autoRefreshTitle => '自动刷新';

  @override
  String get autoRefreshSubtitle => '每 30 秒检查一次 Drive 的变化';

  @override
  String autoSyncSnack(String farmName) {
    return '$farmName 已自动同步';
  }

  @override
  String get autoSyncTooltipOn => '自动同步已开启——安全时会自动同步';

  @override
  String get autoSyncTooltipOff => '自动同步已关闭——点击开启';

  @override
  String get autoSyncExplainTitle => '自动同步';

  @override
  String autoSyncExplainBody(String farmName) {
    return '从现在起，$farmName 会在安全的情况下自动上传或下载，不再向你确认。';
  }

  @override
  String get autoSyncExplainSafe => '只有在你明显领先且不会丢失任何内容时才会执行。';

  @override
  String get autoSyncExplainDanger => '如果有丢失进度的风险，它绝不会自动执行：你仍然可以通过常规对话框自己决定。';

  @override
  String get autoSyncExplainMissing => '如果缺少其中一个副本，它不会自动创建：第一次上传或下载由你决定。';

  @override
  String get autoSyncExplainDontShowAgain => '不再显示此提示';

  @override
  String get autoSyncExplainConfirm => '明白了，开启';

  @override
  String get hiwAutoSyncTitle => '自动同步';

  @override
  String get hiwAutoSyncDesc =>
      '每个存档卡片上都有一个 AUTO 标签。开启后，一旦应用检测到变化，该存档就会自动上传或下载——你不需要进入确认。';

  @override
  String get hiwAutoSyncTipSafe => '只有在你明显领先且不会丢失任何内容时，它才会自动同步。';

  @override
  String get hiwAutoSyncTipDanger => '如果有丢失进度的风险，它绝不会自动执行：仍会像往常一样通过比较界面向你确认。';

  @override
  String get hiwAutoSyncTipPerSave =>
      '逐个存档单独开启，不是一次性全部开启：你可以只在自己的存档上开启，共享存档上不开启。';

  @override
  String get hiwAutoSyncTipMissing => '它只保持已存在的两个副本同步。如果缺少一个，第一次上传或下载需要你自己完成。';

  @override
  String get hiwAutoSyncTipRefresh => '你可以在设置中完全关闭自动检查变化的功能。';

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
      '如果你在某个存档上看到\"Drive 上不完整\"，说明云端缺少必要的文件——在从其他设备重新正确上传之前无法下载。';

  @override
  String get hiwShareTitle => '与他人共享';

  @override
  String get hiwShareDesc => '通过邮箱与其他玩家共享存档。对方会在自己设备的\"与我共享\"中看到它。';

  @override
  String get hiwShareStepYourSave => '你的\n存档';

  @override
  String get hiwShareStepShare => '通过邮箱\n共享';

  @override
  String get hiwShareStepFriend => '与我\n共享的';

  @override
  String get hiwShareTipRoles =>
      '两种角色：只读权限可以查看和下载。允许同步权限可以覆盖你 Drive 上的副本。无论哪种角色都不能删除它——只有你这个所有者才能删除你的存档。';

  @override
  String get hiwShareTipDisconnect =>
      '断开连接只会停止对方那一侧的同步——共享关系仍然有效，直到你在\"管理共享\"中真正退出为止。';

  @override
  String get hiwHostSwapTitle => '更换房主';

  @override
  String get hiwHostSwapDesc => '更改哪个农场帮工是存档的房主，原地替换——相同的存档槽，相同的共享权限。';

  @override
  String get hiwHostSwapStepPick => '选择\n农场帮工';

  @override
  String get hiwHostSwapStepConfirm => '确认';

  @override
  String get hiwHostSwapStepDone => '新存档\n已创建';

  @override
  String get hiwHostSwapTipMove => '农场中的一些物体可能会被重新放置以给房子腾出空间——不会删除任何东西。';

  @override
  String get hiwHostSwapTipHouse => '新房主的房子外观会是游戏默认的大房子——如果没有模组，小屋外观不受支持。';

  @override
  String get hiwBackupsTitle => '备份';

  @override
  String get hiwBackupsDesc =>
      '备份是存档在某一时刻的快照，之后可以恢复。你可以随时手动创建，也可以让 ValleySave 在覆盖存档之前（下载、导入、恢复或更换房主时）自动创建。';

  @override
  String get hiwBackupsStepSave => '你的\n存档';

  @override
  String get hiwBackupsStepSnapshot => '备份\n已创建';

  @override
  String get hiwBackupsStepStore => '本地和/或\nDrive';

  @override
  String get hiwBackupsTipRestore => '恢复会用之前的版本覆盖你当前的存档——此操作无法撤销。';

  @override
  String get hiwBackupsTipDelete =>
      '删除备份会将其从存在的所有位置移除（本设备和 Drive，如果已上传）——此操作无法撤销。';

  @override
  String get hiwBackupsTipExport =>
      '你还可以将存档导出为 zip 文件，保存到任何地方，之后再导入回来——这是内置备份之外的一种手动、可移动的替代方案。';

  @override
  String get hiwBackupsTipRetention =>
      'ValleySave 为每个存档保留最近的 5 个自动备份；你手动创建的备份永远不会被自动删除。';

  @override
  String get hiwBackupsTipRestoreBridge =>
      '在桥接模式下（Android 无 root/Shizuku），恢复备份需要你手动将 .zip 解压到 Stardew 文件夹——和下载时一样。';

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
  String get hiwLaunchTipLinux => '在 Linux 上，如果未能自动检测到游戏，请在设置 → 游戏中设置可执行文件路径。';

  @override
  String get hiwSaveLocationsTitle => '存档保存在哪里';

  @override
  String get hiwSaveLocationsDesc => 'ValleySave 会直接在每个平台的游戏存档文件夹中读写。';

  @override
  String get hiwSaveLocationWindows =>
      'Windows: %AppData%\\StardewValley\\Saves';

  @override
  String get hiwSaveLocationAndroid => 'Android：受保护的文件夹，需通过 Shizuku 或桥接模式访问';

  @override
  String get hiwSaveLocationLinux =>
      'Linux：~/.config/StardewValley/Saves（如果通过 snap 安装了 Steam，则为 ~/snap/steam/common/.config/StardewValley/Saves）';

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

  @override
  String get makeHostDeleteOriginalTitle => '要从此设备删除原始存档吗？';

  @override
  String get makeHostDeleteOriginalBody =>
      '新存档已就绪。可以先把原始存档备份到你的 Drive（之后可重新下载），或者只删除本地副本。';

  @override
  String get makeHostDeleteOriginalNoBackupBody =>
      '未连接 Drive：不会保留任何备份。仅会删除本设备上的本地副本。';

  @override
  String get makeHostDeleteOriginalUploadBody =>
      '原始存档会先上传到你的 Drive 作为备份，然后再删除本设备上的本地副本。';

  @override
  String get makeHostDeleteWithoutUpload => '不上传直接删除';

  @override
  String get makeHostUploadAndDelete => '上传并删除';
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
  String disconnectButtonEmail(String email) {
    return '中斷與 $email 的連線';
  }

  @override
  String get connectedAsPrefix => '已連線為';

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
  String get exportAction => '匯出';

  @override
  String get exportSuccess => '存檔已匯出。';

  @override
  String exportError(String error) {
    return '無法匯出存檔：$error';
  }

  @override
  String get importAction => '匯入存檔';

  @override
  String importSuccess(String playerName) {
    return '已匯入 $playerName 的存檔。';
  }

  @override
  String get importErrInvalidZip => '此檔案不是有效的 zip 檔案。';

  @override
  String get importErrUnsafePath => '此檔案的結構不安全，已被拒絕。';

  @override
  String get importErrTooLarge => '此檔案過大，無法匯入。';

  @override
  String get importErrNotASave => '此檔案不包含可識別的存檔。';

  @override
  String get importErrWrite => '無法寫入匯入的存檔（磁碟/權限問題）。';

  @override
  String get importErrBackupFailed => '無法建立備份。未匯入任何內容。';

  @override
  String get importConflictTitle => '已存在同名存檔';

  @override
  String get importConflictBody => '匯入將取代現有的本機副本。此操作無法復原。';

  @override
  String get importConflictConfirm => '覆蓋';

  @override
  String get shareAction => '共用';

  @override
  String get shareUploadFirstCta => '先上傳';

  @override
  String get shareDialogTitle => '共用存檔';

  @override
  String get shareEmailPlaceholder => 'name@example.com';

  @override
  String get shareInfoNote => '共用只提供檢視和下載權限。只有你能編輯或刪除 Drive 中的副本。';

  @override
  String get shareRoleReader => '唯讀';

  @override
  String get shareRoleWriter => '允許同步';

  @override
  String get shareInfoNoteCoop =>
      '唯讀權限允許檢視和下載。允許同步權限允許覆蓋你 Drive 上的副本——但永遠無法刪除它。';

  @override
  String get shareConfirmButton => '共用';

  @override
  String shareSuccess(String email) {
    return '已與 $email 共用。';
  }

  @override
  String get manageAccessTitle => '有權存取的人';

  @override
  String get manageAccessEmpty => '目前還沒有其他人可以存取。';

  @override
  String get manageAccessRoleLabel => '存取權限';

  @override
  String get manageAccessRevoke => '撤銷';

  @override
  String manageAccessRevokeConfirm(String email) {
    return '要取消 $email 的存取權限嗎？已經下載的任何本機副本仍然歸他們所有。';
  }

  @override
  String get driveOnlyControlsYourCopy =>
      '共用只控制你在 Drive 上的副本。如果有人下載了它，那份副本就是他們的了。';

  @override
  String get driveOnlyControlsYourCopyCoop =>
      '同步只控制你在 Drive 上的副本——你授權的人可以覆蓋它，但永遠無法刪除。';

  @override
  String get sharedWithMeTitle => '與我共用的';

  @override
  String get sharedWithMeEmpty => '目前還沒有人與你共用任何內容。';

  @override
  String get sharedWithMeAdd => '新增共用存檔';

  @override
  String sharedWithMeOwnedBy(String email) {
    return '由 $email 共用';
  }

  @override
  String get sharedWithMeRoleSync => '同步';

  @override
  String get sharedWithMeRoleRead => '唯讀';

  @override
  String get sharedWithMeSync => '同步';

  @override
  String get sharedWithMeDownload => '下載';

  @override
  String get sharedWithMeRemove => '中斷連線';

  @override
  String sharedWithMeRemoveConfirm(String email) {
    return '你將不再與 $email 的 Drive 同步，但可以隨時重新新增——它仍然是共用的。你的本機副本會變成一個普通的合作存檔。';
  }

  @override
  String sharedLeaveConfirm(Object email) {
    return '你將真正失去對此存檔的存取權限。除非 $email 再次與你共用，否則你無法重新新增它。你的本機副本會變成一個普通的合作存檔。';
  }

  @override
  String get sharedManageButton => '管理';

  @override
  String get sharedManageDialogTitle => '管理共用';

  @override
  String get sharedManageDialogHint => '在這裡你可以真正退出一個共用存檔。';

  @override
  String get sharedLeaveButton => '退出共用';

  @override
  String sharedLeaveSuccess(Object email) {
    return '你已退出 $email 的共用。';
  }

  @override
  String sharedWithMeSyncConfirm(String email) {
    return '要用你的本機存檔覆蓋 $email 在 Drive 上的副本嗎？';
  }

  @override
  String sharedAccessReadOnly(String email) {
    return '$email 已將你設為唯讀模式——你可以檢視和下載，但無法同步到他們的 Drive。';
  }

  @override
  String get sharedWithMeRevoked => '你已不再擁有存取權限';

  @override
  String sharedRevokedDialogBody(String email, String farmName) {
    return '$email 已停止與你共用 $farmName。你的本機副本和 Drive 副本保持不變，現在會出現在「我的存檔」中。';
  }

  @override
  String get sharedRevokedAccept => '確定';

  @override
  String get sharedSelfCleanupTitle => '記錄已修正';

  @override
  String sharedSelfCleanupBody(String farmName) {
    return '$farmName 曾被錯誤地顯示為與你共用——實際上它是你自己的。現在已修正，它在「我的存檔」中。';
  }

  @override
  String get sharedWithMeUploadOwn => '上傳到我的 Drive';

  @override
  String get sharedDownloadOwn => '從我的 Drive 下載';

  @override
  String get sharedStatusOwnDriveAhead => '你的 Drive 領先——下載它';

  @override
  String get sharedSyncBoth => '上傳到兩個 Drive';

  @override
  String get sharedSideMyDrive => '我的 DRIVE';

  @override
  String sharedSideOwnerDrive(String email) {
    return '$email 的 DRIVE';
  }

  @override
  String sharedSideDate(int day, int year) {
    return '第 $day 天 · 第 $year 年';
  }

  @override
  String get sharedStatusSyncedNoOwnDrive => '已與擁有者同步 · 你的 Drive 中無副本';

  @override
  String get sharedStatusAheadNoOwnDrive => '你領先 · 你的 Drive 中無副本';

  @override
  String sharedStatusOwnerAheadNoOwnDrive(String email) {
    return '$email 領先 · 你的 Drive 中無副本';
  }

  @override
  String get sharedStatusAllSynced => '已同步（本機 + 兩個 Drive）';

  @override
  String get sharedStatusAheadBoth => '你在兩個 Drive 上都領先';

  @override
  String get sharedStatusMixed => '未同步——請檢查各個 Drive';

  @override
  String get sharedStatusFullySynced => '完全同步';

  @override
  String get sharedStatusSyncedOwn => '我的 Drive 已同步';

  @override
  String get sharedStatusSyncedOwner => '共用 Drive 已同步';

  @override
  String get sharedStatusNotCloud => '僅在本機裝置';

  @override
  String sharedStatusOwnerAhead(Object email) {
    return '$email 的 Drive 領先';
  }

  @override
  String get sharedStatusBothAhead => '兩個 Drive 都領先';

  @override
  String get sharedStatusLocalMissing => '不在此裝置上';

  @override
  String sharedStatusOwnerUnavailable(Object email) {
    return '無法檢查 $email 的 Drive';
  }

  @override
  String get sharedStatusWorking => '正在同步…';

  @override
  String get sharedSideUnavailable => '無法檢查';

  @override
  String get sharedSyncChooseTitle => '你想同步到哪裡？';

  @override
  String get sharedSyncChooseBody => '選擇你想用本機裝置的存檔更新哪些雲端副本。';

  @override
  String get sharedSyncTargetOwn => '我的 Drive';

  @override
  String sharedSyncTargetOwner(Object email) {
    return '$email 的 Drive';
  }

  @override
  String get sharedSyncTargetBoth => '兩個 Drive';

  @override
  String get sharedDownloadChooseTitle => '你想下載哪個副本？';

  @override
  String get sharedDownloadChooseBody => '有多個副本領先。請選擇你想要下載到本機裝置的那個。';

  @override
  String get sharedDownloadSourceOwn => '來自我的 Drive';

  @override
  String sharedDownloadSourceOwner(Object email) {
    return '來自 $email 的 Drive';
  }

  @override
  String get sharedWithMePickerTitle => '新增共用存檔';

  @override
  String get sharedPickerEmptyHint => '其他玩家從 Drive 與你共用的內容會顯示在這裡。';

  @override
  String get sharedPickerAddButton => '新增';

  @override
  String get sharedOriginBadge => '共用';

  @override
  String sharedOriginFrom(String email) {
    return '來自 $email';
  }

  @override
  String get swapBackupDialogTitle => '備份已建立';

  @override
  String get swapBackupDialogBody => '之前的版本已保存為 zip 檔案。你想如何處理它？';

  @override
  String get swapBackupUpload => '上傳到 Drive';

  @override
  String get swapBackupLocalOnly => '保留在本機裝置';

  @override
  String get swapBackupDeleteNow => '立即刪除';

  @override
  String get swapBackupUploadOk => '備份已上傳到 Drive。';

  @override
  String swapBackupUploadErr(String error) {
    return '無法上傳備份：$error';
  }

  @override
  String get swapBackupLocalOnlySnack => '備份已保存在本機裝置。';

  @override
  String get backupsAction => '備份';

  @override
  String backupsScreenTitle(String farmName) {
    return '$farmName 的備份';
  }

  @override
  String get backupsEmpty => '暫無備份。';

  @override
  String get backupsRestore => '恢復';

  @override
  String get backupsRestoreConfirmTitle => '要恢復此備份嗎？';

  @override
  String get backupsRestoreConfirmBody => '這會用此前的版本覆蓋你目前的存檔。此操作無法復原。';

  @override
  String get backupsDelete => '刪除';

  @override
  String get backupsDeleteConfirmTitle => '要刪除此備份嗎？';

  @override
  String get backupsDeleteConfirmBody =>
      '將從存在的所有位置刪除（本機裝置和 Drive，如果已上傳）。此操作無法復原。';

  @override
  String get backupsRestoreOk => '備份已恢復。';

  @override
  String get backupsRestoreManualTitle => '手動恢復';

  @override
  String get backupsRestoreManualBody =>
      '在橋接模式下，ValleySave 無法自動寫入遊戲資料夾。請自行將此備份的 .zip 解壓縮到 Stardew Valley 的 Saves 資料夾，或在設定中切換到 Root/Shizuku 模式以自動復原。';

  @override
  String backupsRestoreErr(String error) {
    return '無法恢復備份：$error';
  }

  @override
  String backupsDeleteErr(String error) {
    return '無法刪除備份：$error';
  }

  @override
  String get backupsCreate => '建立本機備份';

  @override
  String get backupsCreateLocalHint => '備份會先在本機裝置上建立。之後你可以將它們上傳到 Drive。';

  @override
  String get backupsCreateOk => '備份已建立。';

  @override
  String backupsCreateErr(String error) {
    return '無法建立備份：$error';
  }

  @override
  String get backupsDownload => '下載';

  @override
  String get backupsDownloadOk => '備份已下載到本機裝置。';

  @override
  String backupsDownloadErr(String error) {
    return '無法下載備份：$error';
  }

  @override
  String get backupsCopyOwn => '複製到我的 Drive';

  @override
  String get backupsUploadOwn => '到我的 Drive';

  @override
  String get backupsUploadShared => '到共用 Drive';

  @override
  String get backupsUploadOk => '備份已上傳。';

  @override
  String backupsUploadErr(String error) {
    return '無法上傳備份：$error';
  }

  @override
  String get backupsLocationLocal => '本機裝置';

  @override
  String get backupsLocationOwnDrive => '我的 Drive';

  @override
  String get backupsLocationSharedDrive => '共用 Drive';

  @override
  String get backupsDeleteChooseBody => '請選擇要從哪裡刪除它。只會顯示存在此備份的位置。';

  @override
  String get backupsDeleteLocalOnly => '僅從本機裝置';

  @override
  String get backupsDeleteOwnOnly => '僅從我的 Drive';

  @override
  String get backupsDeleteSharedOnly => '僅從共用 Drive';

  @override
  String get backupsDeleteAll => '從所有副本';

  @override
  String deleteUnifiedTitle(String farmName) {
    return '要刪除 $farmName 嗎？';
  }

  @override
  String get deleteChooseLocationBody =>
      '選擇從哪裡刪除。本機裝置的副本將被永久刪除；Drive 上的副本會進入垃圾桶（30 天）。';

  @override
  String deleteDriveContextTitle(String farmName) {
    return '要從 Drive 中刪除 $farmName 嗎？';
  }

  @override
  String get deleteDriveContextBody => 'Drive 上的副本將進入垃圾桶，你可以在 30 天內復原它。';

  @override
  String get deleteDriveLocalKept => '本機裝置的副本將保持不變。';

  @override
  String deleteLocalContextTitle(String farmName) {
    return '要從本機裝置中刪除 $farmName 嗎？';
  }

  @override
  String get deleteLocalContextBody => '本機裝置的副本將被永久刪除。';

  @override
  String deleteLocalDriveCurrent(String date) {
    return '你的 Drive 副本是最新的（$date），仍將可用。';
  }

  @override
  String deleteLocalDriveAhead(String date) {
    return '你的 Drive 副本更新（$date），仍將可用。';
  }

  @override
  String deleteLocalDriveOlder(String driveDate, String localDate) {
    return '你的 Drive 副本較舊（$driveDate）；本機裝置的進度是 $localDate。';
  }

  @override
  String deleteLocalBackupAvailable(int count) {
    return '有 $count 個本機備份可用，以防你需要之前的版本。';
  }

  @override
  String get deleteLocalNoRecovery => '沒有 Drive 副本，也沒有本機備份可以復原此存檔。';

  @override
  String get deleteOptionLocalOnly => '僅從本機裝置';

  @override
  String get deleteOptionDriveOnly => '僅從我的 Drive';

  @override
  String get deleteOptionBoth => '從兩份副本';

  @override
  String get viewPlayersHint => '檢視玩家';

  @override
  String snackDeletedBoth(String saveName) {
    return '\"$saveName\" 已從本機裝置刪除，並移至 Drive 垃圾桶。';
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
  String get hiwConnectTitle => '連接你的帳號';

  @override
  String get hiwConnectDesc =>
      'ValleySave 使用你的 Google 帳號，將存檔保存在你自己 Drive 中的 ValleySave 專屬資料夾裡。';

  @override
  String get hiwConnectStepGoogle => 'Google\n帳號';

  @override
  String get hiwConnectStepDrive => 'ValleySave 資料夾\n已建立';

  @override
  String get hiwConnectStepReady => '準備好\n同步了';

  @override
  String get hiwConnectTipOwnership =>
      '只有你能編輯或刪除 Drive 中的副本——ValleySave 只在自己的資料夾內讀寫。';

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
  String get overwriteWhatChanges => '有什麼變化';

  @override
  String get overwriteTagOverwritten => '將被覆蓋';

  @override
  String get overwriteNewCopyTag => '新';

  @override
  String overwriteDeltaPhrase(int days, String time) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: '$days 天又 $time',
      zero: '$time',
    );
    return '$_temp0';
  }

  @override
  String overwriteVerdictAhead(String delta) {
    return '你領先 $delta。可以放心。';
  }

  @override
  String get overwriteVerdictMoneySpent =>
      '💰 目前金錢變少了，但整體進度在前進——你可能是把錢花在了某樣東西上。這不是真正的損失。';

  @override
  String overwriteVerdictNegligible(String delta) {
    return '差異極小（$delta）。兩個副本用哪個都可以。';
  }

  @override
  String overwriteVerdictDanger(String delta, String target) {
    return '⚠️ 你將遺失 $target 中 $delta 的進度。繼續前請先檢查。';
  }

  @override
  String get overwriteConfirmTitleUpload => '確認上傳嗎？';

  @override
  String get overwriteConfirmTitleDownload => '確認下載嗎？';

  @override
  String overwriteConfirmBody(String delta, String target) {
    return '你將遺失 $target 中的 $delta。此操作無法復原。';
  }

  @override
  String get overwriteConfirmButtonUpload => '確認上傳';

  @override
  String get overwriteConfirmButtonDownload => '確認下載';

  @override
  String get overwriteDangerButtonUpload => '⚠️ 仍然上傳';

  @override
  String get overwriteDangerButtonDownload => '⚠️ 仍然下載';

  @override
  String overwriteIdenticalSummary(int count, String list) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '✓ 相同 $count 個',
    );
    return '$_temp0 — $list';
  }

  @override
  String overwriteUploadToOwner(String email) {
    return '上傳到 $email 的 Drive';
  }

  @override
  String get overwriteUploadBoth => '上傳到兩個 Drive';

  @override
  String get overwriteConfirmTitleBoth => '確認這兩次上傳嗎？';

  @override
  String overwriteConfirmBodyBoth(String delta, String targets) {
    return '你將遺失 $targets 中的 $delta。此操作無法復原。';
  }

  @override
  String overwriteBothDestinationsLabel(String first, String second) {
    return '$first 和 $second';
  }

  @override
  String get sharedTargetOwnDrive => '你的 Drive';

  @override
  String sharedStatusLocalAhead(String targets) {
    return '你在 $targets 領先';
  }

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
  String get snackReplacePrepareFailed => '無法準備存檔。磁碟上未做任何修改';

  @override
  String get snackReplaceValidationFailed => '下載的存檔似乎無效或不完整。磁碟上未做任何修改';

  @override
  String get snackReplaceBackupFailed => '無法建立備份。磁碟上未做任何修改';

  @override
  String get snackReplaceSwapFailed => '交換失敗，但原始存檔已從備份中復原';

  @override
  String get snackReplaceBusy => '此存檔已有正在進行的操作';

  @override
  String get snackUploadIncomplete => '本機存檔不完整或已損壞。未上傳任何內容';

  @override
  String get snackDownloadIncomplete => '無法下載：Drive 上缺少內容';

  @override
  String get cardIncomplete => 'Drive 上不完整';

  @override
  String get autoRefreshTitle => '自動重新整理';

  @override
  String get autoRefreshSubtitle => '每 30 秒檢查一次 Drive 的變化';

  @override
  String autoSyncSnack(String farmName) {
    return '$farmName 已自動同步';
  }

  @override
  String get autoSyncTooltipOn => '自動同步已開啟——安全時會自動同步';

  @override
  String get autoSyncTooltipOff => '自動同步已關閉——點擊開啟';

  @override
  String get autoSyncExplainTitle => '自動同步';

  @override
  String autoSyncExplainBody(String farmName) {
    return '從現在起，$farmName 會在安全的情況下自動上傳或下載，不再向你確認。';
  }

  @override
  String get autoSyncExplainSafe => '只有在你明顯領先且不會遺失任何內容時才會執行。';

  @override
  String get autoSyncExplainDanger => '如果有遺失進度的風險，它絕不會自動執行：你仍然可以透過常規對話方塊自己決定。';

  @override
  String get autoSyncExplainMissing => '如果缺少其中一個副本，它不會自動建立：第一次上傳或下載由你決定。';

  @override
  String get autoSyncExplainDontShowAgain => '不再顯示此提示';

  @override
  String get autoSyncExplainConfirm => '明白了，開啟';

  @override
  String get hiwAutoSyncTitle => '自動同步';

  @override
  String get hiwAutoSyncDesc =>
      '每個存檔卡片上都有一個 AUTO 標籤。開啟後，一旦應用程式偵測到變化，該存檔就會自動上傳或下載——你不需要進入確認。';

  @override
  String get hiwAutoSyncTipSafe => '只有在你明顯領先且不會遺失任何內容時，它才會自動同步。';

  @override
  String get hiwAutoSyncTipDanger => '如果有遺失進度的風險，它絕不會自動執行：仍會像往常一樣透過比較介面向你確認。';

  @override
  String get hiwAutoSyncTipPerSave =>
      '逐個存檔單獨開啟，不是一次性全部開啟：你可以只在自己的存檔上開啟，共用存檔上不開啟。';

  @override
  String get hiwAutoSyncTipMissing => '它只保持已存在的兩個副本同步。如果缺少一個，第一次上傳或下載需要你自己完成。';

  @override
  String get hiwAutoSyncTipRefresh => '你可以在設定中完全關閉自動檢查變化的功能。';

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
  String get hiwCompatIncomplete =>
      '如果你在某個存檔上看到「Drive 上不完整」，表示雲端缺少必要的檔案——在從其他裝置重新正確上傳之前無法下載。';

  @override
  String get hiwShareTitle => '與他人共用';

  @override
  String get hiwShareDesc => '透過電子郵件與其他玩家共用存檔。對方會在自己裝置的「與我共用」中看到它。';

  @override
  String get hiwShareStepYourSave => '你的\n存檔';

  @override
  String get hiwShareStepShare => '透過電子郵件\n共用';

  @override
  String get hiwShareStepFriend => '與我\n共用的';

  @override
  String get hiwShareTipRoles =>
      '兩種角色：唯讀權限可以檢視和下載。允許同步權限可以覆蓋你 Drive 上的副本。無論哪種角色都不能刪除它——只有你這個擁有者才能刪除你的存檔。';

  @override
  String get hiwShareTipDisconnect =>
      '中斷連線只會停止對方那一側的同步——共用關係仍然有效，直到你在「管理共用」中真正退出為止。';

  @override
  String get hiwHostSwapTitle => '更換房主';

  @override
  String get hiwHostSwapDesc => '更改哪個農場幫工是存檔的房主，原地替換——相同的存檔槽，相同的共用權限。';

  @override
  String get hiwHostSwapStepPick => '選擇\n農場幫工';

  @override
  String get hiwHostSwapStepConfirm => '確認';

  @override
  String get hiwHostSwapStepDone => '新存檔\n已建立';

  @override
  String get hiwHostSwapTipMove => '農場中的一些物件可能會被重新放置以給房子騰出空間——不會刪除任何東西。';

  @override
  String get hiwHostSwapTipHouse => '新房主的房子外觀會是遊戲預設的大房子——如果沒有模組，小屋外觀不受支援。';

  @override
  String get hiwBackupsTitle => '備份';

  @override
  String get hiwBackupsDesc =>
      '備份是存檔在某一時刻的快照，之後可以復原。你可以隨時手動建立，也可以讓 ValleySave 在覆蓋存檔之前（下載、匯入、復原或更換房主時）自動建立。';

  @override
  String get hiwBackupsStepSave => '你的\n存檔';

  @override
  String get hiwBackupsStepSnapshot => '備份\n已建立';

  @override
  String get hiwBackupsStepStore => '本機和/或\nDrive';

  @override
  String get hiwBackupsTipRestore => '恢復會用之前的版本覆蓋你目前的存檔——此操作無法復原。';

  @override
  String get hiwBackupsTipDelete =>
      '刪除備份會將其從存在的所有位置移除（本機裝置和 Drive，如果已上傳）——此操作無法復原。';

  @override
  String get hiwBackupsTipExport =>
      '你還可以將存檔匯出為 zip 檔案，保存到任何地方，之後再匯入回來——這是內建備份之外的一種手動、可攜式的替代方案。';

  @override
  String get hiwBackupsTipRetention =>
      'ValleySave 為每個存檔保留最近的 5 個自動備份；你手動建立的備份永遠不會被自動刪除。';

  @override
  String get hiwBackupsTipRestoreBridge =>
      '在橋接模式下（Android 無 root/Shizuku），復原備份需要你手動將 .zip 解壓縮到 Stardew 資料夾——和下載時一樣。';

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
  String get tooltipLaunchGame => '開始遊戲';

  @override
  String get hiwLaunchTitle => '啟動遊戲';

  @override
  String get hiwLaunchDesc => '在「我的存檔」上方列點擊 ▶ 按鈕，可直接從應用程式啟動 Stardew Valley。';

  @override
  String get hiwLaunchTipWindows => '在 Windows 上，若未自動偵測到遊戲，請在設定 → 遊戲中設定可執行檔路徑。';

  @override
  String get hiwLaunchTipAndroid => '在 Android 上，若已安裝遊戲則直接啟動。';

  @override
  String get hiwLaunchTipLinux => '在 Linux 上，如果未能自動偵測到遊戲，請在設定 → 遊戲中設定可執行檔路徑。';

  @override
  String get hiwSaveLocationsTitle => '存檔保存在哪裡';

  @override
  String get hiwSaveLocationsDesc => 'ValleySave 會直接在每個平台的遊戲存檔資料夾中讀寫。';

  @override
  String get hiwSaveLocationWindows =>
      'Windows: %AppData%\\StardewValley\\Saves';

  @override
  String get hiwSaveLocationAndroid => 'Android：受保護的資料夾，需透過 Shizuku 或橋接模式存取';

  @override
  String get hiwSaveLocationLinux =>
      'Linux：~/.config/StardewValley/Saves（如果透過 snap 安裝了 Steam，則為 ~/snap/steam/common/.config/StardewValley/Saves）';

  @override
  String get settingsGameSection => '遊戲';

  @override
  String get settingsGameExePath => 'Stardew Valley 可執行檔';

  @override
  String get settingsGameExeNotFound => '未自動找到';

  @override
  String get settingsGameExeBrowse => '瀏覽…';

  @override
  String get settingsGameExeSaved => '路徑已儲存';

  @override
  String get snackLaunchError => '無法開啟遊戲';

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

  @override
  String get makeHostDeleteOriginalTitle => '要從此裝置刪除原始存檔嗎？';

  @override
  String get makeHostDeleteOriginalBody =>
      '新存檔已就緒。可以先把原始存檔備份到你的 Drive（之後可重新下載），或者只刪除本機副本。';

  @override
  String get makeHostDeleteOriginalNoBackupBody =>
      '未連接 Drive：不會保留任何備份。僅會刪除本裝置上的本機副本。';

  @override
  String get makeHostDeleteOriginalUploadBody =>
      '原始存檔會先上傳到你的 Drive 作為備份，然後再刪除本裝置上的本機副本。';

  @override
  String get makeHostDeleteWithoutUpload => '不上傳直接刪除';

  @override
  String get makeHostUploadAndDelete => '上傳並刪除';
}
