// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Portuguese (`pt`).
class AppLocalizationsPt extends AppLocalizations {
  AppLocalizationsPt([String locale = 'pt']) : super(locale);

  @override
  String get appTitle => 'ValleySave';

  @override
  String get welcomeTitle => 'Nunca perca sua fazenda, leve-a consigo.';

  @override
  String get connectGoogleDrive => 'Conectar Google Drive';

  @override
  String get connecting => 'Conectando…';

  @override
  String get mySaves => 'Meus Saves';

  @override
  String get howItWorks => 'Como funciona';

  @override
  String get settings => 'Configurações';

  @override
  String get aboutSection => 'Sobre';

  @override
  String get openSource => 'Código disponível';

  @override
  String get nonCommercial => 'Não comercial';

  @override
  String get freeForever => 'Sempre grátis';

  @override
  String get privacyTitle => 'Privacidade e uso de dados';

  @override
  String get privacyDescription =>
      'ValleySave é um aplicativo para sincronizar seus savegames de Stardew Valley com sua própria conta do Google Drive.';

  @override
  String get whatDataTitle => 'Que dados usa';

  @override
  String get whatDataDesc =>
      'ValleySave acessa apenas os arquivos de savegame do Stardew Valley necessários para fazer cópias, sincronizá-los ou restaurá-los.';

  @override
  String get googleDriveTitle => 'Google Drive';

  @override
  String get googleDriveDesc =>
      'Seus savegames são carregados em sua própria conta do Google Drive. ValleySave não usa seus próprios servidores para armazenar seus jogos.';

  @override
  String get androidPermissionsTitle => 'Permissões no Android';

  @override
  String get androidPermissionsDesc =>
      'ValleySave pode precisar de permissões de armazenamento ou ferramentas como Shizuku para acessar arquivos de savegame.';

  @override
  String get adsTitle => 'Anúncios';

  @override
  String get adsDesc => 'ValleySave pode exibir anúncios via Google AdMob.';

  @override
  String get responsibilityTitle => 'Responsabilidade';

  @override
  String get responsibilityDesc =>
      'Seus arquivos de savegame são sua responsabilidade.';

  @override
  String get deleteDataTitle => 'Deletar dados';

  @override
  String get deleteDataDesc =>
      'Você pode deletar suas cópias sincronizadas deletando manualmente a pasta ValleySave do Google Drive.';

  @override
  String get sourceCodeTitle => 'Código-fonte e contato';

  @override
  String get sourceCodeDesc =>
      'ValleySave é um projeto com código disponível sob licença Polyform Noncommercial.';

  @override
  String get upToDate => 'Atualizado';

  @override
  String get checkingUpdates => 'Verificando…';

  @override
  String get updateAvailable => 'Atualização disponível';

  @override
  String get application => 'Aplicativo';

  @override
  String version(Object version) {
    return 'Versão $version';
  }

  @override
  String get checkForUpdates => 'Verificar atualizações';

  @override
  String get shizukuRequired => 'Shizuku obrigatório';

  @override
  String get shizukuGuide => 'Guia de configuração do Shizuku';

  @override
  String get activateShizuku => 'Ative Shizuku para escrever o save no jogo.';

  @override
  String deleteSaveTitle(Object saveName) {
    return 'Deletar $saveName';
  }

  @override
  String get deleteSaveMessage =>
      'Isso deletará o save deste dispositivo. Deseja continuar?';

  @override
  String get deleteFromDrive => 'Deletar do Drive';

  @override
  String confirmDelete(Object saveName) {
    return 'O save $saveName será movido para a Lixeira do Google Drive.';
  }

  @override
  String deleteFromDeviceMessage(Object saveName) {
    return 'O save $saveName será deletado permanentemente deste dispositivo.';
  }

  @override
  String restoreSaveTitle(Object saveName) {
    return 'Restaurar $saveName';
  }

  @override
  String restoreSaveMessage(Object saveName) {
    return 'Baixar $saveName para este dispositivo?';
  }

  @override
  String get restore => 'Restaurar';

  @override
  String get cancel => 'Cancelar';

  @override
  String get error => 'Erro';

  @override
  String get success => 'Sucesso';

  @override
  String get loading => 'Carregando…';

  @override
  String get disconnect => 'Desconectar';

  @override
  String get ok => 'OK';

  @override
  String get yes => 'Sim';

  @override
  String get no => 'Não';

  @override
  String get welcomeHeroPre => 'Never lose\nyour ';

  @override
  String get welcomeHeroAccent => 'farm,';

  @override
  String get welcomeHeroPost => '\ntake it with you.';

  @override
  String get welcomeSubtitle =>
      'Sync your Stardew Valley saves across all your devices. Your data lives in your own Google Drive — no servers, no subscriptions, under your control.';

  @override
  String get welcomeDriveConnected => 'Drive connected';

  @override
  String get welcomeFooterTagline => '· Non-commercial · Free forever ·';

  @override
  String updateVersionAvailable(String version) {
    return 'v$version available';
  }

  @override
  String get sectionMode => 'Mode';

  @override
  String get sectionSeason => 'Season';

  @override
  String get sectionLanguage => 'Language';

  @override
  String get modeAutoTitle => 'Automatic';

  @override
  String get modeAutoDesc =>
      'Follows your active save and, if no saves, your real location.';

  @override
  String get modeSavesTitle => 'By save';

  @override
  String get modeSavesDesc =>
      'Always uses the season from your most recent save.';

  @override
  String get modeGeoTitle => 'By location';

  @override
  String get modeGeoDesc => 'Always uses the real season of your location.';

  @override
  String get modeFixedTitle => 'Fixed season';

  @override
  String get modeFixedDesc => 'Always shows the same season.';

  @override
  String get modeRandomTitle => 'Random';

  @override
  String get modeRandomDesc =>
      'Picks a different season each time you open the app.';

  @override
  String get seasonInitial => 'Initial';

  @override
  String get seasonSpring => 'Spring';

  @override
  String get seasonSummer => 'Summer';

  @override
  String get seasonFall => 'Fall';

  @override
  String get seasonWinter => 'Winter';

  @override
  String get autoPriorityTitle => 'Priority order';

  @override
  String get autoStep1Title => 'First launch';

  @override
  String get autoStep1Desc => 'Shows the initial state.';

  @override
  String get autoStep2Title => 'Active save';

  @override
  String get autoStep2Desc => 'Uses the season from your last synced save.';

  @override
  String get autoStep3Title => 'Location';

  @override
  String get autoStep3Desc =>
      'Detects your hemisphere and the real season of your region.';

  @override
  String get autoStep4Title => 'Default';

  @override
  String get autoStep4Desc => 'Initial (night mode) if no data is available.';

  @override
  String get versionInstalled => 'Installed version';

  @override
  String get updateNeverChecked => 'Never checked';

  @override
  String get updateCheckedNow => 'Checked now';

  @override
  String get updateOutdatedDownload => 'Not up to date · Download';

  @override
  String get disconnectTitle => 'Disconnect Drive?';

  @override
  String get disconnectBody =>
      'Your saves on Drive won\'t be deleted. You can reconnect anytime.';

  @override
  String get disconnectButton => 'Disconnect Drive';

  @override
  String get languageTileLabel => 'Language';

  @override
  String get languageDialogTitle => 'App language';

  @override
  String get searchHint => 'Search…';

  @override
  String get languageAuto => 'Auto · system';

  @override
  String get languageAutoDesc => 'Uses your system language';
}
