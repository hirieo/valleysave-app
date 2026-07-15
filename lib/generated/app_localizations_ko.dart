// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Korean (`ko`).
class AppLocalizationsKo extends AppLocalizations {
  AppLocalizationsKo([String locale = 'ko']) : super(locale);

  @override
  String get appTitle => 'ValleySave';

  @override
  String get welcomeTitle => '농장을 잃지 마세요, 어디든지 가져가세요.';

  @override
  String get connectGoogleDrive => 'Google Drive 연결';

  @override
  String get connecting => '연결 중…';

  @override
  String get mySaves => '내 저장';

  @override
  String get howItWorks => '작동 방식';

  @override
  String get settings => '설정';

  @override
  String get aboutSection => '정보';

  @override
  String get openSource => '사용 가능한 코드';

  @override
  String get nonCommercial => '비상업적';

  @override
  String get freeForever => '영구 무료';

  @override
  String get privacyTitle => '개인정보 보호 및 데이터 사용';

  @override
  String get privacyDescription =>
      'ValleySave는 Stardew Valley 저장 파일을 자신의 Google Drive 계정과 동기화하는 앱입니다.';

  @override
  String get whatDataTitle => '사용하는 데이터';

  @override
  String get whatDataDesc =>
      'ValleySave는 복사본을 만들고, 동기화하거나 복원하는 데 필요한 Stardew Valley 저장 파일에만 액세스합니다.';

  @override
  String get googleDriveTitle => 'Google Drive';

  @override
  String get googleDriveDesc =>
      '저장 파일은 자신의 Google Drive 계정에 업로드됩니다. ValleySave는 게임을 저장하기 위해 자체 서버를 사용하지 않습니다.';

  @override
  String get androidPermissionsTitle => 'Android 권한';

  @override
  String get androidPermissionsDesc =>
      'ValleySave는 저장 파일에 액세스하기 위해 저장 공간 권한 또는 Shizuku와 같은 도구가 필요할 수 있습니다.';

  @override
  String get adsTitle => '광고';

  @override
  String get adsDesc => 'ValleySave는 Google AdMob을 통해 광고를 표시할 수 있습니다.';

  @override
  String get responsibilityTitle => '책임';

  @override
  String get responsibilityDesc => '저장 파일은 귀하의 책임입니다.';

  @override
  String get deleteDataTitle => '데이터 삭제';

  @override
  String get deleteDataDesc =>
      'Google Drive에서 ValleySave 폴더를 수동으로 삭제하여 동기화된 복사본을 삭제할 수 있습니다.';

  @override
  String get sourceCodeTitle => '소스 코드 및 연락처';

  @override
  String get sourceCodeDesc =>
      'ValleySave는 Polyform Noncommercial 라이선스에 따라 사용 가능한 코드가 있는 프로젝트입니다.';

  @override
  String get upToDate => '최신';

  @override
  String get checkingUpdates => '확인 중…';

  @override
  String get updateAvailable => '사용 가능한 업데이트';

  @override
  String get application => '애플리케이션';

  @override
  String version(Object version) {
    return '버전 $version';
  }

  @override
  String get checkForUpdates => '업데이트 확인';

  @override
  String get shizukuRequired => 'Shizuku 필요';

  @override
  String get shizukuGuide => 'Shizuku 설정 가이드';

  @override
  String get activateShizuku => 'Shizuku를 활성화하여 게임에서 저장을 쓰십시오.';

  @override
  String deleteSaveTitle(Object saveName) {
    return '$saveName 삭제';
  }

  @override
  String get deleteSaveMessage => '이 기기에서 저장을 삭제합니다. 계속하시겠습니까?';

  @override
  String get deleteFromDrive => 'Drive에서 삭제';

  @override
  String confirmDelete(Object saveName) {
    return '$saveName 저장이 Google Drive 휴지통으로 이동합니다.';
  }

  @override
  String deleteFromDeviceMessage(Object saveName) {
    return '$saveName 저장이 이 기기에서 영구적으로 삭제됩니다.';
  }

  @override
  String restoreSaveTitle(Object saveName) {
    return '$saveName 복원';
  }

  @override
  String restoreSaveMessage(Object saveName) {
    return '$saveName을(를) 이 기기로 다운로드하시겠습니까?';
  }

  @override
  String get restore => '복원';

  @override
  String get cancel => '취소';

  @override
  String get error => '오류';

  @override
  String get success => '성공';

  @override
  String get loading => '로드 중…';

  @override
  String get disconnect => '연결 해제';

  @override
  String get ok => 'OK';

  @override
  String get yes => '예';

  @override
  String get no => '아니오';

  @override
  String get welcomeHeroPre => '농장을\n잃지 마세요,';

  @override
  String get welcomeHeroAccent => '어디든지';

  @override
  String get welcomeHeroPost => '\n가져가세요.';

  @override
  String get welcomeSubtitle =>
      '모든 기기에서 Stardew Valley 저장을 동기화하세요. 데이터는 자신의 Google Drive에 있습니다 — 서버 없음, 구독 없음, 완전한 제어.';

  @override
  String get welcomeDriveConnected => 'Drive 연결됨';

  @override
  String get welcomeFooterTagline => '· 비상업적 · 영구 무료 ·';

  @override
  String updateVersionAvailable(String version) {
    return 'v$version 사용 가능';
  }

  @override
  String get sectionMode => '모드';

  @override
  String get sectionSeason => '계절';

  @override
  String get sectionLanguage => '언어';

  @override
  String get modeAutoTitle => '자동';

  @override
  String get modeAutoDesc => '활성 저장을 따르며, 저장이 없으면 실제 위치를 따릅니다.';

  @override
  String get modeSavesTitle => '저장별';

  @override
  String get modeSavesDesc => '항상 최근 저장의 계절을 사용합니다.';

  @override
  String get modeGeoTitle => '위치별';

  @override
  String get modeGeoDesc => '항상 해당 위치의 실제 계절을 사용합니다.';

  @override
  String get modeFixedTitle => '고정 계절';

  @override
  String get modeFixedDesc => '항상 동일한 계절을 표시합니다.';

  @override
  String get modeRandomTitle => '무작위';

  @override
  String get modeRandomDesc => '앱을 열 때마다 다른 계절을 선택합니다.';

  @override
  String get seasonInitial => '초기';

  @override
  String get seasonSpring => '봄';

  @override
  String get seasonSummer => '여름';

  @override
  String get seasonFall => '가을';

  @override
  String get seasonWinter => '겨울';

  @override
  String get autoPriorityTitle => '우선 순위';

  @override
  String get autoStep1Title => '처음 실행';

  @override
  String get autoStep1Desc => '초기 상태를 표시합니다.';

  @override
  String get autoStep2Title => '활성 저장';

  @override
  String get autoStep2Desc => '마지막 동기화된 저장의 계절을 사용합니다.';

  @override
  String get autoStep3Title => '위치';

  @override
  String get autoStep3Desc => '반구 및 지역의 실제 계절을 감지합니다.';

  @override
  String get autoStep4Title => '기본값';

  @override
  String get autoStep4Desc => '사용 가능한 데이터가 없으면 초기 (야간 모드)입니다.';

  @override
  String get versionInstalled => '설치된 버전';

  @override
  String get updateNeverChecked => '확인하지 않음';

  @override
  String get updateCheckedNow => '방금 확인함';

  @override
  String get updateOutdatedDownload => '최신이 아님 · 다운로드';

  @override
  String get updateDownloading => '업데이트 다운로드 중…';

  @override
  String get updateError => '오류 — 다시 시도하려면 탭하세요';

  @override
  String get disconnectTitle => 'Drive 연결을 끊으시겠습니까?';

  @override
  String disconnectBody(String email) {
    return 'Drive의 저장은 삭제되지 않습니다. 언제든지 다시 연결할 수 있습니다.';
  }

  @override
  String get disconnectButton => 'Drive 연결 해제';

  @override
  String disconnectButtonEmail(String email) {
    return 'Disconnect from $email';
  }

  @override
  String get connectedAsPrefix => 'Connected as';

  @override
  String get languageTileLabel => '언어';

  @override
  String get languageDialogTitle => '앱 언어';

  @override
  String get searchHint => '검색…';

  @override
  String get languageAuto => '시스템 언어';

  @override
  String get languageAutoDesc => '시스템 언어를 사용합니다';

  @override
  String get privacyPolicyTitle => '개인정보 보호정책';

  @override
  String get privacyBeforeStartTitle => '시작하기 전에';

  @override
  String get privacyLastUpdated => '마지막 업데이트: 2026년 6월';

  @override
  String get privacyAccept => '알겠습니다, 계속';

  @override
  String get cardSynced => '동기화됨';

  @override
  String get cardLocalAhead => '로컬이 더 최신';

  @override
  String get cardDriveAhead => 'Drive가 더 최신';

  @override
  String get cardLocalOnly => '로컬만';

  @override
  String get cardDriveOnly => 'Drive만';

  @override
  String get cardTimeNow => '지금';

  @override
  String cardTimeMinutesAgo(int minutes) {
    return '$minutes분 전';
  }

  @override
  String cardTimeHoursAgo(int hours) {
    return '$hours시간 전';
  }

  @override
  String cardTimeDaysAgo(int days) {
    return '$days일 전';
  }

  @override
  String cardTimeMonthsAgo(int months) {
    return '$months개월 전';
  }

  @override
  String get cardDetailLocalTitle => '이 기기에서';

  @override
  String get cardDetailRemoteTitle => 'Drive에서';

  @override
  String get cardDetailUpload => 'Drive에 업로드';

  @override
  String get cardDetailDownload => '저장 다운로드';

  @override
  String get cardDetailDeleteLabel => '삭제';

  @override
  String get cardDetailDeleteLocal => '이 기기에서 삭제';

  @override
  String get cardDetailDeleteRemote => 'Drive에서 삭제';

  @override
  String get cardCloseBarrier => '닫기';

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
    return '$day일 · $year년';
  }

  @override
  String statDayOnly(int day) {
    return '$day일';
  }

  @override
  String get statPlaytime => '플레이 시간';

  @override
  String get statMoney => '코인';

  @override
  String get statTotal => '합계';

  @override
  String get statMineUnexplored => '미탐험';

  @override
  String get statMine => '광산';

  @override
  String get statMineLvl => '광산 · Lv';

  @override
  String get skillFarming => '농업';

  @override
  String get skillForaging => '채집';

  @override
  String get skillMining => '채광';

  @override
  String get skillFishing => '낚시';

  @override
  String get skillCombat => '전투';

  @override
  String get cardLocalPresence => '이 기기에서';

  @override
  String get cardRemotePresence => 'Drive에서';

  @override
  String get cardNotPresent => '여기에 없음';

  @override
  String get cardActionSynced => '동기화됨';

  @override
  String get cardActionUpload => '업로드';

  @override
  String get cardActionDownload => '다운로드';

  @override
  String get pillMonsters => '몬스터';

  @override
  String get pillFriends => '친구';

  @override
  String get pillFaints => '기절';

  @override
  String get pillSleeps => '수면';

  @override
  String get hiwTitle => '작동 방식';

  @override
  String get hiwSyncTitle => '동기화 방식';

  @override
  String get hiwSyncIntro =>
      'ValleySave는 기기 간에 저장을 이동하기 위해 자신의 Google Drive를 사용합니다. 중개 서버 없음: 파일은 귀하의 것입니다.';

  @override
  String get hiwSyncDevice => '귀하의\n기기';

  @override
  String get hiwSyncCloud => 'Google\nDrive';

  @override
  String get hiwSyncOtherDevice => '다른\n기기';

  @override
  String get hiwUploadTitle => '저장 업로드';

  @override
  String get hiwUploadDesc =>
      '업로드할 때 ValleySave는 두 저장 파일 (SaveGameInfo + 농장 파일)을 Drive의 ValleySave/ 폴더에 복사합니다.';

  @override
  String get hiwDownloadTitle => '저장 다운로드';

  @override
  String get hiwDownloadDesc =>
      '다운로드할 때 ValleySave는 Drive의 파일을 가져와 게임 폴더에 직접 배치합니다.';

  @override
  String get hiwCompareTitle => '무엇을 비교합니까?';

  @override
  String get hiwCompareIntro =>
      '어느 버전이 더 최신인지 알기 위해 ValleySave는 총 플레이 시간을 사용합니다 — 유일하게 증가할 수 있는 데이터입니다.';

  @override
  String get hiwCompareNote => '확인하기 전에 다음도 표시되므로 결정할 수 있습니다:';

  @override
  String get hiwCompareMoney => '현재 금액 및 총 획득';

  @override
  String get hiwCompareMine => '광산 레벨';

  @override
  String get hiwCompareSkills => '기술 (농업, 채광, 전투…)';

  @override
  String get hiwCompareRelations => '친구, 처치한 몬스터, 기절';

  @override
  String get hiwCompareStamina => '체력 및 건강';

  @override
  String get hiwCompareNotShown =>
      '다음은 표시되지 않습니다 — 어느 방향으로든 변하며 어느 저장이 더 최신인지를 나타내지 않습니다.';

  @override
  String get hiwCompareNotShownExamples => '작물 및 동물 상태, 인벤토리 및 아이템, 개별 관계';

  @override
  String get hiwCompareWarning =>
      '다음은 표시되지 않습니다 — 어느 방향으로든 변하며 어느 저장이 더 최신인지를 나타내지 않습니다.';

  @override
  String get hiwConflictTitle => '동기화하지 않고 플레이하면';

  @override
  String get hiwConflictDesc =>
      '모바일과 PC에서 세션 간에 동기화하지 않고 진행하면 동일한 저장의 두 버전을 얻습니다.';

  @override
  String get hiwConflictNoMerge =>
      '병합할 수 없습니다. ValleySave는 항상 두 버전을 모두 표시하므로 어느 버전을 유지할지 선택할 수 있습니다.';

  @override
  String get hiwConflictMobile => '모바일';

  @override
  String get hiwConflictVersionA => '버전 A';

  @override
  String get hiwConflictPC => 'PC';

  @override
  String get hiwConflictVersionB => '버전 B';

  @override
  String get hiwDeleteTitle => '저장이 삭제되면';

  @override
  String get hiwDeleteDesc =>
      'Drive에서 저장을 삭제하면 즉시 사라지지 않습니다: Google Drive 휴지통으로 이동합니다.';

  @override
  String get hiwCompatTitle => '플랫폼 호환성';

  @override
  String get hiwCompatAndroidAccess => 'ANDROID에서 액세스';

  @override
  String get hiwShizukuTitle => 'Shizuku 사용';

  @override
  String get hiwShizukuSubtitle =>
      '한 번 설정하세요. 그 후 ValleySave는 자동으로 동기화되며, 다시 건드릴 필요가 없습니다.';

  @override
  String get hiwShizukuBadge => '자동 · 권장';

  @override
  String get hiwShizukuDone =>
      '✓  완료. 그 후부터는 다운로드 및 업로드 저장이 직접적이며, 컴퓨터처럼 작동합니다.';

  @override
  String get hiwShizukuNote =>
      '페어링은 처음만 필요합니다. 새 Shizuku 버전은 휴대폰을 다시 시작한 후 자동으로 다시 활성화됩니다.';

  @override
  String get hiwBridgeTitle => '수동 브리지';

  @override
  String get hiwBridgeSubtitle =>
      'Android 11 및 12에서만 작동합니다. 추가로 설치하지 않습니다. 대신 동기화할 때마다 파일 앱으로 수동으로 저장을 복사합니다.';

  @override
  String get hiwBridgeBadge => '수동 대안 · ANDROID 11-12';

  @override
  String get hiwBridgeSaveFolder => 'Stardew의 폴더';

  @override
  String get hiwBridgeValleySaveFolder => 'ValleySave의 폴더';

  @override
  String get hiwBridgeNote =>
      '시스템 파일 앱이 이러한 폴더에 액세스할 수 있기 때문에 작동합니다 (ValleySave는 할 수 없음).';

  @override
  String get hiwTipAlwaysShow => '항상 덮어쓰기 전에 Drive에 있는 내용을 표시하므로 비교할 수 있습니다.';

  @override
  String get hiwTipWithoutUpload => '업로드하지 않으면 다른 기기에서 최근 진행률을 볼 수 없습니다.';

  @override
  String get hiwTipComparison => '확인하기 전에 로컬과 Drive 간의 비교를 표시합니다.';

  @override
  String get hiwTipDownloadOverwrite =>
      '다운로드는 로컬 저장을 덮어씁니다. 동기화하지 않은 진행률은 손실됩니다.';

  @override
  String get hiwTipSync => '기기를 전환하기 전에 항상 업로드하고, 도착했을 때 다운로드하세요.';

  @override
  String get hiwTipDeletion => '영구 삭제되기 전에 30일 동안 Drive 휴지통에서 복원할 수 있습니다.';

  @override
  String get hiwPrivacyLink => '개인정보 보호정책 및 사용';

  @override
  String get emptyNoSaves => '저장을 찾을 수 없음';

  @override
  String get emptyNoSavesHint => '이 기기에서 읽을 수 있는 로컬 저장이 없습니다';

  @override
  String get bridgeTitle => '저장 가져오기';

  @override
  String get bridgeDesc =>
      '로컬 저장을 보고 업로드하려면 파일 앱으로 Stardew 폴더에서 이 ValleySave 폴더로 복사하세요. 그 다음 새로고침합니다.';

  @override
  String get bridgeRefresh => '새로고침';

  @override
  String get bridgeChangeMode => '방법 변경';

  @override
  String get loaderLoading => '로드 중';

  @override
  String get loaderConnecting => 'Drive에 연결 중…';

  @override
  String get chooserTitle => '연결 방식 선택';

  @override
  String get chooserAutomatic => '자동 · 권장';

  @override
  String get chooserManual => '수동 대안 · Android 11-12';

  @override
  String get shizukuStepTitle => 'Shizuku 설정';

  @override
  String get shizukuStep1Title => 'Shizuku 설치';

  @override
  String get shizukuStep1Desc => 'Play Store 또는 GitHub에서 다운로드하세요';

  @override
  String get shizukuStep2Title => 'Shizuku 활성화';

  @override
  String get shizukuStep2Desc => '앱을 실행하고 권한을 부여하세요';

  @override
  String get shizukuStep3Title => '권한 부여';

  @override
  String get shizukuStep3Desc => 'ValleySave가 액세스를 요청합니다';

  @override
  String get shizukuDone =>
      '✓  완료. 그 후부터는 저장 다운로드 및 업로드가 직접적으로 작동하며, 컴퓨터처럼 입니다.';

  @override
  String get dlgDeleteDriveTitle => 'Drive에서 삭제';

  @override
  String get dlgDeleteLocalTitle => '이 기기에서 삭제';

  @override
  String get dlgDownloadTitle => '저장 다운로드';

  @override
  String get dlgUploadTitle => '저장 업로드';

  @override
  String get dlgUploadOverwrite => '로컬 저장을 덮어씁니다';

  @override
  String get dlgGotIt => '알겠습니다';

  @override
  String get dlgCopyDest => '복사 대상';

  @override
  String get previewColDayYear => '날짜/년';

  @override
  String get previewColTime => '플레이 시간';

  @override
  String get previewColMoney => '코인';

  @override
  String get previewColTotal => '합계';

  @override
  String get previewColFarming => '농업';

  @override
  String get previewColForaging => '채집';

  @override
  String get previewColMining => '채광';

  @override
  String get previewColFishing => '낚시';

  @override
  String get previewColCombat => '전투';

  @override
  String get previewColFriends => '친구';

  @override
  String get previewColMonsters => '몬스터';

  @override
  String get previewColFaints => '기절';

  @override
  String get previewColMine => '광산';

  @override
  String get previewColUnexplored => '미탐험';

  @override
  String get previewLocalLabel => '이 기기에서';

  @override
  String get previewDriveLabel => 'Drive에서';

  @override
  String get previewFromDrive => 'Drive에서';

  @override
  String get previewFromDevice => '이 기기에서';

  @override
  String versionMismatch(String local, String drive) {
    return '다른 버전: 로컬 $local · Drive $drive…';
  }

  @override
  String get snackPathCopied => '경로 복사됨';

  @override
  String get snackDestCopied => '대상 경로 복사됨';

  @override
  String get snackDownloaded => '저장이 게임으로 다운로드됨';

  @override
  String get snackSessionExpired => 'Drive 세션이 만료되었습니다. 다시 연결하세요';

  @override
  String snackUploadError(String error) {
    return '업로드 오류: $error';
  }

  @override
  String snackDownloadError(String error) {
    return '다운로드 오류: $error';
  }

  @override
  String snackDeleteError(String error) {
    return '삭제 오류: $error';
  }

  @override
  String snackTrashed(String saveName) {
    return '\"$saveName\" Drive 휴지통으로 이동됨. 복원할 수 있는 시간: 30일.';
  }

  @override
  String snackDeletedLocal(String saveName) {
    return '\"$saveName\" 이 기기에서 삭제됨';
  }

  @override
  String get snackShizukuRequired => 'Shizuku 활성화…';

  @override
  String get snackWriteError =>
      '게임에 쓸 수 없습니다. 일부 휴대폰은 Shizuku를 사용해도 /Android/data를 차단합니다.';

  @override
  String get snackPlatformNotSupported => '이 플랫폼은 아직 로컬 저장 쓰기를 지원하지 않습니다.';

  @override
  String get snackWirelessDebugHint => '수동으로 열기: 설정 → 개발자 옵션 → 무선 디버깅.';

  @override
  String get snackOpenShizukuApp => '앱 드로어에서 Shizuku를 여세요.';

  @override
  String get hiwTipDeletePermanent =>
      'ValleySave는 영구 삭제된 저장을 복구할 수 없습니다. Drive 파일은 귀하의 책임입니다.';

  @override
  String get hiwCompatAchievements =>
      'Steam 및 Google Play 성취는 전송되지 않습니다. 각 플랫폼은 실시간으로 발생하는 성취만 추적합니다 — 저장 파일이 이를 소급 적용하지 않습니다.';

  @override
  String get hiwCompatOverwrite =>
      '설정된 순서 없이 두 기기에서 동기화하면 한 저장이 다른 저장을 덮어쓸 수 있습니다. 항상 다운로드하기 전에 업로드하세요.';

  @override
  String get hiwCompatVersions =>
      '다른 게임 버전의 저장은 올바르게 로드되지 않을 수 있습니다. ValleySave는 다운로드 전에 버전 불일치를 감지하면 경고합니다.';

  @override
  String get hiwCompatMods =>
      'SMAPI 모드는 저장에 추가 데이터를 추가합니다. 해당 모드가 설치되지 않은 기기에서 모드된 저장을 로드하면 게임이 충돌하거나 모드 데이터가 손실될 수 있습니다.\n\nAndroid에서는 모드를 사용하기 위해 SMAPI를 설치할 수도 있습니다.';

  @override
  String get hiwComparePrimary => '총 플레이 시간';

  @override
  String get hiwCompareNoShown1 => '작물 및 동물 상태';

  @override
  String get hiwCompareNoShown2 => '인벤토리 및 아이템';

  @override
  String get hiwCompareNoShown3 => '개별 관계';

  @override
  String get hiwShizuku1 => 'Shizuku를 설치하세요 (Play Store 또는 GitHub APK).';

  @override
  String get hiwShizuku2 => '무선 디버깅으로 활성화하세요 — ValleySave가 단계별로 안내합니다.';

  @override
  String get hiwShizuku3 => '메시지가 표시되면 ValleySave에 권한을 부여하세요.';

  @override
  String get hiwBridge1 =>
      'Drive에서 다운로드: ValleySave는 저장을 폴더에 남깁니다. 파일 앱으로 Stardew의 폴더에 복사합니다.';

  @override
  String get hiwBridge2 =>
      'Drive에 업로드: Stardew에서 ValleySave의 폴더로 저장을 복사하세요. ValleySave가 감지하고 업로드합니다.';

  @override
  String get snackShizukuBattery => '설정 → 앱 → Shizuku → 배터리 → 무제한.';

  @override
  String snackDriveError(String error) {
    return 'Drive: $error';
  }

  @override
  String get dlgDeleteLocalWarning => '⚠️ Drive에 업로드하지 않았으면 영구히 손실됩니다. 복구 없음.';

  @override
  String get dlgDelete => '삭제';

  @override
  String get dlgDownloadButton => '다운로드';

  @override
  String get dlgUploadButton => '업로드';

  @override
  String get dlgBridgeCopyTitle => '저장을 게임에 복사';

  @override
  String dlgBridgeCopyDesc(String saveName) {
    return '저장 준비 완료. 파일 앱으로 \"$saveName\" 폴더를 복사하여 Stardew 폴더에 붙여넣으세요.';
  }

  @override
  String get labelFrom => '출처';

  @override
  String get labelTo => '대상';

  @override
  String dlgDownloadNewDesc(String saveName, int day, String playtime) {
    return '\"$saveName\" ($day일, $playtime)이(가) 이 기기로 복사됩니다.';
  }

  @override
  String dlgDownloadOverwrite(String saveName) {
    return '\"$saveName\"의 로컬 저장을 덮어씁니다.';
  }

  @override
  String dlgUploadNewDesc(String saveName, int day, String playtime) {
    return '\"$saveName\" ($day일, $playtime)이(가) Drive에 업로드됩니다.';
  }

  @override
  String dlgUploadOverwriteDrive(String saveName) {
    return '\"$saveName\"의 Drive 버전을 덮어씁니다.';
  }

  @override
  String get pathLabelFromStardew => '출처 (Stardew)';

  @override
  String get pathLabelToValleySave => '대상 (ValleySave)';

  @override
  String get chooserDesc =>
      'Android는 게임 폴더를 보호합니다. ValleySave에 액세스를 제공하는 방법을 선택하세요 — 언제든지 변경할 수 있습니다.';

  @override
  String get chooserShizukuDesc =>
      '한 번 설정됨. 그 후 ValleySave는 자동으로 동기화되며, 아무것도 건드릴 필요가 없습니다. Android 13 이상에서만 신뢰할 수 있는 방법입니다.';

  @override
  String get chooserManualBadge => 'Android 11-12만';

  @override
  String get chooserBridgeDesc =>
      '파일 앱으로 저장을 복사하세요. 추가 설치 없음. Android 11 및 12에서만.';

  @override
  String get chooserRootBadge => 'ROOT';

  @override
  String get chooserRootTitle => '루트 접근';

  @override
  String get chooserRootDesc =>
      '루팅된 기기용 (Magisk / SuperSU). 루트 권한을 한 번 승인하면 이후 자동으로 작동합니다.';

  @override
  String get snackRootDenied => '루트 접근이 거부되었습니다. Shizuku를 사용해 보세요.';

  @override
  String get shizukuGateSubtitle => '한 번 설정됨 · 처음만';

  @override
  String get shizukuStatusLabel => 'Shizuku 활성';

  @override
  String get shizukuStatusRunning => '연결됨 및 대기 중.';

  @override
  String get shizukuStatusNotDetected => '아직 감지되지 않음.';

  @override
  String get shizukuPermLabel => '권한 부여됨';

  @override
  String get shizukuPermGranted => 'ValleySave는 이미 액세스 권한이 있습니다.';

  @override
  String get shizukuPermNotGranted => 'ValleySave 승인 필요.';

  @override
  String get shizukuGrant => '부여';

  @override
  String get shizukuGuideHeader => '단계별 가이드';

  @override
  String get shizukuStep1DescFull =>
      '무료. Google Play에서 차단되면 공식 GitHub APK를 사용하세요.';

  @override
  String get btnPlayStore => 'Play Store';

  @override
  String get btnApkGithub => 'APK GitHub';

  @override
  String get shizukuStep2TitleFull => '개발자 옵션 활성화';

  @override
  String get shizukuStep2DescFull =>
      '설정 → 휴대폰 정보 → 소프트웨어 정보 → \"빌드 번호\" 7번 탭하세요.';

  @override
  String get shizukuStep3TitleFull => '무선 디버깅 활성화';

  @override
  String get shizukuStep3DescFull =>
      '버튼이 해당 위치로 이동합니다 (강조됨). 활성화하세요 (ON). \"페어링 코드로 기기 페어링\" 탭하세요 — 화면에 6자리 코드가 나타납니다.';

  @override
  String get btnOpenAndHighlight => '열기 및 강조';

  @override
  String get shizukuStep4Title => '페어링 및 Shizuku 시작';

  @override
  String get shizukuStep4Desc =>
      'Shizuku 열기 → \"무선 디버깅 시작\" → \"페어링 코드로 페어링\". Shizuku가 대기 중이라는 알림을 보냅니다. 무선 디버깅 화면에서 6자리 코드를 입력하세요. 페어링 후 시작을 누르세요 — 마지막 탭이 없으면 Shizuku가 활성화되지 않습니다.';

  @override
  String get btnOpenShizuku => 'Shizuku 열기';

  @override
  String get shizukuStep5Title => 'Shizuku 배터리를 무제한으로 설정';

  @override
  String get shizukuStep5Desc =>
      '앱 정보 열기 → 배터리 → 무제한. 그렇지 않으면 시스템이 백그라운드에서 Shizuku를 닫고 다시 시작을 눌러야 합니다.';

  @override
  String get btnShizukuAppInfo => 'Shizuku 앱 정보';

  @override
  String get shizukuStep6DescActive => 'Shizuku가 활성 상태입니다. 버튼을 눌러 승인하세요.';

  @override
  String get shizukuStep6DescWaiting => 'Shizuku가 활성화된 후 사용 가능 (단계 4).';

  @override
  String get btnGrantPermission => '권한 부여';

  @override
  String get btnCheckShizuku => '완료 · 확인';

  @override
  String get statusDone => '완료';

  @override
  String get statusPending => '보류 중';

  @override
  String get latestBadge => '· 최신 저장 ·';

  @override
  String saveDateLabel(String season, int year) {
    return '$season · $year년';
  }

  @override
  String get petCat => '고양이';

  @override
  String get petDog => '개';

  @override
  String get houseBasic => '기본 집';

  @override
  String get houseKitchen => '부엌 포함';

  @override
  String get houseBedroom => '침실 포함';

  @override
  String get houseCellar => '지하실 포함';

  @override
  String houseLevelN(int level) {
    return 'Lv. $level';
  }

  @override
  String get tooltipLaunchGame => '플레이';

  @override
  String get hiwLaunchTitle => '게임 실행';

  @override
  String get hiwLaunchDesc =>
      '내 세이브 화면 상단 바의 ▶ 버튼으로 앱에서 바로 Stardew Valley를 실행할 수 있습니다.';

  @override
  String get hiwLaunchTipWindows =>
      'Windows에서 게임이 자동으로 감지되지 않으면 설정 → 게임에서 실행 파일 경로를 설정하세요.';

  @override
  String get hiwLaunchTipAndroid => 'Android에서는 게임이 설치되어 있으면 실행됩니다.';

  @override
  String get settingsGameSection => '게임';

  @override
  String get settingsGameExePath => 'Stardew Valley 실행 파일';

  @override
  String get settingsGameExeNotFound => '자동으로 찾을 수 없음';

  @override
  String get settingsGameExeBrowse => '찾아보기…';

  @override
  String get settingsGameExeSaved => '경로 저장됨';

  @override
  String get snackLaunchError => '게임을 열 수 없습니다';

  @override
  String get makeHostAction => '호스트로 만들기';

  @override
  String get makeHostExperimental => '실험적 기능';

  @override
  String get makeHostDialogTitle => '호스트 변경';

  @override
  String makeHostDialogIntro(String playerName, String farmName) {
    return '$playerName님이 $farmName의 호스트가 됩니다.';
  }

  @override
  String get makeHostNewCopyNote => '새 세이브 파일이 생성됩니다. 이후 원본을 어떻게 할지 직접 결정합니다.';

  @override
  String makeHostMoveCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '집을 지을 공간을 확보하기 위해 농장의 오브젝트 $count개가 이동합니다. 아무것도 삭제되지 않습니다.',
    );
    return '$_temp0';
  }

  @override
  String get makeHostHouseWarning =>
      '새 호스트의 집은 게임의 메인 농장 주택처럼 보입니다. 오두막 외관은 모드 없이는 지원되지 않습니다.';

  @override
  String get makeHostConfirmButton => '호스트로 만들기';

  @override
  String makeHostSuccess(String playerName) {
    return '새 세이브 파일 생성됨: 이제 $playerName님이 호스트입니다.';
  }

  @override
  String get hostSwapErrInvalid => '이 세이브 파일의 구조가 예상과 다릅니다. 아무것도 변경되지 않았습니다.';

  @override
  String get hostSwapErrNoSpace =>
      '오브젝트를 재배치할 여유 공간이 농장에 없습니다. 아무것도 변경되지 않았습니다.';

  @override
  String get hostSwapErrWrite => '새 세이브 파일을 쓸 수 없습니다(디스크/권한). 아무것도 변경되지 않았습니다.';

  @override
  String get hostSwapErrValidation => '새 세이브 파일 검증에 실패하여 폐기되었습니다. 원본은 그대로입니다.';
}
