import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_de.dart';
import 'app_localizations_en.dart';
import 'app_localizations_es.dart';
import 'app_localizations_fr.dart';
import 'app_localizations_it.dart';
import 'app_localizations_ja.dart';
import 'app_localizations_ko.dart';
import 'app_localizations_pt.dart';
import 'app_localizations_ru.dart';
import 'app_localizations_th.dart';
import 'app_localizations_uk.dart';
import 'app_localizations_zh.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'generated/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('de'),
    Locale('en'),
    Locale('es'),
    Locale('fr'),
    Locale('it'),
    Locale('ja'),
    Locale('ko'),
    Locale('pt'),
    Locale('ru'),
    Locale('th'),
    Locale('uk'),
    Locale('zh'),
    Locale.fromSubtags(languageCode: 'zh', scriptCode: 'Hant'),
  ];

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'ValleySave'**
  String get appTitle;

  /// No description provided for @welcomeTitle.
  ///
  /// In en, this message translates to:
  /// **'Never lose your farm, take it with you.'**
  String get welcomeTitle;

  /// No description provided for @connectGoogleDrive.
  ///
  /// In en, this message translates to:
  /// **'Connect Google Drive'**
  String get connectGoogleDrive;

  /// No description provided for @connecting.
  ///
  /// In en, this message translates to:
  /// **'Connecting…'**
  String get connecting;

  /// No description provided for @mySaves.
  ///
  /// In en, this message translates to:
  /// **'My Saves'**
  String get mySaves;

  /// No description provided for @howItWorks.
  ///
  /// In en, this message translates to:
  /// **'How it works'**
  String get howItWorks;

  /// No description provided for @settings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// No description provided for @aboutSection.
  ///
  /// In en, this message translates to:
  /// **'About'**
  String get aboutSection;

  /// No description provided for @openSource.
  ///
  /// In en, this message translates to:
  /// **'Available code'**
  String get openSource;

  /// No description provided for @nonCommercial.
  ///
  /// In en, this message translates to:
  /// **'Non-commercial'**
  String get nonCommercial;

  /// No description provided for @freeForever.
  ///
  /// In en, this message translates to:
  /// **'Free forever'**
  String get freeForever;

  /// No description provided for @privacyTitle.
  ///
  /// In en, this message translates to:
  /// **'Privacy and data usage'**
  String get privacyTitle;

  /// No description provided for @privacyDescription.
  ///
  /// In en, this message translates to:
  /// **'ValleySave is an app for syncing your Stardew Valley saves with your own Google Drive account.'**
  String get privacyDescription;

  /// No description provided for @whatDataTitle.
  ///
  /// In en, this message translates to:
  /// **'What data it uses'**
  String get whatDataTitle;

  /// No description provided for @whatDataDesc.
  ///
  /// In en, this message translates to:
  /// **'ValleySave only accesses the Stardew Valley save files necessary to make copies, sync them, or restore them.'**
  String get whatDataDesc;

  /// No description provided for @googleDriveTitle.
  ///
  /// In en, this message translates to:
  /// **'Google Drive'**
  String get googleDriveTitle;

  /// No description provided for @googleDriveDesc.
  ///
  /// In en, this message translates to:
  /// **'Your saves are uploaded to your own Google Drive account. ValleySave doesn\'t use its own servers to store your games.'**
  String get googleDriveDesc;

  /// No description provided for @androidPermissionsTitle.
  ///
  /// In en, this message translates to:
  /// **'Permissions on Android'**
  String get androidPermissionsTitle;

  /// No description provided for @androidPermissionsDesc.
  ///
  /// In en, this message translates to:
  /// **'ValleySave may need storage permissions or tools like Shizuku to access save files.'**
  String get androidPermissionsDesc;

  /// No description provided for @adsTitle.
  ///
  /// In en, this message translates to:
  /// **'Ads'**
  String get adsTitle;

  /// No description provided for @adsDesc.
  ///
  /// In en, this message translates to:
  /// **'ValleySave may show ads through Google AdMob.'**
  String get adsDesc;

  /// No description provided for @responsibilityTitle.
  ///
  /// In en, this message translates to:
  /// **'Responsibility'**
  String get responsibilityTitle;

  /// No description provided for @responsibilityDesc.
  ///
  /// In en, this message translates to:
  /// **'Your save files are your responsibility.'**
  String get responsibilityDesc;

  /// No description provided for @deleteDataTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete data'**
  String get deleteDataTitle;

  /// No description provided for @deleteDataDesc.
  ///
  /// In en, this message translates to:
  /// **'You can delete your synchronized copies by manually deleting the ValleySave folder from Google Drive.'**
  String get deleteDataDesc;

  /// No description provided for @sourceCodeTitle.
  ///
  /// In en, this message translates to:
  /// **'Source code and contact'**
  String get sourceCodeTitle;

  /// No description provided for @sourceCodeDesc.
  ///
  /// In en, this message translates to:
  /// **'ValleySave is a project with available code under Polyform Noncommercial license.'**
  String get sourceCodeDesc;

  /// No description provided for @upToDate.
  ///
  /// In en, this message translates to:
  /// **'Up to date'**
  String get upToDate;

  /// No description provided for @checkingUpdates.
  ///
  /// In en, this message translates to:
  /// **'Checking…'**
  String get checkingUpdates;

  /// No description provided for @updateAvailable.
  ///
  /// In en, this message translates to:
  /// **'Update available'**
  String get updateAvailable;

  /// No description provided for @application.
  ///
  /// In en, this message translates to:
  /// **'Application'**
  String get application;

  /// No description provided for @version.
  ///
  /// In en, this message translates to:
  /// **'Version {version}'**
  String version(Object version);

  /// No description provided for @checkForUpdates.
  ///
  /// In en, this message translates to:
  /// **'Check for updates'**
  String get checkForUpdates;

  /// No description provided for @shizukuRequired.
  ///
  /// In en, this message translates to:
  /// **'Shizuku required'**
  String get shizukuRequired;

  /// No description provided for @shizukuGuide.
  ///
  /// In en, this message translates to:
  /// **'Shizuku Setup Guide'**
  String get shizukuGuide;

  /// No description provided for @activateShizuku.
  ///
  /// In en, this message translates to:
  /// **'Enable Shizuku to write the save in the game.'**
  String get activateShizuku;

  /// No description provided for @deleteSaveTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete {saveName}'**
  String deleteSaveTitle(Object saveName);

  /// No description provided for @deleteSaveMessage.
  ///
  /// In en, this message translates to:
  /// **'This will remove the save from this device. Do you want to continue?'**
  String get deleteSaveMessage;

  /// No description provided for @deleteFromDrive.
  ///
  /// In en, this message translates to:
  /// **'Delete from Drive'**
  String get deleteFromDrive;

  /// No description provided for @confirmDelete.
  ///
  /// In en, this message translates to:
  /// **'The {saveName} will be moved to Google Drive Trash.'**
  String confirmDelete(Object saveName);

  /// No description provided for @deleteFromDeviceMessage.
  ///
  /// In en, this message translates to:
  /// **'The {saveName} will be deleted permanently from this device.'**
  String deleteFromDeviceMessage(Object saveName);

  /// No description provided for @restoreSaveTitle.
  ///
  /// In en, this message translates to:
  /// **'Restore {saveName}'**
  String restoreSaveTitle(Object saveName);

  /// No description provided for @restoreSaveMessage.
  ///
  /// In en, this message translates to:
  /// **'Download {saveName} to this device?'**
  String restoreSaveMessage(Object saveName);

  /// No description provided for @restore.
  ///
  /// In en, this message translates to:
  /// **'Restore'**
  String get restore;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @error.
  ///
  /// In en, this message translates to:
  /// **'Error'**
  String get error;

  /// No description provided for @success.
  ///
  /// In en, this message translates to:
  /// **'Success'**
  String get success;

  /// No description provided for @loading.
  ///
  /// In en, this message translates to:
  /// **'Loading…'**
  String get loading;

  /// No description provided for @disconnect.
  ///
  /// In en, this message translates to:
  /// **'Disconnect'**
  String get disconnect;

  /// No description provided for @ok.
  ///
  /// In en, this message translates to:
  /// **'OK'**
  String get ok;

  /// No description provided for @yes.
  ///
  /// In en, this message translates to:
  /// **'Yes'**
  String get yes;

  /// No description provided for @no.
  ///
  /// In en, this message translates to:
  /// **'No'**
  String get no;

  /// No description provided for @welcomeHeroPre.
  ///
  /// In en, this message translates to:
  /// **'Never lose\nyour '**
  String get welcomeHeroPre;

  /// No description provided for @welcomeHeroAccent.
  ///
  /// In en, this message translates to:
  /// **'farm,'**
  String get welcomeHeroAccent;

  /// No description provided for @welcomeHeroPost.
  ///
  /// In en, this message translates to:
  /// **'\ntake it with you.'**
  String get welcomeHeroPost;

  /// No description provided for @welcomeSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Sync your Stardew Valley saves across all your devices. Your data lives in your own Google Drive — no servers, no subscriptions, under your control.'**
  String get welcomeSubtitle;

  /// No description provided for @welcomeDriveConnected.
  ///
  /// In en, this message translates to:
  /// **'Drive connected'**
  String get welcomeDriveConnected;

  /// No description provided for @welcomeFooterTagline.
  ///
  /// In en, this message translates to:
  /// **'· Non-commercial · Free forever ·'**
  String get welcomeFooterTagline;

  /// No description provided for @updateVersionAvailable.
  ///
  /// In en, this message translates to:
  /// **'v{version} available'**
  String updateVersionAvailable(String version);

  /// No description provided for @sectionMode.
  ///
  /// In en, this message translates to:
  /// **'Mode'**
  String get sectionMode;

  /// No description provided for @sectionSeason.
  ///
  /// In en, this message translates to:
  /// **'Season'**
  String get sectionSeason;

  /// No description provided for @sectionLanguage.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get sectionLanguage;

  /// No description provided for @modeAutoTitle.
  ///
  /// In en, this message translates to:
  /// **'Automatic'**
  String get modeAutoTitle;

  /// No description provided for @modeAutoDesc.
  ///
  /// In en, this message translates to:
  /// **'Follows your active save and, if no saves, your real location.'**
  String get modeAutoDesc;

  /// No description provided for @modeSavesTitle.
  ///
  /// In en, this message translates to:
  /// **'By save'**
  String get modeSavesTitle;

  /// No description provided for @modeSavesDesc.
  ///
  /// In en, this message translates to:
  /// **'Always uses the season from your most recent save.'**
  String get modeSavesDesc;

  /// No description provided for @modeGeoTitle.
  ///
  /// In en, this message translates to:
  /// **'By location'**
  String get modeGeoTitle;

  /// No description provided for @modeGeoDesc.
  ///
  /// In en, this message translates to:
  /// **'Always uses the real season of your location.'**
  String get modeGeoDesc;

  /// No description provided for @modeFixedTitle.
  ///
  /// In en, this message translates to:
  /// **'Fixed season'**
  String get modeFixedTitle;

  /// No description provided for @modeFixedDesc.
  ///
  /// In en, this message translates to:
  /// **'Always shows the same season.'**
  String get modeFixedDesc;

  /// No description provided for @modeRandomTitle.
  ///
  /// In en, this message translates to:
  /// **'Random'**
  String get modeRandomTitle;

  /// No description provided for @modeRandomDesc.
  ///
  /// In en, this message translates to:
  /// **'Picks a different season each time you open the app.'**
  String get modeRandomDesc;

  /// No description provided for @seasonInitial.
  ///
  /// In en, this message translates to:
  /// **'Initial'**
  String get seasonInitial;

  /// No description provided for @seasonSpring.
  ///
  /// In en, this message translates to:
  /// **'Spring'**
  String get seasonSpring;

  /// No description provided for @seasonSummer.
  ///
  /// In en, this message translates to:
  /// **'Summer'**
  String get seasonSummer;

  /// No description provided for @seasonFall.
  ///
  /// In en, this message translates to:
  /// **'Fall'**
  String get seasonFall;

  /// No description provided for @seasonWinter.
  ///
  /// In en, this message translates to:
  /// **'Winter'**
  String get seasonWinter;

  /// No description provided for @autoPriorityTitle.
  ///
  /// In en, this message translates to:
  /// **'Priority order'**
  String get autoPriorityTitle;

  /// No description provided for @autoStep1Title.
  ///
  /// In en, this message translates to:
  /// **'First launch'**
  String get autoStep1Title;

  /// No description provided for @autoStep1Desc.
  ///
  /// In en, this message translates to:
  /// **'Shows the initial state.'**
  String get autoStep1Desc;

  /// No description provided for @autoStep2Title.
  ///
  /// In en, this message translates to:
  /// **'Active save'**
  String get autoStep2Title;

  /// No description provided for @autoStep2Desc.
  ///
  /// In en, this message translates to:
  /// **'Uses the season from your last synced save.'**
  String get autoStep2Desc;

  /// No description provided for @autoStep3Title.
  ///
  /// In en, this message translates to:
  /// **'Location'**
  String get autoStep3Title;

  /// No description provided for @autoStep3Desc.
  ///
  /// In en, this message translates to:
  /// **'Detects your hemisphere and the real season of your region.'**
  String get autoStep3Desc;

  /// No description provided for @autoStep4Title.
  ///
  /// In en, this message translates to:
  /// **'Default'**
  String get autoStep4Title;

  /// No description provided for @autoStep4Desc.
  ///
  /// In en, this message translates to:
  /// **'Initial (night mode) if no data is available.'**
  String get autoStep4Desc;

  /// No description provided for @versionInstalled.
  ///
  /// In en, this message translates to:
  /// **'Installed version'**
  String get versionInstalled;

  /// No description provided for @updateNeverChecked.
  ///
  /// In en, this message translates to:
  /// **'Never checked'**
  String get updateNeverChecked;

  /// No description provided for @updateCheckedNow.
  ///
  /// In en, this message translates to:
  /// **'Checked now'**
  String get updateCheckedNow;

  /// No description provided for @updateOutdatedDownload.
  ///
  /// In en, this message translates to:
  /// **'Not up to date · Download'**
  String get updateOutdatedDownload;

  /// No description provided for @disconnectTitle.
  ///
  /// In en, this message translates to:
  /// **'Disconnect Drive?'**
  String get disconnectTitle;

  /// No description provided for @disconnectBody.
  ///
  /// In en, this message translates to:
  /// **'Your saves on Drive won\'t be deleted. You can reconnect anytime.'**
  String get disconnectBody;

  /// No description provided for @disconnectButton.
  ///
  /// In en, this message translates to:
  /// **'Disconnect Drive'**
  String get disconnectButton;

  /// No description provided for @languageTileLabel.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get languageTileLabel;

  /// No description provided for @languageDialogTitle.
  ///
  /// In en, this message translates to:
  /// **'App language'**
  String get languageDialogTitle;

  /// No description provided for @searchHint.
  ///
  /// In en, this message translates to:
  /// **'Search…'**
  String get searchHint;

  /// No description provided for @languageAuto.
  ///
  /// In en, this message translates to:
  /// **'Auto · system'**
  String get languageAuto;

  /// No description provided for @languageAutoDesc.
  ///
  /// In en, this message translates to:
  /// **'Uses your system language'**
  String get languageAutoDesc;

  /// No description provided for @privacyPolicyTitle.
  ///
  /// In en, this message translates to:
  /// **'Privacy policy'**
  String get privacyPolicyTitle;

  /// No description provided for @privacyBeforeStartTitle.
  ///
  /// In en, this message translates to:
  /// **'Before you start'**
  String get privacyBeforeStartTitle;

  /// No description provided for @privacyLastUpdated.
  ///
  /// In en, this message translates to:
  /// **'Last updated: June 2026'**
  String get privacyLastUpdated;

  /// No description provided for @privacyAccept.
  ///
  /// In en, this message translates to:
  /// **'Got it, continue'**
  String get privacyAccept;

  /// No description provided for @cardSynced.
  ///
  /// In en, this message translates to:
  /// **'Synced'**
  String get cardSynced;

  /// No description provided for @cardLocalAhead.
  ///
  /// In en, this message translates to:
  /// **'Local ahead'**
  String get cardLocalAhead;

  /// No description provided for @cardDriveAhead.
  ///
  /// In en, this message translates to:
  /// **'Cloud ahead'**
  String get cardDriveAhead;

  /// No description provided for @cardLocalOnly.
  ///
  /// In en, this message translates to:
  /// **'Local only'**
  String get cardLocalOnly;

  /// No description provided for @cardDriveOnly.
  ///
  /// In en, this message translates to:
  /// **'Cloud only'**
  String get cardDriveOnly;

  /// No description provided for @cardTimeNow.
  ///
  /// In en, this message translates to:
  /// **'now'**
  String get cardTimeNow;

  /// No description provided for @cardTimeMinutesAgo.
  ///
  /// In en, this message translates to:
  /// **'{minutes} min ago'**
  String cardTimeMinutesAgo(int minutes);

  /// No description provided for @cardTimeHoursAgo.
  ///
  /// In en, this message translates to:
  /// **'{hours}h ago'**
  String cardTimeHoursAgo(int hours);

  /// No description provided for @cardTimeDaysAgo.
  ///
  /// In en, this message translates to:
  /// **'{days}d ago'**
  String cardTimeDaysAgo(int days);

  /// No description provided for @cardTimeMonthsAgo.
  ///
  /// In en, this message translates to:
  /// **'{months} month{plural} ago'**
  String cardTimeMonthsAgo(int months, String plural);

  /// No description provided for @cardDetailLocalTitle.
  ///
  /// In en, this message translates to:
  /// **'On this device'**
  String get cardDetailLocalTitle;

  /// No description provided for @cardDetailRemoteTitle.
  ///
  /// In en, this message translates to:
  /// **'On Drive'**
  String get cardDetailRemoteTitle;

  /// No description provided for @cardDetailUpload.
  ///
  /// In en, this message translates to:
  /// **'Upload to Drive'**
  String get cardDetailUpload;

  /// No description provided for @cardDetailDownload.
  ///
  /// In en, this message translates to:
  /// **'Download save'**
  String get cardDetailDownload;

  /// No description provided for @cardDetailDeleteLabel.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get cardDetailDeleteLabel;

  /// No description provided for @cardDetailDeleteLocal.
  ///
  /// In en, this message translates to:
  /// **'Delete from this device'**
  String get cardDetailDeleteLocal;

  /// No description provided for @cardDetailDeleteRemote.
  ///
  /// In en, this message translates to:
  /// **'Delete from Drive'**
  String get cardDetailDeleteRemote;

  /// No description provided for @cardCloseBarrier.
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get cardCloseBarrier;

  /// No description provided for @statDayYear.
  ///
  /// In en, this message translates to:
  /// **'Day {day} · Year {year}'**
  String statDayYear(int day, int year);

  /// No description provided for @statDayOnly.
  ///
  /// In en, this message translates to:
  /// **'Day {day}'**
  String statDayOnly(int day);

  /// No description provided for @statPlaytime.
  ///
  /// In en, this message translates to:
  /// **'Playtime'**
  String get statPlaytime;

  /// No description provided for @statMoney.
  ///
  /// In en, this message translates to:
  /// **'Coins'**
  String get statMoney;

  /// No description provided for @statTotal.
  ///
  /// In en, this message translates to:
  /// **'Total'**
  String get statTotal;

  /// No description provided for @statMineUnexplored.
  ///
  /// In en, this message translates to:
  /// **'Unexplored'**
  String get statMineUnexplored;

  /// No description provided for @statMine.
  ///
  /// In en, this message translates to:
  /// **'Mine'**
  String get statMine;

  /// No description provided for @statMineLvl.
  ///
  /// In en, this message translates to:
  /// **'Mine · Lv'**
  String get statMineLvl;

  /// No description provided for @skillFarming.
  ///
  /// In en, this message translates to:
  /// **'Farming'**
  String get skillFarming;

  /// No description provided for @skillForaging.
  ///
  /// In en, this message translates to:
  /// **'Foraging'**
  String get skillForaging;

  /// No description provided for @skillMining.
  ///
  /// In en, this message translates to:
  /// **'Mining'**
  String get skillMining;

  /// No description provided for @skillFishing.
  ///
  /// In en, this message translates to:
  /// **'Fishing'**
  String get skillFishing;

  /// No description provided for @skillCombat.
  ///
  /// In en, this message translates to:
  /// **'Combat'**
  String get skillCombat;

  /// No description provided for @cardLocalPresence.
  ///
  /// In en, this message translates to:
  /// **'On this device'**
  String get cardLocalPresence;

  /// No description provided for @cardRemotePresence.
  ///
  /// In en, this message translates to:
  /// **'On Drive'**
  String get cardRemotePresence;

  /// No description provided for @cardNotPresent.
  ///
  /// In en, this message translates to:
  /// **'Not here'**
  String get cardNotPresent;

  /// No description provided for @cardActionSynced.
  ///
  /// In en, this message translates to:
  /// **'Synced'**
  String get cardActionSynced;

  /// No description provided for @cardActionUpload.
  ///
  /// In en, this message translates to:
  /// **'Upload'**
  String get cardActionUpload;

  /// No description provided for @cardActionDownload.
  ///
  /// In en, this message translates to:
  /// **'Download'**
  String get cardActionDownload;

  /// No description provided for @pillMonsters.
  ///
  /// In en, this message translates to:
  /// **'monsters'**
  String get pillMonsters;

  /// No description provided for @pillFriends.
  ///
  /// In en, this message translates to:
  /// **'friends'**
  String get pillFriends;

  /// No description provided for @pillFaints.
  ///
  /// In en, this message translates to:
  /// **'faints'**
  String get pillFaints;

  /// No description provided for @hiwTitle.
  ///
  /// In en, this message translates to:
  /// **'How it works'**
  String get hiwTitle;

  /// No description provided for @hiwSyncTitle.
  ///
  /// In en, this message translates to:
  /// **'How sync works'**
  String get hiwSyncTitle;

  /// No description provided for @hiwSyncIntro.
  ///
  /// In en, this message translates to:
  /// **'ValleySave uses your own Google Drive to move saves between devices. No intermediary servers: the files are yours.'**
  String get hiwSyncIntro;

  /// No description provided for @hiwSyncDevice.
  ///
  /// In en, this message translates to:
  /// **'Your\ndevice'**
  String get hiwSyncDevice;

  /// No description provided for @hiwSyncCloud.
  ///
  /// In en, this message translates to:
  /// **'Google\nDrive'**
  String get hiwSyncCloud;

  /// No description provided for @hiwSyncOtherDevice.
  ///
  /// In en, this message translates to:
  /// **'Other\ndevice'**
  String get hiwSyncOtherDevice;

  /// No description provided for @hiwUploadTitle.
  ///
  /// In en, this message translates to:
  /// **'Upload a save'**
  String get hiwUploadTitle;

  /// No description provided for @hiwUploadDesc.
  ///
  /// In en, this message translates to:
  /// **'When you upload, ValleySave copies both save files (SaveGameInfo + farm file) to your ValleySave/ folder on Drive.'**
  String get hiwUploadDesc;

  /// No description provided for @hiwDownloadTitle.
  ///
  /// In en, this message translates to:
  /// **'Download a save'**
  String get hiwDownloadTitle;

  /// No description provided for @hiwDownloadDesc.
  ///
  /// In en, this message translates to:
  /// **'When you download, ValleySave brings the files from Drive and places them directly in the game folder.'**
  String get hiwDownloadDesc;

  /// No description provided for @hiwCompareTitle.
  ///
  /// In en, this message translates to:
  /// **'What does it compare?'**
  String get hiwCompareTitle;

  /// No description provided for @hiwCompareIntro.
  ///
  /// In en, this message translates to:
  /// **'To know which version is ahead, ValleySave uses total playtime — the only data that can only grow.'**
  String get hiwCompareIntro;

  /// No description provided for @hiwCompareNote.
  ///
  /// In en, this message translates to:
  /// **'Before confirming you\'ll also see, so you can decide:'**
  String get hiwCompareNote;

  /// No description provided for @hiwCompareMoney.
  ///
  /// In en, this message translates to:
  /// **'Current money and total earned'**
  String get hiwCompareMoney;

  /// No description provided for @hiwCompareMine.
  ///
  /// In en, this message translates to:
  /// **'Mine level'**
  String get hiwCompareMine;

  /// No description provided for @hiwCompareSkills.
  ///
  /// In en, this message translates to:
  /// **'Skills (farming, mining, combat…)'**
  String get hiwCompareSkills;

  /// No description provided for @hiwCompareRelations.
  ///
  /// In en, this message translates to:
  /// **'Friends, monsters killed, faints'**
  String get hiwCompareRelations;

  /// No description provided for @hiwCompareStamina.
  ///
  /// In en, this message translates to:
  /// **'Stamina and health'**
  String get hiwCompareStamina;

  /// No description provided for @hiwCompareNotShown.
  ///
  /// In en, this message translates to:
  /// **'These are not shown — they change in any direction and don\'t indicate which save is ahead.'**
  String get hiwCompareNotShown;

  /// No description provided for @hiwCompareNotShownExamples.
  ///
  /// In en, this message translates to:
  /// **'Crop and animal status, inventory and items, individual relationships'**
  String get hiwCompareNotShownExamples;

  /// No description provided for @hiwCompareWarning.
  ///
  /// In en, this message translates to:
  /// **'They\'re not shown — they change in any direction and don\'t indicate which save is ahead.'**
  String get hiwCompareWarning;

  /// No description provided for @hiwConflictTitle.
  ///
  /// In en, this message translates to:
  /// **'If you play without syncing'**
  String get hiwConflictTitle;

  /// No description provided for @hiwConflictDesc.
  ///
  /// In en, this message translates to:
  /// **'If you advance on mobile and PC without syncing between sessions, you end up with two versions of the same save.'**
  String get hiwConflictDesc;

  /// No description provided for @hiwConflictNoMerge.
  ///
  /// In en, this message translates to:
  /// **'They can\'t be merged. ValleySave always shows you both versions so you can choose which to keep.'**
  String get hiwConflictNoMerge;

  /// No description provided for @hiwConflictMobile.
  ///
  /// In en, this message translates to:
  /// **'Mobile'**
  String get hiwConflictMobile;

  /// No description provided for @hiwConflictVersionA.
  ///
  /// In en, this message translates to:
  /// **'version A'**
  String get hiwConflictVersionA;

  /// No description provided for @hiwConflictPC.
  ///
  /// In en, this message translates to:
  /// **'PC'**
  String get hiwConflictPC;

  /// No description provided for @hiwConflictVersionB.
  ///
  /// In en, this message translates to:
  /// **'version B'**
  String get hiwConflictVersionB;

  /// No description provided for @hiwDeleteTitle.
  ///
  /// In en, this message translates to:
  /// **'If a save is deleted'**
  String get hiwDeleteTitle;

  /// No description provided for @hiwDeleteDesc.
  ///
  /// In en, this message translates to:
  /// **'When you delete a save from Drive, it doesn\'t disappear immediately: it goes to Google Drive Trash.'**
  String get hiwDeleteDesc;

  /// No description provided for @hiwCompatTitle.
  ///
  /// In en, this message translates to:
  /// **'Platform compatibility'**
  String get hiwCompatTitle;

  /// No description provided for @hiwCompatAndroidAccess.
  ///
  /// In en, this message translates to:
  /// **'ACCESS ON ANDROID'**
  String get hiwCompatAndroidAccess;

  /// No description provided for @hiwShizukuTitle.
  ///
  /// In en, this message translates to:
  /// **'With Shizuku'**
  String get hiwShizukuTitle;

  /// No description provided for @hiwShizukuSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Set up once. After that, ValleySave syncs by itself, without you ever touching it again.'**
  String get hiwShizukuSubtitle;

  /// No description provided for @hiwShizukuBadge.
  ///
  /// In en, this message translates to:
  /// **'AUTOMATIC · RECOMMENDED'**
  String get hiwShizukuBadge;

  /// No description provided for @hiwShizukuDone.
  ///
  /// In en, this message translates to:
  /// **'✓  Done. From then on, downloading and uploading saves is direct, just like on a computer.'**
  String get hiwShizukuDone;

  /// No description provided for @hiwShizukuNote.
  ///
  /// In en, this message translates to:
  /// **'Pairing is only the first time. New Shizuku versions reactivate by themselves after restarting your phone.'**
  String get hiwShizukuNote;

  /// No description provided for @hiwBridgeTitle.
  ///
  /// In en, this message translates to:
  /// **'Manual bridge'**
  String get hiwBridgeTitle;

  /// No description provided for @hiwBridgeSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Only works on Android 11 and 12. You don\'t install anything extra; instead, you copy the save by hand with your Files app every time you sync.'**
  String get hiwBridgeSubtitle;

  /// No description provided for @hiwBridgeBadge.
  ///
  /// In en, this message translates to:
  /// **'MANUAL ALTERNATIVE · ANDROID 11-12'**
  String get hiwBridgeBadge;

  /// No description provided for @hiwBridgeSaveFolder.
  ///
  /// In en, this message translates to:
  /// **'Stardew\'s folder'**
  String get hiwBridgeSaveFolder;

  /// No description provided for @hiwBridgeValleySaveFolder.
  ///
  /// In en, this message translates to:
  /// **'ValleySave\'s folder'**
  String get hiwBridgeValleySaveFolder;

  /// No description provided for @hiwBridgeNote.
  ///
  /// In en, this message translates to:
  /// **'It works because your system Files app can access those folders (ValleySave can\'t).'**
  String get hiwBridgeNote;

  /// No description provided for @hiwTipAlwaysShow.
  ///
  /// In en, this message translates to:
  /// **'You\'ll always see what\'s on Drive...'**
  String get hiwTipAlwaysShow;

  /// No description provided for @hiwTipWithoutUpload.
  ///
  /// In en, this message translates to:
  /// **'Without uploading, no other device...'**
  String get hiwTipWithoutUpload;

  /// No description provided for @hiwTipComparison.
  ///
  /// In en, this message translates to:
  /// **'You\'ll see the comparison between local and Drive...'**
  String get hiwTipComparison;

  /// No description provided for @hiwTipDownloadOverwrite.
  ///
  /// In en, this message translates to:
  /// **'Downloading overwrites your local save...'**
  String get hiwTipDownloadOverwrite;

  /// No description provided for @hiwTipSync.
  ///
  /// In en, this message translates to:
  /// **'Always upload before switching devices...'**
  String get hiwTipSync;

  /// No description provided for @hiwTipDeletion.
  ///
  /// In en, this message translates to:
  /// **'Deleted saves go to Drive Trash...'**
  String get hiwTipDeletion;

  /// No description provided for @hiwPrivacyLink.
  ///
  /// In en, this message translates to:
  /// **'Privacy policy and usage'**
  String get hiwPrivacyLink;

  /// No description provided for @emptyNoSaves.
  ///
  /// In en, this message translates to:
  /// **'No saves found'**
  String get emptyNoSaves;

  /// No description provided for @emptyNoSavesHint.
  ///
  /// In en, this message translates to:
  /// **'No local saves can be read on this device'**
  String get emptyNoSavesHint;

  /// No description provided for @bridgeTitle.
  ///
  /// In en, this message translates to:
  /// **'Bring your saves'**
  String get bridgeTitle;

  /// No description provided for @bridgeDesc.
  ///
  /// In en, this message translates to:
  /// **'To see and upload your local saves, copy them with your Files app from the Stardew folder to this ValleySave folder. Then swipe to refresh.'**
  String get bridgeDesc;

  /// No description provided for @bridgeRefresh.
  ///
  /// In en, this message translates to:
  /// **'Refresh'**
  String get bridgeRefresh;

  /// No description provided for @bridgeChangeMode.
  ///
  /// In en, this message translates to:
  /// **'Change method'**
  String get bridgeChangeMode;

  /// No description provided for @loaderLoading.
  ///
  /// In en, this message translates to:
  /// **'LOADING'**
  String get loaderLoading;

  /// No description provided for @loaderConnecting.
  ///
  /// In en, this message translates to:
  /// **'connecting to Drive…'**
  String get loaderConnecting;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>[
    'de',
    'en',
    'es',
    'fr',
    'it',
    'ja',
    'ko',
    'pt',
    'ru',
    'th',
    'uk',
    'zh',
  ].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when language+script codes are specified.
  switch (locale.languageCode) {
    case 'zh':
      {
        switch (locale.scriptCode) {
          case 'Hant':
            return AppLocalizationsZhHant();
        }
        break;
      }
  }

  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'de':
      return AppLocalizationsDe();
    case 'en':
      return AppLocalizationsEn();
    case 'es':
      return AppLocalizationsEs();
    case 'fr':
      return AppLocalizationsFr();
    case 'it':
      return AppLocalizationsIt();
    case 'ja':
      return AppLocalizationsJa();
    case 'ko':
      return AppLocalizationsKo();
    case 'pt':
      return AppLocalizationsPt();
    case 'ru':
      return AppLocalizationsRu();
    case 'th':
      return AppLocalizationsTh();
    case 'uk':
      return AppLocalizationsUk();
    case 'zh':
      return AppLocalizationsZh();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
