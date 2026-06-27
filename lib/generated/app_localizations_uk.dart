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
}
