// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Basque (`eu`).
class AppLocalizationsEu extends AppLocalizations {
  AppLocalizationsEu([String locale = 'eu']) : super(locale);

  @override
  String get appTitle => 'ValleySave';

  @override
  String get welcomeTitle => 'Inoiz ez gal zure baserrira, jokoan hartu.';

  @override
  String get connectGoogleDrive => 'Google Drive konektatu';

  @override
  String get connecting => 'Konektatzen…';

  @override
  String get mySaves => 'Nire gordetzeak';

  @override
  String get howItWorks => 'Nola darabiltza';

  @override
  String get settings => 'Ezarpenak';

  @override
  String get aboutSection => 'Honi buruz';

  @override
  String get openSource => 'Kodearen availability';

  @override
  String get nonCommercial => 'Ez-komertzial';

  @override
  String get freeForever => 'Aske betirako';

  @override
  String get privacyTitle => 'Pribatutasun eta datuen erabilpena';

  @override
  String get privacyDescription =>
      'ValleySave Stardew Valley gordetzeak sinkronizatzeko aplikazioa da zure Google Drive kontuarekin.';

  @override
  String get whatDataTitle => 'Zer datu erabiltzen ditu';

  @override
  String get whatDataDesc =>
      'ValleySave Stardew Valley gordetzeak bakarrik atzitzen ditu kopiak egiteko, sinkronizatzeko edo leheneratzeko.';

  @override
  String get googleDriveTitle => 'Google Drive';

  @override
  String get googleDriveDesc =>
      'Zure gordetzeek zure Google Drive kontuan igotzen dira. ValleySave ez du bere zerbitzaririk erabiltzen zure jokoak biltegiratzeko.';

  @override
  String get androidPermissionsTitle => 'Android-eko baimenak';

  @override
  String get androidPermissionsDesc =>
      'ValleySave gordetze fitxategiak atzitzeko biltegi-baimenak edo Shizuku bezalako tresneria beharko litezke.';

  @override
  String get adsTitle => 'Iragarkiak';

  @override
  String get adsDesc =>
      'ValleySave Google AdMob-en bidezko iragarkiak erakutsi ditzake.';

  @override
  String get responsibilityTitle => 'Erantzukizuna';

  @override
  String get responsibilityDesc =>
      'Zure gordetze fitxategiak zure erantzukizuna dira.';

  @override
  String get deleteDataTitle => 'Datua ezabatu';

  @override
  String get deleteDataDesc =>
      'Zure sinkronizaturiko kopiak ezabatu ditzakezu Google Drive-tik ValleySave karpeta eskuz ezabatuz.';

  @override
  String get sourceCodeTitle => 'Kodea eta kontaktua';

  @override
  String get sourceCodeDesc =>
      'ValleySave Polyform Noncommercial lizentzapean kode disponiblearekin dagoen proiektua da.';

  @override
  String get upToDate => 'Eguneratuta';

  @override
  String get checkingUpdates => 'Egiaztatzen…';

  @override
  String get updateAvailable => 'Eguneratzea erabilgarri';

  @override
  String get application => 'Aplikazioa';

  @override
  String version(Object version) {
    return '$version bertsioa';
  }

  @override
  String get checkForUpdates => 'Eguneraketaak egiaztatu';

  @override
  String get shizukuRequired => 'Shizuku beharrezkoa';

  @override
  String get shizukuGuide => 'Shizuku Konfigurazio Gidaburuak';

  @override
  String get activateShizuku =>
      'Shizuku gaitu gordetze jokoen artikuluan idazteko.';

  @override
  String deleteSaveTitle(Object saveName) {
    return '$saveName ezabatu';
  }

  @override
  String get deleteSaveMessage =>
      'Honek gailutik gordetze hau kendu egingo du. Jarraitu nahi duzu?';

  @override
  String get deleteFromDrive => 'Drive-tik ezabatu';

  @override
  String confirmDelete(Object saveName) {
    return 'ValleySave $saveName Google Drive Zabor basurantz mugituko da.';
  }

  @override
  String deleteFromDeviceMessage(Object saveName) {
    return '$saveName gailutik betirako ezabatuko da.';
  }

  @override
  String restoreSaveTitle(Object saveName) {
    return '$saveName leheneratu';
  }

  @override
  String restoreSaveMessage(Object saveName) {
    return '$saveName gailuetara deskargatu?';
  }

  @override
  String get restore => 'Leheneratu';

  @override
  String get cancel => 'Utzi';

  @override
  String get error => 'Akatsa';

  @override
  String get success => 'Arrakasta';

  @override
  String get loading => 'Kargatzen…';

  @override
  String get disconnect => 'Deskonektatu';

  @override
  String get ok => 'OK';

  @override
  String get yes => 'Bai';

  @override
  String get no => 'Ez';

  @override
  String get welcomeHeroPre => 'Inoiz ez gal\nzure ';

  @override
  String get welcomeHeroAccent => 'baserrira,';

  @override
  String get welcomeHeroPost => '\njokoan hartu.';

  @override
  String get welcomeSubtitle =>
      'Sinkronizatu Stardew Valley gordetzeeak zure gailu guztietan. Zure datuak zure Google Drive-ean bizi dira — ez zerbitzariak, ez harpidetzak, zure kontrolpean.';

  @override
  String get welcomeDriveConnected => 'Drive konektatuta';

  @override
  String get welcomeFooterTagline => '· Ez-komertzial · Aske betirako ·';

  @override
  String updateVersionAvailable(String version) {
    return 'v$version erabilgarri';
  }

  @override
  String get sectionMode => 'Modua';

  @override
  String get sectionSeason => 'Denboraldi';

  @override
  String get sectionLanguage => 'Hizkuntza';

  @override
  String get modeAutoTitle => 'Automatikoa';

  @override
  String get modeAutoDesc =>
      'Zure aktiboen gordetzeari jarraikitzen zaio eta, gordetzerik ez badago, zure errealeko kokalekuari.';

  @override
  String get modeSavesTitle => 'Gordetzearen arabera';

  @override
  String get modeSavesDesc =>
      'Beti zure azkeneko gordetzearen denboraldia erabiltzen du.';

  @override
  String get modeGeoTitle => 'Kokalekuaren arabera';

  @override
  String get modeGeoDesc =>
      'Beti zure kokalekuaren errealeko denboraldia erabiltzen du.';

  @override
  String get modeFixedTitle => 'Finkatutako denboraldi';

  @override
  String get modeFixedDesc => 'Beti denboraldi berbera erakusten du.';

  @override
  String get modeRandomTitle => 'Ausazkoa';

  @override
  String get modeRandomDesc =>
      'Aplikazioa irekitzen duzunean denboraldi desberdina aukeratzen du.';

  @override
  String get seasonInitial => 'Hasierakoa';

  @override
  String get seasonSpring => 'Udaberria';

  @override
  String get seasonSummer => 'Uda';

  @override
  String get seasonFall => 'Urtaroa';

  @override
  String get seasonWinter => 'Negua';

  @override
  String get autoPriorityTitle => 'Lehentasunaren ordena';

  @override
  String get autoStep1Title => 'Lehen itzulera';

  @override
  String get autoStep1Desc => 'Hasierako egoera erakusten du.';

  @override
  String get autoStep2Title => 'Gordetze aktiboa';

  @override
  String get autoStep2Desc =>
      'Zure azkeneko sinkronizaturiko gordetzearen denboraldia erabiltzen du.';

  @override
  String get autoStep3Title => 'Kokalekua';

  @override
  String get autoStep3Desc =>
      'Zure hemisferioa eta zure eskualdeko errealeko denboraldia detektatzen du.';

  @override
  String get autoStep4Title => 'Lehenetsitakoa';

  @override
  String get autoStep4Desc => 'Hasierakoa (gabia moduan) daturik ez badago.';

  @override
  String get versionInstalled => 'Instalaturiko bertsioa';

  @override
  String get updateNeverChecked => 'Inoiz ez egiaztatuta';

  @override
  String get updateCheckedNow => 'Besterik ez egiaztatuta';

  @override
  String get updateOutdatedDownload => 'Ez dago eguneraturik · Deskargatu';

  @override
  String get updateDownloading => 'Eguneratzearen deskarga egiten…';

  @override
  String get updateError => 'Akatsa — sakatu berriz saiatzen';

  @override
  String get updateNeedsPermission =>
      'Gaitu \"ezezaguneko aplikazioak instalatzea\" ValleySaverentzat eta sakatu Eguneratu berriro';

  @override
  String get disconnectTitle => 'Drive deskonektatu?';

  @override
  String disconnectBody(String email) {
    return 'Drive-eko zure gordetzeek ez dira ezabatuko. Noiznahi berkonektatu zaitezke.';
  }

  @override
  String get disconnectButton => 'Drive deskonektatu';

  @override
  String disconnectButtonEmail(String email) {
    return 'Disconnect from $email';
  }

  @override
  String get connectedAsPrefix => 'Connected as';

  @override
  String get languageTileLabel => 'Hizkuntza';

  @override
  String get languageDialogTitle => 'Aplikazioen hizkuntza';

  @override
  String get searchHint => 'Bilatu…';

  @override
  String get languageAuto => 'Sistemaren hizkuntza';

  @override
  String get languageAutoDesc => 'Zure sistemaren hizkuntza erabiltzen du';

  @override
  String get privacyPolicyTitle => 'Pribatutasun politika';

  @override
  String get privacyBeforeStartTitle => 'Hastea aurretik';

  @override
  String get privacyLastUpdated => 'Azkena eguneratuta: 2026ko ekaina';

  @override
  String get privacyAccept => 'Ulertu, jarraitu';

  @override
  String get cardSynced => 'Sinkronizatuta';

  @override
  String get cardLocalAhead => 'Lokal aurretik';

  @override
  String get cardDriveAhead => 'Drive aurretik';

  @override
  String get cardLocalOnly => 'Lokal bakarrik';

  @override
  String get cardDriveOnly => 'Drive bakarrik';

  @override
  String get cardTimeNow => 'orain';

  @override
  String cardTimeMinutesAgo(int minutes) {
    return '$minutes min atzo';
  }

  @override
  String cardTimeHoursAgo(int hours) {
    return '${hours}h atzo';
  }

  @override
  String cardTimeDaysAgo(int days) {
    return '${days}e atzo';
  }

  @override
  String cardTimeMonthsAgo(int months) {
    return '${months}hil atzo';
  }

  @override
  String get cardDetailLocalTitle => 'Gailu honetan';

  @override
  String get cardDetailRemoteTitle => 'Drive-ean';

  @override
  String get cardDetailUpload => 'Drive-ra igo';

  @override
  String get cardDetailDownload => 'Gordetze deskargatu';

  @override
  String get cardDetailDeleteLabel => 'Ezabatu';

  @override
  String get cardDetailDeleteLocal => 'Gailu honetatik ezabatu';

  @override
  String get cardDetailDeleteRemote => 'Drive-tik ezabatu';

  @override
  String get cardCloseBarrier => 'Itxi';

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
  String get importErrBackupFailed =>
      'Couldn\'t create a safety backup. Nothing was imported.';

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
  String sharedAccessReadOnly(String email) {
    return '$email set your access to read-only — you can view and download, but not sync to their Drive.';
  }

  @override
  String get sharedWithMeRevoked => 'You no longer have access';

  @override
  String sharedRevokedDialogBody(String email, String farmName) {
    return '$email stopped sharing $farmName with you. Your local copy and the one on your Drive stay as they are, now under My saves.';
  }

  @override
  String get sharedRevokedAccept => 'Accept';

  @override
  String get sharedSelfCleanupTitle => 'Record fixed';

  @override
  String sharedSelfCleanupBody(String farmName) {
    return '$farmName showed up as shared with you by mistake — it\'s actually yours. It\'s been fixed, now it\'s under My saves.';
  }

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
  String get backupsRestoreManualTitle => 'Restore manually';

  @override
  String get backupsRestoreManualBody =>
      'In bridge mode, ValleySave can\'t write to the game folder automatically. Extract this backup\'s .zip into Stardew Valley\'s Saves folder yourself, or switch to Root/Shizuku mode in Settings for automatic restore.';

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
    return '$day eguna · $year urtea';
  }

  @override
  String statDayOnly(int day) {
    return '$day eguna';
  }

  @override
  String get statPlaytime => 'Joko-denbora';

  @override
  String get statMoney => 'Txanponak';

  @override
  String get statTotal => 'Guztira';

  @override
  String get statMineUnexplored => 'Arakatu gabea';

  @override
  String get statMine => 'Meatzea';

  @override
  String get statMineLvl => 'Meatzea · Lv';

  @override
  String get skillFarming => 'Laborantzak';

  @override
  String get skillForaging => 'Bilduma';

  @override
  String get skillMining => 'Meatzea';

  @override
  String get skillFishing => 'Arrantzak';

  @override
  String get skillCombat => 'Borroka';

  @override
  String get cardLocalPresence => 'Gailu honetan';

  @override
  String get cardRemotePresence => 'Drive-ean';

  @override
  String get cardNotPresent => 'Hemen ez';

  @override
  String get cardActionSynced => 'Sinkronizatuta';

  @override
  String get cardActionUpload => 'Igo';

  @override
  String get cardActionDownload => 'Deskargatu';

  @override
  String get pillMonsters => 'bestiak';

  @override
  String get pillFriends => 'lagunak';

  @override
  String get pillFaints => 'hautsi';

  @override
  String get pillSleeps => 'Loari';

  @override
  String get hiwTitle => 'Nola darabiltza';

  @override
  String get hiwConnectTitle => 'Connect your account';

  @override
  String get hiwConnectDesc =>
      'ValleySave uses your Google account to store your saves in a private ValleySave folder on your own Drive.';

  @override
  String get hiwConnectStepGoogle => 'Google\naccount';

  @override
  String get hiwConnectStepDrive => 'ValleySave\nfolder created';

  @override
  String get hiwConnectStepReady => 'Ready to\nsync';

  @override
  String get hiwConnectTipOwnership =>
      'Only you can edit or delete your copies on Drive — ValleySave only reads and writes inside its own folder.';

  @override
  String get hiwSyncTitle => 'Nola dabil sinkronizatzea';

  @override
  String get hiwSyncIntro =>
      'ValleySave zure Google Drive erabiltzen du gordetzeeak gailuen artean mugitzeko. Zerbitzari bitartekaririk ez: fitxategiak zureak dira.';

  @override
  String get hiwSyncDevice => 'Zure\ngailua';

  @override
  String get hiwSyncCloud => 'Google\nDrive';

  @override
  String get hiwSyncOtherDevice => 'Beste\ngailua';

  @override
  String get hiwUploadTitle => 'Gordetze igo';

  @override
  String get hiwUploadDesc =>
      'Igotzen duzunean, ValleySave gordetze fitxategi biak (SaveGameInfo + farmak fitxategia) zure ValleySave/ karpetan igo egiten du Drive-an.';

  @override
  String get hiwDownloadTitle => 'Gordetze deskargatu';

  @override
  String get hiwDownloadDesc =>
      'Deskargatzen duzunean, ValleySave fitxategiak Drive-etik ekartzen ditu eta zuzenean jokoen karpetan jartzen ditu.';

  @override
  String get hiwCompareTitle => 'Zer ditu konparatu?';

  @override
  String get hiwCompareIntro =>
      'Zein bertsioa aurretik dagoen jakin ahal izateko, ValleySave joko-denbora guztira erabiltzen du — bakarrik handitu daitekeen datua.';

  @override
  String get hiwCompareNote =>
      'Aurretik egiaztatzen duzu ere ikus al duzu, eta erabaki dezakezu:';

  @override
  String get hiwCompareMoney => 'Unean dauden dirua eta guztira irabazita';

  @override
  String get hiwCompareMine => 'Meatzeen maila';

  @override
  String get hiwCompareSkills =>
      'Trebetasunak (laborantzak, meatzea, borroka…)';

  @override
  String get hiwCompareRelations => 'Lagunak, bestiak hil eta hautsi';

  @override
  String get hiwCompareStamina => 'Energia eta osasuna';

  @override
  String get hiwCompareNotShown =>
      'Hauek ez dira erakusten — nozko norutz aldatzen dira eta ez dute adierazten zein gordetze aurretik dagoen.';

  @override
  String get hiwCompareNotShownExamples =>
      'Basoaren eta animalien egoera, inbentarioa eta objektuak, banakako harremanak';

  @override
  String get hiwCompareWarning =>
      'Ez dira erakusten — nozko norutz aldatzen dira eta ez dute adierazten zein gordetze aurretik dagoen.';

  @override
  String get hiwConflictTitle => 'Sinkronizatu gabe jokatzen baduzu';

  @override
  String get hiwConflictDesc =>
      'Mugikorrean eta PCan sinkronizatu gabe aurrera daitezke saioek, bi gordetze bertsio lortzen dituzu.';

  @override
  String get hiwConflictNoMerge =>
      'Ezin daitezke batu. ValleySave bertsioak erakusten ditu beti zuk zein aurten dezakezu.';

  @override
  String get hiwConflictMobile => 'Mugikorra';

  @override
  String get hiwConflictVersionA => 'A bertsioa';

  @override
  String get hiwConflictPC => 'PC';

  @override
  String get hiwConflictVersionB => 'B bertsioa';

  @override
  String get hiwDeleteTitle => 'Gordetze ezabatzen bada';

  @override
  String get hiwDeleteDesc =>
      'Drive-etik gordetze ezabatzen duzunean, ez da berehala desagertzen: Google Drive Zaborra basurantz doa.';

  @override
  String get hiwCompatTitle => 'Plataformaren bateragarritasuna';

  @override
  String get hiwCompatAndroidAccess => 'ANDROID-EN SARBIDEA';

  @override
  String get hiwShizukuTitle => 'Shizuku-rekin';

  @override
  String get hiwShizukuSubtitle =>
      'Konfiguratu behin. Ondoren, ValleySave berez sinkronizatzen du, inoiz ez hori apurtu gabe.';

  @override
  String get hiwShizukuBadge => 'AUTOMATIKOA · GOMENDATUA';

  @override
  String get hiwShizukuDone =>
      '✓ Egina. Ordutik aurrera, gordetzeeak deskargatzea eta igotzeya zuzenean egiten da, ordenagailuaren bezala.';

  @override
  String get hiwShizukuNote =>
      'Parea lehen aldia bakarrik. Shizuku bertsio berriak berez berriro aktibatzen dira telefonoa berrabiartu ondoren.';

  @override
  String get hiwBridgeTitle => 'Zubi eskuzkoa';

  @override
  String get hiwBridgeSubtitle =>
      'Android 11 eta 12-an bakarrik darabila. Ezer extra instalatu ez behar; gordetze kopia eskuz biltegian egiten duzu denbora bakoitzean.';

  @override
  String get hiwBridgeBadge => 'ESKUZKOA ALTERNATIBOA · ANDROID 11-12';

  @override
  String get hiwBridgeSaveFolder => 'Stardew-en karpeta';

  @override
  String get hiwBridgeValleySaveFolder => 'ValleySave-ren karpeta';

  @override
  String get hiwBridgeNote =>
      'Darabila zure sistemaren fitxategien aplikazio hartan horien karpetak atzitu ditzakete (ValleySave ez dak).';

  @override
  String get hiwTipAlwaysShow =>
      'Beti Drive-ean dagoena ikusiko duzu idatzia aurretik, konparatu ahal izateko.';

  @override
  String get hiwTipWithoutUpload =>
      'Igotu gabe, beste gailuak ez ditu zure aurrerapen berria ikusiko.';

  @override
  String get hiwTipComparison =>
      'Konparaketa ikusiko duzu lokalen eta Drive-en artean egiaztatzen aurretik.';

  @override
  String get hiwTipDownloadOverwrite =>
      'Deskargatzea zure gordetze lokala idazten du. Sinkronizagabeko aurrerapenik galduko da.';

  @override
  String get hiwTipSync =>
      'Beti igo Drive-ra gailua aldatu aurretik, eta deskargatu heltzean.';

  @override
  String get hiwTipDeletion =>
      '30 egunean Drive Zabortik leheneratu dezakezu betirako ezabatu aurretik.';

  @override
  String get hiwPrivacyLink => 'Pribatutasun politika eta erabilpena';

  @override
  String get emptyNoSaves => 'Gordetzerik ez aurkitu';

  @override
  String get emptyNoSavesHint =>
      'Gordetze lokalik ez da irakur daiteke gailu honetan';

  @override
  String get bridgeTitle => 'Zure gordetzeeak ekartzen';

  @override
  String get bridgeDesc =>
      'Zure gordetze lokalak ikusi eta igo ahal izateko, kopiak zure fitxategien aplikazioarekin Stardew karpetetik ValleySave karpetara. Ondoren, gorantz estali berritzeko.';

  @override
  String get bridgeRefresh => 'Berritu';

  @override
  String get bridgeChangeMode => 'Metodoa aldatu';

  @override
  String get loaderLoading => 'KARGATZEN';

  @override
  String get loaderConnecting => 'Drive-ra konektatzen…';

  @override
  String get chooserTitle => 'Nola konektatu aukeratu';

  @override
  String get chooserAutomatic => 'Automatikoa · Gomendatua';

  @override
  String get chooserManual => 'Eskuzkoa alternatiboa · Android 11-12';

  @override
  String get shizukuStepTitle => 'Shizuku konfiguratu';

  @override
  String get shizukuStep1Title => 'Shizuku instalatu';

  @override
  String get shizukuStep1Desc => 'Play Store-tik edo GitHub-etik deskargatu';

  @override
  String get shizukuStep2Title => 'Shizuku aktibatu';

  @override
  String get shizukuStep2Desc => 'Aplikazioa exekutatu eta baimenak emango';

  @override
  String get shizukuStep3Title => 'Baimena emango';

  @override
  String get shizukuStep3Desc => 'ValleySave sarbidea eskatuko du';

  @override
  String get shizukuDone =>
      '✓ Egina. Ordutik aurrera, gordetzeeak deskargatzea eta igotzeya zuzenean egiten da, ordenagailuaren bezala.';

  @override
  String get dlgDeleteDriveTitle => 'Drive-tik ezabatu';

  @override
  String get dlgDeleteLocalTitle => 'Gailu honetatik ezabatu';

  @override
  String get dlgDownloadTitle => 'Gordetze deskargatu';

  @override
  String get dlgUploadTitle => 'Gordetze igo';

  @override
  String get dlgUploadOverwrite => 'Honek zure gordetze lokala idatziko du';

  @override
  String get dlgGotIt => 'Ulertu';

  @override
  String get dlgCopyDest => 'Kopiaren helmuga';

  @override
  String get previewColDayYear => 'Eguna/Urtea';

  @override
  String get previewColTime => 'Joko-denbora';

  @override
  String get previewColMoney => 'Txanponak';

  @override
  String get previewColTotal => 'Guztira';

  @override
  String get previewColFarming => 'Laborantzak';

  @override
  String get previewColForaging => 'Bilduma';

  @override
  String get previewColMining => 'Meatzea';

  @override
  String get previewColFishing => 'Arrantzak';

  @override
  String get previewColCombat => 'Borroka';

  @override
  String get previewColFriends => 'Lagunak';

  @override
  String get previewColMonsters => 'Bestiak';

  @override
  String get previewColFaints => 'Hautsi';

  @override
  String get previewColMine => 'Meatzea';

  @override
  String get previewColUnexplored => 'Arakatu gabea';

  @override
  String get previewLocalLabel => 'GAILU HONETAN';

  @override
  String get previewDriveLabel => 'DRIVE-AN';

  @override
  String get previewFromDrive => 'DRIVE-ETIK';

  @override
  String get previewFromDevice => 'GAILU HONETATIK';

  @override
  String versionMismatch(String local, String drive) {
    return 'Bertsioak desberdiak: lokal $local · Drive $drive…';
  }

  @override
  String get snackPathCopied => 'Bidea kopiatuta';

  @override
  String get snackDestCopied => 'Helmugan bidea kopiatuta';

  @override
  String get snackDownloaded => 'Gordetze jokoen deskargatuta';

  @override
  String get snackReplacePrepareFailed =>
      'Could not prepare the save. Nothing on disk was changed';

  @override
  String get snackReplaceValidationFailed =>
      'The downloaded save looks invalid or incomplete. Nothing on disk was changed';

  @override
  String get snackReplaceBackupFailed =>
      'Could not create a safety backup. Nothing on disk was changed';

  @override
  String get snackReplaceSwapFailed =>
      'The swap failed, but the original save was restored from backup';

  @override
  String get snackReplaceBusy =>
      'There\'s already an operation in progress for this save';

  @override
  String get snackUploadIncomplete =>
      'The local save is incomplete or corrupted. Nothing was uploaded';

  @override
  String get snackDownloadIncomplete =>
      'Can\'t download: this save is missing content on Drive';

  @override
  String get cardIncomplete => 'Incomplete on Drive';

  @override
  String get snackSessionExpired => 'Drive saioai amaitu. Berrkonektatu';

  @override
  String snackUploadError(String error) {
    return 'Igo akatsa: $error';
  }

  @override
  String snackDownloadError(String error) {
    return 'Deskarga akatsa: $error';
  }

  @override
  String snackDeleteError(String error) {
    return 'Ezabatze akatsa: $error';
  }

  @override
  String snackTrashed(String saveName) {
    return '\"$saveName\" Drive Zaborra basurantz mugitu. 30 egunean leheneratu dezakezu.';
  }

  @override
  String snackDeletedLocal(String saveName) {
    return '\"$saveName\" gailu honetatik ezabatu';
  }

  @override
  String get snackShizukuRequired => 'Shizuku gaitu…';

  @override
  String get snackWriteError =>
      'Jokoen idaztera ezin. Telefo batzuk /Android/data ez dituzte oztat Shizuku-rekin ere.';

  @override
  String get snackPlatformNotSupported =>
      'Plataforma honek ez dak oraindik gordetze lokalak idaztea';

  @override
  String get snackWirelessDebugHint =>
      'Ireki eskuz: Ezarpenak → Garapeneraren aukerak → Hari gabea debugging.';

  @override
  String get snackOpenShizukuApp =>
      'Irekiertz Shizuku zure aplikazioen bilatzean.';

  @override
  String get hiwTipDeletePermanent =>
      'ValleySave inoiz ez al dezake berriz galdutako gordetzeeak. Drive fitxategiak zure erantzukizuna dira.';

  @override
  String get hiwCompatAchievements =>
      'Steam eta Google Play lorpenak ez dira transferitzen. Plataforma bakoitzak berez lotzen ditu bakarrik gertatutako lorpenak — gordetze fitxategik ez ditu retroaktiboki sustatzen.';

  @override
  String get hiwCompatOverwrite =>
      'Bi gailuetatik sinkronizatu gabe ordenari jarraiki, gordetze batak bestea bota ditzake. Beti igo Drive-ra deskargatu aurretik.';

  @override
  String get hiwCompatVersions =>
      'Jokoen berbtsio desberdinetatik gordetzeeak ez agian ez direla kargatzen ondo. ValleySave abisezia ematen dizu bertsio desparekotasuna atzemarik aurretik deskargatzen baduzu.';

  @override
  String get hiwCompatMods =>
      'SMAPI moldaketak datu osagarri gehitze dituzte gordetzeean. SMAPI moldaketak ez badaude gailuan non kargatzen baduzu, jokoa huts egite edo moldaketa datuak galdu ditzake.\n\nAndroid-ean, SMAPI moldaketak erabiltzeko instalatu ditzake.';

  @override
  String get hiwCompatIncomplete =>
      'If you see \"Incomplete on Drive\" on a save, it\'s missing a required file in the cloud — it can\'t be downloaded until it\'s uploaded properly again from another device.';

  @override
  String get hiwShareTitle => 'Share with others';

  @override
  String get hiwShareDesc =>
      'Share a save with another player by email. They\'ll see it under Shared with me on their own device.';

  @override
  String get hiwShareStepYourSave => 'Your\nsave';

  @override
  String get hiwShareStepShare => 'Share by\nemail';

  @override
  String get hiwShareStepFriend => 'Shared\nwith me';

  @override
  String get hiwShareTipRoles =>
      'Two roles: Read-only lets them view and download. Allow sync lets them overwrite your copy on Drive. Either way they can never delete it — only you, the owner, can delete your save.';

  @override
  String get hiwShareTipDisconnect =>
      'Disconnecting just stops syncing on their end — the share stays active until you leave it for real from Manage shares.';

  @override
  String get hiwHostSwapTitle => 'Host swap';

  @override
  String get hiwHostSwapDesc =>
      'Change which farmhand hosts the save, replacing it in place — same save slot, same sharing permissions.';

  @override
  String get hiwHostSwapStepPick => 'Pick a\nfarmhand';

  @override
  String get hiwHostSwapStepConfirm => 'Confirm';

  @override
  String get hiwHostSwapStepDone => 'New save\ncreated';

  @override
  String get hiwHostSwapTipMove =>
      'Some farm objects may be relocated to make room for the house — nothing is deleted.';

  @override
  String get hiwHostSwapTipHouse =>
      'The new host\'s house will look like the game\'s default big house — cabin styling isn\'t supported without mods.';

  @override
  String get hiwBackupsTitle => 'Backups';

  @override
  String get hiwBackupsDesc =>
      'A backup is a snapshot of a save you can restore later. Create one manually anytime, or let ValleySave create one automatically before overwriting a save (downloading, importing, restoring, or a host swap).';

  @override
  String get hiwBackupsStepSave => 'Your\nsave';

  @override
  String get hiwBackupsStepSnapshot => 'Backup\nsnapshot';

  @override
  String get hiwBackupsStepStore => 'Local and/or\nDrive';

  @override
  String get hiwBackupsTipRestore =>
      'Restoring overwrites your current save with that earlier version — this can\'t be undone.';

  @override
  String get hiwBackupsTipDelete =>
      'Deleting a backup removes it everywhere it exists (this device and Drive, if uploaded) — this can\'t be undone.';

  @override
  String get hiwBackupsTipExport =>
      'You can also Export a save as a zip file to keep wherever you like, and Import it back later — a fully manual, portable alternative to the built-in backups.';

  @override
  String get hiwBackupsTipRetention =>
      'ValleySave keeps the 5 most recent automatic backups per save; the ones you create manually are never deleted on their own.';

  @override
  String get hiwBackupsTipRestoreBridge =>
      'In Bridge mode (Android without root/Shizuku), restoring a backup asks you to extract the .zip by hand into Stardew\'s folder — same as downloading.';

  @override
  String get hiwComparePrimary => 'Joko-denbora guztira';

  @override
  String get hiwCompareNoShown1 => 'Basoaren eta animalien egoera';

  @override
  String get hiwCompareNoShown2 => 'Inbentarioa eta objektuak';

  @override
  String get hiwCompareNoShown3 => 'Banakako harremanak';

  @override
  String get hiwShizuku1 => 'Shizuku instalatu (Play Store edo GitHub APK).';

  @override
  String get hiwShizuku2 =>
      'Aktibatu hari gabeko debugging-ean — ValleySave pausoka gidalari egiten dizu.';

  @override
  String get hiwShizuku3 => 'Baimena emango ValleySave behartzean.';

  @override
  String get hiwBridge1 =>
      'Drive-tik deskargatu: ValleySave gordetzeea bere karpetan utzietan. Zuk kopian harekin fitxategian Stardew-ren karpetan.';

  @override
  String get hiwBridge2 =>
      'Drive-ra igo: kopiatu gordetzeea Stardew-tik ValleySave-ren karpetan. ValleySave atzemanzen du eta igotzea.';

  @override
  String get snackShizukuBattery =>
      'Ezarpenak → Aplikazioak → Shizuku → Bateria → Mugarik gabe.';

  @override
  String snackDriveError(String error) {
    return 'Drive: $error';
  }

  @override
  String get dlgDeleteLocalWarning =>
      '⚠️ Drive-ra igo ez baduzu, betirako galduko da. Berreskurapenez gabe.';

  @override
  String get dlgDelete => 'Ezabatu';

  @override
  String get dlgDownloadButton => 'Deskargatu';

  @override
  String get dlgUploadButton => 'Igo';

  @override
  String get dlgBridgeCopyTitle => 'Kopiatu gordetzeea jokoan';

  @override
  String dlgBridgeCopyDesc(String saveName) {
    return 'Gordetzeea dago. Zure fitxategien aplikazioarekin, kopiatu \"$saveName\" karpeta eta azkoa Stardew karpetan.';
  }

  @override
  String get labelFrom => 'Jatorritik';

  @override
  String get labelTo => 'Helmuganera';

  @override
  String dlgDownloadNewDesc(String saveName, int day, String playtime) {
    return '\"$saveName\" ($day eguna, $playtime) gailu honetan kopiatuko da.';
  }

  @override
  String dlgDownloadOverwrite(String saveName) {
    return 'Honek \"$saveName\"-ren zure lokal gordetzeea idatziko du.';
  }

  @override
  String dlgUploadNewDesc(String saveName, int day, String playtime) {
    return '\"$saveName\" ($day eguna, $playtime) zure Drive-an igoko da.';
  }

  @override
  String dlgUploadOverwriteDrive(String saveName) {
    return 'Honek \"$saveName\"-ren Drive bertsioa idatziko du.';
  }

  @override
  String get pathLabelFromStardew => 'Jatorritik (Stardew)';

  @override
  String get pathLabelToValleySave => 'Helmuganera (ValleySave)';

  @override
  String get chooserDesc =>
      'Android jokoen karpeta babestuetan. Nola emango diozu ValleySave-ri sarbidea — noiznahi aldatu dezakezu.';

  @override
  String get chooserShizukuDesc =>
      'Konfiguraturik behin. Ondoren ValleySave berez sinkronizatzen du, inoiz ez hori apurtu gabe. Android 13 eta hurrengoan bakarrik fidagarri metodo.';

  @override
  String get chooserManualBadge => 'ANDROID 11-12 BAKARRIK';

  @override
  String get chooserBridgeDesc =>
      'Gordetzeeak zure fitxategien aplikazioarekin kopian. Ezer extra ez instalatu. Android 11 eta 12-an bakarrik.';

  @override
  String get chooserRootBadge => 'ROOT';

  @override
  String get chooserRootTitle => 'Root Sarbidea';

  @override
  String get chooserRootDesc =>
      'Errotu diren gailuetarako (Magisk / SuperSU). Root baimena behin onartu — geroztik automatikoki.';

  @override
  String get snackRootDenied => 'Root sarbidea ukatua. Saiatu Shizuku.';

  @override
  String get shizukuGateSubtitle =>
      'Konfiguraturik behin · lehen aldia bakarrik';

  @override
  String get shizukuStatusLabel => 'Shizuku aktibo';

  @override
  String get shizukuStatusRunning => 'Konektatuta eta itxaroten.';

  @override
  String get shizukuStatusNotDetected => 'Oraindik ez atzemanzen.';

  @override
  String get shizukuPermLabel => 'Baimena emanda';

  @override
  String get shizukuPermGranted => 'ValleySave-k dagoenean sarbidea.';

  @override
  String get shizukuPermNotGranted => 'ValleySave baimen egingo.';

  @override
  String get shizukuGrant => 'baimen';

  @override
  String get shizukuGuideHeader => 'PAUSOKA GIDABURUAK';

  @override
  String get shizukuStep1DescFull =>
      'Aske. Google Play-k zure telefonoan blokeatu baldin badu, offizialaren GitHub APK erabili.';

  @override
  String get btnPlayStore => 'Play Store';

  @override
  String get btnApkGithub => 'APK GitHub';

  @override
  String get shizukuStep2TitleFull => 'Garapeneraren aukerak gaitu';

  @override
  String get shizukuStep2DescFull =>
      'Ezarpenak → Telefo info → Software info → sakatu \"Eraikuntza zenbakia\" 7 alditan.';

  @override
  String get shizukuStep3TitleFull => 'Hari gabeko debugging gaitu';

  @override
  String get shizukuStep3DescFull =>
      'Botoia nora joana hartzen dizu eta nabarmentzena. Gaitu (ON). Ondoren sakatu \"Gailu parean pairing kodearen bidez\" — 6 zifraren kodea pantailan agertuko zaio.';

  @override
  String get btnOpenAndHighlight => 'Ireki eta nabarmen';

  @override
  String get shizukuStep4Title => 'Parean eta SHIZUKU HASI';

  @override
  String get shizukuStep4Desc =>
      'Ireki Shizuku → \"Hasi hari gabeko debugging bidez\" → \"Parean pairing kodearen bidez\". Shizuku jakinarazpen bat bidaliko du itxaroten zaio. Sartu 6 zifraren kodea hari gabeko debugging pantailatik. Parean ondoren, sakatu START — bota azkoa gabe Shizuku ez aktibatuta.';

  @override
  String get btnOpenShizuku => 'Ireki Shizuku';

  @override
  String get shizukuStep5Title => 'Shizuku bateria mugarik gabe konfiguratu';

  @override
  String get shizukuStep5Desc =>
      'Ireki aplikazio info → Bateria → Mugarik gabe. Honek ez baduzu, sistemak Shizuku atzemakaian itxi agertuko eta START berriro sakatu beharko duzu.';

  @override
  String get btnShizukuAppInfo => 'Shizuku aplikazio info';

  @override
  String get shizukuStep6DescActive =>
      'Shizuku aktibo dago. Botoia sakatu baimen emango.';

  @override
  String get shizukuStep6DescWaiting =>
      'Erabilgarri Shizuku aktiboan bada (4 pausoa).';

  @override
  String get btnGrantPermission => 'Baimena emango';

  @override
  String get btnCheckShizuku => 'Egina · Egiaztatu';

  @override
  String get statusDone => 'egina';

  @override
  String get statusPending => 'zain';

  @override
  String get latestBadge => '· AZKENEKO GORDETZEEA ·';

  @override
  String saveDateLabel(String season, int year) {
    return '$season · $year urtea';
  }

  @override
  String get petCat => 'Katua';

  @override
  String get petDog => 'Txakurra';

  @override
  String get houseBasic => 'Baserritxo oinarrizko';

  @override
  String get houseKitchen => 'Sukaldean duenak';

  @override
  String get houseBedroom => 'Logelarekin';

  @override
  String get houseCellar => 'Soteroan duenak';

  @override
  String houseLevelN(int level) {
    return 'Lv. $level';
  }

  @override
  String get tooltipLaunchGame => 'Jokatu';

  @override
  String get hiwLaunchTitle => 'Jokoa ireki';

  @override
  String get hiwLaunchDesc =>
      'Nire gordetakoak pantailako goiko barrako ▶ botoiak Stardew Valley zuzenean aplikaziotik irekitzen du.';

  @override
  String get hiwLaunchTipWindows =>
      'Windowsen jokoa automatikoki aurkitzen ez bada, Ezarpenak → Jokoa atalean exekutagarriaren bidea ezarri.';

  @override
  String get hiwLaunchTipAndroid =>
      'Androiden instalatuta badago jokoa irekitzen du.';

  @override
  String get hiwLaunchTipLinux =>
      'On Linux, if the game isn’t detected automatically, set the executable path in Settings → Game.';

  @override
  String get hiwSaveLocationsTitle => 'Where your saves live';

  @override
  String get hiwSaveLocationsDesc =>
      'ValleySave reads and writes directly to the game\'s save folder on each platform.';

  @override
  String get hiwSaveLocationWindows =>
      'Windows: %AppData%\\StardewValley\\Saves';

  @override
  String get hiwSaveLocationAndroid =>
      'Android: protected folder, accessed via Shizuku or the Bridge';

  @override
  String get hiwSaveLocationLinux =>
      'Linux: ~/.config/StardewValley/Saves (or ~/snap/steam/common/.config/StardewValley/Saves if Steam is installed via snap)';

  @override
  String get settingsGameSection => 'Jokoa';

  @override
  String get settingsGameExePath => 'Stardew Valley exekutagarria';

  @override
  String get settingsGameExeNotFound => 'Ez da automatikoki aurkitu';

  @override
  String get settingsGameExeBrowse => 'Bilatu…';

  @override
  String get settingsGameExeSaved => 'Bidea gordeta';

  @override
  String get snackLaunchError => 'Ezin izan da jokoa ireki';

  @override
  String get makeHostAction => 'OSTALARI BIHURTU';

  @override
  String get makeHostExperimental => 'ESPERIMENTALA';

  @override
  String get makeHostDialogTitle => 'Ostalaria aldatu';

  @override
  String makeHostDialogIntro(String playerName, String farmName) {
    return '$playerName $farmName baserriko ostalari izango da.';
  }

  @override
  String get makeHostNewCopyNote =>
      'Partida berri bat sortzen da. Gero erabakiko duzu jatorrizkoarekin zer egin.';

  @override
  String makeHostMoveCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other:
          'Baserriko $count objektu lekuz aldatuko dira etxeari tokia egiteko. Ezer ez da ezabatzen.',
      one:
          'Baserriko objektu 1 lekuz aldatuko da etxeari tokia egiteko. Ezer ez da ezabatzen.',
    );
    return '$_temp0';
  }

  @override
  String get makeHostHouseWarning =>
      'Ostalari berriaren etxea jokoaren baserri handi bezala ikusiko da. Etxolaren itxura ez da onartzen modrik gabe.';

  @override
  String get makeHostConfirmButton => 'Ostalari bihurtu';

  @override
  String makeHostSuccess(String playerName) {
    return 'Partida berria sortu da: $playerName da orain ostalaria.';
  }

  @override
  String get hostSwapErrInvalid =>
      'Partida honek ustekabeko egitura du. Ez da ezer aldatu.';

  @override
  String get hostSwapErrNoSpace =>
      'Ez dago leku librerik baserrian objektuak lekuz aldatzeko. Ez da ezer aldatu.';

  @override
  String get hostSwapErrWrite =>
      'Ezin izan da partida berria idatzi (diskoa/baimenak). Ez da ezer aldatu.';

  @override
  String get hostSwapErrValidation =>
      'Partida berriaren egiaztapenak huts egin du eta baztertu egin da. Jatorrizkoa osorik dago.';
}
