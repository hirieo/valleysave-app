// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Japanese (`ja`).
class AppLocalizationsJa extends AppLocalizations {
  AppLocalizationsJa([String locale = 'ja']) : super(locale);

  @override
  String get appTitle => 'ValleySave';

  @override
  String get welcomeTitle => 'あなたの農場を失わないで、持ち歩きましょう。';

  @override
  String get connectGoogleDrive => 'Google Driveに接続';

  @override
  String get connecting => '接続中…';

  @override
  String get mySaves => 'マイセーブ';

  @override
  String get howItWorks => '使い方';

  @override
  String get settings => '設定';

  @override
  String get aboutSection => 'について';

  @override
  String get openSource => '利用可能なコード';

  @override
  String get nonCommercial => '非商用';

  @override
  String get freeForever => '永久無料';

  @override
  String get privacyTitle => 'プライバシーとデータの使用';

  @override
  String get privacyDescription =>
      'ValleySaveは、Stardew Valleyのセーブデータを自分のGoogle Driveアカウントと同期するアプリです。';

  @override
  String get whatDataTitle => '使用するデータ';

  @override
  String get whatDataDesc =>
      'ValleySaveは、コピーの作成、同期、または復元に必要なStardew Valleyのセーブファイルのみにアクセスします。';

  @override
  String get googleDriveTitle => 'Google Drive';

  @override
  String get googleDriveDesc =>
      'セーブはあなた自身のGoogle Driveアカウントにアップロードされます。ValleySaveはゲームを保存するために独自のサーバーを使用しません。';

  @override
  String get androidPermissionsTitle => 'Android上のアクセス許可';

  @override
  String get androidPermissionsDesc =>
      'ValleySaveは、セーブファイルにアクセスするためにストレージの許可またはShizukuなどのツールが必要な場合があります。';

  @override
  String get adsTitle => '広告';

  @override
  String get adsDesc => 'ValleySaveはGoogle AdMobを介して広告を表示する場合があります。';

  @override
  String get responsibilityTitle => '責任';

  @override
  String get responsibilityDesc => 'セーブファイルはあなたの責任です。';

  @override
  String get deleteDataTitle => 'データを削除';

  @override
  String get deleteDataDesc =>
      'Google DriveからValleySaveフォルダを手動で削除することで、同期されたコピーを削除できます。';

  @override
  String get sourceCodeTitle => 'ソースコードと連絡先';

  @override
  String get sourceCodeDesc =>
      'ValleySaveはPolyform Noncommercialライセンスの下で利用可能なコードを持つプロジェクトです。';

  @override
  String get upToDate => '最新';

  @override
  String get checkingUpdates => '確認中…';

  @override
  String get updateAvailable => 'アップデートが利用可能';

  @override
  String get application => 'アプリケーション';

  @override
  String version(Object version) {
    return 'バージョン $version';
  }

  @override
  String get checkForUpdates => 'アップデートを確認';

  @override
  String get shizukuRequired => 'Shizukuが必要';

  @override
  String get shizukuGuide => 'Shizukuセットアップガイド';

  @override
  String get activateShizuku => 'Shizukuを有効にしてゲーム内のセーブを書き込みます。';

  @override
  String deleteSaveTitle(Object saveName) {
    return '$saveNameを削除';
  }

  @override
  String get deleteSaveMessage => 'これによりこのデバイスからセーブが削除されます。続行しますか?';

  @override
  String get deleteFromDrive => 'Driveから削除';

  @override
  String confirmDelete(Object saveName) {
    return 'セーブ$saveNameはGoogle Driveのゴミ箱に移動されます。';
  }

  @override
  String deleteFromDeviceMessage(Object saveName) {
    return 'セーブ$saveNameはこのデバイスから完全に削除されます。';
  }

  @override
  String restoreSaveTitle(Object saveName) {
    return '$saveNameを復元';
  }

  @override
  String restoreSaveMessage(Object saveName) {
    return '$saveNameをこのデバイスにダウンロードしますか?';
  }

  @override
  String get restore => '復元';

  @override
  String get cancel => 'キャンセル';

  @override
  String get error => 'エラー';

  @override
  String get success => '成功';

  @override
  String get loading => '読み込み中…';

  @override
  String get disconnect => '切断';

  @override
  String get ok => 'OK';

  @override
  String get yes => 'はい';

  @override
  String get no => 'いいえ';

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
  String get hiwTipAlwaysShow => 'You\'ll always see what\'s on Drive...';

  @override
  String get hiwTipWithoutUpload => 'Without uploading, no other device...';

  @override
  String get hiwTipComparison =>
      'You\'ll see the comparison between local and Drive...';

  @override
  String get hiwTipDownloadOverwrite =>
      'Downloading overwrites your local save...';

  @override
  String get hiwTipSync => 'Always upload before switching devices...';

  @override
  String get hiwTipDeletion => 'Deleted saves go to Drive Trash...';

  @override
  String get hiwPrivacyLink => 'Privacy policy and usage';
}
