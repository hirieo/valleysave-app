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
}
