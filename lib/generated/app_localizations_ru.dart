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
}
