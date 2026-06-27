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
}
