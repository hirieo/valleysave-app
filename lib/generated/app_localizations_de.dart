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
  String get updateNeedsPermission =>
      'Aktiviere „Unbekannte Apps installieren“ für ValleySave und tippe erneut auf Aktualisieren';

  @override
  String get disconnectTitle => 'Drive trennen?';

  @override
  String disconnectBody(String email) {
    return 'Ihre Speicherstände auf Drive werden nicht gelöscht. Sie können sich jederzeit erneut verbinden.';
  }

  @override
  String get disconnectButton => 'Drive trennen';

  @override
  String disconnectButtonEmail(String email) {
    return 'Von $email trennen';
  }

  @override
  String get connectedAsPrefix => 'Verbunden als';

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
  String get exportAction => 'Exportieren';

  @override
  String get exportSuccess => 'Speicherstand exportiert.';

  @override
  String exportError(String error) {
    return 'Der Speicherstand konnte nicht exportiert werden: $error';
  }

  @override
  String get importAction => 'Speicherstand importieren';

  @override
  String importSuccess(String playerName) {
    return 'Speicherstand von $playerName importiert.';
  }

  @override
  String get importErrInvalidZip => 'Diese Datei ist keine gültige Zip-Datei.';

  @override
  String get importErrUnsafePath =>
      'Diese Datei hat eine unsichere Struktur und wurde abgelehnt.';

  @override
  String get importErrTooLarge =>
      'Diese Datei ist zu groß, um importiert zu werden.';

  @override
  String get importErrNotASave =>
      'Diese Datei enthält keinen erkennbaren Speicherstand.';

  @override
  String get importErrWrite =>
      'Der importierte Speicherstand konnte nicht geschrieben werden (Speicher/Berechtigungen).';

  @override
  String get importErrBackupFailed =>
      'Es konnte keine Sicherung erstellt werden. Es wurde nichts importiert.';

  @override
  String get importConflictTitle =>
      'Es gibt bereits einen Speicherstand mit diesem Namen';

  @override
  String get importConflictBody =>
      'Der Import ersetzt die vorhandene lokale Kopie. Kann nicht rückgängig gemacht werden.';

  @override
  String get importConflictConfirm => 'Überschreiben';

  @override
  String get shareAction => 'Teilen';

  @override
  String get shareUploadFirstCta => 'Zuerst hochladen';

  @override
  String get shareDialogTitle => 'Speicherstand teilen';

  @override
  String get shareEmailPlaceholder => 'name@beispiel.de';

  @override
  String get shareInfoNote =>
      'Teilen gewährt Zugriff zum Ansehen und Herunterladen. Nur Sie können Ihre Kopie auf Drive bearbeiten oder löschen.';

  @override
  String get shareRoleReader => 'Nur lesen';

  @override
  String get shareRoleWriter => 'Synchronisieren erlauben';

  @override
  String get shareInfoNoteCoop =>
      'Nur lesen erlaubt Ansehen und Herunterladen. Synchronisieren erlauben erlaubt das Überschreiben Ihrer Kopie auf Drive — löschen können sie sie nie.';

  @override
  String get shareConfirmButton => 'Teilen';

  @override
  String shareSuccess(String email) {
    return 'Mit $email geteilt.';
  }

  @override
  String get manageAccessTitle => 'Personen mit Zugriff';

  @override
  String get manageAccessEmpty => 'Noch niemand sonst hat Zugriff.';

  @override
  String get manageAccessRoleLabel => 'Zugriff';

  @override
  String get manageAccessRevoke => 'Widerrufen';

  @override
  String manageAccessRevokeConfirm(String email) {
    return 'Zugriff für $email entfernen? Jede bereits heruntergeladene lokale Kopie bleibt seine/ihre.';
  }

  @override
  String get driveOnlyControlsYourCopy =>
      'Teilen steuert Ihre Kopie auf Drive. Wenn jemand sie herunterlädt, gehört diese Kopie ihm.';

  @override
  String get driveOnlyControlsYourCopyCoop =>
      'Synchronisieren steuert Ihre Kopie auf Drive — sie kann von den von Ihnen autorisierten Personen überschrieben, aber nie gelöscht werden.';

  @override
  String get sharedWithMeTitle => 'Mit mir geteilt';

  @override
  String get sharedWithMeEmpty => 'Noch nichts mit Ihnen geteilt.';

  @override
  String get sharedWithMeAdd => 'Geteilten Speicherstand hinzufügen';

  @override
  String sharedWithMeOwnedBy(String email) {
    return 'Geteilt von $email';
  }

  @override
  String get sharedWithMeRoleSync => 'Synchronisiert';

  @override
  String get sharedWithMeRoleRead => 'Nur lesen';

  @override
  String get sharedWithMeSync => 'Synchronisieren';

  @override
  String get sharedWithMeDownload => 'Herunterladen';

  @override
  String get sharedWithMeRemove => 'Trennen';

  @override
  String sharedWithMeRemoveConfirm(String email) {
    return 'Sie synchronisieren nicht mehr mit dem Drive von $email, können sie aber jederzeit wieder hinzufügen — sie bleibt geteilt. Ihre lokale Kopie bleibt ein normaler Koop-Speicherstand.';
  }

  @override
  String sharedLeaveConfirm(Object email) {
    return 'Sie verlieren wirklich den Zugriff auf diesen Speicherstand. Sie können ihn nicht erneut hinzufügen, es sei denn, $email teilt ihn wieder mit Ihnen. Ihre lokale Kopie bleibt ein normaler Koop-Speicherstand.';
  }

  @override
  String get sharedManageButton => 'Verwalten';

  @override
  String get sharedManageDialogTitle => 'Freigaben verwalten';

  @override
  String get sharedManageDialogHint =>
      'Hier können Sie einen geteilten Speicherstand wirklich verlassen.';

  @override
  String get sharedLeaveButton => 'Freigabe verlassen';

  @override
  String sharedLeaveSuccess(Object email) {
    return 'Sie haben die Freigabe von $email verlassen.';
  }

  @override
  String sharedWithMeSyncConfirm(String email) {
    return 'Die Kopie von $email auf Drive mit Ihrem lokalen Speicherstand überschreiben?';
  }

  @override
  String sharedAccessReadOnly(String email) {
    return '$email hat Sie auf Nur-lesen gesetzt — Sie können ansehen und herunterladen, aber nicht mit seinem/ihrem Drive synchronisieren.';
  }

  @override
  String get sharedWithMeRevoked => 'Sie haben keinen Zugriff mehr';

  @override
  String sharedRevokedDialogBody(String email, String farmName) {
    return '$email teilt $farmName nicht mehr mit Ihnen. Ihre lokale Kopie und die auf Ihrem Drive bleiben unverändert, jetzt unter Meine Speicherstände.';
  }

  @override
  String get sharedRevokedAccept => 'Akzeptieren';

  @override
  String get sharedSelfCleanupTitle => 'Eintrag korrigiert';

  @override
  String sharedSelfCleanupBody(String farmName) {
    return '$farmName wurde fälschlicherweise als mit Ihnen geteilt angezeigt — tatsächlich gehört er Ihnen. Dies wurde korrigiert, er befindet sich jetzt unter Meine Speicherstände.';
  }

  @override
  String get sharedWithMeUploadOwn => 'Auf mein Drive hochladen';

  @override
  String get sharedDownloadOwn => 'Von meinem Drive herunterladen';

  @override
  String get sharedStatusOwnDriveAhead =>
      'Ihr Drive ist voraus — laden Sie ihn herunter';

  @override
  String get sharedSyncBoth => 'Auf beide Drives hochladen';

  @override
  String get sharedSideMyDrive => 'MEIN DRIVE';

  @override
  String sharedSideOwnerDrive(String email) {
    return 'DRIVE VON $email';
  }

  @override
  String sharedSideDate(int day, int year) {
    return 'Tag $day · Jahr $year';
  }

  @override
  String get sharedStatusSyncedNoOwnDrive =>
      'Mit dem Eigentümer synchronisiert · keine Kopie auf Ihrem Drive';

  @override
  String get sharedStatusAheadNoOwnDrive =>
      'Sie sind voraus · keine Kopie auf Ihrem Drive';

  @override
  String sharedStatusOwnerAheadNoOwnDrive(String email) {
    return '$email ist voraus · keine Kopie auf Ihrem Drive';
  }

  @override
  String get sharedStatusAllSynced => 'Synchronisiert (lokal + beide Drives)';

  @override
  String get sharedStatusAheadBoth => 'Sie sind bei beiden Drives voraus';

  @override
  String get sharedStatusMixed => 'Nicht synchron — jedes Drive überprüfen';

  @override
  String get sharedStatusFullySynced => 'Vollständig synchronisiert';

  @override
  String get sharedStatusSyncedOwn => 'Mein Drive synchronisiert';

  @override
  String get sharedStatusSyncedOwner => 'Geteiltes Drive synchronisiert';

  @override
  String get sharedStatusNotCloud => 'Nur auf diesem Gerät';

  @override
  String sharedStatusOwnerAhead(Object email) {
    return 'Drive von $email ist voraus';
  }

  @override
  String get sharedStatusBothAhead => 'Beide Drives sind voraus';

  @override
  String get sharedStatusLocalMissing => 'Nicht auf diesem Gerät';

  @override
  String sharedStatusOwnerUnavailable(Object email) {
    return 'Drive von $email konnte nicht überprüft werden';
  }

  @override
  String get sharedStatusWorking => 'Synchronisiert wird…';

  @override
  String get sharedSideUnavailable => 'Konnte nicht überprüft werden';

  @override
  String get sharedSyncChooseTitle => 'Wo möchten Sie synchronisieren?';

  @override
  String get sharedSyncChooseBody =>
      'Wählen Sie, welche Cloud-Kopien Sie mit dem Speicherstand dieses Geräts aktualisieren möchten.';

  @override
  String get sharedSyncTargetOwn => 'Mein Drive';

  @override
  String sharedSyncTargetOwner(Object email) {
    return 'Drive von $email';
  }

  @override
  String get sharedSyncTargetBoth => 'Beide Drives';

  @override
  String get sharedDownloadChooseTitle =>
      'Welche Kopie möchten Sie herunterladen?';

  @override
  String get sharedDownloadChooseBody =>
      'Es gibt mehr als eine Kopie, die voraus ist. Wählen Sie, welche Sie auf dieses Gerät holen möchten.';

  @override
  String get sharedDownloadSourceOwn => 'Von meinem Drive';

  @override
  String sharedDownloadSourceOwner(Object email) {
    return 'Von Drive bei $email';
  }

  @override
  String get sharedWithMePickerTitle => 'Geteilten Speicherstand hinzufügen';

  @override
  String get sharedPickerEmptyHint =>
      'Hier erscheint, was ein anderer Spieler mit Ihnen über Drive teilt.';

  @override
  String get sharedPickerAddButton => 'Hinzufügen';

  @override
  String get sharedOriginBadge => 'Geteilt';

  @override
  String sharedOriginFrom(String email) {
    return 'von $email';
  }

  @override
  String get swapBackupDialogTitle => 'Sicherung erstellt';

  @override
  String get swapBackupDialogBody =>
      'Die vorherige Version wurde als Zip gespeichert. Was möchten Sie damit tun?';

  @override
  String get swapBackupUpload => 'Auf Drive hochladen';

  @override
  String get swapBackupLocalOnly => 'Auf diesem Gerät behalten';

  @override
  String get swapBackupDeleteNow => 'Jetzt löschen';

  @override
  String get swapBackupUploadOk => 'Sicherung auf Drive hochgeladen.';

  @override
  String swapBackupUploadErr(String error) {
    return 'Die Sicherung konnte nicht hochgeladen werden: $error';
  }

  @override
  String get swapBackupLocalOnlySnack =>
      'Sicherung auf diesem Gerät gespeichert.';

  @override
  String get backupsAction => 'Sicherungen';

  @override
  String backupsScreenTitle(String farmName) {
    return 'Sicherungen von $farmName';
  }

  @override
  String get backupsEmpty => 'Noch keine Sicherungen.';

  @override
  String get backupsRestore => 'Wiederherstellen';

  @override
  String get backupsRestoreConfirmTitle => 'Diese Sicherung wiederherstellen?';

  @override
  String get backupsRestoreConfirmBody =>
      'Dies überschreibt Ihren aktuellen Speicherstand mit dieser früheren Version. Kann nicht rückgängig gemacht werden.';

  @override
  String get backupsDelete => 'Löschen';

  @override
  String get backupsDeleteConfirmTitle => 'Diese Sicherung löschen?';

  @override
  String get backupsDeleteConfirmBody =>
      'Wird an allen Orten gelöscht, an denen sie existiert (dieses Gerät und Drive, falls hochgeladen). Kann nicht rückgängig gemacht werden.';

  @override
  String get backupsRestoreOk => 'Sicherung wiederhergestellt.';

  @override
  String get backupsRestoreManualTitle => 'Manuell wiederherstellen';

  @override
  String get backupsRestoreManualBody =>
      'Im Brücken-Modus kann ValleySave nicht automatisch in den Spielordner schreiben. Entpacken Sie die .zip-Datei dieser Sicherung selbst in den Saves-Ordner von Stardew Valley, oder wechseln Sie in den Einstellungen zum Root-/Shizuku-Modus, um automatisch wiederherzustellen.';

  @override
  String backupsRestoreErr(String error) {
    return 'Die Sicherung konnte nicht wiederhergestellt werden: $error';
  }

  @override
  String backupsDeleteErr(String error) {
    return 'Die Sicherung konnte nicht gelöscht werden: $error';
  }

  @override
  String get backupsCreate => 'Lokale Sicherung erstellen';

  @override
  String get backupsCreateLocalHint =>
      'Sicherungen werden zunächst auf diesem Gerät erstellt. Danach können Sie sie auf Drive hochladen.';

  @override
  String get backupsCreateOk => 'Sicherung erstellt.';

  @override
  String backupsCreateErr(String error) {
    return 'Die Sicherung konnte nicht erstellt werden: $error';
  }

  @override
  String get backupsDownload => 'Herunterladen';

  @override
  String get backupsDownloadOk => 'Sicherung auf dieses Gerät heruntergeladen.';

  @override
  String backupsDownloadErr(String error) {
    return 'Die Sicherung konnte nicht heruntergeladen werden: $error';
  }

  @override
  String get backupsCopyOwn => 'Auf mein Drive kopieren';

  @override
  String get backupsUploadOwn => 'Auf mein Drive';

  @override
  String get backupsUploadShared => 'Auf das geteilte Drive';

  @override
  String get backupsUploadOk => 'Sicherung hochgeladen.';

  @override
  String backupsUploadErr(String error) {
    return 'Die Sicherung konnte nicht hochgeladen werden: $error';
  }

  @override
  String get backupsLocationLocal => 'Dieses Gerät';

  @override
  String get backupsLocationOwnDrive => 'Mein Drive';

  @override
  String get backupsLocationSharedDrive => 'Geteiltes Drive';

  @override
  String get backupsDeleteChooseBody =>
      'Wählen Sie genau, wo sie gelöscht werden soll. Es werden nur die Orte angezeigt, an denen diese Sicherung existiert.';

  @override
  String get backupsDeleteLocalOnly => 'Nur von diesem Gerät';

  @override
  String get backupsDeleteOwnOnly => 'Nur von meinem Drive';

  @override
  String get backupsDeleteSharedOnly => 'Nur vom geteilten Drive';

  @override
  String get backupsDeleteAll => 'Von allen Kopien';

  @override
  String deleteUnifiedTitle(String farmName) {
    return '$farmName löschen?';
  }

  @override
  String get deleteChooseLocationBody =>
      'Wählen Sie, von wo. Die Kopie auf diesem Gerät wird für immer gelöscht; die auf Drive wandert in den Papierkorb (30 Tage).';

  @override
  String deleteDriveContextTitle(String farmName) {
    return '$farmName von Drive löschen?';
  }

  @override
  String get deleteDriveContextBody =>
      'Die Kopie auf Drive wandert in den Papierkorb, wo Sie sie 30 Tage lang wiederherstellen können.';

  @override
  String get deleteDriveLocalKept =>
      'Die Kopie auf diesem Gerät bleibt unverändert.';

  @override
  String deleteLocalContextTitle(String farmName) {
    return '$farmName von diesem Gerät löschen?';
  }

  @override
  String get deleteLocalContextBody =>
      'Die Kopie auf diesem Gerät wird für immer gelöscht.';

  @override
  String deleteLocalDriveCurrent(String date) {
    return 'Ihre Kopie auf Drive ist aktuell ($date) und bleibt verfügbar.';
  }

  @override
  String deleteLocalDriveAhead(String date) {
    return 'Ihre Kopie auf Drive ist neuer ($date) und bleibt verfügbar.';
  }

  @override
  String deleteLocalDriveOlder(String driveDate, String localDate) {
    return 'Ihre Kopie auf Drive ist älter ($driveDate); dieses Gerät befindet sich bei $localDate.';
  }

  @override
  String deleteLocalBackupAvailable(int count) {
    return 'Es sind $count lokale Sicherungen verfügbar, falls Sie eine frühere Kopie benötigen.';
  }

  @override
  String get deleteLocalNoRecovery =>
      'Es gibt weder eine Kopie auf Drive noch eine lokale Sicherung, aus der dieser Speicherstand wiederhergestellt werden könnte.';

  @override
  String get deleteOptionLocalOnly => 'Nur von diesem Gerät';

  @override
  String get deleteOptionDriveOnly => 'Nur von meinem Drive';

  @override
  String get deleteOptionBoth => 'Von beiden Kopien';

  @override
  String get viewPlayersHint => 'Spieler ansehen';

  @override
  String snackDeletedBoth(String saveName) {
    return '\"$saveName\" von diesem Gerät gelöscht und in den Drive-Papierkorb verschoben.';
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
  String get hiwConnectTitle => 'Ihr Konto verbinden';

  @override
  String get hiwConnectDesc =>
      'ValleySave verwendet Ihr Google-Konto, um Ihre Speicherstände in einem privaten ValleySave-Ordner auf Ihrem eigenen Drive zu speichern.';

  @override
  String get hiwConnectStepGoogle => 'Google-\nKonto';

  @override
  String get hiwConnectStepDrive => 'ValleySave-Ordner\nerstellt';

  @override
  String get hiwConnectStepReady => 'Bereit zum\nSynchronisieren';

  @override
  String get hiwConnectTipOwnership =>
      'Nur Sie können Ihre Kopien auf Drive bearbeiten oder löschen — ValleySave liest und schreibt nur innerhalb seines eigenen Ordners.';

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
  String get overwriteWhatChanges => 'Was sich ändert';

  @override
  String get overwriteTagOverwritten => 'WIRD ÜBERSCHRIEBEN';

  @override
  String get overwriteNewCopyTag => 'NEU';

  @override
  String overwriteDeltaPhrase(int days, String time) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: '$days Tage und $time',
      one: '1 Tag und $time',
      zero: '$time',
    );
    return '$_temp0';
  }

  @override
  String overwriteVerdictAhead(String delta) {
    return 'Sie sind $delta voraus. Es ist sicher.';
  }

  @override
  String get overwriteVerdictMoneySpent =>
      '💰 Das aktuelle Geld ist gesunken, aber der Gesamtfortschritt geht voran — Sie haben es wahrscheinlich für etwas ausgegeben. Das ist kein echter Verlust.';

  @override
  String overwriteVerdictNegligible(String delta) {
    return 'Minimaler Unterschied ($delta). Beide Kopien funktionieren.';
  }

  @override
  String overwriteVerdictDanger(String delta, String target) {
    return '⚠️ Sie verlieren $delta an Fortschritt bei $target. Überprüfen Sie es, bevor Sie fortfahren.';
  }

  @override
  String get overwriteConfirmTitleUpload => 'Upload bestätigen?';

  @override
  String get overwriteConfirmTitleDownload => 'Download bestätigen?';

  @override
  String overwriteConfirmBody(String delta, String target) {
    return 'Sie verlieren $delta bei $target. Diese Aktion kann nicht rückgängig gemacht werden.';
  }

  @override
  String get overwriteConfirmButtonUpload => 'Upload bestätigen';

  @override
  String get overwriteConfirmButtonDownload => 'Download bestätigen';

  @override
  String get overwriteDangerButtonUpload => '⚠️ Trotzdem hochladen';

  @override
  String get overwriteDangerButtonDownload => '⚠️ Trotzdem herunterladen';

  @override
  String overwriteIdenticalSummary(int count, String list) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '✓ $count identisch',
      one: '✓ 1 identisch',
    );
    return '$_temp0 — $list';
  }

  @override
  String overwriteUploadToOwner(String email) {
    return 'Auf Drive von $email hochladen';
  }

  @override
  String get overwriteUploadBoth => 'Auf beide Drives hochladen';

  @override
  String get overwriteConfirmTitleBoth => 'Beide Uploads bestätigen?';

  @override
  String overwriteConfirmBodyBoth(String delta, String targets) {
    return 'Sie verlieren $delta bei $targets. Diese Aktion kann nicht rückgängig gemacht werden.';
  }

  @override
  String overwriteBothDestinationsLabel(String first, String second) {
    return '$first und $second';
  }

  @override
  String get sharedTargetOwnDrive => 'Ihr Drive';

  @override
  String sharedStatusLocalAhead(String targets) {
    return 'Sie sind bei $targets voraus';
  }

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
  String get snackReplacePrepareFailed =>
      'Der Speicherstand konnte nicht vorbereitet werden. Es wurde nichts auf der Festplatte geändert';

  @override
  String get snackReplaceValidationFailed =>
      'Der heruntergeladene Speicherstand scheint ungültig oder unvollständig zu sein. Es wurde nichts auf der Festplatte geändert';

  @override
  String get snackReplaceBackupFailed =>
      'Es konnte keine Sicherung erstellt werden. Es wurde nichts auf der Festplatte geändert';

  @override
  String get snackReplaceSwapFailed =>
      'Der Austausch ist fehlgeschlagen, aber der ursprüngliche Speicherstand wurde aus der Sicherung wiederhergestellt';

  @override
  String get snackReplaceBusy =>
      'Für diesen Speicherstand läuft bereits ein Vorgang';

  @override
  String get snackUploadIncomplete =>
      'Der lokale Speicherstand ist unvollständig oder beschädigt. Es wurde nichts hochgeladen';

  @override
  String get snackDownloadIncomplete =>
      'Herunterladen nicht möglich: Auf Drive fehlt Inhalt';

  @override
  String get cardIncomplete => 'Unvollständig auf Drive';

  @override
  String get autoRefreshTitle => 'Auto-Aktualisierung';

  @override
  String get autoRefreshSubtitle => 'Prüft alle 30 s auf Änderungen auf Drive';

  @override
  String autoSyncSnack(String farmName) {
    return '$farmName wurde automatisch synchronisiert';
  }

  @override
  String get autoSyncTooltipOn =>
      'Auto-Sync aktiviert — synchronisiert sich selbst, wenn es sicher ist';

  @override
  String get autoSyncTooltipOff =>
      'Auto-Sync deaktiviert — tippen, um es zu aktivieren';

  @override
  String get autoSyncExplainTitle => 'Auto-Sync';

  @override
  String autoSyncExplainBody(String farmName) {
    return 'Ab jetzt wird $farmName von selbst hoch- oder heruntergeladen, wenn es sicher ist, ohne dass Sie bestätigen müssen.';
  }

  @override
  String get autoSyncExplainSafe =>
      'Es handelt nur, wenn Sie eindeutig voraus sind und nichts verloren geht.';

  @override
  String get autoSyncExplainDanger =>
      'Bestünde ein Risiko, Fortschritt zu verlieren, handelt es nie von selbst: Sie entscheiden weiterhin über den gewohnten Dialog.';

  @override
  String get autoSyncExplainMissing =>
      'Fehlt eine der beiden Kopien, wird sie nicht von selbst erstellt: Das erste Hoch- oder Herunterladen entscheiden Sie.';

  @override
  String get autoSyncExplainDontShowAgain =>
      'Diesen Hinweis nicht mehr anzeigen';

  @override
  String get autoSyncExplainConfirm => 'Verstanden, aktivieren';

  @override
  String get hiwAutoSyncTitle => 'Selbstständig synchronisieren';

  @override
  String get hiwAutoSyncDesc =>
      'Jeder Speicherstand hat ein AUTO-Chip auf seiner Karte. Wenn Sie es aktivieren, wird dieser Speicherstand von selbst hoch- oder heruntergeladen, sobald die App eine Änderung erkennt — ohne dass Sie es bestätigen müssen.';

  @override
  String get hiwAutoSyncTipSafe =>
      'Es synchronisiert sich nur von selbst, wenn Sie eindeutig voraus sind und nichts verloren geht.';

  @override
  String get hiwAutoSyncTipDanger =>
      'Bestünde ein Risiko, Fortschritt zu verlieren, macht es das nie von selbst: Es fragt weiterhin mit dem gewohnten Vergleich nach.';

  @override
  String get hiwAutoSyncTipPerSave =>
      'Es wird pro Speicherstand aktiviert, nicht auf einmal: Sie können es bei Ihrem eigenen aktivieren und bei einem geteilten nicht.';

  @override
  String get hiwAutoSyncTipMissing =>
      'Es hält nur zwei bereits existierende Kopien synchron. Fehlt eine, führen Sie das erste Hoch- oder Herunterladen selbst durch.';

  @override
  String get hiwAutoSyncTipRefresh =>
      'In den Einstellungen können Sie die automatische Änderungsprüfung ganz ausschalten.';

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
  String get hiwCompatIncomplete =>
      'Wenn Sie bei einem Speicherstand \"Unvollständig auf Drive\" sehen, fehlt ihm eine notwendige Datei in der Cloud — er kann erst heruntergeladen werden, wenn er von einem anderen Gerät aus richtig erneut hochgeladen wurde.';

  @override
  String get hiwShareTitle => 'Mit anderen teilen';

  @override
  String get hiwShareDesc =>
      'Teilen Sie einen Speicherstand per E-Mail mit einem anderen Spieler. Er wird ihn unter Mit mir geteilt auf seinem eigenen Gerät sehen.';

  @override
  String get hiwShareStepYourSave => 'Ihr\nSpeicherstand';

  @override
  String get hiwShareStepShare => 'Per E-Mail\nteilen';

  @override
  String get hiwShareStepFriend => 'Mit mir\ngeteilt';

  @override
  String get hiwShareTipRoles =>
      'Zwei Rollen: Nur lesen erlaubt Ansehen und Herunterladen. Synchronisieren erlauben erlaubt das Überschreiben Ihrer Kopie auf Drive. In keinem Fall können sie sie löschen — nur Sie als Eigentümer können Ihren Speicherstand löschen.';

  @override
  String get hiwShareTipDisconnect =>
      'Trennen stoppt die Synchronisierung nur auf ihrer Seite — die Freigabe bleibt aktiv, bis Sie sie über Freigaben verwalten wirklich verlassen.';

  @override
  String get hiwHostSwapTitle => 'Gastgeberwechsel';

  @override
  String get hiwHostSwapDesc =>
      'Ändert, welcher Farmhand der Gastgeber des Speicherstands ist, indem er direkt ersetzt wird — gleicher Speicherplatz, gleiche Freigabeberechtigungen.';

  @override
  String get hiwHostSwapStepPick => 'Farmhand\nwählen';

  @override
  String get hiwHostSwapStepConfirm => 'Bestätigen';

  @override
  String get hiwHostSwapStepDone => 'Neuer Speicherstand\nerstellt';

  @override
  String get hiwHostSwapTipMove =>
      'Einige Objekte auf dem Hof können verschoben werden, um Platz für das Haus zu schaffen — nichts wird gelöscht.';

  @override
  String get hiwHostSwapTipHouse =>
      'Das Haus des neuen Gastgebers sieht aus wie das standardmäßige große Bauernhaus des Spiels — die Hütten-Optik wird ohne Mods nicht unterstützt.';

  @override
  String get hiwBackupsTitle => 'Sicherungen';

  @override
  String get hiwBackupsDesc =>
      'Eine Sicherung ist eine Momentaufnahme eines Speicherstands, die Sie später wiederherstellen können. Erstellen Sie sie manuell, wann immer Sie möchten, oder lassen Sie ValleySave automatisch eine erstellen, bevor ein Speicherstand überschrieben wird (beim Herunterladen, Importieren, Wiederherstellen oder Gastgeberwechsel).';

  @override
  String get hiwBackupsStepSave => 'Ihr\nSpeicherstand';

  @override
  String get hiwBackupsStepSnapshot => 'Sicherung\nerstellt';

  @override
  String get hiwBackupsStepStore => 'Lokal und/oder\nDrive';

  @override
  String get hiwBackupsTipRestore =>
      'Wiederherstellen überschreibt Ihren aktuellen Speicherstand mit dieser früheren Version — kann nicht rückgängig gemacht werden.';

  @override
  String get hiwBackupsTipDelete =>
      'Das Löschen einer Sicherung entfernt sie an allen Orten, an denen sie existiert (dieses Gerät und Drive, falls hochgeladen) — kann nicht rückgängig gemacht werden.';

  @override
  String get hiwBackupsTipExport =>
      'Sie können einen Speicherstand auch als Zip Exportieren, um ihn zu speichern, wo Sie möchten, und ihn später wieder Importieren — eine manuelle, portable Alternative zu den integrierten Sicherungen.';

  @override
  String get hiwBackupsTipRetention =>
      'ValleySave behält die 5 neuesten automatischen Sicherungen jedes Speicherstands; die, die Sie manuell erstellen, werden nie von selbst gelöscht.';

  @override
  String get hiwBackupsTipRestoreBridge =>
      'Im Brücken-Modus (Android ohne Root/Shizuku) müssen Sie beim Wiederherstellen einer Sicherung die .zip-Datei manuell in den Stardew-Ordner entpacken — genau wie beim Herunterladen.';

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
  String get hiwLaunchTipLinux =>
      'Unter Linux, wenn das Spiel nicht automatisch erkannt wird, legen Sie den Pfad der ausführbaren Datei unter Einstellungen → Spiel fest.';

  @override
  String get hiwSaveLocationsTitle => 'Wo Ihre Speicherstände liegen';

  @override
  String get hiwSaveLocationsDesc =>
      'ValleySave liest und schreibt direkt im Speicherordner des Spiels auf jeder Plattform.';

  @override
  String get hiwSaveLocationWindows =>
      'Windows: %AppData%\\StardewValley\\Saves';

  @override
  String get hiwSaveLocationAndroid =>
      'Android: geschützter Ordner, Zugriff über Shizuku oder die Brücke';

  @override
  String get hiwSaveLocationLinux =>
      'Linux: ~/.config/StardewValley/Saves (oder ~/snap/steam/common/.config/StardewValley/Saves, wenn Steam über Snap installiert ist)';

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

  @override
  String get makeHostDeleteOriginalTitle =>
      'Original-Spielstand von diesem Gerät löschen?';

  @override
  String get makeHostDeleteOriginalBody =>
      'Der neue Spielstand ist bereit. Sichere das Original zuerst in deinem Drive (du kannst es später erneut herunterladen) oder lösche einfach die lokale Kopie.';

  @override
  String get makeHostDeleteOriginalNoBackupBody =>
      'Keine Drive-Verbindung: Es bleibt keine Sicherung übrig. Nur die lokale Kopie auf diesem Gerät wird gelöscht.';

  @override
  String get makeHostDeleteOriginalUploadBody =>
      'Der Original-Spielstand wird zuerst als Sicherung in dein Drive hochgeladen, dann wird die lokale Kopie auf diesem Gerät gelöscht.';

  @override
  String get makeHostDeleteWithoutUpload => 'Ohne Hochladen löschen';

  @override
  String get makeHostUploadAndDelete => 'Hochladen und löschen';
}
