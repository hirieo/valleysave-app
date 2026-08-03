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
  String get updateNeedsPermission =>
      'Attiva \"installa app sconosciute\" per ValleySave e tocca di nuovo Aggiorna';

  @override
  String get disconnectTitle => 'Disconnettere Drive?';

  @override
  String disconnectBody(String email) {
    return 'I tuoi salvataggi su Drive non verranno eliminati. Puoi riconnetterti in qualsiasi momento.';
  }

  @override
  String get disconnectButton => 'Disconnetti Drive';

  @override
  String disconnectButtonEmail(String email) {
    return 'Disconnetti da $email';
  }

  @override
  String get connectedAsPrefix => 'Connesso come';

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
  String get exportAction => 'Esporta';

  @override
  String get exportSuccess => 'Salvataggio esportato.';

  @override
  String exportError(String error) {
    return 'Impossibile esportare il salvataggio: $error';
  }

  @override
  String get importAction => 'Importa salvataggio';

  @override
  String importSuccess(String playerName) {
    return 'Salvataggio di $playerName importato.';
  }

  @override
  String get importErrInvalidZip => 'Questo file non è uno zip valido.';

  @override
  String get importErrUnsafePath =>
      'Questo file ha una struttura non sicura ed è stato rifiutato.';

  @override
  String get importErrTooLarge =>
      'Questo file è troppo grande per essere importato.';

  @override
  String get importErrNotASave =>
      'Questo file non contiene un salvataggio riconoscibile.';

  @override
  String get importErrWrite =>
      'Impossibile scrivere il salvataggio importato (disco/permessi).';

  @override
  String get importErrBackupFailed =>
      'Impossibile creare un backup di sicurezza. Non è stato importato nulla.';

  @override
  String get importConflictTitle => 'Esiste già un salvataggio con questo nome';

  @override
  String get importConflictBody =>
      'L\'importazione sostituirà la copia locale esistente. Non può essere annullata.';

  @override
  String get importConflictConfirm => 'Sovrascrivi';

  @override
  String get shareAction => 'Condividi';

  @override
  String get shareUploadFirstCta => 'Carica prima';

  @override
  String get shareDialogTitle => 'Condividi salvataggio';

  @override
  String get shareEmailPlaceholder => 'nome@esempio.com';

  @override
  String get shareInfoNote =>
      'La condivisione dà accesso in visualizzazione e download. Solo tu puoi modificare o eliminare la tua copia su Drive.';

  @override
  String get shareRoleReader => 'Sola lettura';

  @override
  String get shareRoleWriter => 'Consenti sincronizzazione';

  @override
  String get shareInfoNoteCoop =>
      'Sola lettura permette di vedere e scaricare. Consenti sincronizzazione permette di sovrascrivere la tua copia su Drive — non potranno mai eliminarla.';

  @override
  String get shareConfirmButton => 'Condividi';

  @override
  String shareSuccess(String email) {
    return 'Condiviso con $email.';
  }

  @override
  String get manageAccessTitle => 'Persone con accesso';

  @override
  String get manageAccessEmpty => 'Nessun altro ha ancora accesso.';

  @override
  String get manageAccessRoleLabel => 'Accesso';

  @override
  String get manageAccessRevoke => 'Revoca';

  @override
  String manageAccessRevokeConfirm(String email) {
    return 'Rimuovere l\'accesso a $email? Qualsiasi copia locale già scaricata resta sua.';
  }

  @override
  String get driveOnlyControlsYourCopy =>
      'La condivisione controlla la tua copia su Drive. Se qualcuno la scarica, quella copia è sua.';

  @override
  String get driveOnlyControlsYourCopyCoop =>
      'La sincronizzazione controlla la tua copia su Drive — può essere sovrascritta, ma mai eliminata, da chi autorizzi.';

  @override
  String get sharedWithMeTitle => 'Condivisi con me';

  @override
  String get sharedWithMeEmpty => 'Ancora nulla condiviso con te.';

  @override
  String get sharedWithMeAdd => 'Aggiungi salvataggio condiviso';

  @override
  String sharedWithMeOwnedBy(String email) {
    return 'Condiviso da $email';
  }

  @override
  String get sharedWithMeRoleSync => 'Sincronizza';

  @override
  String get sharedWithMeRoleRead => 'Sola lettura';

  @override
  String get sharedWithMeSync => 'Sincronizza';

  @override
  String get sharedWithMeDownload => 'Scarica';

  @override
  String get sharedWithMeRemove => 'Disconnetti';

  @override
  String sharedWithMeRemoveConfirm(String email) {
    return 'Non sincronizzerai più con il Drive di $email, ma puoi aggiungerlo di nuovo quando vuoi — resta condiviso. La tua copia locale rimane un normale salvataggio coop.';
  }

  @override
  String sharedLeaveConfirm(Object email) {
    return 'Perderai davvero l\'accesso a questo salvataggio. Non potrai aggiungerlo di nuovo a meno che $email non lo condivida di nuovo con te. La tua copia locale rimane un normale salvataggio coop.';
  }

  @override
  String get sharedManageButton => 'Gestisci';

  @override
  String get sharedManageDialogTitle => 'Gestisci condivisioni';

  @override
  String get sharedManageDialogHint =>
      'Qui puoi lasciare davvero un salvataggio condiviso.';

  @override
  String get sharedLeaveButton => 'Lascia la condivisione';

  @override
  String sharedLeaveSuccess(Object email) {
    return 'Hai lasciato la condivisione di $email.';
  }

  @override
  String sharedWithMeSyncConfirm(String email) {
    return 'Sovrascrivere la copia di $email su Drive con il tuo salvataggio locale?';
  }

  @override
  String sharedAccessReadOnly(String email) {
    return '$email ti ha impostato in sola lettura — puoi vedere e scaricare, ma non sincronizzare verso il suo Drive.';
  }

  @override
  String get sharedWithMeRevoked => 'Non hai più accesso';

  @override
  String sharedRevokedDialogBody(String email, String farmName) {
    return '$email ha smesso di condividere $farmName con te. La tua copia locale e quella sul tuo Drive restano invariate, ora in I miei salvataggi.';
  }

  @override
  String get sharedRevokedAccept => 'Accetta';

  @override
  String get sharedSelfCleanupTitle => 'Registro corretto';

  @override
  String sharedSelfCleanupBody(String farmName) {
    return '$farmName è apparso come condiviso con te per errore — in realtà è tuo. È stato corretto, ora si trova in I miei salvataggi.';
  }

  @override
  String get sharedWithMeUploadOwn => 'Carica sul mio Drive';

  @override
  String get sharedDownloadOwn => 'Scarica dal mio Drive';

  @override
  String get sharedStatusOwnDriveAhead => 'Il tuo Drive è avanti — scaricalo';

  @override
  String get sharedSyncBoth => 'Carica su entrambi i Drive';

  @override
  String get sharedSideMyDrive => 'IL MIO DRIVE';

  @override
  String sharedSideOwnerDrive(String email) {
    return 'DRIVE DI $email';
  }

  @override
  String sharedSideDate(int day, int year) {
    return 'Giorno $day · Anno $year';
  }

  @override
  String get sharedStatusSyncedNoOwnDrive =>
      'Sincronizzato con il proprietario · nessuna copia sul tuo Drive';

  @override
  String get sharedStatusAheadNoOwnDrive =>
      'Sei avanti · nessuna copia sul tuo Drive';

  @override
  String sharedStatusOwnerAheadNoOwnDrive(String email) {
    return '$email è avanti · nessuna copia sul tuo Drive';
  }

  @override
  String get sharedStatusAllSynced =>
      'Sincronizzato (locale + entrambi i Drive)';

  @override
  String get sharedStatusAheadBoth => 'Sei avanti su entrambi i Drive';

  @override
  String get sharedStatusMixed => 'Non sincronizzato — controlla ogni Drive';

  @override
  String get sharedStatusFullySynced => 'Completamente sincronizzato';

  @override
  String get sharedStatusSyncedOwn => 'Il mio Drive sincronizzato';

  @override
  String get sharedStatusSyncedOwner => 'Drive condiviso sincronizzato';

  @override
  String get sharedStatusNotCloud => 'Solo su questo dispositivo';

  @override
  String sharedStatusOwnerAhead(Object email) {
    return 'Il Drive di $email è avanti';
  }

  @override
  String get sharedStatusBothAhead => 'Entrambi i Drive sono avanti';

  @override
  String get sharedStatusLocalMissing => 'Non presente su questo dispositivo';

  @override
  String sharedStatusOwnerUnavailable(Object email) {
    return 'Impossibile verificare il Drive di $email';
  }

  @override
  String get sharedStatusWorking => 'Sincronizzazione…';

  @override
  String get sharedSideUnavailable => 'Impossibile verificare';

  @override
  String get sharedSyncChooseTitle => 'Dove vuoi sincronizzare?';

  @override
  String get sharedSyncChooseBody =>
      'Scegli quali copie nel cloud vuoi aggiornare con il salvataggio di questo dispositivo.';

  @override
  String get sharedSyncTargetOwn => 'Il mio Drive';

  @override
  String sharedSyncTargetOwner(Object email) {
    return 'Drive di $email';
  }

  @override
  String get sharedSyncTargetBoth => 'Entrambi i Drive';

  @override
  String get sharedDownloadChooseTitle => 'Quale copia vuoi scaricare?';

  @override
  String get sharedDownloadChooseBody =>
      'Più di una copia è avanti. Scegli quale vuoi portare su questo dispositivo.';

  @override
  String get sharedDownloadSourceOwn => 'Dal mio Drive';

  @override
  String sharedDownloadSourceOwner(Object email) {
    return 'Dal Drive di $email';
  }

  @override
  String get sharedWithMePickerTitle => 'Aggiungi salvataggio condiviso';

  @override
  String get sharedPickerEmptyHint =>
      'Qui appare ciò che un altro giocatore condivide con te da Drive.';

  @override
  String get sharedPickerAddButton => 'Aggiungi';

  @override
  String get sharedOriginBadge => 'Condiviso';

  @override
  String sharedOriginFrom(String email) {
    return 'da $email';
  }

  @override
  String get swapBackupDialogTitle => 'Backup creato';

  @override
  String get swapBackupDialogBody =>
      'La versione precedente è stata salvata come zip. Cosa vuoi farne?';

  @override
  String get swapBackupUpload => 'Carica su Drive';

  @override
  String get swapBackupLocalOnly => 'Mantieni su questo dispositivo';

  @override
  String get swapBackupDeleteNow => 'Elimina ora';

  @override
  String get swapBackupUploadOk => 'Backup caricato su Drive.';

  @override
  String swapBackupUploadErr(String error) {
    return 'Impossibile caricare il backup: $error';
  }

  @override
  String get swapBackupLocalOnlySnack =>
      'Backup salvato su questo dispositivo.';

  @override
  String get backupsAction => 'Backup';

  @override
  String backupsScreenTitle(String farmName) {
    return 'Backup di $farmName';
  }

  @override
  String get backupsEmpty => 'Ancora nessun backup.';

  @override
  String get backupsRestore => 'Ripristina';

  @override
  String get backupsRestoreConfirmTitle => 'Ripristinare questo backup?';

  @override
  String get backupsRestoreConfirmBody =>
      'Questo sovrascrive il tuo salvataggio attuale con questa versione precedente. Non può essere annullato.';

  @override
  String get backupsDelete => 'Elimina';

  @override
  String get backupsDeleteConfirmTitle => 'Eliminare questo backup?';

  @override
  String get backupsDeleteConfirmBody =>
      'Verrà eliminato in tutti i luoghi in cui esiste (questo dispositivo e Drive, se caricato). Non può essere annullato.';

  @override
  String get backupsRestoreOk => 'Backup ripristinato.';

  @override
  String get backupsRestoreManualTitle => 'Ripristina manualmente';

  @override
  String get backupsRestoreManualBody =>
      'In modalità Ponte, ValleySave non può scrivere automaticamente nella cartella del gioco. Estrai tu stesso lo .zip di questo backup nella cartella Saves di Stardew Valley, oppure passa alla modalità Root/Shizuku in Impostazioni per ripristinare automaticamente.';

  @override
  String backupsRestoreErr(String error) {
    return 'Impossibile ripristinare il backup: $error';
  }

  @override
  String backupsDeleteErr(String error) {
    return 'Impossibile eliminare il backup: $error';
  }

  @override
  String get backupsCreate => 'Crea backup locale';

  @override
  String get backupsCreateLocalHint =>
      'I backup vengono creati prima su questo dispositivo. Potrai poi caricarli su Drive.';

  @override
  String get backupsCreateOk => 'Backup creato.';

  @override
  String backupsCreateErr(String error) {
    return 'Impossibile creare il backup: $error';
  }

  @override
  String get backupsDownload => 'Scarica';

  @override
  String get backupsDownloadOk => 'Backup scaricato su questo dispositivo.';

  @override
  String backupsDownloadErr(String error) {
    return 'Impossibile scaricare il backup: $error';
  }

  @override
  String get backupsCopyOwn => 'Copia sul mio Drive';

  @override
  String get backupsUploadOwn => 'Sul mio Drive';

  @override
  String get backupsUploadShared => 'Sul Drive condiviso';

  @override
  String get backupsUploadOk => 'Backup caricato.';

  @override
  String backupsUploadErr(String error) {
    return 'Impossibile caricare il backup: $error';
  }

  @override
  String get backupsLocationLocal => 'Questo dispositivo';

  @override
  String get backupsLocationOwnDrive => 'Il mio Drive';

  @override
  String get backupsLocationSharedDrive => 'Drive condiviso';

  @override
  String get backupsDeleteChooseBody =>
      'Scegli esattamente dove eliminarlo. Vengono mostrati solo i luoghi in cui esiste questo backup.';

  @override
  String get backupsDeleteLocalOnly => 'Solo da questo dispositivo';

  @override
  String get backupsDeleteOwnOnly => 'Solo dal mio Drive';

  @override
  String get backupsDeleteSharedOnly => 'Solo dal Drive condiviso';

  @override
  String get backupsDeleteAll => 'Da tutte le copie';

  @override
  String deleteUnifiedTitle(String farmName) {
    return 'Eliminare $farmName?';
  }

  @override
  String get deleteChooseLocationBody =>
      'Scegli da dove. La copia su questo dispositivo viene eliminata per sempre; quella su Drive va nel Cestino (30 giorni).';

  @override
  String deleteDriveContextTitle(String farmName) {
    return 'Eliminare $farmName da Drive?';
  }

  @override
  String get deleteDriveContextBody =>
      'La copia su Drive andrà nel Cestino, dove potrai recuperarla per 30 giorni.';

  @override
  String get deleteDriveLocalKept =>
      'La copia su questo dispositivo rimarrà invariata.';

  @override
  String deleteLocalContextTitle(String farmName) {
    return 'Eliminare $farmName da questo dispositivo?';
  }

  @override
  String get deleteLocalContextBody =>
      'La copia su questo dispositivo verrà eliminata per sempre.';

  @override
  String deleteLocalDriveCurrent(String date) {
    return 'La tua copia su Drive è aggiornata ($date) e resterà disponibile.';
  }

  @override
  String deleteLocalDriveAhead(String date) {
    return 'La tua copia su Drive è più recente ($date) e resterà disponibile.';
  }

  @override
  String deleteLocalDriveOlder(String driveDate, String localDate) {
    return 'La tua copia su Drive è precedente ($driveDate); questo dispositivo è a $localDate.';
  }

  @override
  String deleteLocalBackupAvailable(int count) {
    return 'Sono disponibili $count backup locali nel caso in cui tu abbia bisogno di una copia precedente.';
  }

  @override
  String get deleteLocalNoRecovery =>
      'Non c\'è una copia su Drive né un backup locale da cui recuperare questo salvataggio.';

  @override
  String get deleteOptionLocalOnly => 'Solo da questo dispositivo';

  @override
  String get deleteOptionDriveOnly => 'Solo da Drive';

  @override
  String get deleteOptionBoth => 'Da entrambe le copie (dispositivo + Drive)';

  @override
  String get viewPlayersHint => 'Vedi giocatori';

  @override
  String snackDeletedBoth(String saveName) {
    return '\"$saveName\" eliminato da questo dispositivo e spostato nel Cestino di Drive.';
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
  String get hiwConnectTitle => 'Connetti il tuo account';

  @override
  String get hiwConnectDesc =>
      'ValleySave usa il tuo account Google per salvare i tuoi salvataggi in una cartella privata di ValleySave nel tuo Drive personale.';

  @override
  String get hiwConnectStepGoogle => 'Account\nGoogle';

  @override
  String get hiwConnectStepDrive => 'Cartella ValleySave\ncreata';

  @override
  String get hiwConnectStepReady => 'Pronto per\nsincronizzare';

  @override
  String get hiwConnectTipOwnership =>
      'Solo tu puoi modificare o eliminare le tue copie su Drive — ValleySave legge e scrive solo all\'interno della propria cartella.';

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
  String get overwriteWhatChanges => 'Cosa cambia';

  @override
  String get overwriteTagOverwritten => 'VERRÀ SOVRASCRITTO';

  @override
  String get overwriteNewCopyTag => 'NUOVO';

  @override
  String overwriteDeltaPhrase(int days, String time) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: '$days giorni e $time',
      one: '1 giorno e $time',
      zero: '$time',
    );
    return '$_temp0';
  }

  @override
  String overwriteVerdictAhead(String delta) {
    return 'Sei avanti di $delta. È sicuro.';
  }

  @override
  String get overwriteVerdictMoneySpent =>
      '💰 Il denaro attuale è diminuito, ma il progresso complessivo avanza — probabilmente lo hai speso per qualcosa. Non è una perdita reale.';

  @override
  String overwriteVerdictNegligible(String delta) {
    return 'Differenza minima ($delta). Va bene una qualsiasi delle due copie.';
  }

  @override
  String overwriteVerdictDanger(String delta, String target) {
    return '⚠️ Stai per perdere $delta di progresso su $target. Controlla prima di continuare.';
  }

  @override
  String get overwriteConfirmTitleUpload => 'Confermi il caricamento?';

  @override
  String get overwriteConfirmTitleDownload => 'Confermi il download?';

  @override
  String overwriteConfirmBody(String delta, String target) {
    return 'Perderai $delta su $target. Questa azione non può essere annullata.';
  }

  @override
  String get overwriteConfirmButtonUpload => 'Conferma caricamento';

  @override
  String get overwriteConfirmButtonDownload => 'Conferma download';

  @override
  String get overwriteDangerButtonUpload => '⚠️ Carica comunque';

  @override
  String get overwriteDangerButtonDownload => '⚠️ Scarica comunque';

  @override
  String overwriteIdenticalSummary(int count, String list) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '✓ $count identici',
      one: '✓ 1 identico',
    );
    return '$_temp0 — $list';
  }

  @override
  String overwriteUploadToOwner(String email) {
    return 'Carica sul Drive di $email';
  }

  @override
  String get overwriteUploadBoth => 'Carica su entrambi i Drive';

  @override
  String get overwriteConfirmTitleBoth => 'Confermi entrambi i caricamenti?';

  @override
  String overwriteConfirmBodyBoth(String delta, String targets) {
    return 'Perderai $delta su $targets. Questa azione non può essere annullata.';
  }

  @override
  String overwriteBothDestinationsLabel(String first, String second) {
    return '$first e $second';
  }

  @override
  String get sharedTargetOwnDrive => 'il tuo Drive';

  @override
  String sharedStatusLocalAhead(String targets) {
    return 'Sei avanti su $targets';
  }

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
  String get snackReplacePrepareFailed =>
      'Impossibile preparare il salvataggio. Non è stato modificato nulla sul disco';

  @override
  String get snackReplaceValidationFailed =>
      'Il salvataggio scaricato sembra non valido o incompleto. Non è stato modificato nulla sul disco';

  @override
  String get snackReplaceBackupFailed =>
      'Impossibile creare un backup di sicurezza. Non è stato modificato nulla sul disco';

  @override
  String get snackReplaceSwapFailed =>
      'Lo scambio non è riuscito, ma il salvataggio originale è stato ripristinato dal backup';

  @override
  String get snackReplaceBusy =>
      'C\'è già un\'operazione in corso per questo salvataggio';

  @override
  String get snackUploadIncomplete =>
      'Il salvataggio locale è incompleto o danneggiato. Non è stato caricato nulla';

  @override
  String get snackDownloadIncomplete =>
      'Impossibile scaricare: manca contenuto su Drive';

  @override
  String get cardIncomplete => 'Incompleto su Drive';

  @override
  String get autoRefreshTitle => 'Aggiornamento automatico';

  @override
  String get autoRefreshSubtitle => 'Controlla le modifiche su Drive ogni 30 s';

  @override
  String autoSyncSnack(String farmName) {
    return '$farmName sincronizzato automaticamente';
  }

  @override
  String get autoSyncTooltipOn =>
      'Sincronizzazione automatica attiva — si sincronizza da sola quando è sicuro';

  @override
  String get autoSyncTooltipOff =>
      'Sincronizzazione automatica disattivata — tocca per attivarla';

  @override
  String get autoSyncExplainTitle => 'Sincronizzazione automatica';

  @override
  String autoSyncExplainBody(String farmName) {
    return 'D\'ora in poi, $farmName verrà caricato o scaricato da solo quando è sicuro, senza chiederti conferma.';
  }

  @override
  String get autoSyncExplainSafe =>
      'Agisce solo quando sei chiaramente avanti e non si perde nulla.';

  @override
  String get autoSyncExplainDanger =>
      'Se ci fosse il rischio di perdere progressi, non agisce mai da sola: deciderai sempre tu con la solita finestra di dialogo.';

  @override
  String get autoSyncExplainMissing =>
      'Se manca una delle due copie, non la crea da sola: la prima volta decidi tu se caricare o scaricare.';

  @override
  String get autoSyncExplainDontShowAgain => 'Non mostrare più questo avviso';

  @override
  String get autoSyncExplainConfirm => 'Capito, attiva';

  @override
  String get hiwAutoSyncTitle => 'Sincronizzarsi da solo';

  @override
  String get hiwAutoSyncDesc =>
      'Ogni salvataggio ha un chip AUTO sulla propria scheda. Attivandolo, quel salvataggio si carica o si scarica da solo quando l\'app rileva una modifica — senza che tu debba entrare a confermarlo.';

  @override
  String get hiwAutoSyncTipSafe =>
      'Si sincronizza da sola solo quando sei chiaramente avanti e non si perde nulla.';

  @override
  String get hiwAutoSyncTipDanger =>
      'Se ci fosse il rischio di perdere progressi, non lo fa mai da solo: continua a chiedertelo con il solito confronto.';

  @override
  String get hiwAutoSyncTipPerSave =>
      'Si attiva salvataggio per salvataggio, non tutto insieme: puoi averlo sul tuo e non su uno condiviso.';

  @override
  String get hiwAutoSyncTipMissing =>
      'Mantiene sincronizzate solo due copie già esistenti. Se ne manca una, il primo caricamento o download lo fai tu.';

  @override
  String get hiwAutoSyncTipRefresh =>
      'In Impostazioni puoi disattivare completamente il controllo automatico delle modifiche.';

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
  String get hiwCompatIncomplete =>
      'Se vedi \"Incompleto su Drive\" su un salvataggio, gli manca un file necessario nel cloud — non può essere scaricato finché non viene ricaricato correttamente da un altro dispositivo.';

  @override
  String get hiwShareTitle => 'Condividi con altri';

  @override
  String get hiwShareDesc =>
      'Condividi un salvataggio con un altro giocatore via email. Lo vedrà in Condivisi con me sul proprio dispositivo.';

  @override
  String get hiwShareStepYourSave => 'Il tuo\nsalvataggio';

  @override
  String get hiwShareStepShare => 'Condividi via\nemail';

  @override
  String get hiwShareStepFriend => 'Condivisi\ncon me';

  @override
  String get hiwShareTipRoles =>
      'Due ruoli: Sola lettura permette di vedere e scaricare. Consenti sincronizzazione permette di sovrascrivere la tua copia su Drive. In nessun caso possono eliminarla — solo tu, il proprietario, puoi eliminare il tuo salvataggio.';

  @override
  String get hiwShareTipDisconnect =>
      'Disconnettersi interrompe la sincronizzazione solo dal loro lato — la condivisione resta attiva finché non la lasci davvero da Gestisci condivisioni.';

  @override
  String get hiwHostSwapTitle => 'Cambio di ospitante';

  @override
  String get hiwHostSwapDesc =>
      'Cambia quale Farmhand è l\'ospitante del salvataggio, sostituendolo sul posto — stesso slot di salvataggio, stessi permessi di condivisione.';

  @override
  String get hiwHostSwapStepPick => 'Scegli\nFarmhand';

  @override
  String get hiwHostSwapStepConfirm => 'Conferma';

  @override
  String get hiwHostSwapStepDone => 'Nuovo salvataggio\ncreato';

  @override
  String get hiwHostSwapTipMove =>
      'Alcuni oggetti della fattoria possono essere riposizionati per fare spazio alla casa — nulla viene eliminato.';

  @override
  String get hiwHostSwapTipHouse =>
      'La casa del nuovo ospitante apparirà come la grande casa predefinita del gioco — l\'estetica della baita non è supportata senza mod.';

  @override
  String get hiwBackupsTitle => 'Backup';

  @override
  String get hiwBackupsDesc =>
      'Un backup è un\'istantanea di un salvataggio che puoi ripristinare in seguito. Crealo manualmente quando vuoi, oppure lascia che ValleySave ne crei uno automaticamente prima di sovrascrivere un salvataggio (durante download, importazione, ripristino o cambio di ospitante).';

  @override
  String get hiwBackupsStepSave => 'Il tuo\nsalvataggio';

  @override
  String get hiwBackupsStepSnapshot => 'Backup\ncreato';

  @override
  String get hiwBackupsStepStore => 'Locale e/o\nDrive';

  @override
  String get hiwBackupsTipRestore =>
      'Ripristinare sovrascrive il tuo salvataggio attuale con quella versione precedente — non può essere annullato.';

  @override
  String get hiwBackupsTipDelete =>
      'Eliminare un backup lo cancella in tutti i luoghi in cui esiste (questo dispositivo e Drive, se caricato) — non può essere annullato.';

  @override
  String get hiwBackupsTipExport =>
      'Puoi anche Esportare un salvataggio come zip per conservarlo dove vuoi, e Importarlo di nuovo in seguito — un\'alternativa manuale e portatile ai backup integrati.';

  @override
  String get hiwBackupsTipRetention =>
      'ValleySave conserva i 5 backup automatici più recenti di ogni salvataggio; quelli che crei manualmente non vengono mai eliminati da soli.';

  @override
  String get hiwBackupsTipRestoreBridge =>
      'In modalità Ponte (Android senza root/Shizuku), ripristinare un backup ti chiede di estrarre lo .zip a mano nella cartella di Stardew — proprio come per il download.';

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
  String get hiwLaunchTipLinux =>
      'Su Linux, se il gioco non viene rilevato automaticamente, imposta il percorso dell\'eseguibile in Impostazioni → Gioco.';

  @override
  String get hiwSaveLocationsTitle => 'Dove vivono i tuoi salvataggi';

  @override
  String get hiwSaveLocationsDesc =>
      'ValleySave legge e scrive direttamente nella cartella dei salvataggi del gioco su ogni piattaforma.';

  @override
  String get hiwSaveLocationWindows =>
      'Windows: %AppData%\\StardewValley\\Saves';

  @override
  String get hiwSaveLocationAndroid =>
      'Android: cartella protetta, si accede tramite Shizuku o il Ponte';

  @override
  String get hiwSaveLocationLinux =>
      'Linux: ~/.config/StardewValley/Saves (oppure ~/snap/steam/common/.config/StardewValley/Saves se Steam è installato tramite snap)';

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

  @override
  String get makeHostDeleteOriginalTitle =>
      'Eliminare il salvataggio originale da questo dispositivo?';

  @override
  String get makeHostDeleteOriginalBody =>
      'Il nuovo salvataggio è pronto. Fai prima il backup dell\'originale sul tuo Drive (potrai riscaricarlo in seguito) o elimina solo la copia locale.';

  @override
  String get makeHostDeleteOriginalNoBackupBody =>
      'Nessuna connessione a Drive: non resterà alcun backup. Verrà eliminata solo la copia locale su questo dispositivo.';

  @override
  String get makeHostDeleteOriginalUploadBody =>
      'Il salvataggio originale verrà prima caricato sul tuo Drive come backup, poi la copia locale su questo dispositivo verrà eliminata.';

  @override
  String get makeHostDeleteWithoutUpload => 'Elimina senza caricare';

  @override
  String get makeHostUploadAndDelete => 'Carica ed elimina';

  @override
  String get updateCheckFailed => 'Controllo non riuscito';

  @override
  String get updateCheckFailedRetry => 'Tocca per riprovare';
}
