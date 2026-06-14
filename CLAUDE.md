# ValleySave — App (Flutter)

## Stack
Flutter/Dart (Android, iOS, macOS, Windows, Linux) · Google Drive API
AdMob · in_app_purchase · Ko-fi · MIT License

Repo hermano: `valleysave-web` (landing).

## Modos siempre activos
CAVEMAN · DREAM (auto-plan) · MEMORY (auto-update)
Ver `.claude/rules/protocolo.md` para detalles.

## Rules
@.claude/rules/protocolo.md
@.claude/rules/seguridad.md
@.claude/rules/flutter.md

## Skills — leer en este orden al empezar sesión
@.claude/skills/valleysave-project/SKILL.md
@.claude/skills/valleysave-design/SKILL.md

## Memoria
@.claude/memory.md

## Comandos
/caveman /dream /memory /find-skills /update-config
/flush /simplify /loop /spec-kit /consolidate-memory

## Estado
<!-- BEGIN STATE -->
Última sesión: 2026-06-14

Completado:
- Paleta de estaciones finalizada y validada en season_state.dart
- Chips de estación — welcome_screen.dart → _seasonChip()
- Teclas 1-5 → HardwareKeyboard
- PrimaryButton + GhostButton reactivos al accentColor de la estación
- SeasonClickEffect integrado en ambos botones
- 001-fix-hit-test — APROBADO ✅
- 002-contrast-fix — APROBADO ✅
- Primavera finalizada ✅
  · Paleta: "Original" (#221040 / #6030a0 / #d04898, colinas #4a8a2a/#2e5a18)
  · Pétalos: teardrop bezier, 55p, vy .15-.5, drift 1.5-3.5, size 7-15
- Verano luciérnagas finalizado ✅
  · Concentradas zona colinas (y: H*.45→H*.95), vy -.08→-.02, drift .5-1.2, size 3-6, 55p
- SeasonClickEffect finalizado ✅
  · 5000ms, 35p, gravity 55, fade delay 60%, teardrop bezier para primavera
- Otoño hojas finalizado ✅
  · 90 hojas, big(35%)/small(65%), vx −1.0→5.5 / −1.5→2.0, wind gust periódico
  · Respawn desde arriba en ancho completo (sin chorro lateral)
  · debug spring picker y fall toggle eliminados — código limpio

Patrón de preview (para todas las sesiones futuras):
- Flutter corre en localhost:9191
- Controller: python AppData/Local/Temp/flutter_ctrl_new.py (usa flutter en Downloads)
- Flutter bin: C:\Users\Hirieo\Downloads\flutter_windows_3.44.0-stable\flutter\bin\flutter.bat
- Chrome app-mode: chrome.exe --app=http://localhost:9191 --force-app-mode
- HWND app-mode 788286 / RenderWidgetHostHWND 1312454 (client 946x623) — puede cambiar
- Encontrar HWNDs: EnumWindows("ValleySave") + EnumChildWindows("Chrome_RenderWidgetHostHWND")
- PostMessage chip coords (client 946x623): Primavera x≈309, Verano x≈439, Otoño x≈569, y≈582
- DPI scale=150%

Pendiente:
- IDEAS ESTACIONALES APROBADAS EN CONCEPTO — implementar cuando toque:
  · BOTONES (todas estaciones): click → efecto dramático en fondo → transición a pantalla destino
  · INICIAL: estrellas pulsan/brillan al interactuar
  · PRIMAVERA: más pétalos o lluvia fina al interactuar (DECISIÓN PENDIENTE: pétalos vs rain)
  · VERANO: luciérnagas brillan más intenso temporalmente al interactuar
  · OTOÑO: más hojas + ráfaga de viento al interactuar
- Ciclo automático de estaciones (9s por estación)
- Google OAuth flow
- Google Drive API integration
- Save file detection por plataforma
- Upload/Download básico a Drive
- Auto-save watcher (desktop)
- AdMob integration + in_app_purchase

Bloqueantes:
- Ninguno
<!-- END STATE -->

<!-- SPECKIT START -->
Current feature plan: specs/001-fix-hit-test/plan.md
Research: specs/001-fix-hit-test/research.md
Spec: specs/001-fix-hit-test/spec.md
<!-- SPECKIT END -->
