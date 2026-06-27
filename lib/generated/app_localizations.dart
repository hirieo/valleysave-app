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
