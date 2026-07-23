<div align="center">

<img src="assets/icons/icon.png" width="200" height="200" alt="ValleySave — Stardew Valley cloud save sync app logo">

# ValleySave

**Sync your Stardew Valley saves across Windows, macOS, Linux and Android — using your own Google Drive.**

No third-party servers. No subscriptions. No tracking. Your saves never leave your own Google account.

[![Latest release](https://img.shields.io/github/v/release/hirieo/valleysave-app?label=Download&color=brightgreen)](https://github.com/hirieo/valleysave-app/releases/latest)
[![Downloads](https://img.shields.io/github/downloads/hirieo/valleysave-app/total?color=blue)](https://github.com/hirieo/valleysave-app/releases)
[![License: Polyform NC](https://img.shields.io/badge/License-Polyform%20NC-orange)](./LICENSE)
![Platforms](https://img.shields.io/badge/Windows%20%7C%20macOS%20%7C%20Linux%20%7C%20Android-lightgrey)

🇬🇧 English · [🇪🇸 Español](docs/readme/README.es.md) · [🇫🇷 Français](docs/readme/README.fr.md) · [🇩🇪 Deutsch](docs/readme/README.de.md) · [🇮🇹 Italiano](docs/readme/README.it.md) · [🇵🇹 Português](docs/readme/README.pt.md) · [Euskera](docs/readme/README.eu.md) · [🇷🇺 Русский](docs/readme/README.ru.md) · [🇺🇦 Українська](docs/readme/README.uk.md) · [🇯🇵 日本語](docs/readme/README.ja.md) · [🇰🇷 한국어](docs/readme/README.ko.md) · [🇨🇳 中文](docs/readme/README.zh.md) · [🇹🇼 中文（繁體）](docs/readme/README.zh-Hant.md) · [🇹🇭 ไทย](docs/readme/README.th.md)

</div>

---

> [!IMPORTANT]
> **ValleySave is in early access.** The Google sign-in screen is still pending Google's verification, so only allow-listed Google accounts can connect for now. To get access, email **lhirieo@gmail.com** with the Google account (email address) you'll use with ValleySave. It opens to everyone once Google's verification is complete.

## What is ValleySave?

Stardew Valley has no official cloud save sync between PC and mobile. **ValleySave fills that gap**: it detects your farms, uploads them to a `ValleySave/` folder in **your own Google Drive**, and lets you download and continue playing on any other device — Windows, macOS, Linux or Android.

- 🔒 **Privacy-first** — uses Google's restricted `drive.file` scope: the app can only see files it created itself, never the rest of your Drive.
- 🖥️ **Truly cross-platform** — one codebase (Flutter), native builds for all four platforms.
- 🌍 **14 languages** — English, Spanish, Basque, French, German, Italian, Portuguese, Russian, Ukrainian, Japanese, Korean, Chinese (Simplified & Traditional) and Thai.

## Features

### Save sync & transfer
- **Automatic farm detection** — finds your Stardew Valley saves on every platform, including Steam (native, Flatpak and Snap on Linux) and the protected `Android/data` folder on Android (root, [Shizuku](https://shizuku.rikka.app/) or manual-bridge modes).
- **Upload / download with one click** — per-farm cards show which side is ahead (local vs Drive) and recommend the right action.
- **Incomplete-save protection** — a save that is missing files in Drive is flagged and can't be downloaded half-broken.

### Data safety (the part we're most proud of)
- **Transactional replace** — every download, import and restore uses a *prepare → validate → backup → swap → verify* pipeline with automatic rollback. If your PC crashes mid-download, your original save is untouched or automatically restored. Never a half-written farm.
- **Atomic uploads** — uploads go to a new immutable "generation" folder and are published with a single final manifest update. Other devices never see a half-uploaded save.
- **Automatic backups with retention** — a verified backup is created before any save is replaced; the app keeps the last 5 automatic backups per farm (manual backups are never deleted).
- **Crash recovery** — leftover temp folders from an interrupted operation are detected and safely resolved on next launch, always preferring the valid copy.

### Co-op multiplayer
- **Host migration** — transfer the host role of a co-op farm to another player in the save file, with full integrity validation before and after the swap. Play the same farm even when the usual host is away.
- **Share farms with friends** — share a farm through Drive so other players can download it and keep playing, with role badges (read-only vs sync).
- **Player-aware cards** — co-op farms show every farmhand, not just the host.

### Quality of life
- **Launch the game from the app** — detects and starts Stardew Valley on Windows, macOS and Linux (Steam native / Flatpak / Snap).
- **Import saves from .zip** — with the same transactional safety as downloads.
- **Built-in updater** — checks GitHub Releases and downloads the new version for you.
- **Seasonal UI** — the whole interface follows the in-game season: spring petals, summer fireflies, autumn leaves, winter snow.

## Downloads

Grab the latest version from **[Releases](https://github.com/hirieo/valleysave-app/releases/latest)**:

| Platform | File | Notes |
|---|---|---|
| **Windows** | `ValleySave-Setup-*.exe` | Installer — includes VC++ runtime, 14 languages |
| **Windows** (portable) | `ValleySave-*-windows.zip` | Unzip & run |
| **macOS** | `valleysave-macos.zip` | Unzip, move to Applications |
| **Linux** (Ubuntu/Debian) | `valleysave_*_amd64.deb` | Double-click to install — menu icon included |
| **Linux** (portable) | `valleysave-linux-x64.tar.gz` | Extract & run, any distro |
| **Android** | `ValleySave-*.apk` | Android 8+ |

> [!NOTE]
> **📱 iOS:** It's already built. What I don't have is the 99 USD/year Apple charges as a cover charge — [chip in on Ko-fi](https://ko-fi.com/hirieo) and iOS gets to join the party.

## How it works

1. **Connect** — link your own Google account (OAuth, `drive.file` scope only).
2. **Detect** — ValleySave finds your Stardew Valley farms automatically.
3. **Sync** — upload farms to a `ValleySave/` folder in your Drive.
4. **Continue anywhere** — install ValleySave on another device, connect the same account, download and play.

## FAQ

**Does Stardew Valley have official cloud saves between PC and mobile?**
No — saves on PC and mobile are stored locally and there is no official cross-platform sync. ValleySave provides it using your own Google Drive.

**Is my save data safe?**
Every destructive operation is transactional: your original save is backed up and verified before being replaced, and automatically restored if anything fails. Corrupt or incomplete data is rejected before it can overwrite a good save.

**Where are my saves stored?**
In a `ValleySave/` folder inside *your own* Google Drive. There is no ValleySave server. The app uses the restricted `drive.file` scope, so it can't read anything else in your Drive.

**Can I move a farm between Windows and Android?**
Yes — that's the core use case. Also macOS and Linux, in any direction.

**Can we keep playing our co-op farm when the host is away?**
Yes. ValleySave can transfer the host role to another player (host migration) and share the farm through Drive.

## Build from source

Requirements: [Flutter](https://docs.flutter.dev/get-started/install) ≥ 3.12 · Android Studio (for Android builds)

```bash
git clone https://github.com/hirieo/valleysave-app.git
cd valleysave-app

flutter pub get
cp .env.example .env
# Desktop: fill GOOGLE_CLIENT_ID and GOOGLE_CLIENT_SECRET in .env
flutter run
```

Android needs its own Google Cloud credentials (`google-services.json`).

## Bug reports & contributions

- Bugs that affect core functionality: [open an issue](../../issues).
- Pull requests are welcome — the code is source-available under Polyform Noncommercial.

## License

[Polyform Noncommercial 1.0.0](./LICENSE) — you may read, learn from and contribute to the code; commercial use requires explicit permission.

Distributed in the hope that it will be useful, **without any warranty**. Use at your own risk.

---

**Sister repo:** [`valleysave-web`](https://github.com/hirieo/valleysave-web) — landing page & web presence.
