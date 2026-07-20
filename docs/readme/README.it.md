<div align="center">

<img src="../../assets/icons/icon.png" width="200" height="200" alt="ValleySave — logo dell'app di sincronizzazione salvataggi di Stardew Valley">

# ValleySave

**Sincronizza i tuoi salvataggi di Stardew Valley tra Windows, macOS, Linux e Android — con il tuo Google Drive.**

Nessun server di terzi. Nessun abbonamento. Nessun tracciamento. I tuoi salvataggi non lasciano mai il tuo account Google.

[![Ultima versione](https://img.shields.io/github/v/release/hirieo/valleysave-app?label=Scarica&color=brightgreen)](https://github.com/hirieo/valleysave-app/releases/latest)
[![Download](https://img.shields.io/github/downloads/hirieo/valleysave-app/total?color=blue)](https://github.com/hirieo/valleysave-app/releases)
[![Licenza: Polyform NC](https://img.shields.io/badge/Licenza-Polyform%20NC-orange)](../../LICENSE)
![Piattaforme](https://img.shields.io/badge/Windows%20%7C%20macOS%20%7C%20Linux%20%7C%20Android-lightgrey)

[🇬🇧 English](../../README.md) · [🇪🇸 Español](README.es.md) · [🇫🇷 Français](README.fr.md) · [🇩🇪 Deutsch](README.de.md) · 🇮🇹 Italiano · [🇵🇹 Português](README.pt.md) · [Euskera](README.eu.md) · [🇷🇺 Русский](README.ru.md) · [🇺🇦 Українська](README.uk.md) · [🇯🇵 日本語](README.ja.md) · [🇰🇷 한국어](README.ko.md) · [🇨🇳 中文](README.zh.md) · [🇹🇼 中文（繁體）](README.zh-Hant.md) · [🇹🇭 ไทย](README.th.md)

</div>

---

> [!IMPORTANT]
> **ValleySave è in accesso anticipato.** La schermata di accesso Google è ancora in attesa della verifica di Google, quindi per ora possono collegarsi solo gli account Google inseriti nella lista consentiti. Per ottenere l'accesso, scrivi a **lhirieo@gmail.com** indicando l'account Google (email) che userai con ValleySave. Si aprirà a tutti non appena la verifica di Google sarà completata.

## Cos'è ValleySave?

Stardew Valley non ha una sincronizzazione cloud ufficiale tra PC e mobile. **ValleySave colma questo vuoto**: rileva le tue fattorie, le carica in una cartella `ValleySave/` nel **tuo Google Drive**, e ti permette di scaricarle e continuare a giocare su qualsiasi altro dispositivo — Windows, macOS, Linux o Android.

- 🔒 **Privacy al primo posto** — usa lo scope ristretto `drive.file` di Google: l'app vede solo i file che ha creato lei stessa, mai il resto del tuo Drive.
- 🖥️ **Davvero multipiattaforma** — un solo codice (Flutter), build native per tutte e quattro le piattaforme.
- 🌍 **14 lingue** — italiano, inglese, spagnolo, basco, francese, tedesco, portoghese, russo, ucraino, giapponese, coreano, cinese (semplificato e tradizionale) e thailandese.

## Funzionalità

### Sincronizzazione e trasferimento salvataggi
- **Rilevamento automatico delle fattorie** — trova i tuoi salvataggi su ogni piattaforma, incluso Steam (nativo, Flatpak e Snap su Linux) e la cartella protetta `Android/data` su Android (modalità root, [Shizuku](https://shizuku.rikka.app/) o ponte manuale).
- **Carica / scarica con un clic** — ogni fattoria mostra quale lato è più avanti (locale o Drive) e consiglia l'azione giusta.
- **Protezione dai salvataggi incompleti** — un salvataggio con file mancanti su Drive viene segnalato e non può essere scaricato a metà.

### Sicurezza dei dati (la parte di cui siamo più orgogliosi)
- **Sostituzione transazionale** — ogni download, importazione e ripristino segue *prepara → valida → backup → sostituisci → verifica* con rollback automatico. Se il PC si blocca a metà download, il salvataggio originale resta intatto o viene ripristinato da solo. Mai una fattoria scritta a metà.
- **Upload atomici** — i caricamenti vanno in una nuova cartella "generazione" immutabile e vengono pubblicati con un unico aggiornamento finale del manifest. Gli altri dispositivi non vedono mai un salvataggio caricato a metà.
- **Backup automatici con conservazione** — prima di ogni sostituzione viene creato un backup verificato; si conservano gli ultimi 5 backup automatici per fattoria (quelli manuali non vengono mai eliminati).
- **Recupero dopo i crash** — le cartelle temporanee di un'operazione interrotta vengono rilevate e risolte in sicurezza al riavvio, privilegiando sempre la copia valida.

### Multiplayer cooperativo
- **Cambio di host** — trasferisci il ruolo di host di una fattoria coop a un altro giocatore nel file di salvataggio, con validazione completa dell'integrità prima e dopo. Continuate la stessa fattoria anche quando l'host abituale è assente.
- **Condividi le fattorie con gli amici** — condividi una fattoria via Drive perché altri giocatori la scarichino e continuino a giocare, con badge di ruolo (sola lettura o sincronizzazione).
- **Schede con tutti i giocatori** — le fattorie coop mostrano tutti i contadini, non solo l'host.

### Comodità
- **Avvia il gioco dall'app** — rileva e avvia Stardew Valley su Windows, macOS e Linux (Steam nativo / Flatpak / Snap).
- **Importa salvataggi da .zip** — con la stessa sicurezza transazionale dei download.
- **Updater integrato** — controlla GitHub Releases e scarica la nuova versione per te.
- **Interfaccia stagionale** — tutta l'interfaccia segue la stagione del gioco: petali in primavera, lucciole in estate, foglie in autunno, neve in inverno.

## Download

Scarica l'ultima versione da **[Releases](https://github.com/hirieo/valleysave-app/releases/latest)**:

| Piattaforma | File | Note |
|---|---|---|
| **Windows** | `ValleySave-Setup-*.exe` | Installer — runtime VC++ incluso, 14 lingue |
| **Windows** (portatile) | `ValleySave-*-windows.zip` | Estrai ed esegui |
| **macOS** | `valleysave-macos.zip` | Estrai, sposta in Applicazioni |
| **Linux** (Ubuntu/Debian) | `valleysave_*_amd64.deb` | Doppio clic per installare — icona nel menu |
| **Linux** (portatile) | `valleysave-linux-x64.tar.gz` | Estrai ed esegui, qualsiasi distro |
| **Android** | `ValleySave-*.apk` | Android 8+ |

## Come funziona

1. **Collega** — connetti il tuo account Google (OAuth, solo scope `drive.file`).
2. **Rileva** — ValleySave trova le tue fattorie automaticamente.
3. **Sincronizza** — carica le fattorie in una cartella `ValleySave/` del tuo Drive.
4. **Continua ovunque** — installa ValleySave su un altro dispositivo, collega lo stesso account, scarica e gioca.

## FAQ

**Stardew Valley ha salvataggi cloud ufficiali tra PC e mobile?**
No — i salvataggi sono locali e non esiste una sincronizzazione ufficiale. ValleySave la fornisce usando il tuo Google Drive.

**I miei salvataggi sono al sicuro?**
Ogni operazione distruttiva è transazionale: l'originale viene salvato e verificato prima della sostituzione, e ripristinato automaticamente in caso di errore.

**Dove vengono salvati i miei dati?**
In una cartella `ValleySave/` nel *tuo* Google Drive. Non esiste alcun server ValleySave.

**Posso spostare una fattoria tra Windows e Android?**
Sì — è il caso d'uso principale. Anche macOS e Linux, in ogni direzione.

## Compilare dai sorgenti

Requisiti: [Flutter](https://docs.flutter.dev/get-started/install) ≥ 3.12 · Android Studio (per Android)

```bash
git clone https://github.com/hirieo/valleysave-app.git
cd valleysave-app

flutter pub get
cp .env.example .env
# Desktop: compila GOOGLE_CLIENT_ID e GOOGLE_CLIENT_SECRET in .env
flutter run
```

## Licenza

[Polyform Noncommercial 1.0.0](../../LICENSE) — puoi leggere il codice, impararne e contribuire; l'uso commerciale richiede autorizzazione esplicita.

Distribuito **senza alcuna garanzia**. Uso a proprio rischio.
