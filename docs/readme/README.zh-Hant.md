<div align="center">

<img src="../../assets/icons/icon.png" width="200" height="200" alt="ValleySave — 星露谷物語存檔同步應用程式標誌">

# ValleySave

**在 Windows、macOS、Linux 和 Android 之間同步你的星露谷物語（Stardew Valley）存檔 — 使用你自己的 Google Drive。**

無第三方伺服器。無訂閱。無追蹤。你的存檔永遠不會離開你自己的 Google 帳號。

[![最新版本](https://img.shields.io/github/v/release/hirieo/valleysave-app?label=%E4%B8%8B%E8%BC%89&color=brightgreen)](https://github.com/hirieo/valleysave-app/releases/latest)
[![下載量](https://img.shields.io/github/downloads/hirieo/valleysave-app/total?color=blue)](https://github.com/hirieo/valleysave-app/releases)
[![授權: Polyform NC](https://img.shields.io/badge/License-Polyform%20NC-orange)](../../LICENSE)
![平台](https://img.shields.io/badge/Windows%20%7C%20macOS%20%7C%20Linux%20%7C%20Android-lightgrey)

[🇬🇧 English](../../README.md) · [🇪🇸 Español](README.es.md) · [🇫🇷 Français](README.fr.md) · [🇩🇪 Deutsch](README.de.md) · [🇮🇹 Italiano](README.it.md) · [🇵🇹 Português](README.pt.md) · [Euskera](README.eu.md) · [🇷🇺 Русский](README.ru.md) · [🇺🇦 Українська](README.uk.md) · [🇯🇵 日本語](README.ja.md) · [🇰🇷 한국어](README.ko.md) · [🇨🇳 中文](README.zh.md) · 🇹🇼 中文（繁體） · [🇹🇭 ไทย](README.th.md)

</div>

---

> [!IMPORTANT]
> **ValleySave 目前處於搶先體驗階段。** Google 登入畫面仍在等待 Google 的驗證，因此目前只有白名單中的 Google 帳號才能連線。如需取得權限，請寄信至 **lhirieo@gmail.com**，註明你將用於 ValleySave 的 Google 帳號（電子郵件地址）。一旦 Google 完成驗證，將向所有人開放。

## ValleySave 是什麼？

星露谷物語在 PC 和行動裝置之間沒有官方雲端存檔同步。**ValleySave 填補了這個空缺**：它會自動偵測你的農場存檔，上傳到**你自己的 Google Drive** 中的 `ValleySave/` 資料夾，然後你可以在任何其他裝置上下載並繼續遊玩 — Windows、macOS、Linux 或 Android。

- 🔒 **隱私優先** — 使用 Google 受限的 `drive.file` 權限範圍：應用程式只能看到它自己建立的檔案，永遠無法存取你 Drive 中的其他內容。
- 🖥️ **真正的跨平台** — 單一程式碼庫（Flutter），四個平台全部原生建置。
- 🌍 **14 種語言** — 中文（繁體、簡體）、英語、西班牙語、巴斯克語、法語、德語、義大利語、葡萄牙語、俄語、烏克蘭語、日語、韓語和泰語。

## 功能

### 存檔同步與轉移
- **自動偵測農場** — 在每個平台上找到你的存檔，包括 Linux 上的 Steam（原生、Flatpak 和 Snap）以及 Android 上受保護的 `Android/data` 資料夾（root、[Shizuku](https://shizuku.rikka.app/) 或手動橋接模式）。
- **一鍵上傳/下載** — 每個農場卡片顯示哪一側較新（本機還是 Drive），並建議正確的操作。
- **不完整存檔保護** — Drive 中缺少檔案的存檔會被標記，無法半途下載。

### 資料安全（我們最引以為傲的部分）
- **交易式取代** — 每次下載、匯入和還原都經過*準備 → 驗證 → 備份 → 取代 → 確認*流程，失敗時自動回復。即使電腦在下載途中當機，你的原始存檔也會保持完好或被自動還原。絕不會出現寫到一半的農場。
- **原子上傳** — 上傳寫入一個新的不可變「世代」資料夾，僅透過最後一次清單更新發佈。其他裝置永遠不會看到上傳到一半的存檔。
- **帶保留策略的自動備份** — 取代任何存檔前都會建立經過驗證的備份；每個農場保留最近 5 個自動備份（手動備份永不刪除）。
- **當機復原** — 中斷操作留下的暫存資料夾會在下次啟動時被偵測並安全處理，始終優先保留有效副本。

### 連線合作
- **房主轉移** — 在存檔檔案中將合作農場的房主角色轉移給另一位玩家，轉移前後都進行完整性驗證。即使平常的房主不在，也能繼續玩同一個農場。
- **與朋友共享農場** — 透過 Drive 共享農場，讓其他玩家下載並繼續遊玩，附角色標識（唯讀或可同步）。
- **顯示所有玩家** — 合作農場卡片顯示所有農夫，而不只是房主。

### 便利功能
- **從應用程式啟動遊戲** — 在 Windows、macOS 和 Linux 上偵測並啟動星露谷物語（Steam 原生 / Flatpak / Snap）。
- **從 .zip 匯入存檔** — 與下載相同的交易式保護。
- **內建更新程式** — 檢查 GitHub Releases 並為你下載新版本。
- **季節主題介面** — 整個介面跟隨遊戲內季節變化：春天花瓣、夏天螢火蟲、秋天落葉、冬天飄雪。

## 下載

從 **[Releases](https://github.com/hirieo/valleysave-app/releases/latest)** 取得最新版本：

| 平台 | 檔案 | 說明 |
|---|---|---|
| **Windows** | `ValleySave-Setup-*.exe` | 安裝程式 — 內含 VC++ 執行階段，14 種語言 |
| **Windows**（可攜版） | `ValleySave-*-windows.zip` | 解壓即用 |
| **macOS** | `valleysave-macos.zip` | 解壓後移到「應用程式」 |
| **Linux**（Ubuntu/Debian） | `valleysave_*_amd64.deb` | 雙擊安裝 — 含選單圖示 |
| **Linux**（可攜版） | `valleysave-linux-x64.tar.gz` | 解壓即用，任何發行版 |
| **Android** | `ValleySave-*.apk` | Android 8+ |

> [!NOTE]
> **📱 iOS：** ValleySave 的 iPhone/iPad 版本已經存在，但要在 App Store 上架需要 Apple 開發者授權（每年 99 美元，約 99 歐元）。將發起群眾募資活動來支付這筆費用。

## 運作方式

1. **連接** — 連結你自己的 Google 帳號（OAuth，僅 `drive.file` 權限）。
2. **偵測** — ValleySave 自動找到你的農場。
3. **同步** — 將農場上傳到你 Drive 的 `ValleySave/` 資料夾。
4. **隨處繼續** — 在另一台裝置上安裝 ValleySave，連接同一帳號，下載並遊玩。

## 常見問題

**星露谷物語在 PC 和行動裝置之間有官方雲端存檔嗎？**
沒有 — 存檔儲存在本機，不存在官方跨平台同步。ValleySave 透過你自己的 Google Drive 提供這項功能。

**我的存檔資料安全嗎？**
所有破壞性操作都是交易式的：原始存檔在取代前會被備份和驗證，失敗時自動還原。

**我的存檔儲存在哪裡？**
在*你自己的* Google Drive 中的 `ValleySave/` 資料夾。不存在 ValleySave 伺服器。

**能在 Windows 和 Android 之間轉移農場嗎？**
能 — 這正是核心使用情境。macOS 和 Linux 也可以，任意方向。

## 從原始碼建置

需求：[Flutter](https://docs.flutter.dev/get-started/install) ≥ 3.12 · Android Studio（用於 Android 建置）

```bash
git clone https://github.com/hirieo/valleysave-app.git
cd valleysave-app

flutter pub get
cp .env.example .env
# 桌面端：在 .env 中填寫 GOOGLE_CLIENT_ID 和 GOOGLE_CLIENT_SECRET
flutter run
```

## 授權

[Polyform Noncommercial 1.0.0](../../LICENSE) — 可以閱讀程式碼、學習並貢獻；商業使用需要明確授權。

**不提供任何保證**。使用風險自負。
