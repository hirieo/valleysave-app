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
  String get updateNeedsPermission =>
      'ValleySaveの「不明なアプリのインストール」を有効にしてから、もう一度「更新」をタップしてください';

  @override
  String get disconnectTitle => 'Driveを切断しますか?';

  @override
  String disconnectBody(String email) {
    return 'Drive上のセーブは削除されません。いつでも再接続できます。';
  }

  @override
  String get disconnectButton => 'Driveを切断';

  @override
  String disconnectButtonEmail(String email) {
    return '$emailから切断';
  }

  @override
  String get connectedAsPrefix => '接続アカウント';

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
  String get exportAction => 'エクスポート';

  @override
  String get exportSuccess => 'セーブをエクスポートしました。';

  @override
  String exportError(String error) {
    return 'セーブをエクスポートできませんでした: $error';
  }

  @override
  String get importAction => 'セーブをインポート';

  @override
  String importSuccess(String playerName) {
    return '$playerNameのセーブをインポートしました。';
  }

  @override
  String get importErrInvalidZip => 'このファイルは有効なzipではありません。';

  @override
  String get importErrUnsafePath => 'このファイルは安全でない構造のため拒否されました。';

  @override
  String get importErrTooLarge => 'このファイルは大きすぎてインポートできません。';

  @override
  String get importErrNotASave => 'このファイルには認識可能なセーブが含まれていません。';

  @override
  String get importErrWrite => 'インポートしたセーブを書き込めませんでした（ディスク／権限）。';

  @override
  String get importErrBackupFailed => 'バックアップの作成に失敗しました。何もインポートされませんでした。';

  @override
  String get importConflictTitle => 'この名前のセーブはすでに存在します';

  @override
  String get importConflictBody => 'インポートすると既存のローカルコピーが置き換えられます。取り消せません。';

  @override
  String get importConflictConfirm => '上書き';

  @override
  String get shareAction => '共有';

  @override
  String get shareUploadFirstCta => '先にアップロード';

  @override
  String get shareDialogTitle => 'セーブを共有';

  @override
  String get shareEmailPlaceholder => 'name@example.com';

  @override
  String get shareInfoNote =>
      '共有すると閲覧とダウンロードのアクセス権が付与されます。Drive上のコピーを編集・削除できるのはあなただけです。';

  @override
  String get shareRoleReader => '閲覧のみ';

  @override
  String get shareRoleWriter => '同期を許可';

  @override
  String get shareInfoNoteCoop =>
      '「閲覧のみ」は表示とダウンロードを許可します。「同期を許可」はDrive上のコピーの上書きを許可します — 削除することは決してできません。';

  @override
  String get shareConfirmButton => '共有する';

  @override
  String shareSuccess(String email) {
    return '$emailと共有しました。';
  }

  @override
  String get manageAccessTitle => 'アクセス権を持つ人';

  @override
  String get manageAccessEmpty => 'まだ他に誰もアクセス権を持っていません。';

  @override
  String get manageAccessRoleLabel => 'アクセス';

  @override
  String get manageAccessRevoke => '取り消す';

  @override
  String manageAccessRevokeConfirm(String email) {
    return '$emailのアクセスを削除しますか? すでにダウンロード済みのローカルコピーは引き続き相手のものです。';
  }

  @override
  String get driveOnlyControlsYourCopy =>
      '共有はDrive上のあなたのコピーを制御します。誰かがそれをダウンロードすると、そのコピーはその人のものになります。';

  @override
  String get driveOnlyControlsYourCopyCoop =>
      '同期はDrive上のあなたのコピーを制御します — 許可した相手が上書きすることはできますが、削除することは決してできません。';

  @override
  String get sharedWithMeTitle => '共有されたセーブ';

  @override
  String get sharedWithMeEmpty => 'まだ何も共有されていません。';

  @override
  String get sharedWithMeAdd => '共有セーブを追加';

  @override
  String sharedWithMeOwnedBy(String email) {
    return '$emailが共有';
  }

  @override
  String get sharedWithMeRoleSync => '同期';

  @override
  String get sharedWithMeRoleRead => '閲覧のみ';

  @override
  String get sharedWithMeSync => '同期する';

  @override
  String get sharedWithMeDownload => 'ダウンロード';

  @override
  String get sharedWithMeRemove => 'リストから削除';

  @override
  String sharedWithMeRemoveConfirm(String email) {
    return '$emailのDriveとの同期は行われなくなりますが、いつでも再度追加できます — 共有自体は継続されます。ローカルのコピーは通常のコープセーブとしてそのまま残ります。';
  }

  @override
  String sharedLeaveConfirm(Object email) {
    return 'このセーブへのアクセスを完全に失います。$emailが再度共有してくれない限り、再び追加することはできません。ローカルのコピーは通常のコープセーブとしてそのまま残ります。';
  }

  @override
  String get sharedManageButton => '管理';

  @override
  String get sharedManageDialogTitle => '共有セーブを管理';

  @override
  String get sharedManageDialogHint => 'ここから共有セーブを完全に退出できます。';

  @override
  String get sharedLeaveButton => '共有から退出';

  @override
  String sharedLeaveSuccess(Object email) {
    return '$emailの共有から退出しました。';
  }

  @override
  String sharedWithMeSyncConfirm(String email) {
    return 'Drive上の$emailのコピーをローカルのセーブで上書きしますか?';
  }

  @override
  String sharedAccessReadOnly(String email) {
    return '$emailによってあなたのアクセスは閲覧のみに設定されました — 表示とダウンロードはできますが、相手のDriveへの同期はできません。';
  }

  @override
  String get sharedWithMeRevoked => 'アクセス権がなくなりました';

  @override
  String sharedRevokedDialogBody(String email, String farmName) {
    return '$emailが$farmNameの共有を停止しました。ローカルおよびあなたのDrive上のコピーはそのまま残り、今後は「マイセーブ」に表示されます。';
  }

  @override
  String get sharedRevokedAccept => 'OK';

  @override
  String get sharedSelfCleanupTitle => '記録を修正しました';

  @override
  String sharedSelfCleanupBody(String farmName) {
    return '$farmNameが誤ってあなたと共有されているように表示されていました — 実際にはあなたのものです。修正済みで、現在は「マイセーブ」に表示されています。';
  }

  @override
  String get sharedWithMeUploadOwn => '自分のDriveにアップロード';

  @override
  String get sharedDownloadOwn => '自分のDriveからダウンロード';

  @override
  String get sharedStatusOwnDriveAhead => 'あなたのDriveが先に進んでいます — ダウンロードしましょう';

  @override
  String get sharedSyncBoth => '両方のDriveにアップロード';

  @override
  String get sharedSideMyDrive => '自分のDRIVE';

  @override
  String sharedSideOwnerDrive(String email) {
    return '$emailのDRIVE';
  }

  @override
  String sharedSideDate(int day, int year) {
    return 'Day $day · Year $year';
  }

  @override
  String get sharedStatusSyncedNoOwnDrive => '所有者と同期済み · あなたのDriveにコピーなし';

  @override
  String get sharedStatusAheadNoOwnDrive => '先に進んでいます · あなたのDriveにコピーなし';

  @override
  String sharedStatusOwnerAheadNoOwnDrive(String email) {
    return '$emailが先に進んでいます · あなたのDriveにコピーなし';
  }

  @override
  String get sharedStatusAllSynced => '同期済み（端末 + 両方のDrive）';

  @override
  String get sharedStatusAheadBoth => '両方のDriveで先に進んでいます';

  @override
  String get sharedStatusMixed => '同期がずれています — 各Driveを確認してください';

  @override
  String get sharedStatusFullySynced => '完全に同期済み';

  @override
  String get sharedStatusSyncedOwn => '自分のDriveと同期済み';

  @override
  String get sharedStatusSyncedOwner => '共有先と同期済み';

  @override
  String get sharedStatusNotCloud => 'この端末のみ';

  @override
  String sharedStatusOwnerAhead(Object email) {
    return '$emailのDriveが先に進んでいます';
  }

  @override
  String get sharedStatusBothAhead => '両方のDriveが先に進んでいます';

  @override
  String get sharedStatusLocalMissing => 'この端末にはありません';

  @override
  String sharedStatusOwnerUnavailable(Object email) {
    return '$emailのDriveを確認できませんでした';
  }

  @override
  String get sharedStatusWorking => '同期中…';

  @override
  String get sharedSideUnavailable => '確認できませんでした';

  @override
  String get sharedSyncChooseTitle => 'どこに同期しますか?';

  @override
  String get sharedSyncChooseBody => 'この端末のセーブでどのクラウドコピーを更新するか選んでください。';

  @override
  String get sharedSyncTargetOwn => '自分のDrive';

  @override
  String sharedSyncTargetOwner(Object email) {
    return '$emailのDrive';
  }

  @override
  String get sharedSyncTargetBoth => '両方のDrive';

  @override
  String get sharedDownloadChooseTitle => 'どのコピーをダウンロードしますか?';

  @override
  String get sharedDownloadChooseBody =>
      '先に進んでいるコピーが複数あります。この端末に取り込むものを選んでください。';

  @override
  String get sharedDownloadSourceOwn => '自分のDriveから';

  @override
  String sharedDownloadSourceOwner(Object email) {
    return '$emailのDriveから';
  }

  @override
  String get sharedWithMePickerTitle => '共有セーブを追加';

  @override
  String get sharedPickerEmptyHint => '他のプレイヤーがDriveから共有した内容がここに表示されます。';

  @override
  String get sharedPickerAddButton => '追加';

  @override
  String get sharedOriginBadge => '共有';

  @override
  String sharedOriginFrom(String email) {
    return '$emailから';
  }

  @override
  String get swapBackupDialogTitle => 'バックアップを作成しました';

  @override
  String get swapBackupDialogBody => '以前のバージョンはzipとして保存されました。どうしますか?';

  @override
  String get swapBackupUpload => 'Driveにアップロード';

  @override
  String get swapBackupLocalOnly => 'この端末に保存しておく';

  @override
  String get swapBackupDeleteNow => '今すぐ削除';

  @override
  String get swapBackupUploadOk => 'バックアップをDriveにアップロードしました。';

  @override
  String swapBackupUploadErr(String error) {
    return 'バックアップをアップロードできませんでした: $error';
  }

  @override
  String get swapBackupLocalOnlySnack => 'バックアップをこの端末に保存しました。';

  @override
  String get backupsAction => 'バックアップ';

  @override
  String backupsScreenTitle(String farmName) {
    return '$farmNameのバックアップ';
  }

  @override
  String get backupsEmpty => 'まだバックアップがありません。';

  @override
  String get backupsRestore => '復元';

  @override
  String get backupsRestoreConfirmTitle => 'このバックアップを復元しますか?';

  @override
  String get backupsRestoreConfirmBody => '現在のセーブがこの過去のバージョンで上書きされます。取り消せません。';

  @override
  String get backupsDelete => '削除';

  @override
  String get backupsDeleteConfirmTitle => 'このバックアップを削除しますか?';

  @override
  String get backupsDeleteConfirmBody =>
      '存在するすべての場所（この端末、アップロード済みの場合はDrive）から削除されます。取り消せません。';

  @override
  String get backupsRestoreOk => 'バックアップを復元しました。';

  @override
  String get backupsRestoreManualTitle => '手動で復元';

  @override
  String get backupsRestoreManualBody =>
      'ブリッジモードでは、ValleySaveはゲームフォルダに自動で書き込むことができません。このバックアップの.zipをStardew ValleyのSavesフォルダに自分で展開するか、設定でRoot/Shizukuモードに切り替えて自動復元してください。';

  @override
  String backupsRestoreErr(String error) {
    return 'バックアップを復元できませんでした: $error';
  }

  @override
  String backupsDeleteErr(String error) {
    return 'バックアップを削除できませんでした: $error';
  }

  @override
  String get backupsCreate => 'ローカルバックアップを作成';

  @override
  String get backupsCreateLocalHint =>
      'バックアップはまずこの端末に作成されます。その後Driveにアップロードできます。';

  @override
  String get backupsCreateOk => 'バックアップを作成しました。';

  @override
  String backupsCreateErr(String error) {
    return 'バックアップを作成できませんでした: $error';
  }

  @override
  String get backupsDownload => 'ダウンロード';

  @override
  String get backupsDownloadOk => 'バックアップをこの端末にダウンロードしました。';

  @override
  String backupsDownloadErr(String error) {
    return 'バックアップをダウンロードできませんでした: $error';
  }

  @override
  String get backupsCopyOwn => '自分のDriveにコピー';

  @override
  String get backupsUploadOwn => '自分のDriveへ';

  @override
  String get backupsUploadShared => '共有Driveへ';

  @override
  String get backupsUploadOk => 'バックアップをアップロードしました。';

  @override
  String backupsUploadErr(String error) {
    return 'バックアップをアップロードできませんでした: $error';
  }

  @override
  String get backupsLocationLocal => 'この端末';

  @override
  String get backupsLocationOwnDrive => '自分のDrive';

  @override
  String get backupsLocationSharedDrive => '共有Drive';

  @override
  String get backupsDeleteChooseBody =>
      '削除する場所を正確に選んでください。このバックアップが存在する場所のみ表示されます。';

  @override
  String get backupsDeleteLocalOnly => 'この端末からのみ';

  @override
  String get backupsDeleteOwnOnly => '自分のDriveからのみ';

  @override
  String get backupsDeleteSharedOnly => '共有Driveからのみ';

  @override
  String get backupsDeleteAll => 'すべてのコピーから';

  @override
  String deleteUnifiedTitle(String farmName) {
    return '$farmNameを削除しますか?';
  }

  @override
  String get deleteChooseLocationBody =>
      '削除元を選んでください。この端末のコピーは完全に削除されます。Driveのコピーはゴミ箱に移動します（30日間）。';

  @override
  String deleteDriveContextTitle(String farmName) {
    return '$farmNameをDriveから削除しますか?';
  }

  @override
  String get deleteDriveContextBody => 'Driveのコピーはゴミ箱に移動し、30日間は復元できます。';

  @override
  String get deleteDriveLocalKept => 'この端末のコピーは変更されずそのまま残ります。';

  @override
  String deleteLocalContextTitle(String farmName) {
    return '$farmNameをこの端末から削除しますか?';
  }

  @override
  String get deleteLocalContextBody => 'この端末のコピーは完全に削除されます。';

  @override
  String deleteLocalDriveCurrent(String date) {
    return 'あなたのDriveのコピーは最新です（$date）。引き続き利用できます。';
  }

  @override
  String deleteLocalDriveAhead(String date) {
    return 'あなたのDriveのコピーはより新しく（$date）、引き続き利用できます。';
  }

  @override
  String deleteLocalDriveOlder(String driveDate, String localDate) {
    return 'あなたのDriveのコピーは古く（$driveDate）、この端末は$localDate時点です。';
  }

  @override
  String deleteLocalBackupAvailable(int count) {
    return '以前のコピーが必要な場合に備えて、$count件のローカルバックアップが利用可能です。';
  }

  @override
  String get deleteLocalNoRecovery => 'このセーブを復元できるDriveのコピーもローカルのバックアップもありません。';

  @override
  String get deleteOptionLocalOnly => 'この端末からのみ';

  @override
  String get deleteOptionDriveOnly => '自分のDriveからのみ';

  @override
  String get deleteOptionBoth => '両方のコピーから（端末 + Drive）';

  @override
  String get viewPlayersHint => 'プレイヤーを表示';

  @override
  String snackDeletedBoth(String saveName) {
    return '「$saveName」をこの端末から削除し、Driveのゴミ箱に移動しました。';
  }

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
  String get hiwConnectTitle => 'アカウントを接続';

  @override
  String get hiwConnectDesc =>
      'ValleySaveはあなたのGoogleアカウントを使い、あなた自身のDrive内にあるValleySave専用の非公開フォルダにセーブを保存します。';

  @override
  String get hiwConnectStepGoogle => 'Google\nアカウント';

  @override
  String get hiwConnectStepDrive => 'ValleySaveフォルダ\n作成完了';

  @override
  String get hiwConnectStepReady => '同期の\n準備完了';

  @override
  String get hiwConnectTipOwnership =>
      'Drive上のコピーを編集・削除できるのはあなただけです。ValleySaveは自身のフォルダ内でのみ読み書きを行います。';

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
  String get overwriteWhatChanges => '変更される内容';

  @override
  String get overwriteTagOverwritten => '上書きされます';

  @override
  String get overwriteNewCopyTag => '新規';

  @override
  String overwriteDeltaPhrase(int days, String time) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: '$days日と$time',
      zero: '$time',
    );
    return '$_temp0';
  }

  @override
  String overwriteVerdictAhead(String delta) {
    return '$delta進んでいます。安全です。';
  }

  @override
  String get overwriteVerdictMoneySpent =>
      '💰 所持金は減っていますが、全体の進行状況は進んでいます — 何かに使った可能性が高いです。実質的な損失ではありません。';

  @override
  String overwriteVerdictNegligible(String delta) {
    return '差はごくわずかです（$delta）。どちらのコピーでも問題ありません。';
  }

  @override
  String overwriteVerdictDanger(String delta, String target) {
    return '⚠️ $targetの進行状況を$delta失うことになります。続行する前によく確認してください。';
  }

  @override
  String get overwriteConfirmTitleUpload => 'アップロードを確定しますか?';

  @override
  String get overwriteConfirmTitleDownload => 'ダウンロードを確定しますか?';

  @override
  String overwriteConfirmBody(String delta, String target) {
    return '$targetで$deltaを失うことになります。この操作は取り消せません。';
  }

  @override
  String get overwriteConfirmButtonUpload => 'アップロードを確定';

  @override
  String get overwriteConfirmButtonDownload => 'ダウンロードを確定';

  @override
  String get overwriteDangerButtonUpload => '⚠️ それでもアップロードする';

  @override
  String get overwriteDangerButtonDownload => '⚠️ それでもダウンロードする';

  @override
  String overwriteIdenticalSummary(int count, String list) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '✓ $count件が同一',
    );
    return '$_temp0 — $list';
  }

  @override
  String overwriteUploadToOwner(String email) {
    return '$emailのDriveにアップロード';
  }

  @override
  String get overwriteUploadBoth => '両方のDriveにアップロード';

  @override
  String get overwriteConfirmTitleBoth => '2件のアップロードを確定しますか?';

  @override
  String overwriteConfirmBodyBoth(String delta, String targets) {
    return '$targetsで$deltaを失うことになります。この操作は取り消せません。';
  }

  @override
  String overwriteBothDestinationsLabel(String first, String second) {
    return '$firstと$second';
  }

  @override
  String get sharedTargetOwnDrive => 'あなたのDrive';

  @override
  String sharedStatusLocalAhead(String targets) {
    return '$targetsで先に進んでいます';
  }

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
  String get snackReplacePrepareFailed => 'セーブの準備に失敗しました。ディスク上には何も変更されていません';

  @override
  String get snackReplaceValidationFailed =>
      'ダウンロードしたセーブは無効か不完全なようです。ディスク上には何も変更されていません';

  @override
  String get snackReplaceBackupFailed => 'バックアップの作成に失敗しました。ディスク上には何も変更されていません';

  @override
  String get snackReplaceSwapFailed => '入れ替えに失敗しましたが、元のセーブはバックアップから復元されました';

  @override
  String get snackReplaceBusy => 'このセーブに対する処理がすでに進行中です';

  @override
  String get snackUploadIncomplete => 'ローカルのセーブが不完全か破損しています。何もアップロードされませんでした';

  @override
  String get snackDownloadIncomplete => 'ダウンロードできません: Drive上のコンテンツが不足しています';

  @override
  String get cardIncomplete => 'Drive上で不完全';

  @override
  String get autoRefreshTitle => '自動更新';

  @override
  String get autoRefreshSubtitle => '30秒ごとにDriveの変更を確認します';

  @override
  String autoSyncSnack(String farmName) {
    return '$farmNameを自動的に同期しました';
  }

  @override
  String get autoSyncTooltipOn => '自動同期オン — 安全なときに自動で同期します';

  @override
  String get autoSyncTooltipOff => '自動同期オフ — タップして有効にします';

  @override
  String get autoSyncExplainTitle => '自動同期';

  @override
  String autoSyncExplainBody(String farmName) {
    return 'これ以降、$farmNameは安全な場合に確認なしで自動的にアップロードまたはダウンロードされます。';
  }

  @override
  String get autoSyncExplainSafe => '明らかに先に進んでいて、何も失われない場合にのみ動作します。';

  @override
  String get autoSyncExplainDanger =>
      '進行状況を失うリスクがある場合は、決して自動では動作しません。これまで通り、あなた自身がいつものダイアログで判断します。';

  @override
  String get autoSyncExplainMissing =>
      'どちらか一方のコピーが存在しない場合、自動では作成されません。最初のアップロードまたはダウンロードはあなたが決めます。';

  @override
  String get autoSyncExplainDontShowAgain => 'この通知を今後表示しない';

  @override
  String get autoSyncExplainConfirm => '了解、有効にする';

  @override
  String get hiwAutoSyncTitle => '自動で同期';

  @override
  String get hiwAutoSyncDesc =>
      '各セーブのカードにはAUTOチップがあります。有効にすると、アプリが変更を検知した際にそのセーブが自動的にアップロードまたはダウンロードされます — 確認のために開く必要はありません。';

  @override
  String get hiwAutoSyncTipSafe => '明らかに先に進んでいて、何も失われない場合にのみ自動で同期します。';

  @override
  String get hiwAutoSyncTipDanger =>
      '進行状況を失うリスクがある場合は、決して自動では行いません。これまで通り、いつもの比較画面で確認を求めます。';

  @override
  String get hiwAutoSyncTipPerSave =>
      '一括ではなく、セーブごとに個別に有効化できます。自分のセーブでは有効にし、共有セーブでは無効のままにすることも可能です。';

  @override
  String get hiwAutoSyncTipMissing =>
      'すでに存在する2つのコピーの同期を保つだけです。どちらかが存在しない場合、最初のアップロードまたはダウンロードはあなたが行います。';

  @override
  String get hiwAutoSyncTipRefresh => '設定で変更の自動確認を完全にオフにすることもできます。';

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
  String get hiwCompatIncomplete =>
      'セーブに「Drive上で不完全」と表示されている場合、クラウドに必要なファイルが不足しています — 別のデバイスから正しく再アップロードされるまでダウンロードできません。';

  @override
  String get hiwShareTitle => '他の人と共有';

  @override
  String get hiwShareDesc =>
      'メールで他のプレイヤーとセーブを共有できます。相手は自分のデバイスの「共有されたセーブ」にそれを見つけられます。';

  @override
  String get hiwShareStepYourSave => 'あなたの\nセーブ';

  @override
  String get hiwShareStepShare => 'メールで\n共有';

  @override
  String get hiwShareStepFriend => '共有された\nセーブ';

  @override
  String get hiwShareTipRoles =>
      '2つの役割があります。「閲覧のみ」は表示とダウンロードのみ許可します。「同期を許可」はあなたのDrive上のコピーの上書きを許可します。いずれの場合も削除はできません — 削除できるのは所有者であるあなただけです。';

  @override
  String get hiwShareTipDisconnect =>
      '「切断」は相手側の同期を止めるだけです — 共有自体は「共有の管理」から本当に退出するまで有効なままです。';

  @override
  String get hiwHostSwapTitle => 'ホスト変更';

  @override
  String get hiwHostSwapDesc =>
      'どのファームハンドをホストにするかを変更し、その場でセーブを置き換えます — 同じセーブスロット、同じ共有権限を維持します。';

  @override
  String get hiwHostSwapStepPick => 'ファームハンドを\n選択';

  @override
  String get hiwHostSwapStepConfirm => '確定';

  @override
  String get hiwHostSwapStepDone => '新しいセーブ\n作成完了';

  @override
  String get hiwHostSwapTipMove =>
      '家のためのスペースを確保するために、農場の一部のオブジェクトが移動する場合があります — 何も削除されません。';

  @override
  String get hiwHostSwapTipHouse =>
      '新しいホストの家はゲームのデフォルトの大きな家として表示されます — コテージの見た目はMODなしではサポートされません。';

  @override
  String get hiwBackupsTitle => 'バックアップ';

  @override
  String get hiwBackupsDesc =>
      'バックアップとは、後で復元できるセーブのスナップショットです。いつでも手動で作成するか、セーブを上書きする前（ダウンロード時、インポート時、復元時、ホスト変更時）にValleySaveが自動的に作成するようにできます。';

  @override
  String get hiwBackupsStepSave => 'あなたの\nセーブ';

  @override
  String get hiwBackupsStepSnapshot => 'バックアップ\n作成完了';

  @override
  String get hiwBackupsStepStore => '端末内や\nDriveに保存';

  @override
  String get hiwBackupsTipRestore =>
      '復元すると、現在のセーブがその過去のバージョンで上書きされます — 取り消せません。';

  @override
  String get hiwBackupsTipDelete =>
      'バックアップを削除すると、存在するすべての場所（この端末、アップロード済みの場合はDrive）から削除されます — 取り消せません。';

  @override
  String get hiwBackupsTipExport =>
      'セーブをzipとしてエクスポートし、好きな場所に保存して、後でインポートし直すこともできます — 内蔵バックアップの手動・持ち運び可能な代替手段です。';

  @override
  String get hiwBackupsTipRetention =>
      'ValleySaveは各セーブについて直近5件の自動バックアップを保持します。手動で作成したものは自動的に削除されることはありません。';

  @override
  String get hiwBackupsTipRestoreBridge =>
      'ブリッジモード（rootやShizukuを使わないAndroid）では、バックアップの復元時にStardewフォルダへ.zipを手動で展開するよう求められます — ダウンロード時と同様です。';

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
  String get chooserRootBadge => 'ROOT';

  @override
  String get chooserRootTitle => 'ルートアクセス';

  @override
  String get chooserRootDesc =>
      'ルート化されたデバイス用（Magisk / SuperSU）。root権限を一度承認するだけで、以降は自動的に動作します。';

  @override
  String get snackRootDenied => 'rootアクセスが拒否されました。代わりにShizukuを試してください。';

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

  @override
  String get tooltipLaunchGame => 'プレイ';

  @override
  String get hiwLaunchTitle => 'ゲームを起動';

  @override
  String get hiwLaunchDesc =>
      'セーブデータ画面の上部バーにある▶ボタンで、アプリからStardew Valleyを直接起動できます。';

  @override
  String get hiwLaunchTipWindows =>
      'Windowsでゲームが自動検出されない場合は、設定 → ゲームで実行ファイルのパスを設定してください。';

  @override
  String get hiwLaunchTipAndroid => 'Androidではゲームがインストールされていれば起動します。';

  @override
  String get hiwLaunchTipLinux =>
      'Linuxでゲームが自動検出されない場合は、設定 → ゲームで実行ファイルのパスを設定してください。';

  @override
  String get hiwSaveLocationsTitle => 'セーブの保存場所';

  @override
  String get hiwSaveLocationsDesc =>
      'ValleySaveは各プラットフォームのゲームのセーブフォルダに直接読み書きします。';

  @override
  String get hiwSaveLocationWindows =>
      'Windows: %AppData%\\StardewValley\\Saves';

  @override
  String get hiwSaveLocationAndroid =>
      'Android: 保護されたフォルダで、ShizukuまたはBridge経由でアクセスします';

  @override
  String get hiwSaveLocationLinux =>
      'Linux: ~/.config/StardewValley/Saves（SteamをSnap経由でインストールしている場合は ~/snap/steam/common/.config/StardewValley/Saves）';

  @override
  String get settingsGameSection => 'ゲーム';

  @override
  String get settingsGameExePath => 'Stardew Valley 実行ファイル';

  @override
  String get settingsGameExeNotFound => '自動検出されませんでした';

  @override
  String get settingsGameExeBrowse => '参照…';

  @override
  String get settingsGameExeSaved => 'パスを保存しました';

  @override
  String get snackLaunchError => 'ゲームを開けませんでした';

  @override
  String get makeHostAction => 'ホストにする';

  @override
  String get makeHostExperimental => '実験的機能';

  @override
  String get makeHostDialogTitle => 'ホストを変更';

  @override
  String makeHostDialogIntro(String playerName, String farmName) {
    return '$playerNameが$farmNameのホストになります。';
  }

  @override
  String get makeHostNewCopyNote => '新しいセーブデータが作成されます。その後、元のデータをどうするか選べます。';

  @override
  String makeHostMoveCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '家を建てるスペースを確保するため、農場のオブジェクトが$count個移動します。何も削除されません。',
    );
    return '$_temp0';
  }

  @override
  String get makeHostHouseWarning =>
      '新しいホストの家は、ゲームのメインの農場家に見えます。コテージの見た目はMODなしではサポートされません。';

  @override
  String get makeHostConfirmButton => 'ホストにする';

  @override
  String makeHostSuccess(String playerName) {
    return '新しいセーブデータを作成しました：$playerNameが新しいホストです。';
  }

  @override
  String get hostSwapErrInvalid => 'このセーブデータは予期しない構造をしています。何も変更されていません。';

  @override
  String get hostSwapErrNoSpace => '農場にオブジェクトを移動する空きスペースがありません。何も変更されていません。';

  @override
  String get hostSwapErrWrite => '新しいセーブデータを書き込めませんでした（ディスク／権限）。何も変更されていません。';

  @override
  String get hostSwapErrValidation => '新しいセーブデータの検証に失敗したため、破棄されました。元のデータは無事です。';

  @override
  String get makeHostDeleteOriginalTitle => 'この端末から元のセーブデータを削除しますか？';

  @override
  String get makeHostDeleteOriginalBody =>
      '新しいセーブデータの準備ができました。元のデータをまずDriveにバックアップする（後で再ダウンロードできます）か、ローカルコピーだけを削除できます。';

  @override
  String get makeHostDeleteOriginalNoBackupBody =>
      'Drive未接続：バックアップは残りません。この端末のローカルコピーのみが削除されます。';

  @override
  String get makeHostDeleteOriginalUploadBody =>
      '元のセーブデータはまずバックアップとしてDriveにアップロードされ、その後この端末のローカルコピーが削除されます。';

  @override
  String get makeHostDeleteWithoutUpload => 'アップロードせずに削除';

  @override
  String get makeHostUploadAndDelete => 'アップロードして削除';

  @override
  String get updateCheckFailed => '確認できませんでした';

  @override
  String get updateCheckFailedRetry => 'タップして再試行';
}
