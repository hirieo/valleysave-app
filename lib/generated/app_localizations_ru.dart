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
  String get updateNeedsPermission =>
      'Включите «Установка неизвестных приложений» для ValleySave и снова нажмите «Обновить»';

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
    return 'Отключиться от $email';
  }

  @override
  String get connectedAsPrefix => 'Подключено как';

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
  String get exportAction => 'Экспортировать';

  @override
  String get exportSuccess => 'Сохранение экспортировано.';

  @override
  String exportError(String error) {
    return 'Не удалось экспортировать сохранение: $error';
  }

  @override
  String get importAction => 'Импортировать сохранение';

  @override
  String importSuccess(String playerName) {
    return 'Сохранение $playerName импортировано.';
  }

  @override
  String get importErrInvalidZip =>
      'Этот файл не является допустимым zip-архивом.';

  @override
  String get importErrUnsafePath =>
      'У этого файла небезопасная структура, он был отклонён.';

  @override
  String get importErrTooLarge => 'Этот файл слишком большой для импорта.';

  @override
  String get importErrNotASave =>
      'Этот файл не содержит распознаваемого сохранения.';

  @override
  String get importErrWrite =>
      'Не удалось записать импортированное сохранение (диск/права доступа).';

  @override
  String get importErrBackupFailed =>
      'Не удалось создать резервную копию. Ничего не импортировано.';

  @override
  String get importConflictTitle => 'Сохранение с таким именем уже существует';

  @override
  String get importConflictBody =>
      'Импорт заменит существующую локальную копию. Отменить это нельзя.';

  @override
  String get importConflictConfirm => 'Перезаписать';

  @override
  String get shareAction => 'Поделиться';

  @override
  String get shareUploadFirstCta => 'Сначала загрузить';

  @override
  String get shareDialogTitle => 'Поделиться сохранением';

  @override
  String get shareEmailPlaceholder => 'имя@пример.com';

  @override
  String get shareInfoNote =>
      'Общий доступ даёт право только просматривать и скачивать. Только вы можете редактировать или удалять свою копию на Drive.';

  @override
  String get shareRoleReader => 'Только чтение';

  @override
  String get shareRoleWriter => 'Разрешить синхронизацию';

  @override
  String get shareInfoNoteCoop =>
      'Только чтение позволяет просматривать и скачивать. Разрешить синхронизацию позволяет перезаписывать вашу копию на Drive — удалить её они никогда не смогут.';

  @override
  String get shareConfirmButton => 'Поделиться';

  @override
  String shareSuccess(String email) {
    return 'Доступ предоставлен $email.';
  }

  @override
  String get manageAccessTitle => 'Люди с доступом';

  @override
  String get manageAccessEmpty => 'Больше ни у кого пока нет доступа.';

  @override
  String get manageAccessRoleLabel => 'Доступ';

  @override
  String get manageAccessRevoke => 'Отозвать';

  @override
  String manageAccessRevokeConfirm(String email) {
    return 'Убрать доступ у $email? Любая уже скачанная локальная копия остаётся у него.';
  }

  @override
  String get driveOnlyControlsYourCopy =>
      'Общий доступ управляет только вашей копией на Drive. Если кто-то её скачает, эта копия становится его.';

  @override
  String get driveOnlyControlsYourCopyCoop =>
      'Синхронизация управляет вашей копией на Drive — те, кому вы разрешили синхронизацию, могут её перезаписать, но никогда не могут удалить.';

  @override
  String get sharedWithMeTitle => 'Общие со мной';

  @override
  String get sharedWithMeEmpty =>
      'Пока ничего не предоставлено вам в общий доступ.';

  @override
  String get sharedWithMeAdd => 'Добавить общее сохранение';

  @override
  String sharedWithMeOwnedBy(String email) {
    return 'Предоставлено $email';
  }

  @override
  String get sharedWithMeRoleSync => 'Синхронизирует';

  @override
  String get sharedWithMeRoleRead => 'Только чтение';

  @override
  String get sharedWithMeSync => 'Синхронизировать';

  @override
  String get sharedWithMeDownload => 'Скачать';

  @override
  String get sharedWithMeRemove => 'Отключить';

  @override
  String sharedWithMeRemoveConfirm(String email) {
    return 'Вы перестанете синхронизироваться с Drive $email, но можете добавить его снова в любой момент — общий доступ сохраняется. Ваша локальная копия остаётся обычным кооп-сохранением.';
  }

  @override
  String sharedLeaveConfirm(Object email) {
    return 'Вы по-настоящему потеряете доступ к этому сохранению. Вы не сможете добавить его снова, если $email не предоставит доступ ещё раз. Ваша локальная копия остаётся обычным кооп-сохранением.';
  }

  @override
  String get sharedManageButton => 'Управление';

  @override
  String get sharedManageDialogTitle => 'Управление общими сохранениями';

  @override
  String get sharedManageDialogHint =>
      'Здесь вы можете по-настоящему покинуть общее сохранение.';

  @override
  String get sharedLeaveButton => 'Покинуть общее сохранение';

  @override
  String sharedLeaveSuccess(Object email) {
    return 'Вы покинули общее сохранение $email.';
  }

  @override
  String sharedWithMeSyncConfirm(String email) {
    return 'Перезаписать копию $email на Drive вашим локальным сохранением?';
  }

  @override
  String sharedAccessReadOnly(String email) {
    return '$email установил(а) для вас доступ только для чтения — вы можете просматривать и скачивать, но не синхронизировать на его Drive.';
  }

  @override
  String get sharedWithMeRevoked => 'У вас больше нет доступа';

  @override
  String sharedRevokedDialogBody(String email, String farmName) {
    return '$email перестал(а) делиться с вами $farmName. Ваша локальная копия и копия на вашем Drive остаются как есть, теперь в разделе Мои сохранения.';
  }

  @override
  String get sharedRevokedAccept => 'Принять';

  @override
  String get sharedSelfCleanupTitle => 'Запись исправлена';

  @override
  String sharedSelfCleanupBody(String farmName) {
    return '$farmName по ошибке отображалось как предоставленное вам — на самом деле оно ваше. Это исправлено, теперь оно в разделе Мои сохранения.';
  }

  @override
  String get sharedWithMeUploadOwn => 'Загрузить на мой Drive';

  @override
  String get sharedDownloadOwn => 'Скачать с моего Drive';

  @override
  String get sharedStatusOwnDriveAhead => 'Ваш Drive впереди — скачайте его';

  @override
  String get sharedSyncBoth => 'Загрузить на оба Drive';

  @override
  String get sharedSideMyDrive => 'МОЙ DRIVE';

  @override
  String sharedSideOwnerDrive(String email) {
    return 'DRIVE У $email';
  }

  @override
  String sharedSideDate(int day, int year) {
    return 'День $day · Год $year';
  }

  @override
  String get sharedStatusSyncedNoOwnDrive =>
      'Синхронизировано с владельцем · нет копии на вашем Drive';

  @override
  String get sharedStatusAheadNoOwnDrive =>
      'Вы впереди · нет копии на вашем Drive';

  @override
  String sharedStatusOwnerAheadNoOwnDrive(String email) {
    return '$email впереди · нет копии на вашем Drive';
  }

  @override
  String get sharedStatusAllSynced => 'Синхронизировано (локально + оба Drive)';

  @override
  String get sharedStatusAheadBoth => 'Вы впереди на обоих Drive';

  @override
  String get sharedStatusMixed =>
      'Рассинхронизировано — проверьте каждый Drive';

  @override
  String get sharedStatusFullySynced => 'Полностью синхронизировано';

  @override
  String get sharedStatusSyncedOwn => 'Мой Drive синхронизирован';

  @override
  String get sharedStatusSyncedOwner => 'Общий Drive синхронизирован';

  @override
  String get sharedStatusNotCloud => 'Только на этом устройстве';

  @override
  String sharedStatusOwnerAhead(Object email) {
    return 'Drive у $email впереди';
  }

  @override
  String get sharedStatusBothAhead => 'Оба Drive впереди';

  @override
  String get sharedStatusLocalMissing => 'Нет на этом устройстве';

  @override
  String sharedStatusOwnerUnavailable(Object email) {
    return 'Не удалось проверить Drive у $email';
  }

  @override
  String get sharedStatusWorking => 'Синхронизация…';

  @override
  String get sharedSideUnavailable => 'Не удалось проверить';

  @override
  String get sharedSyncChooseTitle => 'Где вы хотите синхронизировать?';

  @override
  String get sharedSyncChooseBody =>
      'Выберите, какие облачные копии обновить сохранением с этого устройства.';

  @override
  String get sharedSyncTargetOwn => 'Мой Drive';

  @override
  String sharedSyncTargetOwner(Object email) {
    return 'Drive у $email';
  }

  @override
  String get sharedSyncTargetBoth => 'Оба Drive';

  @override
  String get sharedDownloadChooseTitle => 'Какую копию вы хотите скачать?';

  @override
  String get sharedDownloadChooseBody =>
      'Впереди больше одной копии. Выберите, какую перенести на это устройство.';

  @override
  String get sharedDownloadSourceOwn => 'С моего Drive';

  @override
  String sharedDownloadSourceOwner(Object email) {
    return 'С Drive у $email';
  }

  @override
  String get sharedWithMePickerTitle => 'Добавить общее сохранение';

  @override
  String get sharedPickerEmptyHint =>
      'Здесь появляется то, чем с вами поделился другой игрок через Drive.';

  @override
  String get sharedPickerAddButton => 'Добавить';

  @override
  String get sharedOriginBadge => 'Общее';

  @override
  String sharedOriginFrom(String email) {
    return 'от $email';
  }

  @override
  String get swapBackupDialogTitle => 'Резервная копия создана';

  @override
  String get swapBackupDialogBody =>
      'Предыдущая версия была сохранена как zip-файл. Что вы хотите с ней сделать?';

  @override
  String get swapBackupUpload => 'Загрузить на Drive';

  @override
  String get swapBackupLocalOnly => 'Оставить на этом устройстве';

  @override
  String get swapBackupDeleteNow => 'Удалить сейчас';

  @override
  String get swapBackupUploadOk => 'Резервная копия загружена на Drive.';

  @override
  String swapBackupUploadErr(String error) {
    return 'Не удалось загрузить резервную копию: $error';
  }

  @override
  String get swapBackupLocalOnlySnack =>
      'Резервная копия сохранена на этом устройстве.';

  @override
  String get backupsAction => 'Резервные копии';

  @override
  String backupsScreenTitle(String farmName) {
    return 'Резервные копии $farmName';
  }

  @override
  String get backupsEmpty => 'Резервных копий пока нет.';

  @override
  String get backupsRestore => 'Восстановить';

  @override
  String get backupsRestoreConfirmTitle => 'Восстановить эту резервную копию?';

  @override
  String get backupsRestoreConfirmBody =>
      'Это перезапишет текущее сохранение этой более ранней версией. Отменить нельзя.';

  @override
  String get backupsDelete => 'Удалить';

  @override
  String get backupsDeleteConfirmTitle => 'Удалить эту резервную копию?';

  @override
  String get backupsDeleteConfirmBody =>
      'Она будет удалена везде, где существует (это устройство и Drive, если загружена). Отменить нельзя.';

  @override
  String get backupsRestoreOk => 'Резервная копия восстановлена.';

  @override
  String get backupsRestoreManualTitle => 'Восстановить вручную';

  @override
  String get backupsRestoreManualBody =>
      'В режиме моста ValleySave не может автоматически записывать в папку игры. Извлеките zip-файл этой резервной копии в папку Saves Stardew Valley самостоятельно или переключитесь на режим Root/Shizuku в Параметрах для автоматического восстановления.';

  @override
  String backupsRestoreErr(String error) {
    return 'Не удалось восстановить резервную копию: $error';
  }

  @override
  String backupsDeleteErr(String error) {
    return 'Не удалось удалить резервную копию: $error';
  }

  @override
  String get backupsCreate => 'Создать локальную резервную копию';

  @override
  String get backupsCreateLocalHint =>
      'Резервные копии сначала создаются на этом устройстве. Позже вы сможете загрузить их на Drive.';

  @override
  String get backupsCreateOk => 'Резервная копия создана.';

  @override
  String backupsCreateErr(String error) {
    return 'Не удалось создать резервную копию: $error';
  }

  @override
  String get backupsDownload => 'Скачать';

  @override
  String get backupsDownloadOk => 'Резервная копия скачана на это устройство.';

  @override
  String backupsDownloadErr(String error) {
    return 'Не удалось скачать резервную копию: $error';
  }

  @override
  String get backupsCopyOwn => 'Скопировать на мой Drive';

  @override
  String get backupsUploadOwn => 'На мой Drive';

  @override
  String get backupsUploadShared => 'На общий Drive';

  @override
  String get backupsUploadOk => 'Резервная копия загружена.';

  @override
  String backupsUploadErr(String error) {
    return 'Не удалось загрузить резервную копию: $error';
  }

  @override
  String get backupsLocationLocal => 'Это устройство';

  @override
  String get backupsLocationOwnDrive => 'Мой Drive';

  @override
  String get backupsLocationSharedDrive => 'Общий Drive';

  @override
  String get backupsDeleteChooseBody =>
      'Выберите, откуда именно её удалить. Показаны только места, где эта резервная копия существует.';

  @override
  String get backupsDeleteLocalOnly => 'Только с этого устройства';

  @override
  String get backupsDeleteOwnOnly => 'Только с моего Drive';

  @override
  String get backupsDeleteSharedOnly => 'Только с общего Drive';

  @override
  String get backupsDeleteAll => 'Со всех копий';

  @override
  String deleteUnifiedTitle(String farmName) {
    return 'Удалить $farmName?';
  }

  @override
  String get deleteChooseLocationBody =>
      'Выберите откуда. Копия на этом устройстве удаляется навсегда; копия на Drive перемещается в корзину (30 дней).';

  @override
  String deleteDriveContextTitle(String farmName) {
    return 'Удалить $farmName с Drive?';
  }

  @override
  String get deleteDriveContextBody =>
      'Копия на Drive переместится в корзину, где её можно восстановить в течение 30 дней.';

  @override
  String get deleteDriveLocalKept =>
      'Копия на этом устройстве останется без изменений.';

  @override
  String deleteLocalContextTitle(String farmName) {
    return 'Удалить $farmName с этого устройства?';
  }

  @override
  String get deleteLocalContextBody =>
      'Копия на этом устройстве будет удалена навсегда.';

  @override
  String deleteLocalDriveCurrent(String date) {
    return 'Ваша копия на Drive актуальна ($date) и останется доступной.';
  }

  @override
  String deleteLocalDriveAhead(String date) {
    return 'Ваша копия на Drive новее ($date) и останется доступной.';
  }

  @override
  String deleteLocalDriveOlder(String driveDate, String localDate) {
    return 'Ваша копия на Drive старее ($driveDate); это устройство на $localDate.';
  }

  @override
  String deleteLocalBackupAvailable(int count) {
    return 'Доступно $count локальных резервных копий на случай, если вам понадобится более ранняя копия.';
  }

  @override
  String get deleteLocalNoRecovery =>
      'Нет ни копии на Drive, ни локальной резервной копии, из которой можно восстановить эту игру.';

  @override
  String get deleteOptionLocalOnly => 'Только с этого устройства';

  @override
  String get deleteOptionDriveOnly => 'Только с Drive';

  @override
  String get deleteOptionBoth => 'Из обеих копий (устройство + Drive)';

  @override
  String get viewPlayersHint => 'Посмотреть игроков';

  @override
  String snackDeletedBoth(String saveName) {
    return '\"$saveName\" удалено с этого устройства и перемещено в корзину Drive.';
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
  String get hiwConnectTitle => 'Подключите свой аккаунт';

  @override
  String get hiwConnectDesc =>
      'ValleySave использует ваш аккаунт Google для хранения сохранений в приватной папке ValleySave на вашем собственном Drive.';

  @override
  String get hiwConnectStepGoogle => 'Аккаунт\nGoogle';

  @override
  String get hiwConnectStepDrive => 'Папка ValleySave\nсоздана';

  @override
  String get hiwConnectStepReady => 'Готово к\nсинхронизации';

  @override
  String get hiwConnectTipOwnership =>
      'Только вы можете редактировать или удалять свои копии на Drive — ValleySave только читает и записывает в пределах своей собственной папки.';

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
  String get overwriteWhatChanges => 'Что изменится';

  @override
  String get overwriteTagOverwritten => 'БУДЕТ ПЕРЕЗАПИСАНО';

  @override
  String get overwriteNewCopyTag => 'НОВОЕ';

  @override
  String overwriteDeltaPhrase(int days, String time) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: '$days дня и $time',
      many: '$days дней и $time',
      few: '$days дня и $time',
      one: '1 день и $time',
      zero: '$time',
    );
    return '$_temp0';
  }

  @override
  String overwriteVerdictAhead(String delta) {
    return 'Вы впереди на $delta. Это безопасно.';
  }

  @override
  String get overwriteVerdictMoneySpent =>
      '💰 Текущие деньги уменьшились, но общий прогресс продвигается вперёд — вероятно, вы потратили их на что-то. Это не настоящая потеря.';

  @override
  String overwriteVerdictNegligible(String delta) {
    return 'Минимальная разница ($delta). Подойдёт любая из двух копий.';
  }

  @override
  String overwriteVerdictDanger(String delta, String target) {
    return '⚠️ Вы потеряете $delta прогресса в $target. Проверьте перед тем, как продолжить.';
  }

  @override
  String get overwriteConfirmTitleUpload => 'Подтвердить загрузку?';

  @override
  String get overwriteConfirmTitleDownload => 'Подтвердить скачивание?';

  @override
  String overwriteConfirmBody(String delta, String target) {
    return 'Вы потеряете $delta в $target. Это действие нельзя отменить.';
  }

  @override
  String get overwriteConfirmButtonUpload => 'Подтвердить загрузку';

  @override
  String get overwriteConfirmButtonDownload => 'Подтвердить скачивание';

  @override
  String get overwriteDangerButtonUpload => '⚠️ Всё равно загрузить';

  @override
  String get overwriteDangerButtonDownload => '⚠️ Всё равно скачать';

  @override
  String overwriteIdenticalSummary(int count, String list) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '✓ $count одинаковых',
      many: '✓ $count одинаковых',
      few: '✓ $count одинаковых',
      one: '✓ 1 одинаковое',
    );
    return '$_temp0 — $list';
  }

  @override
  String overwriteUploadToOwner(String email) {
    return 'Загрузить на Drive $email';
  }

  @override
  String get overwriteUploadBoth => 'Загрузить на оба Drive';

  @override
  String get overwriteConfirmTitleBoth => 'Подтвердить обе загрузки?';

  @override
  String overwriteConfirmBodyBoth(String delta, String targets) {
    return 'Вы потеряете $delta в $targets. Это действие нельзя отменить.';
  }

  @override
  String overwriteBothDestinationsLabel(String first, String second) {
    return '$first и $second';
  }

  @override
  String get sharedTargetOwnDrive => 'ваш Drive';

  @override
  String sharedStatusLocalAhead(String targets) {
    return 'Вы впереди в $targets';
  }

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
      'Не удалось подготовить сохранение. На диске ничего не изменилось';

  @override
  String get snackReplaceValidationFailed =>
      'Скачанное сохранение выглядит недействительным или неполным. На диске ничего не изменилось';

  @override
  String get snackReplaceBackupFailed =>
      'Не удалось создать резервную копию. На диске ничего не изменилось';

  @override
  String get snackReplaceSwapFailed =>
      'Замена не удалась, но исходное сохранение было восстановлено из резервной копии';

  @override
  String get snackReplaceBusy =>
      'Для этого сохранения уже выполняется другая операция';

  @override
  String get snackUploadIncomplete =>
      'Локальное сохранение неполное или повреждено. Ничего не загружено';

  @override
  String get snackDownloadIncomplete =>
      'Невозможно скачать: не хватает содержимого на Drive';

  @override
  String get cardIncomplete => 'Неполное на Drive';

  @override
  String get autoRefreshTitle => 'Автообновление';

  @override
  String get autoRefreshSubtitle => 'Проверяет изменения на Drive каждые 30с';

  @override
  String autoSyncSnack(String farmName) {
    return '$farmName синхронизировано автоматически';
  }

  @override
  String get autoSyncTooltipOn =>
      'Автосинхронизация включена — синхронизируется сама, когда это безопасно';

  @override
  String get autoSyncTooltipOff =>
      'Автосинхронизация выключена — нажмите, чтобы включить';

  @override
  String get autoSyncExplainTitle => 'Auto-sync';

  @override
  String autoSyncExplainBody(String farmName) {
    return 'Теперь $farmName будет загружаться или скачиваться сама, когда это безопасно, без запроса подтверждения.';
  }

  @override
  String get autoSyncExplainSafe =>
      'Действует только тогда, когда вы явно впереди и ничего не теряется.';

  @override
  String get autoSyncExplainDanger =>
      'Если был бы риск потерять прогресс, она никогда не действует сама: вы по-прежнему будете решать через обычный диалог.';

  @override
  String get autoSyncExplainMissing =>
      'Если одной из двух копий не хватает, она не создаёт её сама: первую загрузку или скачивание вы решаете сами.';

  @override
  String get autoSyncExplainDontShowAgain =>
      'Больше не показывать это предупреждение';

  @override
  String get autoSyncExplainConfirm => 'Понятно, включить';

  @override
  String get hiwAutoSyncTitle => 'Синхронизация сама по себе';

  @override
  String get hiwAutoSyncDesc =>
      'У каждого сохранения на карточке есть значок AUTO. Включите его — и это сохранение будет загружаться или скачиваться само, как только приложение заметит изменение, без необходимости открывать и подтверждать.';

  @override
  String get hiwAutoSyncTipSafe =>
      'Синхронизируется сама только тогда, когда вы явно впереди и ничего не теряется.';

  @override
  String get hiwAutoSyncTipDanger =>
      'Если был бы риск потерять прогресс, она никогда не делает это сама: по-прежнему спрашивает вас с обычным сравнением.';

  @override
  String get hiwAutoSyncTipPerSave =>
      'Включается для каждого сохранения отдельно, а не сразу для всех: можно включить для своего и выключить для общего.';

  @override
  String get hiwAutoSyncTipMissing =>
      'Поддерживает синхронизацию только двух уже существующих копий. Если одной не хватает, первую загрузку или скачивание делаете вы.';

  @override
  String get hiwAutoSyncTipRefresh =>
      'В Параметрах можно полностью отключить автоматическую проверку изменений.';

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
      'Если вы видите «Неполное на Drive» у сохранения, ему не хватает нужного файла в облаке — его нельзя скачать, пока оно не будет корректно загружено заново с другого устройства.';

  @override
  String get hiwShareTitle => 'Поделиться с другими';

  @override
  String get hiwShareDesc =>
      'Поделитесь сохранением с другим игроком по email. Он увидит его в разделе Общие со мной на своём устройстве.';

  @override
  String get hiwShareStepYourSave => 'Ваше\nсохранение';

  @override
  String get hiwShareStepShare => 'Поделиться по\nemail';

  @override
  String get hiwShareStepFriend => 'Общие\nсо мной';

  @override
  String get hiwShareTipRoles =>
      'Две роли: Только чтение позволяет просматривать и скачивать. Разрешить синхронизацию позволяет перезаписывать вашу копию на Drive. В любом случае удалить её они не могут — только вы, владелец, можете удалить своё сохранение.';

  @override
  String get hiwShareTipDisconnect =>
      'Отключение просто останавливает синхронизацию с его стороны — общий доступ остаётся активным, пока вы не покинете его по-настоящему в разделе Управление общими.';

  @override
  String get hiwHostSwapTitle => 'Смена хозяина';

  @override
  String get hiwHostSwapDesc =>
      'Меняет, какой фермер является хозяином сохранения, заменяя его на месте — тот же слот сохранения, те же права доступа.';

  @override
  String get hiwHostSwapStepPick => 'Выбрать\nфермера';

  @override
  String get hiwHostSwapStepConfirm => 'Подтвердить';

  @override
  String get hiwHostSwapStepDone => 'Новое сохранение\nсоздано';

  @override
  String get hiwHostSwapTipMove =>
      'Некоторые объекты фермы могут быть перемещены, чтобы освободить место для дома — ничего не удаляется.';

  @override
  String get hiwHostSwapTipHouse =>
      'Дом нового хозяина будет выглядеть как стандартный большой дом игры — внешний вид хижины не поддерживается без модов.';

  @override
  String get hiwBackupsTitle => 'Резервные копии';

  @override
  String get hiwBackupsDesc =>
      'Резервная копия — это снимок сохранения, который можно восстановить позже. Создавайте её вручную в любой момент или позвольте ValleySave создавать её автоматически перед перезаписью сохранения (при скачивании, импорте, восстановлении или смене хозяина).';

  @override
  String get hiwBackupsStepSave => 'Ваше\nсохранение';

  @override
  String get hiwBackupsStepSnapshot => 'Резервная копия\nсоздана';

  @override
  String get hiwBackupsStepStore => 'Локально и/или\nDrive';

  @override
  String get hiwBackupsTipRestore =>
      'Восстановление перезаписывает текущее сохранение этой более ранней версией — отменить нельзя.';

  @override
  String get hiwBackupsTipDelete =>
      'Удаление резервной копии убирает её везде, где она существует (это устройство и Drive, если загружена) — отменить нельзя.';

  @override
  String get hiwBackupsTipExport =>
      'Вы также можете Экспортировать сохранение в zip-файл, чтобы хранить где угодно, а потом Импортировать его обратно — полностью ручная и переносимая альтернатива встроенным резервным копиям.';

  @override
  String get hiwBackupsTipRetention =>
      'ValleySave хранит 5 самых последних автоматических резервных копий для каждого сохранения; те, что вы создаёте вручную, никогда не удаляются сами.';

  @override
  String get hiwBackupsTipRestoreBridge =>
      'В режиме Моста (Android без root/Shizuku) восстановление резервной копии попросит вас вручную извлечь .zip в папку Stardew — так же, как при скачивании.';

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
      'В Linux, если игра не определяется автоматически, укажите путь к исполняемому файлу в Параметры → Игра.';

  @override
  String get hiwSaveLocationsTitle => 'Где хранятся ваши сохранения';

  @override
  String get hiwSaveLocationsDesc =>
      'ValleySave читает и записывает напрямую в папку сохранений игры на каждой платформе.';

  @override
  String get hiwSaveLocationWindows =>
      'Windows: %AppData%\\\\StardewValley\\\\Saves';

  @override
  String get hiwSaveLocationAndroid =>
      'Android: защищённая папка, доступ через Shizuku или Мост';

  @override
  String get hiwSaveLocationLinux =>
      'Linux: ~/.config/StardewValley/Saves (или ~/snap/steam/common/.config/StardewValley/Saves, если Steam установлен через snap)';

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

  @override
  String get makeHostDeleteOriginalTitle =>
      'Удалить оригинальное сохранение с этого устройства?';

  @override
  String get makeHostDeleteOriginalBody =>
      'Новое сохранение готово. Сначала сделайте резервную копию оригинала в Drive (позже сможете скачать его снова) или просто удалите локальную копию.';

  @override
  String get makeHostDeleteOriginalNoBackupBody =>
      'Нет подключения к Drive: резервной копии не останется. Будет удалена только локальная копия на этом устройстве.';

  @override
  String get makeHostDeleteOriginalUploadBody =>
      'Оригинальное сохранение сначала будет загружено в ваш Drive как резервная копия, затем локальная копия на этом устройстве будет удалена.';

  @override
  String get makeHostDeleteWithoutUpload => 'Удалить без загрузки';

  @override
  String get makeHostUploadAndDelete => 'Загрузить и удалить';
}
