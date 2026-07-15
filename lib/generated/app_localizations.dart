import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_de.dart';
import 'app_localizations_en.dart';
import 'app_localizations_es.dart';
import 'app_localizations_eu.dart';
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
    Locale('eu'),
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
  /// **'Source available'**
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
  /// **'Just checked'**
  String get updateCheckedNow;

  /// No description provided for @updateOutdatedDownload.
  ///
  /// In en, this message translates to:
  /// **'Not up to date · Download'**
  String get updateOutdatedDownload;

  /// No description provided for @updateDownloading.
  ///
  /// In en, this message translates to:
  /// **'Downloading update…'**
  String get updateDownloading;

  /// No description provided for @updateError.
  ///
  /// In en, this message translates to:
  /// **'Error — tap to retry'**
  String get updateError;

  /// No description provided for @disconnectTitle.
  ///
  /// In en, this message translates to:
  /// **'Disconnect Drive?'**
  String get disconnectTitle;

  /// No description provided for @disconnectBody.
  ///
  /// In en, this message translates to:
  /// **'This will sign {email} out. Your saves on Drive won\'t be deleted, you can reconnect anytime.'**
  String disconnectBody(String email);

  /// No description provided for @disconnectButton.
  ///
  /// In en, this message translates to:
  /// **'Disconnect Drive'**
  String get disconnectButton;

  /// No description provided for @disconnectButtonEmail.
  ///
  /// In en, this message translates to:
  /// **'Disconnect from {email}'**
  String disconnectButtonEmail(String email);

  /// No description provided for @connectedAsPrefix.
  ///
  /// In en, this message translates to:
  /// **'Connected as'**
  String get connectedAsPrefix;

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
  /// **'System language'**
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
  /// **'Drive ahead'**
  String get cardDriveAhead;

  /// No description provided for @cardLocalOnly.
  ///
  /// In en, this message translates to:
  /// **'Local only'**
  String get cardLocalOnly;

  /// No description provided for @cardDriveOnly.
  ///
  /// In en, this message translates to:
  /// **'Drive only'**
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
  /// **'{months}mo ago'**
  String cardTimeMonthsAgo(int months);

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

  /// No description provided for @exportAction.
  ///
  /// In en, this message translates to:
  /// **'Export'**
  String get exportAction;

  /// No description provided for @exportSuccess.
  ///
  /// In en, this message translates to:
  /// **'Save exported.'**
  String get exportSuccess;

  /// No description provided for @exportError.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t export the save: {error}'**
  String exportError(String error);

  /// No description provided for @importAction.
  ///
  /// In en, this message translates to:
  /// **'Import save'**
  String get importAction;

  /// No description provided for @importSuccess.
  ///
  /// In en, this message translates to:
  /// **'{playerName}\'s save imported.'**
  String importSuccess(String playerName);

  /// No description provided for @importErrInvalidZip.
  ///
  /// In en, this message translates to:
  /// **'This isn\'t a valid zip file.'**
  String get importErrInvalidZip;

  /// No description provided for @importErrUnsafePath.
  ///
  /// In en, this message translates to:
  /// **'This file has an unsafe structure and was rejected.'**
  String get importErrUnsafePath;

  /// No description provided for @importErrTooLarge.
  ///
  /// In en, this message translates to:
  /// **'This file is too large to import.'**
  String get importErrTooLarge;

  /// No description provided for @importErrNotASave.
  ///
  /// In en, this message translates to:
  /// **'This file doesn\'t contain a recognizable save.'**
  String get importErrNotASave;

  /// No description provided for @importErrWrite.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t write the imported save (disk/permissions).'**
  String get importErrWrite;

  /// No description provided for @importConflictTitle.
  ///
  /// In en, this message translates to:
  /// **'A save with this name already exists'**
  String get importConflictTitle;

  /// No description provided for @importConflictBody.
  ///
  /// In en, this message translates to:
  /// **'Importing will replace the existing local copy. This can\'t be undone.'**
  String get importConflictBody;

  /// No description provided for @importConflictConfirm.
  ///
  /// In en, this message translates to:
  /// **'Overwrite'**
  String get importConflictConfirm;

  /// No description provided for @shareAction.
  ///
  /// In en, this message translates to:
  /// **'Share'**
  String get shareAction;

  /// No description provided for @shareUploadFirstCta.
  ///
  /// In en, this message translates to:
  /// **'Upload first'**
  String get shareUploadFirstCta;

  /// No description provided for @shareDialogTitle.
  ///
  /// In en, this message translates to:
  /// **'Share save'**
  String get shareDialogTitle;

  /// No description provided for @shareEmailPlaceholder.
  ///
  /// In en, this message translates to:
  /// **'name@example.com'**
  String get shareEmailPlaceholder;

  /// No description provided for @shareInfoNote.
  ///
  /// In en, this message translates to:
  /// **'Sharing gives view-and-download access only. Only you can edit or delete your copy in Drive.'**
  String get shareInfoNote;

  /// No description provided for @shareRoleReader.
  ///
  /// In en, this message translates to:
  /// **'Read only'**
  String get shareRoleReader;

  /// No description provided for @shareRoleWriter.
  ///
  /// In en, this message translates to:
  /// **'Allow sync'**
  String get shareRoleWriter;

  /// No description provided for @shareInfoNoteCoop.
  ///
  /// In en, this message translates to:
  /// **'Read only lets them view and download. Allow sync lets them overwrite your copy in Drive — they can never delete it.'**
  String get shareInfoNoteCoop;

  /// No description provided for @shareConfirmButton.
  ///
  /// In en, this message translates to:
  /// **'Share'**
  String get shareConfirmButton;

  /// No description provided for @shareSuccess.
  ///
  /// In en, this message translates to:
  /// **'Shared with {email}.'**
  String shareSuccess(String email);

  /// No description provided for @manageAccessTitle.
  ///
  /// In en, this message translates to:
  /// **'People with access'**
  String get manageAccessTitle;

  /// No description provided for @manageAccessEmpty.
  ///
  /// In en, this message translates to:
  /// **'Nobody else has access yet.'**
  String get manageAccessEmpty;

  /// No description provided for @manageAccessRoleLabel.
  ///
  /// In en, this message translates to:
  /// **'Access'**
  String get manageAccessRoleLabel;

  /// No description provided for @manageAccessRevoke.
  ///
  /// In en, this message translates to:
  /// **'Revoke'**
  String get manageAccessRevoke;

  /// No description provided for @manageAccessRevokeConfirm.
  ///
  /// In en, this message translates to:
  /// **'Remove {email}\'s access? Any local copy they already downloaded is theirs to keep.'**
  String manageAccessRevokeConfirm(String email);

  /// No description provided for @driveOnlyControlsYourCopy.
  ///
  /// In en, this message translates to:
  /// **'Sharing controls your copy in Drive. If someone downloads it, that copy is theirs.'**
  String get driveOnlyControlsYourCopy;

  /// No description provided for @driveOnlyControlsYourCopyCoop.
  ///
  /// In en, this message translates to:
  /// **'Sync controls your copy in Drive — it can be overwritten, but never deleted, by people you allow to sync.'**
  String get driveOnlyControlsYourCopyCoop;

  /// No description provided for @sharedWithMeTitle.
  ///
  /// In en, this message translates to:
  /// **'Shared with me'**
  String get sharedWithMeTitle;

  /// No description provided for @sharedWithMeEmpty.
  ///
  /// In en, this message translates to:
  /// **'Nothing shared with you yet.'**
  String get sharedWithMeEmpty;

  /// No description provided for @sharedWithMeAdd.
  ///
  /// In en, this message translates to:
  /// **'Add shared save'**
  String get sharedWithMeAdd;

  /// No description provided for @sharedWithMeOwnedBy.
  ///
  /// In en, this message translates to:
  /// **'Shared by {email}'**
  String sharedWithMeOwnedBy(String email);

  /// No description provided for @sharedWithMeRoleSync.
  ///
  /// In en, this message translates to:
  /// **'Sync'**
  String get sharedWithMeRoleSync;

  /// No description provided for @sharedWithMeRoleRead.
  ///
  /// In en, this message translates to:
  /// **'Read only'**
  String get sharedWithMeRoleRead;

  /// No description provided for @sharedWithMeSync.
  ///
  /// In en, this message translates to:
  /// **'Sync'**
  String get sharedWithMeSync;

  /// No description provided for @sharedWithMeDownload.
  ///
  /// In en, this message translates to:
  /// **'Download'**
  String get sharedWithMeDownload;

  /// No description provided for @sharedWithMeRemove.
  ///
  /// In en, this message translates to:
  /// **'Remove from list'**
  String get sharedWithMeRemove;

  /// No description provided for @sharedWithMeRemoveConfirm.
  ///
  /// In en, this message translates to:
  /// **'You\'ll stop syncing with {email}\'s Drive, but you can add it back anytime — it stays shared. Your local copy remains a normal coop save.'**
  String sharedWithMeRemoveConfirm(String email);

  /// No description provided for @sharedLeaveConfirm.
  ///
  /// In en, this message translates to:
  /// **'You\'ll lose access to this save for real. You won\'t be able to add it back unless {email} shares it with you again. Your local copy remains a normal coop save.'**
  String sharedLeaveConfirm(Object email);

  /// No description provided for @sharedManageButton.
  ///
  /// In en, this message translates to:
  /// **'Manage'**
  String get sharedManageButton;

  /// No description provided for @sharedManageDialogTitle.
  ///
  /// In en, this message translates to:
  /// **'Manage shared saves'**
  String get sharedManageDialogTitle;

  /// No description provided for @sharedManageDialogHint.
  ///
  /// In en, this message translates to:
  /// **'Here you can really leave a shared save.'**
  String get sharedManageDialogHint;

  /// No description provided for @sharedLeaveButton.
  ///
  /// In en, this message translates to:
  /// **'Leave shared save'**
  String get sharedLeaveButton;

  /// No description provided for @sharedLeaveSuccess.
  ///
  /// In en, this message translates to:
  /// **'You left {email}\'s shared save.'**
  String sharedLeaveSuccess(Object email);

  /// No description provided for @sharedWithMeSyncConfirm.
  ///
  /// In en, this message translates to:
  /// **'Overwrite {email}\'s copy in Drive with your local save?'**
  String sharedWithMeSyncConfirm(String email);

  /// No description provided for @sharedAccessReadOnly.
  ///
  /// In en, this message translates to:
  /// **'{email} set your access to read-only — you can view and download, but not sync to their Drive.'**
  String sharedAccessReadOnly(String email);

  /// No description provided for @sharedWithMeRevoked.
  ///
  /// In en, this message translates to:
  /// **'You no longer have access'**
  String get sharedWithMeRevoked;

  /// No description provided for @sharedRevokedDialogBody.
  ///
  /// In en, this message translates to:
  /// **'{email} stopped sharing {farmName} with you. Your local copy and the one on your Drive stay as they are, now under My saves.'**
  String sharedRevokedDialogBody(String email, String farmName);

  /// No description provided for @sharedRevokedAccept.
  ///
  /// In en, this message translates to:
  /// **'Accept'**
  String get sharedRevokedAccept;

  /// No description provided for @sharedSelfCleanupTitle.
  ///
  /// In en, this message translates to:
  /// **'Record fixed'**
  String get sharedSelfCleanupTitle;

  /// No description provided for @sharedSelfCleanupBody.
  ///
  /// In en, this message translates to:
  /// **'{farmName} showed up as shared with you by mistake — it\'s actually yours. It\'s been fixed, now it\'s under My saves.'**
  String sharedSelfCleanupBody(String farmName);

  /// No description provided for @sharedWithMeUploadOwn.
  ///
  /// In en, this message translates to:
  /// **'Upload to my Drive'**
  String get sharedWithMeUploadOwn;

  /// No description provided for @sharedDownloadOwn.
  ///
  /// In en, this message translates to:
  /// **'Download from my Drive'**
  String get sharedDownloadOwn;

  /// No description provided for @sharedStatusOwnDriveAhead.
  ///
  /// In en, this message translates to:
  /// **'Your Drive is ahead — bring it down'**
  String get sharedStatusOwnDriveAhead;

  /// No description provided for @sharedSyncBoth.
  ///
  /// In en, this message translates to:
  /// **'Sync both'**
  String get sharedSyncBoth;

  /// No description provided for @sharedSideMyDrive.
  ///
  /// In en, this message translates to:
  /// **'MY DRIVE'**
  String get sharedSideMyDrive;

  /// No description provided for @sharedSideOwnerDrive.
  ///
  /// In en, this message translates to:
  /// **'{email}\'s DRIVE'**
  String sharedSideOwnerDrive(String email);

  /// No description provided for @sharedSideDate.
  ///
  /// In en, this message translates to:
  /// **'Day {day} · Year {year}'**
  String sharedSideDate(int day, int year);

  /// No description provided for @sharedStatusSyncedNoOwnDrive.
  ///
  /// In en, this message translates to:
  /// **'Synced with the owner · no copy in your Drive'**
  String get sharedStatusSyncedNoOwnDrive;

  /// No description provided for @sharedStatusAheadNoOwnDrive.
  ///
  /// In en, this message translates to:
  /// **'You\'re ahead · no copy in your Drive'**
  String get sharedStatusAheadNoOwnDrive;

  /// No description provided for @sharedStatusOwnerAheadNoOwnDrive.
  ///
  /// In en, this message translates to:
  /// **'{email} is ahead · no copy in your Drive'**
  String sharedStatusOwnerAheadNoOwnDrive(String email);

  /// No description provided for @sharedStatusAllSynced.
  ///
  /// In en, this message translates to:
  /// **'Synced (local + both Drives)'**
  String get sharedStatusAllSynced;

  /// No description provided for @sharedStatusAheadBoth.
  ///
  /// In en, this message translates to:
  /// **'You\'re ahead on both Drives'**
  String get sharedStatusAheadBoth;

  /// No description provided for @sharedStatusMixed.
  ///
  /// In en, this message translates to:
  /// **'Out of sync — check each Drive'**
  String get sharedStatusMixed;

  /// No description provided for @sharedStatusFullySynced.
  ///
  /// In en, this message translates to:
  /// **'Fully synchronized'**
  String get sharedStatusFullySynced;

  /// No description provided for @sharedStatusSyncedOwn.
  ///
  /// In en, this message translates to:
  /// **'My Drive synchronized'**
  String get sharedStatusSyncedOwn;

  /// No description provided for @sharedStatusSyncedOwner.
  ///
  /// In en, this message translates to:
  /// **'Shared Drive synchronized'**
  String get sharedStatusSyncedOwner;

  /// No description provided for @sharedStatusNotCloud.
  ///
  /// In en, this message translates to:
  /// **'Only on this device'**
  String get sharedStatusNotCloud;

  /// No description provided for @sharedStatusOwnerAhead.
  ///
  /// In en, this message translates to:
  /// **'Drive at {email} is ahead'**
  String sharedStatusOwnerAhead(Object email);

  /// No description provided for @sharedStatusBothAhead.
  ///
  /// In en, this message translates to:
  /// **'Both Drives are ahead'**
  String get sharedStatusBothAhead;

  /// No description provided for @sharedStatusLocalMissing.
  ///
  /// In en, this message translates to:
  /// **'Not on this device'**
  String get sharedStatusLocalMissing;

  /// No description provided for @sharedStatusOwnerUnavailable.
  ///
  /// In en, this message translates to:
  /// **'Could not check Drive at {email}'**
  String sharedStatusOwnerUnavailable(Object email);

  /// No description provided for @sharedStatusWorking.
  ///
  /// In en, this message translates to:
  /// **'Synchronizing…'**
  String get sharedStatusWorking;

  /// No description provided for @sharedSideUnavailable.
  ///
  /// In en, this message translates to:
  /// **'Could not check'**
  String get sharedSideUnavailable;

  /// No description provided for @sharedSyncChooseTitle.
  ///
  /// In en, this message translates to:
  /// **'Where do you want to synchronize?'**
  String get sharedSyncChooseTitle;

  /// No description provided for @sharedSyncChooseBody.
  ///
  /// In en, this message translates to:
  /// **'Choose which cloud copies to update from this device.'**
  String get sharedSyncChooseBody;

  /// No description provided for @sharedSyncTargetOwn.
  ///
  /// In en, this message translates to:
  /// **'My Drive'**
  String get sharedSyncTargetOwn;

  /// No description provided for @sharedSyncTargetOwner.
  ///
  /// In en, this message translates to:
  /// **'Drive at {email}'**
  String sharedSyncTargetOwner(Object email);

  /// No description provided for @sharedSyncTargetBoth.
  ///
  /// In en, this message translates to:
  /// **'Both Drives'**
  String get sharedSyncTargetBoth;

  /// No description provided for @sharedDownloadChooseTitle.
  ///
  /// In en, this message translates to:
  /// **'Which copy do you want to download?'**
  String get sharedDownloadChooseTitle;

  /// No description provided for @sharedDownloadChooseBody.
  ///
  /// In en, this message translates to:
  /// **'More than one copy is ahead. Choose which one to bring to this device.'**
  String get sharedDownloadChooseBody;

  /// No description provided for @sharedDownloadSourceOwn.
  ///
  /// In en, this message translates to:
  /// **'From My Drive'**
  String get sharedDownloadSourceOwn;

  /// No description provided for @sharedDownloadSourceOwner.
  ///
  /// In en, this message translates to:
  /// **'From Drive at {email}'**
  String sharedDownloadSourceOwner(Object email);

  /// No description provided for @sharedWithMePickerTitle.
  ///
  /// In en, this message translates to:
  /// **'Add shared save'**
  String get sharedWithMePickerTitle;

  /// No description provided for @sharedPickerEmptyHint.
  ///
  /// In en, this message translates to:
  /// **'Folders another player shares with you from Drive show up here.'**
  String get sharedPickerEmptyHint;

  /// No description provided for @sharedPickerAddButton.
  ///
  /// In en, this message translates to:
  /// **'Add'**
  String get sharedPickerAddButton;

  /// No description provided for @sharedOriginBadge.
  ///
  /// In en, this message translates to:
  /// **'Shared'**
  String get sharedOriginBadge;

  /// No description provided for @sharedOriginFrom.
  ///
  /// In en, this message translates to:
  /// **'from {email}'**
  String sharedOriginFrom(String email);

  /// No description provided for @swapBackupDialogTitle.
  ///
  /// In en, this message translates to:
  /// **'Backup created'**
  String get swapBackupDialogTitle;

  /// No description provided for @swapBackupDialogBody.
  ///
  /// In en, this message translates to:
  /// **'The previous version was saved as a zip. What do you want to do with it?'**
  String get swapBackupDialogBody;

  /// No description provided for @swapBackupUpload.
  ///
  /// In en, this message translates to:
  /// **'Upload to Drive'**
  String get swapBackupUpload;

  /// No description provided for @swapBackupLocalOnly.
  ///
  /// In en, this message translates to:
  /// **'Keep on this device'**
  String get swapBackupLocalOnly;

  /// No description provided for @swapBackupDeleteNow.
  ///
  /// In en, this message translates to:
  /// **'Delete now'**
  String get swapBackupDeleteNow;

  /// No description provided for @swapBackupUploadOk.
  ///
  /// In en, this message translates to:
  /// **'Backup uploaded to Drive.'**
  String get swapBackupUploadOk;

  /// No description provided for @swapBackupUploadErr.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t upload the backup: {error}'**
  String swapBackupUploadErr(String error);

  /// No description provided for @swapBackupLocalOnlySnack.
  ///
  /// In en, this message translates to:
  /// **'Backup saved on this device.'**
  String get swapBackupLocalOnlySnack;

  /// No description provided for @backupsAction.
  ///
  /// In en, this message translates to:
  /// **'Backups'**
  String get backupsAction;

  /// No description provided for @backupsScreenTitle.
  ///
  /// In en, this message translates to:
  /// **'Backups of {farmName}'**
  String backupsScreenTitle(String farmName);

  /// No description provided for @backupsEmpty.
  ///
  /// In en, this message translates to:
  /// **'No backups yet.'**
  String get backupsEmpty;

  /// No description provided for @backupsRestore.
  ///
  /// In en, this message translates to:
  /// **'Restore'**
  String get backupsRestore;

  /// No description provided for @backupsRestoreConfirmTitle.
  ///
  /// In en, this message translates to:
  /// **'Restore this backup?'**
  String get backupsRestoreConfirmTitle;

  /// No description provided for @backupsRestoreConfirmBody.
  ///
  /// In en, this message translates to:
  /// **'This overwrites your current save with this earlier version. This can\'t be undone.'**
  String get backupsRestoreConfirmBody;

  /// No description provided for @backupsDelete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get backupsDelete;

  /// No description provided for @backupsDeleteConfirmTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete this backup?'**
  String get backupsDeleteConfirmTitle;

  /// No description provided for @backupsDeleteConfirmBody.
  ///
  /// In en, this message translates to:
  /// **'Deletes it everywhere it exists (this device and Drive, if uploaded). This can\'t be undone.'**
  String get backupsDeleteConfirmBody;

  /// No description provided for @backupsRestoreOk.
  ///
  /// In en, this message translates to:
  /// **'Backup restored.'**
  String get backupsRestoreOk;

  /// No description provided for @backupsRestoreErr.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t restore the backup: {error}'**
  String backupsRestoreErr(String error);

  /// No description provided for @backupsDeleteErr.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t delete the backup: {error}'**
  String backupsDeleteErr(String error);

  /// No description provided for @backupsCreate.
  ///
  /// In en, this message translates to:
  /// **'Create local backup'**
  String get backupsCreate;

  /// No description provided for @backupsCreateLocalHint.
  ///
  /// In en, this message translates to:
  /// **'Backups are created on this device first. You can upload them to Drive afterwards.'**
  String get backupsCreateLocalHint;

  /// No description provided for @backupsCreateOk.
  ///
  /// In en, this message translates to:
  /// **'Backup created.'**
  String get backupsCreateOk;

  /// No description provided for @backupsCreateErr.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t create the backup: {error}'**
  String backupsCreateErr(String error);

  /// No description provided for @backupsDownload.
  ///
  /// In en, this message translates to:
  /// **'Download'**
  String get backupsDownload;

  /// No description provided for @backupsDownloadOk.
  ///
  /// In en, this message translates to:
  /// **'Backup downloaded to this device.'**
  String get backupsDownloadOk;

  /// No description provided for @backupsDownloadErr.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t download the backup: {error}'**
  String backupsDownloadErr(String error);

  /// No description provided for @backupsCopyOwn.
  ///
  /// In en, this message translates to:
  /// **'Copy to my Drive'**
  String get backupsCopyOwn;

  /// No description provided for @backupsUploadOwn.
  ///
  /// In en, this message translates to:
  /// **'To my Drive'**
  String get backupsUploadOwn;

  /// No description provided for @backupsUploadShared.
  ///
  /// In en, this message translates to:
  /// **'To shared Drive'**
  String get backupsUploadShared;

  /// No description provided for @backupsUploadOk.
  ///
  /// In en, this message translates to:
  /// **'Backup uploaded.'**
  String get backupsUploadOk;

  /// No description provided for @backupsUploadErr.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t upload the backup: {error}'**
  String backupsUploadErr(String error);

  /// No description provided for @backupsLocationLocal.
  ///
  /// In en, this message translates to:
  /// **'This device'**
  String get backupsLocationLocal;

  /// No description provided for @backupsLocationOwnDrive.
  ///
  /// In en, this message translates to:
  /// **'My Drive'**
  String get backupsLocationOwnDrive;

  /// No description provided for @backupsLocationSharedDrive.
  ///
  /// In en, this message translates to:
  /// **'Shared Drive'**
  String get backupsLocationSharedDrive;

  /// No description provided for @backupsDeleteChooseBody.
  ///
  /// In en, this message translates to:
  /// **'Choose exactly where to delete it. Only locations where this backup exists are shown.'**
  String get backupsDeleteChooseBody;

  /// No description provided for @backupsDeleteLocalOnly.
  ///
  /// In en, this message translates to:
  /// **'Only from this device'**
  String get backupsDeleteLocalOnly;

  /// No description provided for @backupsDeleteOwnOnly.
  ///
  /// In en, this message translates to:
  /// **'Only from my Drive'**
  String get backupsDeleteOwnOnly;

  /// No description provided for @backupsDeleteSharedOnly.
  ///
  /// In en, this message translates to:
  /// **'Only from shared Drive'**
  String get backupsDeleteSharedOnly;

  /// No description provided for @backupsDeleteAll.
  ///
  /// In en, this message translates to:
  /// **'From all copies'**
  String get backupsDeleteAll;

  /// No description provided for @deleteUnifiedTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete {farmName}?'**
  String deleteUnifiedTitle(String farmName);

  /// No description provided for @deleteChooseLocationBody.
  ///
  /// In en, this message translates to:
  /// **'Choose where. Your device copy is deleted forever; the Drive copy goes to Trash (30 days).'**
  String get deleteChooseLocationBody;

  /// No description provided for @deleteDriveContextTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete {farmName} from Drive?'**
  String deleteDriveContextTitle(String farmName);

  /// No description provided for @deleteDriveContextBody.
  ///
  /// In en, this message translates to:
  /// **'The Drive copy will move to Trash, where it can be recovered for 30 days.'**
  String get deleteDriveContextBody;

  /// No description provided for @deleteDriveLocalKept.
  ///
  /// In en, this message translates to:
  /// **'The copy on this device will remain unchanged.'**
  String get deleteDriveLocalKept;

  /// No description provided for @deleteLocalContextTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete {farmName} from this device?'**
  String deleteLocalContextTitle(String farmName);

  /// No description provided for @deleteLocalContextBody.
  ///
  /// In en, this message translates to:
  /// **'The copy on this device will be deleted permanently.'**
  String get deleteLocalContextBody;

  /// No description provided for @deleteLocalDriveCurrent.
  ///
  /// In en, this message translates to:
  /// **'Your Drive copy is up to date ({date}) and will remain available.'**
  String deleteLocalDriveCurrent(String date);

  /// No description provided for @deleteLocalDriveAhead.
  ///
  /// In en, this message translates to:
  /// **'Your Drive copy is newer ({date}) and will remain available.'**
  String deleteLocalDriveAhead(String date);

  /// No description provided for @deleteLocalDriveOlder.
  ///
  /// In en, this message translates to:
  /// **'Your Drive copy is older ({driveDate}); this device is at {localDate}.'**
  String deleteLocalDriveOlder(String driveDate, String localDate);

  /// No description provided for @deleteLocalBackupAvailable.
  ///
  /// In en, this message translates to:
  /// **'There are {count} local backups available if you need an earlier copy.'**
  String deleteLocalBackupAvailable(int count);

  /// No description provided for @deleteLocalNoRecovery.
  ///
  /// In en, this message translates to:
  /// **'There is no Drive copy or local backup to recover this game from.'**
  String get deleteLocalNoRecovery;

  /// No description provided for @deleteOptionLocalOnly.
  ///
  /// In en, this message translates to:
  /// **'Only from this device'**
  String get deleteOptionLocalOnly;

  /// No description provided for @deleteOptionDriveOnly.
  ///
  /// In en, this message translates to:
  /// **'Only from Drive'**
  String get deleteOptionDriveOnly;

  /// No description provided for @deleteOptionBoth.
  ///
  /// In en, this message translates to:
  /// **'From both (device + Drive)'**
  String get deleteOptionBoth;

  /// No description provided for @viewPlayersHint.
  ///
  /// In en, this message translates to:
  /// **'View players'**
  String get viewPlayersHint;

  /// No description provided for @snackDeletedBoth.
  ///
  /// In en, this message translates to:
  /// **'\"{saveName}\" deleted from this device and moved to Drive Trash.'**
  String snackDeletedBoth(String saveName);

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

  /// No description provided for @pillSleeps.
  ///
  /// In en, this message translates to:
  /// **'Sleeps'**
  String get pillSleeps;

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
  /// **'You\'ll always see what\'s on Drive before overwriting, so you can compare.'**
  String get hiwTipAlwaysShow;

  /// No description provided for @hiwTipWithoutUpload.
  ///
  /// In en, this message translates to:
  /// **'Without uploading, no other device will see your recent progress.'**
  String get hiwTipWithoutUpload;

  /// No description provided for @hiwTipComparison.
  ///
  /// In en, this message translates to:
  /// **'You\'ll see the comparison between local and Drive before confirming.'**
  String get hiwTipComparison;

  /// No description provided for @hiwTipDownloadOverwrite.
  ///
  /// In en, this message translates to:
  /// **'Downloading overwrites your local save. Any unsynced progress will be lost.'**
  String get hiwTipDownloadOverwrite;

  /// No description provided for @hiwTipSync.
  ///
  /// In en, this message translates to:
  /// **'Always upload before switching devices, and download when you arrive.'**
  String get hiwTipSync;

  /// No description provided for @hiwTipDeletion.
  ///
  /// In en, this message translates to:
  /// **'You have 30 days to restore it from Drive Trash before it\'s permanently deleted.'**
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

  /// No description provided for @chooserTitle.
  ///
  /// In en, this message translates to:
  /// **'Choose how to connect'**
  String get chooserTitle;

  /// No description provided for @chooserAutomatic.
  ///
  /// In en, this message translates to:
  /// **'Automatic · Recommended'**
  String get chooserAutomatic;

  /// No description provided for @chooserManual.
  ///
  /// In en, this message translates to:
  /// **'Manual alternative · Android 11-12'**
  String get chooserManual;

  /// No description provided for @shizukuStepTitle.
  ///
  /// In en, this message translates to:
  /// **'Set up Shizuku'**
  String get shizukuStepTitle;

  /// No description provided for @shizukuStep1Title.
  ///
  /// In en, this message translates to:
  /// **'Install Shizuku'**
  String get shizukuStep1Title;

  /// No description provided for @shizukuStep1Desc.
  ///
  /// In en, this message translates to:
  /// **'Download from Play Store or GitHub'**
  String get shizukuStep1Desc;

  /// No description provided for @shizukuStep2Title.
  ///
  /// In en, this message translates to:
  /// **'Activate Shizuku'**
  String get shizukuStep2Title;

  /// No description provided for @shizukuStep2Desc.
  ///
  /// In en, this message translates to:
  /// **'Run the app and grant permissions'**
  String get shizukuStep2Desc;

  /// No description provided for @shizukuStep3Title.
  ///
  /// In en, this message translates to:
  /// **'Grant permission'**
  String get shizukuStep3Title;

  /// No description provided for @shizukuStep3Desc.
  ///
  /// In en, this message translates to:
  /// **'ValleySave will ask for access'**
  String get shizukuStep3Desc;

  /// No description provided for @shizukuDone.
  ///
  /// In en, this message translates to:
  /// **'✓  Done. From then on, downloading and uploading saves works directly, like on a computer.'**
  String get shizukuDone;

  /// No description provided for @dlgDeleteDriveTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete from Drive'**
  String get dlgDeleteDriveTitle;

  /// No description provided for @dlgDeleteLocalTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete from this device'**
  String get dlgDeleteLocalTitle;

  /// No description provided for @dlgDownloadTitle.
  ///
  /// In en, this message translates to:
  /// **'Download save'**
  String get dlgDownloadTitle;

  /// No description provided for @dlgUploadTitle.
  ///
  /// In en, this message translates to:
  /// **'Upload save'**
  String get dlgUploadTitle;

  /// No description provided for @dlgUploadOverwrite.
  ///
  /// In en, this message translates to:
  /// **'This will overwrite your local save'**
  String get dlgUploadOverwrite;

  /// No description provided for @dlgGotIt.
  ///
  /// In en, this message translates to:
  /// **'Got it'**
  String get dlgGotIt;

  /// No description provided for @dlgCopyDest.
  ///
  /// In en, this message translates to:
  /// **'Copy destination'**
  String get dlgCopyDest;

  /// No description provided for @previewColDayYear.
  ///
  /// In en, this message translates to:
  /// **'Day/Year'**
  String get previewColDayYear;

  /// No description provided for @previewColTime.
  ///
  /// In en, this message translates to:
  /// **'Playtime'**
  String get previewColTime;

  /// No description provided for @previewColMoney.
  ///
  /// In en, this message translates to:
  /// **'Coins'**
  String get previewColMoney;

  /// No description provided for @previewColTotal.
  ///
  /// In en, this message translates to:
  /// **'Total'**
  String get previewColTotal;

  /// No description provided for @previewColFarming.
  ///
  /// In en, this message translates to:
  /// **'Farming'**
  String get previewColFarming;

  /// No description provided for @previewColForaging.
  ///
  /// In en, this message translates to:
  /// **'Foraging'**
  String get previewColForaging;

  /// No description provided for @previewColMining.
  ///
  /// In en, this message translates to:
  /// **'Mining'**
  String get previewColMining;

  /// No description provided for @previewColFishing.
  ///
  /// In en, this message translates to:
  /// **'Fishing'**
  String get previewColFishing;

  /// No description provided for @previewColCombat.
  ///
  /// In en, this message translates to:
  /// **'Combat'**
  String get previewColCombat;

  /// No description provided for @previewColFriends.
  ///
  /// In en, this message translates to:
  /// **'Friends'**
  String get previewColFriends;

  /// No description provided for @previewColMonsters.
  ///
  /// In en, this message translates to:
  /// **'Monsters'**
  String get previewColMonsters;

  /// No description provided for @previewColFaints.
  ///
  /// In en, this message translates to:
  /// **'Faints'**
  String get previewColFaints;

  /// No description provided for @previewColMine.
  ///
  /// In en, this message translates to:
  /// **'Mine'**
  String get previewColMine;

  /// No description provided for @previewColUnexplored.
  ///
  /// In en, this message translates to:
  /// **'Unexplored'**
  String get previewColUnexplored;

  /// No description provided for @previewLocalLabel.
  ///
  /// In en, this message translates to:
  /// **'ON THIS DEVICE'**
  String get previewLocalLabel;

  /// No description provided for @previewDriveLabel.
  ///
  /// In en, this message translates to:
  /// **'ON DRIVE'**
  String get previewDriveLabel;

  /// No description provided for @previewFromDrive.
  ///
  /// In en, this message translates to:
  /// **'FROM DRIVE'**
  String get previewFromDrive;

  /// No description provided for @previewFromDevice.
  ///
  /// In en, this message translates to:
  /// **'FROM THIS DEVICE'**
  String get previewFromDevice;

  /// No description provided for @versionMismatch.
  ///
  /// In en, this message translates to:
  /// **'Different versions: local {local} · Drive {drive}…'**
  String versionMismatch(String local, String drive);

  /// No description provided for @snackPathCopied.
  ///
  /// In en, this message translates to:
  /// **'Path copied'**
  String get snackPathCopied;

  /// No description provided for @snackDestCopied.
  ///
  /// In en, this message translates to:
  /// **'Destination path copied'**
  String get snackDestCopied;

  /// No description provided for @snackDownloaded.
  ///
  /// In en, this message translates to:
  /// **'Save downloaded to the game'**
  String get snackDownloaded;

  /// No description provided for @snackSessionExpired.
  ///
  /// In en, this message translates to:
  /// **'Drive session expired. Reconnect'**
  String get snackSessionExpired;

  /// No description provided for @snackUploadError.
  ///
  /// In en, this message translates to:
  /// **'Upload error: {error}'**
  String snackUploadError(String error);

  /// No description provided for @snackDownloadError.
  ///
  /// In en, this message translates to:
  /// **'Download error: {error}'**
  String snackDownloadError(String error);

  /// No description provided for @snackDeleteError.
  ///
  /// In en, this message translates to:
  /// **'Delete error: {error}'**
  String snackDeleteError(String error);

  /// No description provided for @snackTrashed.
  ///
  /// In en, this message translates to:
  /// **'\"{saveName}\" moved to Drive Trash. You have 30 days to restore it.'**
  String snackTrashed(String saveName);

  /// No description provided for @snackDeletedLocal.
  ///
  /// In en, this message translates to:
  /// **'\"{saveName}\" deleted from this device'**
  String snackDeletedLocal(String saveName);

  /// No description provided for @snackShizukuRequired.
  ///
  /// In en, this message translates to:
  /// **'Enable Shizuku…'**
  String get snackShizukuRequired;

  /// No description provided for @snackWriteError.
  ///
  /// In en, this message translates to:
  /// **'Could not write to the game. Some phones block /Android/data even with Shizuku.'**
  String get snackWriteError;

  /// No description provided for @snackPlatformNotSupported.
  ///
  /// In en, this message translates to:
  /// **'This platform doesn\'t support writing local saves yet.'**
  String get snackPlatformNotSupported;

  /// No description provided for @snackWirelessDebugHint.
  ///
  /// In en, this message translates to:
  /// **'Open manually: Settings → Developer options → Wireless debugging.'**
  String get snackWirelessDebugHint;

  /// No description provided for @snackOpenShizukuApp.
  ///
  /// In en, this message translates to:
  /// **'Open Shizuku from your app drawer.'**
  String get snackOpenShizukuApp;

  /// No description provided for @hiwTipDeletePermanent.
  ///
  /// In en, this message translates to:
  /// **'ValleySave can\'t recover permanently deleted saves. Drive files are your responsibility.'**
  String get hiwTipDeletePermanent;

  /// No description provided for @hiwCompatAchievements.
  ///
  /// In en, this message translates to:
  /// **'Steam and Google Play achievements don\'t transfer. Each platform only tracks achievements that happen in real time — the save file doesn\'t trigger them retroactively.'**
  String get hiwCompatAchievements;

  /// No description provided for @hiwCompatOverwrite.
  ///
  /// In en, this message translates to:
  /// **'If you sync from two devices without a set order, one save can overwrite the other. Always upload before downloading.'**
  String get hiwCompatOverwrite;

  /// No description provided for @hiwCompatVersions.
  ///
  /// In en, this message translates to:
  /// **'Saves from different game versions may not load correctly. ValleySave warns you if it detects a version mismatch before downloading.'**
  String get hiwCompatVersions;

  /// No description provided for @hiwCompatMods.
  ///
  /// In en, this message translates to:
  /// **'SMAPI mods add extra data to the save. If you load a modded save on a device where those mods aren\'t installed, the game may crash or lose mod data.\n\nOn Android, SMAPI can also be installed to use mods.'**
  String get hiwCompatMods;

  /// No description provided for @hiwComparePrimary.
  ///
  /// In en, this message translates to:
  /// **'Total playtime'**
  String get hiwComparePrimary;

  /// No description provided for @hiwCompareNoShown1.
  ///
  /// In en, this message translates to:
  /// **'Crop and animal status'**
  String get hiwCompareNoShown1;

  /// No description provided for @hiwCompareNoShown2.
  ///
  /// In en, this message translates to:
  /// **'Inventory and items'**
  String get hiwCompareNoShown2;

  /// No description provided for @hiwCompareNoShown3.
  ///
  /// In en, this message translates to:
  /// **'Individual relationships'**
  String get hiwCompareNoShown3;

  /// No description provided for @hiwShizuku1.
  ///
  /// In en, this message translates to:
  /// **'Install Shizuku (Play Store or GitHub APK).'**
  String get hiwShizuku1;

  /// No description provided for @hiwShizuku2.
  ///
  /// In en, this message translates to:
  /// **'Activate it with Wireless Debugging — ValleySave guides you step by step.'**
  String get hiwShizuku2;

  /// No description provided for @hiwShizuku3.
  ///
  /// In en, this message translates to:
  /// **'Grant permission to ValleySave when prompted.'**
  String get hiwShizuku3;

  /// No description provided for @hiwBridge1.
  ///
  /// In en, this message translates to:
  /// **'Download from Drive: ValleySave leaves the save in its folder. You copy it with Files to Stardew\'s folder.'**
  String get hiwBridge1;

  /// No description provided for @hiwBridge2.
  ///
  /// In en, this message translates to:
  /// **'Upload to Drive: copy the save from Stardew to ValleySave\'s folder. ValleySave detects it and uploads it.'**
  String get hiwBridge2;

  /// No description provided for @snackShizukuBattery.
  ///
  /// In en, this message translates to:
  /// **'Settings → Apps → Shizuku → Battery → Unrestricted.'**
  String get snackShizukuBattery;

  /// No description provided for @snackDriveError.
  ///
  /// In en, this message translates to:
  /// **'Drive: {error}'**
  String snackDriveError(String error);

  /// No description provided for @dlgDeleteLocalWarning.
  ///
  /// In en, this message translates to:
  /// **'⚠️ If you haven\'t uploaded to Drive, it will be lost forever. No recovery.'**
  String get dlgDeleteLocalWarning;

  /// No description provided for @dlgDelete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get dlgDelete;

  /// No description provided for @dlgDownloadButton.
  ///
  /// In en, this message translates to:
  /// **'Download'**
  String get dlgDownloadButton;

  /// No description provided for @dlgUploadButton.
  ///
  /// In en, this message translates to:
  /// **'Upload'**
  String get dlgUploadButton;

  /// No description provided for @dlgBridgeCopyTitle.
  ///
  /// In en, this message translates to:
  /// **'Copy save to game'**
  String get dlgBridgeCopyTitle;

  /// No description provided for @dlgBridgeCopyDesc.
  ///
  /// In en, this message translates to:
  /// **'Save is ready. With your Files app, copy the \"{saveName}\" folder and paste it into the Stardew folder.'**
  String dlgBridgeCopyDesc(String saveName);

  /// No description provided for @labelFrom.
  ///
  /// In en, this message translates to:
  /// **'From'**
  String get labelFrom;

  /// No description provided for @labelTo.
  ///
  /// In en, this message translates to:
  /// **'To'**
  String get labelTo;

  /// No description provided for @dlgDownloadNewDesc.
  ///
  /// In en, this message translates to:
  /// **'\"{saveName}\" (Day {day}, {playtime}) will be copied to this device.'**
  String dlgDownloadNewDesc(String saveName, int day, String playtime);

  /// No description provided for @dlgDownloadOverwrite.
  ///
  /// In en, this message translates to:
  /// **'This OVERWRITES your local save of \"{saveName}\".'**
  String dlgDownloadOverwrite(String saveName);

  /// No description provided for @dlgUploadNewDesc.
  ///
  /// In en, this message translates to:
  /// **'\"{saveName}\" (Day {day}, {playtime}) will be uploaded to your Drive.'**
  String dlgUploadNewDesc(String saveName, int day, String playtime);

  /// No description provided for @dlgUploadOverwriteDrive.
  ///
  /// In en, this message translates to:
  /// **'This OVERWRITES the Drive version of \"{saveName}\".'**
  String dlgUploadOverwriteDrive(String saveName);

  /// No description provided for @pathLabelFromStardew.
  ///
  /// In en, this message translates to:
  /// **'From (Stardew)'**
  String get pathLabelFromStardew;

  /// No description provided for @pathLabelToValleySave.
  ///
  /// In en, this message translates to:
  /// **'To (ValleySave)'**
  String get pathLabelToValleySave;

  /// No description provided for @chooserDesc.
  ///
  /// In en, this message translates to:
  /// **'Android protects the game folder. Choose how to give ValleySave access — you can change it anytime.'**
  String get chooserDesc;

  /// No description provided for @chooserShizukuDesc.
  ///
  /// In en, this message translates to:
  /// **'Configured once. After that ValleySave syncs on its own, without you touching anything. Only reliable method on Android 13+.'**
  String get chooserShizukuDesc;

  /// No description provided for @chooserManualBadge.
  ///
  /// In en, this message translates to:
  /// **'ONLY ANDROID 11-12'**
  String get chooserManualBadge;

  /// No description provided for @chooserBridgeDesc.
  ///
  /// In en, this message translates to:
  /// **'Copy saves with your Files app. No extra install. Only on Android 11 and 12.'**
  String get chooserBridgeDesc;

  /// No description provided for @chooserRootBadge.
  ///
  /// In en, this message translates to:
  /// **'ROOT'**
  String get chooserRootBadge;

  /// No description provided for @chooserRootTitle.
  ///
  /// In en, this message translates to:
  /// **'Root Access'**
  String get chooserRootTitle;

  /// No description provided for @chooserRootDesc.
  ///
  /// In en, this message translates to:
  /// **'For rooted devices (Magisk / SuperSU). Approve the root prompt once — automatic from then on.'**
  String get chooserRootDesc;

  /// No description provided for @snackRootDenied.
  ///
  /// In en, this message translates to:
  /// **'Root access denied. Try Shizuku instead.'**
  String get snackRootDenied;

  /// No description provided for @shizukuGateSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Configured once · first time only'**
  String get shizukuGateSubtitle;

  /// No description provided for @shizukuStatusLabel.
  ///
  /// In en, this message translates to:
  /// **'Shizuku active'**
  String get shizukuStatusLabel;

  /// No description provided for @shizukuStatusRunning.
  ///
  /// In en, this message translates to:
  /// **'Connected and waiting.'**
  String get shizukuStatusRunning;

  /// No description provided for @shizukuStatusNotDetected.
  ///
  /// In en, this message translates to:
  /// **'Not detected yet.'**
  String get shizukuStatusNotDetected;

  /// No description provided for @shizukuPermLabel.
  ///
  /// In en, this message translates to:
  /// **'Permission granted'**
  String get shizukuPermLabel;

  /// No description provided for @shizukuPermGranted.
  ///
  /// In en, this message translates to:
  /// **'ValleySave already has access.'**
  String get shizukuPermGranted;

  /// No description provided for @shizukuPermNotGranted.
  ///
  /// In en, this message translates to:
  /// **'Need to authorize ValleySave.'**
  String get shizukuPermNotGranted;

  /// No description provided for @shizukuGrant.
  ///
  /// In en, this message translates to:
  /// **'grant'**
  String get shizukuGrant;

  /// No description provided for @shizukuGuideHeader.
  ///
  /// In en, this message translates to:
  /// **'STEP-BY-STEP GUIDE'**
  String get shizukuGuideHeader;

  /// No description provided for @shizukuStep1DescFull.
  ///
  /// In en, this message translates to:
  /// **'Free. If Google Play blocks it on your phone, use the official GitHub APK.'**
  String get shizukuStep1DescFull;

  /// No description provided for @btnPlayStore.
  ///
  /// In en, this message translates to:
  /// **'Play Store'**
  String get btnPlayStore;

  /// No description provided for @btnApkGithub.
  ///
  /// In en, this message translates to:
  /// **'APK GitHub'**
  String get btnApkGithub;

  /// No description provided for @shizukuStep2TitleFull.
  ///
  /// In en, this message translates to:
  /// **'Enable Developer Options'**
  String get shizukuStep2TitleFull;

  /// No description provided for @shizukuStep2DescFull.
  ///
  /// In en, this message translates to:
  /// **'Settings → Phone info → Software info → tap \"Build number\" 7 times.'**
  String get shizukuStep2DescFull;

  /// No description provided for @shizukuStep3TitleFull.
  ///
  /// In en, this message translates to:
  /// **'Enable Wireless Debugging'**
  String get shizukuStep3TitleFull;

  /// No description provided for @shizukuStep3DescFull.
  ///
  /// In en, this message translates to:
  /// **'The button takes you there and highlights it. Enable it (ON). Then tap \"Pair device with pairing code\" — a 6-digit code will appear on screen.'**
  String get shizukuStep3DescFull;

  /// No description provided for @btnOpenAndHighlight.
  ///
  /// In en, this message translates to:
  /// **'Open and highlight'**
  String get btnOpenAndHighlight;

  /// No description provided for @shizukuStep4Title.
  ///
  /// In en, this message translates to:
  /// **'Pair and START Shizuku'**
  String get shizukuStep4Title;

  /// No description provided for @shizukuStep4Desc.
  ///
  /// In en, this message translates to:
  /// **'Open Shizuku → \"Start via Wireless Debugging\" → \"Pair with pairing code\". Shizuku will send a notification saying it\'s waiting. Enter the 6-digit code from the Wireless Debugging screen. After pairing, press START — without that last tap Shizuku won\'t be active.'**
  String get shizukuStep4Desc;

  /// No description provided for @btnOpenShizuku.
  ///
  /// In en, this message translates to:
  /// **'Open Shizuku'**
  String get btnOpenShizuku;

  /// No description provided for @shizukuStep5Title.
  ///
  /// In en, this message translates to:
  /// **'Set Shizuku battery to Unrestricted'**
  String get shizukuStep5Title;

  /// No description provided for @shizukuStep5Desc.
  ///
  /// In en, this message translates to:
  /// **'Open app info → Battery → Unrestricted. If you don\'t, the system will close Shizuku in the background and you\'ll have to press Start again.'**
  String get shizukuStep5Desc;

  /// No description provided for @btnShizukuAppInfo.
  ///
  /// In en, this message translates to:
  /// **'Shizuku app info'**
  String get btnShizukuAppInfo;

  /// No description provided for @shizukuStep6DescActive.
  ///
  /// In en, this message translates to:
  /// **'Shizuku is active. Tap the button to authorize.'**
  String get shizukuStep6DescActive;

  /// No description provided for @shizukuStep6DescWaiting.
  ///
  /// In en, this message translates to:
  /// **'Available once Shizuku is active (step 4).'**
  String get shizukuStep6DescWaiting;

  /// No description provided for @btnGrantPermission.
  ///
  /// In en, this message translates to:
  /// **'Grant permission'**
  String get btnGrantPermission;

  /// No description provided for @btnCheckShizuku.
  ///
  /// In en, this message translates to:
  /// **'Done · Check'**
  String get btnCheckShizuku;

  /// No description provided for @statusDone.
  ///
  /// In en, this message translates to:
  /// **'done'**
  String get statusDone;

  /// No description provided for @statusPending.
  ///
  /// In en, this message translates to:
  /// **'pending'**
  String get statusPending;

  /// No description provided for @latestBadge.
  ///
  /// In en, this message translates to:
  /// **'· LATEST SAVE ·'**
  String get latestBadge;

  /// No description provided for @saveDateLabel.
  ///
  /// In en, this message translates to:
  /// **'{season} · Year {year}'**
  String saveDateLabel(String season, int year);

  /// No description provided for @petCat.
  ///
  /// In en, this message translates to:
  /// **'Cat'**
  String get petCat;

  /// No description provided for @petDog.
  ///
  /// In en, this message translates to:
  /// **'Dog'**
  String get petDog;

  /// No description provided for @houseBasic.
  ///
  /// In en, this message translates to:
  /// **'Basic house'**
  String get houseBasic;

  /// No description provided for @houseKitchen.
  ///
  /// In en, this message translates to:
  /// **'With kitchen'**
  String get houseKitchen;

  /// No description provided for @houseBedroom.
  ///
  /// In en, this message translates to:
  /// **'With bedroom'**
  String get houseBedroom;

  /// No description provided for @houseCellar.
  ///
  /// In en, this message translates to:
  /// **'With cellar'**
  String get houseCellar;

  /// No description provided for @houseLevelN.
  ///
  /// In en, this message translates to:
  /// **'Lv. {level}'**
  String houseLevelN(int level);

  /// No description provided for @tooltipLaunchGame.
  ///
  /// In en, this message translates to:
  /// **'Play'**
  String get tooltipLaunchGame;

  /// No description provided for @hiwLaunchTitle.
  ///
  /// In en, this message translates to:
  /// **'Launch the game'**
  String get hiwLaunchTitle;

  /// No description provided for @hiwLaunchDesc.
  ///
  /// In en, this message translates to:
  /// **'The ▶ button in the top bar of Your saves opens Stardew Valley directly from the app.'**
  String get hiwLaunchDesc;

  /// No description provided for @hiwLaunchTipWindows.
  ///
  /// In en, this message translates to:
  /// **'On Windows, if the game isn’t detected automatically, set the executable path in Settings → Game.'**
  String get hiwLaunchTipWindows;

  /// No description provided for @hiwLaunchTipAndroid.
  ///
  /// In en, this message translates to:
  /// **'On Android, opens the game if it’s installed.'**
  String get hiwLaunchTipAndroid;

  /// No description provided for @settingsGameSection.
  ///
  /// In en, this message translates to:
  /// **'Game'**
  String get settingsGameSection;

  /// No description provided for @settingsGameExePath.
  ///
  /// In en, this message translates to:
  /// **'Stardew Valley executable'**
  String get settingsGameExePath;

  /// No description provided for @settingsGameExeNotFound.
  ///
  /// In en, this message translates to:
  /// **'Not found automatically'**
  String get settingsGameExeNotFound;

  /// No description provided for @settingsGameExeBrowse.
  ///
  /// In en, this message translates to:
  /// **'Browse…'**
  String get settingsGameExeBrowse;

  /// No description provided for @settingsGameExeSaved.
  ///
  /// In en, this message translates to:
  /// **'Path saved'**
  String get settingsGameExeSaved;

  /// No description provided for @snackLaunchError.
  ///
  /// In en, this message translates to:
  /// **'Couldn’t open the game'**
  String get snackLaunchError;

  /// No description provided for @makeHostAction.
  ///
  /// In en, this message translates to:
  /// **'MAKE HOST'**
  String get makeHostAction;

  /// No description provided for @makeHostExperimental.
  ///
  /// In en, this message translates to:
  /// **'EXPERIMENTAL'**
  String get makeHostExperimental;

  /// No description provided for @makeHostDialogTitle.
  ///
  /// In en, this message translates to:
  /// **'Change host'**
  String get makeHostDialogTitle;

  /// No description provided for @makeHostDialogIntro.
  ///
  /// In en, this message translates to:
  /// **'{playerName} will become the host of {farmName}.'**
  String makeHostDialogIntro(String playerName, String farmName);

  /// No description provided for @makeHostNewCopyNote.
  ///
  /// In en, this message translates to:
  /// **'A new save is created. You\'ll decide what to do with the original next.'**
  String get makeHostNewCopyNote;

  /// No description provided for @makeHostMoveCount.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, one{1 farm object will be moved to make room for the house. Nothing is deleted.} other{{count} farm objects will be moved to make room for the house. Nothing is deleted.}}'**
  String makeHostMoveCount(int count);

  /// No description provided for @makeHostHouseWarning.
  ///
  /// In en, this message translates to:
  /// **'The new host\'s home will look like the game\'s main farmhouse. Cabin looks aren\'t supported without mods.'**
  String get makeHostHouseWarning;

  /// No description provided for @makeHostConfirmButton.
  ///
  /// In en, this message translates to:
  /// **'Make host'**
  String get makeHostConfirmButton;

  /// No description provided for @makeHostSuccess.
  ///
  /// In en, this message translates to:
  /// **'New save created: {playerName} is now the host.'**
  String makeHostSuccess(String playerName);

  /// No description provided for @hostSwapErrInvalid.
  ///
  /// In en, this message translates to:
  /// **'This save has an unexpected structure. Nothing was changed.'**
  String get hostSwapErrInvalid;

  /// No description provided for @hostSwapErrNoSpace.
  ///
  /// In en, this message translates to:
  /// **'No free space on the farm to relocate objects. Nothing was changed.'**
  String get hostSwapErrNoSpace;

  /// No description provided for @hostSwapErrWrite.
  ///
  /// In en, this message translates to:
  /// **'Could not write the new save (disk/permissions). Nothing was changed.'**
  String get hostSwapErrWrite;

  /// No description provided for @hostSwapErrValidation.
  ///
  /// In en, this message translates to:
  /// **'Verification of the new save failed, so it was discarded. The original is intact.'**
  String get hostSwapErrValidation;
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
    'eu',
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
    case 'eu':
      return AppLocalizationsEu();
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
