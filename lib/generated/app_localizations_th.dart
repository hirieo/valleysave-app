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
  String get disconnectTitle => 'ตัดการเชื่อมต่อ Drive?';

  @override
  String disconnectBody(String email) {
    return 'บันทึกของคุณใน Drive จะไม่ถูกลบ คุณสามารถเชื่อมต่อใหม่ได้ทุกเมื่อ';
  }

  @override
  String get disconnectButton => 'ตัดการเชื่อมต่อ Drive';

  @override
  String disconnectButtonEmail(String email) {
    return 'Disconnect from $email';
  }

  @override
  String get connectedAsPrefix => 'Connected as';

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
}
