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
  String get welcomeHeroPre => 'あなたの農場を\n失わないで、';

  @override
  String get welcomeHeroAccent => '持ち歩きましょう。';

  @override
  String get welcomeHeroPost => '';

  @override
  String get welcomeSubtitle =>
      'Stardew Valleyのセーブデータをすべてのデバイスで同期します。あなたのデータはあなた自身のGoogle Driveに存在します。サーバーなし、サブスクリプションなし、あなたが管理します。';

  @override
  String get welcomeDriveConnected => 'Driveに接続';

  @override
  String get welcomeFooterTagline => '· 非商用 · 永久無料 ·';

  @override
  String updateVersionAvailable(String version) {
    return 'v$versionが利用可能';
  }

  @override
  String get sectionMode => 'モード';

  @override
  String get sectionSeason => 'シーズン';

  @override
  String get sectionLanguage => '言語';

  @override
  String get modeAutoTitle => '自動';

  @override
  String get modeAutoDesc => 'アクティブなセーブを追跡し、セーブがない場合は実際の場所を使用します。';

  @override
  String get modeSavesTitle => 'セーブ別';

  @override
  String get modeSavesDesc => '常に最新のセーブからシーズンを使用します。';

  @override
  String get modeGeoTitle => '場所別';

  @override
  String get modeGeoDesc => '常にあなたの場所の実際のシーズンを使用します。';

  @override
  String get modeFixedTitle => '固定シーズン';

  @override
  String get modeFixedDesc => '常に同じシーズンを表示します。';

  @override
  String get modeRandomTitle => 'ランダム';

  @override
  String get modeRandomDesc => 'アプリを開くたびに異なるシーズンを選択します。';

  @override
  String get seasonInitial => '初期';

  @override
  String get seasonSpring => '春';

  @override
  String get seasonSummer => '夏';

  @override
  String get seasonFall => '秋';

  @override
  String get seasonWinter => '冬';

  @override
  String get autoPriorityTitle => '優先順位';

  @override
  String get autoStep1Title => '最初の起動';

  @override
  String get autoStep1Desc => '初期状態を表示します。';

  @override
  String get autoStep2Title => 'アクティブなセーブ';

  @override
  String get autoStep2Desc => '最後に同期したセーブからシーズンを使用します。';

  @override
  String get autoStep3Title => '場所';

  @override
  String get autoStep3Desc => 'あなたの半球と地域の実際のシーズンを検出します。';

  @override
  String get autoStep4Title => 'デフォルト';

  @override
  String get autoStep4Desc => 'データがない場合は初期（ナイトモード）。';

  @override
  String get versionInstalled => 'インストール済みバージョン';

  @override
  String get updateNeverChecked => '確認なし';

  @override
  String get updateCheckedNow => '今確認しました';

  @override
  String get updateOutdatedDownload => '最新ではありません · ダウンロード';

  @override
  String get updateDownloading => 'アップデートをダウンロード中…';

  @override
  String get updateError => 'エラー — タップして再試行';

  @override
  String get disconnectTitle => 'Driveを切断しますか?';

  @override
  String get disconnectBody => 'Drive上のセーブは削除されません。いつでも再接続できます。';

  @override
  String get disconnectButton => 'Driveを切断';

  @override
  String get languageTileLabel => '言語';

  @override
  String get languageDialogTitle => 'アプリの言語';

  @override
  String get searchHint => '検索…';

  @override
  String get languageAuto => 'システム言語';

  @override
  String get languageAutoDesc => 'あなたのシステム言語を使用します';

  @override
  String get privacyPolicyTitle => 'プライバシーポリシー';

  @override
  String get privacyBeforeStartTitle => '開始する前に';

  @override
  String get privacyLastUpdated => '最後に更新: 2026年6月';

  @override
  String get privacyAccept => 'わかりました、続ける';

  @override
  String get cardSynced => '同期済み';

  @override
  String get cardLocalAhead => 'ローカルが最新';

  @override
  String get cardDriveAhead => 'Driveが最新';

  @override
  String get cardLocalOnly => 'ローカルのみ';

  @override
  String get cardDriveOnly => 'Driveのみ';

  @override
  String get cardTimeNow => '今';

  @override
  String cardTimeMinutesAgo(int minutes) {
    return '$minutes分前';
  }

  @override
  String cardTimeHoursAgo(int hours) {
    return '$hours時間前';
  }

  @override
  String cardTimeDaysAgo(int days) {
    return '$days日前';
  }

  @override
  String cardTimeMonthsAgo(int months) {
    return '$monthsヶ月前';
  }

  @override
  String get cardDetailLocalTitle => 'このデバイス上';

  @override
  String get cardDetailRemoteTitle => 'Drive上';

  @override
  String get cardDetailUpload => 'Driveにアップロード';

  @override
  String get cardDetailDownload => 'セーブをダウンロード';

  @override
  String get cardDetailDeleteLabel => '削除';

  @override
  String get cardDetailDeleteLocal => 'このデバイスから削除';

  @override
  String get cardDetailDeleteRemote => 'Driveから削除';

  @override
  String get cardCloseBarrier => '閉じる';

  @override
  String statDayYear(int day, int year) {
    return 'Day $day · Year $year';
  }

  @override
  String statDayOnly(int day) {
    return 'Day $day';
  }

  @override
  String get statPlaytime => 'プレイ時間';

  @override
  String get statMoney => 'コイン';

  @override
  String get statTotal => '合計';

  @override
  String get statMineUnexplored => '未探索';

  @override
  String get statMine => '鉱山';

  @override
  String get statMineLvl => '鉱山 · Lv';

  @override
  String get skillFarming => '農業';

  @override
  String get skillForaging => '採集';

  @override
  String get skillMining => '採掘';

  @override
  String get skillFishing => '釣り';

  @override
  String get skillCombat => '戦闘';

  @override
  String get cardLocalPresence => 'このデバイス上';

  @override
  String get cardRemotePresence => 'Drive上';

  @override
  String get cardNotPresent => 'ここにはありません';

  @override
  String get cardActionSynced => '同期済み';

  @override
  String get cardActionUpload => 'アップロード';

  @override
  String get cardActionDownload => 'ダウンロード';

  @override
  String get pillMonsters => 'モンスター';

  @override
  String get pillFriends => '友人';

  @override
  String get pillFaints => '気絶';

  @override
  String get pillSleeps => '睡眠';

  @override
  String get hiwTitle => '使い方';

  @override
  String get hiwSyncTitle => '同期の仕組み';

  @override
  String get hiwSyncIntro =>
      'ValleySaveはあなた自身のGoogle Driveを使ってデバイス間でセーブを移動します。仲介サーバーなし: ファイルはあなたのものです。';

  @override
  String get hiwSyncDevice => 'あなたの\nデバイス';

  @override
  String get hiwSyncCloud => 'Google\nDrive';

  @override
  String get hiwSyncOtherDevice => '他の\nデバイス';

  @override
  String get hiwUploadTitle => 'セーブをアップロード';

  @override
  String get hiwUploadDesc =>
      'アップロードするときは、ValleySaveは両方のセーブファイル（SaveGameInfo + ファームファイル）をDrive上のValleySave/フォルダにコピーします。';

  @override
  String get hiwDownloadTitle => 'セーブをダウンロード';

  @override
  String get hiwDownloadDesc =>
      'ダウンロードするときは、ValleySaveはDriveからファイルを取得してゲームフォルダに直接配置します。';

  @override
  String get hiwCompareTitle => '何を比較しているのか?';

  @override
  String get hiwCompareIntro =>
      'どのバージョンが新しいかを知るために、ValleySaveは総プレイ時間を使用します。唯一成長し続けるデータです。';

  @override
  String get hiwCompareNote => '確認する前に、次のことも表示されます。比較できます:';

  @override
  String get hiwCompareMoney => '現在のお金と獲得した総額';

  @override
  String get hiwCompareMine => '鉱山レベル';

  @override
  String get hiwCompareSkills => 'スキル（農業、採掘、戦闘など）';

  @override
  String get hiwCompareRelations => '友人、倒したモンスター、気絶回数';

  @override
  String get hiwCompareStamina => 'スタミナと健康';

  @override
  String get hiwCompareNotShown =>
      'これらは表示されません。どちらの方向にも変わる可能性があり、どのセーブが新しいかを示さないです。';

  @override
  String get hiwCompareNotShownExamples => '作物と動物のステータス、インベントリとアイテム、個々の関係';

  @override
  String get hiwCompareWarning =>
      'これらは表示されません。どちらの方向にも変わる可能性があり、どのセーブが新しいかを示さないです。';

  @override
  String get hiwConflictTitle => '同期しないでプレイする場合';

  @override
  String get hiwConflictDesc =>
      'モバイルとPCでセッション間の同期なしで進める場合、同じセーブの2つのバージョンが生まれます。';

  @override
  String get hiwConflictNoMerge =>
      'マージできません。ValleySaveは常に両方のバージョンを表示して、どちらを保持するかを選択できます。';

  @override
  String get hiwConflictMobile => 'モバイル';

  @override
  String get hiwConflictVersionA => 'バージョンA';

  @override
  String get hiwConflictPC => 'PC';

  @override
  String get hiwConflictVersionB => 'バージョンB';

  @override
  String get hiwDeleteTitle => 'セーブが削除された場合';

  @override
  String get hiwDeleteDesc =>
      'Driveからセーブを削除すると、すぐには消えません。Google Driveのゴミ箱にはいります。';

  @override
  String get hiwCompatTitle => 'プラットフォーム互換性';

  @override
  String get hiwCompatAndroidAccess => 'ANDROID上でのアクセス';

  @override
  String get hiwShizukuTitle => 'Shizukuを使用';

  @override
  String get hiwShizukuSubtitle =>
      '一度セットアップすれば。その後、ValleySaveは自動的に同期されます。二度と触れる必要はありません。';

  @override
  String get hiwShizukuBadge => '自動 · 推奨';

  @override
  String get hiwShizukuDone =>
      '✓ 完了。その後、セーブのダウンロードとアップロードは直接実行されます。コンピューターのようにです。';

  @override
  String get hiwShizukuNote =>
      'ペアリングは最初だけです。新しいShizukuバージョンは、電話を再起動した後に自動的に再アクティブ化されます。';

  @override
  String get hiwBridgeTitle => '手動ブリッジ';

  @override
  String get hiwBridgeSubtitle =>
      'Android 11と12でのみ動作します。追加のインストールは不要です。代わりに、同期するたびに自分のファイルアプリでセーブを手動でコピーします。';

  @override
  String get hiwBridgeBadge => '手動の代替案 · Android 11-12';

  @override
  String get hiwBridgeSaveFolder => 'Stardewのフォルダ';

  @override
  String get hiwBridgeValleySaveFolder => 'ValleySaveのフォルダ';

  @override
  String get hiwBridgeNote =>
      'システムのファイルアプリがそれらのフォルダにアクセスできるので動作します（ValleySaveはできません）。';

  @override
  String get hiwTipAlwaysShow => '常に上書きする前にDrive上の内容を確認し、比較できます。';

  @override
  String get hiwTipWithoutUpload => 'アップロードなしでは、他のデバイスには最新の進行状況が表示されません。';

  @override
  String get hiwTipComparison => '確認する前に、ローカルとDrive間の比較を見ることができます。';

  @override
  String get hiwTipDownloadOverwrite =>
      'ダウンロードはローカルセーブを上書きします。同期されていない進行状況は失われます。';

  @override
  String get hiwTipSync => 'デバイスを切り替える前に常にアップロードし、到着時にダウンロードしてください。';

  @override
  String get hiwTipDeletion => '永久に削除される前に、Drive Trashから復元するまで30日あります。';

  @override
  String get hiwPrivacyLink => 'プライバシーポリシーと使用方法';

  @override
  String get emptyNoSaves => 'セーブが見つかりません';

  @override
  String get emptyNoSavesHint => 'このデバイスで読み込むことができるローカルセーブがありません';

  @override
  String get bridgeTitle => 'セーブを持ってきてください';

  @override
  String get bridgeDesc =>
      'ローカルセーブを表示してアップロードするには、ファイルアプリでStardewフォルダからこのValleySaveフォルダにコピーしてください。次に、リフレッシュするためにスワイプします。';

  @override
  String get bridgeRefresh => 'リフレッシュ';

  @override
  String get bridgeChangeMode => '方法を変更';

  @override
  String get loaderLoading => '読み込み中';

  @override
  String get loaderConnecting => 'Driveに接続中…';

  @override
  String get chooserTitle => '接続方法を選択';

  @override
  String get chooserAutomatic => '自動 · 推奨';

  @override
  String get chooserManual => '手動の代替案 · Android 11-12';

  @override
  String get shizukuStepTitle => 'Shizukuをセットアップ';

  @override
  String get shizukuStep1Title => 'Shizukuをインストール';

  @override
  String get shizukuStep1Desc => 'Play StoreまたはGitHubからダウンロード';

  @override
  String get shizukuStep2Title => 'Shizukuを有効化';

  @override
  String get shizukuStep2Desc => 'アプリを実行して許可を付与';

  @override
  String get shizukuStep3Title => '許可を付与';

  @override
  String get shizukuStep3Desc => 'ValleySaveがアクセスをリクエストします';

  @override
  String get shizukuDone => '✓ 完了。その後、セーブのダウンロードとアップロードは直接機能します。コンピューターのようにです。';

  @override
  String get dlgDeleteDriveTitle => 'Driveから削除';

  @override
  String get dlgDeleteLocalTitle => 'このデバイスから削除';

  @override
  String get dlgDownloadTitle => 'セーブをダウンロード';

  @override
  String get dlgUploadTitle => 'セーブをアップロード';

  @override
  String get dlgUploadOverwrite => 'これはローカルセーブを上書きします';

  @override
  String get dlgGotIt => 'わかりました';

  @override
  String get dlgCopyDest => 'コピー先';

  @override
  String get previewColDayYear => '日/年';

  @override
  String get previewColTime => 'プレイ時間';

  @override
  String get previewColMoney => 'コイン';

  @override
  String get previewColTotal => '合計';

  @override
  String get previewColFarming => '農業';

  @override
  String get previewColForaging => '採集';

  @override
  String get previewColMining => '採掘';

  @override
  String get previewColFishing => '釣り';

  @override
  String get previewColCombat => '戦闘';

  @override
  String get previewColFriends => '友人';

  @override
  String get previewColMonsters => 'モンスター';

  @override
  String get previewColFaints => '気絶';

  @override
  String get previewColMine => '鉱山';

  @override
  String get previewColUnexplored => '未探索';

  @override
  String get previewLocalLabel => 'このデバイス上';

  @override
  String get previewDriveLabel => 'Drive上';

  @override
  String get previewFromDrive => 'DRIVE から';

  @override
  String get previewFromDevice => 'このデバイス から';

  @override
  String versionMismatch(String local, String drive) {
    return '異なるバージョン: ローカル $local · Drive $drive…';
  }

  @override
  String get snackPathCopied => 'パスがコピーされました';

  @override
  String get snackDestCopied => '宛先パスがコピーされました';

  @override
  String get snackDownloaded => 'セーブがゲームにダウンロードされました';

  @override
  String get snackSessionExpired => 'Driveセッションが期限切れ。再接続してください';

  @override
  String snackUploadError(String error) {
    return 'アップロードエラー: $error';
  }

  @override
  String snackDownloadError(String error) {
    return 'ダウンロードエラー: $error';
  }

  @override
  String snackDeleteError(String error) {
    return '削除エラー: $error';
  }

  @override
  String snackTrashed(String saveName) {
    return '\"$saveName\" がDriveのゴミ箱に移動されました。復元するまで30日あります。';
  }

  @override
  String snackDeletedLocal(String saveName) {
    return '\"$saveName\" がこのデバイスから削除されました';
  }

  @override
  String get snackShizukuRequired => 'Shizukuを有効にしてください…';

  @override
  String get snackWriteError =>
      'ゲームに書き込めませんでした。一部の電話機は Shizuku でも /Android/data をブロックします。';

  @override
  String get snackPlatformNotSupported =>
      'このプラットフォームはまだローカルセーブの書き込みをサポートしていません。';

  @override
  String get snackWirelessDebugHint => '手動で開く: 設定 → 開発者向けオプション → ワイヤレスデバッグ。';

  @override
  String get snackOpenShizukuApp => 'アプリドロワーからShizukuを開きます。';

  @override
  String get hiwTipDeletePermanent =>
      'ValleySaveは永久に削除されたセーブを回復できません。Driveファイルはあなたの責任です。';

  @override
  String get hiwCompatAchievements =>
      'SteamとGoogle Playの実績は転送されません。各プラットフォームは、リアルタイムで発生した実績のみを追跡します。セーブファイルは遡及的に実績をトリガーしません。';

  @override
  String get hiwCompatOverwrite =>
      '順序を設定せずに2つのデバイスから同期する場合、1つのセーブが他を上書きできます。常にダウンロード前にアップロードしてください。';

  @override
  String get hiwCompatVersions =>
      '異なるゲームバージョンのセーブは正しく読み込まれない場合があります。ValleySaveはダウンロード前にバージョンの不一致を検出した場合に警告します。';

  @override
  String get hiwCompatMods =>
      'SMAPI modはセーブに追加データを追加します。それらのmodがインストールされていないデバイスでmodded saveを読み込むと、ゲームがクラッシュするか、modデータが失われる可能性があります。\n\nAndroid上では、modを使用するためにSMAPIをインストールすることもできます。';

  @override
  String get hiwComparePrimary => '総プレイ時間';

  @override
  String get hiwCompareNoShown1 => '作物と動物のステータス';

  @override
  String get hiwCompareNoShown2 => 'インベントリとアイテム';

  @override
  String get hiwCompareNoShown3 => '個々の関係';

  @override
  String get hiwShizuku1 => 'Shizukuをインストール（Play StoreまたはGitHub APK）。';

  @override
  String get hiwShizuku2 => 'ワイヤレスデバッグで有効化します。ValleySaveがステップバイステップでガイドします。';

  @override
  String get hiwShizuku3 => 'プロンプトされたときにValleySaveに許可を付与します。';

  @override
  String get hiwBridge1 =>
      'Driveからダウンロード: ValleySaveはセーブをそのフォルダに残します。ファイルでStardewのフォルダにコピーします。';

  @override
  String get hiwBridge2 =>
      'Driveにアップロード: StardewのフォルダからセーブをValleySaveのフォルダにコピーします。ValleySaveはそれを検出してアップロードします。';

  @override
  String get snackShizukuBattery => '設定 → アプリ → Shizuku → バッテリー → 制限なし。';

  @override
  String snackDriveError(String error) {
    return 'Drive: $error';
  }

  @override
  String get dlgDeleteLocalWarning =>
      '⚠️ Driveにアップロードしていない場合は、永久に失われます。回復はできません。';

  @override
  String get dlgDelete => '削除';

  @override
  String get dlgDownloadButton => 'ダウンロード';

  @override
  String get dlgUploadButton => 'アップロード';

  @override
  String get dlgBridgeCopyTitle => 'セーブをゲームにコピー';

  @override
  String dlgBridgeCopyDesc(String saveName) {
    return 'セーブの準備ができました。ファイルアプリで、\"$saveName\" フォルダをコピーしてStardewフォルダに貼り付けます。';
  }

  @override
  String get labelFrom => 'から';

  @override
  String get labelTo => 'へ';

  @override
  String dlgDownloadNewDesc(String saveName, int day, String playtime) {
    return '\"$saveName\" (Day $day, $playtime) がこのデバイスにコピーされます。';
  }

  @override
  String dlgDownloadOverwrite(String saveName) {
    return 'これはローカルの \"$saveName\" を上書きします。';
  }

  @override
  String dlgUploadNewDesc(String saveName, int day, String playtime) {
    return '\"$saveName\" (Day $day, $playtime) がDriveにアップロードされます。';
  }

  @override
  String dlgUploadOverwriteDrive(String saveName) {
    return 'これはDriveの \"$saveName\" を上書きします。';
  }

  @override
  String get pathLabelFromStardew => 'から（Stardew）';

  @override
  String get pathLabelToValleySave => 'へ（ValleySave）';

  @override
  String get chooserDesc =>
      'Androidはゲームフォルダを保護します。ValleySaveにアクセス権を付与する方法を選択してください。いつでも変更できます。';

  @override
  String get chooserShizukuDesc =>
      '一度設定。その後、ValleySaveは自動的に同期されます。何も触れる必要がありません。Android 13以降の唯一の信頼できる方法。';

  @override
  String get chooserManualBadge => 'Android 11-12のみ';

  @override
  String get chooserBridgeDesc =>
      'ファイルアプリでセーブをコピーします。追加のインストールはありません。Android 11と12のみ。';

  @override
  String get shizukuGateSubtitle => '一度設定 · 最初だけ';

  @override
  String get shizukuStatusLabel => 'Shizukuがアクティブ';

  @override
  String get shizukuStatusRunning => '接続済みで待機中。';

  @override
  String get shizukuStatusNotDetected => 'まだ検出されていません。';

  @override
  String get shizukuPermLabel => '許可が付与されました';

  @override
  String get shizukuPermGranted => 'ValleySaveは既にアクセスしています。';

  @override
  String get shizukuPermNotGranted => 'ValleySaveを認可する必要があります。';

  @override
  String get shizukuGrant => '付与';

  @override
  String get shizukuGuideHeader => 'ステップバイステップガイド';

  @override
  String get shizukuStep1DescFull =>
      '無料。Google Playがあなたの電話にそれをブロックする場合は、公式のGitHub APKを使用してください。';

  @override
  String get btnPlayStore => 'Play Store';

  @override
  String get btnApkGithub => 'APK GitHub';

  @override
  String get shizukuStep2TitleFull => '開発者向けオプションを有効にする';

  @override
  String get shizukuStep2DescFull =>
      '設定 → 電話について → ソフトウェア情報 → 「ビルド番号」を7回タップしてください。';

  @override
  String get shizukuStep3TitleFull => 'ワイヤレスデバッグを有効にする';

  @override
  String get shizukuStep3DescFull =>
      'ボタンはそこに移動してハイライトします。有効にします（ON）。次に、「ペアリングコードを使用してデバイスをペアリング」をタップします。画面に6桁のコードが表示されます。';

  @override
  String get btnOpenAndHighlight => '開く＆ハイライト';

  @override
  String get shizukuStep4Title => 'ペアリングとShizukuをSTART';

  @override
  String get shizukuStep4Desc =>
      'Shizukuを開く → 「ワイヤレスデバッグ経由で開始」 → 「ペアリングコードを使用してペアリング」。Shizukuは待機中という通知を送信します。ワイヤレスデバッグ画面から6桁のコードを入力してください。ペアリング後、STARTを押します。その最後のタップがないとShizukuはアクティブになりません。';

  @override
  String get btnOpenShizuku => 'Shizukuを開く';

  @override
  String get shizukuStep5Title => 'Shizukuのバッテリーを制限なしに設定';

  @override
  String get shizukuStep5Desc =>
      'アプリ情報を開く → バッテリー → 制限なし。そうしないと、システムはShizukuをバックグラウンドで閉じて、再度Startを押す必要があります。';

  @override
  String get btnShizukuAppInfo => 'Shizukuアプリ情報';

  @override
  String get shizukuStep6DescActive => 'Shizukuがアクティブです。ボタンをタップして認可します。';

  @override
  String get shizukuStep6DescWaiting => 'Shizukuがアクティブになった後（ステップ4）に利用可能になります。';

  @override
  String get btnGrantPermission => '許可を付与';

  @override
  String get btnCheckShizuku => '完了 · 確認';

  @override
  String get statusDone => '完了';

  @override
  String get statusPending => '保留中';

  @override
  String get latestBadge => '· 最新のセーブ ·';

  @override
  String saveDateLabel(String season, int year) {
    return '$season · Year $year';
  }

  @override
  String get petCat => '猫';

  @override
  String get petDog => '犬';

  @override
  String get houseBasic => '基本的な家';

  @override
  String get houseKitchen => 'キッチン付き';

  @override
  String get houseBedroom => '寝室付き';

  @override
  String get houseCellar => '地下室付き';

  @override
  String houseLevelN(int level) {
    return 'Lv. $level';
  }
}
