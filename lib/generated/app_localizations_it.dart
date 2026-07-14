// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Italian (`it`).
class AppLocalizationsIt extends AppLocalizations {
  AppLocalizationsIt([String locale = 'it']) : super(locale);

  @override
  String get appTitle => 'ValleySave';

  @override
  String get welcomeTitle => 'Non perdere mai la tua fattoria, portala con te.';

  @override
  String get connectGoogleDrive => 'Connetti Google Drive';

  @override
  String get connecting => 'Connessione in corso…';

  @override
  String get mySaves => 'I miei salvataggi';

  @override
  String get howItWorks => 'Come funziona';

  @override
  String get settings => 'Impostazioni';

  @override
  String get aboutSection => 'Informazioni';

  @override
  String get openSource => 'Codice disponibile';

  @override
  String get nonCommercial => 'Non commerciale';

  @override
  String get freeForever => 'Gratuito per sempre';

  @override
  String get privacyTitle => 'Privacy e utilizzo dei dati';

  @override
  String get privacyDescription =>
      'ValleySave è un\'app per sincronizzare i tuoi salvataggi di Stardew Valley con il tuo account Google Drive.';

  @override
  String get whatDataTitle => 'Quali dati utilizza';

  @override
  String get whatDataDesc =>
      'ValleySave accede solo ai file di salvataggio di Stardew Valley necessari per fare copie, sincronizzarli o ripristinarli.';

  @override
  String get googleDriveTitle => 'Google Drive';

  @override
  String get googleDriveDesc =>
      'I tuoi salvataggi vengono caricati sul tuo account Google Drive. ValleySave non utilizza server propri per archiviare i tuoi giochi.';

  @override
  String get androidPermissionsTitle => 'Autorizzazioni su Android';

  @override
  String get androidPermissionsDesc =>
      'ValleySave potrebbe aver bisogno di autorizzazioni di archiviazione o strumenti come Shizuku per accedere ai file di salvataggio.';

  @override
  String get adsTitle => 'Annunci';

  @override
  String get adsDesc =>
      'ValleySave può visualizzare annunci tramite Google AdMob.';

  @override
  String get responsibilityTitle => 'Responsabilità';

  @override
  String get responsibilityDesc =>
      'I tuoi file di salvataggio sono tuia responsabilità.';

  @override
  String get deleteDataTitle => 'Elimina dati';

  @override
  String get deleteDataDesc =>
      'Puoi eliminare le tue copie sincronizzate eliminando manualmente la cartella ValleySave da Google Drive.';

  @override
  String get sourceCodeTitle => 'Codice sorgente e contatti';

  @override
  String get sourceCodeDesc =>
      'ValleySave è un progetto con codice disponibile sotto licenza Polyform Noncommercial.';

  @override
  String get upToDate => 'Aggiornato';

  @override
  String get checkingUpdates => 'Verifica in corso…';

  @override
  String get updateAvailable => 'Aggiornamento disponibile';

  @override
  String get application => 'Applicazione';

  @override
  String version(Object version) {
    return 'Versione $version';
  }

  @override
  String get checkForUpdates => 'Controlla aggiornamenti';

  @override
  String get shizukuRequired => 'Shizuku richiesto';

  @override
  String get shizukuGuide => 'Guida alla configurazione di Shizuku';

  @override
  String get activateShizuku =>
      'Attiva Shizuku per scrivere il salvataggio nel gioco.';

  @override
  String deleteSaveTitle(Object saveName) {
    return 'Elimina $saveName';
  }

  @override
  String get deleteSaveMessage =>
      'Questo eliminerà il salvataggio da questo dispositivo. Vuoi continuare?';

  @override
  String get deleteFromDrive => 'Elimina da Drive';

  @override
  String confirmDelete(Object saveName) {
    return 'Il salvataggio $saveName verrà spostato nel Cestino di Google Drive.';
  }

  @override
  String deleteFromDeviceMessage(Object saveName) {
    return 'Il salvataggio $saveName verrà eliminato permanentemente da questo dispositivo.';
  }

  @override
  String restoreSaveTitle(Object saveName) {
    return 'Ripristina $saveName';
  }

  @override
  String restoreSaveMessage(Object saveName) {
    return 'Scaricare $saveName su questo dispositivo?';
  }

  @override
  String get restore => 'Ripristina';

  @override
  String get cancel => 'Annulla';

  @override
  String get error => 'Errore';

  @override
  String get success => 'Successo';

  @override
  String get loading => 'Caricamento…';

  @override
  String get disconnect => 'Disconnetti';

  @override
  String get ok => 'OK';

  @override
  String get yes => 'Sì';

  @override
  String get no => 'No';

  @override
  String get welcomeHeroPre => 'Non perdere\nmai la tua ';

  @override
  String get welcomeHeroAccent => 'fattoria,';

  @override
  String get welcomeHeroPost => '\nportala con te.';

  @override
  String get welcomeSubtitle =>
      'Sincronizza i tuoi salvataggi di Stardew Valley su tutti i tuoi dispositivi. I tuoi dati vivono nel tuo Google Drive — nessun server, nessun abbonamento, sotto il tuo controllo.';

  @override
  String get welcomeDriveConnected => 'Drive connesso';

  @override
  String get welcomeFooterTagline =>
      '· Non commerciale · Gratuito per sempre ·';

  @override
  String updateVersionAvailable(String version) {
    return 'v$version disponibile';
  }

  @override
  String get sectionMode => 'Modalità';

  @override
  String get sectionSeason => 'Stagione';

  @override
  String get sectionLanguage => 'Lingua';

  @override
  String get modeAutoTitle => 'Automatico';

  @override
  String get modeAutoDesc =>
      'Segue il tuo salvataggio attivo e, se non ci sono salvataggi, la tua posizione reale.';

  @override
  String get modeSavesTitle => 'Per salvataggio';

  @override
  String get modeSavesDesc =>
      'Usa sempre la stagione del tuo salvataggio più recente.';

  @override
  String get modeGeoTitle => 'Per posizione';

  @override
  String get modeGeoDesc => 'Usa sempre la stagione reale della tua posizione.';

  @override
  String get modeFixedTitle => 'Stagione fissa';

  @override
  String get modeFixedDesc => 'Mostra sempre la stessa stagione.';

  @override
  String get modeRandomTitle => 'Casuale';

  @override
  String get modeRandomDesc =>
      'Sceglie una stagione diversa ogni volta che apri l\'app.';

  @override
  String get seasonInitial => 'Iniziale';

  @override
  String get seasonSpring => 'Primavera';

  @override
  String get seasonSummer => 'Estate';

  @override
  String get seasonFall => 'Autunno';

  @override
  String get seasonWinter => 'Inverno';

  @override
  String get autoPriorityTitle => 'Ordine di priorità';

  @override
  String get autoStep1Title => 'Primo avvio';

  @override
  String get autoStep1Desc => 'Mostra lo stato iniziale.';

  @override
  String get autoStep2Title => 'Salvataggio attivo';

  @override
  String get autoStep2Desc =>
      'Usa la stagione dell\'ultimo salvataggio sincronizzato.';

  @override
  String get autoStep3Title => 'Posizione';

  @override
  String get autoStep3Desc =>
      'Rileva il tuo emisfero e la stagione reale della tua regione.';

  @override
  String get autoStep4Title => 'Predefinito';

  @override
  String get autoStep4Desc =>
      'Iniziale (modalità notte) se non sono disponibili dati.';

  @override
  String get versionInstalled => 'Versione installata';

  @override
  String get updateNeverChecked => 'Mai verificato';

  @override
  String get updateCheckedNow => 'Appena verificato';

  @override
  String get updateOutdatedDownload => 'Non aggiornato · Scarica';

  @override
  String get updateDownloading => 'Download aggiornamento…';

  @override
  String get updateError => 'Errore — tocca per riprovare';

  @override
  String get disconnectTitle => 'Disconnettere Drive?';

  @override
  String get disconnectBody =>
      'I tuoi salvataggi su Drive non verranno eliminati. Puoi riconnetterti in qualsiasi momento.';

  @override
  String get disconnectButton => 'Disconnetti Drive';

  @override
  String get languageTileLabel => 'Lingua';

  @override
  String get languageDialogTitle => 'Lingua dell\'app';

  @override
  String get searchHint => 'Cerca…';

  @override
  String get languageAuto => 'Lingua di sistema';

  @override
  String get languageAutoDesc => 'Usa la lingua del sistema';

  @override
  String get privacyPolicyTitle => 'Informativa sulla privacy';

  @override
  String get privacyBeforeStartTitle => 'Prima di iniziare';

  @override
  String get privacyLastUpdated => 'Ultimo aggiornamento: giugno 2026';

  @override
  String get privacyAccept => 'Capito, continua';

  @override
  String get cardSynced => 'Sincronizzato';

  @override
  String get cardLocalAhead => 'Locale avanti';

  @override
  String get cardDriveAhead => 'Drive avanti';

  @override
  String get cardLocalOnly => 'Solo locale';

  @override
  String get cardDriveOnly => 'Solo Drive';

  @override
  String get cardTimeNow => 'adesso';

  @override
  String cardTimeMinutesAgo(int minutes) {
    return '$minutes min fa';
  }

  @override
  String cardTimeHoursAgo(int hours) {
    return '${hours}h fa';
  }

  @override
  String cardTimeDaysAgo(int days) {
    return '${days}g fa';
  }

  @override
  String cardTimeMonthsAgo(int months) {
    return '${months}me fa';
  }

  @override
  String get cardDetailLocalTitle => 'Su questo dispositivo';

  @override
  String get cardDetailRemoteTitle => 'Su Drive';

  @override
  String get cardDetailUpload => 'Carica su Drive';

  @override
  String get cardDetailDownload => 'Scarica salvataggio';

  @override
  String get cardDetailDeleteLabel => 'Elimina';

  @override
  String get cardDetailDeleteLocal => 'Elimina da questo dispositivo';

  @override
  String get cardDetailDeleteRemote => 'Elimina da Drive';

  @override
  String get cardCloseBarrier => 'Chiudi';

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
    return 'You\'ll stop syncing with $email\'s Drive, but you can add it back anytime — it stays shared. Your local copy remains a normal coop save.';
  }

  @override
  String sharedLeaveConfirm(Object email) {
    return 'You\'ll lose access to this save for real. You won\'t be able to add it back unless $email shares it with you again. Your local copy remains a normal coop save.';
  }

  @override
  String get sharedManageButton => 'Manage';

  @override
  String get sharedManageDialogTitle => 'Manage shared saves';

  @override
  String get sharedManageDialogHint =>
      'Here you can really leave a shared save.';

  @override
  String get sharedLeaveButton => 'Leave shared save';

  @override
  String sharedLeaveSuccess(Object email) {
    return 'You left $email\'s shared save.';
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
  String get sharedDownloadOwn => 'Download from my Drive';

  @override
  String get sharedStatusOwnDriveAhead => 'Your Drive is ahead — bring it down';

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
  String get sharedStatusFullySynced => 'Fully synchronized';

  @override
  String get sharedStatusSyncedOwn => 'My Drive synchronized';

  @override
  String get sharedStatusSyncedOwner => 'Shared Drive synchronized';

  @override
  String get sharedStatusNotCloud => 'Only on this device';

  @override
  String sharedStatusOwnerAhead(Object email) {
    return 'Drive at $email is ahead';
  }

  @override
  String get sharedStatusBothAhead => 'Both Drives are ahead';

  @override
  String get sharedStatusLocalMissing => 'Not on this device';

  @override
  String sharedStatusOwnerUnavailable(Object email) {
    return 'Could not check Drive at $email';
  }

  @override
  String get sharedStatusWorking => 'Synchronizing…';

  @override
  String get sharedSideUnavailable => 'Could not check';

  @override
  String get sharedSyncChooseTitle => 'Where do you want to synchronize?';

  @override
  String get sharedSyncChooseBody =>
      'Choose which cloud copies to update from this device.';

  @override
  String get sharedSyncTargetOwn => 'My Drive';

  @override
  String sharedSyncTargetOwner(Object email) {
    return 'Drive at $email';
  }

  @override
  String get sharedSyncTargetBoth => 'Both Drives';

  @override
  String get sharedDownloadChooseTitle => 'Which copy do you want to download?';

  @override
  String get sharedDownloadChooseBody =>
      'More than one copy is ahead. Choose which one to bring to this device.';

  @override
  String get sharedDownloadSourceOwn => 'From My Drive';

  @override
  String sharedDownloadSourceOwner(Object email) {
    return 'From Drive at $email';
  }

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
  String get backupsCreate => 'Create local backup';

  @override
  String get backupsCreateLocalHint =>
      'Backups are created on this device first. You can upload them to Drive afterwards.';

  @override
  String get backupsCreateOk => 'Backup created.';

  @override
  String backupsCreateErr(String error) {
    return 'Couldn\'t create the backup: $error';
  }

  @override
  String get backupsDownload => 'Download';

  @override
  String get backupsDownloadOk => 'Backup downloaded to this device.';

  @override
  String backupsDownloadErr(String error) {
    return 'Couldn\'t download the backup: $error';
  }

  @override
  String get backupsCopyOwn => 'Copy to my Drive';

  @override
  String get backupsUploadOwn => 'To my Drive';

  @override
  String get backupsUploadShared => 'To shared Drive';

  @override
  String get backupsUploadOk => 'Backup uploaded.';

  @override
  String backupsUploadErr(String error) {
    return 'Couldn\'t upload the backup: $error';
  }

  @override
  String get backupsLocationLocal => 'This device';

  @override
  String get backupsLocationOwnDrive => 'My Drive';

  @override
  String get backupsLocationSharedDrive => 'Shared Drive';

  @override
  String get backupsDeleteChooseBody =>
      'Choose exactly where to delete it. Only locations where this backup exists are shown.';

  @override
  String get backupsDeleteLocalOnly => 'Only from this device';

  @override
  String get backupsDeleteOwnOnly => 'Only from my Drive';

  @override
  String get backupsDeleteSharedOnly => 'Only from shared Drive';

  @override
  String get backupsDeleteAll => 'From all copies';

  @override
  String deleteUnifiedTitle(String farmName) {
    return 'Delete $farmName?';
  }

  @override
  String get deleteChooseLocationBody =>
      'Choose where. Your device copy is deleted forever; the Drive copy goes to Trash (30 days).';

  @override
  String deleteDriveContextTitle(String farmName) {
    return 'Delete $farmName from Drive?';
  }

  @override
  String get deleteDriveContextBody =>
      'The Drive copy will move to Trash, where it can be recovered for 30 days.';

  @override
  String get deleteDriveLocalKept =>
      'The copy on this device will remain unchanged.';

  @override
  String deleteLocalContextTitle(String farmName) {
    return 'Delete $farmName from this device?';
  }

  @override
  String get deleteLocalContextBody =>
      'The copy on this device will be deleted permanently.';

  @override
  String deleteLocalDriveCurrent(String date) {
    return 'Your Drive copy is up to date ($date) and will remain available.';
  }

  @override
  String deleteLocalDriveAhead(String date) {
    return 'Your Drive copy is newer ($date) and will remain available.';
  }

  @override
  String deleteLocalDriveOlder(String driveDate, String localDate) {
    return 'Your Drive copy is older ($driveDate); this device is at $localDate.';
  }

  @override
  String deleteLocalBackupAvailable(int count) {
    return 'There are $count local backups available if you need an earlier copy.';
  }

  @override
  String get deleteLocalNoRecovery =>
      'There is no Drive copy or local backup to recover this game from.';

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
    return 'Giorno $day · Anno $year';
  }

  @override
  String statDayOnly(int day) {
    return 'Giorno $day';
  }

  @override
  String get statPlaytime => 'Tempo di gioco';

  @override
  String get statMoney => 'Monete';

  @override
  String get statTotal => 'Totale';

  @override
  String get statMineUnexplored => 'Inesplorata';

  @override
  String get statMine => 'Miniera';

  @override
  String get statMineLvl => 'Miniera · Lv';

  @override
  String get skillFarming => 'Coltivazione';

  @override
  String get skillForaging => 'Raccolta';

  @override
  String get skillMining => 'Estrazione';

  @override
  String get skillFishing => 'Pesca';

  @override
  String get skillCombat => 'Combattimento';

  @override
  String get cardLocalPresence => 'Su questo dispositivo';

  @override
  String get cardRemotePresence => 'Su Drive';

  @override
  String get cardNotPresent => 'Non presente';

  @override
  String get cardActionSynced => 'Sincronizzato';

  @override
  String get cardActionUpload => 'Carica';

  @override
  String get cardActionDownload => 'Scarica';

  @override
  String get pillMonsters => 'mostri';

  @override
  String get pillFriends => 'amici';

  @override
  String get pillFaints => 'svenimenti';

  @override
  String get pillSleeps => 'Riposi';

  @override
  String get hiwTitle => 'Come funziona';

  @override
  String get hiwSyncTitle => 'Come funziona la sincronizzazione';

  @override
  String get hiwSyncIntro =>
      'ValleySave usa il tuo Google Drive per spostare i salvataggi tra dispositivi. Nessun server intermediario: i file sono tuoi.';

  @override
  String get hiwSyncDevice => 'Il tuo\ndispositivo';

  @override
  String get hiwSyncCloud => 'Google\nDrive';

  @override
  String get hiwSyncOtherDevice => 'Altro\ndispositivo';

  @override
  String get hiwUploadTitle => 'Caricare un salvataggio';

  @override
  String get hiwUploadDesc =>
      'Quando carichi, ValleySave copia entrambi i file di salvataggio (SaveGameInfo + file della fattoria) nella tua cartella ValleySave/ su Drive.';

  @override
  String get hiwDownloadTitle => 'Scaricare un salvataggio';

  @override
  String get hiwDownloadDesc =>
      'Quando scarichi, ValleySave prende i file da Drive e li posiziona direttamente nella cartella del gioco.';

  @override
  String get hiwCompareTitle => 'Cosa confronta?';

  @override
  String get hiwCompareIntro =>
      'Per sapere quale versione è avanti, ValleySave usa il tempo di gioco totale — l\'unico dato che può solo crescere.';

  @override
  String get hiwCompareNote =>
      'Prima di confermare vedrai anche, così puoi decidere:';

  @override
  String get hiwCompareMoney => 'Denaro attuale e totale guadagnato';

  @override
  String get hiwCompareMine => 'Livello della miniera';

  @override
  String get hiwCompareSkills =>
      'Abilità (coltivazione, estrazione, combattimento…)';

  @override
  String get hiwCompareRelations => 'Amici, mostri uccisi, svenimenti';

  @override
  String get hiwCompareStamina => 'Resistenza e salute';

  @override
  String get hiwCompareNotShown =>
      'Questi non vengono mostrati — cambiano in qualsiasi direzione e non indicano quale salvataggio è avanti.';

  @override
  String get hiwCompareNotShownExamples =>
      'Stato colture e animali, inventario e oggetti, relazioni individuali';

  @override
  String get hiwCompareWarning =>
      'Non vengono mostrati — cambiano in qualsiasi direzione e non indicano quale salvataggio è avanti.';

  @override
  String get hiwConflictTitle => 'Se giochi senza sincronizzare';

  @override
  String get hiwConflictDesc =>
      'Se avanzi su mobile e PC senza sincronizzare tra le sessioni, ti ritrovi con due versioni dello stesso salvataggio.';

  @override
  String get hiwConflictNoMerge =>
      'Non possono essere uniti. ValleySave ti mostra sempre entrambe le versioni in modo che tu possa scegliere quale mantenere.';

  @override
  String get hiwConflictMobile => 'Mobile';

  @override
  String get hiwConflictVersionA => 'versione A';

  @override
  String get hiwConflictPC => 'PC';

  @override
  String get hiwConflictVersionB => 'versione B';

  @override
  String get hiwDeleteTitle => 'Se un salvataggio viene eliminato';

  @override
  String get hiwDeleteDesc =>
      'Quando elimini un salvataggio da Drive, non scompare immediatamente: va nel Cestino di Google Drive.';

  @override
  String get hiwCompatTitle => 'Compatibilità tra piattaforme';

  @override
  String get hiwCompatAndroidAccess => 'ACCESSO SU ANDROID';

  @override
  String get hiwShizukuTitle => 'Con Shizuku';

  @override
  String get hiwShizukuSubtitle =>
      'Configurato una volta. Dopodiché, ValleySave si sincronizza da solo, senza che tu debba mai toccarlo di nuovo.';

  @override
  String get hiwShizukuBadge => 'AUTOMATICO · CONSIGLIATO';

  @override
  String get hiwShizukuDone =>
      '✓  Fatto. Da quel momento in poi, scaricare e caricare i salvataggi è diretto, proprio come su un computer.';

  @override
  String get hiwShizukuNote =>
      'L\'associazione avviene solo la prima volta. Le nuove versioni di Shizuku si riattivano da sole dopo aver riavviato il telefono.';

  @override
  String get hiwBridgeTitle => 'Ponte manuale';

  @override
  String get hiwBridgeSubtitle =>
      'Funziona solo su Android 11 e 12. Non installi nulla di extra; invece, copi il salvataggio a mano con la tua app File ogni volta che sincronizzi.';

  @override
  String get hiwBridgeBadge => 'ALTERNATIVA MANUALE · ANDROID 11-12';

  @override
  String get hiwBridgeSaveFolder => 'Cartella di Stardew';

  @override
  String get hiwBridgeValleySaveFolder => 'Cartella di ValleySave';

  @override
  String get hiwBridgeNote =>
      'Funziona perché la tua app File di sistema può accedere a quelle cartelle (ValleySave non può).';

  @override
  String get hiwTipAlwaysShow =>
      'Vedrai sempre cosa c\'è su Drive prima di sovrascrivere, così puoi confrontare.';

  @override
  String get hiwTipWithoutUpload =>
      'Senza caricare, nessun altro dispositivo vedrà i tuoi progressi recenti.';

  @override
  String get hiwTipComparison =>
      'Vedrai il confronto tra locale e Drive prima di confermare.';

  @override
  String get hiwTipDownloadOverwrite =>
      'Il download sovrascrive il tuo salvataggio locale. Qualsiasi progresso non sincronizzato andrà perso.';

  @override
  String get hiwTipSync =>
      'Carica sempre prima di cambiare dispositivo e scarica quando arrivi.';

  @override
  String get hiwTipDeletion =>
      'Hai 30 giorni per ripristinarlo dal Cestino di Drive prima che venga eliminato definitivamente.';

  @override
  String get hiwPrivacyLink => 'Informativa sulla privacy e utilizzo';

  @override
  String get emptyNoSaves => 'Nessun salvataggio trovato';

  @override
  String get emptyNoSavesHint =>
      'Non è possibile leggere salvataggi locali su questo dispositivo';

  @override
  String get bridgeTitle => 'Porta i tuoi salvataggi';

  @override
  String get bridgeDesc =>
      'Per vedere e caricare i tuoi salvataggi locali, copiali con la tua app File dalla cartella Stardew a questa cartella ValleySave. Poi scorri per aggiornare.';

  @override
  String get bridgeRefresh => 'Aggiorna';

  @override
  String get bridgeChangeMode => 'Cambia metodo';

  @override
  String get loaderLoading => 'CARICAMENTO';

  @override
  String get loaderConnecting => 'connessione a Drive…';

  @override
  String get chooserTitle => 'Scegli come connetterti';

  @override
  String get chooserAutomatic => 'Automatico · Consigliato';

  @override
  String get chooserManual => 'Alternativa manuale · Android 11-12';

  @override
  String get shizukuStepTitle => 'Configura Shizuku';

  @override
  String get shizukuStep1Title => 'Installa Shizuku';

  @override
  String get shizukuStep1Desc => 'Scarica dal Play Store o GitHub';

  @override
  String get shizukuStep2Title => 'Attiva Shizuku';

  @override
  String get shizukuStep2Desc => 'Avvia l\'app e concedi le autorizzazioni';

  @override
  String get shizukuStep3Title => 'Concedi autorizzazione';

  @override
  String get shizukuStep3Desc => 'ValleySave chiederà l\'accesso';

  @override
  String get shizukuDone =>
      '✓  Fatto. Da quel momento in poi, scaricare e caricare i salvataggi funziona direttamente, come su un computer.';

  @override
  String get dlgDeleteDriveTitle => 'Elimina da Drive';

  @override
  String get dlgDeleteLocalTitle => 'Elimina da questo dispositivo';

  @override
  String get dlgDownloadTitle => 'Scarica salvataggio';

  @override
  String get dlgUploadTitle => 'Carica salvataggio';

  @override
  String get dlgUploadOverwrite =>
      'Questo sovrascriverà il tuo salvataggio locale';

  @override
  String get dlgGotIt => 'Capito';

  @override
  String get dlgCopyDest => 'Copia destinazione';

  @override
  String get previewColDayYear => 'Giorno/Anno';

  @override
  String get previewColTime => 'Tempo';

  @override
  String get previewColMoney => 'Monete';

  @override
  String get previewColTotal => 'Totale';

  @override
  String get previewColFarming => 'Coltivazione';

  @override
  String get previewColForaging => 'Raccolta';

  @override
  String get previewColMining => 'Estrazione';

  @override
  String get previewColFishing => 'Pesca';

  @override
  String get previewColCombat => 'Combattimento';

  @override
  String get previewColFriends => 'Amici';

  @override
  String get previewColMonsters => 'Mostri';

  @override
  String get previewColFaints => 'Svenimenti';

  @override
  String get previewColMine => 'Miniera';

  @override
  String get previewColUnexplored => 'Inesplorata';

  @override
  String get previewLocalLabel => 'SU QUESTO DISPOSITIVO';

  @override
  String get previewDriveLabel => 'SU DRIVE';

  @override
  String get previewFromDrive => 'DA DRIVE';

  @override
  String get previewFromDevice => 'DA QUESTO DISPOSITIVO';

  @override
  String versionMismatch(String local, String drive) {
    return 'Versioni diverse: locale $local · Drive $drive…';
  }

  @override
  String get snackPathCopied => 'Percorso copiato';

  @override
  String get snackDestCopied => 'Percorso di destinazione copiato';

  @override
  String get snackDownloaded => 'Salvataggio scaricato nel gioco';

  @override
  String get snackSessionExpired => 'Sessione Drive scaduta. Riconnetti';

  @override
  String snackUploadError(String error) {
    return 'Errore di caricamento: $error';
  }

  @override
  String snackDownloadError(String error) {
    return 'Errore di download: $error';
  }

  @override
  String snackDeleteError(String error) {
    return 'Errore di eliminazione: $error';
  }

  @override
  String snackTrashed(String saveName) {
    return '\"$saveName\" spostato nel Cestino di Drive. Hai 30 giorni per ripristinarlo.';
  }

  @override
  String snackDeletedLocal(String saveName) {
    return '\"$saveName\" eliminato da questo dispositivo';
  }

  @override
  String get snackShizukuRequired => 'Attiva Shizuku…';

  @override
  String get snackWriteError =>
      'Impossibile scrivere nel gioco. Alcuni telefoni bloccano /Android/data anche con Shizuku.';

  @override
  String get snackPlatformNotSupported =>
      'Questa piattaforma non supporta ancora la scrittura di salvataggi locali.';

  @override
  String get snackWirelessDebugHint =>
      'Apri manualmente: Impostazioni → Opzioni sviluppatore → Debug wireless.';

  @override
  String get snackOpenShizukuApp => 'Apri Shizuku dal cassetto delle app.';

  @override
  String get hiwTipDeletePermanent =>
      'ValleySave non può recuperare i salvataggi eliminati definitivamente. I file su Drive sono responsabilità tua.';

  @override
  String get hiwCompatAchievements =>
      'I risultati di Steam e Google Play non si trasferiscono. Ogni piattaforma tiene traccia solo dei risultati che avvengono in tempo reale — il file di salvataggio non li attiva retroattivamente.';

  @override
  String get hiwCompatOverwrite =>
      'Se sincronizzi da due dispositivi senza un ordine stabilito, un salvataggio può sovrascrivere l\'altro. Carica sempre prima di scaricare.';

  @override
  String get hiwCompatVersions =>
      'I salvataggi di versioni del gioco diverse potrebbero non caricarsi correttamente. ValleySave ti avvisa se rileva una discrepanza di versione prima di scaricare.';

  @override
  String get hiwCompatMods =>
      'Le mod SMAPI aggiungono dati extra al salvataggio. Se carichi un salvataggio modificato su un dispositivo dove quelle mod non sono installate, il gioco potrebbe crashare o perdere i dati delle mod.\n\nSu Android, SMAPI può essere installato anche per usare le mod.';

  @override
  String get hiwComparePrimary => 'Tempo di gioco totale';

  @override
  String get hiwCompareNoShown1 => 'Stato colture e animali';

  @override
  String get hiwCompareNoShown2 => 'Inventario e oggetti';

  @override
  String get hiwCompareNoShown3 => 'Relazioni individuali';

  @override
  String get hiwShizuku1 => 'Installa Shizuku (Play Store o APK GitHub).';

  @override
  String get hiwShizuku2 =>
      'Attivalo con il Debug wireless — ValleySave ti guida passo dopo passo.';

  @override
  String get hiwShizuku3 =>
      'Concedi l\'autorizzazione a ValleySave quando richiesto.';

  @override
  String get hiwBridge1 =>
      'Scarica da Drive: ValleySave lascia il salvataggio nella sua cartella. Lo copi con File nella cartella di Stardew.';

  @override
  String get hiwBridge2 =>
      'Carica su Drive: copia il salvataggio da Stardew nella cartella di ValleySave. ValleySave lo rileva e lo carica.';

  @override
  String get snackShizukuBattery =>
      'Impostazioni → App → Shizuku → Batteria → Senza restrizioni.';

  @override
  String snackDriveError(String error) {
    return 'Drive: $error';
  }

  @override
  String get dlgDeleteLocalWarning =>
      '⚠️ Se non hai caricato su Drive, andrà perso per sempre. Nessun recupero.';

  @override
  String get dlgDelete => 'Elimina';

  @override
  String get dlgDownloadButton => 'Scarica';

  @override
  String get dlgUploadButton => 'Carica';

  @override
  String get dlgBridgeCopyTitle => 'Copia salvataggio nel gioco';

  @override
  String dlgBridgeCopyDesc(String saveName) {
    return 'Salvataggio pronto. Con la tua app File, copia la cartella \"$saveName\" e incollala nella cartella di Stardew.';
  }

  @override
  String get labelFrom => 'Da';

  @override
  String get labelTo => 'A';

  @override
  String dlgDownloadNewDesc(String saveName, int day, String playtime) {
    return '\"$saveName\" (Giorno $day, $playtime) verrà copiato su questo dispositivo.';
  }

  @override
  String dlgDownloadOverwrite(String saveName) {
    return 'Questo SOVRASCRIVE il tuo salvataggio locale di \"$saveName\".';
  }

  @override
  String dlgUploadNewDesc(String saveName, int day, String playtime) {
    return '\"$saveName\" (Giorno $day, $playtime) verrà caricato sul tuo Drive.';
  }

  @override
  String dlgUploadOverwriteDrive(String saveName) {
    return 'Questo SOVRASCRIVE la versione Drive di \"$saveName\".';
  }

  @override
  String get pathLabelFromStardew => 'Da (Stardew)';

  @override
  String get pathLabelToValleySave => 'A (ValleySave)';

  @override
  String get chooserDesc =>
      'Android protegge la cartella del gioco. Scegli come dare accesso a ValleySave — puoi cambiarlo in qualsiasi momento.';

  @override
  String get chooserShizukuDesc =>
      'Configurato una volta. Dopodiché ValleySave si sincronizza da solo, senza che tu tocchi nulla. Unico metodo affidabile su Android 13+.';

  @override
  String get chooserManualBadge => 'SOLO ANDROID 11-12';

  @override
  String get chooserBridgeDesc =>
      'Copia i salvataggi con la tua app File. Nessuna installazione extra. Solo su Android 11 e 12.';

  @override
  String get chooserRootBadge => 'ROOT';

  @override
  String get chooserRootTitle => 'Accesso Root';

  @override
  String get chooserRootDesc =>
      'Per dispositivi con root (Magisk / SuperSU). Approva il permesso root una volta — automatico da lì in poi.';

  @override
  String get snackRootDenied => 'Accesso root negato. Prova con Shizuku.';

  @override
  String get shizukuGateSubtitle =>
      'Configurato una volta · solo la prima volta';

  @override
  String get shizukuStatusLabel => 'Shizuku attivo';

  @override
  String get shizukuStatusRunning => 'Connesso e in attesa.';

  @override
  String get shizukuStatusNotDetected => 'Non ancora rilevato.';

  @override
  String get shizukuPermLabel => 'Autorizzazione concessa';

  @override
  String get shizukuPermGranted => 'ValleySave ha già l\'accesso.';

  @override
  String get shizukuPermNotGranted => 'Bisogna autorizzare ValleySave.';

  @override
  String get shizukuGrant => 'concedi';

  @override
  String get shizukuGuideHeader => 'GUIDA PASSO DOPO PASSO';

  @override
  String get shizukuStep1DescFull =>
      'Gratuito. Se Google Play lo blocca sul tuo telefono, usa l\'APK GitHub ufficiale.';

  @override
  String get btnPlayStore => 'Play Store';

  @override
  String get btnApkGithub => 'APK GitHub';

  @override
  String get shizukuStep2TitleFull => 'Abilita Opzioni sviluppatore';

  @override
  String get shizukuStep2DescFull =>
      'Impostazioni → Info telefono → Info software → tocca \"Numero build\" 7 volte.';

  @override
  String get shizukuStep3TitleFull => 'Abilita Debug wireless';

  @override
  String get shizukuStep3DescFull =>
      'Il pulsante ti porta lì e lo evidenzia. Abilitalo (ON). Poi tocca \"Associa dispositivo con codice di associazione\" — apparirà un codice a 6 cifre sullo schermo.';

  @override
  String get btnOpenAndHighlight => 'Apri ed evidenzia';

  @override
  String get shizukuStep4Title => 'Associa e AVVIA Shizuku';

  @override
  String get shizukuStep4Desc =>
      'Apri Shizuku → \"Avvia tramite Debug wireless\" → \"Associa con codice di associazione\". Shizuku invierà una notifica dicendo che è in attesa. Inserisci il codice a 6 cifre dalla schermata Debug wireless. Dopo l\'associazione, premi AVVIA — senza quel tocco finale Shizuku non sarà attivo.';

  @override
  String get btnOpenShizuku => 'Apri Shizuku';

  @override
  String get shizukuStep5Title =>
      'Imposta la batteria di Shizuku su Senza restrizioni';

  @override
  String get shizukuStep5Desc =>
      'Apri info app → Batteria → Senza restrizioni. Se non lo fai, il sistema chiuderà Shizuku in background e dovrai premere Avvia di nuovo.';

  @override
  String get btnShizukuAppInfo => 'Info app Shizuku';

  @override
  String get shizukuStep6DescActive =>
      'Shizuku è attivo. Tocca il pulsante per autorizzare.';

  @override
  String get shizukuStep6DescWaiting =>
      'Disponibile una volta che Shizuku è attivo (passo 4).';

  @override
  String get btnGrantPermission => 'Concedi autorizzazione';

  @override
  String get btnCheckShizuku => 'Fatto · Verifica';

  @override
  String get statusDone => 'fatto';

  @override
  String get statusPending => 'in attesa';

  @override
  String get latestBadge => '· SALVATAGGIO PIÙ RECENTE ·';

  @override
  String saveDateLabel(String season, int year) {
    return '$season · Anno $year';
  }

  @override
  String get petCat => 'Gatto';

  @override
  String get petDog => 'Cane';

  @override
  String get houseBasic => 'Casa base';

  @override
  String get houseKitchen => 'Con cucina';

  @override
  String get houseBedroom => 'Con camera da letto';

  @override
  String get houseCellar => 'Con cantina';

  @override
  String houseLevelN(int level) {
    return 'Lv. $level';
  }

  @override
  String get tooltipLaunchGame => 'Gioca';

  @override
  String get hiwLaunchTitle => 'Avvia il gioco';

  @override
  String get hiwLaunchDesc =>
      'Il pulsante ▶ nella barra superiore di I miei salvataggi apre Stardew Valley direttamente dall’app.';

  @override
  String get hiwLaunchTipWindows =>
      'Su Windows, se il gioco non viene rilevato automaticamente, imposta il percorso dell’eseguibile in Impostazioni → Gioco.';

  @override
  String get hiwLaunchTipAndroid =>
      'Su Android, apre il gioco se è installato.';

  @override
  String get settingsGameSection => 'Gioco';

  @override
  String get settingsGameExePath => 'Eseguibile Stardew Valley';

  @override
  String get settingsGameExeNotFound => 'Non trovato automaticamente';

  @override
  String get settingsGameExeBrowse => 'Sfoglia…';

  @override
  String get settingsGameExeSaved => 'Percorso salvato';

  @override
  String get snackLaunchError => 'Impossibile aprire il gioco';

  @override
  String get makeHostAction => 'DIVENTA OSPITANTE';

  @override
  String get makeHostExperimental => 'SPERIMENTALE';

  @override
  String get makeHostDialogTitle => 'Cambia ospitante';

  @override
  String makeHostDialogIntro(String playerName, String farmName) {
    return '$playerName diventerà l\'ospitante di $farmName.';
  }

  @override
  String get makeHostNewCopyNote =>
      'Viene creato un nuovo salvataggio. Deciderai poi cosa fare con l\'originale.';

  @override
  String makeHostMoveCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other:
          '$count oggetti della fattoria verranno spostati per fare spazio alla casa. Nulla viene eliminato.',
      one:
          '1 oggetto della fattoria verrà spostato per fare spazio alla casa. Nulla viene eliminato.',
    );
    return '$_temp0';
  }

  @override
  String get makeHostHouseWarning =>
      'La casa del nuovo ospitante avrà l\'aspetto della fattoria principale del gioco. L\'aspetto della baita non è supportato senza mod.';

  @override
  String get makeHostConfirmButton => 'Diventa ospitante';

  @override
  String makeHostSuccess(String playerName) {
    return 'Nuovo salvataggio creato: $playerName è ora l\'ospitante.';
  }

  @override
  String get hostSwapErrInvalid =>
      'Questo salvataggio ha una struttura imprevista. Non è stato modificato nulla.';

  @override
  String get hostSwapErrNoSpace =>
      'Nessuno spazio libero in fattoria per riposizionare gli oggetti. Non è stato modificato nulla.';

  @override
  String get hostSwapErrWrite =>
      'Impossibile scrivere il nuovo salvataggio (disco/permessi). Non è stato modificato nulla.';

  @override
  String get hostSwapErrValidation =>
      'La verifica del nuovo salvataggio non è riuscita, quindi è stato scartato. L\'originale è intatto.';
}
