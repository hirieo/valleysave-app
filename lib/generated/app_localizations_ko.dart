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
  String get updateNeedsPermission =>
      'ValleySave에 대해 \'알 수 없는 앱 설치\'를 허용한 후 업데이트를 다시 눌러주세요';

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
    return '$email에서 연결 해제';
  }

  @override
  String get connectedAsPrefix => '연결된 계정';

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
  String get exportAction => '내보내기';

  @override
  String get exportSuccess => '세이브를 내보냈습니다.';

  @override
  String exportError(String error) {
    return '세이브를 내보내지 못했습니다: $error';
  }

  @override
  String get importAction => '세이브 가져오기';

  @override
  String importSuccess(String playerName) {
    return '$playerName님의 세이브를 가져왔습니다.';
  }

  @override
  String get importErrInvalidZip => '이 파일은 유효한 zip 파일이 아닙니다.';

  @override
  String get importErrUnsafePath => '이 파일은 안전하지 않은 구조로 되어 있어 거부되었습니다.';

  @override
  String get importErrTooLarge => '이 파일은 너무 커서 가져올 수 없습니다.';

  @override
  String get importErrNotASave => '이 파일에는 인식할 수 있는 세이브가 들어 있지 않습니다.';

  @override
  String get importErrWrite => '가져온 세이브를 쓸 수 없었습니다(디스크/권한).';

  @override
  String get importErrBackupFailed => '백업을 생성하지 못했습니다. 아무것도 가져오지 않았습니다.';

  @override
  String get importConflictTitle => '이 이름의 세이브가 이미 있습니다';

  @override
  String get importConflictBody => '가져오기를 하면 기존 로컬 사본이 교체됩니다. 되돌릴 수 없습니다.';

  @override
  String get importConflictConfirm => '덮어쓰기';

  @override
  String get shareAction => '공유';

  @override
  String get shareUploadFirstCta => '먼저 업로드';

  @override
  String get shareDialogTitle => '세이브 공유';

  @override
  String get shareEmailPlaceholder => 'name@example.com';

  @override
  String get shareInfoNote =>
      '공유하면 보기 및 다운로드 권한이 부여됩니다. Drive의 사본을 수정하거나 삭제할 수 있는 사람은 회원님뿐입니다.';

  @override
  String get shareRoleReader => '읽기 전용';

  @override
  String get shareRoleWriter => '동기화 허용';

  @override
  String get shareInfoNoteCoop =>
      '\'읽기 전용\'은 보기와 다운로드를 허용합니다. \'동기화 허용\'은 Drive의 사본을 덮어쓸 수 있게 합니다 — 절대 삭제할 수는 없습니다.';

  @override
  String get shareConfirmButton => '공유하기';

  @override
  String shareSuccess(String email) {
    return '$email님과 공유했습니다.';
  }

  @override
  String get manageAccessTitle => '접근 권한이 있는 사람';

  @override
  String get manageAccessEmpty => '아직 다른 사람에게 접근 권한이 없습니다.';

  @override
  String get manageAccessRoleLabel => '접근 권한';

  @override
  String get manageAccessRevoke => '취소';

  @override
  String manageAccessRevokeConfirm(String email) {
    return '$email님의 접근 권한을 제거할까요? 이미 다운로드한 로컬 사본은 계속 그 사람의 것으로 남습니다.';
  }

  @override
  String get driveOnlyControlsYourCopy =>
      '공유는 Drive에 있는 회원님의 사본을 제어합니다. 누군가 다운로드하면 그 사본은 그 사람의 것이 됩니다.';

  @override
  String get driveOnlyControlsYourCopyCoop =>
      '동기화는 Drive에 있는 회원님의 사본을 제어합니다 — 허용한 사람이 덮어쓸 수는 있지만 절대 삭제할 수는 없습니다.';

  @override
  String get sharedWithMeTitle => '나와 공유됨';

  @override
  String get sharedWithMeEmpty => '아직 회원님과 공유된 것이 없습니다.';

  @override
  String get sharedWithMeAdd => '공유 세이브 추가';

  @override
  String sharedWithMeOwnedBy(String email) {
    return '$email님이 공유함';
  }

  @override
  String get sharedWithMeRoleSync => '동기화';

  @override
  String get sharedWithMeRoleRead => '읽기 전용';

  @override
  String get sharedWithMeSync => '동기화하기';

  @override
  String get sharedWithMeDownload => '다운로드';

  @override
  String get sharedWithMeRemove => '목록에서 제거';

  @override
  String sharedWithMeRemoveConfirm(String email) {
    return '$email님의 Drive와는 더 이상 동기화되지 않지만 언제든 다시 추가할 수 있습니다 — 공유 자체는 계속 유지됩니다. 로컬 사본은 일반적인 코옵 세이브로 그대로 남습니다.';
  }

  @override
  String sharedLeaveConfirm(Object email) {
    return '이 세이브에 대한 접근 권한을 완전히 잃게 됩니다. $email님이 다시 공유해 주지 않는 한 다시 추가할 수 없습니다. 로컬 사본은 일반적인 코옵 세이브로 그대로 남습니다.';
  }

  @override
  String get sharedManageButton => '관리';

  @override
  String get sharedManageDialogTitle => '공유 세이브 관리';

  @override
  String get sharedManageDialogHint => '여기서 공유 세이브에서 정말로 나갈 수 있습니다.';

  @override
  String get sharedLeaveButton => '공유에서 나가기';

  @override
  String sharedLeaveSuccess(Object email) {
    return '$email님의 공유에서 나갔습니다.';
  }

  @override
  String sharedWithMeSyncConfirm(String email) {
    return '$email님의 Drive 사본을 회원님의 로컬 세이브로 덮어쓸까요?';
  }

  @override
  String sharedAccessReadOnly(String email) {
    return '$email님이 회원님의 접근 권한을 읽기 전용으로 설정했습니다 — 보기와 다운로드는 가능하지만 그 사람의 Drive로 동기화할 수는 없습니다.';
  }

  @override
  String get sharedWithMeRevoked => '더 이상 접근 권한이 없습니다';

  @override
  String sharedRevokedDialogBody(String email, String farmName) {
    return '$email님이 $farmName에 대한 공유를 중단했습니다. 로컬 사본과 회원님의 Drive 사본은 그대로 남으며, 이제 \'내 세이브\'에 표시됩니다.';
  }

  @override
  String get sharedRevokedAccept => '확인';

  @override
  String get sharedSelfCleanupTitle => '기록이 수정되었습니다';

  @override
  String sharedSelfCleanupBody(String farmName) {
    return '$farmName이(가) 실수로 회원님과 공유된 것처럼 표시되었습니다 — 실제로는 회원님의 것입니다. 수정되어 이제 \'내 세이브\'에 있습니다.';
  }

  @override
  String get sharedWithMeUploadOwn => '내 Drive에 업로드';

  @override
  String get sharedDownloadOwn => '내 Drive에서 다운로드';

  @override
  String get sharedStatusOwnDriveAhead => '회원님의 Drive가 앞서 있습니다 — 다운로드하세요';

  @override
  String get sharedSyncBoth => '두 Drive 모두에 업로드';

  @override
  String get sharedSideMyDrive => '내 DRIVE';

  @override
  String sharedSideOwnerDrive(String email) {
    return '$email의 DRIVE';
  }

  @override
  String sharedSideDate(int day, int year) {
    return '$day일 · $year년';
  }

  @override
  String get sharedStatusSyncedNoOwnDrive => '소유자와 동기화됨 · 회원님의 Drive에 사본 없음';

  @override
  String get sharedStatusAheadNoOwnDrive => '앞서 있습니다 · 회원님의 Drive에 사본 없음';

  @override
  String sharedStatusOwnerAheadNoOwnDrive(String email) {
    return '$email님이 앞서 있습니다 · 회원님의 Drive에 사본 없음';
  }

  @override
  String get sharedStatusAllSynced => '동기화됨(로컬 + 두 Drive 모두)';

  @override
  String get sharedStatusAheadBoth => '두 Drive 모두에서 앞서 있습니다';

  @override
  String get sharedStatusMixed => '동기화가 어긋났습니다 — 각 Drive를 확인하세요';

  @override
  String get sharedStatusFullySynced => '완전히 동기화됨';

  @override
  String get sharedStatusSyncedOwn => '내 Drive 동기화됨';

  @override
  String get sharedStatusSyncedOwner => '공유 Drive 동기화됨';

  @override
  String get sharedStatusNotCloud => '이 기기에만 있음';

  @override
  String sharedStatusOwnerAhead(Object email) {
    return '$email의 Drive가 앞서 있습니다';
  }

  @override
  String get sharedStatusBothAhead => '두 Drive 모두 앞서 있습니다';

  @override
  String get sharedStatusLocalMissing => '이 기기에 없음';

  @override
  String sharedStatusOwnerUnavailable(Object email) {
    return '$email의 Drive를 확인할 수 없었습니다';
  }

  @override
  String get sharedStatusWorking => '동기화 중…';

  @override
  String get sharedSideUnavailable => '확인할 수 없음';

  @override
  String get sharedSyncChooseTitle => '어디에 동기화하시겠습니까?';

  @override
  String get sharedSyncChooseBody => '이 기기의 세이브로 업데이트할 클라우드 사본을 선택하세요.';

  @override
  String get sharedSyncTargetOwn => '내 Drive';

  @override
  String sharedSyncTargetOwner(Object email) {
    return '$email의 Drive';
  }

  @override
  String get sharedSyncTargetBoth => '두 Drive 모두';

  @override
  String get sharedDownloadChooseTitle => '어떤 사본을 다운로드하시겠습니까?';

  @override
  String get sharedDownloadChooseBody =>
      '앞서 있는 사본이 하나 이상 있습니다. 이 기기로 가져올 사본을 선택하세요.';

  @override
  String get sharedDownloadSourceOwn => '내 Drive에서';

  @override
  String sharedDownloadSourceOwner(Object email) {
    return '$email의 Drive에서';
  }

  @override
  String get sharedWithMePickerTitle => '공유 세이브 추가';

  @override
  String get sharedPickerEmptyHint => '다른 플레이어가 Drive에서 공유한 항목이 여기에 표시됩니다.';

  @override
  String get sharedPickerAddButton => '추가';

  @override
  String get sharedOriginBadge => '공유됨';

  @override
  String sharedOriginFrom(String email) {
    return '$email님으로부터';
  }

  @override
  String get swapBackupDialogTitle => '백업이 생성되었습니다';

  @override
  String get swapBackupDialogBody => '이전 버전은 zip으로 저장되었습니다. 어떻게 하시겠습니까?';

  @override
  String get swapBackupUpload => 'Drive에 업로드';

  @override
  String get swapBackupLocalOnly => '이 기기에만 보관';

  @override
  String get swapBackupDeleteNow => '지금 삭제';

  @override
  String get swapBackupUploadOk => '백업이 Drive에 업로드되었습니다.';

  @override
  String swapBackupUploadErr(String error) {
    return '백업을 업로드하지 못했습니다: $error';
  }

  @override
  String get swapBackupLocalOnlySnack => '백업이 이 기기에 저장되었습니다.';

  @override
  String get backupsAction => '백업';

  @override
  String backupsScreenTitle(String farmName) {
    return '$farmName의 백업';
  }

  @override
  String get backupsEmpty => '아직 백업이 없습니다.';

  @override
  String get backupsRestore => '복원';

  @override
  String get backupsRestoreConfirmTitle => '이 백업을 복원하시겠습니까?';

  @override
  String get backupsRestoreConfirmBody =>
      '현재 세이브가 이 이전 버전으로 덮어써집니다. 되돌릴 수 없습니다.';

  @override
  String get backupsDelete => '삭제';

  @override
  String get backupsDeleteConfirmTitle => '이 백업을 삭제하시겠습니까?';

  @override
  String get backupsDeleteConfirmBody =>
      '존재하는 모든 위치(이 기기, 업로드했다면 Drive)에서 삭제됩니다. 되돌릴 수 없습니다.';

  @override
  String get backupsRestoreOk => '백업이 복원되었습니다.';

  @override
  String get backupsRestoreManualTitle => '수동으로 복원';

  @override
  String get backupsRestoreManualBody =>
      '브리지 모드에서는 ValleySave가 게임 폴더에 자동으로 쓸 수 없습니다. 이 백업의 .zip 파일을 Stardew Valley의 Saves 폴더에 직접 압축 해제하거나, 설정에서 Root/Shizuku 모드로 전환하여 자동으로 복원하세요.';

  @override
  String backupsRestoreErr(String error) {
    return '백업을 복원하지 못했습니다: $error';
  }

  @override
  String backupsDeleteErr(String error) {
    return '백업을 삭제하지 못했습니다: $error';
  }

  @override
  String get backupsCreate => '로컬 백업 생성';

  @override
  String get backupsCreateLocalHint =>
      '백업은 먼저 이 기기에 생성됩니다. 이후 Drive에 업로드할 수 있습니다.';

  @override
  String get backupsCreateOk => '백업이 생성되었습니다.';

  @override
  String backupsCreateErr(String error) {
    return '백업을 생성하지 못했습니다: $error';
  }

  @override
  String get backupsDownload => '다운로드';

  @override
  String get backupsDownloadOk => '백업이 이 기기에 다운로드되었습니다.';

  @override
  String backupsDownloadErr(String error) {
    return '백업을 다운로드하지 못했습니다: $error';
  }

  @override
  String get backupsCopyOwn => '내 Drive에 복사';

  @override
  String get backupsUploadOwn => '내 Drive로';

  @override
  String get backupsUploadShared => '공유 Drive로';

  @override
  String get backupsUploadOk => '백업이 업로드되었습니다.';

  @override
  String backupsUploadErr(String error) {
    return '백업을 업로드하지 못했습니다: $error';
  }

  @override
  String get backupsLocationLocal => '이 기기';

  @override
  String get backupsLocationOwnDrive => '내 Drive';

  @override
  String get backupsLocationSharedDrive => '공유 Drive';

  @override
  String get backupsDeleteChooseBody =>
      '정확히 어디서 삭제할지 선택하세요. 이 백업이 존재하는 위치만 표시됩니다.';

  @override
  String get backupsDeleteLocalOnly => '이 기기에서만';

  @override
  String get backupsDeleteOwnOnly => '내 Drive에서만';

  @override
  String get backupsDeleteSharedOnly => '공유 Drive에서만';

  @override
  String get backupsDeleteAll => '모든 사본에서';

  @override
  String deleteUnifiedTitle(String farmName) {
    return '$farmName을(를) 삭제하시겠습니까?';
  }

  @override
  String get deleteChooseLocationBody =>
      '삭제할 위치를 선택하세요. 이 기기의 사본은 영구적으로 삭제됩니다. Drive의 사본은 휴지통으로 이동합니다(30일).';

  @override
  String deleteDriveContextTitle(String farmName) {
    return '$farmName을(를) Drive에서 삭제하시겠습니까?';
  }

  @override
  String get deleteDriveContextBody =>
      'Drive 사본은 휴지통으로 이동하며, 30일 동안 복원할 수 있습니다.';

  @override
  String get deleteDriveLocalKept => '이 기기의 사본은 변경 없이 그대로 유지됩니다.';

  @override
  String deleteLocalContextTitle(String farmName) {
    return '$farmName을(를) 이 기기에서 삭제하시겠습니까?';
  }

  @override
  String get deleteLocalContextBody => '이 기기의 사본이 영구적으로 삭제됩니다.';

  @override
  String deleteLocalDriveCurrent(String date) {
    return '회원님의 Drive 사본은 최신 상태이며($date) 계속 이용할 수 있습니다.';
  }

  @override
  String deleteLocalDriveAhead(String date) {
    return '회원님의 Drive 사본이 더 최신이며($date) 계속 이용할 수 있습니다.';
  }

  @override
  String deleteLocalDriveOlder(String driveDate, String localDate) {
    return '회원님의 Drive 사본은 더 오래되었으며($driveDate), 이 기기는 $localDate 기준입니다.';
  }

  @override
  String deleteLocalBackupAvailable(int count) {
    return '이전 사본이 필요할 경우를 대비해 로컬 백업 $count개를 이용할 수 있습니다.';
  }

  @override
  String get deleteLocalNoRecovery => '이 세이브를 복구할 수 있는 Drive 사본이나 로컬 백업이 없습니다.';

  @override
  String get deleteOptionLocalOnly => '이 기기에서만';

  @override
  String get deleteOptionDriveOnly => 'Drive에서만';

  @override
  String get deleteOptionBoth => '두 사본 모두에서(기기 + Drive)';

  @override
  String get viewPlayersHint => '플레이어 보기';

  @override
  String snackDeletedBoth(String saveName) {
    return '\"$saveName\"이(가) 이 기기에서 삭제되고 Drive 휴지통으로 이동되었습니다.';
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
  String get hiwConnectTitle => '계정 연결하기';

  @override
  String get hiwConnectDesc =>
      'ValleySave는 회원님의 Google 계정을 사용하여 세이브를 회원님 자신의 Drive에 있는 비공개 ValleySave 폴더에 저장합니다.';

  @override
  String get hiwConnectStepGoogle => 'Google\n계정';

  @override
  String get hiwConnectStepDrive => 'ValleySave 폴더\n생성됨';

  @override
  String get hiwConnectStepReady => '동기화\n준비 완료';

  @override
  String get hiwConnectTipOwnership =>
      'Drive에 있는 사본을 수정하거나 삭제할 수 있는 사람은 오직 회원님뿐입니다 — ValleySave는 자신의 폴더 안에서만 읽고 씁니다.';

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
  String get overwriteWhatChanges => '무엇이 변경되나요';

  @override
  String get overwriteTagOverwritten => '덮어쓰기됨';

  @override
  String get overwriteNewCopyTag => '신규';

  @override
  String overwriteDeltaPhrase(int days, String time) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: '$days일과 $time',
      zero: '$time',
    );
    return '$_temp0';
  }

  @override
  String overwriteVerdictAhead(String delta) {
    return '$delta 앞서 있습니다. 안전합니다.';
  }

  @override
  String get overwriteVerdictMoneySpent =>
      '💰 현재 소지금은 줄었지만 전체 진행 상황은 앞으로 나아가고 있습니다 — 아마 무언가에 사용하신 것 같습니다. 실제 손실이 아닙니다.';

  @override
  String overwriteVerdictNegligible(String delta) {
    return '차이가 미미합니다 ($delta). 두 사본 중 어느 쪽을 선택해도 괜찮습니다.';
  }

  @override
  String overwriteVerdictDanger(String delta, String target) {
    return '⚠️ $target에서 $delta만큼의 진행 상황을 잃게 됩니다. 계속하기 전에 다시 확인하세요.';
  }

  @override
  String get overwriteConfirmTitleUpload => '업로드를 확정하시겠습니까?';

  @override
  String get overwriteConfirmTitleDownload => '다운로드를 확정하시겠습니까?';

  @override
  String overwriteConfirmBody(String delta, String target) {
    return '$target에서 $delta만큼 잃게 됩니다. 이 작업은 되돌릴 수 없습니다.';
  }

  @override
  String get overwriteConfirmButtonUpload => '업로드 확정';

  @override
  String get overwriteConfirmButtonDownload => '다운로드 확정';

  @override
  String get overwriteDangerButtonUpload => '⚠️ 그래도 업로드';

  @override
  String get overwriteDangerButtonDownload => '⚠️ 그래도 다운로드';

  @override
  String overwriteIdenticalSummary(int count, String list) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '✓ $count개 동일',
    );
    return '$_temp0 — $list';
  }

  @override
  String overwriteUploadToOwner(String email) {
    return '$email의 Drive에 업로드';
  }

  @override
  String get overwriteUploadBoth => '두 Drive 모두에 업로드';

  @override
  String get overwriteConfirmTitleBoth => '두 건의 업로드를 확정하시겠습니까?';

  @override
  String overwriteConfirmBodyBoth(String delta, String targets) {
    return '$targets에서 $delta만큼 잃게 됩니다. 이 작업은 되돌릴 수 없습니다.';
  }

  @override
  String overwriteBothDestinationsLabel(String first, String second) {
    return '$first와(과) $second';
  }

  @override
  String get sharedTargetOwnDrive => '회원님의 Drive';

  @override
  String sharedStatusLocalAhead(String targets) {
    return '$targets에서 앞서 있습니다';
  }

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
  String get snackReplacePrepareFailed =>
      '세이브를 준비하지 못했습니다. 디스크에는 아무것도 변경되지 않았습니다';

  @override
  String get snackReplaceValidationFailed =>
      '다운로드한 세이브가 유효하지 않거나 불완전한 것 같습니다. 디스크에는 아무것도 변경되지 않았습니다';

  @override
  String get snackReplaceBackupFailed =>
      '백업을 생성하지 못했습니다. 디스크에는 아무것도 변경되지 않았습니다';

  @override
  String get snackReplaceSwapFailed => '교체에 실패했지만 원본 세이브는 백업에서 복원되었습니다';

  @override
  String get snackReplaceBusy => '이 세이브에 대한 작업이 이미 진행 중입니다';

  @override
  String get snackUploadIncomplete =>
      '로컬 세이브가 불완전하거나 손상되었습니다. 아무것도 업로드되지 않았습니다';

  @override
  String get snackDownloadIncomplete => '다운로드할 수 없습니다: Drive에 콘텐츠가 부족합니다';

  @override
  String get cardIncomplete => 'Drive에서 불완전함';

  @override
  String get autoRefreshTitle => '자동 새로고침';

  @override
  String get autoRefreshSubtitle => '30초마다 Drive의 변경 사항을 확인합니다';

  @override
  String autoSyncSnack(String farmName) {
    return '$farmName이(가) 자동으로 동기화되었습니다';
  }

  @override
  String get autoSyncTooltipOn => '자동 동기화 켜짐 — 안전할 때 자동으로 동기화됩니다';

  @override
  String get autoSyncTooltipOff => '자동 동기화 꺼짐 — 탭하여 켜기';

  @override
  String get autoSyncExplainTitle => '자동 동기화';

  @override
  String autoSyncExplainBody(String farmName) {
    return '지금부터 $farmName은(는) 안전할 때 확인을 요청하지 않고 자동으로 업로드되거나 다운로드됩니다.';
  }

  @override
  String get autoSyncExplainSafe => '명백히 앞서 있고 아무것도 잃지 않을 때만 작동합니다.';

  @override
  String get autoSyncExplainDanger =>
      '진행 상황을 잃을 위험이 있다면 절대 자동으로 작동하지 않습니다 — 지금처럼 늘 사용하던 대화상자로 회원님이 직접 결정합니다.';

  @override
  String get autoSyncExplainMissing =>
      '두 사본 중 하나가 없으면 자동으로 만들지 않습니다 — 첫 업로드나 다운로드는 회원님이 직접 결정합니다.';

  @override
  String get autoSyncExplainDontShowAgain => '이 알림 다시 표시하지 않기';

  @override
  String get autoSyncExplainConfirm => '확인했습니다, 켜기';

  @override
  String get hiwAutoSyncTitle => '스스로 동기화';

  @override
  String get hiwAutoSyncDesc =>
      '각 세이브 카드에는 AUTO 칩이 있습니다. 활성화하면 앱이 변경을 감지했을 때 해당 세이브가 자동으로 업로드되거나 다운로드됩니다 — 직접 열어서 확인할 필요가 없습니다.';

  @override
  String get hiwAutoSyncTipSafe => '명백히 앞서 있고 아무것도 잃지 않을 때만 스스로 동기화됩니다.';

  @override
  String get hiwAutoSyncTipDanger =>
      '진행 상황을 잃을 위험이 있다면 절대 스스로 하지 않습니다 — 지금처럼 늘 사용하던 비교 화면으로 계속 물어봅니다.';

  @override
  String get hiwAutoSyncTipPerSave =>
      '한 번에 전체가 아니라 세이브별로 개별 설정합니다 — 내 세이브에서는 켜고 공유 세이브에서는 꺼둘 수 있습니다.';

  @override
  String get hiwAutoSyncTipMissing =>
      '이미 존재하는 두 사본만 동기화된 상태로 유지합니다. 하나가 없으면 첫 업로드나 다운로드는 회원님이 직접 합니다.';

  @override
  String get hiwAutoSyncTipRefresh => '설정에서 변경 사항의 자동 확인을 완전히 끌 수 있습니다.';

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
  String get hiwCompatIncomplete =>
      '세이브에 \"Drive에서 불완전함\"이 표시되면 클라우드에 필요한 파일이 없다는 뜻입니다 — 다른 기기에서 다시 올바르게 업로드되기 전까지는 다운로드할 수 없습니다.';

  @override
  String get hiwShareTitle => '다른 사람과 공유';

  @override
  String get hiwShareDesc =>
      '이메일로 다른 플레이어와 세이브를 공유하세요. 상대방은 자신의 기기에서 \'나와 공유됨\'에서 볼 수 있습니다.';

  @override
  String get hiwShareStepYourSave => '회원님의\n세이브';

  @override
  String get hiwShareStepShare => '이메일로\n공유';

  @override
  String get hiwShareStepFriend => '나와\n공유됨';

  @override
  String get hiwShareTipRoles =>
      '역할은 두 가지입니다. \'읽기 전용\'은 보기와 다운로드만 허용합니다. \'동기화 허용\'은 회원님의 Drive 사본을 덮어쓸 수 있게 합니다. 어떤 경우에도 삭제는 할 수 없습니다 — 소유자인 회원님만 세이브를 삭제할 수 있습니다.';

  @override
  String get hiwShareTipDisconnect =>
      '\'연결 해제\'는 상대방 쪽의 동기화만 중단시킵니다 — 공유 관리에서 정말로 나가기 전까지는 공유 자체가 계속 유지됩니다.';

  @override
  String get hiwHostSwapTitle => '호스트 교체';

  @override
  String get hiwHostSwapDesc =>
      '어떤 팜핸드가 세이브의 호스트가 될지 변경하며, 그 자리에서 교체합니다 — 동일한 세이브 슬롯, 동일한 공유 권한이 유지됩니다.';

  @override
  String get hiwHostSwapStepPick => '팜핸드\n선택';

  @override
  String get hiwHostSwapStepConfirm => '확정';

  @override
  String get hiwHostSwapStepDone => '새 세이브\n생성됨';

  @override
  String get hiwHostSwapTipMove =>
      '집을 위한 공간을 확보하기 위해 농장의 일부 오브젝트가 재배치될 수 있습니다 — 아무것도 삭제되지 않습니다.';

  @override
  String get hiwHostSwapTipHouse =>
      '새 호스트의 집은 게임의 기본 큰 집처럼 보입니다 — 오두막 외관은 모드 없이는 지원되지 않습니다.';

  @override
  String get hiwBackupsTitle => '백업';

  @override
  String get hiwBackupsDesc =>
      '백업은 나중에 복원할 수 있는 세이브의 스냅샷입니다. 언제든 직접 만들거나, 세이브를 덮어쓰기 전(다운로드, 가져오기, 복원, 호스트 교체 시)에 ValleySave가 자동으로 만들도록 할 수 있습니다.';

  @override
  String get hiwBackupsStepSave => '회원님의\n세이브';

  @override
  String get hiwBackupsStepSnapshot => '백업\n생성됨';

  @override
  String get hiwBackupsStepStore => '로컬 및/또는\nDrive';

  @override
  String get hiwBackupsTipRestore =>
      '복원하면 현재 세이브가 이전 버전으로 덮어써집니다 — 되돌릴 수 없습니다.';

  @override
  String get hiwBackupsTipDelete =>
      '백업을 삭제하면 존재하는 모든 위치(이 기기, 업로드했다면 Drive)에서 삭제됩니다 — 되돌릴 수 없습니다.';

  @override
  String get hiwBackupsTipExport =>
      '세이브를 zip으로 내보내 원하는 곳에 보관하고, 나중에 다시 가져올 수도 있습니다 — 내장 백업의 수동적이고 이동 가능한 대안입니다.';

  @override
  String get hiwBackupsTipRetention =>
      'ValleySave는 각 세이브에 대해 가장 최근 자동 백업 5개를 보관합니다. 직접 만든 백업은 자동으로 삭제되지 않습니다.';

  @override
  String get hiwBackupsTipRestoreBridge =>
      '브리지 모드(루트/Shizuku 없는 Android)에서는 백업을 복원할 때 Stardew 폴더에 .zip을 직접 압축 해제하라는 요청을 받습니다 — 다운로드할 때와 동일합니다.';

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
  String get hiwLaunchTipLinux =>
      'Linux에서 게임이 자동으로 감지되지 않으면 설정 → 게임에서 실행 파일 경로를 설정하세요.';

  @override
  String get hiwSaveLocationsTitle => '세이브가 저장되는 위치';

  @override
  String get hiwSaveLocationsDesc =>
      'ValleySave는 각 플랫폼에서 게임의 세이브 폴더에 직접 읽고 씁니다.';

  @override
  String get hiwSaveLocationWindows =>
      'Windows: %AppData%\\StardewValley\\Saves';

  @override
  String get hiwSaveLocationAndroid =>
      'Android: 보호된 폴더이며 Shizuku 또는 Bridge를 통해 접근합니다';

  @override
  String get hiwSaveLocationLinux =>
      'Linux: ~/.config/StardewValley/Saves (Steam을 snap으로 설치한 경우 ~/snap/steam/common/.config/StardewValley/Saves)';

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

  @override
  String get makeHostDeleteOriginalTitle => '이 기기에서 원본 세이브 파일을 삭제할까요?';

  @override
  String get makeHostDeleteOriginalBody =>
      '새 세이브 파일이 준비되었습니다. 원본을 먼저 Drive에 백업하거나(나중에 다시 다운로드할 수 있습니다) 로컬 사본만 삭제할 수 있습니다.';

  @override
  String get makeHostDeleteOriginalNoBackupBody =>
      'Drive 연결 없음: 백업이 남지 않습니다. 이 기기의 로컬 사본만 삭제됩니다.';

  @override
  String get makeHostDeleteOriginalUploadBody =>
      '원본 세이브 파일이 먼저 백업으로 Drive에 업로드된 다음, 이 기기의 로컬 사본이 삭제됩니다.';

  @override
  String get makeHostDeleteWithoutUpload => '업로드 없이 삭제';

  @override
  String get makeHostUploadAndDelete => '업로드 후 삭제';
}
