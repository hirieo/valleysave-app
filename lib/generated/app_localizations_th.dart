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
  String get welcomeHeroPre => 'อย่าสูญเสีย\n';

  @override
  String get welcomeHeroAccent => 'ฟาร์มของคุณ,';

  @override
  String get welcomeHeroPost => '\nพาไปด้วย';

  @override
  String get welcomeSubtitle =>
      'ซิงโครไนซ์บันทึก Stardew Valley ของคุณในอุปกรณ์ทั้งหมด ข้อมูลของคุณอยู่ใน Google Drive ของคุณเอง — ไม่มีเซิร์ฟเวอร์ ไม่มีสมัครสมาชิก อยู่ภายใต้การควบคุมของคุณ';

  @override
  String get welcomeDriveConnected => 'Drive เชื่อมต่อแล้ว';

  @override
  String get welcomeFooterTagline => '· ไม่ใช่เชิงพาณิชย์ · ฟรีตลอดไป ·';

  @override
  String updateVersionAvailable(String version) {
    return 'v$version พร้อมใช้งาน';
  }

  @override
  String get sectionMode => 'โหมด';

  @override
  String get sectionSeason => 'ฤดูกาล';

  @override
  String get sectionLanguage => 'ภาษา';

  @override
  String get modeAutoTitle => 'อัตโนมัติ';

  @override
  String get modeAutoDesc =>
      'ทำตามบันทึกที่ใช้งานอยู่ และหากไม่มีบันทึก ให้ทำตามตำแหน่งจริงของคุณ';

  @override
  String get modeSavesTitle => 'โดยบันทึก';

  @override
  String get modeSavesDesc => 'ใช้ฤดูกาลจากบันทึกล่าสุดของคุณเสมอ';

  @override
  String get modeGeoTitle => 'โดยตำแหน่ง';

  @override
  String get modeGeoDesc => 'ใช้ฤดูกาลจริงของตำแหน่งของคุณเสมอ';

  @override
  String get modeFixedTitle => 'ฤดูกาลคงที่';

  @override
  String get modeFixedDesc => 'แสดงฤดูกาลเดียวกันเสมอ';

  @override
  String get modeRandomTitle => 'สุ่ม';

  @override
  String get modeRandomDesc => 'เลือกฤดูกาลที่แตกต่างกันทุกครั้งที่คุณเปิดแอป';

  @override
  String get seasonInitial => 'เริ่มต้น';

  @override
  String get seasonSpring => 'ฤดูใบไม้ผลิ';

  @override
  String get seasonSummer => 'ฤดูร้อน';

  @override
  String get seasonFall => 'ฤดูใบไม้ร่วง';

  @override
  String get seasonWinter => 'ฤดูหนาว';

  @override
  String get autoPriorityTitle => 'ลำดับความสำคัญ';

  @override
  String get autoStep1Title => 'การเปิดครั้งแรก';

  @override
  String get autoStep1Desc => 'แสดงสถานะเริ่มต้น';

  @override
  String get autoStep2Title => 'บันทึกที่ใช้งานอยู่';

  @override
  String get autoStep2Desc => 'ใช้ฤดูกาลจากบันทึกล่าสุดที่ซิงโครไนซ์ของคุณ';

  @override
  String get autoStep3Title => 'ตำแหน่ง';

  @override
  String get autoStep3Desc => 'ตรวจหาซีกโลกและฤดูกาลจริงของภูมิภาคของคุณ';

  @override
  String get autoStep4Title => 'ค่าเริ่มต้น';

  @override
  String get autoStep4Desc => 'เริ่มต้น (โหมดกลางคืน) หากไม่มีข้อมูลพร้อมใช้';

  @override
  String get versionInstalled => 'เวอร์ชันที่ติดตั้ง';

  @override
  String get updateNeverChecked => 'ไม่เคยตรวจสอบ';

  @override
  String get updateCheckedNow => 'เพิ่งตรวจสอบแล้ว';

  @override
  String get updateOutdatedDownload => 'ไม่เป็นปัจจุบัน · ดาวน์โหลด';

  @override
  String get updateDownloading => 'กำลังดาวน์โหลดการอัปเดต…';

  @override
  String get updateError => 'ข้อผิดพลาด — แตะเพื่อลองใหม่';

  @override
  String get updateNeedsPermission =>
      'เปิดใช้งาน \"ติดตั้งแอปที่ไม่รู้จัก\" สำหรับ ValleySave แล้วแตะอัปเดตอีกครั้ง';

  @override
  String get disconnectTitle => 'ตัดการเชื่อมต่อ Drive?';

  @override
  String disconnectBody(String email) {
    return 'บันทึกของคุณใน Drive จะไม่ถูกลบ คุณสามารถเชื่อมต่อใหม่ได้ทุกเมื่อ';
  }

  @override
  String get disconnectButton => 'ตัดการเชื่อมต่อ Drive';

  @override
  String disconnectButtonEmail(String email) {
    return 'ตัดการเชื่อมต่อจาก $email';
  }

  @override
  String get connectedAsPrefix => 'บัญชีที่เชื่อมต่อ';

  @override
  String get languageTileLabel => 'ภาษา';

  @override
  String get languageDialogTitle => 'ภาษาแอป';

  @override
  String get searchHint => 'ค้นหา…';

  @override
  String get languageAuto => 'ภาษาของระบบ';

  @override
  String get languageAutoDesc => 'ใช้ภาษาของระบบของคุณ';

  @override
  String get privacyPolicyTitle => 'นโยบายความเป็นส่วนตัว';

  @override
  String get privacyBeforeStartTitle => 'ก่อนที่คุณเริ่ม';

  @override
  String get privacyLastUpdated => 'อัปเดตครั้งล่าสุด: มิถุนายน 2026';

  @override
  String get privacyAccept => 'รับทราบ ดำเนินการต่อ';

  @override
  String get cardSynced => 'ซิงโครไนซ์แล้ว';

  @override
  String get cardLocalAhead => 'ตัวเก็บไว้ข้างหน้า';

  @override
  String get cardDriveAhead => 'Drive ข้างหน้า';

  @override
  String get cardLocalOnly => 'ตัวเก็บไว้เท่านั้น';

  @override
  String get cardDriveOnly => 'Drive เท่านั้น';

  @override
  String get cardTimeNow => 'ตอนนี้';

  @override
  String cardTimeMinutesAgo(int minutes) {
    return '$minutes นาทีที่แล้ว';
  }

  @override
  String cardTimeHoursAgo(int hours) {
    return '$hoursช. ที่แล้ว';
  }

  @override
  String cardTimeDaysAgo(int days) {
    return '$daysว. ที่แล้ว';
  }

  @override
  String cardTimeMonthsAgo(int months) {
    return '$monthsเดือน ที่แล้ว';
  }

  @override
  String get cardDetailLocalTitle => 'บนอุปกรณ์นี้';

  @override
  String get cardDetailRemoteTitle => 'บน Drive';

  @override
  String get cardDetailUpload => 'อัปโหลดไปยัง Drive';

  @override
  String get cardDetailDownload => 'ดาวน์โหลดการบันทึก';

  @override
  String get cardDetailDeleteLabel => 'ลบ';

  @override
  String get cardDetailDeleteLocal => 'ลบจากอุปกรณ์นี้';

  @override
  String get cardDetailDeleteRemote => 'ลบจาก Drive';

  @override
  String get cardCloseBarrier => 'ปิด';

  @override
  String get exportAction => 'ส่งออก';

  @override
  String get exportSuccess => 'ส่งออกเซฟแล้ว';

  @override
  String exportError(String error) {
    return 'ไม่สามารถส่งออกเซฟได้: $error';
  }

  @override
  String get importAction => 'นำเข้าเซฟ';

  @override
  String importSuccess(String playerName) {
    return 'นำเข้าเซฟของ $playerName แล้ว';
  }

  @override
  String get importErrInvalidZip => 'ไฟล์นี้ไม่ใช่ zip ที่ถูกต้อง';

  @override
  String get importErrUnsafePath =>
      'ไฟล์นี้มีโครงสร้างที่ไม่ปลอดภัยและถูกปฏิเสธ';

  @override
  String get importErrTooLarge => 'ไฟล์นี้มีขนาดใหญ่เกินกว่าจะนำเข้าได้';

  @override
  String get importErrNotASave => 'ไฟล์นี้ไม่มีเซฟที่รู้จักอยู่ภายใน';

  @override
  String get importErrWrite =>
      'ไม่สามารถเขียนเซฟที่นำเข้าได้ (ดิสก์/สิทธิ์การเข้าถึง)';

  @override
  String get importErrBackupFailed =>
      'ไม่สามารถสร้างข้อมูลสำรองได้ ไม่มีการนำเข้าใดๆ';

  @override
  String get importConflictTitle => 'มีเซฟชื่อนี้อยู่แล้ว';

  @override
  String get importConflictBody =>
      'การนำเข้าจะแทนที่สำเนาในเครื่องที่มีอยู่ ย้อนกลับไม่ได้';

  @override
  String get importConflictConfirm => 'เขียนทับ';

  @override
  String get shareAction => 'แชร์';

  @override
  String get shareUploadFirstCta => 'อัปโหลดก่อน';

  @override
  String get shareDialogTitle => 'แชร์เซฟ';

  @override
  String get shareEmailPlaceholder => 'name@example.com';

  @override
  String get shareInfoNote =>
      'การแชร์จะให้สิทธิ์ดูและดาวน์โหลดเท่านั้น มีเพียงคุณเท่านั้นที่แก้ไขหรือลบสำเนาบน Drive ได้';

  @override
  String get shareRoleReader => 'อ่านอย่างเดียว';

  @override
  String get shareRoleWriter => 'อนุญาตให้ซิงโครไนซ์';

  @override
  String get shareInfoNoteCoop =>
      'อ่านอย่างเดียว อนุญาตให้ดูและดาวน์โหลด อนุญาตให้ซิงโครไนซ์ อนุญาตให้เขียนทับสำเนาของคุณบน Drive ได้ — แต่จะไม่สามารถลบมันได้เลย';

  @override
  String get shareConfirmButton => 'แชร์';

  @override
  String shareSuccess(String email) {
    return 'แชร์กับ $email แล้ว';
  }

  @override
  String get manageAccessTitle => 'ผู้ที่มีสิทธิ์เข้าถึง';

  @override
  String get manageAccessEmpty => 'ยังไม่มีใครมีสิทธิ์เข้าถึง';

  @override
  String get manageAccessRoleLabel => 'สิทธิ์การเข้าถึง';

  @override
  String get manageAccessRevoke => 'เพิกถอน';

  @override
  String manageAccessRevokeConfirm(String email) {
    return 'ต้องการเอาสิทธิ์การเข้าถึงของ $email ออกหรือไม่? สำเนาในเครื่องที่พวกเขาดาวน์โหลดไปแล้วยังคงเป็นของพวกเขาต่อไป';
  }

  @override
  String get driveOnlyControlsYourCopy =>
      'การแชร์ควบคุมเฉพาะสำเนาของคุณบน Drive หากใครดาวน์โหลดไป สำเนานั้นจะเป็นของพวกเขา';

  @override
  String get driveOnlyControlsYourCopyCoop =>
      'การซิงโครไนซ์ควบคุมสำเนาของคุณบน Drive — ผู้ที่คุณอนุญาตสามารถเขียนทับได้ แต่ไม่สามารถลบได้เลย';

  @override
  String get sharedWithMeTitle => 'แชร์กับฉัน';

  @override
  String get sharedWithMeEmpty => 'ยังไม่มีอะไรถูกแชร์กับคุณ';

  @override
  String get sharedWithMeAdd => 'เพิ่มเซฟที่แชร์';

  @override
  String sharedWithMeOwnedBy(String email) {
    return 'แชร์โดย $email';
  }

  @override
  String get sharedWithMeRoleSync => 'ซิงโครไนซ์';

  @override
  String get sharedWithMeRoleRead => 'อ่านอย่างเดียว';

  @override
  String get sharedWithMeSync => 'ซิงโครไนซ์';

  @override
  String get sharedWithMeDownload => 'ดาวน์โหลด';

  @override
  String get sharedWithMeRemove => 'นำออกจากรายการ';

  @override
  String sharedWithMeRemoveConfirm(String email) {
    return 'คุณจะไม่ซิงโครไนซ์กับ Drive ของ $email อีกต่อไป แต่สามารถเพิ่มกลับมาได้ทุกเมื่อ — การแชร์ยังคงอยู่ สำเนาในเครื่องของคุณจะยังคงเป็นเซฟโคออปทั่วไป';
  }

  @override
  String sharedLeaveConfirm(Object email) {
    return 'คุณจะสูญเสียสิทธิ์เข้าถึงเซฟนี้อย่างแท้จริง คุณจะเพิ่มกลับมาไม่ได้เว้นแต่ $email จะแชร์กับคุณอีกครั้ง สำเนาในเครื่องของคุณจะยังคงเป็นเซฟโคออปทั่วไป';
  }

  @override
  String get sharedManageButton => 'จัดการ';

  @override
  String get sharedManageDialogTitle => 'จัดการเซฟที่แชร์';

  @override
  String get sharedManageDialogHint =>
      'ที่นี่คุณสามารถออกจากเซฟที่แชร์ได้อย่างแท้จริง';

  @override
  String get sharedLeaveButton => 'ออกจากการแชร์';

  @override
  String sharedLeaveSuccess(Object email) {
    return 'คุณออกจากการแชร์ของ $email แล้ว';
  }

  @override
  String sharedWithMeSyncConfirm(String email) {
    return 'ต้องการเขียนทับสำเนาของ $email บน Drive ด้วยเซฟในเครื่องของคุณหรือไม่?';
  }

  @override
  String sharedAccessReadOnly(String email) {
    return '$email ได้ตั้งค่าการเข้าถึงของคุณเป็นแบบอ่านอย่างเดียว — คุณดูและดาวน์โหลดได้ แต่ซิงโครไนซ์ไปยัง Drive ของพวกเขาไม่ได้';
  }

  @override
  String get sharedWithMeRevoked => 'คุณไม่มีสิทธิ์เข้าถึงแล้ว';

  @override
  String sharedRevokedDialogBody(String email, String farmName) {
    return '$email หยุดแชร์ $farmName กับคุณแล้ว สำเนาในเครื่องและบน Drive ของคุณยังคงอยู่เหมือนเดิม ตอนนี้อยู่ใน \"เซฟของฉัน\"';
  }

  @override
  String get sharedRevokedAccept => 'ตกลง';

  @override
  String get sharedSelfCleanupTitle => 'แก้ไขข้อมูลแล้ว';

  @override
  String sharedSelfCleanupBody(String farmName) {
    return '$farmName ปรากฏว่าถูกแชร์กับคุณโดยผิดพลาด — แต่จริงๆ แล้วเป็นของคุณ ได้รับการแก้ไขแล้ว ตอนนี้อยู่ใน \"เซฟของฉัน\"';
  }

  @override
  String get sharedWithMeUploadOwn => 'อัปโหลดไปยัง Drive ของฉัน';

  @override
  String get sharedDownloadOwn => 'ดาวน์โหลดจาก Drive ของฉัน';

  @override
  String get sharedStatusOwnDriveAhead =>
      'Drive ของคุณล้ำหน้าอยู่ — ดาวน์โหลดเลย';

  @override
  String get sharedSyncBoth => 'อัปโหลดไปยัง Drive ทั้งสอง';

  @override
  String get sharedSideMyDrive => 'DRIVE ของฉัน';

  @override
  String sharedSideOwnerDrive(String email) {
    return 'DRIVE ของ $email';
  }

  @override
  String sharedSideDate(int day, int year) {
    return 'วัน $day · ปี $year';
  }

  @override
  String get sharedStatusSyncedNoOwnDrive =>
      'ซิงโครไนซ์กับเจ้าของแล้ว · ไม่มีสำเนาบน Drive ของคุณ';

  @override
  String get sharedStatusAheadNoOwnDrive =>
      'คุณล้ำหน้าอยู่ · ไม่มีสำเนาบน Drive ของคุณ';

  @override
  String sharedStatusOwnerAheadNoOwnDrive(String email) {
    return '$email ล้ำหน้าอยู่ · ไม่มีสำเนาบน Drive ของคุณ';
  }

  @override
  String get sharedStatusAllSynced =>
      'ซิงโครไนซ์แล้ว (เครื่องนี้ + Drive ทั้งสอง)';

  @override
  String get sharedStatusAheadBoth => 'คุณล้ำหน้าอยู่ใน Drive ทั้งสอง';

  @override
  String get sharedStatusMixed => 'ไม่ซิงค์กัน — ตรวจสอบ Drive แต่ละอัน';

  @override
  String get sharedStatusFullySynced => 'ซิงโครไนซ์สมบูรณ์แล้ว';

  @override
  String get sharedStatusSyncedOwn => 'ซิงโครไนซ์แล้วกับ Drive ของฉัน';

  @override
  String get sharedStatusSyncedOwner => 'ซิงโครไนซ์แล้วกับ Drive ที่แชร์';

  @override
  String get sharedStatusNotCloud => 'อยู่ในเครื่องนี้เท่านั้น';

  @override
  String sharedStatusOwnerAhead(Object email) {
    return 'Drive ของ $email ล้ำหน้าอยู่';
  }

  @override
  String get sharedStatusBothAhead => 'Drive ทั้งสองล้ำหน้าอยู่';

  @override
  String get sharedStatusLocalMissing => 'ไม่มีอยู่ในอุปกรณ์นี้';

  @override
  String sharedStatusOwnerUnavailable(Object email) {
    return 'ไม่สามารถตรวจสอบ Drive ของ $email ได้';
  }

  @override
  String get sharedStatusWorking => 'กำลังซิงโครไนซ์…';

  @override
  String get sharedSideUnavailable => 'ไม่สามารถตรวจสอบได้';

  @override
  String get sharedSyncChooseTitle => 'คุณต้องการซิงโครไนซ์ที่ไหน?';

  @override
  String get sharedSyncChooseBody =>
      'เลือกว่าจะอัปเดตสำเนาบนคลาวด์ใดด้วยเซฟจากอุปกรณ์นี้';

  @override
  String get sharedSyncTargetOwn => 'Drive ของฉัน';

  @override
  String sharedSyncTargetOwner(Object email) {
    return 'Drive ของ $email';
  }

  @override
  String get sharedSyncTargetBoth => 'Drive ทั้งสอง';

  @override
  String get sharedDownloadChooseTitle => 'คุณต้องการดาวน์โหลดสำเนาไหน?';

  @override
  String get sharedDownloadChooseBody =>
      'มีสำเนาที่ล้ำหน้ามากกว่าหนึ่งชุด เลือกว่าจะนำอันไหนมาไว้ในอุปกรณ์นี้';

  @override
  String get sharedDownloadSourceOwn => 'จาก Drive ของฉัน';

  @override
  String sharedDownloadSourceOwner(Object email) {
    return 'จาก Drive ของ $email';
  }

  @override
  String get sharedWithMePickerTitle => 'เพิ่มเซฟที่แชร์';

  @override
  String get sharedPickerEmptyHint =>
      'สิ่งที่ผู้เล่นคนอื่นแชร์กับคุณจาก Drive จะปรากฏที่นี่';

  @override
  String get sharedPickerAddButton => 'เพิ่ม';

  @override
  String get sharedOriginBadge => 'แชร์แล้ว';

  @override
  String sharedOriginFrom(String email) {
    return 'จาก $email';
  }

  @override
  String get swapBackupDialogTitle => 'สร้างข้อมูลสำรองแล้ว';

  @override
  String get swapBackupDialogBody =>
      'เวอร์ชันก่อนหน้าถูกบันทึกเป็นไฟล์ zip แล้ว คุณต้องการทำอย่างไรกับมัน?';

  @override
  String get swapBackupUpload => 'อัปโหลดไปยัง Drive';

  @override
  String get swapBackupLocalOnly => 'เก็บไว้ในเครื่องนี้';

  @override
  String get swapBackupDeleteNow => 'ลบเลย';

  @override
  String get swapBackupUploadOk => 'อัปโหลดข้อมูลสำรองไปยัง Drive แล้ว';

  @override
  String swapBackupUploadErr(String error) {
    return 'ไม่สามารถอัปโหลดข้อมูลสำรองได้: $error';
  }

  @override
  String get swapBackupLocalOnlySnack => 'บันทึกข้อมูลสำรองไว้ในเครื่องนี้แล้ว';

  @override
  String get backupsAction => 'ข้อมูลสำรอง';

  @override
  String backupsScreenTitle(String farmName) {
    return 'ข้อมูลสำรองของ $farmName';
  }

  @override
  String get backupsEmpty => 'ยังไม่มีข้อมูลสำรอง';

  @override
  String get backupsRestore => 'คืนค่า';

  @override
  String get backupsRestoreConfirmTitle => 'คืนค่าข้อมูลสำรองนี้หรือไม่?';

  @override
  String get backupsRestoreConfirmBody =>
      'การกระทำนี้จะเขียนทับเซฟปัจจุบันของคุณด้วยเวอร์ชันก่อนหน้านี้ ย้อนกลับไม่ได้';

  @override
  String get backupsDelete => 'ลบ';

  @override
  String get backupsDeleteConfirmTitle => 'ลบข้อมูลสำรองนี้หรือไม่?';

  @override
  String get backupsDeleteConfirmBody =>
      'จะถูกลบออกจากทุกที่ที่มันอยู่ (เครื่องนี้และ Drive หากอัปโหลดไว้) ย้อนกลับไม่ได้';

  @override
  String get backupsRestoreOk => 'คืนค่าข้อมูลสำรองแล้ว';

  @override
  String get backupsRestoreManualTitle => 'คืนค่าด้วยตนเอง';

  @override
  String get backupsRestoreManualBody =>
      'ในโหมด Bridge ValleySave ไม่สามารถเขียนลงในโฟลเดอร์เกมได้โดยอัตโนมัติ ให้แตกไฟล์ .zip ของข้อมูลสำรองนี้ด้วยตนเองลงในโฟลเดอร์ Saves ของ Stardew Valley หรือเปลี่ยนไปใช้โหมด Root/Shizuku ในการตั้งค่าเพื่อคืนค่าโดยอัตโนมัติ';

  @override
  String backupsRestoreErr(String error) {
    return 'ไม่สามารถคืนค่าข้อมูลสำรองได้: $error';
  }

  @override
  String backupsDeleteErr(String error) {
    return 'ไม่สามารถลบข้อมูลสำรองได้: $error';
  }

  @override
  String get backupsCreate => 'สร้างข้อมูลสำรองในเครื่อง';

  @override
  String get backupsCreateLocalHint =>
      'ข้อมูลสำรองจะถูกสร้างในเครื่องนี้ก่อน หลังจากนั้นคุณสามารถอัปโหลดไปยัง Drive ได้';

  @override
  String get backupsCreateOk => 'สร้างข้อมูลสำรองแล้ว';

  @override
  String backupsCreateErr(String error) {
    return 'ไม่สามารถสร้างข้อมูลสำรองได้: $error';
  }

  @override
  String get backupsDownload => 'ดาวน์โหลด';

  @override
  String get backupsDownloadOk => 'ดาวน์โหลดข้อมูลสำรองมาที่เครื่องนี้แล้ว';

  @override
  String backupsDownloadErr(String error) {
    return 'ไม่สามารถดาวน์โหลดข้อมูลสำรองได้: $error';
  }

  @override
  String get backupsCopyOwn => 'คัดลอกไปยัง Drive ของฉัน';

  @override
  String get backupsUploadOwn => 'ไปยัง Drive ของฉัน';

  @override
  String get backupsUploadShared => 'ไปยัง Drive ที่แชร์';

  @override
  String get backupsUploadOk => 'อัปโหลดข้อมูลสำรองแล้ว';

  @override
  String backupsUploadErr(String error) {
    return 'ไม่สามารถอัปโหลดข้อมูลสำรองได้: $error';
  }

  @override
  String get backupsLocationLocal => 'เครื่องนี้';

  @override
  String get backupsLocationOwnDrive => 'Drive ของฉัน';

  @override
  String get backupsLocationSharedDrive => 'Drive ที่แชร์';

  @override
  String get backupsDeleteChooseBody =>
      'เลือกตำแหน่งที่ต้องการลบให้ชัดเจน จะแสดงเฉพาะตำแหน่งที่มีข้อมูลสำรองนี้อยู่เท่านั้น';

  @override
  String get backupsDeleteLocalOnly => 'จากเครื่องนี้เท่านั้น';

  @override
  String get backupsDeleteOwnOnly => 'จาก Drive ของฉันเท่านั้น';

  @override
  String get backupsDeleteSharedOnly => 'จาก Drive ที่แชร์เท่านั้น';

  @override
  String get backupsDeleteAll => 'จากสำเนาทั้งหมด';

  @override
  String deleteUnifiedTitle(String farmName) {
    return 'ลบ $farmName หรือไม่?';
  }

  @override
  String get deleteChooseLocationBody =>
      'เลือกว่าจะลบจากที่ไหน สำเนาในเครื่องนี้จะถูกลบอย่างถาวร ส่วนสำเนาบน Drive จะย้ายไปที่ถังขยะ (30 วัน)';

  @override
  String deleteDriveContextTitle(String farmName) {
    return 'ลบ $farmName ออกจาก Drive หรือไม่?';
  }

  @override
  String get deleteDriveContextBody =>
      'สำเนาบน Drive จะถูกย้ายไปที่ถังขยะ ซึ่งคุณสามารถกู้คืนได้ภายใน 30 วัน';

  @override
  String get deleteDriveLocalKept =>
      'สำเนาในเครื่องนี้จะยังคงอยู่โดยไม่มีการเปลี่ยนแปลง';

  @override
  String deleteLocalContextTitle(String farmName) {
    return 'ลบ $farmName ออกจากเครื่องนี้หรือไม่?';
  }

  @override
  String get deleteLocalContextBody => 'สำเนาในเครื่องนี้จะถูกลบอย่างถาวร';

  @override
  String deleteLocalDriveCurrent(String date) {
    return 'สำเนาบน Drive ของคุณเป็นปัจจุบัน ($date) และจะยังคงพร้อมใช้งาน';
  }

  @override
  String deleteLocalDriveAhead(String date) {
    return 'สำเนาบน Drive ของคุณใหม่กว่า ($date) และจะยังคงพร้อมใช้งาน';
  }

  @override
  String deleteLocalDriveOlder(String driveDate, String localDate) {
    return 'สำเนาบน Drive ของคุณเก่ากว่า ($driveDate); เครื่องนี้อยู่ที่ $localDate';
  }

  @override
  String deleteLocalBackupAvailable(int count) {
    return 'มีข้อมูลสำรองในเครื่อง $count ชุดพร้อมใช้งาน เผื่อคุณต้องการสำเนาก่อนหน้า';
  }

  @override
  String get deleteLocalNoRecovery =>
      'ไม่มีสำเนาบน Drive หรือข้อมูลสำรองในเครื่องที่จะกู้คืนเซฟนี้ได้';

  @override
  String get deleteOptionLocalOnly => 'จากเครื่องนี้เท่านั้น';

  @override
  String get deleteOptionDriveOnly => 'จาก Drive เท่านั้น';

  @override
  String get deleteOptionBoth => 'จากทั้งสองสำเนา (เครื่อง + Drive)';

  @override
  String get viewPlayersHint => 'ดูผู้เล่น';

  @override
  String snackDeletedBoth(String saveName) {
    return '\"$saveName\" ถูกลบออกจากเครื่องนี้และย้ายไปที่ถังขยะของ Drive แล้ว';
  }

  @override
  String statDayYear(int day, int year) {
    return 'วัน $day · ปี $year';
  }

  @override
  String statDayOnly(int day) {
    return 'วัน $day';
  }

  @override
  String get statPlaytime => 'เวลาเล่น';

  @override
  String get statMoney => 'เหรียญ';

  @override
  String get statTotal => 'รวม';

  @override
  String get statMineUnexplored => 'ยังไม่สำรวจ';

  @override
  String get statMine => 'เหมืองแร่';

  @override
  String get statMineLvl => 'เหมืองแร่ · ระดับ';

  @override
  String get skillFarming => 'การเกษตร';

  @override
  String get skillForaging => 'การเก็บของป่า';

  @override
  String get skillMining => 'การสำรวจเหมือง';

  @override
  String get skillFishing => 'การตกปลา';

  @override
  String get skillCombat => 'การต่อสู้';

  @override
  String get cardLocalPresence => 'บนอุปกรณ์นี้';

  @override
  String get cardRemotePresence => 'บน Drive';

  @override
  String get cardNotPresent => 'ไม่อยู่ที่นี่';

  @override
  String get cardActionSynced => 'ซิงโครไนซ์แล้ว';

  @override
  String get cardActionUpload => 'อัปโหลด';

  @override
  String get cardActionDownload => 'ดาวน์โหลด';

  @override
  String get pillMonsters => 'สัตว์ประหลาด';

  @override
  String get pillFriends => 'เพื่อน';

  @override
  String get pillFaints => 'หมดแรง';

  @override
  String get pillSleeps => 'หลับ';

  @override
  String get hiwTitle => 'วิธีการทำงาน';

  @override
  String get hiwConnectTitle => 'เชื่อมต่อบัญชีของคุณ';

  @override
  String get hiwConnectDesc =>
      'ValleySave ใช้บัญชี Google ของคุณเพื่อเก็บเซฟไว้ในโฟลเดอร์ ValleySave ส่วนตัวบน Drive ของคุณเอง';

  @override
  String get hiwConnectStepGoogle => 'บัญชี\nGoogle';

  @override
  String get hiwConnectStepDrive => 'โฟลเดอร์ ValleySave\nถูกสร้างแล้ว';

  @override
  String get hiwConnectStepReady => 'พร้อม\nซิงโครไนซ์';

  @override
  String get hiwConnectTipOwnership =>
      'มีเพียงคุณเท่านั้นที่แก้ไขหรือลบสำเนาบน Drive ได้ — ValleySave จะอ่านและเขียนเฉพาะภายในโฟลเดอร์ของตัวเองเท่านั้น';

  @override
  String get hiwSyncTitle => 'วิธีการซิงโครไนซ์';

  @override
  String get hiwSyncIntro =>
      'ValleySave ใช้ Google Drive ของคุณเองในการย้ายบันทึกระหว่างอุปกรณ์ ไม่มีเซิร์ฟเวอร์ระดับกลาง: ไฟล์เป็นของคุณ';

  @override
  String get hiwSyncDevice => 'อุปกรณ์\nของคุณ';

  @override
  String get hiwSyncCloud => 'Google\nDrive';

  @override
  String get hiwSyncOtherDevice => 'อุปกรณ์\nอื่น';

  @override
  String get hiwUploadTitle => 'อัปโหลดการบันทึก';

  @override
  String get hiwUploadDesc =>
      'เมื่อคุณอัปโหลด ValleySave จะคัดลอกไฟล์บันทึกทั้งสอง (SaveGameInfo + ไฟล์ฟาร์ม) ไปยังโฟลเดอร์ ValleySave/ บน Drive';

  @override
  String get hiwDownloadTitle => 'ดาวน์โหลดการบันทึก';

  @override
  String get hiwDownloadDesc =>
      'เมื่อคุณดาวน์โหลด ValleySave จะนำไฟล์จาก Drive มาและวางไว้ในโฟลเดอร์เกมโดยตรง';

  @override
  String get hiwCompareTitle => 'มันเปรียบเทียบอะไร?';

  @override
  String get hiwCompareIntro =>
      'เพื่อให้ทราบว่าเวอร์ชันใดนำหน้า ValleySave ใช้เวลาเล่นทั้งหมด — ข้อมูลเพียงอย่างเดียวที่สามารถเพิ่มได้เท่านั้น';

  @override
  String get hiwCompareNote =>
      'ก่อนการยืนยัน คุณจะเห็นข้อมูลด้วย เพื่อให้คุณสามารถตัดสินใจได้:';

  @override
  String get hiwCompareMoney => 'เงินปัจจุบันและรวมที่ได้รับ';

  @override
  String get hiwCompareMine => 'ระดับเหมืองแร่';

  @override
  String get hiwCompareSkills => 'ทักษะ (เกษตร การสำรวจเหมือง ต่อสู้…)';

  @override
  String get hiwCompareRelations => 'เพื่อน สัตว์ประหลาดที่ถูกฆ่า หมดแรง';

  @override
  String get hiwCompareStamina => 'ความอดทน และสุขภาพ';

  @override
  String get hiwCompareNotShown =>
      'ไม่แสดง — ทั้งนี้เปลี่ยนแปลงไปได้และไม่บ่งชี้ว่าบันทึกใดนำหน้า';

  @override
  String get hiwCompareNotShownExamples =>
      'สถานะพืชและสัตว์เลี้ยง สินค้าคงคลังและไอเท็ม ความสัมพันธ์ส่วนบุคคล';

  @override
  String get hiwCompareWarning =>
      'ไม่แสดง — ทั้งนี้เปลี่ยนแปลงไปได้และไม่บ่งชี้ว่าบันทึกใดนำหน้า';

  @override
  String get hiwConflictTitle => 'ถ้าคุณเล่นโดยไม่ซิงโครไนซ์';

  @override
  String get hiwConflictDesc =>
      'หากคุณเล่นต่อบนมือถือและคอมพิวเตอร์โดยไม่ซิงโครไนซ์ระหว่างเซสชัน คุณจะได้บันทึกเดียวกันสองเวอร์ชัน';

  @override
  String get hiwConflictNoMerge =>
      'ไม่สามารถรวมกันได้ ValleySave จะแสดงเวอร์ชันทั้งสองให้คุณเห็นเพื่อให้คุณเลือกรักษาเวอร์ชันใด';

  @override
  String get hiwConflictMobile => 'มือถือ';

  @override
  String get hiwConflictVersionA => 'เวอร์ชัน A';

  @override
  String get hiwConflictPC => 'คอมพิวเตอร์';

  @override
  String get hiwConflictVersionB => 'เวอร์ชัน B';

  @override
  String get hiwDeleteTitle => 'หากลบการบันทึก';

  @override
  String get hiwDeleteDesc =>
      'เมื่อคุณลบบันทึกจาก Drive มันจะไม่หายไปทันที: มันจะไปยังถังขยะของ Google Drive';

  @override
  String get hiwCompatTitle => 'ความเข้ากันได้ของแพลตฟอร์ม';

  @override
  String get hiwCompatAndroidAccess => 'การเข้าถึงบน ANDROID';

  @override
  String get hiwShizukuTitle => 'กับ Shizuku';

  @override
  String get hiwShizukuSubtitle =>
      'ตั้งค่าครั้งเดียว หลังจากนั้น ValleySave จะซิงโครไนซ์เองโดยไม่ต้องให้คุณสัมผัสอีก';

  @override
  String get hiwShizukuBadge => 'อัตโนมัติ · แนะนำ';

  @override
  String get hiwShizukuDone =>
      '✓ เสร็จสิ้น หลังจากนั้นการดาวน์โหลดและอัปโหลดบันทึกจะเป็นการตรง เหมือนบนคอมพิวเตอร์';

  @override
  String get hiwShizukuNote =>
      'การจับคู่จะเป็นครั้งแรกเท่านั้น เวอร์ชัน Shizuku ใหม่จะเปิดใช้งานเองหลังจากรีสตาร์ตโทรศัพท์ของคุณ';

  @override
  String get hiwBridgeTitle => 'สะพานจับแบบแมนนวล';

  @override
  String get hiwBridgeSubtitle =>
      'ใช้งานได้เฉพาะกับ Android 11 และ 12 เท่านั้น คุณไม่ต้องติดตั้งอะไรเพิ่มเติม แต่ให้คัดลอกบันทึกด้วยตนเองด้วยแอป Files ทุกครั้งที่คุณซิงโครไนซ์';

  @override
  String get hiwBridgeBadge => 'ทางเลือกจับแบบแมนนวล · ANDROID 11-12';

  @override
  String get hiwBridgeSaveFolder => 'โฟลเดอร์ Stardew';

  @override
  String get hiwBridgeValleySaveFolder => 'โฟลเดอร์ ValleySave';

  @override
  String get hiwBridgeNote =>
      'มันใช้งานได้เพราะแอป Files ของระบบสามารถเข้าถึงโฟลเดอร์เหล่านั้นได้ (ValleySave ไม่สามารถ)';

  @override
  String get hiwTipAlwaysShow =>
      'คุณจะเห็นเสมอว่ามีอะไรบน Drive ก่อนที่จะเขียนทับ เพื่อให้คุณสามารถเปรียบเทียบ';

  @override
  String get hiwTipWithoutUpload =>
      'หากไม่อัปโหลด อุปกรณ์อื่นจะไม่เห็นความก้าวหน้าล่าสุดของคุณ';

  @override
  String get hiwTipComparison =>
      'คุณจะเห็นการเปรียบเทียบระหว่างตัวเก็บไว้ข้างหน้าและ Drive ก่อนการยืนยัน';

  @override
  String get hiwTipDownloadOverwrite =>
      'การดาวน์โหลดจะเขียนทับบันทึกตัวเก็บไว้ข้างหน้าของคุณ ความก้าวหน้าที่ไม่ซิงโครไนซ์จะหายไป';

  @override
  String get hiwTipSync =>
      'อัปโหลดเสมอก่อนเปลี่ยนอุปกรณ์ และดาวน์โหลดเมื่อคุณมาถึง';

  @override
  String get hiwTipDeletion =>
      'คุณมีเวลา 30 วันในการคืนค่าจากถังขยะของ Drive ก่อนที่จะถูกลบอย่างถาวร';

  @override
  String get hiwPrivacyLink => 'นโยบายความเป็นส่วนตัวและการใช้งาน';

  @override
  String get emptyNoSaves => 'ไม่พบบันทึก';

  @override
  String get emptyNoSavesHint =>
      'ไม่สามารถอ่านบันทึกตัวเก็บไว้ข้างหน้าได้บนอุปกรณ์นี้';

  @override
  String get bridgeTitle => 'นำบันทึกของคุณมา';

  @override
  String get bridgeDesc =>
      'เพื่อดูและอัปโหลดบันทึกตัวเก็บไว้ข้างหน้าของคุณ ให้คัดลอกจากโฟลเดอร์ Stardew ไปยังโฟลเดอร์ ValleySave นี้ด้วยแอป Files แล้วเลื่อนเพื่อรีเฟรช';

  @override
  String get bridgeRefresh => 'รีเฟรช';

  @override
  String get bridgeChangeMode => 'เปลี่ยนวิธีการ';

  @override
  String get loaderLoading => 'กำลังโหลด';

  @override
  String get loaderConnecting => 'กำลังเชื่อมต่อ Drive…';

  @override
  String get chooserTitle => 'เลือกวิธีการเชื่อมต่อ';

  @override
  String get chooserAutomatic => 'อัตโนมัติ · แนะนำ';

  @override
  String get chooserManual => 'ทางเลือกจับแบบแมนนวล · Android 11-12';

  @override
  String get shizukuStepTitle => 'ตั้งค่า Shizuku';

  @override
  String get shizukuStep1Title => 'ติดตั้ง Shizuku';

  @override
  String get shizukuStep1Desc => 'ดาวน์โหลดจาก Play Store หรือ GitHub';

  @override
  String get shizukuStep2Title => 'เปิดใช้งาน Shizuku';

  @override
  String get shizukuStep2Desc => 'เรียกใช้แอปและให้สิทธิ์';

  @override
  String get shizukuStep3Title => 'ให้สิทธิ์';

  @override
  String get shizukuStep3Desc => 'ValleySave จะขอการเข้าถึง';

  @override
  String get shizukuDone =>
      '✓ เสร็จสิ้น หลังจากนั้นการดาวน์โหลดและอัปโหลดบันทึกจะใช้งานได้โดยตรง เหมือนบนคอมพิวเตอร์';

  @override
  String get dlgDeleteDriveTitle => 'ลบจาก Drive';

  @override
  String get dlgDeleteLocalTitle => 'ลบจากอุปกรณ์นี้';

  @override
  String get dlgDownloadTitle => 'ดาวน์โหลดการบันทึก';

  @override
  String get dlgUploadTitle => 'อัปโหลดการบันทึก';

  @override
  String get dlgUploadOverwrite =>
      'นี่จะเขียนทับบันทึกตัวเก็บไว้ข้างหน้าของคุณ';

  @override
  String get dlgGotIt => 'รับทราบ';

  @override
  String get dlgCopyDest => 'คัดลอกปลายทาง';

  @override
  String get previewColDayYear => 'วัน/ปี';

  @override
  String get previewColTime => 'เวลาเล่น';

  @override
  String get previewColMoney => 'เหรียญ';

  @override
  String get previewColTotal => 'รวม';

  @override
  String get previewColFarming => 'การเกษตร';

  @override
  String get previewColForaging => 'การเก็บของป่า';

  @override
  String get previewColMining => 'การสำรวจเหมือง';

  @override
  String get previewColFishing => 'การตกปลา';

  @override
  String get previewColCombat => 'การต่อสู้';

  @override
  String get previewColFriends => 'เพื่อน';

  @override
  String get previewColMonsters => 'สัตว์ประหลาด';

  @override
  String get previewColFaints => 'หมดแรง';

  @override
  String get previewColMine => 'เหมืองแร่';

  @override
  String get previewColUnexplored => 'ยังไม่สำรวจ';

  @override
  String get previewLocalLabel => 'บนอุปกรณ์นี้';

  @override
  String get previewDriveLabel => 'บน DRIVE';

  @override
  String get previewFromDrive => 'จาก DRIVE';

  @override
  String get previewFromDevice => 'จากอุปกรณ์นี้';

  @override
  String get overwriteWhatChanges => 'สิ่งที่จะเปลี่ยนแปลง';

  @override
  String get overwriteTagOverwritten => 'จะถูกเขียนทับ';

  @override
  String get overwriteNewCopyTag => 'ใหม่';

  @override
  String overwriteDeltaPhrase(int days, String time) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: '$days วันและ $time',
      zero: '$time',
    );
    return '$_temp0';
  }

  @override
  String overwriteVerdictAhead(String delta) {
    return 'คุณล้ำหน้าอยู่ $delta ปลอดภัยดี';
  }

  @override
  String get overwriteVerdictMoneySpent =>
      '💰 เงินปัจจุบันลดลง แต่ความคืบหน้าโดยรวมยังก้าวไปข้างหน้า — คุณอาจใช้จ่ายไปกับอะไรบางอย่าง ไม่ใช่การสูญเสียที่แท้จริง';

  @override
  String overwriteVerdictNegligible(String delta) {
    return 'แตกต่างกันเพียงเล็กน้อย ($delta) ใช้สำเนาไหนก็ได้';
  }

  @override
  String overwriteVerdictDanger(String delta, String target) {
    return '⚠️ คุณกำลังจะสูญเสียความคืบหน้า $delta ใน $target ตรวจสอบให้ดีก่อนดำเนินการต่อ';
  }

  @override
  String get overwriteConfirmTitleUpload => 'ยืนยันการอัปโหลดหรือไม่?';

  @override
  String get overwriteConfirmTitleDownload => 'ยืนยันการดาวน์โหลดหรือไม่?';

  @override
  String overwriteConfirmBody(String delta, String target) {
    return 'คุณกำลังจะสูญเสีย $delta ใน $target การกระทำนี้ไม่สามารถย้อนกลับได้';
  }

  @override
  String get overwriteConfirmButtonUpload => 'ยืนยันการอัปโหลด';

  @override
  String get overwriteConfirmButtonDownload => 'ยืนยันการดาวน์โหลด';

  @override
  String get overwriteDangerButtonUpload => '⚠️ อัปโหลดต่อไป';

  @override
  String get overwriteDangerButtonDownload => '⚠️ ดาวน์โหลดต่อไป';

  @override
  String overwriteIdenticalSummary(int count, String list) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '✓ เหมือนกัน $count รายการ',
    );
    return '$_temp0 — $list';
  }

  @override
  String overwriteUploadToOwner(String email) {
    return 'อัปโหลดไปยัง Drive ของ $email';
  }

  @override
  String get overwriteUploadBoth => 'อัปโหลดไปยัง Drive ทั้งสอง';

  @override
  String get overwriteConfirmTitleBoth =>
      'ยืนยันการอัปโหลดทั้งสองรายการหรือไม่?';

  @override
  String overwriteConfirmBodyBoth(String delta, String targets) {
    return 'คุณจะสูญเสีย $delta ใน $targets การกระทำนี้ไม่สามารถย้อนกลับได้';
  }

  @override
  String overwriteBothDestinationsLabel(String first, String second) {
    return '$first และ $second';
  }

  @override
  String get sharedTargetOwnDrive => 'Drive ของคุณ';

  @override
  String sharedStatusLocalAhead(String targets) {
    return 'คุณล้ำหน้าอยู่ใน $targets';
  }

  @override
  String versionMismatch(String local, String drive) {
    return 'เวอร์ชันต่างกัน: ตัวเก็บไว้ข้างหน้า $local · Drive $drive…';
  }

  @override
  String get snackPathCopied => 'คัดลอกเส้นทางแล้ว';

  @override
  String get snackDestCopied => 'คัดลอกเส้นทางปลายทางแล้ว';

  @override
  String get snackDownloaded => 'ดาวน์โหลดการบันทึกไปยังเกม';

  @override
  String get snackReplacePrepareFailed =>
      'ไม่สามารถเตรียมเซฟได้ ไม่มีการเปลี่ยนแปลงใดๆ บนดิสก์';

  @override
  String get snackReplaceValidationFailed =>
      'เซฟที่ดาวน์โหลดมาดูเหมือนจะไม่ถูกต้องหรือไม่สมบูรณ์ ไม่มีการเปลี่ยนแปลงใดๆ บนดิสก์';

  @override
  String get snackReplaceBackupFailed =>
      'ไม่สามารถสร้างข้อมูลสำรองได้ ไม่มีการเปลี่ยนแปลงใดๆ บนดิสก์';

  @override
  String get snackReplaceSwapFailed =>
      'การสลับล้มเหลว แต่เซฟต้นฉบับถูกคืนค่าจากข้อมูลสำรองแล้ว';

  @override
  String get snackReplaceBusy => 'มีการดำเนินการกับเซฟนี้อยู่แล้ว';

  @override
  String get snackUploadIncomplete =>
      'เซฟในเครื่องนี้ไม่สมบูรณ์หรือเสียหาย ไม่มีการอัปโหลดใดๆ';

  @override
  String get snackDownloadIncomplete =>
      'ไม่สามารถดาวน์โหลดได้ ขาดเนื้อหาบน Drive';

  @override
  String get cardIncomplete => 'ไม่สมบูรณ์บน Drive';

  @override
  String get autoRefreshTitle => 'รีเฟรชอัตโนมัติ';

  @override
  String get autoRefreshSubtitle =>
      'ตรวจสอบการเปลี่ยนแปลงบน Drive ทุก 30 วินาที';

  @override
  String autoSyncSnack(String farmName) {
    return 'ซิงโครไนซ์ $farmName โดยอัตโนมัติแล้ว';
  }

  @override
  String get autoSyncTooltipOn =>
      'เปิดใช้งานซิงค์อัตโนมัติ — จะซิงโครไนซ์ให้เองเมื่อปลอดภัย';

  @override
  String get autoSyncTooltipOff => 'ปิดใช้งานซิงค์อัตโนมัติ — แตะเพื่อเปิด';

  @override
  String get autoSyncExplainTitle => 'ซิงค์อัตโนมัติ';

  @override
  String autoSyncExplainBody(String farmName) {
    return 'ตั้งแต่นี้ไป $farmName จะอัปโหลดหรือดาวน์โหลดเองเมื่อปลอดภัย โดยไม่ต้องขอให้คุณยืนยัน';
  }

  @override
  String get autoSyncExplainSafe =>
      'จะทำงานก็ต่อเมื่อคุณล้ำหน้าอย่างชัดเจนและไม่มีอะไรสูญหาย';

  @override
  String get autoSyncExplainDanger =>
      'หากมีความเสี่ยงที่จะสูญเสียความคืบหน้า จะไม่ทำงานเองเด็ดขาด คุณยังคงเป็นผู้ตัดสินใจผ่านกล่องโต้ตอบแบบเดิม';

  @override
  String get autoSyncExplainMissing =>
      'หากขาดสำเนาใดสำเนาหนึ่ง จะไม่สร้างให้เอง การอัปโหลดหรือดาวน์โหลดครั้งแรกคุณเป็นผู้ตัดสินใจ';

  @override
  String get autoSyncExplainDontShowAgain => 'ไม่ต้องแสดงข้อความนี้อีก';

  @override
  String get autoSyncExplainConfirm => 'เข้าใจแล้ว เปิดใช้งาน';

  @override
  String get hiwAutoSyncTitle => 'ซิงโครไนซ์ด้วยตัวเอง';

  @override
  String get hiwAutoSyncDesc =>
      'เซฟแต่ละอันมีชิป AUTO อยู่บนการ์ด เมื่อเปิดใช้งาน เซฟนั้นจะอัปโหลดหรือดาวน์โหลดเองเมื่อแอปตรวจพบการเปลี่ยนแปลง — โดยไม่ต้องเข้าไปยืนยัน';

  @override
  String get hiwAutoSyncTipSafe =>
      'จะซิงโครไนซ์เองก็ต่อเมื่อคุณล้ำหน้าอย่างชัดเจนและไม่มีอะไรสูญหาย';

  @override
  String get hiwAutoSyncTipDanger =>
      'หากมีความเสี่ยงที่จะสูญเสียความคืบหน้า จะไม่ทำเองเด็ดขาด ยังคงถามคุณผ่านหน้าจอเปรียบเทียบแบบเดิม';

  @override
  String get hiwAutoSyncTipPerSave =>
      'เปิดใช้งานทีละเซฟ ไม่ใช่เปิดพร้อมกันทั้งหมด คุณสามารถเปิดไว้ในเซฟของคุณแต่ปิดไว้ในเซฟที่แชร์ได้';

  @override
  String get hiwAutoSyncTipMissing =>
      'จะรักษาสำเนาสองชุดที่มีอยู่แล้วให้ซิงค์กันเท่านั้น หากขาดชุดใดชุดหนึ่ง การอัปโหลดหรือดาวน์โหลดครั้งแรกคุณต้องทำเอง';

  @override
  String get hiwAutoSyncTipRefresh =>
      'ในการตั้งค่า คุณสามารถปิดการตรวจสอบการเปลี่ยนแปลงอัตโนมัติทั้งหมดได้';

  @override
  String get snackSessionExpired =>
      'เซสชัน Drive หมดอายุแล้ว เชื่อมต่ออีกครั้ง';

  @override
  String snackUploadError(String error) {
    return 'ข้อผิดพลาดในการอัปโหลด: $error';
  }

  @override
  String snackDownloadError(String error) {
    return 'ข้อผิดพลาดในการดาวน์โหลด: $error';
  }

  @override
  String snackDeleteError(String error) {
    return 'ข้อผิดพลาดในการลบ: $error';
  }

  @override
  String snackTrashed(String saveName) {
    return '\"$saveName\" ย้ายไปยังถังขยะของ Drive แล้ว คุณมีเวลา 30 วันในการคืนค่า';
  }

  @override
  String snackDeletedLocal(String saveName) {
    return '\"$saveName\" ลบจากอุปกรณ์นี้แล้ว';
  }

  @override
  String get snackShizukuRequired => 'เปิดใช้งาน Shizuku…';

  @override
  String get snackWriteError =>
      'ไม่สามารถเขียนลงในเกม บางโทรศัพท์บล็อก /Android/data แม้ว่าจะใช้ Shizuku';

  @override
  String get snackPlatformNotSupported =>
      'แพลตฟอร์มนี้ยังไม่รองรับการเขียนบันทึกตัวเก็บไว้ข้างหน้า';

  @override
  String get snackWirelessDebugHint =>
      'เปิดด้วยตนเอง: การตั้งค่า → ตัวเลือกของนักพัฒนา → การแก้จุดข้อมูลไร้สาย';

  @override
  String get snackOpenShizukuApp => 'เปิด Shizuku จากลิ้นชักแอปของคุณ';

  @override
  String get hiwTipDeletePermanent =>
      'ValleySave ไม่สามารถกู้คืนบันทึกที่ถูกลบอย่างถาวร ไฟล์ Drive เป็นความรับผิดชอบของคุณ';

  @override
  String get hiwCompatAchievements =>
      'ความสำเร็จ Steam และ Google Play ไม่ส่งต่อ แต่ละแพลตฟอร์มจะติดตามเฉพาะความสำเร็จที่เกิดขึ้นในเวลาจริงเท่านั้น — ไฟล์บันทึกไม่ทำให้เกิดความสำเร็จย้อนหลัง';

  @override
  String get hiwCompatOverwrite =>
      'หากคุณซิงโครไนซ์จากอุปกรณ์สองเครื่องโดยไม่มีลำดับที่กำหนด บันทึกหนึ่งอาจเขียนทับอีกบันทึกหนึ่ง อัปโหลดเสมอก่อนดาวน์โหลด';

  @override
  String get hiwCompatVersions =>
      'บันทึกจากเวอร์ชันเกมต่างกันอาจไม่โหลดถูกต้อง ValleySave จะเตือนคุณหากตรวจหาความไม่ตรงกันของเวอร์ชันก่อนดาวน์โหลด';

  @override
  String get hiwCompatMods =>
      'โมด SMAPI เพิ่มข้อมูลพิเศษให้กับบันทึก หากคุณโหลดบันทึกที่มีการแก้ไขบนอุปกรณ์ที่ไม่ติดตั้งโมดเหล่านั้น เกมอาจขัดข้องหรือสูญเสียข้อมูลโมด\n\nบน Android SMAPI สามารถติดตั้งได้เช่นกัน เพื่อใช้โมด';

  @override
  String get hiwCompatIncomplete =>
      'หากคุณเห็นข้อความ \"ไม่สมบูรณ์บน Drive\" ในเซฟใด แสดงว่าขาดไฟล์ที่จำเป็นบนคลาวด์ — จะดาวน์โหลดไม่ได้จนกว่าจะมีการอัปโหลดใหม่อย่างถูกต้องจากอุปกรณ์อื่น';

  @override
  String get hiwShareTitle => 'แชร์กับผู้อื่น';

  @override
  String get hiwShareDesc =>
      'แชร์เซฟกับผู้เล่นคนอื่นทางอีเมล พวกเขาจะเห็นมันใน \"แชร์กับฉัน\" บนอุปกรณ์ของตัวเอง';

  @override
  String get hiwShareStepYourSave => 'เซฟ\nของคุณ';

  @override
  String get hiwShareStepShare => 'แชร์ทาง\nอีเมล';

  @override
  String get hiwShareStepFriend => 'แชร์\nกับฉัน';

  @override
  String get hiwShareTipRoles =>
      'มีสองบทบาท: อ่านอย่างเดียว อนุญาตให้ดูและดาวน์โหลดได้ อนุญาตให้ซิงโครไนซ์ อนุญาตให้เขียนทับสำเนาของคุณบน Drive ได้ ไม่ว่ากรณีใดก็ตาม พวกเขาไม่สามารถลบมันได้ — มีเพียงคุณ เจ้าของ เท่านั้นที่ลบเซฟของคุณได้';

  @override
  String get hiwShareTipDisconnect =>
      'การตัดการเชื่อมต่อจะหยุดแค่การซิงโครไนซ์ฝั่งของพวกเขาเท่านั้น — การแชร์ยังคงทำงานอยู่จนกว่าคุณจะออกจริงจาก \"จัดการการแชร์\"';

  @override
  String get hiwHostSwapTitle => 'การเปลี่ยนเจ้าของบ้าน';

  @override
  String get hiwHostSwapDesc =>
      'เปลี่ยนว่าฟาร์มแฮนด์คนใดเป็นเจ้าของบ้านของเซฟ โดยแทนที่ในตำแหน่งเดิม — สล็อตเซฟเดิม สิทธิ์การแชร์เดิม';

  @override
  String get hiwHostSwapStepPick => 'เลือก\nฟาร์มแฮนด์';

  @override
  String get hiwHostSwapStepConfirm => 'ยืนยัน';

  @override
  String get hiwHostSwapStepDone => 'สร้างเซฟใหม่\nเรียบร้อย';

  @override
  String get hiwHostSwapTipMove =>
      'วัตถุบางอย่างในฟาร์มอาจถูกย้ายที่เพื่อเปิดพื้นที่ให้บ้าน — จะไม่มีการลบสิ่งใดออก';

  @override
  String get hiwHostSwapTipHouse =>
      'บ้านของเจ้าของบ้านคนใหม่จะมีลักษณะเหมือนบ้านหลังใหญ่เริ่มต้นของเกม — รูปลักษณ์กระท่อมไม่รองรับหากไม่มีม็อด';

  @override
  String get hiwBackupsTitle => 'ข้อมูลสำรอง';

  @override
  String get hiwBackupsDesc =>
      'ข้อมูลสำรองคือภาพรวมของเซฟที่คุณสามารถคืนค่าได้ในภายหลัง สร้างด้วยตนเองได้ทุกเมื่อ หรือปล่อยให้ ValleySave สร้างให้อัตโนมัติก่อนเขียนทับเซฟ (ตอนดาวน์โหลด นำเข้า คืนค่า หรือเปลี่ยนเจ้าของบ้าน)';

  @override
  String get hiwBackupsStepSave => 'เซฟ\nของคุณ';

  @override
  String get hiwBackupsStepSnapshot => 'สร้าง\nข้อมูลสำรอง';

  @override
  String get hiwBackupsStepStore => 'เครื่องนี้และ/หรือ\nDrive';

  @override
  String get hiwBackupsTipRestore =>
      'การคืนค่าจะเขียนทับเซฟปัจจุบันของคุณด้วยเวอร์ชันก่อนหน้านั้น — ย้อนกลับไม่ได้';

  @override
  String get hiwBackupsTipDelete =>
      'การลบข้อมูลสำรองจะลบออกจากทุกที่ที่มันอยู่ (เครื่องนี้และ Drive หากอัปโหลดไว้) — ย้อนกลับไม่ได้';

  @override
  String get hiwBackupsTipExport =>
      'คุณยังสามารถส่งออกเซฟเป็นไฟล์ zip เพื่อเก็บไว้ที่ไหนก็ได้ และนำเข้ากลับมาในภายหลัง — เป็นทางเลือกแบบแมนนวลและพกพาได้แทนข้อมูลสำรองในตัว';

  @override
  String get hiwBackupsTipRetention =>
      'ValleySave จะเก็บข้อมูลสำรองอัตโนมัติล่าสุด 5 ชุดต่อเซฟหนึ่งอัน ส่วนที่คุณสร้างด้วยตนเองจะไม่ถูกลบไปเอง';

  @override
  String get hiwBackupsTipRestoreBridge =>
      'ในโหมด Bridge (Android ที่ไม่มี root/Shizuku) การคืนค่าข้อมูลสำรองจะขอให้คุณแตกไฟล์ .zip ด้วยตนเองลงในโฟลเดอร์ Stardew — เหมือนกับตอนดาวน์โหลด';

  @override
  String get hiwComparePrimary => 'เวลาเล่นทั้งหมด';

  @override
  String get hiwCompareNoShown1 => 'สถานะพืชและสัตว์เลี้ยง';

  @override
  String get hiwCompareNoShown2 => 'สินค้าคงคลังและไอเท็ม';

  @override
  String get hiwCompareNoShown3 => 'ความสัมพันธ์ส่วนบุคคล';

  @override
  String get hiwShizuku1 => 'ติดตั้ง Shizuku (Play Store หรือ APK GitHub)';

  @override
  String get hiwShizuku2 =>
      'เปิดใช้งานด้วยการแก้จุดข้อมูลไร้สาย — ValleySave จะแนะนำคุณทีละขั้นตอน';

  @override
  String get hiwShizuku3 => 'ให้สิทธิ์แก่ ValleySave เมื่อขอให้ทำ';

  @override
  String get hiwBridge1 =>
      'ดาวน์โหลดจาก Drive: ValleySave ปล่อยให้บันทึกอยู่ในโฟลเดอร์ของมัน คุณคัดลอกไปยังโฟลเดอร์ Stardew ด้วย Files';

  @override
  String get hiwBridge2 =>
      'อัปโหลดไปยัง Drive: คัดลอกบันทึกจาก Stardew ไปยังโฟลเดอร์ ValleySave ValleySave จะตรวจหามันและอัปโหลด';

  @override
  String get snackShizukuBattery =>
      'การตั้งค่า → แอป → Shizuku → แบตเตอรี่ → ไม่จำกัด';

  @override
  String snackDriveError(String error) {
    return 'Drive: $error';
  }

  @override
  String get dlgDeleteLocalWarning =>
      '⚠️ หากคุณไม่ได้อัปโหลดไปยัง Drive มันจะหายไปตลอดไป ไม่มีการกู้คืน';

  @override
  String get dlgDelete => 'ลบ';

  @override
  String get dlgDownloadButton => 'ดาวน์โหลด';

  @override
  String get dlgUploadButton => 'อัปโหลด';

  @override
  String get dlgBridgeCopyTitle => 'คัดลอกบันทึกไปยังเกม';

  @override
  String dlgBridgeCopyDesc(String saveName) {
    return 'บันทึกพร้อมแล้ว ด้วยแอป Files ของคุณ ให้คัดลอกโฟลเดอร์ \"$saveName\" และวางลงในโฟลเดอร์ Stardew';
  }

  @override
  String get labelFrom => 'จาก';

  @override
  String get labelTo => 'ถึง';

  @override
  String dlgDownloadNewDesc(String saveName, int day, String playtime) {
    return '\"$saveName\" (วัน $day, $playtime) จะถูกคัดลอกไปยังอุปกรณ์นี้';
  }

  @override
  String dlgDownloadOverwrite(String saveName) {
    return 'นี่จะเขียนทับบันทึกตัวเก็บไว้ข้างหน้าของ \"$saveName\"';
  }

  @override
  String dlgUploadNewDesc(String saveName, int day, String playtime) {
    return '\"$saveName\" (วัน $day, $playtime) จะถูกอัปโหลดไปยัง Drive ของคุณ';
  }

  @override
  String dlgUploadOverwriteDrive(String saveName) {
    return 'นี่จะเขียนทับเวอร์ชัน Drive ของ \"$saveName\"';
  }

  @override
  String get pathLabelFromStardew => 'จาก (Stardew)';

  @override
  String get pathLabelToValleySave => 'ถึง (ValleySave)';

  @override
  String get chooserDesc =>
      'Android ป้องกันโฟลเดอร์เกม เลือกวิธีให้ ValleySave เข้าถึง — คุณสามารถเปลี่ยนได้ทุกเมื่อ';

  @override
  String get chooserShizukuDesc =>
      'ตั้งค่าครั้งเดียว หลังจากนั้น ValleySave จะซิงโครไนซ์ของตัวเอง โดยไม่ต้องให้คุณสัมผัสอะไรเลย วิธีเดียวที่เชื่อถือได้บน Android 13+';

  @override
  String get chooserManualBadge => 'เฉพาะ ANDROID 11-12';

  @override
  String get chooserBridgeDesc =>
      'คัดลอกบันทึกด้วยแอป Files ของคุณ ไม่ต้องติดตั้งเพิ่มเติม เฉพาะ Android 11 และ 12 เท่านั้น';

  @override
  String get chooserRootBadge => 'ROOT';

  @override
  String get chooserRootTitle => 'เข้าถึง Root';

  @override
  String get chooserRootDesc =>
      'สำหรับอุปกรณ์ที่รูทแล้ว (Magisk / SuperSU). อนุมัติสิทธิ์ root หนึ่งครั้ง — ทำงานอัตโนมัติหลังจากนั้น';

  @override
  String get snackRootDenied => 'ถูกปฏิเสธการเข้าถึง Root ลองใช้ Shizuku แทน';

  @override
  String get shizukuGateSubtitle => 'ตั้งค่าครั้งเดียว · ครั้งแรกเท่านั้น';

  @override
  String get shizukuStatusLabel => 'Shizuku ใช้งานอยู่';

  @override
  String get shizukuStatusRunning => 'เชื่อมต่อและรอคอย';

  @override
  String get shizukuStatusNotDetected => 'ยังไม่พบ';

  @override
  String get shizukuPermLabel => 'ให้สิทธิ์แล้ว';

  @override
  String get shizukuPermGranted => 'ValleySave มีการเข้าถึงแล้ว';

  @override
  String get shizukuPermNotGranted => 'ต้องให้สิทธิ์แก่ ValleySave';

  @override
  String get shizukuGrant => 'ให้สิทธิ์';

  @override
  String get shizukuGuideHeader => 'คำแนะนำทีละขั้นตอน';

  @override
  String get shizukuStep1DescFull =>
      'ฟรี หากการตั้งค่า Google Play บล็อกบนโทรศัพท์ของคุณ ให้ใช้ APK ของ GitHub ที่เป็นทางการ';

  @override
  String get btnPlayStore => 'Play Store';

  @override
  String get btnApkGithub => 'APK GitHub';

  @override
  String get shizukuStep2TitleFull => 'เปิดใช้งานตัวเลือกของนักพัฒนา';

  @override
  String get shizukuStep2DescFull =>
      'การตั้งค่า → ข้อมูลโทรศัพท์ → ข้อมูลซอฟต์แวร์ → แตะ \"Build number\" 7 ครั้ง';

  @override
  String get shizukuStep3TitleFull => 'เปิดใช้งานการแก้จุดข้อมูลไร้สาย';

  @override
  String get shizukuStep3DescFull =>
      'ปุ่มจะพาคุณไปที่นั่นและเน้นมัน เปิดใช้งาน (เปิด) จากนั้นแตะ \"Pair device with pairing code\" — รหัส 6 หลักจะปรากฏบนหน้าจอ';

  @override
  String get btnOpenAndHighlight => 'เปิดและเน้น';

  @override
  String get shizukuStep4Title => 'จับคู่และ START Shizuku';

  @override
  String get shizukuStep4Desc =>
      'เปิด Shizuku → \"Start via Wireless Debugging\" → \"Pair with pairing code\" Shizuku จะส่งการแจ้งเตือนที่บอกว่ากำลังรอ ป้อนรหัส 6 หลักจากหน้าจอ Wireless Debugging หลังจากจับคู่ ให้กดปุ่ม START — หากไม่มีแตะครั้งสุดท้ายนี้ Shizuku จะไม่เปิดใช้งาน';

  @override
  String get btnOpenShizuku => 'เปิด Shizuku';

  @override
  String get shizukuStep5Title => 'ตั้งค่าแบตเตอรี่ Shizuku เป็น Unrestricted';

  @override
  String get shizukuStep5Desc =>
      'เปิด app info → Battery → Unrestricted หากคุณไม่ทำ ระบบจะปิด Shizuku ในพื้นหลังและคุณจะต้องกดปุ่ม Start อีกครั้ง';

  @override
  String get btnShizukuAppInfo => 'ข้อมูลแอป Shizuku';

  @override
  String get shizukuStep6DescActive =>
      'Shizuku ใช้งานอยู่ แตะปุ่มเพื่อให้สิทธิ์';

  @override
  String get shizukuStep6DescWaiting =>
      'พร้อมใช้งานเมื่อ Shizuku เปิดใช้งาน (ขั้นตอนที่ 4)';

  @override
  String get btnGrantPermission => 'ให้สิทธิ์';

  @override
  String get btnCheckShizuku => 'เสร็จสิ้น · ตรวจสอบ';

  @override
  String get statusDone => 'เสร็จสิ้น';

  @override
  String get statusPending => 'ค้างอยู่';

  @override
  String get latestBadge => '· บันทึกล่าสุด ·';

  @override
  String saveDateLabel(String season, int year) {
    return '$season · ปี $year';
  }

  @override
  String get petCat => 'แมว';

  @override
  String get petDog => 'สุนัข';

  @override
  String get houseBasic => 'บ้านพื้นฐาน';

  @override
  String get houseKitchen => 'มีห้องครัว';

  @override
  String get houseBedroom => 'มีห้องนอน';

  @override
  String get houseCellar => 'มีห้องเก็บของ';

  @override
  String houseLevelN(int level) {
    return 'ระดับ $level';
  }

  @override
  String get tooltipLaunchGame => 'เล่น';

  @override
  String get hiwLaunchTitle => 'เปิดเกม';

  @override
  String get hiwLaunchDesc =>
      'ปุ่ม ▶ ในแถบด้านบนของหน้าเซฟจะเปิด Stardew Valley โดยตรงจากแอป';

  @override
  String get hiwLaunchTipWindows =>
      'บน Windows หากไม่พบเกมอัตโนมัติ ให้ตั้งค่าพาธใน การตั้งค่า → เกม';

  @override
  String get hiwLaunchTipAndroid => 'บน Android จะเปิดเกมหากติดตั้งไว้แล้ว';

  @override
  String get hiwLaunchTipLinux =>
      'บน Linux หากไม่พบเกมโดยอัตโนมัติ ให้ตั้งค่าพาธไฟล์ปฏิบัติการใน การตั้งค่า → เกม';

  @override
  String get hiwSaveLocationsTitle => 'เซฟของคุณอยู่ที่ไหน';

  @override
  String get hiwSaveLocationsDesc =>
      'ValleySave อ่านและเขียนไปยังโฟลเดอร์เซฟของเกมโดยตรงในแต่ละแพลตฟอร์ม';

  @override
  String get hiwSaveLocationWindows =>
      'Windows: %AppData%\\StardewValley\\Saves';

  @override
  String get hiwSaveLocationAndroid =>
      'Android: โฟลเดอร์ที่ได้รับการป้องกัน เข้าถึงผ่าน Shizuku หรือ Bridge';

  @override
  String get hiwSaveLocationLinux =>
      'Linux: ~/.config/StardewValley/Saves (หรือ ~/snap/steam/common/.config/StardewValley/Saves หากติดตั้ง Steam ผ่าน snap)';

  @override
  String get settingsGameSection => 'เกม';

  @override
  String get settingsGameExePath => 'ไฟล์ปฏิบัติการ Stardew Valley';

  @override
  String get settingsGameExeNotFound => 'ไม่พบอัตโนมัติ';

  @override
  String get settingsGameExeBrowse => 'เรียกดู…';

  @override
  String get settingsGameExeSaved => 'บันทึกพาธแล้ว';

  @override
  String get snackLaunchError => 'ไม่สามารถเปิดเกมได้';

  @override
  String get makeHostAction => 'ตั้งเป็นเจ้าของบ้าน';

  @override
  String get makeHostExperimental => 'ทดลอง';

  @override
  String get makeHostDialogTitle => 'เปลี่ยนเจ้าของบ้าน';

  @override
  String makeHostDialogIntro(String playerName, String farmName) {
    return '$playerName จะกลายเป็นเจ้าของบ้านของ $farmName';
  }

  @override
  String get makeHostNewCopyNote =>
      'จะสร้างเซฟใหม่ขึ้นมา จากนั้นคุณจะเลือกเองว่าจะทำอย่างไรกับต้นฉบับ';

  @override
  String makeHostMoveCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other:
          'วัตถุในฟาร์ม $count ชิ้นจะถูกย้ายเพื่อเปิดพื้นที่ให้บ้าน จะไม่มีการลบสิ่งใดออก',
    );
    return '$_temp0';
  }

  @override
  String get makeHostHouseWarning =>
      'บ้านของเจ้าของบ้านคนใหม่จะมีลักษณะเหมือนบ้านฟาร์มหลักของเกม รูปลักษณ์กระท่อมไม่รองรับหากไม่มีม็อด';

  @override
  String get makeHostConfirmButton => 'ตั้งเป็นเจ้าของบ้าน';

  @override
  String makeHostSuccess(String playerName) {
    return 'สร้างเซฟใหม่แล้ว: $playerName เป็นเจ้าของบ้านคนใหม่แล้ว';
  }

  @override
  String get hostSwapErrInvalid =>
      'เซฟนี้มีโครงสร้างที่ไม่คาดคิด ไม่มีการเปลี่ยนแปลงใดๆ';

  @override
  String get hostSwapErrNoSpace =>
      'ไม่มีพื้นที่ว่างในฟาร์มสำหรับย้ายวัตถุ ไม่มีการเปลี่ยนแปลงใดๆ';

  @override
  String get hostSwapErrWrite =>
      'ไม่สามารถเขียนเซฟใหม่ได้ (ดิสก์/สิทธิ์การเข้าถึง) ไม่มีการเปลี่ยนแปลงใดๆ';

  @override
  String get hostSwapErrValidation =>
      'การตรวจสอบเซฟใหม่ล้มเหลว จึงถูกยกเลิก ต้นฉบับยังคงสมบูรณ์';

  @override
  String get makeHostDeleteOriginalTitle =>
      'ลบเซฟต้นฉบับออกจากเครื่องนี้หรือไม่?';

  @override
  String get makeHostDeleteOriginalBody =>
      'เซฟใหม่พร้อมแล้ว สำรองต้นฉบับไปยัง Drive ของคุณก่อน (คุณดาวน์โหลดใหม่ได้ภายหลัง) หรือจะลบเฉพาะสำเนาในเครื่องก็ได้';

  @override
  String get makeHostDeleteOriginalNoBackupBody =>
      'ไม่มีการเชื่อมต่อ Drive: จะไม่มีข้อมูลสำรองเหลืออยู่ จะลบเฉพาะสำเนาในเครื่องนี้เท่านั้น';

  @override
  String get makeHostDeleteOriginalUploadBody =>
      'เซฟต้นฉบับจะถูกอัปโหลดไปยัง Drive ของคุณเป็นข้อมูลสำรองก่อน จากนั้นจะลบสำเนาในเครื่องนี้';

  @override
  String get makeHostDeleteWithoutUpload => 'ลบโดยไม่อัปโหลด';

  @override
  String get makeHostUploadAndDelete => 'อัปโหลดและลบ';
}
