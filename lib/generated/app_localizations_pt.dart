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
  String get welcomeHeroPre => 'Nunca perca\nsua ';

  @override
  String get welcomeHeroAccent => 'fazenda,';

  @override
  String get welcomeHeroPost => '\nleve-a consigo.';

  @override
  String get welcomeSubtitle =>
      'Sincronize seus saves de Stardew Valley em todos os seus dispositivos. Seus dados ficam no seu próprio Google Drive — sem servidores, sem assinaturas, sob seu controle.';

  @override
  String get welcomeDriveConnected => 'Drive conectado';

  @override
  String get welcomeFooterTagline => '· Não comercial · Sempre grátis ·';

  @override
  String updateVersionAvailable(String version) {
    return 'v$version disponível';
  }

  @override
  String get sectionMode => 'Modo';

  @override
  String get sectionSeason => 'Estação';

  @override
  String get sectionLanguage => 'Idioma';

  @override
  String get modeAutoTitle => 'Automático';

  @override
  String get modeAutoDesc =>
      'Segue seu save ativo e, se não houver saves, usa sua localização real.';

  @override
  String get modeSavesTitle => 'Por save';

  @override
  String get modeSavesDesc => 'Usa sempre a estação do seu save mais recente.';

  @override
  String get modeGeoTitle => 'Por localização';

  @override
  String get modeGeoDesc => 'Usa sempre a estação real da sua localização.';

  @override
  String get modeFixedTitle => 'Estação fixa';

  @override
  String get modeFixedDesc => 'Mostra sempre a mesma estação.';

  @override
  String get modeRandomTitle => 'Aleatório';

  @override
  String get modeRandomDesc =>
      'Escolhe uma estação diferente cada vez que você abre o app.';

  @override
  String get seasonInitial => 'Inicial';

  @override
  String get seasonSpring => 'Primavera';

  @override
  String get seasonSummer => 'Verão';

  @override
  String get seasonFall => 'Outono';

  @override
  String get seasonWinter => 'Inverno';

  @override
  String get autoPriorityTitle => 'Ordem de prioridade';

  @override
  String get autoStep1Title => 'Primeiro acesso';

  @override
  String get autoStep1Desc => 'Exibe o estado inicial.';

  @override
  String get autoStep2Title => 'Save ativo';

  @override
  String get autoStep2Desc => 'Usa a estação do seu último save sincronizado.';

  @override
  String get autoStep3Title => 'Localização';

  @override
  String get autoStep3Desc =>
      'Detecta seu hemisfério e a estação real da sua região.';

  @override
  String get autoStep4Title => 'Padrão';

  @override
  String get autoStep4Desc =>
      'Inicial (modo noturno) se não houver dados disponíveis.';

  @override
  String get versionInstalled => 'Versão instalada';

  @override
  String get updateNeverChecked => 'Nunca verificado';

  @override
  String get updateCheckedNow => 'Verificado agora';

  @override
  String get updateOutdatedDownload => 'Desatualizado · Baixar';

  @override
  String get updateDownloading => 'Baixando atualização…';

  @override
  String get updateError => 'Erro — toque para tentar novamente';

  @override
  String get updateNeedsPermission =>
      'Ative \"instalar apps desconhecidos\" para o ValleySave e toque em Atualizar novamente';

  @override
  String get disconnectTitle => 'Desconectar Drive?';

  @override
  String disconnectBody(String email) {
    return 'Seus saves no Drive não serão deletados. Você pode reconectar quando quiser.';
  }

  @override
  String get disconnectButton => 'Desconectar Drive';

  @override
  String disconnectButtonEmail(String email) {
    return 'Desconectar de $email';
  }

  @override
  String get connectedAsPrefix => 'Conectado como';

  @override
  String get languageTileLabel => 'Idioma';

  @override
  String get languageDialogTitle => 'Idioma do app';

  @override
  String get searchHint => 'Pesquisar…';

  @override
  String get languageAuto => 'Idioma do sistema';

  @override
  String get languageAutoDesc => 'Usa o idioma do seu sistema';

  @override
  String get privacyPolicyTitle => 'Política de privacidade';

  @override
  String get privacyBeforeStartTitle => 'Antes de começar';

  @override
  String get privacyLastUpdated => 'Última atualização: junho de 2026';

  @override
  String get privacyAccept => 'Entendi, continuar';

  @override
  String get cardSynced => 'Sincronizado';

  @override
  String get cardLocalAhead => 'Local à frente';

  @override
  String get cardDriveAhead => 'Drive à frente';

  @override
  String get cardLocalOnly => 'Somente local';

  @override
  String get cardDriveOnly => 'Somente Drive';

  @override
  String get cardTimeNow => 'agora';

  @override
  String cardTimeMinutesAgo(int minutes) {
    return 'há $minutes min';
  }

  @override
  String cardTimeHoursAgo(int hours) {
    return 'há ${hours}h';
  }

  @override
  String cardTimeDaysAgo(int days) {
    return 'há ${days}d';
  }

  @override
  String cardTimeMonthsAgo(int months) {
    return 'há $months mes';
  }

  @override
  String get cardDetailLocalTitle => 'Neste dispositivo';

  @override
  String get cardDetailRemoteTitle => 'No Drive';

  @override
  String get cardDetailUpload => 'Enviar para o Drive';

  @override
  String get cardDetailDownload => 'Baixar save';

  @override
  String get cardDetailDeleteLabel => 'Deletar';

  @override
  String get cardDetailDeleteLocal => 'Deletar deste dispositivo';

  @override
  String get cardDetailDeleteRemote => 'Deletar do Drive';

  @override
  String get cardCloseBarrier => 'Fechar';

  @override
  String get exportAction => 'Exportar';

  @override
  String get exportSuccess => 'Save exportado.';

  @override
  String exportError(String error) {
    return 'Não foi possível exportar o save: $error';
  }

  @override
  String get importAction => 'Importar save';

  @override
  String importSuccess(String playerName) {
    return 'Save de $playerName importado.';
  }

  @override
  String get importErrInvalidZip => 'Este arquivo não é um zip válido.';

  @override
  String get importErrUnsafePath =>
      'Este arquivo tem uma estrutura insegura e foi rejeitado.';

  @override
  String get importErrTooLarge =>
      'Este arquivo é grande demais para ser importado.';

  @override
  String get importErrNotASave =>
      'Este arquivo não contém um save reconhecível.';

  @override
  String get importErrWrite =>
      'Não foi possível gravar o save importado (disco/permissões).';

  @override
  String get importErrBackupFailed =>
      'Não foi possível criar um backup de segurança. Nada foi importado.';

  @override
  String get importConflictTitle => 'Já existe um save com este nome';

  @override
  String get importConflictBody =>
      'Importar substituirá a cópia local existente. Isso não pode ser desfeito.';

  @override
  String get importConflictConfirm => 'Sobrescrever';

  @override
  String get shareAction => 'Compartilhar';

  @override
  String get shareUploadFirstCta => 'Enviar primeiro';

  @override
  String get shareDialogTitle => 'Compartilhar save';

  @override
  String get shareEmailPlaceholder => 'nome@exemplo.com';

  @override
  String get shareInfoNote =>
      'Compartilhar dá acesso apenas para ver e baixar. Só você pode editar ou deletar sua cópia no Drive.';

  @override
  String get shareRoleReader => 'Somente leitura';

  @override
  String get shareRoleWriter => 'Permitir sincronizar';

  @override
  String get shareInfoNoteCoop =>
      'Somente leitura permite ver e baixar. Permitir sincronizar permite sobrescrever sua cópia no Drive — nunca poderão deletá-la.';

  @override
  String get shareConfirmButton => 'Compartilhar';

  @override
  String shareSuccess(String email) {
    return 'Compartilhado com $email.';
  }

  @override
  String get manageAccessTitle => 'Pessoas com acesso';

  @override
  String get manageAccessEmpty => 'Ninguém mais tem acesso ainda.';

  @override
  String get manageAccessRoleLabel => 'Acesso';

  @override
  String get manageAccessRevoke => 'Revogar';

  @override
  String manageAccessRevokeConfirm(String email) {
    return 'Remover o acesso de $email? Qualquer cópia local que já tenha sido baixada continua sendo dele.';
  }

  @override
  String get driveOnlyControlsYourCopy =>
      'Compartilhar controla sua cópia no Drive. Se alguém a baixar, essa cópia é dele.';

  @override
  String get driveOnlyControlsYourCopyCoop =>
      'Sincronizar controla sua cópia no Drive — pode ser sobrescrita, mas nunca deletada, por quem você autorizar a sincronizar.';

  @override
  String get sharedWithMeTitle => 'Compartilhadas comigo';

  @override
  String get sharedWithMeEmpty => 'Nada compartilhado com você ainda.';

  @override
  String get sharedWithMeAdd => 'Adicionar save compartilhado';

  @override
  String sharedWithMeOwnedBy(String email) {
    return 'Compartilhado por $email';
  }

  @override
  String get sharedWithMeRoleSync => 'Sincroniza';

  @override
  String get sharedWithMeRoleRead => 'Somente leitura';

  @override
  String get sharedWithMeSync => 'Sincronizar';

  @override
  String get sharedWithMeDownload => 'Baixar';

  @override
  String get sharedWithMeRemove => 'Desconectar';

  @override
  String sharedWithMeRemoveConfirm(String email) {
    return 'Você deixará de sincronizar com o Drive de $email, mas pode adicioná-lo de volta quando quiser — continua compartilhado. Sua cópia local fica como um save coop normal.';
  }

  @override
  String sharedLeaveConfirm(Object email) {
    return 'Você perderá o acesso a este save de verdade. Não poderá adicioná-lo de volta a não ser que $email compartilhe com você novamente. Sua cópia local fica como um save coop normal.';
  }

  @override
  String get sharedManageButton => 'Gerenciar';

  @override
  String get sharedManageDialogTitle => 'Gerenciar compartilhadas';

  @override
  String get sharedManageDialogHint =>
      'Aqui você pode sair de verdade de um save compartilhado.';

  @override
  String get sharedLeaveButton => 'Sair do compartilhado';

  @override
  String sharedLeaveSuccess(Object email) {
    return 'Você saiu do compartilhado de $email.';
  }

  @override
  String sharedWithMeSyncConfirm(String email) {
    return 'Sobrescrever a cópia de $email no Drive com seu save local?';
  }

  @override
  String sharedAccessReadOnly(String email) {
    return '$email colocou seu acesso em modo somente leitura — você pode ver e baixar, mas não sincronizar para o Drive dele.';
  }

  @override
  String get sharedWithMeRevoked => 'Você não tem mais acesso';

  @override
  String sharedRevokedDialogBody(String email, String farmName) {
    return '$email parou de compartilhar $farmName com você. Sua cópia local e a do seu Drive continuam como estão, agora em Meus saves.';
  }

  @override
  String get sharedRevokedAccept => 'Aceitar';

  @override
  String get sharedSelfCleanupTitle => 'Registro corrigido';

  @override
  String sharedSelfCleanupBody(String farmName) {
    return '$farmName apareceu como compartilhado com você por engano — na verdade é seu. Foi corrigido, agora está em Meus saves.';
  }

  @override
  String get sharedWithMeUploadOwn => 'Enviar para meu Drive';

  @override
  String get sharedDownloadOwn => 'Baixar do meu Drive';

  @override
  String get sharedStatusOwnDriveAhead => 'Seu Drive está à frente — baixe';

  @override
  String get sharedSyncBoth => 'Enviar para os dois Drives';

  @override
  String get sharedSideMyDrive => 'MEU DRIVE';

  @override
  String sharedSideOwnerDrive(String email) {
    return 'DRIVE EM $email';
  }

  @override
  String sharedSideDate(int day, int year) {
    return 'Dia $day · Ano $year';
  }

  @override
  String get sharedStatusSyncedNoOwnDrive =>
      'Sincronizado com o dono · sem cópia no seu Drive';

  @override
  String get sharedStatusAheadNoOwnDrive =>
      'Você está à frente · sem cópia no seu Drive';

  @override
  String sharedStatusOwnerAheadNoOwnDrive(String email) {
    return '$email está à frente · sem cópia no seu Drive';
  }

  @override
  String get sharedStatusAllSynced => 'Sincronizado (local + os dois Drives)';

  @override
  String get sharedStatusAheadBoth => 'Você está à frente nos dois Drives';

  @override
  String get sharedStatusMixed => 'Dessincronizado — verifique cada Drive';

  @override
  String get sharedStatusFullySynced => 'Totalmente sincronizado';

  @override
  String get sharedStatusSyncedOwn => 'Meu Drive sincronizado';

  @override
  String get sharedStatusSyncedOwner => 'Drive compartilhado sincronizado';

  @override
  String get sharedStatusNotCloud => 'Somente neste dispositivo';

  @override
  String sharedStatusOwnerAhead(Object email) {
    return 'Drive em $email está à frente';
  }

  @override
  String get sharedStatusBothAhead => 'Os dois Drives estão à frente';

  @override
  String get sharedStatusLocalMissing => 'Não está neste dispositivo';

  @override
  String sharedStatusOwnerUnavailable(Object email) {
    return 'Não foi possível verificar o Drive em $email';
  }

  @override
  String get sharedStatusWorking => 'Sincronizando…';

  @override
  String get sharedSideUnavailable => 'Não foi possível verificar';

  @override
  String get sharedSyncChooseTitle => 'Onde você quer sincronizar?';

  @override
  String get sharedSyncChooseBody =>
      'Escolha quais cópias na nuvem você quer atualizar com o save deste dispositivo.';

  @override
  String get sharedSyncTargetOwn => 'Meu Drive';

  @override
  String sharedSyncTargetOwner(Object email) {
    return 'Drive em $email';
  }

  @override
  String get sharedSyncTargetBoth => 'Os dois Drives';

  @override
  String get sharedDownloadChooseTitle => 'Qual cópia você quer baixar?';

  @override
  String get sharedDownloadChooseBody =>
      'Há mais de uma cópia à frente. Escolha qual você quer trazer para este dispositivo.';

  @override
  String get sharedDownloadSourceOwn => 'Do meu Drive';

  @override
  String sharedDownloadSourceOwner(Object email) {
    return 'Do Drive em $email';
  }

  @override
  String get sharedWithMePickerTitle => 'Adicionar save compartilhado';

  @override
  String get sharedPickerEmptyHint =>
      'Aqui aparece o que outro jogador compartilhar com você pelo Drive.';

  @override
  String get sharedPickerAddButton => 'Adicionar';

  @override
  String get sharedOriginBadge => 'Compartilhado';

  @override
  String sharedOriginFrom(String email) {
    return 'de $email';
  }

  @override
  String get swapBackupDialogTitle => 'Backup criado';

  @override
  String get swapBackupDialogBody =>
      'A versão anterior foi salva como zip. O que você quer fazer com ela?';

  @override
  String get swapBackupUpload => 'Enviar para o Drive';

  @override
  String get swapBackupLocalOnly => 'Manter neste dispositivo';

  @override
  String get swapBackupDeleteNow => 'Deletar agora';

  @override
  String get swapBackupUploadOk => 'Backup enviado para o Drive.';

  @override
  String swapBackupUploadErr(String error) {
    return 'Não foi possível enviar o backup: $error';
  }

  @override
  String get swapBackupLocalOnlySnack => 'Backup salvo neste dispositivo.';

  @override
  String get backupsAction => 'Backups';

  @override
  String backupsScreenTitle(String farmName) {
    return 'Backups de $farmName';
  }

  @override
  String get backupsEmpty => 'Nenhum backup ainda.';

  @override
  String get backupsRestore => 'Restaurar';

  @override
  String get backupsRestoreConfirmTitle => 'Restaurar este backup?';

  @override
  String get backupsRestoreConfirmBody =>
      'Isso sobrescreve seu save atual com esta versão anterior. Não pode ser desfeito.';

  @override
  String get backupsDelete => 'Deletar';

  @override
  String get backupsDeleteConfirmTitle => 'Deletar este backup?';

  @override
  String get backupsDeleteConfirmBody =>
      'Será apagado em todos os lugares onde existir (este dispositivo e Drive, se foi enviado). Não pode ser desfeito.';

  @override
  String get backupsRestoreOk => 'Backup restaurado.';

  @override
  String get backupsRestoreManualTitle => 'Restaurar manualmente';

  @override
  String get backupsRestoreManualBody =>
      'No modo Ponte, o ValleySave não consegue gravar na pasta do jogo automaticamente. Extraia você mesmo o .zip deste backup na pasta Saves do Stardew Valley, ou mude para o modo Root/Shizuku em Configurações para restaurar automaticamente.';

  @override
  String backupsRestoreErr(String error) {
    return 'Não foi possível restaurar o backup: $error';
  }

  @override
  String backupsDeleteErr(String error) {
    return 'Não foi possível deletar o backup: $error';
  }

  @override
  String get backupsCreate => 'Criar backup local';

  @override
  String get backupsCreateLocalHint =>
      'Os backups são criados primeiro neste dispositivo. Depois você pode enviá-los para o Drive.';

  @override
  String get backupsCreateOk => 'Backup criado.';

  @override
  String backupsCreateErr(String error) {
    return 'Não foi possível criar o backup: $error';
  }

  @override
  String get backupsDownload => 'Baixar';

  @override
  String get backupsDownloadOk => 'Backup baixado neste dispositivo.';

  @override
  String backupsDownloadErr(String error) {
    return 'Não foi possível baixar o backup: $error';
  }

  @override
  String get backupsCopyOwn => 'Copiar para meu Drive';

  @override
  String get backupsUploadOwn => 'Para meu Drive';

  @override
  String get backupsUploadShared => 'Para o Drive compartilhado';

  @override
  String get backupsUploadOk => 'Backup enviado.';

  @override
  String backupsUploadErr(String error) {
    return 'Não foi possível enviar o backup: $error';
  }

  @override
  String get backupsLocationLocal => 'Este dispositivo';

  @override
  String get backupsLocationOwnDrive => 'Meu Drive';

  @override
  String get backupsLocationSharedDrive => 'Drive compartilhado';

  @override
  String get backupsDeleteChooseBody =>
      'Escolha exatamente onde deletá-lo. Só aparecem os lugares onde este backup existe.';

  @override
  String get backupsDeleteLocalOnly => 'Somente deste dispositivo';

  @override
  String get backupsDeleteOwnOnly => 'Somente do meu Drive';

  @override
  String get backupsDeleteSharedOnly => 'Somente do Drive compartilhado';

  @override
  String get backupsDeleteAll => 'De todas as cópias';

  @override
  String deleteUnifiedTitle(String farmName) {
    return 'Deletar $farmName?';
  }

  @override
  String get deleteChooseLocationBody =>
      'Escolha de onde. A cópia deste dispositivo é apagada para sempre; a do Drive vai para a Lixeira (30 dias).';

  @override
  String deleteDriveContextTitle(String farmName) {
    return 'Deletar $farmName do Drive?';
  }

  @override
  String get deleteDriveContextBody =>
      'A cópia do Drive vai para a Lixeira, onde você pode recuperá-la por 30 dias.';

  @override
  String get deleteDriveLocalKept =>
      'A cópia deste dispositivo permanecerá sem alterações.';

  @override
  String deleteLocalContextTitle(String farmName) {
    return 'Deletar $farmName deste dispositivo?';
  }

  @override
  String get deleteLocalContextBody =>
      'A cópia deste dispositivo será apagada para sempre.';

  @override
  String deleteLocalDriveCurrent(String date) {
    return 'Sua cópia no Drive está atualizada ($date) e continuará disponível.';
  }

  @override
  String deleteLocalDriveAhead(String date) {
    return 'Sua cópia no Drive é mais recente ($date) e continuará disponível.';
  }

  @override
  String deleteLocalDriveOlder(String driveDate, String localDate) {
    return 'Sua cópia no Drive é anterior ($driveDate); este dispositivo está em $localDate.';
  }

  @override
  String deleteLocalBackupAvailable(int count) {
    return 'Há $count backups locais disponíveis caso você precise de uma cópia anterior.';
  }

  @override
  String get deleteLocalNoRecovery =>
      'Não há uma cópia no Drive nem um backup local para recuperar este jogo.';

  @override
  String get deleteOptionLocalOnly => 'Somente deste dispositivo';

  @override
  String get deleteOptionDriveOnly => 'Somente do Drive';

  @override
  String get deleteOptionBoth => 'De ambas as cópias (dispositivo + Drive)';

  @override
  String get viewPlayersHint => 'Ver jogadores';

  @override
  String snackDeletedBoth(String saveName) {
    return '\"$saveName\" deletado deste dispositivo e movido para a Lixeira do Drive.';
  }

  @override
  String statDayYear(int day, int year) {
    return 'Dia $day · Ano $year';
  }

  @override
  String statDayOnly(int day) {
    return 'Dia $day';
  }

  @override
  String get statPlaytime => 'Tempo de jogo';

  @override
  String get statMoney => 'Moedas';

  @override
  String get statTotal => 'Total';

  @override
  String get statMineUnexplored => 'Inexplorado';

  @override
  String get statMine => 'Mina';

  @override
  String get statMineLvl => 'Mina · Nv';

  @override
  String get skillFarming => 'Agricultura';

  @override
  String get skillForaging => 'Coleta';

  @override
  String get skillMining => 'Mineração';

  @override
  String get skillFishing => 'Pesca';

  @override
  String get skillCombat => 'Combate';

  @override
  String get cardLocalPresence => 'Neste dispositivo';

  @override
  String get cardRemotePresence => 'No Drive';

  @override
  String get cardNotPresent => 'Não aqui';

  @override
  String get cardActionSynced => 'Sincronizado';

  @override
  String get cardActionUpload => 'Enviar';

  @override
  String get cardActionDownload => 'Baixar';

  @override
  String get pillMonsters => 'monstros';

  @override
  String get pillFriends => 'amigos';

  @override
  String get pillFaints => 'desmaios';

  @override
  String get pillSleeps => 'Dormidas';

  @override
  String get hiwTitle => 'Como funciona';

  @override
  String get hiwConnectTitle => 'Conectar sua conta';

  @override
  String get hiwConnectDesc =>
      'ValleySave usa sua conta do Google para guardar seus saves em uma pasta privada do ValleySave no seu próprio Drive.';

  @override
  String get hiwConnectStepGoogle => 'Conta do\nGoogle';

  @override
  String get hiwConnectStepDrive => 'Pasta ValleySave\ncriada';

  @override
  String get hiwConnectStepReady => 'Pronto para\nsincronizar';

  @override
  String get hiwConnectTipOwnership =>
      'Somente você pode editar ou deletar suas cópias no Drive — o ValleySave só lê e grava dentro da própria pasta.';

  @override
  String get hiwSyncTitle => 'Como a sincronização funciona';

  @override
  String get hiwSyncIntro =>
      'ValleySave usa seu próprio Google Drive para mover saves entre dispositivos. Sem servidores intermediários: os arquivos são seus.';

  @override
  String get hiwSyncDevice => 'Seu\ndispositivo';

  @override
  String get hiwSyncCloud => 'Google\nDrive';

  @override
  String get hiwSyncOtherDevice => 'Outro\ndispositivo';

  @override
  String get hiwUploadTitle => 'Enviar um save';

  @override
  String get hiwUploadDesc =>
      'Ao enviar, ValleySave copia os dois arquivos de save (SaveGameInfo + arquivo da fazenda) para sua pasta ValleySave/ no Drive.';

  @override
  String get hiwDownloadTitle => 'Baixar um save';

  @override
  String get hiwDownloadDesc =>
      'Ao baixar, ValleySave traz os arquivos do Drive e os coloca diretamente na pasta do jogo.';

  @override
  String get hiwCompareTitle => 'O que ele compara?';

  @override
  String get hiwCompareIntro =>
      'Para saber qual versão está à frente, ValleySave usa o tempo total de jogo — o único dado que só pode crescer.';

  @override
  String get hiwCompareNote =>
      'Antes de confirmar você também verá, para poder decidir:';

  @override
  String get hiwCompareMoney => 'Dinheiro atual e total ganho';

  @override
  String get hiwCompareMine => 'Nível da mina';

  @override
  String get hiwCompareSkills =>
      'Habilidades (agricultura, mineração, combate…)';

  @override
  String get hiwCompareRelations => 'Amigos, monstros mortos, desmaios';

  @override
  String get hiwCompareStamina => 'Stamina e saúde';

  @override
  String get hiwCompareNotShown =>
      'Estes não são exibidos — mudam em qualquer direção e não indicam qual save está à frente.';

  @override
  String get hiwCompareNotShownExamples =>
      'Estado de plantações e animais, inventário e itens, relacionamentos individuais';

  @override
  String get hiwCompareWarning =>
      'Não são exibidos — mudam em qualquer direção e não indicam qual save está à frente.';

  @override
  String get hiwConflictTitle => 'Se você jogar sem sincronizar';

  @override
  String get hiwConflictDesc =>
      'Se você avançar no celular e no PC sem sincronizar entre as sessões, você acaba com duas versões do mesmo save.';

  @override
  String get hiwConflictNoMerge =>
      'Elas não podem ser mescladas. ValleySave sempre mostra as duas versões para você escolher qual manter.';

  @override
  String get hiwConflictMobile => 'Celular';

  @override
  String get hiwConflictVersionA => 'versão A';

  @override
  String get hiwConflictPC => 'PC';

  @override
  String get hiwConflictVersionB => 'versão B';

  @override
  String get hiwDeleteTitle => 'Se um save for deletado';

  @override
  String get hiwDeleteDesc =>
      'Quando você deleta um save do Drive, ele não desaparece imediatamente: vai para a Lixeira do Google Drive.';

  @override
  String get hiwCompatTitle => 'Compatibilidade entre plataformas';

  @override
  String get hiwCompatAndroidAccess => 'ACESSO NO ANDROID';

  @override
  String get hiwShizukuTitle => 'Com Shizuku';

  @override
  String get hiwShizukuSubtitle =>
      'Configure uma vez. Depois disso, ValleySave sincroniza sozinho, sem você precisar fazer mais nada.';

  @override
  String get hiwShizukuBadge => 'AUTOMÁTICO · RECOMENDADO';

  @override
  String get hiwShizukuDone =>
      '✓  Pronto. A partir daí, baixar e enviar saves é direto, como em um computador.';

  @override
  String get hiwShizukuNote =>
      'O pareamento é só na primeira vez. Novas versões do Shizuku se reativam sozinhas após reiniciar o celular.';

  @override
  String get hiwBridgeTitle => 'Ponte manual';

  @override
  String get hiwBridgeSubtitle =>
      'Funciona apenas no Android 11 e 12. Você não instala nada extra; em vez disso, copia o save manualmente com o app Arquivos toda vez que sincronizar.';

  @override
  String get hiwBridgeBadge => 'ALTERNATIVA MANUAL · ANDROID 11-12';

  @override
  String get hiwBridgeSaveFolder => 'Pasta do Stardew';

  @override
  String get hiwBridgeValleySaveFolder => 'Pasta do ValleySave';

  @override
  String get hiwBridgeNote =>
      'Funciona porque o app Arquivos do sistema pode acessar essas pastas (ValleySave não pode).';

  @override
  String get hiwTipAlwaysShow =>
      'Você sempre verá o que está no Drive antes de sobrescrever, para poder comparar.';

  @override
  String get hiwTipWithoutUpload =>
      'Sem enviar, nenhum outro dispositivo verá seu progresso recente.';

  @override
  String get hiwTipComparison =>
      'Você verá a comparação entre local e Drive antes de confirmar.';

  @override
  String get hiwTipDownloadOverwrite =>
      'Baixar sobrescreve seu save local. Qualquer progresso não sincronizado será perdido.';

  @override
  String get hiwTipSync =>
      'Sempre envie antes de trocar de dispositivo e baixe quando chegar.';

  @override
  String get hiwTipDeletion =>
      'Você tem 30 dias para restaurá-lo da Lixeira do Drive antes que seja deletado permanentemente.';

  @override
  String get hiwPrivacyLink => 'Política de privacidade e uso';

  @override
  String get emptyNoSaves => 'Nenhum save encontrado';

  @override
  String get emptyNoSavesHint =>
      'Nenhum save local pode ser lido neste dispositivo';

  @override
  String get bridgeTitle => 'Traga seus saves';

  @override
  String get bridgeDesc =>
      'Para ver e enviar seus saves locais, copie-os com o app Arquivos da pasta do Stardew para esta pasta do ValleySave. Depois deslize para atualizar.';

  @override
  String get bridgeRefresh => 'Atualizar';

  @override
  String get bridgeChangeMode => 'Mudar método';

  @override
  String get loaderLoading => 'CARREGANDO';

  @override
  String get loaderConnecting => 'conectando ao Drive…';

  @override
  String get chooserTitle => 'Escolha como conectar';

  @override
  String get chooserAutomatic => 'Automático · Recomendado';

  @override
  String get chooserManual => 'Alternativa manual · Android 11-12';

  @override
  String get shizukuStepTitle => 'Configurar Shizuku';

  @override
  String get shizukuStep1Title => 'Instalar Shizuku';

  @override
  String get shizukuStep1Desc => 'Baixe da Play Store ou GitHub';

  @override
  String get shizukuStep2Title => 'Ativar Shizuku';

  @override
  String get shizukuStep2Desc => 'Abra o app e conceda as permissões';

  @override
  String get shizukuStep3Title => 'Conceder permissão';

  @override
  String get shizukuStep3Desc => 'ValleySave solicitará acesso';

  @override
  String get shizukuDone =>
      '✓  Pronto. A partir daí, baixar e enviar saves funciona diretamente, como em um computador.';

  @override
  String get dlgDeleteDriveTitle => 'Deletar do Drive';

  @override
  String get dlgDeleteLocalTitle => 'Deletar deste dispositivo';

  @override
  String get dlgDownloadTitle => 'Baixar save';

  @override
  String get dlgUploadTitle => 'Enviar save';

  @override
  String get dlgUploadOverwrite => 'Isso vai sobrescrever seu save local';

  @override
  String get dlgGotIt => 'Entendi';

  @override
  String get dlgCopyDest => 'Destino da cópia';

  @override
  String get previewColDayYear => 'Dia/Ano';

  @override
  String get previewColTime => 'Tempo de jogo';

  @override
  String get previewColMoney => 'Moedas';

  @override
  String get previewColTotal => 'Total';

  @override
  String get previewColFarming => 'Agricultura';

  @override
  String get previewColForaging => 'Coleta';

  @override
  String get previewColMining => 'Mineração';

  @override
  String get previewColFishing => 'Pesca';

  @override
  String get previewColCombat => 'Combate';

  @override
  String get previewColFriends => 'Amigos';

  @override
  String get previewColMonsters => 'Monstros';

  @override
  String get previewColFaints => 'Desmaios';

  @override
  String get previewColMine => 'Mina';

  @override
  String get previewColUnexplored => 'Inexplorado';

  @override
  String get previewLocalLabel => 'NESTE DISPOSITIVO';

  @override
  String get previewDriveLabel => 'NO DRIVE';

  @override
  String get previewFromDrive => 'DO DRIVE';

  @override
  String get previewFromDevice => 'DESTE DISPOSITIVO';

  @override
  String get overwriteWhatChanges => 'O que muda';

  @override
  String get overwriteTagOverwritten => 'SERÁ SOBRESCRITO';

  @override
  String get overwriteNewCopyTag => 'NOVO';

  @override
  String overwriteDeltaPhrase(int days, String time) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: '$days dias e $time',
      one: '1 dia e $time',
      zero: '$time',
    );
    return '$_temp0';
  }

  @override
  String overwriteVerdictAhead(String delta) {
    return 'Você está $delta à frente. É seguro.';
  }

  @override
  String get overwriteVerdictMoneySpent =>
      '💰 O dinheiro atual caiu, mas o progresso geral avança — provavelmente você gastou em algo. Não é uma perda real.';

  @override
  String overwriteVerdictNegligible(String delta) {
    return 'Diferença mínima ($delta). Qualquer uma das duas cópias serve.';
  }

  @override
  String overwriteVerdictDanger(String delta, String target) {
    return '⚠️ Você vai perder $delta de progresso em $target. Revise antes de continuar.';
  }

  @override
  String get overwriteConfirmTitleUpload => 'Confirma o envio?';

  @override
  String get overwriteConfirmTitleDownload => 'Confirma o download?';

  @override
  String overwriteConfirmBody(String delta, String target) {
    return 'Você vai perder $delta em $target. Esta ação não pode ser desfeita.';
  }

  @override
  String get overwriteConfirmButtonUpload => 'Confirmar envio';

  @override
  String get overwriteConfirmButtonDownload => 'Confirmar download';

  @override
  String get overwriteDangerButtonUpload => '⚠️ Enviar mesmo assim';

  @override
  String get overwriteDangerButtonDownload => '⚠️ Baixar mesmo assim';

  @override
  String overwriteIdenticalSummary(int count, String list) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '✓ $count idênticos',
      one: '✓ 1 idêntico',
    );
    return '$_temp0 — $list';
  }

  @override
  String overwriteUploadToOwner(String email) {
    return 'Enviar para o Drive de $email';
  }

  @override
  String get overwriteUploadBoth => 'Enviar para os dois Drives';

  @override
  String get overwriteConfirmTitleBoth => 'Confirma os dois envios?';

  @override
  String overwriteConfirmBodyBoth(String delta, String targets) {
    return 'Você vai perder $delta em $targets. Esta ação não pode ser desfeita.';
  }

  @override
  String overwriteBothDestinationsLabel(String first, String second) {
    return '$first e $second';
  }

  @override
  String get sharedTargetOwnDrive => 'seu Drive';

  @override
  String sharedStatusLocalAhead(String targets) {
    return 'Você está à frente em $targets';
  }

  @override
  String versionMismatch(String local, String drive) {
    return 'Versões diferentes: local $local · Drive $drive…';
  }

  @override
  String get snackPathCopied => 'Caminho copiado';

  @override
  String get snackDestCopied => 'Caminho de destino copiado';

  @override
  String get snackDownloaded => 'Save baixado para o jogo';

  @override
  String get snackReplacePrepareFailed =>
      'Não foi possível preparar o save. Nada foi alterado no disco';

  @override
  String get snackReplaceValidationFailed =>
      'O save baixado parece inválido ou incompleto. Nada foi alterado no disco';

  @override
  String get snackReplaceBackupFailed =>
      'Não foi possível criar um backup de segurança. Nada foi alterado no disco';

  @override
  String get snackReplaceSwapFailed =>
      'A troca falhou, mas o save original foi restaurado a partir do backup';

  @override
  String get snackReplaceBusy =>
      'Já existe uma operação em andamento para este save';

  @override
  String get snackUploadIncomplete =>
      'O save local está incompleto ou corrompido. Nada foi enviado';

  @override
  String get snackDownloadIncomplete =>
      'Não é possível baixar: falta conteúdo no Drive';

  @override
  String get cardIncomplete => 'Incompleto no Drive';

  @override
  String get autoRefreshTitle => 'Atualização automática';

  @override
  String get autoRefreshSubtitle => 'Verifica mudanças no Drive a cada 30s';

  @override
  String autoSyncSnack(String farmName) {
    return '$farmName sincronizado automaticamente';
  }

  @override
  String get autoSyncTooltipOn =>
      'Auto-sync ativado — sincroniza sozinho quando é seguro';

  @override
  String get autoSyncTooltipOff => 'Auto-sync desativado — toque para ativar';

  @override
  String get autoSyncExplainTitle => 'Auto-sync';

  @override
  String autoSyncExplainBody(String farmName) {
    return 'A partir de agora, $farmName será enviado ou baixado sozinho quando for seguro, sem pedir sua confirmação.';
  }

  @override
  String get autoSyncExplainSafe =>
      'Só age quando você está claramente à frente e nada se perde.';

  @override
  String get autoSyncExplainDanger =>
      'Se houvesse risco de perder progresso, ele nunca age sozinho: você continuará decidindo com o diálogo de sempre.';

  @override
  String get autoSyncExplainMissing =>
      'Se faltar uma das duas cópias, ele não a cria sozinho: enviar ou baixar pela primeira vez é você quem decide.';

  @override
  String get autoSyncExplainDontShowAgain => 'Não mostrar este aviso novamente';

  @override
  String get autoSyncExplainConfirm => 'Entendi, ativar';

  @override
  String get hiwAutoSyncTitle => 'Sincronizar sozinho';

  @override
  String get hiwAutoSyncDesc =>
      'Cada save tem um chip AUTO no seu cartão. Ao ativá-lo, esse save é enviado ou baixado sozinho quando o app detecta uma mudança — sem precisar entrar para confirmar.';

  @override
  String get hiwAutoSyncTipSafe =>
      'Só sincroniza sozinho quando você está claramente à frente e nada se perde.';

  @override
  String get hiwAutoSyncTipDanger =>
      'Se houvesse risco de perder progresso, ele nunca faz sozinho: continua perguntando com a comparação de sempre.';

  @override
  String get hiwAutoSyncTipPerSave =>
      'É ativado save por save, não de uma vez: você pode ter no seu e não em um compartilhado.';

  @override
  String get hiwAutoSyncTipMissing =>
      'Só mantém sincronizadas duas cópias que já existem. Se faltar uma, o primeiro envio ou download é com você.';

  @override
  String get hiwAutoSyncTipRefresh =>
      'Em Configurações você pode desativar completamente a verificação automática de mudanças.';

  @override
  String get snackSessionExpired => 'Sessão do Drive expirada. Reconecte';

  @override
  String snackUploadError(String error) {
    return 'Erro ao enviar: $error';
  }

  @override
  String snackDownloadError(String error) {
    return 'Erro ao baixar: $error';
  }

  @override
  String snackDeleteError(String error) {
    return 'Erro ao deletar: $error';
  }

  @override
  String snackTrashed(String saveName) {
    return '\"$saveName\" movido para a Lixeira do Drive. Você tem 30 dias para restaurá-lo.';
  }

  @override
  String snackDeletedLocal(String saveName) {
    return '\"$saveName\" deletado deste dispositivo';
  }

  @override
  String get snackShizukuRequired => 'Ative Shizuku…';

  @override
  String get snackWriteError =>
      'Não foi possível escrever no jogo. Alguns celulares bloqueiam /Android/data mesmo com Shizuku.';

  @override
  String get snackPlatformNotSupported =>
      'Esta plataforma ainda não suporta escrita de saves locais.';

  @override
  String get snackWirelessDebugHint =>
      'Abra manualmente: Configurações → Opções do desenvolvedor → Depuração sem fio.';

  @override
  String get snackOpenShizukuApp => 'Abra Shizuku pela sua gaveta de apps.';

  @override
  String get hiwTipDeletePermanent =>
      'ValleySave não consegue recuperar saves deletados permanentemente. Os arquivos do Drive são sua responsabilidade.';

  @override
  String get hiwCompatAchievements =>
      'Conquistas do Steam e Google Play não são transferidas. Cada plataforma rastreia apenas conquistas que acontecem em tempo real — o arquivo de save não as dispara retroativamente.';

  @override
  String get hiwCompatOverwrite =>
      'Se você sincronizar de dois dispositivos sem uma ordem definida, um save pode sobrescrever o outro. Sempre envie antes de baixar.';

  @override
  String get hiwCompatVersions =>
      'Saves de versões diferentes do jogo podem não carregar corretamente. ValleySave avisa se detectar uma incompatibilidade de versão antes de baixar.';

  @override
  String get hiwCompatMods =>
      'Mods do SMAPI adicionam dados extras ao save. Se você carregar um save com mods em um dispositivo onde esses mods não estão instalados, o jogo pode travar ou perder dados dos mods.\n\nNo Android, o SMAPI também pode ser instalado para usar mods.';

  @override
  String get hiwCompatIncomplete =>
      'Se você ver \"Incompleto no Drive\" em um save, falta algum arquivo necessário na nuvem — não é possível baixá-lo até que seja enviado corretamente novamente de outro dispositivo.';

  @override
  String get hiwShareTitle => 'Compartilhar com outros';

  @override
  String get hiwShareDesc =>
      'Compartilhe um save com outro jogador por e-mail. Ele o verá em Compartilhadas comigo no próprio dispositivo.';

  @override
  String get hiwShareStepYourSave => 'Seu\nsave';

  @override
  String get hiwShareStepShare => 'Compartilhar por\ne-mail';

  @override
  String get hiwShareStepFriend => 'Compartilhadas\ncomigo';

  @override
  String get hiwShareTipRoles =>
      'Dois papéis: Somente leitura permite ver e baixar. Permitir sincronizar permite sobrescrever sua cópia no Drive. Em nenhum caso podem deletá-la — só você, o dono, pode deletar seu save.';

  @override
  String get hiwShareTipDisconnect =>
      'Desconectar só interrompe a sincronização do lado dele — o compartilhamento continua ativo até você realmente sair dele em Gerenciar compartilhadas.';

  @override
  String get hiwHostSwapTitle => 'Troca de anfitrião';

  @override
  String get hiwHostSwapDesc =>
      'Muda qual farmhand é o anfitrião do save, substituindo-o no lugar — mesmo slot de save, mesmas permissões de compartilhamento.';

  @override
  String get hiwHostSwapStepPick => 'Escolher\nfarmhand';

  @override
  String get hiwHostSwapStepConfirm => 'Confirmar';

  @override
  String get hiwHostSwapStepDone => 'Save novo\ncriado';

  @override
  String get hiwHostSwapTipMove =>
      'Alguns objetos da fazenda podem ser realocados para abrir espaço para a casa — nada é apagado.';

  @override
  String get hiwHostSwapTipHouse =>
      'A casa do novo anfitrião vai parecer a casa grande padrão do jogo — a estética de cabana não é suportada sem mods.';

  @override
  String get hiwBackupsTitle => 'Backups';

  @override
  String get hiwBackupsDesc =>
      'Um backup é uma foto de um save que você pode restaurar mais tarde. Crie um manualmente quando quiser, ou deixe o ValleySave criar um automaticamente antes de sobrescrever um save (ao baixar, importar, restaurar ou trocar de anfitrião).';

  @override
  String get hiwBackupsStepSave => 'Seu\nsave';

  @override
  String get hiwBackupsStepSnapshot => 'Backup\ncriado';

  @override
  String get hiwBackupsStepStore => 'Local e/ou\nDrive';

  @override
  String get hiwBackupsTipRestore =>
      'Restaurar sobrescreve seu save atual com essa versão anterior — não pode ser desfeito.';

  @override
  String get hiwBackupsTipDelete =>
      'Deletar um backup o apaga em todos os lugares onde existir (este dispositivo e Drive, se foi enviado) — não pode ser desfeito.';

  @override
  String get hiwBackupsTipExport =>
      'Você também pode Exportar um save como zip para guardar onde quiser, e Importá-lo de volta mais tarde — uma alternativa manual e portátil aos backups integrados.';

  @override
  String get hiwBackupsTipRetention =>
      'O ValleySave mantém os 5 backups automáticos mais recentes de cada save; os que você cria manualmente nunca são apagados sozinhos.';

  @override
  String get hiwBackupsTipRestoreBridge =>
      'No modo Ponte (Android sem root/Shizuku), restaurar um backup pede que você extraia o .zip manualmente na pasta do Stardew — igual ao baixar.';

  @override
  String get hiwComparePrimary => 'Tempo total de jogo';

  @override
  String get hiwCompareNoShown1 => 'Estado de plantações e animais';

  @override
  String get hiwCompareNoShown2 => 'Inventário e itens';

  @override
  String get hiwCompareNoShown3 => 'Relacionamentos individuais';

  @override
  String get hiwShizuku1 => 'Instale Shizuku (Play Store ou APK do GitHub).';

  @override
  String get hiwShizuku2 =>
      'Ative-o com Depuração sem fio — ValleySave guia você passo a passo.';

  @override
  String get hiwShizuku3 =>
      'Conceda permissão ao ValleySave quando solicitado.';

  @override
  String get hiwBridge1 =>
      'Baixar do Drive: ValleySave deixa o save na sua pasta. Você o copia com o Arquivos para a pasta do Stardew.';

  @override
  String get hiwBridge2 =>
      'Enviar para o Drive: copie o save do Stardew para a pasta do ValleySave. ValleySave detecta e faz o envio.';

  @override
  String get snackShizukuBattery =>
      'Configurações → Apps → Shizuku → Bateria → Sem restrições.';

  @override
  String snackDriveError(String error) {
    return 'Drive: $error';
  }

  @override
  String get dlgDeleteLocalWarning =>
      '⚠️ Se você não enviou para o Drive, será perdido para sempre. Sem recuperação.';

  @override
  String get dlgDelete => 'Deletar';

  @override
  String get dlgDownloadButton => 'Baixar';

  @override
  String get dlgUploadButton => 'Enviar';

  @override
  String get dlgBridgeCopyTitle => 'Copiar save para o jogo';

  @override
  String dlgBridgeCopyDesc(String saveName) {
    return 'Save pronto. Com o app Arquivos, copie a pasta \"$saveName\" e cole na pasta do Stardew.';
  }

  @override
  String get labelFrom => 'De';

  @override
  String get labelTo => 'Para';

  @override
  String dlgDownloadNewDesc(String saveName, int day, String playtime) {
    return '\"$saveName\" (Dia $day, $playtime) será copiado para este dispositivo.';
  }

  @override
  String dlgDownloadOverwrite(String saveName) {
    return 'Isso SOBRESCREVE seu save local de \"$saveName\".';
  }

  @override
  String dlgUploadNewDesc(String saveName, int day, String playtime) {
    return '\"$saveName\" (Dia $day, $playtime) será enviado para o seu Drive.';
  }

  @override
  String dlgUploadOverwriteDrive(String saveName) {
    return 'Isso SOBRESCREVE a versão do Drive de \"$saveName\".';
  }

  @override
  String get pathLabelFromStardew => 'De (Stardew)';

  @override
  String get pathLabelToValleySave => 'Para (ValleySave)';

  @override
  String get chooserDesc =>
      'O Android protege a pasta do jogo. Escolha como dar acesso ao ValleySave — você pode mudar a qualquer momento.';

  @override
  String get chooserShizukuDesc =>
      'Configurado uma vez. Depois disso ValleySave sincroniza sozinho, sem você precisar fazer nada. Único método confiável no Android 13+.';

  @override
  String get chooserManualBadge => 'APENAS ANDROID 11-12';

  @override
  String get chooserBridgeDesc =>
      'Copie saves com o app Arquivos. Sem instalação extra. Apenas no Android 11 e 12.';

  @override
  String get chooserRootBadge => 'ROOT';

  @override
  String get chooserRootTitle => 'Acesso Root';

  @override
  String get chooserRootDesc =>
      'Para dispositivos com root (Magisk / SuperSU). Aprove o permiso root uma vez — automático depois disso.';

  @override
  String get snackRootDenied => 'Acesso root negado. Tente o Shizuku.';

  @override
  String get shizukuGateSubtitle =>
      'Configurado uma vez · somente na primeira vez';

  @override
  String get shizukuStatusLabel => 'Shizuku ativo';

  @override
  String get shizukuStatusRunning => 'Conectado e aguardando.';

  @override
  String get shizukuStatusNotDetected => 'Ainda não detectado.';

  @override
  String get shizukuPermLabel => 'Permissão concedida';

  @override
  String get shizukuPermGranted => 'ValleySave já tem acesso.';

  @override
  String get shizukuPermNotGranted => 'Precisa autorizar o ValleySave.';

  @override
  String get shizukuGrant => 'autorizar';

  @override
  String get shizukuGuideHeader => 'GUIA PASSO A PASSO';

  @override
  String get shizukuStep1DescFull =>
      'Gratuito. Se a Play Store bloquear no seu celular, use o APK oficial do GitHub.';

  @override
  String get btnPlayStore => 'Play Store';

  @override
  String get btnApkGithub => 'APK GitHub';

  @override
  String get shizukuStep2TitleFull => 'Ativar Opções do desenvolvedor';

  @override
  String get shizukuStep2DescFull =>
      'Configurações → Informações do telefone → Informações de software → toque em \"Número da versão\" 7 vezes.';

  @override
  String get shizukuStep3TitleFull => 'Ativar Depuração sem fio';

  @override
  String get shizukuStep3DescFull =>
      'O botão leva você até lá e destaca a opção. Ative (ON). Depois toque em \"Parear dispositivo com código de pareamento\" — um código de 6 dígitos aparecerá na tela.';

  @override
  String get btnOpenAndHighlight => 'Abrir e destacar';

  @override
  String get shizukuStep4Title => 'Parear e INICIAR Shizuku';

  @override
  String get shizukuStep4Desc =>
      'Abra Shizuku → \"Iniciar via Depuração sem fio\" → \"Parear com código de pareamento\". Shizuku enviará uma notificação dizendo que está aguardando. Digite o código de 6 dígitos da tela de Depuração sem fio. Após o pareamento, pressione INICIAR — sem esse último toque Shizuku não estará ativo.';

  @override
  String get btnOpenShizuku => 'Abrir Shizuku';

  @override
  String get shizukuStep5Title =>
      'Configurar bateria do Shizuku como Sem restrições';

  @override
  String get shizukuStep5Desc =>
      'Abra as informações do app → Bateria → Sem restrições. Se não fizer isso, o sistema fechará o Shizuku em segundo plano e você terá que pressionar Iniciar novamente.';

  @override
  String get btnShizukuAppInfo => 'Informações do Shizuku';

  @override
  String get shizukuStep6DescActive =>
      'Shizuku está ativo. Toque no botão para autorizar.';

  @override
  String get shizukuStep6DescWaiting =>
      'Disponível quando Shizuku estiver ativo (passo 4).';

  @override
  String get btnGrantPermission => 'Conceder permissão';

  @override
  String get btnCheckShizuku => 'Pronto · Verificar';

  @override
  String get statusDone => 'concluído';

  @override
  String get statusPending => 'pendente';

  @override
  String get latestBadge => '· SAVE MAIS RECENTE ·';

  @override
  String saveDateLabel(String season, int year) {
    return '$season · Ano $year';
  }

  @override
  String get petCat => 'Gato';

  @override
  String get petDog => 'Cachorro';

  @override
  String get houseBasic => 'Casa básica';

  @override
  String get houseKitchen => 'Com cozinha';

  @override
  String get houseBedroom => 'Com quarto';

  @override
  String get houseCellar => 'Com adega';

  @override
  String houseLevelN(int level) {
    return 'Nv. $level';
  }

  @override
  String get tooltipLaunchGame => 'Jogar';

  @override
  String get hiwLaunchTitle => 'Abrir o jogo';

  @override
  String get hiwLaunchDesc =>
      'O botão ▶ na barra superior de Minhas partidas abre o Stardew Valley diretamente pelo app.';

  @override
  String get hiwLaunchTipWindows =>
      'No Windows, se o jogo não for detectado automaticamente, configure o caminho do executável em Configurações → Jogo.';

  @override
  String get hiwLaunchTipAndroid =>
      'No Android, abre o jogo se estiver instalado.';

  @override
  String get hiwLaunchTipLinux =>
      'No Linux, se o jogo não for detectado automaticamente, configure o caminho do executável em Configurações → Jogo.';

  @override
  String get hiwSaveLocationsTitle => 'Onde vivem seus saves';

  @override
  String get hiwSaveLocationsDesc =>
      'O ValleySave lê e grava diretamente na pasta de saves do jogo em cada plataforma.';

  @override
  String get hiwSaveLocationWindows =>
      'Windows: %AppData%\\\\StardewValley\\\\Saves';

  @override
  String get hiwSaveLocationAndroid =>
      'Android: pasta protegida, acessada via Shizuku ou a Ponte';

  @override
  String get hiwSaveLocationLinux =>
      'Linux: ~/.config/StardewValley/Saves (ou ~/snap/steam/common/.config/StardewValley/Saves se o Steam estiver instalado via snap)';

  @override
  String get settingsGameSection => 'Jogo';

  @override
  String get settingsGameExePath => 'Executável do Stardew Valley';

  @override
  String get settingsGameExeNotFound => 'Não encontrado automaticamente';

  @override
  String get settingsGameExeBrowse => 'Procurar…';

  @override
  String get settingsGameExeSaved => 'Caminho salvo';

  @override
  String get snackLaunchError => 'Não foi possível abrir o jogo';

  @override
  String get makeHostAction => 'TORNAR ANFITRIÃO';

  @override
  String get makeHostExperimental => 'EXPERIMENTAL';

  @override
  String get makeHostDialogTitle => 'Trocar anfitrião';

  @override
  String makeHostDialogIntro(String playerName, String farmName) {
    return '$playerName passará a ser o anfitrião de $farmName.';
  }

  @override
  String get makeHostNewCopyNote =>
      'Um novo save é criado. Depois você decide o que fazer com o original.';

  @override
  String makeHostMoveCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other:
          '$count objetos da fazenda serão movidos para abrir espaço para a casa. Nada é apagado.',
      one:
          '1 objeto da fazenda será movido para abrir espaço para a casa. Nada é apagado.',
    );
    return '$_temp0';
  }

  @override
  String get makeHostHouseWarning =>
      'A casa do novo anfitrião vai parecer a casa grande do jogo. A aparência de cabana não é suportada sem mods.';

  @override
  String get makeHostConfirmButton => 'Tornar anfitrião';

  @override
  String makeHostSuccess(String playerName) {
    return 'Novo save criado: $playerName agora é o anfitrião.';
  }

  @override
  String get hostSwapErrInvalid =>
      'Este save tem uma estrutura inesperada. Nada foi alterado.';

  @override
  String get hostSwapErrNoSpace =>
      'Não há espaço livre na fazenda para reposicionar objetos. Nada foi alterado.';

  @override
  String get hostSwapErrWrite =>
      'Não foi possível gravar o novo save (disco/permissões). Nada foi alterado.';

  @override
  String get hostSwapErrValidation =>
      'A verificação do novo save falhou e foi descartado. O original está intacto.';

  @override
  String get makeHostDeleteOriginalTitle =>
      'Apagar o save original deste dispositivo?';

  @override
  String get makeHostDeleteOriginalBody =>
      'O novo save está pronto. Faça backup do original no seu Drive primeiro (você poderá baixá-lo de novo depois) ou apague só a cópia local.';

  @override
  String get makeHostDeleteOriginalNoBackupBody =>
      'Sem conexão com o Drive: não restará nenhum backup. Só a cópia local deste dispositivo será apagada.';

  @override
  String get makeHostDeleteOriginalUploadBody =>
      'O save original será primeiro enviado ao seu Drive como backup e, em seguida, a cópia local deste dispositivo será apagada.';

  @override
  String get makeHostDeleteWithoutUpload => 'Apagar sem enviar';

  @override
  String get makeHostUploadAndDelete => 'Enviar e apagar';

  @override
  String get updateCheckFailed => 'Não foi possível verificar';

  @override
  String get updateCheckFailedRetry => 'Toque para tentar novamente';
}
