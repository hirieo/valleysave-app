<div align="center">

<img src="../../assets/icons/icon.png" width="200" height="200" alt="ValleySave — 星露谷物语存档同步应用标志">

# ValleySave

**在 Windows、macOS、Linux 和 Android 之间同步你的星露谷物语（Stardew Valley）存档 — 使用你自己的 Google Drive。**

无第三方服务器。无订阅。无跟踪。你的存档永远不会离开你自己的 Google 账号。

[![最新版本](https://img.shields.io/github/v/release/hirieo/valleysave-app?label=%E4%B8%8B%E8%BD%BD&color=brightgreen)](https://github.com/hirieo/valleysave-app/releases/latest)
[![下载量](https://img.shields.io/github/downloads/hirieo/valleysave-app/total?color=blue)](https://github.com/hirieo/valleysave-app/releases)
[![许可证: Polyform NC](https://img.shields.io/badge/License-Polyform%20NC-orange)](../../LICENSE)
![平台](https://img.shields.io/badge/Windows%20%7C%20macOS%20%7C%20Linux%20%7C%20Android-lightgrey)

[🇬🇧 English](../../README.md) · [🇪🇸 Español](README.es.md) · [🇫🇷 Français](README.fr.md) · [🇩🇪 Deutsch](README.de.md) · [🇮🇹 Italiano](README.it.md) · [🇵🇹 Português](README.pt.md) · [Euskera](README.eu.md) · [🇷🇺 Русский](README.ru.md) · [🇺🇦 Українська](README.uk.md) · [🇯🇵 日本語](README.ja.md) · [🇰🇷 한국어](README.ko.md) · 🇨🇳 中文 · [🇹🇼 中文（繁體）](README.zh-Hant.md) · [🇹🇭 ไทย](README.th.md)

</div>

---

> [!IMPORTANT]
> **ValleySave 目前处于抢先体验阶段。** Google 登录页面仍在等待 Google 的验证，因此目前只有白名单中的 Google 账号才能连接。如需获取权限，请发送邮件至 **lhirieo@gmail.com**，注明你将用于 ValleySave 的 Google 账号（邮箱地址）。一旦 Google 完成验证，将向所有人开放。

## ValleySave 是什么？

星露谷物语在 PC 和移动端之间没有官方云存档同步。**ValleySave 填补了这个空白**：它会自动检测你的农场存档，上传到**你自己的 Google Drive** 中的 `ValleySave/` 文件夹，然后你可以在任何其他设备上下载并继续游玩 — Windows、macOS、Linux 或 Android。

- 🔒 **隐私优先** — 使用 Google 受限的 `drive.file` 权限范围：应用只能看到它自己创建的文件，永远无法访问你 Drive 中的其他内容。
- 🖥️ **真正的跨平台** — 单一代码库（Flutter），四个平台全部原生构建。
- 🌍 **14 种语言** — 中文（简体、繁体）、英语、西班牙语、巴斯克语、法语、德语、意大利语、葡萄牙语、俄语、乌克兰语、日语、韩语和泰语。

## 功能

### 存档同步与转移
- **自动检测农场** — 在每个平台上找到你的存档，包括 Linux 上的 Steam（原生、Flatpak 和 Snap）以及 Android 上受保护的 `Android/data` 文件夹（root、[Shizuku](https://shizuku.rikka.app/) 或手动桥接模式）。
- **一键上传/下载** — 每个农场卡片显示哪一侧更新（本地还是 Drive），并推荐正确的操作。
- **不完整存档保护** — Drive 中缺少文件的存档会被标记，无法半途下载。

### 数据安全（我们最引以为豪的部分）
- **事务性替换** — 每次下载、导入和恢复都经过*准备 → 校验 → 备份 → 替换 → 验证*流程，失败时自动回滚。即使电脑在下载中途崩溃，你的原始存档也会保持完好或被自动恢复。绝不会出现写了一半的农场。
- **原子上传** — 上传写入一个新的不可变"世代"文件夹，仅通过最后一次清单更新发布。其他设备永远不会看到上传了一半的存档。
- **带保留策略的自动备份** — 替换任何存档前都会创建经过验证的备份；每个农场保留最近 5 个自动备份（手动备份永不删除）。
- **崩溃恢复** — 中断操作留下的临时文件夹会在下次启动时被检测并安全处理，始终优先保留有效副本。

### 联机合作
- **房主迁移** — 在存档文件中将合作农场的房主角色转移给另一位玩家，迁移前后都进行完整性验证。即使平时的房主不在，也能继续玩同一个农场。
- **与朋友共享农场** — 通过 Drive 共享农场，让其他玩家下载并继续游玩，带角色标识（只读或可同步）。
- **显示所有玩家** — 合作农场卡片显示所有农夫，而不仅仅是房主。

### 便利功能
- **从应用启动游戏** — 在 Windows、macOS 和 Linux 上检测并启动星露谷物语（Steam 原生 / Flatpak / Snap）。
- **从 .zip 导入存档** — 与下载相同的事务性保护。
- **内置更新器** — 检查 GitHub Releases 并为你下载新版本。
- **季节主题界面** — 整个界面跟随游戏内季节变化：春天花瓣、夏天萤火虫、秋天落叶、冬天飘雪。

## 下载

从 **[Releases](https://github.com/hirieo/valleysave-app/releases/latest)** 获取最新版本：

| 平台 | 文件 | 说明 |
|---|---|---|
| **Windows** | `ValleySave-Setup-*.exe` | 安装程序 — 内含 VC++ 运行库，14 种语言 |
| **Windows**（便携版） | `ValleySave-*-windows.zip` | 解压即用 |
| **macOS** | `valleysave-macos.zip` | 解压后移到"应用程序" |
| **Linux**（Ubuntu/Debian） | `valleysave_*_amd64.deb` | 双击安装 — 含菜单图标 |
| **Linux**（便携版） | `valleysave-linux-x64.tar.gz` | 解压即用，任何发行版 |
| **Android** | `ValleySave-*.apk` | Android 8+ |

## 工作原理

1. **连接** — 关联你自己的 Google 账号（OAuth，仅 `drive.file` 权限）。
2. **检测** — ValleySave 自动找到你的农场。
3. **同步** — 将农场上传到你 Drive 的 `ValleySave/` 文件夹。
4. **随处继续** — 在另一台设备上安装 ValleySave，连接同一账号，下载并游玩。

## 常见问题

**星露谷物语在 PC 和移动端之间有官方云存档吗？**
没有 — 存档保存在本地，不存在官方跨平台同步。ValleySave 通过你自己的 Google Drive 提供这一功能。

**我的存档数据安全吗？**
所有破坏性操作都是事务性的：原始存档在替换前会被备份和验证，失败时自动恢复。

**我的存档存储在哪里？**
在*你自己的* Google Drive 中的 `ValleySave/` 文件夹。不存在 ValleySave 服务器。

**能在 Windows 和 Android 之间转移农场吗？**
能 — 这正是核心使用场景。macOS 和 Linux 也可以，任意方向。

## 从源码构建

要求：[Flutter](https://docs.flutter.dev/get-started/install) ≥ 3.12 · Android Studio（用于 Android 构建）

```bash
git clone https://github.com/hirieo/valleysave-app.git
cd valleysave-app

flutter pub get
cp .env.example .env
# 桌面端：在 .env 中填写 GOOGLE_CLIENT_ID 和 GOOGLE_CLIENT_SECRET
flutter run
```

## 许可证

[Polyform Noncommercial 1.0.0](../../LICENSE) — 可以阅读代码、学习并贡献；商业使用需要明确授权。

**不提供任何保证**。使用风险自负。
