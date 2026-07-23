<div align="center">

<img src="../../assets/icons/icon.png" width="200" height="200" alt="ValleySave — Logo der Stardew-Valley-Spielstand-Sync-App">

# ValleySave

**Synchronisiere deine Stardew-Valley-Spielstände zwischen Windows, macOS, Linux und Android — über dein eigenes Google Drive.**

Keine Drittanbieter-Server. Keine Abos. Kein Tracking. Deine Spielstände verlassen nie dein eigenes Google-Konto.

[![Neueste Version](https://img.shields.io/github/v/release/hirieo/valleysave-app?label=Download&color=brightgreen)](https://github.com/hirieo/valleysave-app/releases/latest)
[![Downloads](https://img.shields.io/github/downloads/hirieo/valleysave-app/total?color=blue)](https://github.com/hirieo/valleysave-app/releases)
[![Lizenz: Polyform NC](https://img.shields.io/badge/Lizenz-Polyform%20NC-orange)](../../LICENSE)
![Plattformen](https://img.shields.io/badge/Windows%20%7C%20macOS%20%7C%20Linux%20%7C%20Android-lightgrey)

[🇬🇧 English](../../README.md) · [🇪🇸 Español](README.es.md) · [🇫🇷 Français](README.fr.md) · 🇩🇪 Deutsch · [🇮🇹 Italiano](README.it.md) · [🇵🇹 Português](README.pt.md) · [Euskera](README.eu.md) · [🇷🇺 Русский](README.ru.md) · [🇺🇦 Українська](README.uk.md) · [🇯🇵 日本語](README.ja.md) · [🇰🇷 한국어](README.ko.md) · [🇨🇳 中文](README.zh.md) · [🇹🇼 中文（繁體）](README.zh-Hant.md) · [🇹🇭 ไทย](README.th.md)

</div>

---

> [!IMPORTANT]
> **ValleySave befindet sich im Early Access.** Der Google-Anmeldebildschirm wartet noch auf Googles Verifizierung, daher können sich derzeit nur freigeschaltete Google-Konten verbinden. Um Zugang zu erhalten, schreibe eine E-Mail an **lhirieo@gmail.com** mit dem Google-Konto (E-Mail-Adresse), das du mit ValleySave nutzen möchtest. Sobald Googles Verifizierung abgeschlossen ist, öffnet sich die App für alle.

## Was ist ValleySave?

Stardew Valley hat keine offizielle Cloud-Synchronisierung zwischen PC und Mobilgeräten. **ValleySave schließt diese Lücke**: Es erkennt deine Farmen, lädt sie in einen `ValleySave/`-Ordner in **deinem eigenen Google Drive** hoch und lässt dich auf jedem anderen Gerät weiterspielen — Windows, macOS, Linux oder Android.

- 🔒 **Privatsphäre zuerst** — nutzt Googles eingeschränkten `drive.file`-Scope: Die App sieht nur Dateien, die sie selbst erstellt hat, nie den Rest deines Drive.
- 🖥️ **Echt plattformübergreifend** — eine Codebasis (Flutter), native Builds für alle vier Plattformen.
- 🌍 **14 Sprachen** — Deutsch, Englisch, Spanisch, Baskisch, Französisch, Italienisch, Portugiesisch, Russisch, Ukrainisch, Japanisch, Koreanisch, Chinesisch (vereinfacht & traditionell) und Thai.

## Funktionen

### Spielstand-Sync & Transfer
- **Automatische Farm-Erkennung** — findet deine Stardew-Valley-Spielstände auf jeder Plattform, inklusive Steam (nativ, Flatpak und Snap unter Linux) und dem geschützten `Android/data`-Ordner unter Android (Root-, [Shizuku](https://shizuku.rikka.app/)- oder manueller Brücken-Modus).
- **Hoch-/Herunterladen mit einem Klick** — jede Farm zeigt, welche Seite aktueller ist (lokal oder Drive), und empfiehlt die richtige Aktion.
- **Schutz vor unvollständigen Spielständen** — ein Spielstand mit fehlenden Dateien in Drive wird markiert und kann nicht halb heruntergeladen werden.

### Datensicherheit (unser Herzstück)
- **Transaktionales Ersetzen** — jeder Download, Import und jede Wiederherstellung durchläuft *Vorbereiten → Validieren → Sichern → Tauschen → Verifizieren* mit automatischem Rollback. Stürzt der PC mitten im Download ab, bleibt dein Original unberührt oder wird automatisch wiederhergestellt. Nie eine halb geschriebene Farm.
- **Atomare Uploads** — Uploads landen in einem neuen, unveränderlichen „Generationen"-Ordner und werden mit einem einzigen finalen Manifest-Update veröffentlicht. Andere Geräte sehen nie einen halb hochgeladenen Spielstand.
- **Automatische Backups mit Aufbewahrung** — vor jedem Ersetzen wird ein verifiziertes Backup erstellt; die letzten 5 automatischen Backups pro Farm bleiben erhalten (manuelle werden nie gelöscht).
- **Absturz-Wiederherstellung** — übrig gebliebene Temp-Ordner einer unterbrochenen Operation werden beim nächsten Start erkannt und sicher aufgelöst — immer zugunsten der gültigen Kopie.

### Koop-Multiplayer
- **Host-Wechsel** — übertrage die Host-Rolle einer Koop-Farm im Spielstand auf einen anderen Spieler, mit vollständiger Integritätsprüfung davor und danach. Spielt dieselbe Farm weiter, auch wenn der übliche Host abwesend ist.
- **Farmen mit Freunden teilen** — teile eine Farm über Drive, damit andere sie herunterladen und weiterspielen können, mit Rollen-Badges (nur lesen oder synchronisieren).
- **Alle Spieler sichtbar** — Koop-Farmen zeigen jeden Farmer, nicht nur den Host.

### Komfort
- **Spiel aus der App starten** — erkennt und startet Stardew Valley unter Windows, macOS und Linux (Steam nativ / Flatpak / Snap).
- **Spielstände aus .zip importieren** — mit derselben transaktionalen Sicherheit wie Downloads.
- **Integrierter Updater** — prüft GitHub Releases und lädt neue Versionen für dich herunter.
- **Saisonale Oberfläche** — die ganze Oberfläche folgt der Jahreszeit im Spiel: Blütenblätter im Frühling, Glühwürmchen im Sommer, Blätter im Herbst, Schnee im Winter.

## Downloads

Hol dir die neueste Version von **[Releases](https://github.com/hirieo/valleysave-app/releases/latest)**:

| Plattform | Datei | Hinweise |
|---|---|---|
| **Windows** | `ValleySave-Setup-*.exe` | Installer — VC++-Runtime enthalten, 14 Sprachen |
| **Windows** (portabel) | `ValleySave-*-windows.zip` | Entpacken & starten |
| **macOS** | `valleysave-macos.zip` | Entpacken, in Programme verschieben |
| **Linux** (Ubuntu/Debian) | `valleysave_*_amd64.deb` | Doppelklick zum Installieren — mit Menü-Icon |
| **Linux** (portabel) | `valleysave-linux-x64.tar.gz` | Entpacken & starten, jede Distribution |
| **Android** | `ValleySave-*.apk` | Android 8+ |

> [!NOTE]
> **📱 iOS:** Die ValleySave-App für iPhone/iPad existiert bereits, aber ihre Veröffentlichung im App Store erfordert eine Apple-Entwicklerlizenz (99 USD/Jahr, ~99 €). Es wird eine Crowdfunding-Kampagne gestartet, um diese Kosten zu decken.

## So funktioniert's

1. **Verbinden** — verknüpfe dein eigenes Google-Konto (OAuth, nur `drive.file`-Scope).
2. **Erkennen** — ValleySave findet deine Stardew-Valley-Farmen automatisch.
3. **Synchronisieren** — lade Farmen in einen `ValleySave/`-Ordner deines Drive hoch.
4. **Überall weiterspielen** — installiere ValleySave auf einem anderen Gerät, verbinde dasselbe Konto, lade herunter und spiele.

## FAQ

**Hat Stardew Valley offizielle Cloud-Saves zwischen PC und Mobil?**
Nein — Spielstände werden lokal gespeichert, eine offizielle plattformübergreifende Synchronisierung gibt es nicht. ValleySave liefert sie über dein eigenes Google Drive.

**Sind meine Spielstände sicher?**
Jede zerstörerische Operation ist transaktional: Dein Original wird gesichert und verifiziert, bevor es ersetzt wird, und bei Fehlern automatisch wiederhergestellt.

**Wo werden meine Spielstände gespeichert?**
In einem `ValleySave/`-Ordner in *deinem eigenen* Google Drive. Es gibt keinen ValleySave-Server.

**Kann ich eine Farm zwischen Windows und Android verschieben?**
Ja — das ist der Kern-Anwendungsfall. Auch macOS und Linux, in jede Richtung.

## Aus dem Quellcode bauen

Voraussetzungen: [Flutter](https://docs.flutter.dev/get-started/install) ≥ 3.12 · Android Studio (für Android)

```bash
git clone https://github.com/hirieo/valleysave-app.git
cd valleysave-app

flutter pub get
cp .env.example .env
# Desktop: GOOGLE_CLIENT_ID und GOOGLE_CLIENT_SECRET in .env eintragen
flutter run
```

## Lizenz

[Polyform Noncommercial 1.0.0](../../LICENSE) — Code einsehen, daraus lernen und beitragen ist erlaubt; kommerzielle Nutzung erfordert ausdrückliche Genehmigung.

Verbreitet **ohne jede Garantie**. Nutzung auf eigene Gefahr.
