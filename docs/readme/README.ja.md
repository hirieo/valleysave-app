<div align="center">

<img src="../../assets/icons/icon.png" width="200" height="200" alt="ValleySave — スターデューバレー セーブデータ同期アプリのロゴ">

# ValleySave

**Stardew Valley（スターデューバレー）のセーブデータを Windows・macOS・Linux・Android 間で同期 — あなた自身の Google Drive を使って。**

サードパーティのサーバーなし。サブスクリプションなし。トラッキングなし。セーブデータがあなたの Google アカウントの外に出ることはありません。

[![最新リリース](https://img.shields.io/github/v/release/hirieo/valleysave-app?label=%E3%83%80%E3%82%A6%E3%83%B3%E3%83%AD%E3%83%BC%E3%83%89&color=brightgreen)](https://github.com/hirieo/valleysave-app/releases/latest)
[![ダウンロード数](https://img.shields.io/github/downloads/hirieo/valleysave-app/total?color=blue)](https://github.com/hirieo/valleysave-app/releases)
[![ライセンス: Polyform NC](https://img.shields.io/badge/License-Polyform%20NC-orange)](../../LICENSE)
![対応プラットフォーム](https://img.shields.io/badge/Windows%20%7C%20macOS%20%7C%20Linux%20%7C%20Android-lightgrey)

[🇬🇧 English](../../README.md) · [🇪🇸 Español](README.es.md) · [🇫🇷 Français](README.fr.md) · [🇩🇪 Deutsch](README.de.md) · [🇮🇹 Italiano](README.it.md) · [🇵🇹 Português](README.pt.md) · [Euskera](README.eu.md) · [🇷🇺 Русский](README.ru.md) · [🇺🇦 Українська](README.uk.md) · 🇯🇵 日本語 · [🇰🇷 한국어](README.ko.md) · [🇨🇳 中文](README.zh.md) · [🇹🇼 中文（繁體）](README.zh-Hant.md) · [🇹🇭 ไทย](README.th.md)

</div>

---

> [!IMPORTANT]
> **ValleySave は現在アーリーアクセス中です。** Google のログイン画面はまだ Google による審査待ちのため、現時点では許可リストに登録された Google アカウントのみ接続できます。アクセスを希望する場合は、ValleySave で使用する Google アカウント（メールアドレス）を記載のうえ **lhirieo@gmail.com** までご連絡ください。Google の審査が完了次第、全員に公開されます。

## ValleySave とは？

Stardew Valley には PC とモバイル間の公式クラウドセーブ同期がありません。**ValleySave がその穴を埋めます**。牧場のセーブデータを自動検出し、**あなた自身の Google Drive** の `ValleySave/` フォルダにアップロード。他のデバイス（Windows・macOS・Linux・Android）でダウンロードして、そのまま続きをプレイできます。

- 🔒 **プライバシー第一** — Google の制限付き `drive.file` スコープを使用。アプリは自分が作成したファイルしか見えず、Drive の他の内容には一切アクセスできません。
- 🖥️ **真のクロスプラットフォーム** — 単一コードベース（Flutter）、4 プラットフォームすべてネイティブビルド。
- 🌍 **14 言語対応** — 日本語、英語、スペイン語、バスク語、フランス語、ドイツ語、イタリア語、ポルトガル語、ロシア語、ウクライナ語、韓国語、中国語（簡体字・繁体字）、タイ語。

## 機能

### セーブデータの同期・転送
- **牧場の自動検出** — あらゆるプラットフォームでセーブデータを発見。Linux の Steam（ネイティブ / Flatpak / Snap）や、Android の保護された `Android/data` フォルダ（root・[Shizuku](https://shizuku.rikka.app/)・手動ブリッジの各モード）にも対応。
- **ワンクリックでアップロード / ダウンロード** — 牧場ごとにローカルと Drive のどちらが新しいかを表示し、適切な操作を提案。
- **不完全なセーブの保護** — Drive 上でファイルが欠けているセーブにはフラグが付き、中途半端な状態でのダウンロードを防ぎます。

### データの安全性（最も誇りにしている部分）
- **トランザクショナルな置き換え** — ダウンロード・インポート・復元はすべて *準備 → 検証 → バックアップ → 置換 → 確認* のパイプラインを通り、失敗時は自動ロールバック。ダウンロード中に PC がクラッシュしても、元のセーブは無傷のまま、または自動復元されます。
- **アトミックなアップロード** — アップロードは新しい不変の「世代」フォルダに書き込まれ、最後のマニフェスト更新 1 回で公開されます。他のデバイスが中途半端なセーブを見ることはありません。
- **保持機能付き自動バックアップ** — 置き換えの前に必ず検証済みバックアップを作成。牧場ごとに直近 5 件の自動バックアップを保持（手動バックアップは削除されません）。
- **クラッシュ復旧** — 中断された操作の一時フォルダは次回起動時に検出され、常に有効なコピーを優先して安全に解決されます。

### マルチプレイ（協力プレイ）
- **ホスト移行** — 協力プレイ牧場のホスト役をセーブファイル内で別のプレイヤーに移譲。移行前後で完全な整合性検証を実施。いつものホストが不在でも同じ牧場で遊べます。
- **牧場を友達と共有** — Drive 経由で牧場を共有し、他のプレイヤーがダウンロードしてプレイを継続。ロールバッジ付き（閲覧のみ / 同期可）。
- **全プレイヤー表示** — 協力プレイの牧場はホストだけでなく全員の農夫を表示。

### 便利機能
- **アプリからゲームを起動** — Windows・macOS・Linux で Stardew Valley を検出して起動（Steam ネイティブ / Flatpak / Snap）。
- **.zip からセーブをインポート** — ダウンロードと同じトランザクション保護付き。
- **内蔵アップデーター** — GitHub Releases を確認し、新バージョンを自動ダウンロード。
- **季節の UI** — インターフェース全体がゲーム内の季節に連動：春は花びら、夏はホタル、秋は落ち葉、冬は雪。

## ダウンロード

最新版は **[Releases](https://github.com/hirieo/valleysave-app/releases/latest)** から：

| プラットフォーム | ファイル | 備考 |
|---|---|---|
| **Windows** | `ValleySave-Setup-*.exe` | インストーラー — VC++ ランタイム同梱、14 言語 |
| **Windows**（ポータブル） | `ValleySave-*-windows.zip` | 解凍して実行 |
| **macOS** | `valleysave-macos.zip` | 解凍してアプリケーションへ移動 |
| **Linux**（Ubuntu/Debian） | `valleysave_*_amd64.deb` | ダブルクリックでインストール — メニューアイコン付き |
| **Linux**（ポータブル） | `valleysave-linux-x64.tar.gz` | 展開して実行、どのディストロでも |
| **Android** | `ValleySave-*.apk` | Android 8 以上 |

## 使い方

1. **接続** — 自分の Google アカウントを連携（OAuth、`drive.file` スコープのみ）。
2. **検出** — ValleySave が牧場を自動的に見つけます。
3. **同期** — 牧場を Drive の `ValleySave/` フォルダにアップロード。
4. **どこでも続きから** — 別のデバイスに ValleySave を入れて同じアカウントを接続、ダウンロードしてプレイ。

## よくある質問

**Stardew Valley に PC とモバイル間の公式クラウドセーブはありますか？**
ありません — セーブはローカル保存で、公式のクロスプラットフォーム同期は存在しません。ValleySave があなた自身の Google Drive を使ってそれを実現します。

**セーブデータは安全ですか？**
破壊的な操作はすべてトランザクショナルです。元のセーブは置き換え前にバックアップ・検証され、失敗時は自動復元されます。

**セーブデータはどこに保存されますか？**
*あなた自身の* Google Drive 内の `ValleySave/` フォルダです。ValleySave のサーバーは存在しません。

**Windows と Android の間で牧場を移動できますか？**
はい — それが中心的なユースケースです。macOS・Linux も含め、どの方向にも移動できます。

## ソースからビルド

必要環境: [Flutter](https://docs.flutter.dev/get-started/install) ≥ 3.12 · Android Studio（Android ビルド用）

```bash
git clone https://github.com/hirieo/valleysave-app.git
cd valleysave-app

flutter pub get
cp .env.example .env
# デスクトップ: .env に GOOGLE_CLIENT_ID と GOOGLE_CLIENT_SECRET を記入
flutter run
```

## ライセンス

[Polyform Noncommercial 1.0.0](../../LICENSE) — コードの閲覧・学習・貢献は自由。商用利用には明示的な許可が必要です。

**無保証**で配布されています。自己責任でご利用ください。
