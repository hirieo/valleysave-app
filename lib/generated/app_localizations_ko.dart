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
    return '저장 $saveName이(가) Google Drive 휴지통으로 이동합니다.';
  }

  @override
  String deleteFromDeviceMessage(Object saveName) {
    return '저장 $saveName이(가) 이 기기에서 영구적으로 삭제됩니다.';
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
  String get ok => '확인';

  @override
  String get yes => '예';

  @override
  String get no => '아니오';

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
  String get cardDriveAhead => 'Cloud ahead';

  @override
  String get cardLocalOnly => 'Local only';

  @override
  String get cardDriveOnly => 'Cloud only';

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
  String cardTimeMonthsAgo(int months, String plural) {
    return '$months month$plural ago';
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
}
