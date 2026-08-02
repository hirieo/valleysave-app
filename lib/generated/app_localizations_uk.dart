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
  String get updateNeedsPermission =>
      'Увімкніть «Встановлення невідомих застосунків» для ValleySave і знову натисніть «Оновити»';

  @override
  String get disconnectTitle => 'Відключити Drive?';

  @override
  String disconnectBody(String email) {
    return 'Ваші збереження на Drive не будуть видалені. Ви можете переконнектитися в будь-який час.';
  }

  @override
  String get disconnectButton => 'Відключити Drive';

  @override
  String disconnectButtonEmail(String email) {
    return 'Відключитися від $email';
  }

  @override
  String get connectedAsPrefix => 'Підключено як';

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
  String get exportAction => 'Експортувати';

  @override
  String get exportSuccess => 'Збереження експортовано.';

  @override
  String exportError(String error) {
    return 'Не вдалося експортувати збереження: $error';
  }

  @override
  String get importAction => 'Імпортувати збереження';

  @override
  String importSuccess(String playerName) {
    return 'Збереження $playerName імпортовано.';
  }

  @override
  String get importErrInvalidZip => 'Цей файл не є дійсним zip-архівом.';

  @override
  String get importErrUnsafePath =>
      'Цей файл має небезпечну структуру і був відхилений.';

  @override
  String get importErrTooLarge => 'Цей файл занадто великий для імпорту.';

  @override
  String get importErrNotASave =>
      'Цей файл не містить розпізнаваного збереження.';

  @override
  String get importErrWrite =>
      'Не вдалося записати імпортоване збереження (диск/дозволи).';

  @override
  String get importErrBackupFailed =>
      'Не вдалося створити резервну копію. Нічого не імпортовано.';

  @override
  String get importConflictTitle => 'Збереження з такою назвою вже існує';

  @override
  String get importConflictBody =>
      'Імпорт замінить наявну локальну копію. Це не можна скасувати.';

  @override
  String get importConflictConfirm => 'Перезаписати';

  @override
  String get shareAction => 'Поділитися';

  @override
  String get shareUploadFirstCta => 'Спершу вивантажити';

  @override
  String get shareDialogTitle => 'Поділитися збереженням';

  @override
  String get shareEmailPlaceholder => 'ім\'я@приклад.com';

  @override
  String get shareInfoNote =>
      'Спільний доступ надає право лише переглядати й завантажувати. Тільки ви можете редагувати або видаляти свою копію на Drive.';

  @override
  String get shareRoleReader => 'Тільки перегляд';

  @override
  String get shareRoleWriter => 'Дозволити синхронізацію';

  @override
  String get shareInfoNoteCoop =>
      'Тільки перегляд дозволяє переглядати й завантажувати. Дозволити синхронізацію дозволяє перезаписувати вашу копію на Drive — видалити її вони ніколи не зможуть.';

  @override
  String get shareConfirmButton => 'Поділитися';

  @override
  String shareSuccess(String email) {
    return 'Надано доступ $email.';
  }

  @override
  String get manageAccessTitle => 'Люди з доступом';

  @override
  String get manageAccessEmpty => 'Поки що більше ніхто не має доступу.';

  @override
  String get manageAccessRoleLabel => 'Доступ';

  @override
  String get manageAccessRevoke => 'Відкликати';

  @override
  String manageAccessRevokeConfirm(String email) {
    return 'Прибрати доступ у $email? Будь-яка вже завантажена локальна копія залишається його.';
  }

  @override
  String get driveOnlyControlsYourCopy =>
      'Спільний доступ керує лише вашою копією на Drive. Якщо хтось її завантажить, ця копія стане його.';

  @override
  String get driveOnlyControlsYourCopyCoop =>
      'Синхронізація керує вашою копією на Drive — ті, кому ви дозволили синхронізацію, можуть її перезаписати, але ніколи не можуть видалити.';

  @override
  String get sharedWithMeTitle => 'Поділені зі мною';

  @override
  String get sharedWithMeEmpty => 'Поки що нічого не поділено з вами.';

  @override
  String get sharedWithMeAdd => 'Додати спільне збереження';

  @override
  String sharedWithMeOwnedBy(String email) {
    return 'Поділився(-лася) $email';
  }

  @override
  String get sharedWithMeRoleSync => 'Синхронізує';

  @override
  String get sharedWithMeRoleRead => 'Тільки перегляд';

  @override
  String get sharedWithMeSync => 'Синхронізувати';

  @override
  String get sharedWithMeDownload => 'Завантажити';

  @override
  String get sharedWithMeRemove => 'Відключити';

  @override
  String sharedWithMeRemoveConfirm(String email) {
    return 'Ви припините синхронізацію з Drive $email, але можете додати його знову будь-коли — доступ залишається спільним. Ваша локальна копія залишається звичайним кооп-збереженням.';
  }

  @override
  String sharedLeaveConfirm(Object email) {
    return 'Ви по-справжньому втратите доступ до цього збереження. Ви не зможете додати його знову, якщо $email не поділиться з вами ще раз. Ваша локальна копія залишається звичайним кооп-збереженням.';
  }

  @override
  String get sharedManageButton => 'Керування';

  @override
  String get sharedManageDialogTitle => 'Керування поділеними збереженнями';

  @override
  String get sharedManageDialogHint =>
      'Тут ви можете по-справжньому залишити спільне збереження.';

  @override
  String get sharedLeaveButton => 'Залишити спільне збереження';

  @override
  String sharedLeaveSuccess(Object email) {
    return 'Ви залишили спільне збереження $email.';
  }

  @override
  String sharedWithMeSyncConfirm(String email) {
    return 'Перезаписати копію $email на Drive вашим локальним збереженням?';
  }

  @override
  String sharedAccessReadOnly(String email) {
    return '$email встановив(-ла) для вас доступ тільки для перегляду — ви можете переглядати й завантажувати, але не синхронізувати на його Drive.';
  }

  @override
  String get sharedWithMeRevoked => 'У вас більше немає доступу';

  @override
  String sharedRevokedDialogBody(String email, String farmName) {
    return '$email припинив(-ла) ділитися з вами $farmName. Ваша локальна копія та копія на вашому Drive залишаються як є, тепер у розділі Мої збереження.';
  }

  @override
  String get sharedRevokedAccept => 'Прийняти';

  @override
  String get sharedSelfCleanupTitle => 'Запис виправлено';

  @override
  String sharedSelfCleanupBody(String farmName) {
    return '$farmName з\'явилося як поділене з вами через помилку — насправді воно ваше. Це виправлено, тепер воно в розділі Мої збереження.';
  }

  @override
  String get sharedWithMeUploadOwn => 'Вивантажити на мій Drive';

  @override
  String get sharedDownloadOwn => 'Завантажити з мого Drive';

  @override
  String get sharedStatusOwnDriveAhead =>
      'Ваш Drive попереду — завантажте його';

  @override
  String get sharedSyncBoth => 'Вивантажити на обидва Drive';

  @override
  String get sharedSideMyDrive => 'МІЙ DRIVE';

  @override
  String sharedSideOwnerDrive(String email) {
    return 'DRIVE У $email';
  }

  @override
  String sharedSideDate(int day, int year) {
    return 'День $day · Рік $year';
  }

  @override
  String get sharedStatusSyncedNoOwnDrive =>
      'Синхронізовано з власником · немає копії на вашому Drive';

  @override
  String get sharedStatusAheadNoOwnDrive =>
      'Ви попереду · немає копії на вашому Drive';

  @override
  String sharedStatusOwnerAheadNoOwnDrive(String email) {
    return '$email попереду · немає копії на вашому Drive';
  }

  @override
  String get sharedStatusAllSynced =>
      'Синхронізовано (локально + обидва Drive)';

  @override
  String get sharedStatusAheadBoth => 'Ви попереду на обох Drive';

  @override
  String get sharedStatusMixed => 'Розсинхронізовано — перевірте кожен Drive';

  @override
  String get sharedStatusFullySynced => 'Повністю синхронізовано';

  @override
  String get sharedStatusSyncedOwn => 'Мій Drive синхронізовано';

  @override
  String get sharedStatusSyncedOwner => 'Спільний Drive синхронізовано';

  @override
  String get sharedStatusNotCloud => 'Тільки на цьому пристрої';

  @override
  String sharedStatusOwnerAhead(Object email) {
    return 'Drive у $email попереду';
  }

  @override
  String get sharedStatusBothAhead => 'Обидва Drive попереду';

  @override
  String get sharedStatusLocalMissing => 'Немає на цьому пристрої';

  @override
  String sharedStatusOwnerUnavailable(Object email) {
    return 'Не вдалося перевірити Drive у $email';
  }

  @override
  String get sharedStatusWorking => 'Синхронізація…';

  @override
  String get sharedSideUnavailable => 'Не вдалося перевірити';

  @override
  String get sharedSyncChooseTitle => 'Де ви хочете синхронізувати?';

  @override
  String get sharedSyncChooseBody =>
      'Виберіть, які хмарні копії оновити збереженням з цього пристрою.';

  @override
  String get sharedSyncTargetOwn => 'Мій Drive';

  @override
  String sharedSyncTargetOwner(Object email) {
    return 'Drive у $email';
  }

  @override
  String get sharedSyncTargetBoth => 'Обидва Drive';

  @override
  String get sharedDownloadChooseTitle => 'Яку копію ви хочете завантажити?';

  @override
  String get sharedDownloadChooseBody =>
      'Попереду більше однієї копії. Виберіть, яку перенести на цей пристрій.';

  @override
  String get sharedDownloadSourceOwn => 'З мого Drive';

  @override
  String sharedDownloadSourceOwner(Object email) {
    return 'З Drive у $email';
  }

  @override
  String get sharedWithMePickerTitle => 'Додати спільне збереження';

  @override
  String get sharedPickerEmptyHint =>
      'Тут з\'являється те, чим з вами поділився інший гравець через Drive.';

  @override
  String get sharedPickerAddButton => 'Додати';

  @override
  String get sharedOriginBadge => 'Спільне';

  @override
  String sharedOriginFrom(String email) {
    return 'від $email';
  }

  @override
  String get swapBackupDialogTitle => 'Резервну копію створено';

  @override
  String get swapBackupDialogBody =>
      'Попередню версію збережено як zip-файл. Що ви хочете з нею зробити?';

  @override
  String get swapBackupUpload => 'Вивантажити на Drive';

  @override
  String get swapBackupLocalOnly => 'Залишити на цьому пристрої';

  @override
  String get swapBackupDeleteNow => 'Видалити зараз';

  @override
  String get swapBackupUploadOk => 'Резервну копію вивантажено на Drive.';

  @override
  String swapBackupUploadErr(String error) {
    return 'Не вдалося вивантажити резервну копію: $error';
  }

  @override
  String get swapBackupLocalOnlySnack =>
      'Резервну копію збережено на цьому пристрої.';

  @override
  String get backupsAction => 'Резервні копії';

  @override
  String backupsScreenTitle(String farmName) {
    return 'Резервні копії $farmName';
  }

  @override
  String get backupsEmpty => 'Резервних копій поки немає.';

  @override
  String get backupsRestore => 'Відновити';

  @override
  String get backupsRestoreConfirmTitle => 'Відновити цю резервну копію?';

  @override
  String get backupsRestoreConfirmBody =>
      'Це перезапише ваше поточне збереження цією попередньою версією. Скасувати не можна.';

  @override
  String get backupsDelete => 'Видалити';

  @override
  String get backupsDeleteConfirmTitle => 'Видалити цю резервну копію?';

  @override
  String get backupsDeleteConfirmBody =>
      'Її буде видалено всюди, де вона існує (цей пристрій і Drive, якщо вивантажена). Скасувати не можна.';

  @override
  String get backupsRestoreOk => 'Резервну копію відновлено.';

  @override
  String get backupsRestoreManualTitle => 'Відновити вручну';

  @override
  String get backupsRestoreManualBody =>
      'У режимі мосту ValleySave не може автоматично записувати в папку гри. Видобудьте .zip цієї резервної копії в папку Saves Stardew Valley самостійно або перемкніться на режим Root/Shizuku в Налаштуваннях для автоматичного відновлення.';

  @override
  String backupsRestoreErr(String error) {
    return 'Не вдалося відновити резервну копію: $error';
  }

  @override
  String backupsDeleteErr(String error) {
    return 'Не вдалося видалити резервну копію: $error';
  }

  @override
  String get backupsCreate => 'Створити локальну резервну копію';

  @override
  String get backupsCreateLocalHint =>
      'Резервні копії спершу створюються на цьому пристрої. Пізніше ви зможете вивантажити їх на Drive.';

  @override
  String get backupsCreateOk => 'Резервну копію створено.';

  @override
  String backupsCreateErr(String error) {
    return 'Не вдалося створити резервну копію: $error';
  }

  @override
  String get backupsDownload => 'Завантажити';

  @override
  String get backupsDownloadOk => 'Резервну копію завантажено на цей пристрій.';

  @override
  String backupsDownloadErr(String error) {
    return 'Не вдалося завантажити резервну копію: $error';
  }

  @override
  String get backupsCopyOwn => 'Скопіювати на мій Drive';

  @override
  String get backupsUploadOwn => 'На мій Drive';

  @override
  String get backupsUploadShared => 'На спільний Drive';

  @override
  String get backupsUploadOk => 'Резервну копію вивантажено.';

  @override
  String backupsUploadErr(String error) {
    return 'Не вдалося вивантажити резервну копію: $error';
  }

  @override
  String get backupsLocationLocal => 'Цей пристрій';

  @override
  String get backupsLocationOwnDrive => 'Мій Drive';

  @override
  String get backupsLocationSharedDrive => 'Спільний Drive';

  @override
  String get backupsDeleteChooseBody =>
      'Виберіть, звідки саме її видалити. Показані лише місця, де ця резервна копія існує.';

  @override
  String get backupsDeleteLocalOnly => 'Тільки з цього пристрою';

  @override
  String get backupsDeleteOwnOnly => 'Тільки з мого Drive';

  @override
  String get backupsDeleteSharedOnly => 'Тільки зі спільного Drive';

  @override
  String get backupsDeleteAll => 'З усіх копій';

  @override
  String deleteUnifiedTitle(String farmName) {
    return 'Видалити $farmName?';
  }

  @override
  String get deleteChooseLocationBody =>
      'Виберіть звідки. Копія на цьому пристрої видаляється назавжди; копія на Drive переходить у кошик (30 днів).';

  @override
  String deleteDriveContextTitle(String farmName) {
    return 'Видалити $farmName з Drive?';
  }

  @override
  String get deleteDriveContextBody =>
      'Копія на Drive перейде в кошик, де її можна відновити протягом 30 днів.';

  @override
  String get deleteDriveLocalKept =>
      'Копія на цьому пристрої залишиться без змін.';

  @override
  String deleteLocalContextTitle(String farmName) {
    return 'Видалити $farmName з цього пристрою?';
  }

  @override
  String get deleteLocalContextBody =>
      'Копія на цьому пристрої буде видалена назавжди.';

  @override
  String deleteLocalDriveCurrent(String date) {
    return 'Ваша копія на Drive актуальна ($date) і залишиться доступною.';
  }

  @override
  String deleteLocalDriveAhead(String date) {
    return 'Ваша копія на Drive новіша ($date) і залишиться доступною.';
  }

  @override
  String deleteLocalDriveOlder(String driveDate, String localDate) {
    return 'Ваша копія на Drive старіша ($driveDate); цей пристрій на $localDate.';
  }

  @override
  String deleteLocalBackupAvailable(int count) {
    return 'Доступно $count локальних резервних копій на випадок, якщо вам знадобиться попередня копія.';
  }

  @override
  String get deleteLocalNoRecovery =>
      'Немає ні копії на Drive, ні локальної резервної копії, з якої можна відновити цю гру.';

  @override
  String get deleteOptionLocalOnly => 'Тільки з цього пристрою';

  @override
  String get deleteOptionDriveOnly => 'Тільки з Drive';

  @override
  String get deleteOptionBoth => 'З обох копій (пристрій + Drive)';

  @override
  String get viewPlayersHint => 'Переглянути гравців';

  @override
  String snackDeletedBoth(String saveName) {
    return '\"$saveName\" видалено з цього пристрою та переміщено в кошик Drive.';
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
  String get hiwConnectTitle => 'Підключіть свій обліковий запис';

  @override
  String get hiwConnectDesc =>
      'ValleySave використовує ваш обліковий запис Google для зберігання ваших збережень у приватній папці ValleySave на вашому власному Drive.';

  @override
  String get hiwConnectStepGoogle => 'Обліковий запис\nGoogle';

  @override
  String get hiwConnectStepDrive => 'Папка ValleySave\nстворена';

  @override
  String get hiwConnectStepReady => 'Готово до\nсинхронізації';

  @override
  String get hiwConnectTipOwnership =>
      'Тільки ви можете редагувати або видаляти свої копії на Drive — ValleySave лише читає та записує в межах власної папки.';

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
  String get overwriteWhatChanges => 'Що зміниться';

  @override
  String get overwriteTagOverwritten => 'БУДЕ ПЕРЕЗАПИСАНО';

  @override
  String get overwriteNewCopyTag => 'НОВЕ';

  @override
  String overwriteDeltaPhrase(int days, String time) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: '$days дня і $time',
      many: '$days днів і $time',
      few: '$days дні і $time',
      one: '1 день і $time',
      zero: '$time',
    );
    return '$_temp0';
  }

  @override
  String overwriteVerdictAhead(String delta) {
    return 'Ви на $delta попереду. Це безпечно.';
  }

  @override
  String get overwriteVerdictMoneySpent =>
      '💰 Поточні гроші зменшилися, але загальний прогрес просувається вперед — ймовірно, ви витратили їх на щось. Це не справжня втрата.';

  @override
  String overwriteVerdictNegligible(String delta) {
    return 'Мінімальна різниця ($delta). Підійде будь-яка з двох копій.';
  }

  @override
  String overwriteVerdictDanger(String delta, String target) {
    return '⚠️ Ви втратите $delta прогресу в $target. Перевірте перед тим, як продовжити.';
  }

  @override
  String get overwriteConfirmTitleUpload => 'Підтвердити вивантаження?';

  @override
  String get overwriteConfirmTitleDownload => 'Підтвердити завантаження?';

  @override
  String overwriteConfirmBody(String delta, String target) {
    return 'Ви втратите $delta в $target. Цю дію не можна скасувати.';
  }

  @override
  String get overwriteConfirmButtonUpload => 'Підтвердити вивантаження';

  @override
  String get overwriteConfirmButtonDownload => 'Підтвердити завантаження';

  @override
  String get overwriteDangerButtonUpload => '⚠️ Все одно вивантажити';

  @override
  String get overwriteDangerButtonDownload => '⚠️ Все одно завантажити';

  @override
  String overwriteIdenticalSummary(int count, String list) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '✓ $count однакових',
      many: '✓ $count однакових',
      few: '✓ $count однакових',
      one: '✓ 1 однакове',
    );
    return '$_temp0 — $list';
  }

  @override
  String overwriteUploadToOwner(String email) {
    return 'Вивантажити на Drive $email';
  }

  @override
  String get overwriteUploadBoth => 'Вивантажити на обидва Drive';

  @override
  String get overwriteConfirmTitleBoth => 'Підтвердити обидва вивантаження?';

  @override
  String overwriteConfirmBodyBoth(String delta, String targets) {
    return 'Ви втратите $delta в $targets. Цю дію не можна скасувати.';
  }

  @override
  String overwriteBothDestinationsLabel(String first, String second) {
    return '$first і $second';
  }

  @override
  String get sharedTargetOwnDrive => 'ваш Drive';

  @override
  String sharedStatusLocalAhead(String targets) {
    return 'Ви попереду в $targets';
  }

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
  String get snackReplacePrepareFailed =>
      'Не вдалося підготувати збереження. На диску нічого не змінилося';

  @override
  String get snackReplaceValidationFailed =>
      'Завантажене збереження виглядає недійсним або неповним. На диску нічого не змінилося';

  @override
  String get snackReplaceBackupFailed =>
      'Не вдалося створити резервну копію. На диску нічого не змінилося';

  @override
  String get snackReplaceSwapFailed =>
      'Заміна не вдалася, але оригінальне збереження було відновлено з резервної копії';

  @override
  String get snackReplaceBusy =>
      'Для цього збереження вже виконується інша операція';

  @override
  String get snackUploadIncomplete =>
      'Локальне збереження неповне або пошкоджене. Нічого не вивантажено';

  @override
  String get snackDownloadIncomplete =>
      'Неможливо завантажити: бракує вмісту на Drive';

  @override
  String get cardIncomplete => 'Неповне на Drive';

  @override
  String get autoRefreshTitle => 'Автооновлення';

  @override
  String get autoRefreshSubtitle => 'Перевіряє зміни на Drive кожні 30с';

  @override
  String autoSyncSnack(String farmName) {
    return '$farmName синхронізовано автоматично';
  }

  @override
  String get autoSyncTooltipOn =>
      'Автосинхронізацію увімкнено — синхронізується сама, коли це безпечно';

  @override
  String get autoSyncTooltipOff =>
      'Автосинхронізацію вимкнено — торкніться, щоб увімкнути';

  @override
  String get autoSyncExplainTitle => 'Auto-sync';

  @override
  String autoSyncExplainBody(String farmName) {
    return 'Відтепер $farmName буде вивантажуватися або завантажуватися сама, коли це безпечно, без запиту підтвердження.';
  }

  @override
  String get autoSyncExplainSafe =>
      'Діє лише тоді, коли ви явно попереду і нічого не втрачається.';

  @override
  String get autoSyncExplainDanger =>
      'Якби існував ризик втратити прогрес, вона ніколи не діє сама: ви й надалі вирішуватимете через звичайний діалог.';

  @override
  String get autoSyncExplainMissing =>
      'Якщо однієї з двох копій бракує, вона не створює її сама: перше вивантаження чи завантаження вирішуєте ви.';

  @override
  String get autoSyncExplainDontShowAgain =>
      'Більше не показувати це попередження';

  @override
  String get autoSyncExplainConfirm => 'Зрозуміло, увімкнути';

  @override
  String get hiwAutoSyncTitle => 'Синхронізація сама по собі';

  @override
  String get hiwAutoSyncDesc =>
      'Кожне збереження має значок AUTO на своїй картці. Увімкніть його — і це збереження буде вивантажуватися або завантажуватися само, щойно застосунок помітить зміну, без потреби відкривати й підтверджувати.';

  @override
  String get hiwAutoSyncTipSafe =>
      'Синхронізується сама лише тоді, коли ви явно попереду і нічого не втрачається.';

  @override
  String get hiwAutoSyncTipDanger =>
      'Якби існував ризик втратити прогрес, вона ніколи не робить це сама: й надалі запитує вас зі звичайним порівнянням.';

  @override
  String get hiwAutoSyncTipPerSave =>
      'Вмикається для кожного збереження окремо, а не одразу для всіх: можна ввімкнути для свого і вимкнути для спільного.';

  @override
  String get hiwAutoSyncTipMissing =>
      'Підтримує синхронізацію лише двох уже наявних копій. Якщо однієї бракує, перше вивантаження чи завантаження робите ви.';

  @override
  String get hiwAutoSyncTipRefresh =>
      'У Налаштуваннях можна повністю вимкнути автоматичну перевірку змін.';

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
  String get hiwCompatIncomplete =>
      'Якщо ви бачите «Неповне на Drive» у збереженні, йому бракує потрібного файлу в хмарі — його не можна завантажити, доки воно не буде коректно вивантажено знову з іншого пристрою.';

  @override
  String get hiwShareTitle => 'Поділитися з іншими';

  @override
  String get hiwShareDesc =>
      'Поділіться збереженням з іншим гравцем через email. Він побачить його в розділі Поділені зі мною на своєму пристрої.';

  @override
  String get hiwShareStepYourSave => 'Ваше\nзбереження';

  @override
  String get hiwShareStepShare => 'Поділитися через\nemail';

  @override
  String get hiwShareStepFriend => 'Поділені\nзі мною';

  @override
  String get hiwShareTipRoles =>
      'Дві ролі: Тільки перегляд дозволяє переглядати й завантажувати. Дозволити синхронізацію дозволяє перезаписувати вашу копію на Drive. У будь-якому разі видалити її вони не можуть — тільки ви, власник, можете видалити своє збереження.';

  @override
  String get hiwShareTipDisconnect =>
      'Відключення лише зупиняє синхронізацію з його боку — доступ залишається активним, доки ви по-справжньому не залишите його в розділі Керування поділеними.';

  @override
  String get hiwHostSwapTitle => 'Зміна господаря';

  @override
  String get hiwHostSwapDesc =>
      'Змінює, який фермер є господарем збереження, замінюючи його на місці — той самий слот збереження, ті самі права доступу.';

  @override
  String get hiwHostSwapStepPick => 'Обрати\nфермера';

  @override
  String get hiwHostSwapStepConfirm => 'Підтвердити';

  @override
  String get hiwHostSwapStepDone => 'Нове збереження\nстворено';

  @override
  String get hiwHostSwapTipMove =>
      'Деякі об\'єкти ферми можуть бути переміщені, щоб звільнити місце для будинку — нічого не видаляється.';

  @override
  String get hiwHostSwapTipHouse =>
      'Будинок нового господаря виглядатиме як стандартний великий будинок гри — вигляд хатини не підтримується без модів.';

  @override
  String get hiwBackupsTitle => 'Резервні копії';

  @override
  String get hiwBackupsDesc =>
      'Резервна копія — це знімок збереження, який можна відновити пізніше. Створюйте її вручну будь-коли або дозвольте ValleySave створювати її автоматично перед перезаписом збереження (при завантаженні, імпорті, відновленні або зміні господаря).';

  @override
  String get hiwBackupsStepSave => 'Ваше\nзбереження';

  @override
  String get hiwBackupsStepSnapshot => 'Резервна копія\nстворена';

  @override
  String get hiwBackupsStepStore => 'Локально та/або\nDrive';

  @override
  String get hiwBackupsTipRestore =>
      'Відновлення перезаписує ваше поточне збереження цією більш ранньою версією — скасувати це не можна.';

  @override
  String get hiwBackupsTipDelete =>
      'Видалення резервної копії прибирає її всюди, де вона існує (цей пристрій і Drive, якщо вивантажена) — скасувати це не можна.';

  @override
  String get hiwBackupsTipExport =>
      'Ви також можете Експортувати збереження як zip-файл, щоб зберігати його де завгодно, а потім Імпортувати назад пізніше — повністю ручна й портативна альтернатива вбудованим резервним копіям.';

  @override
  String get hiwBackupsTipRetention =>
      'ValleySave зберігає 5 найновіших автоматичних резервних копій для кожного збереження; ті, що ви створюєте вручну, ніколи не видаляються самі.';

  @override
  String get hiwBackupsTipRestoreBridge =>
      'У режимі Мосту (Android без root/Shizuku) відновлення резервної копії попросить вас вручну видобути .zip у папку Stardew — так само, як при завантаженні.';

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
  String get hiwLaunchTipLinux =>
      'У Linux, якщо гру не визначено автоматично, вкажіть шлях до виконуваного файлу в Налаштування → Гра.';

  @override
  String get hiwSaveLocationsTitle => 'Де живуть ваші збереження';

  @override
  String get hiwSaveLocationsDesc =>
      'ValleySave читає та записує безпосередньо в папку збережень гри на кожній платформі.';

  @override
  String get hiwSaveLocationWindows =>
      'Windows: %AppData%\\\\StardewValley\\\\Saves';

  @override
  String get hiwSaveLocationAndroid =>
      'Android: захищена папка, доступ через Shizuku або Міст';

  @override
  String get hiwSaveLocationLinux =>
      'Linux: ~/.config/StardewValley/Saves (або ~/snap/steam/common/.config/StardewValley/Saves, якщо Steam встановлено через snap)';

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

  @override
  String get makeHostDeleteOriginalTitle =>
      'Видалити оригінальне збереження з цього пристрою?';

  @override
  String get makeHostDeleteOriginalBody =>
      'Нове збереження готове. Спершу зробіть резервну копію оригіналу у Drive (пізніше зможете завантажити його знову) або просто видаліть локальну копію.';

  @override
  String get makeHostDeleteOriginalNoBackupBody =>
      'Немає з\'єднання з Drive: резервної копії не залишиться. Буде видалено лише локальну копію на цьому пристрої.';

  @override
  String get makeHostDeleteOriginalUploadBody =>
      'Оригінальне збереження спершу буде завантажено у ваш Drive як резервну копію, потім локальну копію на цьому пристрої буде видалено.';

  @override
  String get makeHostDeleteWithoutUpload => 'Видалити без завантаження';

  @override
  String get makeHostUploadAndDelete => 'Завантажити та видалити';
}
