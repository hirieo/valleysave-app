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
  String get disconnectTitle => 'Desconectar Drive?';

  @override
  String get disconnectBody =>
      'Seus saves no Drive não serão deletados. Você pode reconectar quando quiser.';

  @override
  String get disconnectButton => 'Desconectar Drive';

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
}
