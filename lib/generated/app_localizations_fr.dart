// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for French (`fr`).
class AppLocalizationsFr extends AppLocalizations {
  AppLocalizationsFr([String locale = 'fr']) : super(locale);

  @override
  String get appTitle => 'ValleySave';

  @override
  String get welcomeTitle =>
      'Ne perdez jamais votre ferme, emportez-la partout.';

  @override
  String get connectGoogleDrive => 'Connecter Google Drive';

  @override
  String get connecting => 'Connexion…';

  @override
  String get mySaves => 'Mes sauvegardes';

  @override
  String get howItWorks => 'Comment ça marche';

  @override
  String get settings => 'Paramètres';

  @override
  String get aboutSection => 'À propos';

  @override
  String get openSource => 'Code disponible';

  @override
  String get nonCommercial => 'Non commercial';

  @override
  String get freeForever => 'Gratuit pour toujours';

  @override
  String get privacyTitle => 'Confidentialité et utilisation des données';

  @override
  String get privacyDescription =>
      'ValleySave est une application pour synchroniser vos sauvegardes Stardew Valley avec votre propre compte Google Drive.';

  @override
  String get whatDataTitle => 'Quelles données sont utilisées';

  @override
  String get whatDataDesc =>
      'ValleySave n\'accède qu\'aux fichiers de sauvegarde Stardew Valley nécessaires pour faire des copies, les synchroniser ou les restaurer.';

  @override
  String get googleDriveTitle => 'Google Drive';

  @override
  String get googleDriveDesc =>
      'Vos sauvegardes sont téléchargées sur votre propre compte Google Drive. ValleySave n\'utilise pas ses propres serveurs pour stocker vos jeux.';

  @override
  String get androidPermissionsTitle => 'Permissions sur Android';

  @override
  String get androidPermissionsDesc =>
      'ValleySave peut avoir besoin de permissions de stockage ou d\'outils comme Shizuku pour accéder aux fichiers de sauvegarde.';

  @override
  String get adsTitle => 'Publicités';

  @override
  String get adsDesc =>
      'ValleySave peut afficher des publicités via Google AdMob.';

  @override
  String get responsibilityTitle => 'Responsabilité';

  @override
  String get responsibilityDesc =>
      'Vos fichiers de sauvegarde sont votre responsabilité.';

  @override
  String get deleteDataTitle => 'Supprimer les données';

  @override
  String get deleteDataDesc =>
      'Vous pouvez supprimer vos copies synchronisées en supprimant manuellement le dossier ValleySave de Google Drive.';

  @override
  String get sourceCodeTitle => 'Code source et contact';

  @override
  String get sourceCodeDesc =>
      'ValleySave est un projet avec code disponible sous licence Polyform Noncommercial.';

  @override
  String get upToDate => 'À jour';

  @override
  String get checkingUpdates => 'Vérification…';

  @override
  String get updateAvailable => 'Mise à jour disponible';

  @override
  String get application => 'Application';

  @override
  String version(Object version) {
    return 'Version $version';
  }

  @override
  String get checkForUpdates => 'Vérifier les mises à jour';

  @override
  String get shizukuRequired => 'Shizuku requis';

  @override
  String get shizukuGuide => 'Guide de configuration de Shizuku';

  @override
  String get activateShizuku =>
      'Activez Shizuku pour écrire la sauvegarde dans le jeu.';

  @override
  String deleteSaveTitle(Object saveName) {
    return 'Supprimer $saveName';
  }

  @override
  String get deleteSaveMessage =>
      'Cela supprimera la sauvegarde de cet appareil. Voulez-vous continuer?';

  @override
  String get deleteFromDrive => 'Supprimer de Drive';

  @override
  String confirmDelete(Object saveName) {
    return 'La sauvegarde $saveName sera déplacée vers la Corbeille de Google Drive.';
  }

  @override
  String deleteFromDeviceMessage(Object saveName) {
    return 'La sauvegarde $saveName sera supprimée définitivement de cet appareil.';
  }

  @override
  String restoreSaveTitle(Object saveName) {
    return 'Restaurer $saveName';
  }

  @override
  String restoreSaveMessage(Object saveName) {
    return 'Télécharger $saveName sur cet appareil?';
  }

  @override
  String get restore => 'Restaurer';

  @override
  String get cancel => 'Annuler';

  @override
  String get error => 'Erreur';

  @override
  String get success => 'Succès';

  @override
  String get loading => 'Chargement…';

  @override
  String get disconnect => 'Déconnecter';

  @override
  String get ok => 'OK';

  @override
  String get yes => 'Oui';

  @override
  String get no => 'Non';

  @override
  String get welcomeHeroPre => 'Ne perdez jamais\nvotre ';

  @override
  String get welcomeHeroAccent => 'ferme,';

  @override
  String get welcomeHeroPost => '\nemportez-la partout.';

  @override
  String get welcomeSubtitle =>
      'Synchronisez vos sauvegardes Stardew Valley sur tous vos appareils. Vos données restent dans votre propre Google Drive — pas de serveurs, pas d\'abonnements, sous votre contrôle.';

  @override
  String get welcomeDriveConnected => 'Drive connecté';

  @override
  String get welcomeFooterTagline =>
      '· Non commercial · Gratuit pour toujours ·';

  @override
  String updateVersionAvailable(String version) {
    return 'v$version disponible';
  }

  @override
  String get sectionMode => 'Mode';

  @override
  String get sectionSeason => 'Saison';

  @override
  String get sectionLanguage => 'Langue';

  @override
  String get modeAutoTitle => 'Automatique';

  @override
  String get modeAutoDesc =>
      'Suit votre sauvegarde active et, si aucune, votre emplacement réel.';

  @override
  String get modeSavesTitle => 'Par sauvegarde';

  @override
  String get modeSavesDesc =>
      'Utilise toujours la saison de votre sauvegarde la plus récente.';

  @override
  String get modeGeoTitle => 'Par emplacement';

  @override
  String get modeGeoDesc =>
      'Utilise toujours la saison réelle de votre emplacement.';

  @override
  String get modeFixedTitle => 'Saison fixe';

  @override
  String get modeFixedDesc => 'Affiche toujours la même saison.';

  @override
  String get modeRandomTitle => 'Aléatoire';

  @override
  String get modeRandomDesc =>
      'Choisit une saison différente à chaque ouverture de l\'application.';

  @override
  String get seasonInitial => 'Initiale';

  @override
  String get seasonSpring => 'Printemps';

  @override
  String get seasonSummer => 'Été';

  @override
  String get seasonFall => 'Automne';

  @override
  String get seasonWinter => 'Hiver';

  @override
  String get autoPriorityTitle => 'Ordre de priorité';

  @override
  String get autoStep1Title => 'Premier lancement';

  @override
  String get autoStep1Desc => 'Affiche l\'état initial.';

  @override
  String get autoStep2Title => 'Sauvegarde active';

  @override
  String get autoStep2Desc =>
      'Utilise la saison de votre dernière sauvegarde synchronisée.';

  @override
  String get autoStep3Title => 'Emplacement';

  @override
  String get autoStep3Desc =>
      'Détecte votre hémisphère et la saison réelle de votre région.';

  @override
  String get autoStep4Title => 'Par défaut';

  @override
  String get autoStep4Desc =>
      'Initial (mode nuit) si aucune donnée n\'est disponible.';

  @override
  String get versionInstalled => 'Version installée';

  @override
  String get updateNeverChecked => 'Jamais vérifié';

  @override
  String get updateCheckedNow => 'Vérifié à l\'instant';

  @override
  String get updateOutdatedDownload => 'Pas à jour · Télécharger';

  @override
  String get updateDownloading => 'Téléchargement de la mise à jour…';

  @override
  String get updateError => 'Erreur — appuyer pour réessayer';

  @override
  String get disconnectTitle => 'Déconnecter Drive?';

  @override
  String get disconnectBody =>
      'Vos sauvegardes sur Drive ne seront pas supprimées. Vous pouvez vous reconnecter à tout moment.';

  @override
  String get disconnectButton => 'Déconnecter Drive';

  @override
  String get languageTileLabel => 'Langue';

  @override
  String get languageDialogTitle => 'Langue de l\'application';

  @override
  String get searchHint => 'Rechercher…';

  @override
  String get languageAuto => 'Langue du système';

  @override
  String get languageAutoDesc => 'Utilise la langue de votre système';

  @override
  String get privacyPolicyTitle => 'Politique de confidentialité';

  @override
  String get privacyBeforeStartTitle => 'Avant de commencer';

  @override
  String get privacyLastUpdated => 'Dernière mise à jour : juin 2026';

  @override
  String get privacyAccept => 'Compris, continuer';

  @override
  String get cardSynced => 'Synchronisé';

  @override
  String get cardLocalAhead => 'Local en avance';

  @override
  String get cardDriveAhead => 'Drive en avance';

  @override
  String get cardLocalOnly => 'Local uniquement';

  @override
  String get cardDriveOnly => 'Drive uniquement';

  @override
  String get cardTimeNow => 'maintenant';

  @override
  String cardTimeMinutesAgo(int minutes) {
    return 'il y a $minutes min';
  }

  @override
  String cardTimeHoursAgo(int hours) {
    return 'il y a ${hours}h';
  }

  @override
  String cardTimeDaysAgo(int days) {
    return 'il y a ${days}j';
  }

  @override
  String cardTimeMonthsAgo(int months) {
    return 'il y a $months mois';
  }

  @override
  String get cardDetailLocalTitle => 'Sur cet appareil';

  @override
  String get cardDetailRemoteTitle => 'Sur Drive';

  @override
  String get cardDetailUpload => 'Envoyer sur Drive';

  @override
  String get cardDetailDownload => 'Télécharger la sauvegarde';

  @override
  String get cardDetailDeleteLabel => 'Supprimer';

  @override
  String get cardDetailDeleteLocal => 'Supprimer de cet appareil';

  @override
  String get cardDetailDeleteRemote => 'Supprimer de Drive';

  @override
  String get cardCloseBarrier => 'Fermer';

  @override
  String statDayYear(int day, int year) {
    return 'Jour $day · Année $year';
  }

  @override
  String statDayOnly(int day) {
    return 'Jour $day';
  }

  @override
  String get statPlaytime => 'Temps de jeu';

  @override
  String get statMoney => 'Pièces';

  @override
  String get statTotal => 'Total';

  @override
  String get statMineUnexplored => 'Inexploré';

  @override
  String get statMine => 'Mine';

  @override
  String get statMineLvl => 'Mine · Nv';

  @override
  String get skillFarming => 'Agriculture';

  @override
  String get skillForaging => 'Cueillette';

  @override
  String get skillMining => 'Minage';

  @override
  String get skillFishing => 'Pêche';

  @override
  String get skillCombat => 'Combat';

  @override
  String get cardLocalPresence => 'Sur cet appareil';

  @override
  String get cardRemotePresence => 'Sur Drive';

  @override
  String get cardNotPresent => 'Absent';

  @override
  String get cardActionSynced => 'Synchronisé';

  @override
  String get cardActionUpload => 'Envoyer';

  @override
  String get cardActionDownload => 'Télécharger';

  @override
  String get pillMonsters => 'monstres';

  @override
  String get pillFriends => 'amis';

  @override
  String get pillFaints => 'évanouissements';

  @override
  String get pillSleeps => 'Dodos';

  @override
  String get hiwTitle => 'Comment ça marche';

  @override
  String get hiwSyncTitle => 'Comment fonctionne la synchronisation';

  @override
  String get hiwSyncIntro =>
      'ValleySave utilise votre propre Google Drive pour déplacer les sauvegardes entre appareils. Pas de serveurs intermédiaires : les fichiers sont les vôtres.';

  @override
  String get hiwSyncDevice => 'Votre\nappareil';

  @override
  String get hiwSyncCloud => 'Google\nDrive';

  @override
  String get hiwSyncOtherDevice => 'Autre\nappareil';

  @override
  String get hiwUploadTitle => 'Envoyer une sauvegarde';

  @override
  String get hiwUploadDesc =>
      'Lors de l\'envoi, ValleySave copie les deux fichiers de sauvegarde (SaveGameInfo + fichier ferme) dans votre dossier ValleySave/ sur Drive.';

  @override
  String get hiwDownloadTitle => 'Télécharger une sauvegarde';

  @override
  String get hiwDownloadDesc =>
      'Lors du téléchargement, ValleySave récupère les fichiers depuis Drive et les place directement dans le dossier du jeu.';

  @override
  String get hiwCompareTitle => 'Que compare-t-il?';

  @override
  String get hiwCompareIntro =>
      'Pour savoir quelle version est en avance, ValleySave utilise le temps de jeu total — la seule donnée qui ne peut que croître.';

  @override
  String get hiwCompareNote =>
      'Avant de confirmer, vous verrez aussi, pour pouvoir décider :';

  @override
  String get hiwCompareMoney => 'Argent actuel et total gagné';

  @override
  String get hiwCompareMine => 'Niveau de la mine';

  @override
  String get hiwCompareSkills => 'Compétences (agriculture, minage, combat…)';

  @override
  String get hiwCompareRelations => 'Amis, monstres tués, évanouissements';

  @override
  String get hiwCompareStamina => 'Énergie et santé';

  @override
  String get hiwCompareNotShown =>
      'Ceux-ci ne sont pas affichés — ils varient dans tous les sens et n\'indiquent pas quelle sauvegarde est en avance.';

  @override
  String get hiwCompareNotShownExamples =>
      'État des cultures et animaux, inventaire et objets, relations individuelles';

  @override
  String get hiwCompareWarning =>
      'Ils ne sont pas affichés — ils varient dans tous les sens et n\'indiquent pas quelle sauvegarde est en avance.';

  @override
  String get hiwConflictTitle => 'Si vous jouez sans synchroniser';

  @override
  String get hiwConflictDesc =>
      'Si vous progressez sur mobile et PC sans synchroniser entre les sessions, vous vous retrouvez avec deux versions de la même sauvegarde.';

  @override
  String get hiwConflictNoMerge =>
      'Elles ne peuvent pas être fusionnées. ValleySave vous affiche toujours les deux versions pour que vous puissiez choisir laquelle conserver.';

  @override
  String get hiwConflictMobile => 'Mobile';

  @override
  String get hiwConflictVersionA => 'version A';

  @override
  String get hiwConflictPC => 'PC';

  @override
  String get hiwConflictVersionB => 'version B';

  @override
  String get hiwDeleteTitle => 'Si une sauvegarde est supprimée';

  @override
  String get hiwDeleteDesc =>
      'Quand vous supprimez une sauvegarde de Drive, elle ne disparaît pas immédiatement : elle va dans la Corbeille de Google Drive.';

  @override
  String get hiwCompatTitle => 'Compatibilité des plateformes';

  @override
  String get hiwCompatAndroidAccess => 'ACCÈS SUR ANDROID';

  @override
  String get hiwShizukuTitle => 'Avec Shizuku';

  @override
  String get hiwShizukuSubtitle =>
      'Configurer une fois. Ensuite, ValleySave synchronise tout seul, sans que vous ayez à intervenir.';

  @override
  String get hiwShizukuBadge => 'AUTOMATIQUE · RECOMMANDÉ';

  @override
  String get hiwShizukuDone =>
      '✓  Terminé. À partir de là, télécharger et envoyer des sauvegardes est direct, comme sur un ordinateur.';

  @override
  String get hiwShizukuNote =>
      'Le jumelage n\'est nécessaire qu\'une seule fois. Les nouvelles versions de Shizuku se réactivent d\'elles-mêmes après le redémarrage du téléphone.';

  @override
  String get hiwBridgeTitle => 'Pont manuel';

  @override
  String get hiwBridgeSubtitle =>
      'Fonctionne uniquement sur Android 11 et 12. Vous n\'installez rien de plus ; vous copiez la sauvegarde manuellement avec votre application Fichiers à chaque synchronisation.';

  @override
  String get hiwBridgeBadge => 'ALTERNATIVE MANUELLE · ANDROID 11-12';

  @override
  String get hiwBridgeSaveFolder => 'Dossier Stardew';

  @override
  String get hiwBridgeValleySaveFolder => 'Dossier ValleySave';

  @override
  String get hiwBridgeNote =>
      'Cela fonctionne parce que votre application Fichiers système peut accéder à ces dossiers (ValleySave ne le peut pas).';

  @override
  String get hiwTipAlwaysShow =>
      'Vous verrez toujours ce qui est sur Drive avant d\'écraser, pour pouvoir comparer.';

  @override
  String get hiwTipWithoutUpload =>
      'Sans envoi, aucun autre appareil ne verra votre progression récente.';

  @override
  String get hiwTipComparison =>
      'Vous verrez la comparaison entre local et Drive avant de confirmer.';

  @override
  String get hiwTipDownloadOverwrite =>
      'Le téléchargement écrase votre sauvegarde locale. Toute progression non synchronisée sera perdue.';

  @override
  String get hiwTipSync =>
      'Envoyez toujours avant de changer d\'appareil, et téléchargez à l\'arrivée.';

  @override
  String get hiwTipDeletion =>
      'Vous avez 30 jours pour la restaurer depuis la Corbeille Drive avant sa suppression définitive.';

  @override
  String get hiwPrivacyLink => 'Politique de confidentialité et utilisation';

  @override
  String get emptyNoSaves => 'Aucune sauvegarde trouvée';

  @override
  String get emptyNoSavesHint =>
      'Aucune sauvegarde locale ne peut être lue sur cet appareil';

  @override
  String get bridgeTitle => 'Importer vos sauvegardes';

  @override
  String get bridgeDesc =>
      'Pour voir et envoyer vos sauvegardes locales, copiez-les avec votre application Fichiers depuis le dossier Stardew vers ce dossier ValleySave. Puis glissez pour actualiser.';

  @override
  String get bridgeRefresh => 'Actualiser';

  @override
  String get bridgeChangeMode => 'Changer de méthode';

  @override
  String get loaderLoading => 'CHARGEMENT';

  @override
  String get loaderConnecting => 'connexion à Drive…';

  @override
  String get chooserTitle => 'Choisir comment se connecter';

  @override
  String get chooserAutomatic => 'Automatique · Recommandé';

  @override
  String get chooserManual => 'Alternative manuelle · Android 11-12';

  @override
  String get shizukuStepTitle => 'Configurer Shizuku';

  @override
  String get shizukuStep1Title => 'Installer Shizuku';

  @override
  String get shizukuStep1Desc => 'Télécharger depuis Play Store ou GitHub';

  @override
  String get shizukuStep2Title => 'Activer Shizuku';

  @override
  String get shizukuStep2Desc =>
      'Lancer l\'application et accorder les permissions';

  @override
  String get shizukuStep3Title => 'Accorder la permission';

  @override
  String get shizukuStep3Desc => 'ValleySave demandera l\'accès';

  @override
  String get shizukuDone =>
      '✓  Terminé. À partir de là, télécharger et envoyer des sauvegardes fonctionne directement, comme sur un ordinateur.';

  @override
  String get dlgDeleteDriveTitle => 'Supprimer de Drive';

  @override
  String get dlgDeleteLocalTitle => 'Supprimer de cet appareil';

  @override
  String get dlgDownloadTitle => 'Télécharger la sauvegarde';

  @override
  String get dlgUploadTitle => 'Envoyer la sauvegarde';

  @override
  String get dlgUploadOverwrite => 'Cela écrasera votre sauvegarde locale';

  @override
  String get dlgGotIt => 'Compris';

  @override
  String get dlgCopyDest => 'Destination de la copie';

  @override
  String get previewColDayYear => 'Jour/Année';

  @override
  String get previewColTime => 'Temps de jeu';

  @override
  String get previewColMoney => 'Pièces';

  @override
  String get previewColTotal => 'Total';

  @override
  String get previewColFarming => 'Agriculture';

  @override
  String get previewColForaging => 'Cueillette';

  @override
  String get previewColMining => 'Minage';

  @override
  String get previewColFishing => 'Pêche';

  @override
  String get previewColCombat => 'Combat';

  @override
  String get previewColFriends => 'Amis';

  @override
  String get previewColMonsters => 'Monstres';

  @override
  String get previewColFaints => 'Évanouissements';

  @override
  String get previewColMine => 'Mine';

  @override
  String get previewColUnexplored => 'Inexploré';

  @override
  String get previewLocalLabel => 'SUR CET APPAREIL';

  @override
  String get previewDriveLabel => 'SUR DRIVE';

  @override
  String get previewFromDrive => 'DEPUIS DRIVE';

  @override
  String get previewFromDevice => 'DEPUIS CET APPAREIL';

  @override
  String versionMismatch(String local, String drive) {
    return 'Versions différentes : local $local · Drive $drive…';
  }

  @override
  String get snackPathCopied => 'Chemin copié';

  @override
  String get snackDestCopied => 'Chemin de destination copié';

  @override
  String get snackDownloaded => 'Sauvegarde téléchargée dans le jeu';

  @override
  String get snackSessionExpired => 'Session Drive expirée. Reconnectez-vous';

  @override
  String snackUploadError(String error) {
    return 'Erreur d\'envoi : $error';
  }

  @override
  String snackDownloadError(String error) {
    return 'Erreur de téléchargement : $error';
  }

  @override
  String snackDeleteError(String error) {
    return 'Erreur de suppression : $error';
  }

  @override
  String snackTrashed(String saveName) {
    return '\"$saveName\" déplacé vers la Corbeille Drive. Vous avez 30 jours pour le restaurer.';
  }

  @override
  String snackDeletedLocal(String saveName) {
    return '\"$saveName\" supprimé de cet appareil';
  }

  @override
  String get snackShizukuRequired => 'Activez Shizuku…';

  @override
  String get snackWriteError =>
      'Impossible d\'écrire dans le jeu. Certains téléphones bloquent /Android/data même avec Shizuku.';

  @override
  String get snackPlatformNotSupported =>
      'Cette plateforme ne prend pas encore en charge l\'écriture de sauvegardes locales.';

  @override
  String get snackWirelessDebugHint =>
      'Ouvrir manuellement : Paramètres → Options développeur → Débogage sans fil.';

  @override
  String get snackOpenShizukuApp =>
      'Ouvrez Shizuku depuis votre tiroir d\'applications.';

  @override
  String get hiwTipDeletePermanent =>
      'ValleySave ne peut pas récupérer les sauvegardes supprimées définitivement. Les fichiers Drive sont votre responsabilité.';

  @override
  String get hiwCompatAchievements =>
      'Les succès Steam et Google Play ne se transfèrent pas. Chaque plateforme ne suit que les succès obtenus en temps réel — le fichier de sauvegarde ne les déclenche pas rétroactivement.';

  @override
  String get hiwCompatOverwrite =>
      'Si vous synchronisez depuis deux appareils sans ordre établi, une sauvegarde peut écraser l\'autre. Envoyez toujours avant de télécharger.';

  @override
  String get hiwCompatVersions =>
      'Les sauvegardes de différentes versions du jeu peuvent ne pas se charger correctement. ValleySave vous avertit s\'il détecte une incompatibilité de version avant le téléchargement.';

  @override
  String get hiwCompatMods =>
      'Les mods SMAPI ajoutent des données supplémentaires à la sauvegarde. Si vous chargez une sauvegarde moddée sur un appareil où ces mods ne sont pas installés, le jeu peut planter ou perdre les données des mods.\n\nSur Android, SMAPI peut également être installé pour utiliser des mods.';

  @override
  String get hiwComparePrimary => 'Temps de jeu total';

  @override
  String get hiwCompareNoShown1 => 'État des cultures et animaux';

  @override
  String get hiwCompareNoShown2 => 'Inventaire et objets';

  @override
  String get hiwCompareNoShown3 => 'Relations individuelles';

  @override
  String get hiwShizuku1 => 'Installez Shizuku (Play Store ou APK GitHub).';

  @override
  String get hiwShizuku2 =>
      'Activez-le avec le Débogage sans fil — ValleySave vous guide étape par étape.';

  @override
  String get hiwShizuku3 =>
      'Accordez la permission à ValleySave lorsque vous y êtes invité.';

  @override
  String get hiwBridge1 =>
      'Télécharger depuis Drive : ValleySave dépose la sauvegarde dans son dossier. Vous la copiez avec Fichiers vers le dossier Stardew.';

  @override
  String get hiwBridge2 =>
      'Envoyer sur Drive : copiez la sauvegarde de Stardew vers le dossier ValleySave. ValleySave la détecte et l\'envoie.';

  @override
  String get snackShizukuBattery =>
      'Paramètres → Applications → Shizuku → Batterie → Sans restriction.';

  @override
  String snackDriveError(String error) {
    return 'Drive : $error';
  }

  @override
  String get dlgDeleteLocalWarning =>
      '⚠️ Si vous n\'avez pas envoyé sur Drive, elle sera perdue définitivement. Aucune récupération possible.';

  @override
  String get dlgDelete => 'Supprimer';

  @override
  String get dlgDownloadButton => 'Télécharger';

  @override
  String get dlgUploadButton => 'Envoyer';

  @override
  String get dlgBridgeCopyTitle => 'Copier la sauvegarde dans le jeu';

  @override
  String dlgBridgeCopyDesc(String saveName) {
    return 'Sauvegarde prête. Avec votre application Fichiers, copiez le dossier \"$saveName\" et collez-le dans le dossier Stardew.';
  }

  @override
  String get labelFrom => 'De';

  @override
  String get labelTo => 'À';

  @override
  String dlgDownloadNewDesc(String saveName, int day, String playtime) {
    return '\"$saveName\" (Jour $day, $playtime) sera copié sur cet appareil.';
  }

  @override
  String dlgDownloadOverwrite(String saveName) {
    return 'Cela ÉCRASE votre sauvegarde locale de \"$saveName\".';
  }

  @override
  String dlgUploadNewDesc(String saveName, int day, String playtime) {
    return '\"$saveName\" (Jour $day, $playtime) sera envoyé sur votre Drive.';
  }

  @override
  String dlgUploadOverwriteDrive(String saveName) {
    return 'Cela ÉCRASE la version Drive de \"$saveName\".';
  }

  @override
  String get pathLabelFromStardew => 'De (Stardew)';

  @override
  String get pathLabelToValleySave => 'À (ValleySave)';

  @override
  String get chooserDesc =>
      'Android protège le dossier du jeu. Choisissez comment donner l\'accès à ValleySave — vous pouvez changer à tout moment.';

  @override
  String get chooserShizukuDesc =>
      'Configuré une fois. Ensuite ValleySave synchronise tout seul, sans que vous touchiez à quoi que ce soit. Seule méthode fiable sur Android 13+.';

  @override
  String get chooserManualBadge => 'ANDROID 11-12 SEULEMENT';

  @override
  String get chooserBridgeDesc =>
      'Copiez les sauvegardes avec votre application Fichiers. Pas d\'installation supplémentaire. Uniquement sur Android 11 et 12.';

  @override
  String get shizukuGateSubtitle =>
      'Configuré une fois · première fois seulement';

  @override
  String get shizukuStatusLabel => 'Shizuku actif';

  @override
  String get shizukuStatusRunning => 'Connecté et en attente.';

  @override
  String get shizukuStatusNotDetected => 'Pas encore détecté.';

  @override
  String get shizukuPermLabel => 'Permission accordée';

  @override
  String get shizukuPermGranted => 'ValleySave a déjà l\'accès.';

  @override
  String get shizukuPermNotGranted => 'Besoin d\'autoriser ValleySave.';

  @override
  String get shizukuGrant => 'autoriser';

  @override
  String get shizukuGuideHeader => 'GUIDE ÉTAPE PAR ÉTAPE';

  @override
  String get shizukuStep1DescFull =>
      'Gratuit. Si Google Play le bloque sur votre téléphone, utilisez l\'APK officiel GitHub.';

  @override
  String get btnPlayStore => 'Play Store';

  @override
  String get btnApkGithub => 'APK GitHub';

  @override
  String get shizukuStep2TitleFull => 'Activer les options développeur';

  @override
  String get shizukuStep2DescFull =>
      'Paramètres → Infos sur le téléphone → Infos logicielles → appuyez 7 fois sur \"Numéro de build\".';

  @override
  String get shizukuStep3TitleFull => 'Activer le débogage sans fil';

  @override
  String get shizukuStep3DescFull =>
      'Le bouton vous y amène et le met en évidence. Activez-le (ON). Puis appuyez sur \"Appairer l\'appareil avec un code d\'appairage\" — un code à 6 chiffres apparaîtra à l\'écran.';

  @override
  String get btnOpenAndHighlight => 'Ouvrir et mettre en évidence';

  @override
  String get shizukuStep4Title => 'Appairer et DÉMARRER Shizuku';

  @override
  String get shizukuStep4Desc =>
      'Ouvrez Shizuku → \"Démarrer via le débogage sans fil\" → \"Appairer avec un code d\'appairage\". Shizuku enverra une notification indiquant qu\'il attend. Entrez le code à 6 chiffres de l\'écran de débogage sans fil. Après l\'appairage, appuyez sur DÉMARRER — sans ce dernier appui, Shizuku ne sera pas actif.';

  @override
  String get btnOpenShizuku => 'Ouvrir Shizuku';

  @override
  String get shizukuStep5Title =>
      'Régler la batterie de Shizuku sur Sans restriction';

  @override
  String get shizukuStep5Desc =>
      'Ouvrez les infos de l\'application → Batterie → Sans restriction. Sinon, le système fermera Shizuku en arrière-plan et vous devrez appuyer à nouveau sur Démarrer.';

  @override
  String get btnShizukuAppInfo => 'Infos de l\'application Shizuku';

  @override
  String get shizukuStep6DescActive =>
      'Shizuku est actif. Appuyez sur le bouton pour autoriser.';

  @override
  String get shizukuStep6DescWaiting =>
      'Disponible une fois Shizuku actif (étape 4).';

  @override
  String get btnGrantPermission => 'Accorder la permission';

  @override
  String get btnCheckShizuku => 'Terminé · Vérifier';

  @override
  String get statusDone => 'fait';

  @override
  String get statusPending => 'en attente';

  @override
  String get latestBadge => '· DERNIÈRE SAUVEGARDE ·';

  @override
  String saveDateLabel(String season, int year) {
    return '$season · Année $year';
  }

  @override
  String get petCat => 'Chat';

  @override
  String get petDog => 'Chien';

  @override
  String get houseBasic => 'Maison de base';

  @override
  String get houseKitchen => 'Avec cuisine';

  @override
  String get houseBedroom => 'Avec chambre';

  @override
  String get houseCellar => 'Avec cave';

  @override
  String houseLevelN(int level) {
    return 'Nv. $level';
  }
}
