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
  String get welcomeTitle => 'Nunca pierdas tu granja, llévala contigo.';

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
  String get updateCheckedNow => 'Recién comprobado';

  @override
  String get updateOutdatedDownload => 'No está al día · Descargar';

  @override
  String get updateDownloading => 'Descargando actualización…';

  @override
  String get updateError => 'Error — toca para reintentar';

  @override
  String get updateNeedsPermission =>
      'Activa \"instalar apps desconocidas\" para ValleySave y toca Actualizar otra vez';

  @override
  String get disconnectTitle => '¿Desconectar Drive?';

  @override
  String disconnectBody(String email) {
    return 'Se cerrará la sesión de $email. Tus saves en Drive no se borran, puedes reconectar cuando quieras.';
  }

  @override
  String get disconnectButton => 'Desconectar Drive';

  @override
  String disconnectButtonEmail(String email) {
    return 'Desconectar de $email';
  }

  @override
  String get connectedAsPrefix => 'Conectado en';

  @override
  String get languageTileLabel => 'Idioma';

  @override
  String get languageDialogTitle => 'Idioma de la app';

  @override
  String get searchHint => 'Buscar…';

  @override
  String get languageAuto => 'Idioma del sistema';

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
  String cardTimeMonthsAgo(int months) {
    return 'hace $months mes';
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
  String get cardDetailDeleteRemote => 'Borrar de mi Drive';

  @override
  String get cardCloseBarrier => 'Cerrar';

  @override
  String get exportAction => 'Exportar';

  @override
  String get exportSuccess => 'Partida exportada.';

  @override
  String exportError(String error) {
    return 'No se pudo exportar la partida: $error';
  }

  @override
  String get importAction => 'Importar partida';

  @override
  String importSuccess(String playerName) {
    return 'Partida de $playerName importada.';
  }

  @override
  String get importErrInvalidZip => 'Este archivo no es un zip válido.';

  @override
  String get importErrUnsafePath =>
      'Este archivo tiene una estructura insegura y se ha rechazado.';

  @override
  String get importErrTooLarge =>
      'Este archivo es demasiado grande para importarlo.';

  @override
  String get importErrNotASave =>
      'Este archivo no contiene una partida reconocible.';

  @override
  String get importErrWrite =>
      'No se pudo escribir la partida importada (disco/permisos).';

  @override
  String get importErrBackupFailed =>
      'No se pudo crear una copia de seguridad. No se importó nada.';

  @override
  String get importConflictTitle => 'Ya existe una partida con este nombre';

  @override
  String get importConflictBody =>
      'Importar reemplazará la copia local existente. No se puede deshacer.';

  @override
  String get importConflictConfirm => 'Sobrescribir';

  @override
  String get shareAction => 'Compartir';

  @override
  String get shareUploadFirstCta => 'Subir primero';

  @override
  String get shareDialogTitle => 'Compartir partida';

  @override
  String get shareEmailPlaceholder => 'nombre@ejemplo.com';

  @override
  String get shareInfoNote =>
      'Compartir da acceso de ver y descargar. Solo tú puedes editar o borrar tu copia en Drive.';

  @override
  String get shareRoleReader => 'Solo lectura';

  @override
  String get shareRoleWriter => 'Permitir sincronizar';

  @override
  String get shareInfoNoteCoop =>
      'Solo lectura permite ver y descargar. Permitir sincronizar permite sobrescribir tu copia en Drive — nunca podrán borrarla.';

  @override
  String get shareConfirmButton => 'Compartir';

  @override
  String shareSuccess(String email) {
    return 'Compartido con $email.';
  }

  @override
  String get manageAccessTitle => 'Personas con acceso';

  @override
  String get manageAccessEmpty => 'Nadie más tiene acceso todavía.';

  @override
  String get manageAccessRoleLabel => 'Acceso';

  @override
  String get manageAccessRevoke => 'Revocar';

  @override
  String manageAccessRevokeConfirm(String email) {
    return '¿Quitar el acceso a $email? Cualquier copia local que ya se haya descargado sigue siendo suya.';
  }

  @override
  String get driveOnlyControlsYourCopy =>
      'Compartir controla tu copia en Drive. Si alguien la descarga, esa copia es suya.';

  @override
  String get driveOnlyControlsYourCopyCoop =>
      'Sincronizar controla tu copia en Drive — se puede sobrescribir, pero nunca borrar, por quien autorices.';

  @override
  String get sharedWithMeTitle => 'Compartidas conmigo';

  @override
  String get sharedWithMeEmpty => 'Nada compartido contigo todavía.';

  @override
  String get sharedWithMeAdd => 'Añadir save compartido';

  @override
  String sharedWithMeOwnedBy(String email) {
    return 'Compartida por $email';
  }

  @override
  String get sharedWithMeRoleSync => 'Sincroniza';

  @override
  String get sharedWithMeRoleRead => 'Solo lectura';

  @override
  String get sharedWithMeSync => 'Sincronizar';

  @override
  String get sharedWithMeDownload => 'Descargar';

  @override
  String get sharedWithMeRemove => 'Desconectar';

  @override
  String sharedWithMeRemoveConfirm(String email) {
    return 'Ya no sincronizarás con el Drive de $email, pero puedes volver a añadirla cuando quieras — sigue compartida. Tu copia local se queda como una partida coop normal.';
  }

  @override
  String sharedLeaveConfirm(Object email) {
    return 'Perderás el acceso a esta partida de verdad. No podrás volver a añadirla salvo que $email vuelva a compartirla contigo. Tu copia local se queda como una partida coop normal.';
  }

  @override
  String get sharedManageButton => 'Administrar';

  @override
  String get sharedManageDialogTitle => 'Gestionar compartidas';

  @override
  String get sharedManageDialogHint =>
      'Aquí puedes salir de verdad de una partida compartida.';

  @override
  String get sharedLeaveButton => 'Salir del compartido';

  @override
  String sharedLeaveSuccess(Object email) {
    return 'Has salido del compartido de $email.';
  }

  @override
  String sharedWithMeSyncConfirm(String email) {
    return '¿Sobrescribir la copia de $email en Drive con tu partida local?';
  }

  @override
  String sharedAccessReadOnly(String email) {
    return '$email te ha puesto en modo solo lectura — puedes ver y descargar, pero no sincronizar hacia su Drive.';
  }

  @override
  String get sharedWithMeRevoked => 'Ya no tienes acceso';

  @override
  String sharedRevokedDialogBody(String email, String farmName) {
    return '$email ha dejado de compartir $farmName contigo. Tu copia local y la de tu Drive se quedan tal cual, ahora en Mis partidas.';
  }

  @override
  String get sharedRevokedAccept => 'Aceptar';

  @override
  String get sharedSelfCleanupTitle => 'Registro corregido';

  @override
  String sharedSelfCleanupBody(String farmName) {
    return '$farmName apareció como compartida contigo por error — en realidad es tuya. Se ha corregido, ahora está en Mis partidas.';
  }

  @override
  String get sharedWithMeUploadOwn => 'Subir a mi Drive';

  @override
  String get sharedDownloadOwn => 'Bajar de mi Drive';

  @override
  String get sharedStatusOwnDriveAhead => 'Tu Drive va por delante — bájalo';

  @override
  String get sharedSyncBoth => 'Sincronizar ambos';

  @override
  String get sharedSideMyDrive => 'MI DRIVE';

  @override
  String sharedSideOwnerDrive(String email) {
    return 'DRIVE EN $email';
  }

  @override
  String sharedSideDate(int day, int year) {
    return 'Día $day · Año $year';
  }

  @override
  String get sharedStatusSyncedNoOwnDrive =>
      'Sincronizado con el dueño · sin copia en tu Drive';

  @override
  String get sharedStatusAheadNoOwnDrive =>
      'Vas por delante · sin copia en tu Drive';

  @override
  String sharedStatusOwnerAheadNoOwnDrive(String email) {
    return '$email va por delante · sin copia en tu Drive';
  }

  @override
  String get sharedStatusAllSynced => 'Sincronizado (local + los dos Drive)';

  @override
  String get sharedStatusAheadBoth => 'Vas por delante en los dos Drive';

  @override
  String get sharedStatusMixed => 'Desincronizado — revisa cada Drive';

  @override
  String get sharedStatusFullySynced => 'Totalmente sincronizado';

  @override
  String get sharedStatusSyncedOwn => 'Sincronizado Mi Drive';

  @override
  String get sharedStatusSyncedOwner => 'Sincronizado compartido';

  @override
  String get sharedStatusNotCloud => 'Solo en este equipo';

  @override
  String sharedStatusOwnerAhead(Object email) {
    return 'Drive en $email va por delante';
  }

  @override
  String get sharedStatusBothAhead => 'Los dos Drive van por delante';

  @override
  String get sharedStatusLocalMissing => 'No está en este dispositivo';

  @override
  String sharedStatusOwnerUnavailable(Object email) {
    return 'No se pudo comprobar Drive en $email';
  }

  @override
  String get sharedStatusWorking => 'Sincronizando…';

  @override
  String get sharedSideUnavailable => 'No se pudo comprobar';

  @override
  String get sharedSyncChooseTitle => '¿Dónde quieres sincronizar?';

  @override
  String get sharedSyncChooseBody =>
      'Elige qué copias de la nube quieres actualizar con la partida de este dispositivo.';

  @override
  String get sharedSyncTargetOwn => 'Mi Drive';

  @override
  String sharedSyncTargetOwner(Object email) {
    return 'Drive en $email';
  }

  @override
  String get sharedSyncTargetBoth => 'Los dos Drive';

  @override
  String get sharedDownloadChooseTitle => '¿Qué copia quieres descargar?';

  @override
  String get sharedDownloadChooseBody =>
      'Hay más de una copia por delante. Elige cuál quieres traer a este dispositivo.';

  @override
  String get sharedDownloadSourceOwn => 'Desde Mi Drive';

  @override
  String sharedDownloadSourceOwner(Object email) {
    return 'Desde Drive en $email';
  }

  @override
  String get sharedWithMePickerTitle => 'Añadir save compartido';

  @override
  String get sharedPickerEmptyHint =>
      'Aquí aparece lo que otro jugador te comparta desde Drive.';

  @override
  String get sharedPickerAddButton => 'Añadir';

  @override
  String get sharedOriginBadge => 'Compartida';

  @override
  String sharedOriginFrom(String email) {
    return 'de $email';
  }

  @override
  String get swapBackupDialogTitle => 'Respaldo creado';

  @override
  String get swapBackupDialogBody =>
      'La versión anterior se guardó como zip. ¿Qué quieres hacer con ella?';

  @override
  String get swapBackupUpload => 'Subir a Drive';

  @override
  String get swapBackupLocalOnly => 'Mantener en este equipo';

  @override
  String get swapBackupDeleteNow => 'Borrar ahora';

  @override
  String get swapBackupUploadOk => 'Respaldo subido a Drive.';

  @override
  String swapBackupUploadErr(String error) {
    return 'No se pudo subir el respaldo: $error';
  }

  @override
  String get swapBackupLocalOnlySnack => 'Respaldo guardado en este equipo.';

  @override
  String get backupsAction => 'Backups';

  @override
  String backupsScreenTitle(String farmName) {
    return 'Respaldos de $farmName';
  }

  @override
  String get backupsEmpty => 'Sin respaldos todavía.';

  @override
  String get backupsRestore => 'Restaurar';

  @override
  String get backupsRestoreConfirmTitle => '¿Restaurar este respaldo?';

  @override
  String get backupsRestoreConfirmBody =>
      'Esto sobrescribe tu partida actual con esta versión anterior. No se puede deshacer.';

  @override
  String get backupsDelete => 'Eliminar';

  @override
  String get backupsDeleteConfirmTitle => '¿Eliminar este respaldo?';

  @override
  String get backupsDeleteConfirmBody =>
      'Se borra en todas las ubicaciones donde exista (este equipo y Drive, si se subió). No se puede deshacer.';

  @override
  String get backupsRestoreOk => 'Respaldo restaurado.';

  @override
  String get backupsRestoreManualTitle => 'Restaurar manualmente';

  @override
  String get backupsRestoreManualBody =>
      'En modo Puente, ValleySave no puede escribir en la carpeta del juego de forma automática. Extrae tú mismo el .zip de este respaldo en la carpeta Saves de Stardew Valley, o cambia a modo Root/Shizuku en Ajustes para restaurar de forma automática.';

  @override
  String backupsRestoreErr(String error) {
    return 'No se pudo restaurar el respaldo: $error';
  }

  @override
  String backupsDeleteErr(String error) {
    return 'No se pudo eliminar el respaldo: $error';
  }

  @override
  String get backupsCreate => 'Crear respaldo local';

  @override
  String get backupsCreateLocalHint =>
      'Los respaldos se crean primero en este equipo. Después podrás subirlos a Drive.';

  @override
  String get backupsCreateOk => 'Respaldo creado.';

  @override
  String backupsCreateErr(String error) {
    return 'No se pudo crear el respaldo: $error';
  }

  @override
  String get backupsDownload => 'Descargar';

  @override
  String get backupsDownloadOk => 'Respaldo descargado en este equipo.';

  @override
  String backupsDownloadErr(String error) {
    return 'No se pudo descargar el respaldo: $error';
  }

  @override
  String get backupsCopyOwn => 'Copiar a mi Drive';

  @override
  String get backupsUploadOwn => 'A mi Drive';

  @override
  String get backupsUploadShared => 'Al Drive compartido';

  @override
  String get backupsUploadOk => 'Respaldo subido.';

  @override
  String backupsUploadErr(String error) {
    return 'No se pudo subir el respaldo: $error';
  }

  @override
  String get backupsLocationLocal => 'Este equipo';

  @override
  String get backupsLocationOwnDrive => 'Mi Drive';

  @override
  String get backupsLocationSharedDrive => 'Drive compartido';

  @override
  String get backupsDeleteChooseBody =>
      'Elige exactamente dónde borrarlo. Solo aparecen las ubicaciones donde existe este respaldo.';

  @override
  String get backupsDeleteLocalOnly => 'Solo de este equipo';

  @override
  String get backupsDeleteOwnOnly => 'Solo de mi Drive';

  @override
  String get backupsDeleteSharedOnly => 'Solo del Drive compartido';

  @override
  String get backupsDeleteAll => 'De todas las copias';

  @override
  String deleteUnifiedTitle(String farmName) {
    return '¿Eliminar $farmName?';
  }

  @override
  String get deleteChooseLocationBody =>
      'Elige de dónde. La copia de este equipo se borra para siempre; la de Drive va a la papelera (30 días).';

  @override
  String deleteDriveContextTitle(String farmName) {
    return '¿Eliminar $farmName de Drive?';
  }

  @override
  String get deleteDriveContextBody =>
      'La copia de Drive irá a la papelera, donde podrás recuperarla durante 30 días.';

  @override
  String get deleteDriveLocalKept =>
      'La copia de este equipo se mantendrá sin cambios.';

  @override
  String deleteLocalContextTitle(String farmName) {
    return '¿Eliminar $farmName de este equipo?';
  }

  @override
  String get deleteLocalContextBody =>
      'La copia de este equipo se borrará para siempre.';

  @override
  String deleteLocalDriveCurrent(String date) {
    return 'Tu copia de Drive está actualizada ($date) y seguirá disponible.';
  }

  @override
  String deleteLocalDriveAhead(String date) {
    return 'Tu copia de Drive es más reciente ($date) y seguirá disponible.';
  }

  @override
  String deleteLocalDriveOlder(String driveDate, String localDate) {
    return 'Tu copia de Drive es anterior ($driveDate); este equipo está en $localDate.';
  }

  @override
  String deleteLocalBackupAvailable(int count) {
    return 'Hay $count respaldos locales disponibles por si necesitas una copia anterior.';
  }

  @override
  String get deleteLocalNoRecovery =>
      'No hay una copia en Drive ni un respaldo local desde el que recuperar esta partida.';

  @override
  String get deleteOptionLocalOnly => 'Solo de este equipo';

  @override
  String get deleteOptionDriveOnly => 'Solo de mi Drive';

  @override
  String get deleteOptionBoth => 'De ambas copias';

  @override
  String get viewPlayersHint => 'Ver jugadores';

  @override
  String snackDeletedBoth(String saveName) {
    return '\"$saveName\" eliminada de este equipo y movida a la papelera de Drive.';
  }

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
  String get cardLocalPresence => 'EN ESTE DISPOSITIVO';

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
  String get pillSleeps => 'Duerme';

  @override
  String get hiwTitle => 'Cómo funciona';

  @override
  String get hiwConnectTitle => 'Conectar tu cuenta';

  @override
  String get hiwConnectDesc =>
      'ValleySave usa tu cuenta de Google para guardar tus partidas en una carpeta privada de ValleySave en tu propio Drive.';

  @override
  String get hiwConnectStepGoogle => 'Cuenta de\nGoogle';

  @override
  String get hiwConnectStepDrive => 'Carpeta ValleySave\ncreada';

  @override
  String get hiwConnectStepReady => 'Listo para\nsincronizar';

  @override
  String get hiwConnectTipOwnership =>
      'Solo tú puedes editar o borrar tus copias en Drive — ValleySave solo lee y escribe dentro de su propia carpeta.';

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
  String get hiwTipAlwaysShow =>
      'Siempre se te muestra qué hay en Drive antes de sobrescribir, para que puedas comparar.';

  @override
  String get hiwTipWithoutUpload =>
      'Sin subir, ningún otro dispositivo verá tus avances recientes.';

  @override
  String get hiwTipComparison =>
      'Verás la comparación entre local y Drive antes de confirmar.';

  @override
  String get hiwTipDownloadOverwrite =>
      'Descargar sobrescribe tu partida local. Si tienes avances que no has subido, los perderás.';

  @override
  String get hiwTipSync =>
      'Sube siempre antes de cambiar de dispositivo y descarga al llegar.';

  @override
  String get hiwTipDeletion =>
      'Tienes 30 días para restaurarla desde la Papelera de Drive antes de que se elimine definitivamente.';

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
  String get snackReplacePrepareFailed =>
      'No se pudo preparar la partida. No se modificó nada en el disco';

  @override
  String get snackReplaceValidationFailed =>
      'La partida descargada parece inválida o incompleta. No se modificó nada en el disco';

  @override
  String get snackReplaceBackupFailed =>
      'No se pudo crear una copia de seguridad. No se modificó nada en el disco';

  @override
  String get snackReplaceSwapFailed =>
      'El intercambio falló, pero la partida original se restauró desde la copia de seguridad';

  @override
  String get snackReplaceBusy =>
      'Ya hay una operación en curso para esta partida';

  @override
  String get snackUploadIncomplete =>
      'La partida local está incompleta o dañada. No se subió nada';

  @override
  String get snackDownloadIncomplete =>
      'No se puede descargar: le falta contenido en Drive';

  @override
  String get cardIncomplete => 'Incompleta en Drive';

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
  String get snackWriteError =>
      'No se pudo escribir en el juego. Algunos móviles bloquean /Android/data aun con Shizuku.';

  @override
  String get snackPlatformNotSupported =>
      'Esta plataforma no permite escribir el save local todavía.';

  @override
  String get snackWirelessDebugHint =>
      'Ábrelo a mano: Ajustes → Opciones de desarrollador → Depuración inalámbrica.';

  @override
  String get snackOpenShizukuApp => 'Abre Shizuku desde tu cajón de apps.';

  @override
  String get hiwTipDeletePermanent =>
      'ValleySave no puede recuperar partidas borradas definitivamente. Los archivos en Drive son tu responsabilidad.';

  @override
  String get hiwCompatAchievements =>
      'Los logros de Steam y Google Play no se transfieren. Cada plataforma solo registra los logros que ocurren en ella en tiempo real — el save no los activa retroactivamente.';

  @override
  String get hiwCompatOverwrite =>
      'Si sincronizas desde dos dispositivos sin orden, una partida puede sobrescribir a otra. Sube siempre antes de descargar.';

  @override
  String get hiwCompatVersions =>
      'Las partidas de versiones distintas del juego pueden no cargarse correctamente. ValleySave avisa si detecta una diferencia de versión antes de descargar.';

  @override
  String get hiwCompatMods =>
      'Los mods de SMAPI añaden datos extra al save. Si cargas una partida con mods en un dispositivo donde esos mods no están instalados, el juego puede fallar o perder datos del mod.\n\nEn Android, SMAPI también puede instalarse para usar mods.';

  @override
  String get hiwCompatIncomplete =>
      'Si ves \"Incompleta en Drive\" en una partida, le falta algún archivo necesario en la nube — no se puede descargar hasta que se vuelva a subir bien desde otro dispositivo.';

  @override
  String get hiwShareTitle => 'Compartir con otros';

  @override
  String get hiwShareDesc =>
      'Comparte una partida con otro jugador por email. La verá en Compartidas conmigo en su propio dispositivo.';

  @override
  String get hiwShareStepYourSave => 'Tu\npartida';

  @override
  String get hiwShareStepShare => 'Compartir por\nemail';

  @override
  String get hiwShareStepFriend => 'Compartidas\nconmigo';

  @override
  String get hiwShareTipRoles =>
      'Dos roles: Solo lectura permite ver y descargar. Permitir sincronizar permite sobrescribir tu copia en Drive. En ningún caso pueden borrarla — solo tú, el dueño, puedes borrar tu partida.';

  @override
  String get hiwShareTipDisconnect =>
      'Desconectar solo detiene la sincronización de su lado — el compartido sigue activo hasta que lo dejes de verdad desde Administrar compartidas.';

  @override
  String get hiwHostSwapTitle => 'Cambio de anfitrión';

  @override
  String get hiwHostSwapDesc =>
      'Cambia qué farmhand es el anfitrión de la partida, reemplazándola en sitio — mismo slot de guardado, mismos permisos de compartir.';

  @override
  String get hiwHostSwapStepPick => 'Elegir\nfarmhand';

  @override
  String get hiwHostSwapStepConfirm => 'Confirmar';

  @override
  String get hiwHostSwapStepDone => 'Partida nueva\ncreada';

  @override
  String get hiwHostSwapTipMove =>
      'Algunos objetos de la granja pueden reubicarse para hacer sitio a la casa — nada se borra.';

  @override
  String get hiwHostSwapTipHouse =>
      'La casa del nuevo anfitrión se verá como la casa grande por defecto del juego — la estética de cabaña no está soportada sin mods.';

  @override
  String get hiwBackupsTitle => 'Respaldos';

  @override
  String get hiwBackupsDesc =>
      'Un respaldo es una foto de una partida que puedes restaurar más adelante. Créalo manualmente cuando quieras, o deja que ValleySave cree uno automáticamente antes de sobrescribir una partida (al descargar, importar, restaurar o cambiar de anfitrión).';

  @override
  String get hiwBackupsStepSave => 'Tu\npartida';

  @override
  String get hiwBackupsStepSnapshot => 'Respaldo\ncreado';

  @override
  String get hiwBackupsStepStore => 'Local y/o\nDrive';

  @override
  String get hiwBackupsTipRestore =>
      'Restaurar sobrescribe tu partida actual con esa versión anterior — no se puede deshacer.';

  @override
  String get hiwBackupsTipDelete =>
      'Eliminar un respaldo lo borra en todas las ubicaciones donde exista (este equipo y Drive, si se subió) — no se puede deshacer.';

  @override
  String get hiwBackupsTipExport =>
      'También puedes Exportar una partida como zip para guardarla donde quieras, e Importarla de vuelta más adelante — una alternativa manual y portable a los respaldos integrados.';

  @override
  String get hiwBackupsTipRetention =>
      'ValleySave conserva los 5 respaldos automáticos más recientes de cada partida; los que creas tú a mano nunca se borran solos.';

  @override
  String get hiwBackupsTipRestoreBridge =>
      'En modo Puente (Android sin root/Shizuku), restaurar un respaldo te pide extraer el .zip a mano en la carpeta de Stardew — igual que al descargar.';

  @override
  String get hiwComparePrimary => 'Tiempo total jugado';

  @override
  String get hiwCompareNoShown1 => 'Estado de cultivos y animales';

  @override
  String get hiwCompareNoShown2 => 'Inventario y objetos';

  @override
  String get hiwCompareNoShown3 => 'Relaciones individuales';

  @override
  String get hiwShizuku1 => 'Instala Shizuku (Play Store o APK desde GitHub).';

  @override
  String get hiwShizuku2 =>
      'Actívala con «Depuración inalámbrica» — ValleySave te guía paso a paso.';

  @override
  String get hiwShizuku3 => 'Concede permiso a ValleySave cuando te lo pida.';

  @override
  String get hiwBridge1 =>
      'Descargar de Drive: ValleySave deja la partida en su carpeta. Tú la copias con Archivos a la carpeta de Stardew.';

  @override
  String get hiwBridge2 =>
      'Subir a Drive: copias la partida de Stardew a la carpeta de ValleySave. ValleySave la detecta y la sube.';

  @override
  String get snackShizukuBattery =>
      'Ajustes → Apps → Shizuku → Batería → No restringido.';

  @override
  String snackDriveError(String error) {
    return 'Drive: $error';
  }

  @override
  String get dlgDeleteLocalWarning =>
      '⚠️ Si no la has subido a Drive, se perderá para siempre. No hay recuperación.';

  @override
  String get dlgDelete => 'Borrar';

  @override
  String get dlgDownloadButton => 'Descargar';

  @override
  String get dlgUploadButton => 'Subir';

  @override
  String get dlgBridgeCopyTitle => 'Copia la partida al juego';

  @override
  String dlgBridgeCopyDesc(String saveName) {
    return 'La partida está lista. Con tu app de Archivos, copia la carpeta \"$saveName\" y pégala en la carpeta de Stardew.';
  }

  @override
  String get labelFrom => 'Desde';

  @override
  String get labelTo => 'Hasta';

  @override
  String dlgDownloadNewDesc(String saveName, int day, String playtime) {
    return 'Se copiará \"$saveName\" (Día $day, $playtime) a este equipo.';
  }

  @override
  String dlgDownloadOverwrite(String saveName) {
    return 'Esto SOBRESCRIBE tu save local de \"$saveName\".';
  }

  @override
  String dlgUploadNewDesc(String saveName, int day, String playtime) {
    return 'Se subirá \"$saveName\" (Día $day, $playtime) a tu Drive.';
  }

  @override
  String dlgUploadOverwriteDrive(String saveName) {
    return 'Esto SOBRESCRIBE la versión en Drive de \"$saveName\".';
  }

  @override
  String get pathLabelFromStardew => 'Desde (Stardew)';

  @override
  String get pathLabelToValleySave => 'Hasta (ValleySave)';

  @override
  String get chooserDesc =>
      'Android protege la carpeta del juego. Elige cómo darle acceso a ValleySave — puedes cambiarlo cuando quieras.';

  @override
  String get chooserShizukuDesc =>
      'Se configura 1 vez. Después ValleySave sincroniza sola, sin que toques nada. Única vía fiable en Android 13+.';

  @override
  String get chooserManualBadge => 'SOLO ANDROID 11-12';

  @override
  String get chooserBridgeDesc =>
      'Copias la partida con tu app de Archivos. Sin instalar nada. Solo en Android 11 y 12.';

  @override
  String get chooserRootBadge => 'ROOT';

  @override
  String get chooserRootTitle => 'Acceso Root';

  @override
  String get chooserRootDesc =>
      'Para dispositivos rooteados (Magisk / SuperSU). Acepta el permiso root una vez — automático a partir de ahí.';

  @override
  String get snackRootDenied => 'Acceso root denegado. Prueba con Shizuku.';

  @override
  String get shizukuGateSubtitle =>
      'Se configura una vez · solo la primera vez';

  @override
  String get shizukuStatusLabel => 'Shizuku activo';

  @override
  String get shizukuStatusRunning => 'Conectado y a la espera.';

  @override
  String get shizukuStatusNotDetected => 'Aún no detectado.';

  @override
  String get shizukuPermLabel => 'Permiso concedido';

  @override
  String get shizukuPermGranted => 'ValleySave ya tiene acceso.';

  @override
  String get shizukuPermNotGranted => 'Falta autorizar a ValleySave.';

  @override
  String get shizukuGrant => 'conceder';

  @override
  String get shizukuGuideHeader => 'GUÍA PASO A PASO';

  @override
  String get shizukuStep1DescFull =>
      'Gratis. Si Google Play te lo bloquea en tu móvil, usa el APK oficial de GitHub.';

  @override
  String get btnPlayStore => 'Play Store';

  @override
  String get btnApkGithub => 'APK GitHub';

  @override
  String get shizukuStep2TitleFull => 'Activa Opciones de desarrollador';

  @override
  String get shizukuStep2DescFull =>
      'Ajustes → Información del teléfono → Información de software → toca \"Número de compilación\" 7 veces.';

  @override
  String get shizukuStep3TitleFull => 'Activa Depuración inalámbrica';

  @override
  String get shizukuStep3DescFull =>
      'El botón te lleva ahí y la resalta. Actívala (ON). Después toca \"Emparejar dispositivo con código de vinculación\" — aparecerá un código de 6 dígitos en pantalla.';

  @override
  String get btnOpenAndHighlight => 'Abrir y resaltar';

  @override
  String get shizukuStep4Title => 'Empareja e INICIA Shizuku';

  @override
  String get shizukuStep4Desc =>
      'Abre Shizuku → \"Iniciar mediante depuración inalámbrica\" → \"Emparejar con código de sincronización\". Shizuku enviará una notificación indicando que está a la espera. Introduce el código de 6 dígitos que ves en la pantalla de Depuración inalámbrica. Tras emparejar, pulsa INICIAR — sin ese último toque Shizuku no queda activo.';

  @override
  String get btnOpenShizuku => 'Abrir Shizuku';

  @override
  String get shizukuStep5Title => 'Pon la energía de Shizuku en No restringido';

  @override
  String get shizukuStep5Desc =>
      'Abre la info de la app → Batería → No restringido. Si no lo haces, el sistema cerrará Shizuku en segundo plano y tendrás que volver a darle a Iniciar.';

  @override
  String get btnShizukuAppInfo => 'Info de app Shizuku';

  @override
  String get shizukuStep6DescActive =>
      'Shizuku está activo. Pulsa el botón para autorizar.';

  @override
  String get shizukuStep6DescWaiting =>
      'Disponible en cuanto Shizuku esté activo (paso 4).';

  @override
  String get btnGrantPermission => 'Conceder permiso';

  @override
  String get btnCheckShizuku => 'Ya lo he hecho · Comprobar';

  @override
  String get statusDone => 'hecho';

  @override
  String get statusPending => 'pendiente';

  @override
  String get latestBadge => '· ÚLTIMA PARTIDA ·';

  @override
  String saveDateLabel(String season, int year) {
    return '$season · Año $year';
  }

  @override
  String get petCat => 'Gato';

  @override
  String get petDog => 'Perro';

  @override
  String get houseBasic => 'Casa básica';

  @override
  String get houseKitchen => 'Con cocina';

  @override
  String get houseBedroom => 'Con habitación';

  @override
  String get houseCellar => 'Con bodega';

  @override
  String houseLevelN(int level) {
    return 'Nv. $level';
  }

  @override
  String get tooltipLaunchGame => 'Jugar';

  @override
  String get hiwLaunchTitle => 'Abrir el juego';

  @override
  String get hiwLaunchDesc =>
      'El botón ▶ en la barra superior de Mis partidas abre Stardew Valley directamente desde la app.';

  @override
  String get hiwLaunchTipWindows =>
      'En Windows, si el juego no se detecta automáticamente, configura la ruta del ejecutable en Ajustes → Juego.';

  @override
  String get hiwLaunchTipAndroid =>
      'En Android abre el juego si está instalado.';

  @override
  String get hiwLaunchTipLinux =>
      'En Linux, si el juego no se detecta automáticamente, configura la ruta del ejecutable en Ajustes → Juego.';

  @override
  String get hiwSaveLocationsTitle => 'Dónde viven tus partidas';

  @override
  String get hiwSaveLocationsDesc =>
      'ValleySave lee y escribe directamente en la carpeta de saves del juego en cada plataforma.';

  @override
  String get hiwSaveLocationWindows =>
      'Windows: %AppData%\\StardewValley\\Saves';

  @override
  String get hiwSaveLocationAndroid =>
      'Android: carpeta protegida, se accede vía Shizuku o el Puente';

  @override
  String get hiwSaveLocationLinux =>
      'Linux: ~/.config/StardewValley/Saves (o ~/snap/steam/common/.config/StardewValley/Saves si Steam está instalado vía snap)';

  @override
  String get settingsGameSection => 'Juego';

  @override
  String get settingsGameExePath => 'Ejecutable de Stardew Valley';

  @override
  String get settingsGameExeNotFound => 'No encontrado automáticamente';

  @override
  String get settingsGameExeBrowse => 'Buscar…';

  @override
  String get settingsGameExeSaved => 'Ruta guardada';

  @override
  String get snackLaunchError => 'No se pudo abrir el juego';

  @override
  String get makeHostAction => 'HACER ANFITRIÓN';

  @override
  String get makeHostExperimental => 'EXPERIMENTAL';

  @override
  String get makeHostDialogTitle => 'Cambiar anfitrión';

  @override
  String makeHostDialogIntro(String playerName, String farmName) {
    return '$playerName pasará a ser el anfitrión de $farmName.';
  }

  @override
  String get makeHostNewCopyNote =>
      'Se crea una partida nueva. Después decides qué hacer con la original.';

  @override
  String makeHostMoveCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other:
          'Se moverán $count objetos de la granja para hacer sitio a la casa. Nada se borra.',
      one:
          'Se moverá 1 objeto de la granja para hacer sitio a la casa. Nada se borra.',
    );
    return '$_temp0';
  }

  @override
  String get makeHostHouseWarning =>
      'La casa del nuevo anfitrión se verá como la casa grande del juego. La estética de cabaña no está soportada sin mods.';

  @override
  String get makeHostConfirmButton => 'Hacer anfitrión';

  @override
  String makeHostSuccess(String playerName) {
    return 'Nueva partida creada: $playerName es ahora el anfitrión.';
  }

  @override
  String get hostSwapErrInvalid =>
      'Esta partida tiene una estructura inesperada. No se cambió nada.';

  @override
  String get hostSwapErrNoSpace =>
      'No hay espacio libre en la granja para reubicar objetos. No se cambió nada.';

  @override
  String get hostSwapErrWrite =>
      'No se pudo escribir la partida nueva (disco/permisos). No se cambió nada.';

  @override
  String get hostSwapErrValidation =>
      'La verificación de la partida nueva falló, así que se descartó. La original está intacta.';
}
