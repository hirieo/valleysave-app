// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Russian (`ru`).
class AppLocalizationsRu extends AppLocalizations {
  AppLocalizationsRu([String locale = 'ru']) : super(locale);

  @override
  String get appTitle => 'ValleySave';

  @override
  String get welcomeTitle =>
      'Никогда не теряйте вашу ферму, берите её с собой.';

  @override
  String get connectGoogleDrive => 'Подключить Google Drive';

  @override
  String get connecting => 'Подключение…';

  @override
  String get mySaves => 'Мои сохранения';

  @override
  String get howItWorks => 'Как это работает';

  @override
  String get settings => 'Параметры';

  @override
  String get aboutSection => 'О программе';

  @override
  String get openSource => 'Доступный код';

  @override
  String get nonCommercial => 'Некоммерческий';

  @override
  String get freeForever => 'Бесплатно навсегда';

  @override
  String get privacyTitle => 'Конфиденциальность и использование данных';

  @override
  String get privacyDescription =>
      'ValleySave — приложение для синхронизации ваших сохранений Stardew Valley с собственной учётной записью Google Drive.';

  @override
  String get whatDataTitle => 'Какие данные используются';

  @override
  String get whatDataDesc =>
      'ValleySave получает доступ только к файлам сохранений Stardew Valley, необходимым для создания копий, их синхронизации или восстановления.';

  @override
  String get googleDriveTitle => 'Google Drive';

  @override
  String get googleDriveDesc =>
      'Ваши сохранения загружаются в вашу учётную запись Google Drive. ValleySave не использует собственные серверы для хранения ваших игр.';

  @override
  String get androidPermissionsTitle => 'Разрешения на Android';

  @override
  String get androidPermissionsDesc =>
      'ValleySave может требовать разрешения на хранилище или инструменты, такие как Shizuku, для доступа к файлам сохранений.';

  @override
  String get adsTitle => 'Реклама';

  @override
  String get adsDesc =>
      'ValleySave может показывать рекламу через Google AdMob.';

  @override
  String get responsibilityTitle => 'Ответственность';

  @override
  String get responsibilityDesc => 'Файлы сохранений — ваша ответственность.';

  @override
  String get deleteDataTitle => 'Удалить данные';

  @override
  String get deleteDataDesc =>
      'Вы можете удалить синхронизированные копии, вручную удалив папку ValleySave с Google Drive.';

  @override
  String get sourceCodeTitle => 'Исходный код и контакты';

  @override
  String get sourceCodeDesc =>
      'ValleySave — проект с доступным кодом под лицензией Polyform Noncommercial.';

  @override
  String get upToDate => 'Актуально';

  @override
  String get checkingUpdates => 'Проверка…';

  @override
  String get updateAvailable => 'Доступно обновление';

  @override
  String get application => 'Приложение';

  @override
  String version(Object version) {
    return 'Версия $version';
  }

  @override
  String get checkForUpdates => 'Проверить обновления';

  @override
  String get shizukuRequired => 'Требуется Shizuku';

  @override
  String get shizukuGuide => 'Руководство по настройке Shizuku';

  @override
  String get activateShizuku =>
      'Активируйте Shizuku, чтобы записать сохранение в игру.';

  @override
  String deleteSaveTitle(Object saveName) {
    return 'Удалить $saveName';
  }

  @override
  String get deleteSaveMessage =>
      'Это удалит сохранение с этого устройства. Вы хотите продолжить?';

  @override
  String get deleteFromDrive => 'Удалить с Drive';

  @override
  String confirmDelete(Object saveName) {
    return 'Сохранение $saveName будет перемещено в корзину Google Drive.';
  }

  @override
  String deleteFromDeviceMessage(Object saveName) {
    return 'Сохранение $saveName будет окончательно удалено с этого устройства.';
  }

  @override
  String restoreSaveTitle(Object saveName) {
    return 'Восстановить $saveName';
  }

  @override
  String restoreSaveMessage(Object saveName) {
    return 'Загрузить $saveName на это устройство?';
  }

  @override
  String get restore => 'Восстановить';

  @override
  String get cancel => 'Отмена';

  @override
  String get error => 'Ошибка';

  @override
  String get success => 'Успешно';

  @override
  String get loading => 'Загрузка…';

  @override
  String get disconnect => 'Отключить';

  @override
  String get ok => 'OK';

  @override
  String get yes => 'Да';

  @override
  String get no => 'Нет';

  @override
  String get welcomeHeroPre => 'Никогда не\nтеряйте ';

  @override
  String get welcomeHeroAccent => 'ферму,';

  @override
  String get welcomeHeroPost => '\nберите её с собой.';

  @override
  String get welcomeSubtitle =>
      'Синхронизируйте сохранения Stardew Valley на всех устройствах. Ваши данные хранятся в вашем Google Drive — без серверов, без подписок, под вашим контролем.';

  @override
  String get welcomeDriveConnected => 'Drive подключён';

  @override
  String get welcomeFooterTagline => '· Некоммерческий · Бесплатно навсегда ·';

  @override
  String updateVersionAvailable(String version) {
    return 'v$version доступно';
  }

  @override
  String get sectionMode => 'Режим';

  @override
  String get sectionSeason => 'Сезон';

  @override
  String get sectionLanguage => 'Язык';

  @override
  String get modeAutoTitle => 'Автоматический';

  @override
  String get modeAutoDesc =>
      'Следует активному сохранению, а если сохранений нет — вашему реальному местоположению.';

  @override
  String get modeSavesTitle => 'По сохранению';

  @override
  String get modeSavesDesc =>
      'Всегда использует сезон из последнего сохранения.';

  @override
  String get modeGeoTitle => 'По местоположению';

  @override
  String get modeGeoDesc => 'Всегда использует реальный сезон вашего региона.';

  @override
  String get modeFixedTitle => 'Фиксированный сезон';

  @override
  String get modeFixedDesc => 'Всегда показывает один и тот же сезон.';

  @override
  String get modeRandomTitle => 'Случайный';

  @override
  String get modeRandomDesc =>
      'Выбирает другой сезон каждый раз при запуске приложения.';

  @override
  String get seasonInitial => 'Начальный';

  @override
  String get seasonSpring => 'Весна';

  @override
  String get seasonSummer => 'Лето';

  @override
  String get seasonFall => 'Осень';

  @override
  String get seasonWinter => 'Зима';

  @override
  String get autoPriorityTitle => 'Порядок приоритетов';

  @override
  String get autoStep1Title => 'Первый запуск';

  @override
  String get autoStep1Desc => 'Показывает начальное состояние.';

  @override
  String get autoStep2Title => 'Активное сохранение';

  @override
  String get autoStep2Desc =>
      'Использует сезон из последнего синхронизированного сохранения.';

  @override
  String get autoStep3Title => 'Местоположение';

  @override
  String get autoStep3Desc =>
      'Определяет ваше полушарие и реальный сезон вашего региона.';

  @override
  String get autoStep4Title => 'По умолчанию';

  @override
  String get autoStep4Desc =>
      'Начальный режим (ночной), если данные недоступны.';

  @override
  String get versionInstalled => 'Установленная версия';

  @override
  String get updateNeverChecked => 'Никогда не проверялось';

  @override
  String get updateCheckedNow => 'Только что проверено';

  @override
  String get updateOutdatedDownload => 'Не актуально · Скачать';

  @override
  String get updateDownloading => 'Загрузка обновления…';

  @override
  String get updateError => 'Ошибка — нажмите для повтора';

  @override
  String get disconnectTitle => 'Отключить Drive?';

  @override
  String disconnectBody(String email) {
    return 'Ваши сохранения на Drive не будут удалены. Вы можете переподключиться в любое время.';
  }

  @override
  String get disconnectButton => 'Отключить Drive';

  @override
  String disconnectButtonEmail(String email) {
    return 'Disconnect from $email';
  }

  @override
  String get connectedAsPrefix => 'Connected as';

  @override
  String get languageTileLabel => 'Язык';

  @override
  String get languageDialogTitle => 'Язык приложения';

  @override
  String get searchHint => 'Поиск…';

  @override
  String get languageAuto => 'Язык системы';

  @override
  String get languageAutoDesc => 'Использует язык вашей системы';

  @override
  String get privacyPolicyTitle => 'Политика конфиденциальности';

  @override
  String get privacyBeforeStartTitle => 'Перед началом';

  @override
  String get privacyLastUpdated => 'Последнее обновление: июнь 2026';

  @override
  String get privacyAccept => 'Понятно, продолжить';

  @override
  String get cardSynced => 'Синхронизировано';

  @override
  String get cardLocalAhead => 'Локальная версия новее';

  @override
  String get cardDriveAhead => 'Drive версия новее';

  @override
  String get cardLocalOnly => 'Только локально';

  @override
  String get cardDriveOnly => 'Только на Drive';

  @override
  String get cardTimeNow => 'сейчас';

  @override
  String cardTimeMinutesAgo(int minutes) {
    return '$minutes мин назад';
  }

  @override
  String cardTimeHoursAgo(int hours) {
    return '$hoursч назад';
  }

  @override
  String cardTimeDaysAgo(int days) {
    return '$daysд назад';
  }

  @override
  String cardTimeMonthsAgo(int months) {
    return '$monthsмес назад';
  }

  @override
  String get cardDetailLocalTitle => 'На этом устройстве';

  @override
  String get cardDetailRemoteTitle => 'На Drive';

  @override
  String get cardDetailUpload => 'Загрузить на Drive';

  @override
  String get cardDetailDownload => 'Скачать сохранение';

  @override
  String get cardDetailDeleteLabel => 'Удалить';

  @override
  String get cardDetailDeleteLocal => 'Удалить с этого устройства';

  @override
  String get cardDetailDeleteRemote => 'Удалить с Drive';

  @override
  String get cardCloseBarrier => 'Закрыть';

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
    return 'День $day · Год $year';
  }

  @override
  String statDayOnly(int day) {
    return 'День $day';
  }

  @override
  String get statPlaytime => 'Время игры';

  @override
  String get statMoney => 'Монеты';

  @override
  String get statTotal => 'Всего';

  @override
  String get statMineUnexplored => 'Не исследовано';

  @override
  String get statMine => 'Шахта';

  @override
  String get statMineLvl => 'Шахта · Ур';

  @override
  String get skillFarming => 'Земледелие';

  @override
  String get skillForaging => 'Собирательство';

  @override
  String get skillMining => 'Горное дело';

  @override
  String get skillFishing => 'Рыбалка';

  @override
  String get skillCombat => 'Бой';

  @override
  String get cardLocalPresence => 'На этом устройстве';

  @override
  String get cardRemotePresence => 'На Drive';

  @override
  String get cardNotPresent => 'Отсутствует';

  @override
  String get cardActionSynced => 'Синхронизировано';

  @override
  String get cardActionUpload => 'Загрузить';

  @override
  String get cardActionDownload => 'Скачать';

  @override
  String get pillMonsters => 'монстры';

  @override
  String get pillFriends => 'друзья';

  @override
  String get pillFaints => 'обмороки';

  @override
  String get pillSleeps => 'Сны';

  @override
  String get hiwTitle => 'Как это работает';

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
  String get hiwSyncTitle => 'Как работает синхронизация';

  @override
  String get hiwSyncIntro =>
      'ValleySave использует ваш Google Drive для переноса сохранений между устройствами. Без промежуточных серверов: файлы принадлежат вам.';

  @override
  String get hiwSyncDevice => 'Ваше\nустройство';

  @override
  String get hiwSyncCloud => 'Google\nDrive';

  @override
  String get hiwSyncOtherDevice => 'Другое\nустройство';

  @override
  String get hiwUploadTitle => 'Загрузить сохранение';

  @override
  String get hiwUploadDesc =>
      'При загрузке ValleySave копирует оба файла сохранения (SaveGameInfo + файл фермы) в папку ValleySave/ на Drive.';

  @override
  String get hiwDownloadTitle => 'Скачать сохранение';

  @override
  String get hiwDownloadDesc =>
      'При скачивании ValleySave берёт файлы с Drive и помещает их прямо в папку игры.';

  @override
  String get hiwCompareTitle => 'Что сравнивается?';

  @override
  String get hiwCompareIntro =>
      'Чтобы узнать, какая версия новее, ValleySave использует общее время игры — единственные данные, которые могут только расти.';

  @override
  String get hiwCompareNote =>
      'Перед подтверждением вы также увидите, чтобы принять решение:';

  @override
  String get hiwCompareMoney => 'Текущие деньги и общий заработок';

  @override
  String get hiwCompareMine => 'Уровень шахты';

  @override
  String get hiwCompareSkills => 'Навыки (земледелие, горное дело, бой…)';

  @override
  String get hiwCompareRelations => 'Друзья, убитые монстры, обмороки';

  @override
  String get hiwCompareStamina => 'Выносливость и здоровье';

  @override
  String get hiwCompareNotShown =>
      'Они не отображаются — они изменяются в любую сторону и не указывают, какое сохранение новее.';

  @override
  String get hiwCompareNotShownExamples =>
      'Состояние посевов и животных, инвентарь и предметы, отдельные отношения';

  @override
  String get hiwCompareWarning =>
      'Они не отображаются — они изменяются в любую сторону и не указывают, какое сохранение новее.';

  @override
  String get hiwConflictTitle => 'Если вы играете без синхронизации';

  @override
  String get hiwConflictDesc =>
      'Если вы продвигаетесь на мобильном и ПК без синхронизации между сессиями, вы получаете две версии одного сохранения.';

  @override
  String get hiwConflictNoMerge =>
      'Их нельзя объединить. ValleySave всегда показывает обе версии, чтобы вы могли выбрать, какую оставить.';

  @override
  String get hiwConflictMobile => 'Мобильный';

  @override
  String get hiwConflictVersionA => 'версия А';

  @override
  String get hiwConflictPC => 'ПК';

  @override
  String get hiwConflictVersionB => 'версия Б';

  @override
  String get hiwDeleteTitle => 'Если сохранение удалено';

  @override
  String get hiwDeleteDesc =>
      'Когда вы удаляете сохранение с Drive, оно не исчезает сразу: оно перемещается в корзину Google Drive.';

  @override
  String get hiwCompatTitle => 'Совместимость платформ';

  @override
  String get hiwCompatAndroidAccess => 'ДОСТУП НА ANDROID';

  @override
  String get hiwShizukuTitle => 'С Shizuku';

  @override
  String get hiwShizukuSubtitle =>
      'Настройте один раз. После этого ValleySave синхронизируется сам, без вашего участия.';

  @override
  String get hiwShizukuBadge => 'АВТОМАТИЧЕСКИ · РЕКОМЕНДУЕТСЯ';

  @override
  String get hiwShizukuDone =>
      '✓  Готово. С этого момента скачивание и загрузка сохранений выполняются напрямую, как на компьютере.';

  @override
  String get hiwShizukuNote =>
      'Сопряжение — только в первый раз. Новые версии Shizuku активируются сами после перезапуска телефона.';

  @override
  String get hiwBridgeTitle => 'Ручной мост';

  @override
  String get hiwBridgeSubtitle =>
      'Работает только на Android 11 и 12. Не нужно ничего дополнительно устанавливать; вместо этого вы копируете сохранение вручную через «Файлы» каждый раз при синхронизации.';

  @override
  String get hiwBridgeBadge => 'РУЧНАЯ АЛЬТЕРНАТИВА · ANDROID 11-12';

  @override
  String get hiwBridgeSaveFolder => 'Папка Stardew';

  @override
  String get hiwBridgeValleySaveFolder => 'Папка ValleySave';

  @override
  String get hiwBridgeNote =>
      'Это работает, потому что системное приложение «Файлы» может получить доступ к этим папкам (ValleySave не может).';

  @override
  String get hiwTipAlwaysShow =>
      'Вы всегда увидите, что находится на Drive, прежде чем перезаписать, чтобы сравнить.';

  @override
  String get hiwTipWithoutUpload =>
      'Без загрузки ни одно другое устройство не увидит ваш последний прогресс.';

  @override
  String get hiwTipComparison =>
      'Вы увидите сравнение между локальным и Drive перед подтверждением.';

  @override
  String get hiwTipDownloadOverwrite =>
      'Скачивание перезаписывает локальное сохранение. Любой несинхронизированный прогресс будет потерян.';

  @override
  String get hiwTipSync =>
      'Всегда загружайте перед переключением устройств и скачивайте при прибытии.';

  @override
  String get hiwTipDeletion =>
      'У вас есть 30 дней, чтобы восстановить его из корзины Drive, прежде чем оно будет удалено навсегда.';

  @override
  String get hiwPrivacyLink => 'Политика конфиденциальности и использование';

  @override
  String get emptyNoSaves => 'Сохранения не найдены';

  @override
  String get emptyNoSavesHint =>
      'Локальные сохранения не могут быть прочитаны на этом устройстве';

  @override
  String get bridgeTitle => 'Принесите ваши сохранения';

  @override
  String get bridgeDesc =>
      'Чтобы увидеть и загрузить локальные сохранения, скопируйте их с помощью «Файлов» из папки Stardew в папку ValleySave. Затем потяните для обновления.';

  @override
  String get bridgeRefresh => 'Обновить';

  @override
  String get bridgeChangeMode => 'Изменить метод';

  @override
  String get loaderLoading => 'ЗАГРУЗКА';

  @override
  String get loaderConnecting => 'подключение к Drive…';

  @override
  String get chooserTitle => 'Выберите способ подключения';

  @override
  String get chooserAutomatic => 'Автоматический · Рекомендуется';

  @override
  String get chooserManual => 'Ручная альтернатива · Android 11-12';

  @override
  String get shizukuStepTitle => 'Настройка Shizuku';

  @override
  String get shizukuStep1Title => 'Установить Shizuku';

  @override
  String get shizukuStep1Desc => 'Скачайте из Play Store или GitHub';

  @override
  String get shizukuStep2Title => 'Активировать Shizuku';

  @override
  String get shizukuStep2Desc =>
      'Запустите приложение и предоставьте разрешения';

  @override
  String get shizukuStep3Title => 'Предоставить разрешение';

  @override
  String get shizukuStep3Desc => 'ValleySave запросит доступ';

  @override
  String get shizukuDone =>
      '✓  Готово. С этого момента скачивание и загрузка сохранений работают напрямую, как на компьютере.';

  @override
  String get dlgDeleteDriveTitle => 'Удалить с Drive';

  @override
  String get dlgDeleteLocalTitle => 'Удалить с этого устройства';

  @override
  String get dlgDownloadTitle => 'Скачать сохранение';

  @override
  String get dlgUploadTitle => 'Загрузить сохранение';

  @override
  String get dlgUploadOverwrite => 'Это перезапишет ваше локальное сохранение';

  @override
  String get dlgGotIt => 'Понятно';

  @override
  String get dlgCopyDest => 'Путь назначения копирования';

  @override
  String get previewColDayYear => 'День/Год';

  @override
  String get previewColTime => 'Время игры';

  @override
  String get previewColMoney => 'Монеты';

  @override
  String get previewColTotal => 'Всего';

  @override
  String get previewColFarming => 'Земледелие';

  @override
  String get previewColForaging => 'Собирательство';

  @override
  String get previewColMining => 'Горное дело';

  @override
  String get previewColFishing => 'Рыбалка';

  @override
  String get previewColCombat => 'Бой';

  @override
  String get previewColFriends => 'Друзья';

  @override
  String get previewColMonsters => 'Монстры';

  @override
  String get previewColFaints => 'Обмороки';

  @override
  String get previewColMine => 'Шахта';

  @override
  String get previewColUnexplored => 'Не исследовано';

  @override
  String get previewLocalLabel => 'НА ЭТОМ УСТРОЙСТВЕ';

  @override
  String get previewDriveLabel => 'НА DRIVE';

  @override
  String get previewFromDrive => 'С DRIVE';

  @override
  String get previewFromDevice => 'С ЭТОГО УСТРОЙСТВА';

  @override
  String versionMismatch(String local, String drive) {
    return 'Разные версии: локальная $local · Drive $drive…';
  }

  @override
  String get snackPathCopied => 'Путь скопирован';

  @override
  String get snackDestCopied => 'Путь назначения скопирован';

  @override
  String get snackDownloaded => 'Сохранение загружено в игру';

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
  String get snackSessionExpired => 'Сессия Drive истекла. Переподключитесь';

  @override
  String snackUploadError(String error) {
    return 'Ошибка загрузки: $error';
  }

  @override
  String snackDownloadError(String error) {
    return 'Ошибка скачивания: $error';
  }

  @override
  String snackDeleteError(String error) {
    return 'Ошибка удаления: $error';
  }

  @override
  String snackTrashed(String saveName) {
    return '\"$saveName\" перемещено в корзину Drive. У вас есть 30 дней для восстановления.';
  }

  @override
  String snackDeletedLocal(String saveName) {
    return '\"$saveName\" удалено с этого устройства';
  }

  @override
  String get snackShizukuRequired => 'Активируйте Shizuku…';

  @override
  String get snackWriteError =>
      'Не удалось записать в игру. Некоторые телефоны блокируют /Android/data даже с Shizuku.';

  @override
  String get snackPlatformNotSupported =>
      'Эта платформа пока не поддерживает запись локальных сохранений.';

  @override
  String get snackWirelessDebugHint =>
      'Откройте вручную: Настройки → Для разработчиков → Беспроводная отладка.';

  @override
  String get snackOpenShizukuApp => 'Откройте Shizuku из списка приложений.';

  @override
  String get hiwTipDeletePermanent =>
      'ValleySave не может восстановить навсегда удалённые сохранения. Файлы на Drive — ваша ответственность.';

  @override
  String get hiwCompatAchievements =>
      'Достижения Steam и Google Play не переносятся. Каждая платформа отслеживает только достижения, полученные в реальном времени — файл сохранения не активирует их ретроактивно.';

  @override
  String get hiwCompatOverwrite =>
      'Если синхронизировать с двух устройств без определённого порядка, одно сохранение может перезаписать другое. Всегда загружайте перед скачиванием.';

  @override
  String get hiwCompatVersions =>
      'Сохранения из разных версий игры могут не загружаться корректно. ValleySave предупредит вас, если обнаружит несовпадение версий перед скачиванием.';

  @override
  String get hiwCompatMods =>
      'Моды SMAPI добавляют дополнительные данные в сохранение. Если загрузить модифицированное сохранение на устройстве, где эти моды не установлены, игра может вылететь или потерять данные мода.\n\nНа Android SMAPI также можно установить для использования модов.';

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
  String get hiwComparePrimary => 'Общее время игры';

  @override
  String get hiwCompareNoShown1 => 'Состояние посевов и животных';

  @override
  String get hiwCompareNoShown2 => 'Инвентарь и предметы';

  @override
  String get hiwCompareNoShown3 => 'Отдельные отношения';

  @override
  String get hiwShizuku1 => 'Установите Shizuku (Play Store или APK с GitHub).';

  @override
  String get hiwShizuku2 =>
      'Активируйте через Беспроводную отладку — ValleySave проведёт вас шаг за шагом.';

  @override
  String get hiwShizuku3 => 'Предоставьте разрешение ValleySave по запросу.';

  @override
  String get hiwBridge1 =>
      'Скачать с Drive: ValleySave помещает сохранение в свою папку. Вы копируете его через «Файлы» в папку Stardew.';

  @override
  String get hiwBridge2 =>
      'Загрузить на Drive: скопируйте сохранение из папки Stardew в папку ValleySave. ValleySave обнаружит и загрузит его.';

  @override
  String get snackShizukuBattery =>
      'Настройки → Приложения → Shizuku → Аккумулятор → Без ограничений.';

  @override
  String snackDriveError(String error) {
    return 'Drive: $error';
  }

  @override
  String get dlgDeleteLocalWarning =>
      '⚠️ Если вы не загрузили на Drive, файл будет потерян навсегда. Восстановление невозможно.';

  @override
  String get dlgDelete => 'Удалить';

  @override
  String get dlgDownloadButton => 'Скачать';

  @override
  String get dlgUploadButton => 'Загрузить';

  @override
  String get dlgBridgeCopyTitle => 'Скопировать сохранение в игру';

  @override
  String dlgBridgeCopyDesc(String saveName) {
    return 'Сохранение готово. С помощью «Файлов» скопируйте папку \"$saveName\" и вставьте её в папку Stardew.';
  }

  @override
  String get labelFrom => 'Откуда';

  @override
  String get labelTo => 'Куда';

  @override
  String dlgDownloadNewDesc(String saveName, int day, String playtime) {
    return '\"$saveName\" (День $day, $playtime) будет скопировано на это устройство.';
  }

  @override
  String dlgDownloadOverwrite(String saveName) {
    return 'Это ПЕРЕЗАПИШЕТ ваше локальное сохранение \"$saveName\".';
  }

  @override
  String dlgUploadNewDesc(String saveName, int day, String playtime) {
    return '\"$saveName\" (День $day, $playtime) будет загружено на ваш Drive.';
  }

  @override
  String dlgUploadOverwriteDrive(String saveName) {
    return 'Это ПЕРЕЗАПИШЕТ версию Drive \"$saveName\".';
  }

  @override
  String get pathLabelFromStardew => 'Откуда (Stardew)';

  @override
  String get pathLabelToValleySave => 'Куда (ValleySave)';

  @override
  String get chooserDesc =>
      'Android защищает папку игры. Выберите, как предоставить ValleySave доступ — вы можете изменить это в любое время.';

  @override
  String get chooserShizukuDesc =>
      'Настраивается один раз. После этого ValleySave синхронизируется сам, без вашего участия. Единственный надёжный метод на Android 13+.';

  @override
  String get chooserManualBadge => 'ТОЛЬКО ANDROID 11-12';

  @override
  String get chooserBridgeDesc =>
      'Копируйте сохранения через «Файлы». Без дополнительной установки. Только на Android 11 и 12.';

  @override
  String get chooserRootBadge => 'ROOT';

  @override
  String get chooserRootTitle => 'Root-доступ';

  @override
  String get chooserRootDesc =>
      'Для устройств с root (Magisk / SuperSU). Подтвердите запрос root один раз — далее автоматически.';

  @override
  String get snackRootDenied => 'Root-доступ отклонён. Попробуйте Shizuku.';

  @override
  String get shizukuGateSubtitle =>
      'Настраивается один раз · только первый раз';

  @override
  String get shizukuStatusLabel => 'Shizuku активен';

  @override
  String get shizukuStatusRunning => 'Подключён и ожидает.';

  @override
  String get shizukuStatusNotDetected => 'Ещё не обнаружен.';

  @override
  String get shizukuPermLabel => 'Разрешение предоставлено';

  @override
  String get shizukuPermGranted => 'ValleySave уже имеет доступ.';

  @override
  String get shizukuPermNotGranted => 'Необходимо авторизовать ValleySave.';

  @override
  String get shizukuGrant => 'предоставить';

  @override
  String get shizukuGuideHeader => 'ПОШАГОВОЕ РУКОВОДСТВО';

  @override
  String get shizukuStep1DescFull =>
      'Бесплатно. Если Google Play блокирует его на вашем телефоне, используйте официальный APK с GitHub.';

  @override
  String get btnPlayStore => 'Play Store';

  @override
  String get btnApkGithub => 'APK GitHub';

  @override
  String get shizukuStep2TitleFull => 'Включить параметры разработчика';

  @override
  String get shizukuStep2DescFull =>
      'Настройки → Сведения о телефоне → Сведения о ПО → нажмите \"Номер сборки\" 7 раз.';

  @override
  String get shizukuStep3TitleFull => 'Включить беспроводную отладку';

  @override
  String get shizukuStep3DescFull =>
      'Кнопка перенесёт вас туда и выделит пункт. Включите его (ВКЛ). Затем нажмите \"Сопряжение устройства с кодом сопряжения\" — на экране появится 6-значный код.';

  @override
  String get btnOpenAndHighlight => 'Открыть и выделить';

  @override
  String get shizukuStep4Title => 'Сопрягите и ЗАПУСТИТЕ Shizuku';

  @override
  String get shizukuStep4Desc =>
      'Откройте Shizuku → \"Запустить через беспроводную отладку\" → \"Сопряжение с кодом сопряжения\". Shizuku отправит уведомление о том, что ожидает. Введите 6-значный код с экрана беспроводной отладки. После сопряжения нажмите ЗАПУСТИТЬ — без этого последнего нажатия Shizuku не будет активен.';

  @override
  String get btnOpenShizuku => 'Открыть Shizuku';

  @override
  String get shizukuStep5Title =>
      'Установить аккумулятор Shizuku без ограничений';

  @override
  String get shizukuStep5Desc =>
      'Откройте сведения о приложении → Аккумулятор → Без ограничений. Иначе система закроет Shizuku в фоне и вам придётся снова нажать Запустить.';

  @override
  String get btnShizukuAppInfo => 'Сведения о Shizuku';

  @override
  String get shizukuStep6DescActive =>
      'Shizuku активен. Нажмите кнопку для авторизации.';

  @override
  String get shizukuStep6DescWaiting =>
      'Доступно после активации Shizuku (шаг 4).';

  @override
  String get btnGrantPermission => 'Предоставить разрешение';

  @override
  String get btnCheckShizuku => 'Готово · Проверить';

  @override
  String get statusDone => 'выполнено';

  @override
  String get statusPending => 'ожидает';

  @override
  String get latestBadge => '· ПОСЛЕДНЕЕ СОХРАНЕНИЕ ·';

  @override
  String saveDateLabel(String season, int year) {
    return '$season · Год $year';
  }

  @override
  String get petCat => 'Кот';

  @override
  String get petDog => 'Пёс';

  @override
  String get houseBasic => 'Простой дом';

  @override
  String get houseKitchen => 'С кухней';

  @override
  String get houseBedroom => 'Со спальней';

  @override
  String get houseCellar => 'С погребом';

  @override
  String houseLevelN(int level) {
    return 'Ур. $level';
  }

  @override
  String get tooltipLaunchGame => 'Играть';

  @override
  String get hiwLaunchTitle => 'Запустить игру';

  @override
  String get hiwLaunchDesc =>
      'Кнопка ▶ в верхней панели раздела Мои сохранения открывает Stardew Valley прямо из приложения.';

  @override
  String get hiwLaunchTipWindows =>
      'В Windows, если игра не найдена автоматически, укажите путь в Настройки → Игра.';

  @override
  String get hiwLaunchTipAndroid =>
      'На Android открывает игру, если она установлена.';

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
  String get settingsGameSection => 'Игра';

  @override
  String get settingsGameExePath => 'Исполняемый файл Stardew Valley';

  @override
  String get settingsGameExeNotFound => 'Не найдено автоматически';

  @override
  String get settingsGameExeBrowse => 'Обзор…';

  @override
  String get settingsGameExeSaved => 'Путь сохранён';

  @override
  String get snackLaunchError => 'Не удалось открыть игру';

  @override
  String get makeHostAction => 'СДЕЛАТЬ ХОЗЯИНОМ';

  @override
  String get makeHostExperimental => 'ЭКСПЕРИМЕНТАЛЬНО';

  @override
  String get makeHostDialogTitle => 'Сменить хозяина';

  @override
  String makeHostDialogIntro(String playerName, String farmName) {
    return '$playerName станет хозяином фермы $farmName.';
  }

  @override
  String get makeHostNewCopyNote =>
      'Создаётся новое сохранение. Затем вы решите, что делать с оригиналом.';

  @override
  String makeHostMoveCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other:
          'На ферме будет перемещено $count объекта, чтобы освободить место для дома. Ничего не удаляется.',
      many:
          'На ферме будет перемещено $count объектов, чтобы освободить место для дома. Ничего не удаляется.',
      few:
          'На ферме будут перемещены $count объекта, чтобы освободить место для дома. Ничего не удаляется.',
      one:
          'На ферме будет перемещён $count объект, чтобы освободить место для дома. Ничего не удаляется.',
    );
    return '$_temp0';
  }

  @override
  String get makeHostHouseWarning =>
      'Дом нового хозяина будет выглядеть как главный фермерский дом игры. Внешний вид хижины не поддерживается без модов.';

  @override
  String get makeHostConfirmButton => 'Сделать хозяином';

  @override
  String makeHostSuccess(String playerName) {
    return 'Новое сохранение создано: $playerName теперь хозяин.';
  }

  @override
  String get hostSwapErrInvalid =>
      'У этого сохранения неожиданная структура. Ничего не изменено.';

  @override
  String get hostSwapErrNoSpace =>
      'На ферме нет свободного места для перемещения объектов. Ничего не изменено.';

  @override
  String get hostSwapErrWrite =>
      'Не удалось записать новое сохранение (диск/права доступа). Ничего не изменено.';

  @override
  String get hostSwapErrValidation =>
      'Проверка нового сохранения не удалась, оно было отменено. Оригинал не повреждён.';
}
