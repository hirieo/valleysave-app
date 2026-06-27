// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Spanish Castilian (`es`).
class AppLocalizationsEs extends AppLocalizations {
  AppLocalizationsEs([String locale = 'es']) : super(locale);

  @override
  String get appTitle => 'ValleySave';

  @override
  String get welcomeTitle => 'Nunca pierdes tu granja, llévala contigo.';

  @override
  String get connectGoogleDrive => 'Conectar Google Drive';

  @override
  String get connecting => 'Conectando…';

  @override
  String get mySaves => 'Mis partidas';

  @override
  String get howItWorks => 'Cómo funciona';

  @override
  String get settings => 'Ajustes';

  @override
  String get aboutSection => 'Acerca de';

  @override
  String get openSource => 'Código disponible';

  @override
  String get nonCommercial => 'No comercial';

  @override
  String get freeForever => 'Gratis para siempre';

  @override
  String get privacyTitle => 'Privacidad y uso de datos';

  @override
  String get privacyDescription =>
      'ValleySave es una app para sincronizar tus partidas de Stardew Valley con tu propia cuenta de Google Drive.';

  @override
  String get whatDataTitle => 'Qué datos usa';

  @override
  String get whatDataDesc =>
      'ValleySave accede únicamente a los archivos de guardado de Stardew Valley necesarios para hacer copias, sincronizarlas o restaurarlas.';

  @override
  String get googleDriveTitle => 'Google Drive';

  @override
  String get googleDriveDesc =>
      'Tus partidas se suben a tu propia cuenta de Google Drive. ValleySave no usa servidores propios para guardar tus partidas.';

  @override
  String get androidPermissionsTitle => 'Permisos en Android';

  @override
  String get androidPermissionsDesc =>
      'ValleySave puede necesitar permisos de almacenamiento o herramientas como Shizuku para acceder a los archivos de guardado.';

  @override
  String get adsTitle => 'Anuncios';

  @override
  String get adsDesc =>
      'ValleySave puede mostrar anuncios mediante Google AdMob.';

  @override
  String get responsibilityTitle => 'Responsabilidad';

  @override
  String get responsibilityDesc =>
      'Tus archivos de guardado son responsabilidad tuya.';

  @override
  String get deleteDataTitle => 'Eliminar datos';

  @override
  String get deleteDataDesc =>
      'Puedes borrar tus copias sincronizadas eliminando la carpeta ValleySave de Google Drive.';

  @override
  String get sourceCodeTitle => 'Código fuente y contacto';

  @override
  String get sourceCodeDesc =>
      'ValleySave es un proyecto de código disponible bajo licencia Polyform Noncommercial.';

  @override
  String get upToDate => 'Al día';

  @override
  String get checkingUpdates => 'Buscando…';

  @override
  String get updateAvailable => 'Actualización disponible';

  @override
  String get application => 'Aplicación';

  @override
  String version(Object version) {
    return 'Versión $version';
  }

  @override
  String get checkForUpdates => 'Buscar actualizaciones';

  @override
  String get shizukuRequired => 'Shizuku requerido';

  @override
  String get shizukuGuide => 'Guía de configuración de Shizuku';

  @override
  String get activateShizuku =>
      'Activa Shizuku para escribir el save en el juego.';

  @override
  String deleteSaveTitle(Object saveName) {
    return 'Eliminar $saveName';
  }

  @override
  String get deleteSaveMessage =>
      'Esto eliminará la partida de este dispositivo. ¿Deseas continuar?';

  @override
  String get deleteFromDrive => 'Eliminar de Drive';

  @override
  String confirmDelete(Object saveName) {
    return 'La partida $saveName se moverá a la Papelera de Google Drive.';
  }

  @override
  String deleteFromDeviceMessage(Object saveName) {
    return 'La partida $saveName se eliminará permanentemente de este dispositivo.';
  }

  @override
  String restoreSaveTitle(Object saveName) {
    return 'Restaurar $saveName';
  }

  @override
  String restoreSaveMessage(Object saveName) {
    return '¿Descargar $saveName a este dispositivo?';
  }

  @override
  String get restore => 'Restaurar';

  @override
  String get cancel => 'Cancelar';

  @override
  String get error => 'Error';

  @override
  String get success => 'Éxito';

  @override
  String get loading => 'Cargando…';

  @override
  String get disconnect => 'Desconectar';

  @override
  String get ok => 'OK';

  @override
  String get yes => 'Sí';

  @override
  String get no => 'No';

  @override
  String get welcomeHeroPre => 'Nunca pierdas\ntu ';

  @override
  String get welcomeHeroAccent => 'granja,';

  @override
  String get welcomeHeroPost => '\nllévala contigo.';

  @override
  String get welcomeSubtitle =>
      'Sincroniza tus saves de Stardew Valley entre todos tus dispositivos. Tus datos viven en tu Google Drive — sin servidores propios, sin suscripciones, bajo tu control.';

  @override
  String get welcomeDriveConnected => 'Drive conectado';

  @override
  String get welcomeFooterTagline => '· No comercial · Gratis para siempre ·';

  @override
  String updateVersionAvailable(String version) {
    return 'v$version disponible';
  }

  @override
  String get sectionMode => 'Modo';

  @override
  String get sectionSeason => 'Estación';

  @override
  String get sectionLanguage => 'Idioma';

  @override
  String get modeAutoTitle => 'Automático';

  @override
  String get modeAutoDesc =>
      'Sigue tu partida activa y, sin partidas, tu ubicación real.';

  @override
  String get modeSavesTitle => 'Según partida';

  @override
  String get modeSavesDesc =>
      'Usa siempre la estación de tu partida más reciente.';

  @override
  String get modeGeoTitle => 'Según ubicación';

  @override
  String get modeGeoDesc => 'Usa siempre la estación real de tu ubicación.';

  @override
  String get modeFixedTitle => 'Fijar estación';

  @override
  String get modeFixedDesc => 'Muestra siempre la misma estación.';

  @override
  String get modeRandomTitle => 'Aleatoria';

  @override
  String get modeRandomDesc => 'Elige una estación diferente al abrir la app.';

  @override
  String get seasonInitial => 'Inicial';

  @override
  String get seasonSpring => 'Primavera';

  @override
  String get seasonSummer => 'Verano';

  @override
  String get seasonFall => 'Otoño';

  @override
  String get seasonWinter => 'Invierno';

  @override
  String get autoPriorityTitle => 'Orden de prioridad';

  @override
  String get autoStep1Title => 'Primera apertura';

  @override
  String get autoStep1Desc => 'Muestra el estado inicial.';

  @override
  String get autoStep2Title => 'Partida activa';

  @override
  String get autoStep2Desc =>
      'Usa la estación de tu última partida sincronizada.';

  @override
  String get autoStep3Title => 'Ubicación';

  @override
  String get autoStep3Desc =>
      'Detecta tu hemisferio y la estación real de tu región.';

  @override
  String get autoStep4Title => 'Por defecto';

  @override
  String get autoStep4Desc =>
      'Inicial (modo nocturno) si no hay ningún dato disponible.';

  @override
  String get versionInstalled => 'Versión instalada';

  @override
  String get updateNeverChecked => 'Nunca comprobado';

  @override
  String get updateCheckedNow => 'Comprobado ahora';

  @override
  String get updateOutdatedDownload => 'No está al día · Descargar';

  @override
  String get disconnectTitle => '¿Desconectar Drive?';

  @override
  String get disconnectBody =>
      'Tus saves en Drive no se borran. Podrás reconectarte cuando quieras.';

  @override
  String get disconnectButton => 'Desconectar Drive';

  @override
  String get languageTileLabel => 'Idioma';

  @override
  String get languageDialogTitle => 'Idioma de la app';

  @override
  String get searchHint => 'Buscar…';

  @override
  String get languageAuto => 'Auto · sistema';

  @override
  String get languageAutoDesc => 'Usa el idioma del sistema';

  @override
  String get privacyPolicyTitle => 'Política de uso';

  @override
  String get privacyBeforeStartTitle => 'Antes de empezar';

  @override
  String get privacyLastUpdated => 'Última actualización: junio 2026';

  @override
  String get privacyAccept => 'Entendido, continuar';

  @override
  String get cardSynced => 'Sincronizado';

  @override
  String get cardLocalAhead => 'Local más avanzada';

  @override
  String get cardDriveAhead => 'Drive más avanzada';

  @override
  String get cardLocalOnly => 'Solo en este equipo';

  @override
  String get cardDriveOnly => 'Solo en Drive';

  @override
  String get cardTimeNow => 'ahora';

  @override
  String cardTimeMinutesAgo(int minutes) {
    return 'hace $minutes min';
  }

  @override
  String cardTimeHoursAgo(int hours) {
    return 'hace $hours h';
  }

  @override
  String cardTimeDaysAgo(int days) {
    return 'hace $days d';
  }

  @override
  String cardTimeMonthsAgo(int months, String plural) {
    return 'hace $months mes$plural';
  }

  @override
  String get cardDetailLocalTitle => 'En este equipo';

  @override
  String get cardDetailRemoteTitle => 'En Drive';

  @override
  String get cardDetailUpload => 'Subir a Drive';

  @override
  String get cardDetailDownload => 'Descargar partida';

  @override
  String get cardDetailDeleteLabel => 'Eliminar';

  @override
  String get cardDetailDeleteLocal => 'Eliminar de este equipo';

  @override
  String get cardDetailDeleteRemote => 'Eliminar de Drive';

  @override
  String get cardCloseBarrier => 'Cerrar';

  @override
  String statDayYear(int day, int year) {
    return 'Día $day · Año $year';
  }

  @override
  String statDayOnly(int day) {
    return 'Día $day';
  }

  @override
  String get statPlaytime => 'Tiempo jugado';

  @override
  String get statMoney => 'Monedas';

  @override
  String get statTotal => 'Total';

  @override
  String get statMineUnexplored => 'Sin explorar';

  @override
  String get statMine => 'Mina';

  @override
  String get statMineLvl => 'Mina · Nv';

  @override
  String get skillFarming => 'Cultivo';

  @override
  String get skillForaging => 'Recolec.';

  @override
  String get skillMining => 'Minería';

  @override
  String get skillFishing => 'Pesca';

  @override
  String get skillCombat => 'Combate';

  @override
  String get cardLocalPresence => 'EN ESTE EQUIPO';

  @override
  String get cardRemotePresence => 'EN DRIVE';

  @override
  String get cardNotPresent => 'No está aquí';

  @override
  String get cardActionSynced => 'Sincronizado';

  @override
  String get cardActionUpload => 'Subir';

  @override
  String get cardActionDownload => 'Descargar';

  @override
  String get pillMonsters => 'monstruos';

  @override
  String get pillFriends => 'amigos';

  @override
  String get pillFaints => 'desmayos';

  @override
  String get hiwTitle => 'Cómo funciona';

  @override
  String get hiwSyncTitle => 'Cómo se sincroniza';

  @override
  String get hiwSyncIntro =>
      'ValleySave usa tu propio Google Drive para mover partidas entre dispositivos. No hay servidores intermedios: los archivos son tuyos.';

  @override
  String get hiwSyncDevice => 'Tu\ndispositivo';

  @override
  String get hiwSyncCloud => 'Google\nDrive';

  @override
  String get hiwSyncOtherDevice => 'Otro\ndispositivo';

  @override
  String get hiwUploadTitle => 'Subir una partida';

  @override
  String get hiwUploadDesc =>
      'Al subir, ValleySave copia los dos archivos del save (SaveGameInfo + archivo de granja) a tu carpeta ValleySave/ en Drive.';

  @override
  String get hiwDownloadTitle => 'Descargar una partida';

  @override
  String get hiwDownloadDesc =>
      'Al descargar, ValleySave trae los archivos de Drive y los coloca directamente en la carpeta del juego.';

  @override
  String get hiwCompareTitle => '¿Qué se compara?';

  @override
  String get hiwCompareIntro =>
      'Para saber qué versión va más adelante, ValleySave usa el tiempo total jugado — el único dato que solo puede crecer.';

  @override
  String get hiwCompareNote =>
      'Antes de confirmar también verás, para que lo valores tú:';

  @override
  String get hiwCompareMoney => 'Dinero actual y total ganado';

  @override
  String get hiwCompareMine => 'Nivel de la mina';

  @override
  String get hiwCompareSkills => 'Habilidades (cultivo, minería, combate…)';

  @override
  String get hiwCompareRelations => 'Amigos, monstruos eliminados, desmayos';

  @override
  String get hiwCompareStamina => 'Stamina y salud';

  @override
  String get hiwCompareNotShown =>
      'Estos no se muestran — cambian en cualquier dirección y no indican cuál save va más adelante.';

  @override
  String get hiwCompareNotShownExamples =>
      'Estado de cultivos y animales, inventario y objetos, relaciones individuales';

  @override
  String get hiwCompareWarning =>
      'Estos no se muestran — cambian en cualquier dirección y no indican cuál save va más adelante.';

  @override
  String get hiwConflictTitle => 'Si juegas sin sincronizar';

  @override
  String get hiwConflictDesc =>
      'Si avanzas en el móvil y en el PC sin sincronizar entre sesiones, acabas con dos versiones distintas del mismo save.';

  @override
  String get hiwConflictNoMerge =>
      'No se pueden mezclar. ValleySave siempre te muestra ambas versiones para que elijas cuál conservar.';

  @override
  String get hiwConflictMobile => 'Móvil';

  @override
  String get hiwConflictVersionA => 'versión A';

  @override
  String get hiwConflictPC => 'PC';

  @override
  String get hiwConflictVersionB => 'versión B';

  @override
  String get hiwDeleteTitle => 'Si se borra una partida';

  @override
  String get hiwDeleteDesc =>
      'Al eliminar una partida de Drive, no desaparece inmediatamente: va a la Papelera de Google Drive.';

  @override
  String get hiwCompatTitle => 'Compatibilidad entre plataformas';

  @override
  String get hiwCompatAndroidAccess => 'ACCESO EN ANDROID';

  @override
  String get hiwShizukuTitle => 'Con Shizuku';

  @override
  String get hiwShizukuSubtitle =>
      'Se configura una sola vez. Después ValleySave sincroniza sola, sin que toques nada nunca más.';

  @override
  String get hiwShizukuBadge => 'AUTOMÁTICO · RECOMENDADO';

  @override
  String get hiwShizukuDone =>
      '✓  Listo. A partir de ahí, descargar y subir partidas es directo, igual que en el ordenador.';

  @override
  String get hiwShizukuNote =>
      'El emparejamiento es solo la primera vez. Las versiones nuevas de Shizuku se reactivan solas tras reiniciar el móvil.';

  @override
  String get hiwBridgeTitle => 'Puente manual';

  @override
  String get hiwBridgeSubtitle =>
      'Solo funciona en Android 11 y 12. No instalas nada extra; a cambio, copias la partida a mano con tu app de Archivos cada vez que sincronizas.';

  @override
  String get hiwBridgeBadge => 'ALTERNATIVA MANUAL · ANDROID 11-12';

  @override
  String get hiwBridgeSaveFolder => 'Carpeta de Stardew';

  @override
  String get hiwBridgeValleySaveFolder => 'Carpeta de ValleySave';

  @override
  String get hiwBridgeNote =>
      'Funciona porque tu app de Archivos del sistema sí puede entrar en esas carpetas (ValleySave no).';

  @override
  String get hiwTipAlwaysShow => 'Siempre se te muestra qué hay en Drive...';

  @override
  String get hiwTipWithoutUpload => 'Sin subir, ningún otro dispositivo...';

  @override
  String get hiwTipComparison => 'Verás la comparación entre local y Drive...';

  @override
  String get hiwTipDownloadOverwrite =>
      'Descargar sobrescribe tu partida local...';

  @override
  String get hiwTipSync => 'Sube siempre antes de cambiar de dispositivo...';

  @override
  String get hiwTipDeletion =>
      'Las partidas eliminadas van a la Papelera de Drive...';

  @override
  String get hiwPrivacyLink => 'Política de privacidad y uso';

  @override
  String get emptyNoSaves => 'No se encontraron partidas';

  @override
  String get emptyNoSavesHint => 'En este dispositivo no se leen saves locales';

  @override
  String get bridgeTitle => 'Trae tus partidas';

  @override
  String get bridgeDesc =>
      'Para ver y subir tus partidas locales, cópialas con tu app de Archivos desde la carpeta de Stardew a esta carpeta de ValleySave. Luego desliza para refrescar.';

  @override
  String get bridgeRefresh => 'Refrescar';

  @override
  String get bridgeChangeMode => 'Cambiar método';

  @override
  String get loaderLoading => 'CARGANDO';

  @override
  String get loaderConnecting => 'conectando con Drive…';

  @override
  String get chooserTitle => 'Elige cómo conectar';

  @override
  String get chooserAutomatic => 'Automático · Recomendado';

  @override
  String get chooserManual => 'Alternativa manual · Android 11-12';

  @override
  String get shizukuStepTitle => 'Configura Shizuku';

  @override
  String get shizukuStep1Title => 'Instala Shizuku';

  @override
  String get shizukuStep1Desc => 'Descarga de Play Store o GitHub';

  @override
  String get shizukuStep2Title => 'Activa Shizuku';

  @override
  String get shizukuStep2Desc => 'Abre la app y concede permisos';

  @override
  String get shizukuStep3Title => 'Concede permiso';

  @override
  String get shizukuStep3Desc => 'ValleySave pedirá acceso';

  @override
  String get shizukuDone =>
      '✓  Listo. A partir de ahí, descargar y subir partidas es directo, igual que en el ordenador.';

  @override
  String get dlgDeleteDriveTitle => 'Eliminar de Drive';

  @override
  String get dlgDeleteLocalTitle => 'Eliminar de este equipo';

  @override
  String get dlgDownloadTitle => 'Descargar partida';

  @override
  String get dlgUploadTitle => 'Subir partida';

  @override
  String get dlgUploadOverwrite => 'Esto sobrescribirá tu partida local';

  @override
  String get dlgGotIt => 'Entendido';

  @override
  String get dlgCopyDest => 'Copiar destino';

  @override
  String get previewColDayYear => 'Día/Año';

  @override
  String get previewColTime => 'Tiempo jugado';

  @override
  String get previewColMoney => 'Monedas';

  @override
  String get previewColTotal => 'Total';

  @override
  String get previewColFarming => 'Cultivo';

  @override
  String get previewColForaging => 'Recolec.';

  @override
  String get previewColMining => 'Minería';

  @override
  String get previewColFishing => 'Pesca';

  @override
  String get previewColCombat => 'Combate';

  @override
  String get previewColFriends => 'Amigos';

  @override
  String get previewColMonsters => 'Monstruos';

  @override
  String get previewColFaints => 'Desmayos';

  @override
  String get previewColMine => 'Mina';

  @override
  String get previewColUnexplored => 'Sin explorar';

  @override
  String get previewLocalLabel => 'EN ESTE EQUIPO';

  @override
  String get previewDriveLabel => 'EN DRIVE';

  @override
  String get previewFromDrive => 'DESDE DRIVE';

  @override
  String get previewFromDevice => 'DESDE ESTE EQUIPO';

  @override
  String versionMismatch(String local, String drive) {
    return 'Versiones distintas: local $local · Drive $drive…';
  }

  @override
  String get snackPathCopied => 'Ruta copiada';

  @override
  String get snackDestCopied => 'Ruta de destino copiada';

  @override
  String get snackDownloaded => 'Partida descargada en el juego';

  @override
  String get snackSessionExpired =>
      'La sesión de Drive ha caducado. Vuelve a conectar';

  @override
  String snackUploadError(String error) {
    return 'Error al subir: $error';
  }

  @override
  String snackDownloadError(String error) {
    return 'Error al descargar: $error';
  }

  @override
  String snackDeleteError(String error) {
    return 'Error al eliminar: $error';
  }

  @override
  String snackTrashed(String saveName) {
    return '\"$saveName\" movida a la Papelera de Drive. Tienes 30 días para restaurarla.';
  }

  @override
  String snackDeletedLocal(String saveName) {
    return '\"$saveName\" eliminada de este equipo';
  }

  @override
  String get snackShizukuRequired => 'Activa Shizuku…';

  @override
  String get snackWriteError => 'No se pudo escribir en el juego…';

  @override
  String get snackPlatformNotSupported => 'Esta plataforma no permite…';
}
