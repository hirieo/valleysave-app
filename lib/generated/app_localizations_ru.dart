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
  String get adsTitle => 'Объявления';

  @override
  String get adsDesc =>
      'ValleySave может показывать объявления через Google AdMob.';

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
      'Это удалит сохранение с этого устройства. Вы уверены?';

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
}
