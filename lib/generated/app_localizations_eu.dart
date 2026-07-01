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
  String get disconnectTitle => 'Drive deskonektatu?';

  @override
  String get disconnectBody =>
      'Drive-eko zure gordetzeek ez dira ezabatuko. Noiznahi berkonektatu zaitezke.';

  @override
  String get disconnectButton => 'Drive deskonektatu';

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
}
