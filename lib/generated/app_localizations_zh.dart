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
