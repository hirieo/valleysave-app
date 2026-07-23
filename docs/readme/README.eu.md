<div align="center">

<img src="../../assets/icons/icon.png" width="200" height="200" alt="ValleySave — Stardew Valley partiden sinkronizazio-aplikazioaren logoa">

# ValleySave

**Sinkronizatu zure Stardew Valley partidak Windows, macOS, Linux eta Android artean — zure Google Drive propioarekin.**

Hirugarrenen zerbitzurik gabe. Harpidetzarik gabe. Jarraipenik gabe. Zure partidak ez dira inoiz zure Google kontutik ateratzen.

[![Azken bertsioa](https://img.shields.io/github/v/release/hirieo/valleysave-app?label=Deskargatu&color=brightgreen)](https://github.com/hirieo/valleysave-app/releases/latest)
[![Deskargak](https://img.shields.io/github/downloads/hirieo/valleysave-app/total?color=blue)](https://github.com/hirieo/valleysave-app/releases)
[![Lizentzia: Polyform NC](https://img.shields.io/badge/Lizentzia-Polyform%20NC-orange)](../../LICENSE)
![Plataformak](https://img.shields.io/badge/Windows%20%7C%20macOS%20%7C%20Linux%20%7C%20Android-lightgrey)

[🇬🇧 English](../../README.md) · [🇪🇸 Español](README.es.md) · [🇫🇷 Français](README.fr.md) · [🇩🇪 Deutsch](README.de.md) · [🇮🇹 Italiano](README.it.md) · [🇵🇹 Português](README.pt.md) · Euskera · [🇷🇺 Русский](README.ru.md) · [🇺🇦 Українська](README.uk.md) · [🇯🇵 日本語](README.ja.md) · [🇰🇷 한국어](README.ko.md) · [🇨🇳 中文](README.zh.md) · [🇹🇼 中文（繁體）](README.zh-Hant.md) · [🇹🇭 ไทย](README.th.md)

</div>

---

> [!IMPORTANT]
> **ValleySave goiztiar sarbidean dago.** Google-ko saioa hasteko pantaila oraindik Google-ren egiaztapenaren zain dago, beraz, oraingoz zerrenda zurian dauden Google kontuek bakarrik konekta daitezke. Sarbidea lortzeko, idatzi **lhirieo@gmail.com** helbidera ValleySave-rekin erabiliko duzun Google kontua (helbide elektronikoa) adieraziz. Google-ren egiaztapena amaitu bezain laster denentzat irekiko da.

## Zer da ValleySave?

Stardew Valley-k ez du hodeiko sinkronizazio ofizialik PC eta mugikorren artean. **ValleySave-k hutsune hori betetzen du**: zure baserriak detektatzen ditu, **zure Google Drive propioko** `ValleySave/` karpeta batera igotzen ditu, eta beste edozein gailutan deskargatu eta jokatzen jarraitzeko aukera ematen dizu — Windows, macOS, Linux edo Android.

- 🔒 **Pribatutasuna lehenik** — Google-ren `drive.file` scope murriztua erabiltzen du: aplikazioak berak sortutako fitxategiak baino ez ditu ikusten, inoiz ez zure Drive-ko gainerakoa.
- 🖥️ **Benetan plataforma anitzekoa** — kode bakarra (Flutter), build natiboak lau plataformetarako.
- 🌍 **14 hizkuntza** — euskara, ingelesa, gaztelania, frantsesa, alemana, italiera, portugesa, errusiera, ukrainera, japoniera, koreera, txinera (sinplifikatua eta tradizionala) eta thailandiera.

## Ezaugarriak

### Partiden sinkronizazioa eta transferentzia
- **Baserrien detekzio automatikoa** — zure partidak aurkitzen ditu plataforma guztietan, Steam barne (natiboa, Flatpak eta Snap Linuxen) eta Android-eko `Android/data` karpeta babestua (root, [Shizuku](https://shizuku.rikka.app/) edo eskuzko zubi moduak).
- **Igo / deskargatu klik batekin** — baserri bakoitzak zein alde doan aurrerago erakusten du (lokala edo Drive) eta ekintza egokia gomendatzen du.
- **Partida osatugabeen aurkako babesa** — Drive-n fitxategiak falta dituen partida bat markatu egiten da eta ezin da erdizka deskargatu.

### Datuen segurtasuna (gure harrotasunik handiena)
- **Ordezkapen transakzionala** — deskarga, inportazio eta leheneratze bakoitzak *prestatu → balioztatu → babeskopia → ordezkatu → egiaztatu* fluxua jarraitzen du, rollback automatikoarekin. PCa deskarga erdian blokeatzen bada, zure jatorrizko partida ukitu gabe geratzen da edo automatikoki leheneratzen da.
- **Igoera atomikoak** — igoerak "belaunaldi" karpeta berri eta aldaezin batera doaz, eta manifestuaren azken eguneratze bakar batekin argitaratzen dira. Beste gailuek ez dute inoiz erdizka igotako partidarik ikusten.
- **Babeskopia automatikoak atxikipenarekin** — edozein ordezkapen baino lehen babeskopia egiaztatu bat sortzen da; baserri bakoitzeko azken 5 automatikoak gordetzen dira (eskuzkoak ez dira inoiz ezabatzen).
- **Kraskaduren ondorengo berreskuratzea** — etendako eragiketa baten aldi baterako karpetak detektatu eta modu seguruan konpontzen dira hurrengo abioan, beti kopia baliozkoari lehentasuna emanez.

### Lankidetza-jokoa (koop)
- **Anfitrioi-aldaketa** — transferitu koop baserri baten anfitrioi-rola beste jokalari bati partidaren fitxategian, osotasun-balidazio osoarekin aurretik eta ondoren. Jarraitu baserri berarekin ohiko anfitrioia ez dagoenean ere.
- **Partekatu baserriak lagunekin** — partekatu baserri bat Drive bidez beste jokalariek deskargatu eta jokatzen jarrai dezaten, rol-bereizgarriekin (irakurtzeko soilik edo sinkronizazioa).
- **Jokalari guztiak ikusgai** — koop baserriek nekazari guztiak erakusten dituzte, ez anfitrioia bakarrik.

### Erosotasuna
- **Abiarazi jokoa aplikaziotik** — Stardew Valley detektatu eta abiarazten du Windows, macOS eta Linuxen (Steam natiboa / Flatpak / Snap).
- **Inportatu partidak .zip-etik** — deskargen segurtasun transakzional berarekin.
- **Eguneratzaile integratua** — GitHub Releases egiaztatzen du eta bertsio berria deskargatzen dizu.
- **Urtaroen araberako interfazea** — interfaze osoak jokoaren urtaroa jarraitzen du: petaloak udaberrian, ipurtargiak udan, hostoak udazkenean, elurra neguan.

## Deskargak

Eskuratu azken bertsioa **[Releases](https://github.com/hirieo/valleysave-app/releases/latest)** orritik:

| Plataforma | Fitxategia | Oharrak |
|---|---|---|
| **Windows** | `ValleySave-Setup-*.exe` | Instalatzailea — VC++ runtime barne, 14 hizkuntza |
| **Windows** (eramangarria) | `ValleySave-*-windows.zip` | Deskonprimitu eta exekutatu |
| **macOS** | `valleysave-macos.zip` | Deskonprimitu, Aplikazioetara mugitu |
| **Linux** (Ubuntu/Debian) | `valleysave_*_amd64.deb` | Klik bikoitza instalatzeko — menuko ikonoarekin |
| **Linux** (eramangarria) | `valleysave-linux-x64.tar.gz` | Atera eta exekutatu, edozein distro |
| **Android** | `ValleySave-*.apk` | Android 8+ |

> [!NOTE]
> **📱 iOS:** Jadanik prest dago. Falta dena Apple-k sarrera gisa eskatzen duen 99 USD/urtekoa da — [lagundu Ko-fi-n](https://ko-fi.com/hirieo) eta iOS jaian sartuko da.

## Nola funtzionatzen du

1. **Konektatu** — lotu zure Google kontu propioa (OAuth, `drive.file` scope soilik).
2. **Detektatu** — ValleySave-k zure baserriak automatikoki aurkitzen ditu.
3. **Sinkronizatu** — igo baserriak zure Drive-ko `ValleySave/` karpeta batera.
4. **Jarraitu edonon** — instalatu ValleySave beste gailu batean, konektatu kontu bera, deskargatu eta jokatu.

## Ohiko galderak

**Stardew Valley-k badu hodeiko gordetze ofizialik PC eta mugikorren artean?**
Ez — partidak lokalki gordetzen dira eta ez dago sinkronizazio ofizialik. ValleySave-k zure Google Drive propioa erabiliz eskaintzen du.

**Nire partidak seguru daude?**
Eragiketa suntsitzaile oro transakzionala da: jatorrizkoa babeskopiatu eta egiaztatzen da ordezkatu baino lehen, eta automatikoki leheneratzen da zerbaitek huts egiten badu.

**Non gordetzen dira nire partidak?**
*Zure* Google Drive propioko `ValleySave/` karpeta batean. Ez dago ValleySave zerbitzaririk.

**Baserri bat Windows eta Android artean mugi dezaket?**
Bai — horixe da erabilera-kasu nagusia. Baita macOS eta Linux ere, edozein norabidetan.

## Iturburutik konpilatu

Eskakizunak: [Flutter](https://docs.flutter.dev/get-started/install) ≥ 3.12 · Android Studio (Androiderako)

```bash
git clone https://github.com/hirieo/valleysave-app.git
cd valleysave-app

flutter pub get
cp .env.example .env
# Mahaigaina: bete GOOGLE_CLIENT_ID eta GOOGLE_CLIENT_SECRET .env fitxategian
flutter run
```

## Lizentzia

[Polyform Noncommercial 1.0.0](../../LICENSE) — kodea irakurri, ikasi eta ekarpenak egin ditzakezu; erabilera komertzialak berariazko baimena behar du.

**Inolako bermerik gabe** banatzen da. Erabili zure ardurapean.
