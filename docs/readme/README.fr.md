<div align="center">

<img src="../../assets/icons/icon.png" width="200" height="200" alt="ValleySave — logo de l'application de synchronisation de sauvegardes Stardew Valley">

# ValleySave

**Synchronisez vos sauvegardes Stardew Valley entre Windows, macOS, Linux et Android — avec votre propre Google Drive.**

Pas de serveurs tiers. Pas d'abonnement. Pas de pistage. Vos sauvegardes ne quittent jamais votre propre compte Google.

[![Dernière version](https://img.shields.io/github/v/release/hirieo/valleysave-app?label=T%C3%A9l%C3%A9charger&color=brightgreen)](https://github.com/hirieo/valleysave-app/releases/latest)
[![Téléchargements](https://img.shields.io/github/downloads/hirieo/valleysave-app/total?color=blue)](https://github.com/hirieo/valleysave-app/releases)
[![Licence : Polyform NC](https://img.shields.io/badge/Licence-Polyform%20NC-orange)](../../LICENSE)
![Plateformes](https://img.shields.io/badge/Windows%20%7C%20macOS%20%7C%20Linux%20%7C%20Android-lightgrey)
[![ko-fi](https://ko-fi.com/img/githubbutton_sm.svg)](https://ko-fi.com/hirieo)

[🇬🇧 English](../../README.md) · [🇪🇸 Español](README.es.md) · 🇫🇷 Français · [🇩🇪 Deutsch](README.de.md) · [🇮🇹 Italiano](README.it.md) · [🇵🇹 Português](README.pt.md) · [Euskera](README.eu.md) · [🇷🇺 Русский](README.ru.md) · [🇺🇦 Українська](README.uk.md) · [🇯🇵 日本語](README.ja.md) · [🇰🇷 한국어](README.ko.md) · [🇨🇳 中文](README.zh.md) · [🇹🇼 中文（繁體）](README.zh-Hant.md) · [🇹🇭 ไทย](README.th.md)

</div>

---

> [!IMPORTANT]
> **ValleySave est en accès anticipé.** L'écran de connexion Google est encore en attente de vérification par Google, donc seuls les comptes Google inscrits sur liste blanche peuvent se connecter pour l'instant. Pour obtenir l'accès, écrivez à **lhirieo@gmail.com** avec le compte Google (adresse e-mail) que vous utiliserez avec ValleySave. L'application s'ouvrira à tous une fois la vérification de Google terminée.

## Qu'est-ce que ValleySave ?

Stardew Valley n'a pas de synchronisation cloud officielle entre PC et mobile. **ValleySave comble ce manque** : il détecte vos fermes, les téléverse dans un dossier `ValleySave/` de **votre propre Google Drive**, et vous permet de les télécharger pour continuer à jouer sur n'importe quel autre appareil — Windows, macOS, Linux ou Android.

- 🔒 **Vie privée d'abord** — utilise le scope restreint `drive.file` de Google : l'application ne voit que les fichiers qu'elle a créés, jamais le reste de votre Drive.
- 🖥️ **Vraiment multiplateforme** — un seul code (Flutter), des builds natifs pour les quatre plateformes.
- 🌍 **14 langues** — français, anglais, espagnol, basque, allemand, italien, portugais, russe, ukrainien, japonais, coréen, chinois (simplifié et traditionnel) et thaï.

## Fonctionnalités

### Synchronisation et transfert de sauvegardes
- **Détection automatique des fermes** — trouve vos sauvegardes Stardew Valley sur chaque plateforme, y compris Steam (natif, Flatpak et Snap sous Linux) et le dossier protégé `Android/data` sous Android (modes root, [Shizuku](https://shizuku.rikka.app/) ou pont manuel).
- **Envoi / téléchargement en un clic** — chaque ferme indique quel côté est en avance (local ou Drive) et recommande la bonne action.
- **Protection contre les sauvegardes incomplètes** — une sauvegarde à laquelle il manque des fichiers sur Drive est signalée et ne peut pas être téléchargée à moitié.

### Sécurité des données (notre plus grande fierté)
- **Remplacement transactionnel** — chaque téléchargement, import et restauration suit un pipeline *préparer → valider → sauvegarder → remplacer → vérifier* avec rollback automatique. Si votre PC plante en plein téléchargement, votre sauvegarde d'origine reste intacte ou est restaurée automatiquement. Jamais de ferme à moitié écrite.
- **Téléversements atomiques** — les envois vont dans un nouveau dossier de « génération » immuable et sont publiés par une unique mise à jour finale du manifeste. Les autres appareils ne voient jamais une sauvegarde à moitié envoyée.
- **Sauvegardes automatiques avec rétention** — une copie vérifiée est créée avant tout remplacement ; l'application conserve les 5 dernières sauvegardes automatiques par ferme (les manuelles ne sont jamais supprimées).
- **Récupération après plantage** — les dossiers temporaires d'une opération interrompue sont détectés et résolus en toute sécurité au démarrage suivant, en privilégiant toujours la copie valide.

### Multijoueur coopératif
- **Migration d'hôte** — transférez le rôle d'hôte d'une ferme coop à un autre joueur dans le fichier de sauvegarde, avec validation d'intégrité complète avant et après. Continuez la même ferme même quand l'hôte habituel est absent.
- **Partagez vos fermes** — partagez une ferme via Drive pour que d'autres joueurs la téléchargent et continuent à jouer, avec badges de rôle (lecture seule ou synchronisation).
- **Cartes multi-joueurs** — les fermes coop affichent tous les fermiers, pas seulement l'hôte.

### Confort d'utilisation
- **Lancez le jeu depuis l'application** — détecte et démarre Stardew Valley sous Windows, macOS et Linux (Steam natif / Flatpak / Snap).
- **Import de sauvegardes .zip** — avec la même sécurité transactionnelle que les téléchargements.
- **Mise à jour intégrée** — vérifie GitHub Releases et télécharge la nouvelle version pour vous.
- **Interface saisonnière** — toute l'interface suit la saison du jeu : pétales au printemps, lucioles en été, feuilles en automne, neige en hiver.

## Téléchargements

Récupérez la dernière version sur **[Releases](https://github.com/hirieo/valleysave-app/releases/latest)** :

| Plateforme | Fichier | Notes |
|---|---|---|
| **Windows** | `ValleySave-Setup-*.exe` | Installateur — runtime VC++ inclus, 14 langues |
| **Windows** (portable) | `ValleySave-*-windows.zip` | Décompresser et lancer |
| **macOS** | `valleysave-macos.zip` | Décompresser, déplacer dans Applications |
| **Linux** (Ubuntu/Debian) | `valleysave_*_amd64.deb` | Double-clic pour installer — icône de menu incluse |
| **Linux** (portable) | `valleysave-linux-x64.tar.gz` | Extraire et lancer, toute distribution |
| **Android** | `ValleySave-*.apk` | Android 8+ |

> [!NOTE]
> **📱 iOS :** Elle est déjà prête. Ce qui manque, ce sont les 99 USD/an qu'Apple demande pour publier — [file un coup de main sur Ko-fi](https://ko-fi.com/hirieo) et iOS rejoint la fête.
>
> Ça fait 7 mois que je bosse sur ValleySave presque tous les jours. Un café le matin, ça aide vraiment à démarrer — ça me donne l'énergie pour continuer ce projet et les suivants. ☕

## Comment ça marche

1. **Connectez** — liez votre propre compte Google (OAuth, scope `drive.file` uniquement).
2. **Détectez** — ValleySave trouve vos fermes Stardew Valley automatiquement.
3. **Synchronisez** — envoyez vos fermes dans un dossier `ValleySave/` de votre Drive.
4. **Continuez partout** — installez ValleySave sur un autre appareil, connectez le même compte, téléchargez et jouez.

## FAQ

**Stardew Valley a-t-il une sauvegarde cloud officielle entre PC et mobile ?**
Non — les sauvegardes PC et mobiles sont locales et il n'existe pas de synchronisation officielle. ValleySave la fournit via votre propre Google Drive.

**Mes sauvegardes sont-elles en sécurité ?**
Chaque opération destructive est transactionnelle : votre sauvegarde d'origine est copiée et vérifiée avant remplacement, et restaurée automatiquement en cas d'échec.

**Où sont stockées mes sauvegardes ?**
Dans un dossier `ValleySave/` de *votre propre* Google Drive. Il n'y a aucun serveur ValleySave.

**Puis-je déplacer une ferme entre Windows et Android ?**
Oui — c'est le cas d'usage principal. macOS et Linux aussi, dans tous les sens.

## Compiler depuis les sources

Prérequis : [Flutter](https://docs.flutter.dev/get-started/install) ≥ 3.12 · Android Studio (pour Android)

```bash
git clone https://github.com/hirieo/valleysave-app.git
cd valleysave-app

flutter pub get
cp .env.example .env
# Desktop : renseignez GOOGLE_CLIENT_ID et GOOGLE_CLIENT_SECRET dans .env
flutter run
```

## Licence

[Polyform Noncommercial 1.0.0](../../LICENSE) — code lisible et ouvert aux contributions ; l'usage commercial nécessite une autorisation explicite.

Distribué **sans aucune garantie**. Utilisation à vos risques.
