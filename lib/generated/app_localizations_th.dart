// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Thai (`th`).
class AppLocalizationsTh extends AppLocalizations {
  AppLocalizationsTh([String locale = 'th']) : super(locale);

  @override
  String get appTitle => 'ValleySave';

  @override
  String get welcomeTitle => 'อย่าสูญเสียฟาร์มของคุณ พาไปด้วย';

  @override
  String get connectGoogleDrive => 'เชื่อมต่อ Google Drive';

  @override
  String get connecting => 'กำลังเชื่อมต่อ…';

  @override
  String get mySaves => 'บันทึกของฉัน';

  @override
  String get howItWorks => 'วิธีการทำงาน';

  @override
  String get settings => 'การตั้งค่า';

  @override
  String get aboutSection => 'เกี่ยวกับ';

  @override
  String get openSource => 'โค้ดที่มีจำหน่าย';

  @override
  String get nonCommercial => 'ไม่ใช่เชิงพาณิชย์';

  @override
  String get freeForever => 'ฟรีตลอดไป';

  @override
  String get privacyTitle => 'ความเป็นส่วนตัวและการใช้ข้อมูล';

  @override
  String get privacyDescription =>
      'ValleySave เป็นแอปพลิเคชันสำหรับซิงโครไนซ์บันทึก Stardew Valley ของคุณกับบัญชี Google Drive ของคุณเอง';

  @override
  String get whatDataTitle => 'ใช้ข้อมูลใด';

  @override
  String get whatDataDesc =>
      'ValleySave เข้าถึงเฉพาะไฟล์บันทึก Stardew Valley ที่จำเป็นในการสร้างสำเนา ซิงโครไนซ์ หรือคืนค่า';

  @override
  String get googleDriveTitle => 'Google Drive';

  @override
  String get googleDriveDesc =>
      'บันทึกของคุณจะถูกอัปโหลดไปยังบัญชี Google Drive ของคุณเอง ValleySave ไม่ใช้เซิร์ฟเวอร์ของตัวเองในการเก็บเกมของคุณ';

  @override
  String get androidPermissionsTitle => 'สิทธิ์ใน Android';

  @override
  String get androidPermissionsDesc =>
      'ValleySave อาจต้องมีสิทธิ์ด้านพื้นที่เก็บข้อมูลหรือเครื่องมือเช่น Shizuku เพื่อเข้าถึงไฟล์บันทึก';

  @override
  String get adsTitle => 'โฆษณา';

  @override
  String get adsDesc => 'ValleySave อาจแสดงโฆษณาผ่าน Google AdMob';

  @override
  String get responsibilityTitle => 'ความรับผิดชอบ';

  @override
  String get responsibilityDesc => 'ไฟล์บันทึกของคุณเป็นความรับผิดชอบของคุณ';

  @override
  String get deleteDataTitle => 'ลบข้อมูล';

  @override
  String get deleteDataDesc =>
      'คุณสามารถลบสำเนาที่ซิงโครไนซ์ได้โดยการลบโฟลเดอร์ ValleySave จาก Google Drive ด้วยตนเอง';

  @override
  String get sourceCodeTitle => 'โค้ดแหล่งที่มาและการติดต่อ';

  @override
  String get sourceCodeDesc =>
      'ValleySave เป็นโปรเจ็กต์ที่มีโค้ดที่มีจำหน่ายภายใต้ใบอนุญาต Polyform Noncommercial';

  @override
  String get upToDate => 'ปัจจุบัน';

  @override
  String get checkingUpdates => 'กำลังตรวจสอบ…';

  @override
  String get updateAvailable => 'มีการอัปเดตที่พร้อม';

  @override
  String get application => 'แอพลิเคชัน';

  @override
  String version(Object version) {
    return 'เวอร์ชัน $version';
  }

  @override
  String get checkForUpdates => 'ตรวจสอบการอัปเดต';

  @override
  String get shizukuRequired => 'ต้องมี Shizuku';

  @override
  String get shizukuGuide => 'คำแนะนำการตั้งค่า Shizuku';

  @override
  String get activateShizuku => 'เปิดใช้งาน Shizuku เพื่อเขียนการบันทึกในเกม';

  @override
  String deleteSaveTitle(Object saveName) {
    return 'ลบ $saveName';
  }

  @override
  String get deleteSaveMessage =>
      'นี่จะลบบันทึกจากอุปกรณ์นี้ คุณต้องการดำเนินการต่อไปหรือไม่?';

  @override
  String get deleteFromDrive => 'ลบจาก Drive';

  @override
  String confirmDelete(Object saveName) {
    return 'บันทึก $saveName จะถูกย้ายไปยังถังขยะของ Google Drive';
  }

  @override
  String deleteFromDeviceMessage(Object saveName) {
    return 'บันทึก $saveName จะถูกลบออกจากอุปกรณ์นี้อย่างถาวร';
  }

  @override
  String restoreSaveTitle(Object saveName) {
    return 'คืนค่า $saveName';
  }

  @override
  String restoreSaveMessage(Object saveName) {
    return 'ดาวน์โหลด $saveName ไปยังอุปกรณ์นี้?';
  }

  @override
  String get restore => 'คืนค่า';

  @override
  String get cancel => 'ยกเลิก';

  @override
  String get error => 'ข้อผิดพลาด';

  @override
  String get success => 'สำเร็จ';

  @override
  String get loading => 'กำลังโหลด…';

  @override
  String get disconnect => 'หลีกเลี่ยง';

  @override
  String get ok => 'ตกลง';

  @override
  String get yes => 'ใช่';

  @override
  String get no => 'ไม่';

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
