<div align="center">

<img src="../../assets/icons/icon.png" width="200" height="200" alt="ValleySave — 스타듀밸리 세이브 동기화 앱 로고">

# ValleySave

**Stardew Valley(스타듀밸리) 세이브를 Windows, macOS, Linux, Android 간에 동기화 — 나만의 Google Drive로.**

제3자 서버 없음. 구독 없음. 추적 없음. 세이브 데이터는 절대 내 Google 계정 밖으로 나가지 않습니다.

[![최신 릴리스](https://img.shields.io/github/v/release/hirieo/valleysave-app?label=%EB%8B%A4%EC%9A%B4%EB%A1%9C%EB%93%9C&color=brightgreen)](https://github.com/hirieo/valleysave-app/releases/latest)
[![다운로드 수](https://img.shields.io/github/downloads/hirieo/valleysave-app/total?color=blue)](https://github.com/hirieo/valleysave-app/releases)
[![라이선스: Polyform NC](https://img.shields.io/badge/License-Polyform%20NC-orange)](../../LICENSE)
![플랫폼](https://img.shields.io/badge/Windows%20%7C%20macOS%20%7C%20Linux%20%7C%20Android-lightgrey)

[🇬🇧 English](../../README.md) · [🇪🇸 Español](README.es.md) · [🇫🇷 Français](README.fr.md) · [🇩🇪 Deutsch](README.de.md) · [🇮🇹 Italiano](README.it.md) · [🇵🇹 Português](README.pt.md) · [Euskera](README.eu.md) · [🇷🇺 Русский](README.ru.md) · [🇺🇦 Українська](README.uk.md) · [🇯🇵 日本語](README.ja.md) · 🇰🇷 한국어 · [🇨🇳 中文](README.zh.md) · [🇹🇼 中文（繁體）](README.zh-Hant.md) · [🇹🇭 ไทย](README.th.md)

</div>

---

## ValleySave란?

스타듀밸리에는 PC와 모바일 간 공식 클라우드 세이브 동기화가 없습니다. **ValleySave가 그 공백을 채웁니다**: 농장을 자동으로 감지하고, **나만의 Google Drive** 안 `ValleySave/` 폴더에 업로드하며, 다른 기기(Windows, macOS, Linux, Android)에서 내려받아 이어서 플레이할 수 있게 해줍니다.

- 🔒 **프라이버시 우선** — Google의 제한된 `drive.file` 스코프 사용: 앱은 자신이 만든 파일만 볼 수 있고, Drive의 다른 내용에는 접근할 수 없습니다.
- 🖥️ **진정한 크로스 플랫폼** — 하나의 코드베이스(Flutter), 네 플랫폼 모두 네이티브 빌드.
- 🌍 **14개 언어** — 한국어, 영어, 스페인어, 바스크어, 프랑스어, 독일어, 이탈리아어, 포르투갈어, 러시아어, 우크라이나어, 일본어, 중국어(간체·번체), 태국어.

## 기능

### 세이브 동기화 및 이동
- **농장 자동 감지** — 모든 플랫폼에서 세이브를 찾아냅니다. Linux의 Steam(네이티브, Flatpak, Snap)과 Android의 보호된 `Android/data` 폴더(root, [Shizuku](https://shizuku.rikka.app/), 수동 브리지 모드) 포함.
- **원클릭 업로드/다운로드** — 농장마다 어느 쪽이 최신인지(로컬 vs Drive) 표시하고 알맞은 동작을 추천합니다.
- **불완전 세이브 보호** — Drive에 파일이 누락된 세이브는 표시되며 반쪽짜리 상태로 다운로드되지 않습니다.

### 데이터 안전성 (가장 자랑스러운 부분)
- **트랜잭션 교체** — 모든 다운로드·가져오기·복원이 *준비 → 검증 → 백업 → 교체 → 확인* 파이프라인을 거치며 실패 시 자동 롤백됩니다. 다운로드 중 PC가 꺼져도 원본 세이브는 그대로 남거나 자동 복원됩니다.
- **원자적 업로드** — 업로드는 새로운 불변 "세대" 폴더에 기록되고 마지막 매니페스트 갱신 한 번으로 공개됩니다. 다른 기기가 반쯤 업로드된 세이브를 보는 일은 없습니다.
- **보존 기능이 있는 자동 백업** — 교체 전 반드시 검증된 백업을 생성. 농장당 최근 자동 백업 5개 보관(수동 백업은 절대 삭제되지 않음).
- **크래시 복구** — 중단된 작업의 임시 폴더는 다음 실행 시 감지되어 항상 유효한 사본을 우선으로 안전하게 정리됩니다.

### 협동 멀티플레이
- **호스트 이전** — 협동 농장의 호스트 역할을 세이브 파일 안에서 다른 플레이어에게 이전. 전후로 완전한 무결성 검증. 평소 호스트가 없어도 같은 농장을 계속 플레이하세요.
- **친구와 농장 공유** — Drive로 농장을 공유해 다른 플레이어가 내려받아 이어서 플레이. 역할 배지 표시(읽기 전용/동기화).
- **모든 플레이어 표시** — 협동 농장 카드에 호스트뿐 아니라 모든 농부가 표시됩니다.

### 편의 기능
- **앱에서 게임 실행** — Windows, macOS, Linux에서 스타듀밸리를 감지하고 실행(Steam 네이티브/Flatpak/Snap).
- **.zip에서 세이브 가져오기** — 다운로드와 동일한 트랜잭션 보호 적용.
- **내장 업데이터** — GitHub Releases를 확인하고 새 버전을 자동 다운로드.
- **계절 UI** — 인터페이스 전체가 게임 속 계절을 따라갑니다: 봄엔 꽃잎, 여름엔 반딧불이, 가을엔 낙엽, 겨울엔 눈.

## 다운로드

최신 버전은 **[Releases](https://github.com/hirieo/valleysave-app/releases/latest)**에서:

| 플랫폼 | 파일 | 비고 |
|---|---|---|
| **Windows** | `ValleySave-Setup-*.exe` | 설치 프로그램 — VC++ 런타임 포함, 14개 언어 |
| **Windows** (포터블) | `ValleySave-*-windows.zip` | 압축 해제 후 실행 |
| **macOS** | `valleysave-macos.zip` | 압축 해제 후 응용 프로그램으로 이동 |
| **Linux** (Ubuntu/Debian) | `valleysave_*_amd64.deb` | 더블클릭으로 설치 — 메뉴 아이콘 포함 |
| **Linux** (포터블) | `valleysave-linux-x64.tar.gz` | 풀어서 실행, 모든 배포판 |
| **Android** | `ValleySave-*.apk` | Android 8 이상 |

## 작동 방식

1. **연결** — 내 Google 계정을 연동(OAuth, `drive.file` 스코프만).
2. **감지** — ValleySave가 농장을 자동으로 찾습니다.
3. **동기화** — 농장을 Drive의 `ValleySave/` 폴더에 업로드.
4. **어디서든 계속** — 다른 기기에 ValleySave를 설치하고 같은 계정을 연결한 뒤 내려받아 플레이.

## 자주 묻는 질문

**스타듀밸리에 PC-모바일 간 공식 클라우드 세이브가 있나요?**
없습니다 — 세이브는 로컬에 저장되며 공식 크로스 플랫폼 동기화는 존재하지 않습니다. ValleySave가 나만의 Google Drive로 이를 제공합니다.

**세이브 데이터는 안전한가요?**
모든 파괴적 작업은 트랜잭션 방식입니다. 원본은 교체 전에 백업·검증되고 실패 시 자동 복원됩니다.

**세이브는 어디에 저장되나요?**
*나만의* Google Drive 안 `ValleySave/` 폴더입니다. ValleySave 서버는 존재하지 않습니다.

**Windows와 Android 간에 농장을 옮길 수 있나요?**
네 — 그것이 핵심 사용 사례입니다. macOS와 Linux도 어느 방향으로든 가능합니다.

## 소스에서 빌드

요구 사항: [Flutter](https://docs.flutter.dev/get-started/install) ≥ 3.12 · Android Studio(Android 빌드용)

```bash
git clone https://github.com/hirieo/valleysave-app.git
cd valleysave-app

flutter pub get
cp .env.example .env
# 데스크톱: .env에 GOOGLE_CLIENT_ID와 GOOGLE_CLIENT_SECRET 입력
flutter run
```

## 라이선스

[Polyform Noncommercial 1.0.0](../../LICENSE) — 코드 열람·학습·기여는 자유이며, 상업적 이용은 명시적 허가가 필요합니다.

**어떠한 보증도 없이** 배포됩니다. 사용에 따른 책임은 본인에게 있습니다.
