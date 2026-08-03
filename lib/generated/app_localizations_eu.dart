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
    return 'Deskonektatu $email(e)tik';
  }

  @override
  String get connectedAsPrefix => 'Honela konektatuta:';

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
  String get exportAction => 'Esportatu';

  @override
  String get exportSuccess => 'Gordetzea esportatu da.';

  @override
  String exportError(String error) {
    return 'Ezin izan da gordetzea esportatu: $error';
  }

  @override
  String get importAction => 'Inportatu gordetzea';

  @override
  String importSuccess(String playerName) {
    return '$playerName(r)en gordetzea inportatu da.';
  }

  @override
  String get importErrInvalidZip =>
      'Fitxategi hau ez da zip fitxategi baliozkoa.';

  @override
  String get importErrUnsafePath =>
      'Fitxategi honek egitura ez-segurua du eta ezetsi egin da.';

  @override
  String get importErrTooLarge => 'Fitxategi hau handiegia da inportatzeko.';

  @override
  String get importErrNotASave =>
      'Fitxategi honek ez du gordetze ezagungarririk.';

  @override
  String get importErrWrite =>
      'Ezin izan da inportatutako gordetzea idatzi (diskoa/baimenak).';

  @override
  String get importErrBackupFailed =>
      'Ezin izan da babeskopia sortu. Ez da ezer inportatu.';

  @override
  String get importConflictTitle =>
      'Dagoeneko badago izen hori duen gordetze bat';

  @override
  String get importConflictBody =>
      'Inportatzeak dagoen kopia lokala ordeztuko du. Ezin da desegin.';

  @override
  String get importConflictConfirm => 'Gainidatzi';

  @override
  String get shareAction => 'Partekatu';

  @override
  String get shareUploadFirstCta => 'Igo lehenengo';

  @override
  String get shareDialogTitle => 'Partekatu gordetzea';

  @override
  String get shareEmailPlaceholder => 'izena@adibidea.com';

  @override
  String get shareInfoNote =>
      'Partekatzeak ikusi eta deskargatzeko sarbidea ematen du. Zuk bakarrik editatu edo ezaba dezakezu zure Drive-ko kopia.';

  @override
  String get shareRoleReader => 'Irakurtzeko soilik';

  @override
  String get shareRoleWriter => 'Sinkronizatzea baimendu';

  @override
  String get shareInfoNoteCoop =>
      'Irakurtzeko soilik aukerak ikusi eta deskargatzeko aukera ematen du. Sinkronizatzea baimentzeak zure Drive-ko kopia gainidazteko aukera ematen du — inoiz ez dute ezabatuko.';

  @override
  String get shareConfirmButton => 'Partekatu';

  @override
  String shareSuccess(String email) {
    return '$email(r)ekin partekatuta.';
  }

  @override
  String get manageAccessTitle => 'Sarbidea duten pertsonak';

  @override
  String get manageAccessEmpty => 'Oraindik inork ez du sarbiderik.';

  @override
  String get manageAccessRoleLabel => 'Sarbidea';

  @override
  String get manageAccessRevoke => 'Kendu';

  @override
  String manageAccessRevokeConfirm(String email) {
    return '$email(r)i sarbidea kendu? Dagoeneko deskargatu duen kopia lokal oro berea izaten jarraituko du.';
  }

  @override
  String get driveOnlyControlsYourCopy =>
      'Partekatzeak zure Drive-ko kopia kontrolatzen du soilik. Norbaitek deskargatzen badu, kopia hori berea da.';

  @override
  String get driveOnlyControlsYourCopyCoop =>
      'Sinkronizatzeak zure Drive-ko kopia kontrolatzen du — baimentzen duzunak gainidatz dezake, baina inoiz ez ezabatu.';

  @override
  String get sharedWithMeTitle => 'Nirekin partekatuak';

  @override
  String get sharedWithMeEmpty => 'Oraindik ez dute ezer partekatu zurekin.';

  @override
  String get sharedWithMeAdd => 'Gehitu partekatutako gordetzea';

  @override
  String sharedWithMeOwnedBy(String email) {
    return '$email(e)k partekatuta';
  }

  @override
  String get sharedWithMeRoleSync => 'Sinkronizatzen du';

  @override
  String get sharedWithMeRoleRead => 'Irakurtzeko soilik';

  @override
  String get sharedWithMeSync => 'Sinkronizatu';

  @override
  String get sharedWithMeDownload => 'Deskargatu';

  @override
  String get sharedWithMeRemove => 'Deskonektatu';

  @override
  String sharedWithMeRemoveConfirm(String email) {
    return 'Ez zara gehiago $email(r)en Drive-rekin sinkronizatuko, baina nahi duzunean berriro gehitu dezakezu — partekatuta jarraitzen du. Zure kopia lokala coop gordetze arrunt gisa geratuko da.';
  }

  @override
  String sharedLeaveConfirm(Object email) {
    return 'Benetan galduko duzu gordetze honetarako sarbidea. Ezin izango duzu berriro gehitu, $email(e)k berriro zurekin partekatzen ez badu. Zure kopia lokala coop gordetze arrunt gisa geratuko da.';
  }

  @override
  String get sharedManageButton => 'Kudeatu';

  @override
  String get sharedManageDialogTitle => 'Partekatuak kudeatu';

  @override
  String get sharedManageDialogHint =>
      'Hemen partekatutako gordetze batetik benetan atera zaitezke.';

  @override
  String get sharedLeaveButton => 'Partekatzetik atera';

  @override
  String sharedLeaveSuccess(Object email) {
    return '$email(r)en partekatzetik atera zara.';
  }

  @override
  String sharedWithMeSyncConfirm(String email) {
    return '$email(r)en Drive-ko kopia zure gordetze lokalarekin gainidatzi?';
  }

  @override
  String sharedAccessReadOnly(String email) {
    return '$email(e)k irakurtzeko soilik moduan jarri zaitu — ikusi eta deskargatu dezakezu, baina ezin duzu bere Drive-ra sinkronizatu.';
  }

  @override
  String get sharedWithMeRevoked => 'Jada ez duzu sarbiderik';

  @override
  String sharedRevokedDialogBody(String email, String farmName) {
    return '$email(e)k $farmName zurekin partekatzeari utzi dio. Zure kopia lokala eta Drive-koa horrela geratzen dira, orain Nire gordetzeak atalean.';
  }

  @override
  String get sharedRevokedAccept => 'Ados';

  @override
  String get sharedSelfCleanupTitle => 'Erregistroa zuzenduta';

  @override
  String sharedSelfCleanupBody(String farmName) {
    return '$farmName zurekin partekatuta agertu zen okerreko batez — benetan zurea da. Zuzendu da, orain Nire gordetzeak atalean dago.';
  }

  @override
  String get sharedWithMeUploadOwn => 'Igo nire Drive-ra';

  @override
  String get sharedDownloadOwn => 'Deskargatu nire Drive-tik';

  @override
  String get sharedStatusOwnDriveAhead =>
      'Zure Drive-a aurretik doa — deskargatu';

  @override
  String get sharedSyncBoth => 'Igo bi Drive-etara';

  @override
  String get sharedSideMyDrive => 'NIRE DRIVE';

  @override
  String sharedSideOwnerDrive(String email) {
    return '$email(r)en DRIVE-A';
  }

  @override
  String sharedSideDate(int day, int year) {
    return '$day eguna · $year urtea';
  }

  @override
  String get sharedStatusSyncedNoOwnDrive =>
      'Jabearekin sinkronizatuta · zure Drive-n kopiarik gabe';

  @override
  String get sharedStatusAheadNoOwnDrive =>
      'Aurretik zoaz · zure Drive-n kopiarik gabe';

  @override
  String sharedStatusOwnerAheadNoOwnDrive(String email) {
    return '$email aurretik doa · zure Drive-n kopiarik gabe';
  }

  @override
  String get sharedStatusAllSynced => 'Sinkronizatuta (lokala + bi Drive-ak)';

  @override
  String get sharedStatusAheadBoth => 'Bi Drive-etan aurretik zoaz';

  @override
  String get sharedStatusMixed =>
      'Sinkronizatu gabe — egiaztatu Drive bakoitza';

  @override
  String get sharedStatusFullySynced => 'Erabat sinkronizatuta';

  @override
  String get sharedStatusSyncedOwn => 'Nire Drive-a sinkronizatuta';

  @override
  String get sharedStatusSyncedOwner => 'Partekatutako Drive-a sinkronizatuta';

  @override
  String get sharedStatusNotCloud => 'Gailu honetan bakarrik';

  @override
  String sharedStatusOwnerAhead(Object email) {
    return '$email(r)en Drive-a aurretik doa';
  }

  @override
  String get sharedStatusBothAhead => 'Bi Drive-ak aurretik doaz';

  @override
  String get sharedStatusLocalMissing => 'Ez dago gailu honetan';

  @override
  String sharedStatusOwnerUnavailable(Object email) {
    return 'Ezin izan da $email(r)en Drive-a egiaztatu';
  }

  @override
  String get sharedStatusWorking => 'Sinkronizatzen…';

  @override
  String get sharedSideUnavailable => 'Ezin izan da egiaztatu';

  @override
  String get sharedSyncChooseTitle => 'Non sinkronizatu nahi duzu?';

  @override
  String get sharedSyncChooseBody =>
      'Aukeratu zein hodei-kopia eguneratu nahi dituzun gailu honetako gordetzearekin.';

  @override
  String get sharedSyncTargetOwn => 'Nire Drive-a';

  @override
  String sharedSyncTargetOwner(Object email) {
    return '$email(r)en Drive-a';
  }

  @override
  String get sharedSyncTargetBoth => 'Bi Drive-ak';

  @override
  String get sharedDownloadChooseTitle => 'Zein kopia deskargatu nahi duzu?';

  @override
  String get sharedDownloadChooseBody =>
      'Kopia bat baino gehiago dago aurretik. Aukeratu zein ekarri nahi duzun gailu honetara.';

  @override
  String get sharedDownloadSourceOwn => 'Nire Drive-tik';

  @override
  String sharedDownloadSourceOwner(Object email) {
    return '$email(r)en Drive-tik';
  }

  @override
  String get sharedWithMePickerTitle => 'Gehitu partekatutako gordetzea';

  @override
  String get sharedPickerEmptyHint =>
      'Beste jokalari batek Drive-tik zurekin partekatzen duena hemen agertzen da.';

  @override
  String get sharedPickerAddButton => 'Gehitu';

  @override
  String get sharedOriginBadge => 'Partekatua';

  @override
  String sharedOriginFrom(String email) {
    return '$email(r)engandik';
  }

  @override
  String get swapBackupDialogTitle => 'Babeskopia sortuta';

  @override
  String get swapBackupDialogBody =>
      'Aurreko bertsioa zip gisa gorde da. Zer egin nahi duzu horrekin?';

  @override
  String get swapBackupUpload => 'Igo Drive-ra';

  @override
  String get swapBackupLocalOnly => 'Mantendu gailu honetan';

  @override
  String get swapBackupDeleteNow => 'Ezabatu orain';

  @override
  String get swapBackupUploadOk => 'Babeskopia Drive-ra igo da.';

  @override
  String swapBackupUploadErr(String error) {
    return 'Ezin izan da babeskopia igo: $error';
  }

  @override
  String get swapBackupLocalOnlySnack => 'Babeskopia gailu honetan gorde da.';

  @override
  String get backupsAction => 'Babeskopiak';

  @override
  String backupsScreenTitle(String farmName) {
    return '$farmName(r)en babeskopiak';
  }

  @override
  String get backupsEmpty => 'Oraindik babeskopiarik ez.';

  @override
  String get backupsRestore => 'Leheneratu';

  @override
  String get backupsRestoreConfirmTitle => 'Babeskopia hau leheneratu?';

  @override
  String get backupsRestoreConfirmBody =>
      'Honek zure uneko gordetzea aurreko bertsio honekin gainidazten du. Ezin da desegin.';

  @override
  String get backupsDelete => 'Ezabatu';

  @override
  String get backupsDeleteConfirmTitle => 'Babeskopia hau ezabatu?';

  @override
  String get backupsDeleteConfirmBody =>
      'Existitzen den leku guztietatik ezabatuko da (gailu hau eta Drive, igo bada). Ezin da desegin.';

  @override
  String get backupsRestoreOk => 'Babeskopia leheneratu da.';

  @override
  String get backupsRestoreManualTitle => 'Eskuz leheneratu';

  @override
  String get backupsRestoreManualBody =>
      'Zubi moduan, ValleySave-k ezin du automatikoki idatzi jokoaren karpetan. Atera zeuk babeskopia honen .zip-a Stardew Valley-ren Saves karpetan, edo aldatu Root/Shizuku modura Ezarpenetan automatikoki leheneratzeko.';

  @override
  String backupsRestoreErr(String error) {
    return 'Ezin izan da babeskopia leheneratu: $error';
  }

  @override
  String backupsDeleteErr(String error) {
    return 'Ezin izan da babeskopia ezabatu: $error';
  }

  @override
  String get backupsCreate => 'Sortu babeskopia lokala';

  @override
  String get backupsCreateLocalHint =>
      'Babeskopiak lehenengo gailu honetan sortzen dira. Ondoren Drive-ra igo ditzakezu.';

  @override
  String get backupsCreateOk => 'Babeskopia sortu da.';

  @override
  String backupsCreateErr(String error) {
    return 'Ezin izan da babeskopia sortu: $error';
  }

  @override
  String get backupsDownload => 'Deskargatu';

  @override
  String get backupsDownloadOk => 'Babeskopia gailu honetara deskargatu da.';

  @override
  String backupsDownloadErr(String error) {
    return 'Ezin izan da babeskopia deskargatu: $error';
  }

  @override
  String get backupsCopyOwn => 'Kopiatu nire Drive-ra';

  @override
  String get backupsUploadOwn => 'Nire Drive-ra';

  @override
  String get backupsUploadShared => 'Partekatutako Drive-ra';

  @override
  String get backupsUploadOk => 'Babeskopia igo da.';

  @override
  String backupsUploadErr(String error) {
    return 'Ezin izan da babeskopia igo: $error';
  }

  @override
  String get backupsLocationLocal => 'Gailu hau';

  @override
  String get backupsLocationOwnDrive => 'Nire Drive-a';

  @override
  String get backupsLocationSharedDrive => 'Partekatutako Drive-a';

  @override
  String get backupsDeleteChooseBody =>
      'Aukeratu zehazki non ezabatu. Babeskopia hau dagoen lekuak bakarrik agertzen dira.';

  @override
  String get backupsDeleteLocalOnly => 'Gailu honetatik bakarrik';

  @override
  String get backupsDeleteOwnOnly => 'Nire Drive-tik bakarrik';

  @override
  String get backupsDeleteSharedOnly => 'Partekatutako Drive-tik bakarrik';

  @override
  String get backupsDeleteAll => 'Kopia guztietatik';

  @override
  String deleteUnifiedTitle(String farmName) {
    return '$farmName ezabatu?';
  }

  @override
  String get deleteChooseLocationBody =>
      'Aukeratu nondik. Gailu honetako kopia betirako ezabatuko da; Drive-koa Zaborrera mugituko da (30 egun).';

  @override
  String deleteDriveContextTitle(String farmName) {
    return '$farmName Drive-tik ezabatu?';
  }

  @override
  String get deleteDriveContextBody =>
      'Drive-ko kopia Zaborrera mugituko da, eta 30 egunean leheneratu ahal izango duzu.';

  @override
  String get deleteDriveLocalKept =>
      'Gailu honetako kopiak aldaketarik gabe jarraituko du.';

  @override
  String deleteLocalContextTitle(String farmName) {
    return '$farmName gailu honetatik ezabatu?';
  }

  @override
  String get deleteLocalContextBody =>
      'Gailu honetako kopia betirako ezabatuko da.';

  @override
  String deleteLocalDriveCurrent(String date) {
    return 'Zure Drive-ko kopia eguneratuta dago ($date) eta erabilgarri jarraituko du.';
  }

  @override
  String deleteLocalDriveAhead(String date) {
    return 'Zure Drive-ko kopia berriagoa da ($date) eta erabilgarri jarraituko du.';
  }

  @override
  String deleteLocalDriveOlder(String driveDate, String localDate) {
    return 'Zure Drive-ko kopia zaharragoa da ($driveDate); gailu hau $localDate(e)an dago.';
  }

  @override
  String deleteLocalBackupAvailable(int count) {
    return '$count babeskopia lokal daude eskuragarri aurreko kopia bat behar izanez gero.';
  }

  @override
  String get deleteLocalNoRecovery =>
      'Ez dago Drive-n kopiarik ezta babeskopia lokalik ere gordetze hau berreskuratzeko.';

  @override
  String get deleteOptionLocalOnly => 'Gailu honetatik bakarrik';

  @override
  String get deleteOptionDriveOnly => 'Nire Drive-tik bakarrik';

  @override
  String get deleteOptionBoth => 'Bi kopietatik';

  @override
  String get viewPlayersHint => 'Ikusi jokalariak';

  @override
  String snackDeletedBoth(String saveName) {
    return '\"$saveName\" gailu honetatik ezabatu da eta Drive Zaborrera mugitu da.';
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
  String get hiwConnectTitle => 'Konektatu zure kontua';

  @override
  String get hiwConnectDesc =>
      'ValleySave-k zure Google kontua erabiltzen du zure gordetzeak zure Drive-eko ValleySave karpeta pribatuan gordetzeko.';

  @override
  String get hiwConnectStepGoogle => 'Google\nkontua';

  @override
  String get hiwConnectStepDrive => 'ValleySave karpeta\nsortuta';

  @override
  String get hiwConnectStepReady => 'Prest\nsinkronizatzeko';

  @override
  String get hiwConnectTipOwnership =>
      'Zuk bakarrik editatu edo ezaba ditzakezu Drive-ko zure kopiak — ValleySave-k bere karpetaren barruan bakarrik irakurri eta idazten du.';

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
  String get overwriteWhatChanges => 'Zer aldatzen den';

  @override
  String get overwriteTagOverwritten => 'GAINIDATZIKO DA';

  @override
  String get overwriteNewCopyTag => 'BERRIA';

  @override
  String overwriteDeltaPhrase(int days, String time) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: '$days egun eta $time',
      one: 'egun 1 eta $time',
      zero: '$time',
    );
    return '$_temp0';
  }

  @override
  String overwriteVerdictAhead(String delta) {
    return '$delta aurretik zoaz. Segurua da.';
  }

  @override
  String get overwriteVerdictMoneySpent =>
      '💰 Uneko dirua jaitsi da, baina aurrerapen orokorra aurrera doa — ziurrenik zerbaitetan gastatu duzu. Ez da benetako galera.';

  @override
  String overwriteVerdictNegligible(String delta) {
    return 'Aldaketa minimoa ($delta). Bi kopiek balio dute.';
  }

  @override
  String overwriteVerdictDanger(String delta, String target) {
    return '⚠️ $delta aurrerapen galduko duzu $target(e)n. Aztertu jarraitu aurretik.';
  }

  @override
  String get overwriteConfirmTitleUpload => 'Igoera baieztatu?';

  @override
  String get overwriteConfirmTitleDownload => 'Deskarga baieztatu?';

  @override
  String overwriteConfirmBody(String delta, String target) {
    return '$delta galduko duzu $target(e)n. Ekintza hau ezin da desegin.';
  }

  @override
  String get overwriteConfirmButtonUpload => 'Igoera baieztatu';

  @override
  String get overwriteConfirmButtonDownload => 'Deskarga baieztatu';

  @override
  String get overwriteDangerButtonUpload => '⚠️ Igo dena den';

  @override
  String get overwriteDangerButtonDownload => '⚠️ Deskargatu dena den';

  @override
  String overwriteIdenticalSummary(int count, String list) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '✓ $count berdinak',
      one: '✓ 1 berdina',
    );
    return '$_temp0 — $list';
  }

  @override
  String overwriteUploadToOwner(String email) {
    return 'Igo $email(r)en Drive-ra';
  }

  @override
  String get overwriteUploadBoth => 'Igo bi Drive-etara';

  @override
  String get overwriteConfirmTitleBoth => 'Bi igoerak baieztatu?';

  @override
  String overwriteConfirmBodyBoth(String delta, String targets) {
    return '$delta galduko duzu $targets(e)n. Ekintza hau ezin da desegin.';
  }

  @override
  String overwriteBothDestinationsLabel(String first, String second) {
    return '$first eta $second';
  }

  @override
  String get sharedTargetOwnDrive => 'zure Drive-a';

  @override
  String sharedStatusLocalAhead(String targets) {
    return '$targets(e)n aurretik zoaz';
  }

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
      'Ezin izan da gordetzea prestatu. Ez da ezer aldatu diskoan';

  @override
  String get snackReplaceValidationFailed =>
      'Deskargatutako gordetzea baliogabea edo osatugabea dirudi. Ez da ezer aldatu diskoan';

  @override
  String get snackReplaceBackupFailed =>
      'Ezin izan da babeskopia sortu. Ez da ezer aldatu diskoan';

  @override
  String get snackReplaceSwapFailed =>
      'Trukeak huts egin du, baina jatorrizko gordetzea babeskopiatik leheneratu da';

  @override
  String get snackReplaceBusy =>
      'Dagoeneko eragiketa bat martxan dago gordetze honentzat';

  @override
  String get snackUploadIncomplete =>
      'Gordetze lokala osatugabea edo hondatuta dago. Ez da ezer igo';

  @override
  String get snackDownloadIncomplete =>
      'Ezin da deskargatu: Drive-en edukia falta zaio';

  @override
  String get cardIncomplete => 'Osatu gabea Drive-n';

  @override
  String get autoRefreshTitle => 'Berritze automatikoa';

  @override
  String get autoRefreshSubtitle =>
      'Drive-eko aldaketak egiaztatzen ditu 30 segundotik behin';

  @override
  String autoSyncSnack(String farmName) {
    return '$farmName automatikoki sinkronizatu da';
  }

  @override
  String get autoSyncTooltipOn =>
      'Sinkronizazio automatikoa piztuta — bakarrik sinkronizatzen da segurua denean';

  @override
  String get autoSyncTooltipOff =>
      'Sinkronizazio automatikoa itzalita — sakatu pizteko';

  @override
  String get autoSyncExplainTitle => 'Sinkronizazio automatikoa';

  @override
  String autoSyncExplainBody(String farmName) {
    return 'Hemendik aurrera, $farmName bere kabuz igo edo deskargatuko da segurua denean, zuri berrespenik eskatu gabe.';
  }

  @override
  String get autoSyncExplainSafe =>
      'Argi eta garbi aurretik zoazenean eta ezer galtzen ez denean bakarrik jarduten du.';

  @override
  String get autoSyncExplainDanger =>
      'Aurrerapena galtzeko arriskurik balego, inoiz ez du bere kabuz jarduten: zuk erabakiko duzu beti ohiko elkarrizketa-koadroaren bidez.';

  @override
  String get autoSyncExplainMissing =>
      'Bi kopietako bat falta bada, ez du bere kabuz sortzen: lehen igoera edo deskarga zuk erabakitzen duzu.';

  @override
  String get autoSyncExplainDontShowAgain => 'Ez erakutsi abisu hau berriro';

  @override
  String get autoSyncExplainConfirm => 'Ulertuta, aktibatu';

  @override
  String get hiwAutoSyncTitle => 'Bere kabuz sinkronizatu';

  @override
  String get hiwAutoSyncDesc =>
      'Gordetze bakoitzak AUTO txartel bat du bere kartan. Piztutakoan, gordetze hori bere kabuz igo edo deskargatuko da aplikazioak aldaketa bat detektatzen duenean — sartu eta berresteko beharrik gabe.';

  @override
  String get hiwAutoSyncTipSafe =>
      'Argi eta garbi aurretik zoazenean eta ezer galtzen ez denean bakarrik sinkronizatzen da bere kabuz.';

  @override
  String get hiwAutoSyncTipDanger =>
      'Aurrerapena galtzeko arriskurik balego, inoiz ez du bere kabuz egiten: ohiko konparaketaren bidez galdetzen jarraituko dizu.';

  @override
  String get hiwAutoSyncTipPerSave =>
      'Gordetzez gordetze aktibatzen da, ez guztiak batera: zeurean piztuta eta partekatutako batean itzalita eduki dezakezu.';

  @override
  String get hiwAutoSyncTipMissing =>
      'Dagoeneko dauden bi kopiak sinkronizatuta mantentzen ditu bakarrik. Bat falta bada, lehen igoera edo deskarga zuk egiten duzu.';

  @override
  String get hiwAutoSyncTipRefresh =>
      'Ezarpenetan aldaketen egiaztapen automatikoa erabat itzali dezakezu.';

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
      'Gordetze batean \"Osatu gabea Drive-n\" ikusten baduzu, hodeian beharrezko fitxategiren bat falta zaio — ezin da deskargatu beste gailu batetik ondo berriro igo arte.';

  @override
  String get hiwShareTitle => 'Besteekin partekatu';

  @override
  String get hiwShareDesc =>
      'Partekatu gordetze bat beste jokalari batekin emailez. Bere gailuan Nirekin partekatuak atalean ikusiko du.';

  @override
  String get hiwShareStepYourSave => 'Zure\ngordetzea';

  @override
  String get hiwShareStepShare => 'Partekatu\nemailez';

  @override
  String get hiwShareStepFriend => 'Nirekin\npartekatuak';

  @override
  String get hiwShareTipRoles =>
      'Bi rol daude: Irakurtzeko soilik aukerak ikusi eta deskargatzeko aukera ematen du. Sinkronizatzea baimentzeak zure Drive-ko kopia gainidazteko aukera ematen du. Inoiz ere ezin dute ezabatu — zuk, jabeak, bakarrik ezaba dezakezu zure gordetzea.';

  @override
  String get hiwShareTipDisconnect =>
      'Deskonektatzeak bere aldeko sinkronizazioa gelditzen du soilik — partekatzeak aktibo jarraitzen du benetan Partekatuak kudeatu ataletik uzten duzun arte.';

  @override
  String get hiwHostSwapTitle => 'Ostalari aldaketa';

  @override
  String get hiwHostSwapDesc =>
      'Aldatu zein farmhand den gordetzearen ostalaria, tokian bertan ordeztuz — gorde-toki bera, partekatze-baimen berak.';

  @override
  String get hiwHostSwapStepPick => 'Aukeratu\nfarmhand-a';

  @override
  String get hiwHostSwapStepConfirm => 'Berretsi';

  @override
  String get hiwHostSwapStepDone => 'Gordetze berria\nsortuta';

  @override
  String get hiwHostSwapTipMove =>
      'Baserriko objektu batzuk lekuz alda daitezke etxeari tokia egiteko — ezer ez da ezabatzen.';

  @override
  String get hiwHostSwapTipHouse =>
      'Ostalari berriaren etxea jokoaren lehenetsitako etxe handia bezala ikusiko da — etxolaren itxura ez da onartzen modrik gabe.';

  @override
  String get hiwBackupsTitle => 'Babeskopiak';

  @override
  String get hiwBackupsDesc =>
      'Babeskopia bat gero leheneratu dezakezun gordetze baten argazkia da. Sortu eskuz nahi duzunean, edo utzi ValleySave-ri automatikoki sortzen gordetze bat gainidatzi aurretik (deskargatzean, inportatzean, leheneratzean edo ostalaria aldatzean).';

  @override
  String get hiwBackupsStepSave => 'Zure\ngordetzea';

  @override
  String get hiwBackupsStepSnapshot => 'Babeskopia\nsortuta';

  @override
  String get hiwBackupsStepStore => 'Lokala eta/edo\nDrive';

  @override
  String get hiwBackupsTipRestore =>
      'Leheneratzeak zure uneko gordetzea aurreko bertsio horrekin gainidazten du — ezin da desegin.';

  @override
  String get hiwBackupsTipDelete =>
      'Babeskopia bat ezabatzeak existitzen den leku guztietatik kentzen du (gailu hau eta Drive, igo bada) — ezin da desegin.';

  @override
  String get hiwBackupsTipExport =>
      'Gordetze bat Zip gisa Esportatu ere badezakezu nahi duzun tokian gordetzeko, eta gero berriro Inportatu — barneko babeskopien eskuzko eta eramangarria den alternatiba bat.';

  @override
  String get hiwBackupsTipRetention =>
      'ValleySave-k gordetze bakoitzeko azken 5 babeskopia automatikoak gordetzen ditu; eskuz sortzen dituzunak inoiz ez dira bakarrik ezabatzen.';

  @override
  String get hiwBackupsTipRestoreBridge =>
      'Zubi moduan (Android root/Shizuku gabe), babeskopia bat leheneratzeak .zip-a eskuz Stardew karpetan ateratzeko eskatzen dizu — deskargatzean bezala.';

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
      'Linux-en, jokoa automatikoki detektatzen ez bada, konfiguratu exekutagarriaren bidea Ezarpenak → Jokoa atalean.';

  @override
  String get hiwSaveLocationsTitle => 'Non bizi diren zure gordetzeak';

  @override
  String get hiwSaveLocationsDesc =>
      'ValleySave-k zuzenean irakurtzen eta idazten du jokoaren gordetze-karpetan plataforma bakoitzean.';

  @override
  String get hiwSaveLocationWindows =>
      'Windows: %AppData%\\StardewValley\\Saves';

  @override
  String get hiwSaveLocationAndroid =>
      'Android: babestutako karpeta, Shizuku edo Zubiaren bidez atzitzen da';

  @override
  String get hiwSaveLocationLinux =>
      'Linux: ~/.config/StardewValley/Saves (edo ~/snap/steam/common/.config/StardewValley/Saves Steam snap bidez instalatuta badago)';

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

  @override
  String get makeHostDeleteOriginalTitle =>
      'Jatorrizko partida gailu honetatik ezabatu?';

  @override
  String get makeHostDeleteOriginalBody =>
      'Partida berria prest dago. Igo jatorrizkoa zure Drive-ra babeskopia gisa (gero berriz deskarga dezakezu), edo ezabatu kopia lokala soilik.';

  @override
  String get makeHostDeleteOriginalNoBackupBody =>
      'Driverekin konexiorik ez: ez da babeskopiarik geratuko. Gailu honetako kopia lokala bakarrik ezabatuko da.';

  @override
  String get makeHostDeleteOriginalUploadBody =>
      'Jatorrizko partida zure Drive-ra igoko da lehenik babeskopia gisa, eta gero gailu honetako kopia lokala ezabatuko da.';

  @override
  String get makeHostDeleteWithoutUpload => 'Ezabatu igo gabe';

  @override
  String get makeHostUploadAndDelete => 'Igo eta ezabatu';

  @override
  String get updateCheckFailed => 'Ezin izan da egiaztatu';

  @override
  String get updateCheckFailedRetry => 'Sakatu berriro saiatzeko';
}
