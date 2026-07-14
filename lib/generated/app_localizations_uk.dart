// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Ukrainian (`uk`).
class AppLocalizationsUk extends AppLocalizations {
  AppLocalizationsUk([String locale = 'uk']) : super(locale);

  @override
  String get appTitle => 'ValleySave';

  @override
  String get welcomeTitle => 'Ніколи не втрачай свою ферму, бери її з собою.';

  @override
  String get connectGoogleDrive => 'Підключити Google Drive';

  @override
  String get connecting => 'Підключення…';

  @override
  String get mySaves => 'Мої збереження';

  @override
  String get howItWorks => 'Як це працює';

  @override
  String get settings => 'Налаштування';

  @override
  String get aboutSection => 'Про додаток';

  @override
  String get openSource => 'Доступний код';

  @override
  String get nonCommercial => 'Некомерційний';

  @override
  String get freeForever => 'Назавжди безкоштовно';

  @override
  String get privacyTitle => 'Конфіденційність та використання даних';

  @override
  String get privacyDescription =>
      'ValleySave — додаток для синхронізації збережень Stardew Valley з вашим Google Drive.';

  @override
  String get whatDataTitle => 'Які дані використовуються';

  @override
  String get whatDataDesc =>
      'ValleySave отримує доступ лише до файлів збережень Stardew Valley, необхідних для створення копій, синхронізації або відновлення.';

  @override
  String get googleDriveTitle => 'Google Drive';

  @override
  String get googleDriveDesc =>
      'Ваші збереження завантажуються на ваш власний Google Drive. ValleySave не використовує власні сервери для зберігання ваших ігор.';

  @override
  String get androidPermissionsTitle => 'Дозволи Android';

  @override
  String get androidPermissionsDesc =>
      'ValleySave може потребувати дозволу на зберігання або інструментів на кшталт Shizuku для доступу до файлів збережень.';

  @override
  String get adsTitle => 'Реклама';

  @override
  String get adsDesc =>
      'ValleySave може показувати рекламу через Google AdMob.';

  @override
  String get responsibilityTitle => 'Відповідальність';

  @override
  String get responsibilityDesc => 'Файли збережень — ваша відповідальність.';

  @override
  String get deleteDataTitle => 'Видалення даних';

  @override
  String get deleteDataDesc =>
      'Ви можете видалити синхронізовані копії, вручну видаливши папку ValleySave з Google Drive.';

  @override
  String get sourceCodeTitle => 'Вихідний код та контакти';

  @override
  String get sourceCodeDesc =>
      'ValleySave — проєкт із доступним кодом за ліцензією Polyform Noncommercial.';

  @override
  String get upToDate => 'Актуально';

  @override
  String get checkingUpdates => 'Перевіряємо…';

  @override
  String get updateAvailable => 'Доступне оновлення';

  @override
  String get application => 'Додаток';

  @override
  String version(Object version) {
    return 'Версія $version';
  }

  @override
  String get checkForUpdates => 'Перевірити оновлення';

  @override
  String get shizukuRequired => 'Потрібен Shizuku';

  @override
  String get shizukuGuide => 'Посібник з налаштування Shizuku';

  @override
  String get activateShizuku => 'Активуйте Shizuku для запису збережень у грі.';

  @override
  String deleteSaveTitle(Object saveName) {
    return 'Видалити $saveName';
  }

  @override
  String get deleteSaveMessage =>
      'Це видалить збереження з цього пристрою. Продовжити?';

  @override
  String get deleteFromDrive => 'Видалити з Drive';

  @override
  String confirmDelete(Object saveName) {
    return 'Збереження $saveName буде переміщено до кошика Google Drive.';
  }

  @override
  String deleteFromDeviceMessage(Object saveName) {
    return 'Збереження $saveName буде назавжди видалено з цього пристрою.';
  }

  @override
  String restoreSaveTitle(Object saveName) {
    return 'Відновити $saveName';
  }

  @override
  String restoreSaveMessage(Object saveName) {
    return 'Завантажити $saveName на цей пристрій?';
  }

  @override
  String get restore => 'Відновити';

  @override
  String get cancel => 'Скасувати';

  @override
  String get error => 'Помилка';

  @override
  String get success => 'Успішно';

  @override
  String get loading => 'Завантаження…';

  @override
  String get disconnect => 'Відключити';

  @override
  String get ok => 'OK';

  @override
  String get yes => 'Так';

  @override
  String get no => 'Ні';

  @override
  String get welcomeHeroPre => 'Ніколи не втрачай\nсвою ';

  @override
  String get welcomeHeroAccent => 'ферму,';

  @override
  String get welcomeHeroPost => '\nбери її з собою.';

  @override
  String get welcomeSubtitle =>
      'Синхронізуйте своїх збереження Stardew Valley на всіх пристроях. Ваші дані знаходяться у вашому Google Drive — жодних серверів, жодних підписок, під вашим контролем.';

  @override
  String get welcomeDriveConnected => 'Drive підключено';

  @override
  String get welcomeFooterTagline => '· Некомерційний · Назавжди безкоштовно ·';

  @override
  String updateVersionAvailable(String version) {
    return 'v$version доступна';
  }

  @override
  String get sectionMode => 'Режим';

  @override
  String get sectionSeason => 'Сезон';

  @override
  String get sectionLanguage => 'Мова';

  @override
  String get modeAutoTitle => 'Автоматично';

  @override
  String get modeAutoDesc =>
      'Слідує за вашим активним збереженням і, якщо збережень немає, за вашим реальним місцем розташування.';

  @override
  String get modeSavesTitle => 'За збереженням';

  @override
  String get modeSavesDesc =>
      'Завжди використовує сезон вашого останнього збереження.';

  @override
  String get modeGeoTitle => 'За місцем розташування';

  @override
  String get modeGeoDesc =>
      'Завжди використовує реальний сезон вашого регіону.';

  @override
  String get modeFixedTitle => 'Фіксований сезон';

  @override
  String get modeFixedDesc => 'Завжди показує один і той же сезон.';

  @override
  String get modeRandomTitle => 'Випадковий';

  @override
  String get modeRandomDesc =>
      'Вибирає інший сезон кожного разу, коли ви відкриваєте додаток.';

  @override
  String get seasonInitial => 'Початковий';

  @override
  String get seasonSpring => 'Весна';

  @override
  String get seasonSummer => 'Літо';

  @override
  String get seasonFall => 'Осінь';

  @override
  String get seasonWinter => 'Зима';

  @override
  String get autoPriorityTitle => 'Порядок пріоритетів';

  @override
  String get autoStep1Title => 'Перший запуск';

  @override
  String get autoStep1Desc => 'Показує початковий стан.';

  @override
  String get autoStep2Title => 'Активне збереження';

  @override
  String get autoStep2Desc =>
      'Використовує сезон вашого останнього синхронізованого збереження.';

  @override
  String get autoStep3Title => 'Місцезнаходження';

  @override
  String get autoStep3Desc =>
      'Визначає вашу півкулю та реальний сезон вашого регіону.';

  @override
  String get autoStep4Title => 'За замовчуванням';

  @override
  String get autoStep4Desc =>
      'Початковий (нічний режим), якщо дані недоступні.';

  @override
  String get versionInstalled => 'Встановлена версія';

  @override
  String get updateNeverChecked => 'Ніколи не перевірялася';

  @override
  String get updateCheckedNow => 'Щойно перевірена';

  @override
  String get updateOutdatedDownload => 'Не актуальна · Завантажити';

  @override
  String get updateDownloading => 'Завантаження оновлення…';

  @override
  String get updateError => 'Помилка — натисніть для повтору';

  @override
  String get disconnectTitle => 'Відключити Drive?';

  @override
  String get disconnectBody =>
      'Ваші збереження на Drive не будуть видалені. Ви можете переконнектитися в будь-який час.';

  @override
  String get disconnectButton => 'Відключити Drive';

  @override
  String get languageTileLabel => 'Мова';

  @override
  String get languageDialogTitle => 'Мова додатка';

  @override
  String get searchHint => 'Пошук…';

  @override
  String get languageAuto => 'Мова системи';

  @override
  String get languageAutoDesc => 'Використовує вашу мову системи';

  @override
  String get privacyPolicyTitle => 'Політика конфіденційності';

  @override
  String get privacyBeforeStartTitle => 'Перед початком';

  @override
  String get privacyLastUpdated => 'Останнє оновлення: червень 2026';

  @override
  String get privacyAccept => 'Зрозуміло, продовжити';

  @override
  String get cardSynced => 'Синхронізовано';

  @override
  String get cardLocalAhead => 'Локально попереду';

  @override
  String get cardDriveAhead => 'Drive попереду';

  @override
  String get cardLocalOnly => 'Тільки локально';

  @override
  String get cardDriveOnly => 'Тільки на Drive';

  @override
  String get cardTimeNow => 'зараз';

  @override
  String cardTimeMinutesAgo(int minutes) {
    return '$minutes хв тому';
  }

  @override
  String cardTimeHoursAgo(int hours) {
    return '$hoursг тому';
  }

  @override
  String cardTimeDaysAgo(int days) {
    return '$daysд тому';
  }

  @override
  String cardTimeMonthsAgo(int months) {
    return '$monthsміс тому';
  }

  @override
  String get cardDetailLocalTitle => 'На цьому пристрої';

  @override
  String get cardDetailRemoteTitle => 'На Drive';

  @override
  String get cardDetailUpload => 'Завантажити на Drive';

  @override
  String get cardDetailDownload => 'Завантажити збереження';

  @override
  String get cardDetailDeleteLabel => 'Видалити';

  @override
  String get cardDetailDeleteLocal => 'Видалити з цього пристрою';

  @override
  String get cardDetailDeleteRemote => 'Видалити з Drive';

  @override
  String get cardCloseBarrier => 'Закрити';

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
  String get sharedWithMeRevoked => 'You no longer have access';

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
    return 'День $day · Рік $year';
  }

  @override
  String statDayOnly(int day) {
    return 'День $day';
  }

  @override
  String get statPlaytime => 'Час гри';

  @override
  String get statMoney => 'Монети';

  @override
  String get statTotal => 'Всього';

  @override
  String get statMineUnexplored => 'Невідпрацьовано';

  @override
  String get statMine => 'Шахта';

  @override
  String get statMineLvl => 'Шахта · Рівень';

  @override
  String get skillFarming => 'Хліборобство';

  @override
  String get skillForaging => 'Збирання';

  @override
  String get skillMining => 'Видобування';

  @override
  String get skillFishing => 'Рибалка';

  @override
  String get skillCombat => 'Бій';

  @override
  String get cardLocalPresence => 'На цьому пристрої';

  @override
  String get cardRemotePresence => 'На Drive';

  @override
  String get cardNotPresent => 'Не тут';

  @override
  String get cardActionSynced => 'Синхронізовано';

  @override
  String get cardActionUpload => 'Завантажити';

  @override
  String get cardActionDownload => 'Завантажити';

  @override
  String get pillMonsters => 'монстрів';

  @override
  String get pillFriends => 'друзів';

  @override
  String get pillFaints => 'падінь';

  @override
  String get pillSleeps => 'сну';

  @override
  String get hiwTitle => 'Як це працює';

  @override
  String get hiwSyncTitle => 'Як працює синхронізація';

  @override
  String get hiwSyncIntro =>
      'ValleySave використовує ваш власний Google Drive для переміщення збережень між пристроями. Жодних проміжних серверів: файли — ваші.';

  @override
  String get hiwSyncDevice => 'Ваш\nпристрій';

  @override
  String get hiwSyncCloud => 'Google\nDrive';

  @override
  String get hiwSyncOtherDevice => 'Інший\nпристрій';

  @override
  String get hiwUploadTitle => 'Завантажити збереження';

  @override
  String get hiwUploadDesc =>
      'При завантаженні ValleySave копіює обидва файли збереження (SaveGameInfo + файл ферми) у папку ValleySave/ на Drive.';

  @override
  String get hiwDownloadTitle => 'Завантажити збереження';

  @override
  String get hiwDownloadDesc =>
      'При завантаженні ValleySave приносить файли з Drive і розміщує їх прямо в папці гри.';

  @override
  String get hiwCompareTitle => 'Що він порівнює?';

  @override
  String get hiwCompareIntro =>
      'Щоб дізнатися, яка версія попереду, ValleySave використовує загальний час гри — єдині дані, які можуть тільки зростати.';

  @override
  String get hiwCompareNote =>
      'Перед підтвердженням ви також побачите, щоб могли вирішити:';

  @override
  String get hiwCompareMoney => 'Поточні гроші та всього заробленого';

  @override
  String get hiwCompareMine => 'Рівень шахти';

  @override
  String get hiwCompareSkills => 'Навички (хліборобство, видобування, бій…)';

  @override
  String get hiwCompareRelations => 'Друзі, вбитих монстрів, падінь';

  @override
  String get hiwCompareStamina => 'Витривалість та здоров\'я';

  @override
  String get hiwCompareNotShown =>
      'Це не показується — вони змінюються в будь-якому напрямку і не вказують на те, яке збереження попереду.';

  @override
  String get hiwCompareNotShownExamples =>
      'Стан культур та тварин, інвентар та речі, окремі взаємовідносини';

  @override
  String get hiwCompareWarning =>
      'Це не показується — вони змінюються в будь-якому напрямку і не вказують на те, яке збереження попереду.';

  @override
  String get hiwConflictTitle => 'Якщо ви граєте без синхронізації';

  @override
  String get hiwConflictDesc =>
      'Якщо ви просуватися на мобілі та комп\'ютері без синхронізації між сеансами, ви закінчите з двома версіями одного збереження.';

  @override
  String get hiwConflictNoMerge =>
      'Їх неможливо об\'єднати. ValleySave завжди показує вам обидві версії, щоб ви могли вибрати, яку зберегти.';

  @override
  String get hiwConflictMobile => 'Мобіль';

  @override
  String get hiwConflictVersionA => 'версія A';

  @override
  String get hiwConflictPC => 'ПК';

  @override
  String get hiwConflictVersionB => 'версія B';

  @override
  String get hiwDeleteTitle => 'Якщо збереження видалено';

  @override
  String get hiwDeleteDesc =>
      'Коли ви видаляєте збереження з Drive, воно не зникає одразу: воно переходить у смітник Google Drive.';

  @override
  String get hiwCompatTitle => 'Сумісність платформ';

  @override
  String get hiwCompatAndroidAccess => 'ДОСТУП НА ANDROID';

  @override
  String get hiwShizukuTitle => 'З Shizuku';

  @override
  String get hiwShizukuSubtitle =>
      'Налаштуйте один раз. Потім ValleySave синхронізується сам, не дотикаючись ні до чого.';

  @override
  String get hiwShizukuBadge => 'АВТОМАТИЧНО · РЕКОМЕНДУЄТЬСЯ';

  @override
  String get hiwShizukuDone =>
      '✓ Виконано. З того часу завантаження та вивантаження збережень відбувається прямо, як на комп\'ютері.';

  @override
  String get hiwShizukuNote =>
      'Сполучення тільки вперше. Нові версії Shizuku активуються самі після перезавантаження телефону.';

  @override
  String get hiwBridgeTitle => 'Ручний міст';

  @override
  String get hiwBridgeSubtitle =>
      'Працює тільки на Android 11 та 12. Ви не встановлюєте нічого додатково; натомість ви копіюєте збереження вручну через файловий менеджер кожного разу, коли синхронізуєтеся.';

  @override
  String get hiwBridgeBadge => 'РУЧНА АЛЬТЕРНАТИВА · ANDROID 11-12';

  @override
  String get hiwBridgeSaveFolder => 'Папка Stardew';

  @override
  String get hiwBridgeValleySaveFolder => 'Папка ValleySave';

  @override
  String get hiwBridgeNote =>
      'Це працює, тому що ваш файловий менеджер системи може отримати доступ до цих папок (ValleySave не може).';

  @override
  String get hiwTipAlwaysShow =>
      'Ви завжди побачите, що на Drive, перед перезаписом, щоб могли порівняти.';

  @override
  String get hiwTipWithoutUpload =>
      'Без завантаження жоден інший пристрій не побачить ваш недавній прогрес.';

  @override
  String get hiwTipComparison =>
      'Перед підтвердженням ви побачите порівняння між локальним і Drive.';

  @override
  String get hiwTipDownloadOverwrite =>
      'Завантаження перезаписує ваше локальне збереження. Будь-який не синхронізований прогрес буде втрачено.';

  @override
  String get hiwTipSync =>
      'Завжди завантажуйте перед перемиканням пристроїв і завантажуйте по прибутті.';

  @override
  String get hiwTipDeletion =>
      'У вас є 30 днів для відновлення його зі смітника Drive перед остаточним видаленням.';

  @override
  String get hiwPrivacyLink => 'Політика конфіденційності та використання';

  @override
  String get emptyNoSaves => 'Збережень не знайдено';

  @override
  String get emptyNoSavesHint =>
      'На цьому пристрої не можна прочитати жодного локального збереження';

  @override
  String get bridgeTitle => 'Принесіть свої збереження';

  @override
  String get bridgeDesc =>
      'Щоб побачити та завантажити ваші локальні збереження, скопіюйте їх через файловий менеджер з папки Stardew до цієї папки ValleySave. Потім проведіть для оновлення.';

  @override
  String get bridgeRefresh => 'Оновити';

  @override
  String get bridgeChangeMode => 'Змінити метод';

  @override
  String get loaderLoading => 'ЗАВАНТАЖЕННЯ';

  @override
  String get loaderConnecting => 'підключення до Drive…';

  @override
  String get chooserTitle => 'Виберіть спосіб підключення';

  @override
  String get chooserAutomatic => 'Автоматично · Рекомендується';

  @override
  String get chooserManual => 'Ручна альтернатива · Android 11-12';

  @override
  String get shizukuStepTitle => 'Налаштуйте Shizuku';

  @override
  String get shizukuStep1Title => 'Встановіть Shizuku';

  @override
  String get shizukuStep1Desc => 'Завантажте з Play Store або GitHub';

  @override
  String get shizukuStep2Title => 'Активуйте Shizuku';

  @override
  String get shizukuStep2Desc => 'Запустіть програму та надайте дозволи';

  @override
  String get shizukuStep3Title => 'Надати дозвіл';

  @override
  String get shizukuStep3Desc => 'ValleySave попросить доступ';

  @override
  String get shizukuDone =>
      '✓ Виконано. З того часу завантаження та вивантаження збережень працює прямо, як на комп\'ютері.';

  @override
  String get dlgDeleteDriveTitle => 'Видалити з Drive';

  @override
  String get dlgDeleteLocalTitle => 'Видалити з цього пристрою';

  @override
  String get dlgDownloadTitle => 'Завантажити збереження';

  @override
  String get dlgUploadTitle => 'Завантажити збереження';

  @override
  String get dlgUploadOverwrite => 'Це перезапише ваше локальне збереження';

  @override
  String get dlgGotIt => 'Зрозуміло';

  @override
  String get dlgCopyDest => 'Скопіювати призначення';

  @override
  String get previewColDayYear => 'День/Рік';

  @override
  String get previewColTime => 'Час гри';

  @override
  String get previewColMoney => 'Монети';

  @override
  String get previewColTotal => 'Всього';

  @override
  String get previewColFarming => 'Хліборобство';

  @override
  String get previewColForaging => 'Збирання';

  @override
  String get previewColMining => 'Видобування';

  @override
  String get previewColFishing => 'Рибалка';

  @override
  String get previewColCombat => 'Бій';

  @override
  String get previewColFriends => 'Друзі';

  @override
  String get previewColMonsters => 'Монстри';

  @override
  String get previewColFaints => 'Падіння';

  @override
  String get previewColMine => 'Шахта';

  @override
  String get previewColUnexplored => 'Невідпрацьовано';

  @override
  String get previewLocalLabel => 'НА ЦЬОМУ ПРИСТРОЇ';

  @override
  String get previewDriveLabel => 'НА DRIVE';

  @override
  String get previewFromDrive => 'З DRIVE';

  @override
  String get previewFromDevice => 'З ЦЬОГО ПРИСТРОЮ';

  @override
  String versionMismatch(String local, String drive) {
    return 'Різні версії: локально $local · Drive $drive…';
  }

  @override
  String get snackPathCopied => 'Шлях скопійовано';

  @override
  String get snackDestCopied => 'Шлях призначення скопійовано';

  @override
  String get snackDownloaded => 'Збереження завантажено до гри';

  @override
  String get snackSessionExpired => 'Сеанс Drive закінчився. Переконнектитися';

  @override
  String snackUploadError(String error) {
    return 'Помилка завантаження: $error';
  }

  @override
  String snackDownloadError(String error) {
    return 'Помилка завантаження: $error';
  }

  @override
  String snackDeleteError(String error) {
    return 'Помилка видалення: $error';
  }

  @override
  String snackTrashed(String saveName) {
    return '\"$saveName\" переміщено до смітника Drive. У вас є 30 днів для відновлення.';
  }

  @override
  String snackDeletedLocal(String saveName) {
    return '\"$saveName\" видалено з цього пристрою';
  }

  @override
  String get snackShizukuRequired => 'Активуйте Shizuku…';

  @override
  String get snackWriteError =>
      'Не вдалося записати до гри. Деякі телефони блокують /Android/data навіть з Shizuku.';

  @override
  String get snackPlatformNotSupported =>
      'Ця платформа поки не підтримує запис локальних збережень.';

  @override
  String get snackWirelessDebugHint =>
      'Відкрийте вручну: Налаштування → Параметри розробника → Бездротове налагодження.';

  @override
  String get snackOpenShizukuApp =>
      'Відкрийте Shizuku зі своєї шухляди застосунків.';

  @override
  String get hiwTipDeletePermanent =>
      'ValleySave не може відновити постійно видалені збереження. Файли Drive — ваша відповідальність.';

  @override
  String get hiwCompatAchievements =>
      'Досягнення Steam та Google Play не переносяться. Кожна платформа відстежує тільки досягнення, які відбуваються в реальному часі — файл збереження не запускає їх зворотно.';

  @override
  String get hiwCompatOverwrite =>
      'Якщо синхронізуватися з двох пристроїв без встановленого порядку, одне збереження може перезаписати інше. Завжди завантажуйте перед завантаженням.';

  @override
  String get hiwCompatVersions =>
      'Збереження з різних версій гри можуть неправильно завантажитися. ValleySave попередить вас, якщо виявить невідповідність версії перед завантаженням.';

  @override
  String get hiwCompatMods =>
      'Моди SMAPI додають додаткові дані до збереження. Якщо завантажити модифіковане збереження на пристрій, де ці моди не встановлені, гра може аварійно завершитися або втратити дані модів.\n\nНа Android можна також встановити SMAPI для використання модів.';

  @override
  String get hiwComparePrimary => 'Загальний час гри';

  @override
  String get hiwCompareNoShown1 => 'Стан культур та тварин';

  @override
  String get hiwCompareNoShown2 => 'Інвентар та речі';

  @override
  String get hiwCompareNoShown3 => 'Окремі взаємовідносини';

  @override
  String get hiwShizuku1 => 'Встановіть Shizuku (Play Store або APK GitHub).';

  @override
  String get hiwShizuku2 =>
      'Активуйте за допомогою бездротового налагодження — ValleySave проведе вас крок за кроком.';

  @override
  String get hiwShizuku3 =>
      'Надайте дозвіл валлеїсейву коли буде запропоновано.';

  @override
  String get hiwBridge1 =>
      'Завантажити з Drive: ValleySave залишає збереження у своїй папці. Ви копіюєте його через Files до папки Stardew.';

  @override
  String get hiwBridge2 =>
      'Завантажити на Drive: скопіюйте збереження з Stardew у папку ValleySave. ValleySave виявляє його та завантажує.';

  @override
  String get snackShizukuBattery =>
      'Налаштування → Програми → Shizuku → Батарея → Без обмежень.';

  @override
  String snackDriveError(String error) {
    return 'Drive: $error';
  }

  @override
  String get dlgDeleteLocalWarning =>
      '⚠️ Якщо ви не завантажили на Drive, воно буде втрачено назавжди. Немає способу восстановлення.';

  @override
  String get dlgDelete => 'Видалити';

  @override
  String get dlgDownloadButton => 'Завантажити';

  @override
  String get dlgUploadButton => 'Завантажити';

  @override
  String get dlgBridgeCopyTitle => 'Скопіювати збереження до гри';

  @override
  String dlgBridgeCopyDesc(String saveName) {
    return 'Збереження готове. За допомогою файлового менеджера скопіюйте папку \"$saveName\" та вставте її в папку Stardew.';
  }

  @override
  String get labelFrom => 'З';

  @override
  String get labelTo => 'До';

  @override
  String dlgDownloadNewDesc(String saveName, int day, String playtime) {
    return '\"$saveName\" (День $day, $playtime) буде скопійовано на цей пристрій.';
  }

  @override
  String dlgDownloadOverwrite(String saveName) {
    return 'Це ПЕРЕЗАПИШЕ ваше локальне збереження \"$saveName\".';
  }

  @override
  String dlgUploadNewDesc(String saveName, int day, String playtime) {
    return '\"$saveName\" (День $day, $playtime) буде завантажено на ваш Drive.';
  }

  @override
  String dlgUploadOverwriteDrive(String saveName) {
    return 'Це ПЕРЕЗАПИШЕ версію Drive \"$saveName\".';
  }

  @override
  String get pathLabelFromStardew => 'З (Stardew)';

  @override
  String get pathLabelToValleySave => 'До (ValleySave)';

  @override
  String get chooserDesc =>
      'Android захищає папку гри. Виберіть, як дати ValleySave доступ — ви можете змінити це в будь-який час.';

  @override
  String get chooserShizukuDesc =>
      'Налаштовується один раз. Потім ValleySave синхронізується самостійно, не дотикаючись нічого. Єдиний надійний метод на Android 13+.';

  @override
  String get chooserManualBadge => 'ТІЛЬКИ ANDROID 11-12';

  @override
  String get chooserBridgeDesc =>
      'Копіюйте збереження через файловий менеджер. Без додаткового встановлення. Тільки на Android 11 та 12.';

  @override
  String get chooserRootBadge => 'ROOT';

  @override
  String get chooserRootTitle => 'Root-доступ';

  @override
  String get chooserRootDesc =>
      'Для пристроїв з root (Magisk / SuperSU). Підтвердіть запит root один раз — далі автоматично.';

  @override
  String get snackRootDenied => 'Root-доступ відхилено. Спробуйте Shizuku.';

  @override
  String get shizukuGateSubtitle =>
      'Налаштовується один раз · тільки в перший раз';

  @override
  String get shizukuStatusLabel => 'Shizuku активна';

  @override
  String get shizukuStatusRunning => 'Підключено та чекає.';

  @override
  String get shizukuStatusNotDetected => 'Ще не виявлено.';

  @override
  String get shizukuPermLabel => 'Дозвіл надано';

  @override
  String get shizukuPermGranted => 'ValleySave вже має доступ.';

  @override
  String get shizukuPermNotGranted => 'Потрібна авторизація ValleySave.';

  @override
  String get shizukuGrant => 'надати';

  @override
  String get shizukuGuideHeader => 'ПОКРОКОВИЙ ПОСІБНИК';

  @override
  String get shizukuStep1DescFull =>
      'Безкоштовно. Якщо Google Play блокує його на вашому телефоні, використовуйте офіційний APK GitHub.';

  @override
  String get btnPlayStore => 'Play Store';

  @override
  String get btnApkGithub => 'APK GitHub';

  @override
  String get shizukuStep2TitleFull => 'Активуйте параметри розробника';

  @override
  String get shizukuStep2DescFull =>
      'Налаштування → Інформація про телефон → Інформація про програмне забезпечення → натисніть \"Номер збірки\" 7 разів.';

  @override
  String get shizukuStep3TitleFull => 'Активуйте бездротове налагодження';

  @override
  String get shizukuStep3DescFull =>
      'Кнопка приносить вас туди та висвітлює це. Активуйте його (ВКЛ). Потім натисніть \"Сполучитися з кодом парування\" — на екрані з\'явиться 6-значний код.';

  @override
  String get btnOpenAndHighlight => 'Відкрити та виділити';

  @override
  String get shizukuStep4Title => 'Сполучити та ЗАПУСТИТИ Shizuku';

  @override
  String get shizukuStep4Desc =>
      'Відкрийте Shizuku → \"Запустити через бездротове налагодження\" → \"Сполучити з кодом парування\". Shizuku надішле сповіщення про те, що чекає. Введіть 6-значний код з екрана бездротового налагодження. Після сполучення натисніть ЗАПУСТИТИ — без цього останнього натиску Shizuku не буде активна.';

  @override
  String get btnOpenShizuku => 'Відкрити Shizuku';

  @override
  String get shizukuStep5Title =>
      'Встановіть батарею Shizuku на \"Без обмежень\"';

  @override
  String get shizukuStep5Desc =>
      'Відкрийте інформацію про програму → Батарея → Без обмежень. Якщо ви цього не зробите, система закриє Shizuku у фоновому режимі, і вам доведеться знову натиснути Запустити.';

  @override
  String get btnShizukuAppInfo => 'Інформація про програму Shizuku';

  @override
  String get shizukuStep6DescActive =>
      'Shizuku активна. Натисніть кнопку для авторизації.';

  @override
  String get shizukuStep6DescWaiting =>
      'Доступно після активації Shizuku (крок 4).';

  @override
  String get btnGrantPermission => 'Надати дозвіл';

  @override
  String get btnCheckShizuku => 'Виконано · Перевірити';

  @override
  String get statusDone => 'виконано';

  @override
  String get statusPending => 'очікування';

  @override
  String get latestBadge => '· ОСТАННЄ ЗБЕРЕЖЕННЯ ·';

  @override
  String saveDateLabel(String season, int year) {
    return '$season · Рік $year';
  }

  @override
  String get petCat => 'Кіт';

  @override
  String get petDog => 'Собака';

  @override
  String get houseBasic => 'Базовий будинок';

  @override
  String get houseKitchen => 'З кухнею';

  @override
  String get houseBedroom => 'З спальнею';

  @override
  String get houseCellar => 'З підвалом';

  @override
  String houseLevelN(int level) {
    return 'Рівень $level';
  }

  @override
  String get tooltipLaunchGame => 'Грати';

  @override
  String get hiwLaunchTitle => 'Запустити гру';

  @override
  String get hiwLaunchDesc =>
      'Кнопка ▶ у верхній панелі розділу Мої збереження відкриває Stardew Valley прямо з додатку.';

  @override
  String get hiwLaunchTipWindows =>
      'У Windows, якщо гру не знайдено автоматично, вкажіть шлях в Налаштування → Гра.';

  @override
  String get hiwLaunchTipAndroid =>
      'На Android відкриває гру, якщо вона встановлена.';

  @override
  String get settingsGameSection => 'Гра';

  @override
  String get settingsGameExePath => 'Виконуваний файл Stardew Valley';

  @override
  String get settingsGameExeNotFound => 'Не знайдено автоматично';

  @override
  String get settingsGameExeBrowse => 'Огляд…';

  @override
  String get settingsGameExeSaved => 'Шлях збережено';

  @override
  String get snackLaunchError => 'Не вдалося відкрити гру';

  @override
  String get makeHostAction => 'ЗРОБИТИ ГОСПОДАРЕМ';

  @override
  String get makeHostExperimental => 'ЕКСПЕРИМЕНТАЛЬНО';

  @override
  String get makeHostDialogTitle => 'Змінити господаря';

  @override
  String makeHostDialogIntro(String playerName, String farmName) {
    return '$playerName стане господарем ферми $farmName.';
  }

  @override
  String get makeHostNewCopyNote =>
      'Створюється нове збереження. Далі ви вирішите, що робити з оригіналом.';

  @override
  String makeHostMoveCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other:
          'На фермі буде переміщено $count об\'єкта, щоб звільнити місце для будинку. Нічого не видаляється.',
      many:
          'На фермі буде переміщено $count об\'єктів, щоб звільнити місце для будинку. Нічого не видаляється.',
      few:
          'На фермі буде переміщено $count об\'єкти, щоб звільнити місце для будинку. Нічого не видаляється.',
      one:
          'На фермі буде переміщено $count об\'єкт, щоб звільнити місце для будинку. Нічого не видаляється.',
    );
    return '$_temp0';
  }

  @override
  String get makeHostHouseWarning =>
      'Будинок нового господаря виглядатиме як великий фермерський будинок гри. Вигляд хатини не підтримується без модів.';

  @override
  String get makeHostConfirmButton => 'Зробити господарем';

  @override
  String makeHostSuccess(String playerName) {
    return 'Нове збереження створено: $playerName тепер господар.';
  }

  @override
  String get hostSwapErrInvalid =>
      'Це збереження має неочікувану структуру. Нічого не змінено.';

  @override
  String get hostSwapErrNoSpace =>
      'На фермі немає вільного місця для переміщення об\'єктів. Нічого не змінено.';

  @override
  String get hostSwapErrWrite =>
      'Не вдалося записати нове збереження (диск/дозволи). Нічого не змінено.';

  @override
  String get hostSwapErrValidation =>
      'Перевірка нового збереження не вдалася, тому його скасовано. Оригінал неушкоджений.';
}
