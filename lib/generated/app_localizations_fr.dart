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
  String get updateNeedsPermission =>
      'Active « installer des applications inconnues » pour ValleySave, puis appuie de nouveau sur Mettre à jour';

  @override
  String get disconnectTitle => 'Déconnecter Drive?';

  @override
  String disconnectBody(String email) {
    return 'Vos sauvegardes sur Drive ne seront pas supprimées. Vous pouvez vous reconnecter à tout moment.';
  }

  @override
  String get disconnectButton => 'Déconnecter Drive';

  @override
  String disconnectButtonEmail(String email) {
    return 'Se déconnecter de $email';
  }

  @override
  String get connectedAsPrefix => 'Connecté en tant que';

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
  String get exportAction => 'Exporter';

  @override
  String get exportSuccess => 'Sauvegarde exportée.';

  @override
  String exportError(String error) {
    return 'Impossible d\'exporter la sauvegarde : $error';
  }

  @override
  String get importAction => 'Importer une sauvegarde';

  @override
  String importSuccess(String playerName) {
    return 'Sauvegarde de $playerName importée.';
  }

  @override
  String get importErrInvalidZip => 'Ce fichier n\'est pas un zip valide.';

  @override
  String get importErrUnsafePath =>
      'Ce fichier a une structure non sécurisée et a été rejeté.';

  @override
  String get importErrTooLarge =>
      'Ce fichier est trop volumineux pour être importé.';

  @override
  String get importErrNotASave =>
      'Ce fichier ne contient pas de sauvegarde reconnaissable.';

  @override
  String get importErrWrite =>
      'Impossible d\'écrire la sauvegarde importée (disque/permissions).';

  @override
  String get importErrBackupFailed =>
      'Impossible de créer une sauvegarde de secours. Rien n\'a été importé.';

  @override
  String get importConflictTitle => 'Une sauvegarde portant ce nom existe déjà';

  @override
  String get importConflictBody =>
      'L\'importation remplacera la copie locale existante. Irréversible.';

  @override
  String get importConflictConfirm => 'Écraser';

  @override
  String get shareAction => 'Partager';

  @override
  String get shareUploadFirstCta => 'Envoyer d\'abord';

  @override
  String get shareDialogTitle => 'Partager la sauvegarde';

  @override
  String get shareEmailPlaceholder => 'nom@exemple.com';

  @override
  String get shareInfoNote =>
      'Le partage donne un accès en consultation et téléchargement uniquement. Vous seul pouvez modifier ou supprimer votre copie sur Drive.';

  @override
  String get shareRoleReader => 'Lecture seule';

  @override
  String get shareRoleWriter => 'Autoriser la synchronisation';

  @override
  String get shareInfoNoteCoop =>
      'Lecture seule permet de voir et de télécharger. Autoriser la synchronisation permet d\'écraser votre copie sur Drive — ils ne pourront jamais la supprimer.';

  @override
  String get shareConfirmButton => 'Partager';

  @override
  String shareSuccess(String email) {
    return 'Partagé avec $email.';
  }

  @override
  String get manageAccessTitle => 'Personnes ayant accès';

  @override
  String get manageAccessEmpty => 'Personne d\'autre n\'a encore accès.';

  @override
  String get manageAccessRoleLabel => 'Accès';

  @override
  String get manageAccessRevoke => 'Révoquer';

  @override
  String manageAccessRevokeConfirm(String email) {
    return 'Retirer l\'accès de $email ? Toute copie locale déjà téléchargée reste la sienne.';
  }

  @override
  String get driveOnlyControlsYourCopy =>
      'Le partage contrôle votre copie sur Drive. Si quelqu\'un la télécharge, cette copie lui appartient.';

  @override
  String get driveOnlyControlsYourCopyCoop =>
      'La synchronisation contrôle votre copie sur Drive — elle peut être écrasée, mais jamais supprimée, par les personnes que vous autorisez.';

  @override
  String get sharedWithMeTitle => 'Partagées avec moi';

  @override
  String get sharedWithMeEmpty => 'Rien n\'a encore été partagé avec vous.';

  @override
  String get sharedWithMeAdd => 'Ajouter une sauvegarde partagée';

  @override
  String sharedWithMeOwnedBy(String email) {
    return 'Partagée par $email';
  }

  @override
  String get sharedWithMeRoleSync => 'Synchronise';

  @override
  String get sharedWithMeRoleRead => 'Lecture seule';

  @override
  String get sharedWithMeSync => 'Synchroniser';

  @override
  String get sharedWithMeDownload => 'Télécharger';

  @override
  String get sharedWithMeRemove => 'Se déconnecter';

  @override
  String sharedWithMeRemoveConfirm(String email) {
    return 'Vous ne synchroniserez plus avec le Drive de $email, mais vous pouvez l\'ajouter à nouveau quand vous voulez — elle reste partagée. Votre copie locale reste une sauvegarde coop normale.';
  }

  @override
  String sharedLeaveConfirm(Object email) {
    return 'Vous perdrez vraiment l\'accès à cette sauvegarde. Vous ne pourrez pas l\'ajouter à nouveau sauf si $email la repartage avec vous. Votre copie locale reste une sauvegarde coop normale.';
  }

  @override
  String get sharedManageButton => 'Gérer';

  @override
  String get sharedManageDialogTitle => 'Gérer les partages';

  @override
  String get sharedManageDialogHint =>
      'Ici, vous pouvez vraiment quitter une sauvegarde partagée.';

  @override
  String get sharedLeaveButton => 'Quitter le partage';

  @override
  String sharedLeaveSuccess(Object email) {
    return 'Vous avez quitté le partage de $email.';
  }

  @override
  String sharedWithMeSyncConfirm(String email) {
    return 'Écraser la copie de $email sur Drive avec votre sauvegarde locale ?';
  }

  @override
  String sharedAccessReadOnly(String email) {
    return '$email vous a mis en lecture seule — vous pouvez voir et télécharger, mais pas synchroniser vers son Drive.';
  }

  @override
  String get sharedWithMeRevoked => 'Vous n\'avez plus accès';

  @override
  String sharedRevokedDialogBody(String email, String farmName) {
    return '$email a cessé de partager $farmName avec vous. Votre copie locale et celle de votre Drive restent telles quelles, désormais dans Mes sauvegardes.';
  }

  @override
  String get sharedRevokedAccept => 'Accepter';

  @override
  String get sharedSelfCleanupTitle => 'Enregistrement corrigé';

  @override
  String sharedSelfCleanupBody(String farmName) {
    return '$farmName apparaissait par erreur comme partagée avec vous — en réalité, elle est à vous. Cela a été corrigé, elle se trouve maintenant dans Mes sauvegardes.';
  }

  @override
  String get sharedWithMeUploadOwn => 'Envoyer vers mon Drive';

  @override
  String get sharedDownloadOwn => 'Télécharger depuis mon Drive';

  @override
  String get sharedStatusOwnDriveAhead =>
      'Votre Drive a de l\'avance — téléchargez-le';

  @override
  String get sharedSyncBoth => 'Envoyer vers les deux Drives';

  @override
  String get sharedSideMyDrive => 'MON DRIVE';

  @override
  String sharedSideOwnerDrive(String email) {
    return 'DRIVE DE $email';
  }

  @override
  String sharedSideDate(int day, int year) {
    return 'Jour $day · Année $year';
  }

  @override
  String get sharedStatusSyncedNoOwnDrive =>
      'Synchronisé avec le propriétaire · aucune copie sur votre Drive';

  @override
  String get sharedStatusAheadNoOwnDrive =>
      'Vous avez de l\'avance · aucune copie sur votre Drive';

  @override
  String sharedStatusOwnerAheadNoOwnDrive(String email) {
    return '$email a de l\'avance · aucune copie sur votre Drive';
  }

  @override
  String get sharedStatusAllSynced => 'Synchronisé (local + les deux Drives)';

  @override
  String get sharedStatusAheadBoth =>
      'Vous avez de l\'avance sur les deux Drives';

  @override
  String get sharedStatusMixed => 'Désynchronisé — vérifiez chaque Drive';

  @override
  String get sharedStatusFullySynced => 'Entièrement synchronisé';

  @override
  String get sharedStatusSyncedOwn => 'Mon Drive synchronisé';

  @override
  String get sharedStatusSyncedOwner => 'Drive partagé synchronisé';

  @override
  String get sharedStatusNotCloud => 'Uniquement sur cet appareil';

  @override
  String sharedStatusOwnerAhead(Object email) {
    return 'Le Drive de $email a de l\'avance';
  }

  @override
  String get sharedStatusBothAhead => 'Les deux Drives ont de l\'avance';

  @override
  String get sharedStatusLocalMissing => 'Absente de cet appareil';

  @override
  String sharedStatusOwnerUnavailable(Object email) {
    return 'Impossible de vérifier le Drive de $email';
  }

  @override
  String get sharedStatusWorking => 'Synchronisation…';

  @override
  String get sharedSideUnavailable => 'Impossible à vérifier';

  @override
  String get sharedSyncChooseTitle => 'Où voulez-vous synchroniser ?';

  @override
  String get sharedSyncChooseBody =>
      'Choisissez quelles copies dans le cloud vous voulez mettre à jour avec la sauvegarde de cet appareil.';

  @override
  String get sharedSyncTargetOwn => 'Mon Drive';

  @override
  String sharedSyncTargetOwner(Object email) {
    return 'Drive de $email';
  }

  @override
  String get sharedSyncTargetBoth => 'Les deux Drives';

  @override
  String get sharedDownloadChooseTitle =>
      'Quelle copie voulez-vous télécharger ?';

  @override
  String get sharedDownloadChooseBody =>
      'Plusieurs copies ont de l\'avance. Choisissez celle que vous voulez amener sur cet appareil.';

  @override
  String get sharedDownloadSourceOwn => 'Depuis mon Drive';

  @override
  String sharedDownloadSourceOwner(Object email) {
    return 'Depuis le Drive de $email';
  }

  @override
  String get sharedWithMePickerTitle => 'Ajouter une sauvegarde partagée';

  @override
  String get sharedPickerEmptyHint =>
      'Ce qu\'un autre joueur partage avec vous depuis Drive apparaît ici.';

  @override
  String get sharedPickerAddButton => 'Ajouter';

  @override
  String get sharedOriginBadge => 'Partagée';

  @override
  String sharedOriginFrom(String email) {
    return 'de $email';
  }

  @override
  String get swapBackupDialogTitle => 'Sauvegarde de secours créée';

  @override
  String get swapBackupDialogBody =>
      'La version précédente a été enregistrée en zip. Que voulez-vous en faire ?';

  @override
  String get swapBackupUpload => 'Envoyer vers Drive';

  @override
  String get swapBackupLocalOnly => 'Conserver sur cet appareil';

  @override
  String get swapBackupDeleteNow => 'Supprimer maintenant';

  @override
  String get swapBackupUploadOk => 'Sauvegarde de secours envoyée vers Drive.';

  @override
  String swapBackupUploadErr(String error) {
    return 'Impossible d\'envoyer la sauvegarde de secours : $error';
  }

  @override
  String get swapBackupLocalOnlySnack =>
      'Sauvegarde de secours enregistrée sur cet appareil.';

  @override
  String get backupsAction => 'Sauvegardes';

  @override
  String backupsScreenTitle(String farmName) {
    return 'Sauvegardes de secours de $farmName';
  }

  @override
  String get backupsEmpty => 'Pas encore de sauvegardes de secours.';

  @override
  String get backupsRestore => 'Restaurer';

  @override
  String get backupsRestoreConfirmTitle =>
      'Restaurer cette sauvegarde de secours ?';

  @override
  String get backupsRestoreConfirmBody =>
      'Cela écrase votre sauvegarde actuelle avec cette version antérieure. Irréversible.';

  @override
  String get backupsDelete => 'Supprimer';

  @override
  String get backupsDeleteConfirmTitle =>
      'Supprimer cette sauvegarde de secours ?';

  @override
  String get backupsDeleteConfirmBody =>
      'Elle sera supprimée partout où elle existe (cet appareil et Drive, si elle a été envoyée). Irréversible.';

  @override
  String get backupsRestoreOk => 'Sauvegarde de secours restaurée.';

  @override
  String get backupsRestoreManualTitle => 'Restaurer manuellement';

  @override
  String get backupsRestoreManualBody =>
      'En mode Pont, ValleySave ne peut pas écrire automatiquement dans le dossier du jeu. Extrayez vous-même le .zip de cette sauvegarde de secours dans le dossier Saves de Stardew Valley, ou passez au mode Root/Shizuku dans les Paramètres pour restaurer automatiquement.';

  @override
  String backupsRestoreErr(String error) {
    return 'Impossible de restaurer la sauvegarde de secours : $error';
  }

  @override
  String backupsDeleteErr(String error) {
    return 'Impossible de supprimer la sauvegarde de secours : $error';
  }

  @override
  String get backupsCreate => 'Créer une sauvegarde de secours locale';

  @override
  String get backupsCreateLocalHint =>
      'Les sauvegardes de secours sont d\'abord créées sur cet appareil. Vous pourrez ensuite les envoyer vers Drive.';

  @override
  String get backupsCreateOk => 'Sauvegarde de secours créée.';

  @override
  String backupsCreateErr(String error) {
    return 'Impossible de créer la sauvegarde de secours : $error';
  }

  @override
  String get backupsDownload => 'Télécharger';

  @override
  String get backupsDownloadOk =>
      'Sauvegarde de secours téléchargée sur cet appareil.';

  @override
  String backupsDownloadErr(String error) {
    return 'Impossible de télécharger la sauvegarde de secours : $error';
  }

  @override
  String get backupsCopyOwn => 'Copier vers mon Drive';

  @override
  String get backupsUploadOwn => 'Vers mon Drive';

  @override
  String get backupsUploadShared => 'Vers le Drive partagé';

  @override
  String get backupsUploadOk => 'Sauvegarde de secours envoyée.';

  @override
  String backupsUploadErr(String error) {
    return 'Impossible d\'envoyer la sauvegarde de secours : $error';
  }

  @override
  String get backupsLocationLocal => 'Cet appareil';

  @override
  String get backupsLocationOwnDrive => 'Mon Drive';

  @override
  String get backupsLocationSharedDrive => 'Drive partagé';

  @override
  String get backupsDeleteChooseBody =>
      'Choisissez précisément où la supprimer. Seuls les emplacements où cette sauvegarde de secours existe s\'affichent.';

  @override
  String get backupsDeleteLocalOnly => 'Uniquement de cet appareil';

  @override
  String get backupsDeleteOwnOnly => 'Uniquement de mon Drive';

  @override
  String get backupsDeleteSharedOnly => 'Uniquement du Drive partagé';

  @override
  String get backupsDeleteAll => 'De toutes les copies';

  @override
  String deleteUnifiedTitle(String farmName) {
    return 'Supprimer $farmName ?';
  }

  @override
  String get deleteChooseLocationBody =>
      'Choisissez d\'où. La copie de cet appareil est supprimée pour toujours ; celle de Drive va à la Corbeille (30 jours).';

  @override
  String deleteDriveContextTitle(String farmName) {
    return 'Supprimer $farmName de Drive ?';
  }

  @override
  String get deleteDriveContextBody =>
      'La copie sur Drive ira à la Corbeille, où vous pourrez la récupérer pendant 30 jours.';

  @override
  String get deleteDriveLocalKept =>
      'La copie sur cet appareil restera inchangée.';

  @override
  String deleteLocalContextTitle(String farmName) {
    return 'Supprimer $farmName de cet appareil ?';
  }

  @override
  String get deleteLocalContextBody =>
      'La copie sur cet appareil sera supprimée pour toujours.';

  @override
  String deleteLocalDriveCurrent(String date) {
    return 'Votre copie sur Drive est à jour ($date) et restera disponible.';
  }

  @override
  String deleteLocalDriveAhead(String date) {
    return 'Votre copie sur Drive est plus récente ($date) et restera disponible.';
  }

  @override
  String deleteLocalDriveOlder(String driveDate, String localDate) {
    return 'Votre copie sur Drive est antérieure ($driveDate) ; cet appareil en est à $localDate.';
  }

  @override
  String deleteLocalBackupAvailable(int count) {
    return 'Il y a $count sauvegardes de secours locales disponibles au cas où vous auriez besoin d\'une copie antérieure.';
  }

  @override
  String get deleteLocalNoRecovery =>
      'Il n\'y a ni copie sur Drive ni sauvegarde de secours locale permettant de récupérer cette sauvegarde.';

  @override
  String get deleteOptionLocalOnly => 'Uniquement de cet appareil';

  @override
  String get deleteOptionDriveOnly => 'Uniquement de Drive';

  @override
  String get deleteOptionBoth => 'Des deux copies (appareil + Drive)';

  @override
  String get viewPlayersHint => 'Voir les joueurs';

  @override
  String snackDeletedBoth(String saveName) {
    return '\"$saveName\" supprimée de cet appareil et déplacée vers la Corbeille Drive.';
  }

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
  String get hiwConnectTitle => 'Connecter votre compte';

  @override
  String get hiwConnectDesc =>
      'ValleySave utilise votre compte Google pour enregistrer vos sauvegardes dans un dossier ValleySave privé sur votre propre Drive.';

  @override
  String get hiwConnectStepGoogle => 'Compte\nGoogle';

  @override
  String get hiwConnectStepDrive => 'Dossier ValleySave\ncréé';

  @override
  String get hiwConnectStepReady => 'Prêt à\nsynchroniser';

  @override
  String get hiwConnectTipOwnership =>
      'Vous seul pouvez modifier ou supprimer vos copies sur Drive — ValleySave ne fait que lire et écrire dans son propre dossier.';

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
  String get overwriteWhatChanges => 'Ce qui change';

  @override
  String get overwriteTagOverwritten => 'SERA ÉCRASÉ';

  @override
  String get overwriteNewCopyTag => 'NOUVEAU';

  @override
  String overwriteDeltaPhrase(int days, String time) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: '$days jours et $time',
      one: '1 jour et $time',
      zero: '$time',
    );
    return '$_temp0';
  }

  @override
  String overwriteVerdictAhead(String delta) {
    return 'Vous avez $delta d\'avance. C\'est sûr.';
  }

  @override
  String get overwriteVerdictMoneySpent =>
      '💰 L\'argent actuel a baissé, mais la progression globale avance — vous l\'avez probablement dépensé pour quelque chose. Ce n\'est pas une vraie perte.';

  @override
  String overwriteVerdictNegligible(String delta) {
    return 'Différence minime ($delta). Les deux copies conviennent.';
  }

  @override
  String overwriteVerdictDanger(String delta, String target) {
    return '⚠️ Vous allez perdre $delta de progression sur $target. Vérifiez avant de continuer.';
  }

  @override
  String get overwriteConfirmTitleUpload => 'Confirmer l\'envoi ?';

  @override
  String get overwriteConfirmTitleDownload => 'Confirmer le téléchargement ?';

  @override
  String overwriteConfirmBody(String delta, String target) {
    return 'Vous allez perdre $delta sur $target. Cette action est irréversible.';
  }

  @override
  String get overwriteConfirmButtonUpload => 'Confirmer l\'envoi';

  @override
  String get overwriteConfirmButtonDownload => 'Confirmer le téléchargement';

  @override
  String get overwriteDangerButtonUpload => '⚠️ Envoyer quand même';

  @override
  String get overwriteDangerButtonDownload => '⚠️ Télécharger quand même';

  @override
  String overwriteIdenticalSummary(int count, String list) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '✓ $count identiques',
      one: '✓ 1 identique',
    );
    return '$_temp0 — $list';
  }

  @override
  String overwriteUploadToOwner(String email) {
    return 'Envoyer vers le Drive de $email';
  }

  @override
  String get overwriteUploadBoth => 'Envoyer vers les deux Drives';

  @override
  String get overwriteConfirmTitleBoth => 'Confirmer les deux envois ?';

  @override
  String overwriteConfirmBodyBoth(String delta, String targets) {
    return 'Vous allez perdre $delta sur $targets. Cette action est irréversible.';
  }

  @override
  String overwriteBothDestinationsLabel(String first, String second) {
    return '$first et $second';
  }

  @override
  String get sharedTargetOwnDrive => 'votre Drive';

  @override
  String sharedStatusLocalAhead(String targets) {
    return 'Vous avez de l\'avance sur $targets';
  }

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
  String get snackReplacePrepareFailed =>
      'Impossible de préparer la sauvegarde. Rien n\'a été modifié sur le disque';

  @override
  String get snackReplaceValidationFailed =>
      'La sauvegarde téléchargée semble invalide ou incomplète. Rien n\'a été modifié sur le disque';

  @override
  String get snackReplaceBackupFailed =>
      'Impossible de créer une sauvegarde de secours. Rien n\'a été modifié sur le disque';

  @override
  String get snackReplaceSwapFailed =>
      'L\'échange a échoué, mais la sauvegarde d\'origine a été restaurée à partir de la copie de secours';

  @override
  String get snackReplaceBusy =>
      'Une opération est déjà en cours pour cette sauvegarde';

  @override
  String get snackUploadIncomplete =>
      'La sauvegarde locale est incomplète ou corrompue. Rien n\'a été envoyé';

  @override
  String get snackDownloadIncomplete =>
      'Impossible de télécharger : il manque du contenu sur Drive';

  @override
  String get cardIncomplete => 'Incomplète sur Drive';

  @override
  String get autoRefreshTitle => 'Actualisation automatique';

  @override
  String get autoRefreshSubtitle =>
      'Vérifie les changements sur Drive toutes les 30 s';

  @override
  String autoSyncSnack(String farmName) {
    return '$farmName synchronisée automatiquement';
  }

  @override
  String get autoSyncTooltipOn =>
      'Synchro auto activée — se synchronise seule quand c\'est sûr';

  @override
  String get autoSyncTooltipOff =>
      'Synchro auto désactivée — touchez pour l\'activer';

  @override
  String get autoSyncExplainTitle => 'Synchro auto';

  @override
  String autoSyncExplainBody(String farmName) {
    return 'À partir de maintenant, $farmName sera envoyée ou téléchargée seule quand c\'est sûr, sans vous demander de confirmation.';
  }

  @override
  String get autoSyncExplainSafe =>
      'Elle n\'agit que lorsque vous avez clairement de l\'avance et que rien n\'est perdu.';

  @override
  String get autoSyncExplainDanger =>
      'En cas de risque de perte de progression, elle n\'agit jamais seule : vous continuerez à décider via la boîte de dialogue habituelle.';

  @override
  String get autoSyncExplainMissing =>
      'Si l\'une des deux copies manque, elle ne la crée pas seule : le premier envoi ou téléchargement, c\'est vous qui décidez.';

  @override
  String get autoSyncExplainDontShowAgain => 'Ne plus afficher cet avis';

  @override
  String get autoSyncExplainConfirm => 'Compris, activer';

  @override
  String get hiwAutoSyncTitle => 'Synchronisation automatique';

  @override
  String get hiwAutoSyncDesc =>
      'Chaque sauvegarde a une puce AUTO sur sa carte. En l\'activant, cette sauvegarde s\'envoie ou se télécharge seule dès que l\'application détecte un changement — sans que vous ayez à l\'ouvrir pour confirmer.';

  @override
  String get hiwAutoSyncTipSafe =>
      'Elle ne se synchronise seule que lorsque vous avez clairement de l\'avance et que rien n\'est perdu.';

  @override
  String get hiwAutoSyncTipDanger =>
      'En cas de risque de perte de progression, elle ne le fait jamais seule : elle continue à vous demander avec la comparaison habituelle.';

  @override
  String get hiwAutoSyncTipPerSave =>
      'Elle s\'active sauvegarde par sauvegarde, pas d\'un coup : vous pouvez l\'avoir sur la vôtre et pas sur une partagée.';

  @override
  String get hiwAutoSyncTipMissing =>
      'Elle ne fait que maintenir synchronisées deux copies déjà existantes. Si l\'une manque, c\'est vous qui effectuez le premier envoi ou téléchargement.';

  @override
  String get hiwAutoSyncTipRefresh =>
      'Dans les Paramètres, vous pouvez désactiver complètement la vérification automatique des changements.';

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
  String get hiwCompatIncomplete =>
      'Si vous voyez \"Incomplète sur Drive\" sur une sauvegarde, il lui manque un fichier nécessaire dans le cloud — elle ne peut pas être téléchargée tant qu\'elle n\'a pas été correctement renvoyée depuis un autre appareil.';

  @override
  String get hiwShareTitle => 'Partager avec d\'autres';

  @override
  String get hiwShareDesc =>
      'Partagez une sauvegarde avec un autre joueur par e-mail. Il la verra dans Partagées avec moi sur son propre appareil.';

  @override
  String get hiwShareStepYourSave => 'Votre\nsauvegarde';

  @override
  String get hiwShareStepShare => 'Partager par\ne-mail';

  @override
  String get hiwShareStepFriend => 'Partagées\navec moi';

  @override
  String get hiwShareTipRoles =>
      'Deux rôles : Lecture seule permet de voir et de télécharger. Autoriser la synchronisation permet d\'écraser votre copie sur Drive. Dans tous les cas, ils ne peuvent jamais la supprimer — seul vous, le propriétaire, pouvez supprimer votre sauvegarde.';

  @override
  String get hiwShareTipDisconnect =>
      'Se déconnecter n\'arrête la synchronisation que de leur côté — le partage reste actif jusqu\'à ce que vous le quittiez vraiment depuis Gérer les partages.';

  @override
  String get hiwHostSwapTitle => 'Changement d\'hôte';

  @override
  String get hiwHostSwapDesc =>
      'Change quel Farmhand est l\'hôte de la sauvegarde, en la remplaçant sur place — même emplacement de sauvegarde, mêmes autorisations de partage.';

  @override
  String get hiwHostSwapStepPick => 'Choisir un\nFarmhand';

  @override
  String get hiwHostSwapStepConfirm => 'Confirmer';

  @override
  String get hiwHostSwapStepDone => 'Nouvelle sauvegarde\ncréée';

  @override
  String get hiwHostSwapTipMove =>
      'Certains objets de la ferme peuvent être déplacés pour faire de la place à la maison — rien n\'est supprimé.';

  @override
  String get hiwHostSwapTipHouse =>
      'La maison du nouvel hôte ressemblera à la grande maison par défaut du jeu — l\'apparence de cabane n\'est pas prise en charge sans mods.';

  @override
  String get hiwBackupsTitle => 'Sauvegardes de secours';

  @override
  String get hiwBackupsDesc =>
      'Une sauvegarde de secours est un instantané d\'une sauvegarde que vous pouvez restaurer plus tard. Créez-la manuellement quand vous voulez, ou laissez ValleySave en créer une automatiquement avant d\'écraser une sauvegarde (téléchargement, importation, restauration ou changement d\'hôte).';

  @override
  String get hiwBackupsStepSave => 'Votre\nsauvegarde';

  @override
  String get hiwBackupsStepSnapshot => 'Sauvegarde de secours\ncréée';

  @override
  String get hiwBackupsStepStore => 'Local et/ou\nDrive';

  @override
  String get hiwBackupsTipRestore =>
      'Restaurer écrase votre sauvegarde actuelle avec cette version antérieure — irréversible.';

  @override
  String get hiwBackupsTipDelete =>
      'Supprimer une sauvegarde de secours l\'efface partout où elle existe (cet appareil et Drive, si elle a été envoyée) — irréversible.';

  @override
  String get hiwBackupsTipExport =>
      'Vous pouvez aussi Exporter une sauvegarde en zip pour la conserver où vous voulez, et l\'Importer de nouveau plus tard — une alternative manuelle et portable aux sauvegardes de secours intégrées.';

  @override
  String get hiwBackupsTipRetention =>
      'ValleySave conserve les 5 sauvegardes de secours automatiques les plus récentes de chaque sauvegarde ; celles que vous créez manuellement ne sont jamais supprimées d\'elles-mêmes.';

  @override
  String get hiwBackupsTipRestoreBridge =>
      'En mode Pont (Android sans root/Shizuku), restaurer une sauvegarde de secours vous demande d\'extraire le .zip manuellement dans le dossier Stardew — comme lors du téléchargement.';

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
  String get chooserRootBadge => 'ROOT';

  @override
  String get chooserRootTitle => 'Accès Root';

  @override
  String get chooserRootDesc =>
      'Pour les appareils rootés (Magisk / SuperSU). Autorisez l\'accès root une fois — automatique ensuite.';

  @override
  String get snackRootDenied => 'Accès root refusé. Essayez Shizuku.';

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

  @override
  String get tooltipLaunchGame => 'Jouer';

  @override
  String get hiwLaunchTitle => 'Lancer le jeu';

  @override
  String get hiwLaunchDesc =>
      'Le bouton ▶ dans la barre supérieure de Mes sauvegardes ouvre Stardew Valley directement depuis l’app.';

  @override
  String get hiwLaunchTipWindows =>
      'Sur Windows, si le jeu n’est pas détecté automatiquement, configurez le chemin de l’exécutable dans Paramètres → Jeu.';

  @override
  String get hiwLaunchTipAndroid =>
      'Sur Android, ouvre le jeu s’il est installé.';

  @override
  String get hiwLaunchTipLinux =>
      'Sous Linux, si le jeu n\'est pas détecté automatiquement, définissez le chemin de l\'exécutable dans Paramètres → Jeu.';

  @override
  String get hiwSaveLocationsTitle => 'Où vivent vos sauvegardes';

  @override
  String get hiwSaveLocationsDesc =>
      'ValleySave lit et écrit directement dans le dossier de sauvegardes du jeu sur chaque plateforme.';

  @override
  String get hiwSaveLocationWindows =>
      'Windows : %AppData%\\StardewValley\\Saves';

  @override
  String get hiwSaveLocationAndroid =>
      'Android : dossier protégé, accessible via Shizuku ou le Pont';

  @override
  String get hiwSaveLocationLinux =>
      'Linux : ~/.config/StardewValley/Saves (ou ~/snap/steam/common/.config/StardewValley/Saves si Steam est installé via snap)';

  @override
  String get settingsGameSection => 'Jeu';

  @override
  String get settingsGameExePath => 'Exécutable Stardew Valley';

  @override
  String get settingsGameExeNotFound => 'Non trouvé automatiquement';

  @override
  String get settingsGameExeBrowse => 'Parcourir…';

  @override
  String get settingsGameExeSaved => 'Chemin enregistré';

  @override
  String get snackLaunchError => 'Impossible d’ouvrir le jeu';

  @override
  String get makeHostAction => 'DEVENIR HÔTE';

  @override
  String get makeHostExperimental => 'EXPÉRIMENTAL';

  @override
  String get makeHostDialogTitle => 'Changer d\'hôte';

  @override
  String makeHostDialogIntro(String playerName, String farmName) {
    return '$playerName deviendra l\'hôte de $farmName.';
  }

  @override
  String get makeHostNewCopyNote =>
      'Une nouvelle sauvegarde est créée. Vous déciderez ensuite quoi faire de l\'originale.';

  @override
  String makeHostMoveCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other:
          '$count objets de la ferme seront déplacés pour faire de la place à la maison. Rien n\'est supprimé.',
      one:
          '1 objet de la ferme sera déplacé pour faire de la place à la maison. Rien n\'est supprimé.',
    );
    return '$_temp0';
  }

  @override
  String get makeHostHouseWarning =>
      'La maison du nouvel hôte ressemblera à la grande ferme du jeu. L\'apparence de cabane n\'est pas prise en charge sans mods.';

  @override
  String get makeHostConfirmButton => 'Devenir hôte';

  @override
  String makeHostSuccess(String playerName) {
    return 'Nouvelle sauvegarde créée : $playerName est maintenant l\'hôte.';
  }

  @override
  String get hostSwapErrInvalid =>
      'Cette sauvegarde a une structure inattendue. Rien n\'a été modifié.';

  @override
  String get hostSwapErrNoSpace =>
      'Pas d\'espace libre dans la ferme pour déplacer les objets. Rien n\'a été modifié.';

  @override
  String get hostSwapErrWrite =>
      'Impossible d\'écrire la nouvelle sauvegarde (disque/permissions). Rien n\'a été modifié.';

  @override
  String get hostSwapErrValidation =>
      'La vérification de la nouvelle sauvegarde a échoué, elle a donc été supprimée. L\'originale est intacte.';

  @override
  String get makeHostDeleteOriginalTitle =>
      'Supprimer la sauvegarde d\'origine de cet appareil ?';

  @override
  String get makeHostDeleteOriginalBody =>
      'La nouvelle sauvegarde est prête. Sauvegardez d\'abord l\'originale sur votre Drive (vous pourrez la retélécharger plus tard) ou supprimez simplement la copie locale.';

  @override
  String get makeHostDeleteOriginalNoBackupBody =>
      'Pas de connexion à Drive : aucune sauvegarde ne subsistera. Seule la copie locale sur cet appareil sera supprimée.';

  @override
  String get makeHostDeleteOriginalUploadBody =>
      'La sauvegarde d\'origine sera d\'abord téléversée sur votre Drive comme sauvegarde de secours, puis la copie locale sur cet appareil sera supprimée.';

  @override
  String get makeHostDeleteWithoutUpload => 'Supprimer sans téléverser';

  @override
  String get makeHostUploadAndDelete => 'Téléverser et supprimer';
}
