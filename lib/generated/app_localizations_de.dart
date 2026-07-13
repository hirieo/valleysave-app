// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for German (`de`).
class AppLocalizationsDe extends AppLocalizations {
  AppLocalizationsDe([String locale = 'de']) : super(locale);

  @override
  String get appTitle => 'ValleySave';

  @override
  String get welcomeTitle =>
      'Verlieren Sie Ihren Bauernhof niemals, nehmen Sie ihn überall hin.';

  @override
  String get connectGoogleDrive => 'Mit Google Drive verbinden';

  @override
  String get connecting => 'Verbindung wird hergestellt…';

  @override
  String get mySaves => 'Meine Speicherstände';

  @override
  String get howItWorks => 'So funktioniert es';

  @override
  String get settings => 'Einstellungen';

  @override
  String get aboutSection => 'Über';

  @override
  String get openSource => 'Code verfügbar';

  @override
  String get nonCommercial => 'Nicht kommerziell';

  @override
  String get freeForever => 'Immer kostenlos';

  @override
  String get privacyTitle => 'Datenschutz und Datennutzung';

  @override
  String get privacyDescription =>
      'ValleySave ist eine App zum Synchronisieren Ihrer Stardew Valley-Speicherstände mit Ihrem eigenen Google Drive-Konto.';

  @override
  String get whatDataTitle => 'Welche Daten werden verwendet';

  @override
  String get whatDataDesc =>
      'ValleySave greift nur auf die Stardew Valley-Speicherdateien zu, die zum Erstellen von Kopien, Synchronisieren oder Wiederherstellen erforderlich sind.';

  @override
  String get googleDriveTitle => 'Google Drive';

  @override
  String get googleDriveDesc =>
      'Ihre Speicherstände werden auf Ihr eigenes Google Drive-Konto hochgeladen. ValleySave verwendet keine eigenen Server zum Speichern Ihrer Spiele.';

  @override
  String get androidPermissionsTitle => 'Berechtigungen auf Android';

  @override
  String get androidPermissionsDesc =>
      'ValleySave benötigt möglicherweise Speicherberechtigungen oder Tools wie Shizuku, um auf Speicherdateien zuzugreifen.';

  @override
  String get adsTitle => 'Anzeigen';

  @override
  String get adsDesc => 'ValleySave kann Anzeigen über Google AdMob anzeigen.';

  @override
  String get responsibilityTitle => 'Verantwortung';

  @override
  String get responsibilityDesc =>
      'Ihre Speicherdateien sind Ihre Verantwortung.';

  @override
  String get deleteDataTitle => 'Daten löschen';

  @override
  String get deleteDataDesc =>
      'Sie können Ihre synchronisierten Kopien löschen, indem Sie den Ordner ValleySave manuell aus Google Drive löschen.';

  @override
  String get sourceCodeTitle => 'Quellcode und Kontakt';

  @override
  String get sourceCodeDesc =>
      'ValleySave ist ein Projekt mit verfügbarem Code unter der Polyform Noncommercial-Lizenz.';

  @override
  String get upToDate => 'Aktuell';

  @override
  String get checkingUpdates => 'Wird überprüft…';

  @override
  String get updateAvailable => 'Update verfügbar';

  @override
  String get application => 'Anwendung';

  @override
  String version(Object version) {
    return 'Version $version';
  }

  @override
  String get checkForUpdates => 'Nach Updates suchen';

  @override
  String get shizukuRequired => 'Shizuku erforderlich';

  @override
  String get shizukuGuide => 'Shizuku-Einrichtungsleitfaden';

  @override
  String get activateShizuku =>
      'Aktivieren Sie Shizuku, um den Speicherstand im Spiel zu schreiben.';

  @override
  String deleteSaveTitle(Object saveName) {
    return '$saveName löschen';
  }

  @override
  String get deleteSaveMessage =>
      'Dies löscht den Speicherstand von diesem Gerät. Möchten Sie fortfahren?';

  @override
  String get deleteFromDrive => 'Aus Drive löschen';

  @override
  String confirmDelete(Object saveName) {
    return '$saveName wird in den Google Drive-Papierkorb verschoben.';
  }

  @override
  String deleteFromDeviceMessage(Object saveName) {
    return '$saveName wird dauerhaft von diesem Gerät gelöscht.';
  }

  @override
  String restoreSaveTitle(Object saveName) {
    return '$saveName wiederherstellen';
  }

  @override
  String restoreSaveMessage(Object saveName) {
    return '$saveName auf dieses Gerät herunterladen?';
  }

  @override
  String get restore => 'Wiederherstellen';

  @override
  String get cancel => 'Abbrechen';

  @override
  String get error => 'Fehler';

  @override
  String get success => 'Erfolg';

  @override
  String get loading => 'Wird geladen…';

  @override
  String get disconnect => 'Trennen';

  @override
  String get ok => 'OK';

  @override
  String get yes => 'Ja';

  @override
  String get no => 'Nein';

  @override
  String get welcomeHeroPre => 'Verlieren Sie\nIhren ';

  @override
  String get welcomeHeroAccent => 'Bauernhof';

  @override
  String get welcomeHeroPost => '\nnicht — nehmen Sie ihn mit.';

  @override
  String get welcomeSubtitle =>
      'Synchronisieren Sie Ihre Stardew Valley-Speicherstände auf all Ihren Geräten. Ihre Daten liegen in Ihrem eigenen Google Drive — keine Server, keine Abonnements, unter Ihrer Kontrolle.';

  @override
  String get welcomeDriveConnected => 'Drive verbunden';

  @override
  String get welcomeFooterTagline => '· Nicht kommerziell · Immer kostenlos ·';

  @override
  String updateVersionAvailable(String version) {
    return 'v$version verfügbar';
  }

  @override
  String get sectionMode => 'Modus';

  @override
  String get sectionSeason => 'Jahreszeit';

  @override
  String get sectionLanguage => 'Sprache';

  @override
  String get modeAutoTitle => 'Automatisch';

  @override
  String get modeAutoDesc =>
      'Folgt Ihrem aktiven Speicherstand und, falls keine vorhanden, Ihrem realen Standort.';

  @override
  String get modeSavesTitle => 'Nach Speicherstand';

  @override
  String get modeSavesDesc =>
      'Verwendet immer die Jahreszeit Ihres letzten Speicherstands.';

  @override
  String get modeGeoTitle => 'Nach Standort';

  @override
  String get modeGeoDesc =>
      'Verwendet immer die reale Jahreszeit Ihres Standorts.';

  @override
  String get modeFixedTitle => 'Feste Jahreszeit';

  @override
  String get modeFixedDesc => 'Zeigt immer dieselbe Jahreszeit.';

  @override
  String get modeRandomTitle => 'Zufällig';

  @override
  String get modeRandomDesc =>
      'Wählt bei jedem App-Start eine andere Jahreszeit.';

  @override
  String get seasonInitial => 'Anfang';

  @override
  String get seasonSpring => 'Frühling';

  @override
  String get seasonSummer => 'Sommer';

  @override
  String get seasonFall => 'Herbst';

  @override
  String get seasonWinter => 'Winter';

  @override
  String get autoPriorityTitle => 'Prioritätsreihenfolge';

  @override
  String get autoStep1Title => 'Erster Start';

  @override
  String get autoStep1Desc => 'Zeigt den Ausgangszustand.';

  @override
  String get autoStep2Title => 'Aktiver Speicherstand';

  @override
  String get autoStep2Desc =>
      'Verwendet die Jahreszeit Ihres letzten synchronisierten Speicherstands.';

  @override
  String get autoStep3Title => 'Standort';

  @override
  String get autoStep3Desc =>
      'Erkennt Ihre Hemisphäre und die reale Jahreszeit Ihrer Region.';

  @override
  String get autoStep4Title => 'Standard';

  @override
  String get autoStep4Desc =>
      'Anfang (Nachtmodus), wenn keine Daten verfügbar sind.';

  @override
  String get versionInstalled => 'Installierte Version';

  @override
  String get updateNeverChecked => 'Noch nie geprüft';

  @override
  String get updateCheckedNow => 'Gerade geprüft';

  @override
  String get updateOutdatedDownload => 'Nicht aktuell · Herunterladen';

  @override
  String get updateDownloading => 'Update wird heruntergeladen…';

  @override
  String get updateError => 'Fehler — tippen zum Wiederholen';

  @override
  String get disconnectTitle => 'Drive trennen?';

  @override
  String get disconnectBody =>
      'Ihre Speicherstände auf Drive werden nicht gelöscht. Sie können sich jederzeit erneut verbinden.';

  @override
  String get disconnectButton => 'Drive trennen';

  @override
  String get languageTileLabel => 'Sprache';

  @override
  String get languageDialogTitle => 'App-Sprache';

  @override
  String get searchHint => 'Suchen…';

  @override
  String get languageAuto => 'Systemsprache';

  @override
  String get languageAutoDesc => 'Verwendet Ihre Systemsprache';

  @override
  String get privacyPolicyTitle => 'Datenschutzrichtlinie';

  @override
  String get privacyBeforeStartTitle => 'Bevor Sie beginnen';

  @override
  String get privacyLastUpdated => 'Zuletzt aktualisiert: Juni 2026';

  @override
  String get privacyAccept => 'Verstanden, weiter';

  @override
  String get cardSynced => 'Synchronisiert';

  @override
  String get cardLocalAhead => 'Lokal voraus';

  @override
  String get cardDriveAhead => 'Drive voraus';

  @override
  String get cardLocalOnly => 'Nur lokal';

  @override
  String get cardDriveOnly => 'Nur auf Drive';

  @override
  String get cardTimeNow => 'gerade eben';

  @override
  String cardTimeMinutesAgo(int minutes) {
    return 'vor $minutes Min.';
  }

  @override
  String cardTimeHoursAgo(int hours) {
    return 'vor $hours Std.';
  }

  @override
  String cardTimeDaysAgo(int days) {
    return 'vor $days T.';
  }

  @override
  String cardTimeMonthsAgo(int months) {
    return 'vor $months Mon.';
  }

  @override
  String get cardDetailLocalTitle => 'Auf diesem Gerät';

  @override
  String get cardDetailRemoteTitle => 'Auf Drive';

  @override
  String get cardDetailUpload => 'Auf Drive hochladen';

  @override
  String get cardDetailDownload => 'Speicherstand herunterladen';

  @override
  String get cardDetailDeleteLabel => 'Löschen';

  @override
  String get cardDetailDeleteLocal => 'Von diesem Gerät löschen';

  @override
  String get cardDetailDeleteRemote => 'Von Drive löschen';

  @override
  String get cardCloseBarrier => 'Schließen';

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
    return 'Remove from your list? This only affects your device — the save stays in $email\'s Drive.';
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
  String deleteUnifiedTitle(String farmName) {
    return 'Delete $farmName?';
  }

  @override
  String get deleteChooseLocationBody =>
      'Choose where. Your device copy is deleted forever; the Drive copy goes to Trash (30 days).';

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
    return 'Tag $day · Jahr $year';
  }

  @override
  String statDayOnly(int day) {
    return 'Tag $day';
  }

  @override
  String get statPlaytime => 'Spielzeit';

  @override
  String get statMoney => 'Münzen';

  @override
  String get statTotal => 'Gesamt';

  @override
  String get statMineUnexplored => 'Unerforscht';

  @override
  String get statMine => 'Mine';

  @override
  String get statMineLvl => 'Mine · Lv';

  @override
  String get skillFarming => 'Landwirtschaft';

  @override
  String get skillForaging => 'Sammeln';

  @override
  String get skillMining => 'Bergbau';

  @override
  String get skillFishing => 'Angeln';

  @override
  String get skillCombat => 'Kampf';

  @override
  String get cardLocalPresence => 'Auf diesem Gerät';

  @override
  String get cardRemotePresence => 'Auf Drive';

  @override
  String get cardNotPresent => 'Nicht vorhanden';

  @override
  String get cardActionSynced => 'Synchronisiert';

  @override
  String get cardActionUpload => 'Hochladen';

  @override
  String get cardActionDownload => 'Herunterladen';

  @override
  String get pillMonsters => 'Monster';

  @override
  String get pillFriends => 'Freunde';

  @override
  String get pillFaints => 'Ohnmachten';

  @override
  String get pillSleeps => 'Schläfe';

  @override
  String get hiwTitle => 'So funktioniert es';

  @override
  String get hiwSyncTitle => 'Wie die Synchronisierung funktioniert';

  @override
  String get hiwSyncIntro =>
      'ValleySave verwendet Ihr eigenes Google Drive, um Speicherstände zwischen Geräten zu übertragen. Keine Zwischenserver: die Dateien gehören Ihnen.';

  @override
  String get hiwSyncDevice => 'Ihr\nGerät';

  @override
  String get hiwSyncCloud => 'Google\nDrive';

  @override
  String get hiwSyncOtherDevice => 'Anderes\nGerät';

  @override
  String get hiwUploadTitle => 'Speicherstand hochladen';

  @override
  String get hiwUploadDesc =>
      'Beim Hochladen kopiert ValleySave beide Speicherdateien (SaveGameInfo + Farm-Datei) in Ihren ValleySave/-Ordner auf Drive.';

  @override
  String get hiwDownloadTitle => 'Speicherstand herunterladen';

  @override
  String get hiwDownloadDesc =>
      'Beim Herunterladen holt ValleySave die Dateien von Drive und legt sie direkt im Spielordner ab.';

  @override
  String get hiwCompareTitle => 'Was wird verglichen?';

  @override
  String get hiwCompareIntro =>
      'Um zu wissen, welche Version aktueller ist, verwendet ValleySave die Gesamtspielzeit — die einzigen Daten, die nur wachsen können.';

  @override
  String get hiwCompareNote =>
      'Vor der Bestätigung sehen Sie außerdem, damit Sie entscheiden können:';

  @override
  String get hiwCompareMoney => 'Aktuelles Geld und Gesamteinnahmen';

  @override
  String get hiwCompareMine => 'Minenebene';

  @override
  String get hiwCompareSkills =>
      'Fähigkeiten (Landwirtschaft, Bergbau, Kampf…)';

  @override
  String get hiwCompareRelations => 'Freunde, besiegte Monster, Ohnmachten';

  @override
  String get hiwCompareStamina => 'Ausdauer und Gesundheit';

  @override
  String get hiwCompareNotShown =>
      'Diese werden nicht angezeigt — sie ändern sich in jede Richtung und zeigen nicht an, welcher Speicherstand aktueller ist.';

  @override
  String get hiwCompareNotShownExamples =>
      'Ernte- und Tierstatus, Inventar und Gegenstände, individuelle Beziehungen';

  @override
  String get hiwCompareWarning =>
      'Sie werden nicht angezeigt — sie ändern sich in jede Richtung und zeigen nicht an, welcher Speicherstand aktueller ist.';

  @override
  String get hiwConflictTitle => 'Wenn Sie ohne Synchronisierung spielen';

  @override
  String get hiwConflictDesc =>
      'Wenn Sie auf Mobilgerät und PC spielen, ohne zwischen den Sitzungen zu synchronisieren, entstehen zwei Versionen desselben Speicherstands.';

  @override
  String get hiwConflictNoMerge =>
      'Sie können nicht zusammengeführt werden. ValleySave zeigt Ihnen immer beide Versionen, damit Sie wählen können, welche Sie behalten möchten.';

  @override
  String get hiwConflictMobile => 'Mobil';

  @override
  String get hiwConflictVersionA => 'Version A';

  @override
  String get hiwConflictPC => 'PC';

  @override
  String get hiwConflictVersionB => 'Version B';

  @override
  String get hiwDeleteTitle => 'Wenn ein Speicherstand gelöscht wird';

  @override
  String get hiwDeleteDesc =>
      'Wenn Sie einen Speicherstand von Drive löschen, verschwindet er nicht sofort: er wird in den Google Drive-Papierkorb verschoben.';

  @override
  String get hiwCompatTitle => 'Plattformkompatibilität';

  @override
  String get hiwCompatAndroidAccess => 'ZUGRIFF AUF ANDROID';

  @override
  String get hiwShizukuTitle => 'Mit Shizuku';

  @override
  String get hiwShizukuSubtitle =>
      'Einmal einrichten. Danach synchronisiert ValleySave von selbst, ohne dass Sie es jemals wieder anfassen müssen.';

  @override
  String get hiwShizukuBadge => 'AUTOMATISCH · EMPFOHLEN';

  @override
  String get hiwShizukuDone =>
      '✓  Erledigt. Ab dann funktioniert das Herunterladen und Hochladen von Speicherständen direkt, wie auf einem Computer.';

  @override
  String get hiwShizukuNote =>
      'Die Kopplung erfolgt nur beim ersten Mal. Neue Shizuku-Versionen reaktivieren sich nach einem Neustart des Telefons von selbst.';

  @override
  String get hiwBridgeTitle => 'Manuelle Brücke';

  @override
  String get hiwBridgeSubtitle =>
      'Funktioniert nur auf Android 11 und 12. Sie installieren nichts Zusätzliches; stattdessen kopieren Sie den Speicherstand jedes Mal manuell mit Ihrer Datei-App.';

  @override
  String get hiwBridgeBadge => 'MANUELLE ALTERNATIVE · ANDROID 11-12';

  @override
  String get hiwBridgeSaveFolder => 'Stardew-Ordner';

  @override
  String get hiwBridgeValleySaveFolder => 'ValleySave-Ordner';

  @override
  String get hiwBridgeNote =>
      'Es funktioniert, weil Ihre System-Datei-App auf diese Ordner zugreifen kann (ValleySave kann es nicht).';

  @override
  String get hiwTipAlwaysShow =>
      'Sie sehen immer, was auf Drive liegt, bevor Sie es überschreiben, damit Sie vergleichen können.';

  @override
  String get hiwTipWithoutUpload =>
      'Ohne Hochladen wird kein anderes Gerät Ihren aktuellen Fortschritt sehen.';

  @override
  String get hiwTipComparison =>
      'Sie sehen den Vergleich zwischen lokal und Drive, bevor Sie bestätigen.';

  @override
  String get hiwTipDownloadOverwrite =>
      'Das Herunterladen überschreibt Ihren lokalen Speicherstand. Nicht synchronisierter Fortschritt geht verloren.';

  @override
  String get hiwTipSync =>
      'Laden Sie immer hoch, bevor Sie das Gerät wechseln, und laden Sie herunter, wenn Sie ankommen.';

  @override
  String get hiwTipDeletion =>
      'Sie haben 30 Tage, um ihn aus dem Drive-Papierkorb wiederherzustellen, bevor er dauerhaft gelöscht wird.';

  @override
  String get hiwPrivacyLink => 'Datenschutzrichtlinie und Nutzung';

  @override
  String get emptyNoSaves => 'Keine Speicherstände gefunden';

  @override
  String get emptyNoSavesHint =>
      'Auf diesem Gerät können keine lokalen Speicherstände gelesen werden';

  @override
  String get bridgeTitle => 'Speicherstände übertragen';

  @override
  String get bridgeDesc =>
      'Um Ihre lokalen Speicherstände zu sehen und hochzuladen, kopieren Sie sie mit Ihrer Datei-App aus dem Stardew-Ordner in diesen ValleySave-Ordner. Dann wischen Sie zum Aktualisieren.';

  @override
  String get bridgeRefresh => 'Aktualisieren';

  @override
  String get bridgeChangeMode => 'Methode ändern';

  @override
  String get loaderLoading => 'WIRD GELADEN';

  @override
  String get loaderConnecting => 'Verbindung mit Drive wird hergestellt…';

  @override
  String get chooserTitle => 'Verbindungsmethode wählen';

  @override
  String get chooserAutomatic => 'Automatisch · Empfohlen';

  @override
  String get chooserManual => 'Manuelle Alternative · Android 11-12';

  @override
  String get shizukuStepTitle => 'Shizuku einrichten';

  @override
  String get shizukuStep1Title => 'Shizuku installieren';

  @override
  String get shizukuStep1Desc => 'Aus dem Play Store oder GitHub herunterladen';

  @override
  String get shizukuStep2Title => 'Shizuku aktivieren';

  @override
  String get shizukuStep2Desc => 'App starten und Berechtigungen erteilen';

  @override
  String get shizukuStep3Title => 'Berechtigung erteilen';

  @override
  String get shizukuStep3Desc => 'ValleySave wird um Zugriff bitten';

  @override
  String get shizukuDone =>
      '✓  Erledigt. Ab dann funktioniert das Herunterladen und Hochladen von Speicherständen direkt, wie auf einem Computer.';

  @override
  String get dlgDeleteDriveTitle => 'Von Drive löschen';

  @override
  String get dlgDeleteLocalTitle => 'Von diesem Gerät löschen';

  @override
  String get dlgDownloadTitle => 'Speicherstand herunterladen';

  @override
  String get dlgUploadTitle => 'Speicherstand hochladen';

  @override
  String get dlgUploadOverwrite =>
      'Dies überschreibt Ihren lokalen Speicherstand';

  @override
  String get dlgGotIt => 'Verstanden';

  @override
  String get dlgCopyDest => 'Zielort kopieren';

  @override
  String get previewColDayYear => 'Tag/Jahr';

  @override
  String get previewColTime => 'Spielzeit';

  @override
  String get previewColMoney => 'Münzen';

  @override
  String get previewColTotal => 'Gesamt';

  @override
  String get previewColFarming => 'Landwirtschaft';

  @override
  String get previewColForaging => 'Sammeln';

  @override
  String get previewColMining => 'Bergbau';

  @override
  String get previewColFishing => 'Angeln';

  @override
  String get previewColCombat => 'Kampf';

  @override
  String get previewColFriends => 'Freunde';

  @override
  String get previewColMonsters => 'Monster';

  @override
  String get previewColFaints => 'Ohnmachten';

  @override
  String get previewColMine => 'Mine';

  @override
  String get previewColUnexplored => 'Unerforscht';

  @override
  String get previewLocalLabel => 'AUF DIESEM GERÄT';

  @override
  String get previewDriveLabel => 'AUF DRIVE';

  @override
  String get previewFromDrive => 'VON DRIVE';

  @override
  String get previewFromDevice => 'VON DIESEM GERÄT';

  @override
  String versionMismatch(String local, String drive) {
    return 'Unterschiedliche Versionen: lokal $local · Drive $drive…';
  }

  @override
  String get snackPathCopied => 'Pfad kopiert';

  @override
  String get snackDestCopied => 'Zielpfad kopiert';

  @override
  String get snackDownloaded => 'Speicherstand ins Spiel heruntergeladen';

  @override
  String get snackSessionExpired =>
      'Drive-Sitzung abgelaufen. Erneut verbinden';

  @override
  String snackUploadError(String error) {
    return 'Uploadfehler: $error';
  }

  @override
  String snackDownloadError(String error) {
    return 'Downloadfehler: $error';
  }

  @override
  String snackDeleteError(String error) {
    return 'Löschfehler: $error';
  }

  @override
  String snackTrashed(String saveName) {
    return '\"$saveName\" in den Drive-Papierkorb verschoben. Sie haben 30 Tage, um ihn wiederherzustellen.';
  }

  @override
  String snackDeletedLocal(String saveName) {
    return '\"$saveName\" von diesem Gerät gelöscht';
  }

  @override
  String get snackShizukuRequired => 'Shizuku aktivieren…';

  @override
  String get snackWriteError =>
      'Konnte nicht ins Spiel schreiben. Manche Telefone blockieren /Android/data selbst mit Shizuku.';

  @override
  String get snackPlatformNotSupported =>
      'Diese Plattform unterstützt das Schreiben lokaler Speicherstände noch nicht.';

  @override
  String get snackWirelessDebugHint =>
      'Manuell öffnen: Einstellungen → Entwickleroptionen → Drahtloses Debugging.';

  @override
  String get snackOpenShizukuApp => 'Shizuku aus Ihrem App-Drawer öffnen.';

  @override
  String get hiwTipDeletePermanent =>
      'ValleySave kann dauerhaft gelöschte Speicherstände nicht wiederherstellen. Drive-Dateien liegen in Ihrer Verantwortung.';

  @override
  String get hiwCompatAchievements =>
      'Steam- und Google Play-Erfolge werden nicht übertragen. Jede Plattform verfolgt nur Erfolge, die in Echtzeit erzielt werden — die Speicherdatei löst sie nicht rückwirkend aus.';

  @override
  String get hiwCompatOverwrite =>
      'Wenn Sie von zwei Geräten ohne feste Reihenfolge synchronisieren, kann ein Speicherstand den anderen überschreiben. Laden Sie immer hoch, bevor Sie herunterladen.';

  @override
  String get hiwCompatVersions =>
      'Speicherstände aus verschiedenen Spielversionen werden möglicherweise nicht korrekt geladen. ValleySave warnt Sie, wenn vor dem Herunterladen ein Versionsunterschied erkannt wird.';

  @override
  String get hiwCompatMods =>
      'SMAPI-Mods fügen dem Speicherstand zusätzliche Daten hinzu. Wenn Sie einen modifizierten Speicherstand auf einem Gerät laden, auf dem diese Mods nicht installiert sind, kann das Spiel abstürzen oder Mod-Daten verlieren.\n\nAuf Android kann SMAPI ebenfalls installiert werden, um Mods zu verwenden.';

  @override
  String get hiwComparePrimary => 'Gesamtspielzeit';

  @override
  String get hiwCompareNoShown1 => 'Ernte- und Tierstatus';

  @override
  String get hiwCompareNoShown2 => 'Inventar und Gegenstände';

  @override
  String get hiwCompareNoShown3 => 'Individuelle Beziehungen';

  @override
  String get hiwShizuku1 =>
      'Shizuku installieren (Play Store oder GitHub APK).';

  @override
  String get hiwShizuku2 =>
      'Mit Drahtlosem Debugging aktivieren — ValleySave führt Sie Schritt für Schritt.';

  @override
  String get hiwShizuku3 =>
      'ValleySave die Berechtigung erteilen, wenn Sie dazu aufgefordert werden.';

  @override
  String get hiwBridge1 =>
      'Von Drive herunterladen: ValleySave legt den Speicherstand in seinem Ordner ab. Sie kopieren ihn mit Dateien in den Stardew-Ordner.';

  @override
  String get hiwBridge2 =>
      'Auf Drive hochladen: Speicherstand von Stardew in den ValleySave-Ordner kopieren. ValleySave erkennt ihn und lädt ihn hoch.';

  @override
  String get snackShizukuBattery =>
      'Einstellungen → Apps → Shizuku → Akku → Nicht eingeschränkt.';

  @override
  String snackDriveError(String error) {
    return 'Drive: $error';
  }

  @override
  String get dlgDeleteLocalWarning =>
      '⚠️ Wenn Sie nicht auf Drive hochgeladen haben, geht der Speicherstand für immer verloren. Keine Wiederherstellung möglich.';

  @override
  String get dlgDelete => 'Löschen';

  @override
  String get dlgDownloadButton => 'Herunterladen';

  @override
  String get dlgUploadButton => 'Hochladen';

  @override
  String get dlgBridgeCopyTitle => 'Speicherstand ins Spiel kopieren';

  @override
  String dlgBridgeCopyDesc(String saveName) {
    return 'Speicherstand bereit. Kopieren Sie mit Ihrer Datei-App den Ordner \"$saveName\" und fügen Sie ihn in den Stardew-Ordner ein.';
  }

  @override
  String get labelFrom => 'Von';

  @override
  String get labelTo => 'Nach';

  @override
  String dlgDownloadNewDesc(String saveName, int day, String playtime) {
    return '\"$saveName\" (Tag $day, $playtime) wird auf dieses Gerät kopiert.';
  }

  @override
  String dlgDownloadOverwrite(String saveName) {
    return 'Dies ÜBERSCHREIBT Ihren lokalen Speicherstand von \"$saveName\".';
  }

  @override
  String dlgUploadNewDesc(String saveName, int day, String playtime) {
    return '\"$saveName\" (Tag $day, $playtime) wird auf Ihr Drive hochgeladen.';
  }

  @override
  String dlgUploadOverwriteDrive(String saveName) {
    return 'Dies ÜBERSCHREIBT die Drive-Version von \"$saveName\".';
  }

  @override
  String get pathLabelFromStardew => 'Von (Stardew)';

  @override
  String get pathLabelToValleySave => 'Nach (ValleySave)';

  @override
  String get chooserDesc =>
      'Android schützt den Spielordner. Wählen Sie, wie Sie ValleySave Zugriff gewähren — Sie können es jederzeit ändern.';

  @override
  String get chooserShizukuDesc =>
      'Einmal konfiguriert. Danach synchronisiert ValleySave von selbst, ohne dass Sie etwas anfassen müssen. Einzige zuverlässige Methode auf Android 13+.';

  @override
  String get chooserManualBadge => 'NUR ANDROID 11-12';

  @override
  String get chooserBridgeDesc =>
      'Speicherstände mit Ihrer Datei-App kopieren. Keine zusätzliche Installation. Nur auf Android 11 und 12.';

  @override
  String get chooserRootBadge => 'ROOT';

  @override
  String get chooserRootTitle => 'Root-Zugriff';

  @override
  String get chooserRootDesc =>
      'Für gerootete Geräte (Magisk / SuperSU). Root-Berechtigung einmal bestätigen — danach automatisch.';

  @override
  String get snackRootDenied =>
      'Root-Zugriff verweigert. Versuche stattdessen Shizuku.';

  @override
  String get shizukuGateSubtitle => 'Einmal konfiguriert · nur beim ersten Mal';

  @override
  String get shizukuStatusLabel => 'Shizuku aktiv';

  @override
  String get shizukuStatusRunning => 'Verbunden und wartend.';

  @override
  String get shizukuStatusNotDetected => 'Noch nicht erkannt.';

  @override
  String get shizukuPermLabel => 'Berechtigung erteilt';

  @override
  String get shizukuPermGranted => 'ValleySave hat bereits Zugriff.';

  @override
  String get shizukuPermNotGranted => 'ValleySave muss autorisiert werden.';

  @override
  String get shizukuGrant => 'Erteilen';

  @override
  String get shizukuGuideHeader => 'SCHRITT-FÜR-SCHRITT-ANLEITUNG';

  @override
  String get shizukuStep1DescFull =>
      'Kostenlos. Wenn Google Play es auf Ihrem Telefon blockiert, verwenden Sie die offizielle GitHub APK.';

  @override
  String get btnPlayStore => 'Play Store';

  @override
  String get btnApkGithub => 'APK GitHub';

  @override
  String get shizukuStep2TitleFull => 'Entwickleroptionen aktivieren';

  @override
  String get shizukuStep2DescFull =>
      'Einstellungen → Telefoninfo → Softwareinfo → 7-mal auf \"Build-Nummer\" tippen.';

  @override
  String get shizukuStep3TitleFull => 'Drahtloses Debugging aktivieren';

  @override
  String get shizukuStep3DescFull =>
      'Die Schaltfläche führt Sie dorthin und hebt es hervor. Aktivieren Sie es (EIN). Tippen Sie dann auf \"Gerät mit Kopplungscode koppeln\" — ein 6-stelliger Code erscheint auf dem Bildschirm.';

  @override
  String get btnOpenAndHighlight => 'Öffnen und hervorheben';

  @override
  String get shizukuStep4Title => 'Shizuku koppeln und STARTEN';

  @override
  String get shizukuStep4Desc =>
      'Shizuku öffnen → \"Via Drahtloses Debugging starten\" → \"Mit Kopplungscode koppeln\". Shizuku sendet eine Benachrichtigung, dass es wartet. Den 6-stelligen Code vom Bildschirm \"Drahtloses Debugging\" eingeben. Nach dem Koppeln STARTEN drücken — ohne diesen letzten Schritt ist Shizuku nicht aktiv.';

  @override
  String get btnOpenShizuku => 'Shizuku öffnen';

  @override
  String get shizukuStep5Title => 'Shizuku-Akku auf Nicht eingeschränkt setzen';

  @override
  String get shizukuStep5Desc =>
      'App-Info öffnen → Akku → Nicht eingeschränkt. Andernfalls schließt das System Shizuku im Hintergrund und Sie müssen erneut auf Start drücken.';

  @override
  String get btnShizukuAppInfo => 'Shizuku App-Info';

  @override
  String get shizukuStep6DescActive =>
      'Shizuku ist aktiv. Tippen Sie auf die Schaltfläche zum Autorisieren.';

  @override
  String get shizukuStep6DescWaiting =>
      'Verfügbar, sobald Shizuku aktiv ist (Schritt 4).';

  @override
  String get btnGrantPermission => 'Berechtigung erteilen';

  @override
  String get btnCheckShizuku => 'Fertig · Prüfen';

  @override
  String get statusDone => 'erledigt';

  @override
  String get statusPending => 'ausstehend';

  @override
  String get latestBadge => '· LETZTER SPEICHERSTAND ·';

  @override
  String saveDateLabel(String season, int year) {
    return '$season · Jahr $year';
  }

  @override
  String get petCat => 'Katze';

  @override
  String get petDog => 'Hund';

  @override
  String get houseBasic => 'Basishaus';

  @override
  String get houseKitchen => 'Mit Küche';

  @override
  String get houseBedroom => 'Mit Schlafzimmer';

  @override
  String get houseCellar => 'Mit Keller';

  @override
  String houseLevelN(int level) {
    return 'Lv. $level';
  }

  @override
  String get tooltipLaunchGame => 'Spielen';

  @override
  String get hiwLaunchTitle => 'Spiel starten';

  @override
  String get hiwLaunchDesc =>
      'Die ▶-Schaltfläche in der oberen Leiste von Meine Spielstände öffnet Stardew Valley direkt aus der App.';

  @override
  String get hiwLaunchTipWindows =>
      'Unter Windows, wenn das Spiel nicht automatisch gefunden wird, Pfad unter Einstellungen → Spiel festlegen.';

  @override
  String get hiwLaunchTipAndroid =>
      'Unter Android öffnet die App das Spiel, wenn es installiert ist.';

  @override
  String get settingsGameSection => 'Spiel';

  @override
  String get settingsGameExePath => 'Stardew Valley Exe';

  @override
  String get settingsGameExeNotFound => 'Nicht automatisch gefunden';

  @override
  String get settingsGameExeBrowse => 'Suchen…';

  @override
  String get settingsGameExeSaved => 'Pfad gespeichert';

  @override
  String get snackLaunchError => 'Spiel konnte nicht geöffnet werden';

  @override
  String get makeHostAction => 'ZUM GASTGEBER MACHEN';

  @override
  String get makeHostExperimental => 'EXPERIMENTELL';

  @override
  String get makeHostDialogTitle => 'Gastgeber wechseln';

  @override
  String makeHostDialogIntro(String playerName, String farmName) {
    return '$playerName wird der neue Gastgeber von $farmName.';
  }

  @override
  String get makeHostNewCopyNote =>
      'Ein neuer Spielstand wird erstellt. Danach entscheidest du, was mit dem Original passiert.';

  @override
  String makeHostMoveCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other:
          '$count Objekte auf dem Hof werden verschoben, um Platz für das Haus zu schaffen. Nichts wird gelöscht.',
      one:
          '1 Objekt auf dem Hof wird verschoben, um Platz für das Haus zu schaffen. Nichts wird gelöscht.',
    );
    return '$_temp0';
  }

  @override
  String get makeHostHouseWarning =>
      'Das Haus des neuen Gastgebers sieht aus wie das große Bauernhaus des Spiels. Die Optik der Hütte wird ohne Mods nicht unterstützt.';

  @override
  String get makeHostConfirmButton => 'Gastgeber machen';

  @override
  String makeHostSuccess(String playerName) {
    return 'Neuer Spielstand erstellt: $playerName ist jetzt der Gastgeber.';
  }

  @override
  String get hostSwapErrInvalid =>
      'Dieser Spielstand hat eine unerwartete Struktur. Es wurde nichts geändert.';

  @override
  String get hostSwapErrNoSpace =>
      'Kein freier Platz auf dem Hof, um Objekte zu verschieben. Es wurde nichts geändert.';

  @override
  String get hostSwapErrWrite =>
      'Der neue Spielstand konnte nicht geschrieben werden (Speicher/Berechtigungen). Es wurde nichts geändert.';

  @override
  String get hostSwapErrValidation =>
      'Die Überprüfung des neuen Spielstands ist fehlgeschlagen, er wurde verworfen. Das Original ist unversehrt.';
}
