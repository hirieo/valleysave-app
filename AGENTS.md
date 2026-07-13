# ValleySave — App (Flutter)

## Stack
Flutter/Dart (Android, iOS, macOS, Windows, Linux) · Google Drive API
AdMob · in_app_purchase · Ko-fi · MIT License

Repo hermano: `valleysave-web` (landing).

## Modos siempre activos
CAVEMAN · DREAM (auto-plan) · MEMORY (auto-update)
Ver `.Codex/rules/protocolo.md` para detalles.

## Rules
@.Codex/rules/protocolo.md
@.Codex/rules/seguridad.md
@.Codex/rules/flutter.md

## Git — REGLA ESTRICTA

### Rama de desarrollo única
- La única rama de desarrollo es **`licendev`**
- Todo el trabajo va a `licendev` — nunca directamente a `main`
- No crear ramas nuevas de feature sin acordarlo con el usuario

### Fusión a main
- **NUNCA** fusionar `licendev` → `main` sin preguntar explícitamente:
  "¿Esto lo ponemos ya en main?"
- Esperar aprobación explícita antes de cualquier push/merge a `main`
- Push a `main` = release. Tratar como acción irreversible.

## Versionamiento

### Flujo de release
Al publicar versión nueva:
1. Subir `version` en `pubspec.yaml` (ej: `0.2.0+10`)
2. Crear **GitHub Release** con tag `v0.2.0`

### Cómo detecta la app la versión
- **Instalada**: `package_info_plus` lee `version` del `pubspec.yaml` en build-time → ej. `"0.1.0"`
- **Más reciente**: `GET https://api.github.com/repos/hirieo/valleysave-app/releases/latest` → campo `tag_name` → strip prefijo `v` → ej. `"0.2.0"`
- **Comparación**: semver campo a campo (major→minor→patch). `0.2.0 > 0.1.0` → update disponible.

### Dónde se muestra
- **WelcomeScreen**: chip Option A (semi-transparente, color estacional, entre "Drive conectado" y "Código abierto"). Se comprueba en background al arrancar.
- **Settings → APLICACIÓN**: fila versión instalada + fila "Buscar actualizaciones" manual (idle / checking / upToDate / available).

## Estética — regla de presentación
Ante cualquier cambio estético (colores, fondos, bordes, tipografía, tamaños),
SIEMPRE mostrar un preview visual renderizado (widget HTML/SVG) de cada opción
antes de implementar nada. Nunca solo texto descriptivo.

## Skills — leer en este orden al empezar sesión
@.Codex/skills/valleysave-project/SKILL.md
@.Codex/skills/valleysave-design/SKILL.md

## Memoria
@.Codex/memory.md

## Comandos
/caveman /dream /memory /find-skills /update-config
/flush /simplify /loop /spec-kit /consolidate-memory

## Estado
Última sesión: 2026-07-06

Sesión 2026-07-06:
- Auditoría completa del repo: seguridad, código sin uso, mejoras funcionales/estéticas
- Limpieza: bridge_service.dart eliminado (0 imports, superado por Shizuku), carpetas home/+repositories/ vacías, .gitkeep redundantes, mockups/PNGs/logs sueltos en raíz
- Animaciones de entrada más rápidas: Settings/HowItWorks 480→350ms, Privacy 500→380ms; disableAnimations (accesibilidad) respetado en las 4 pantallas de entrada
- Geolocator: investigado sustituir por locale/timezone → REVERTIDO a petición del usuario (prefiere precisión GPS a menos permisos). GPS se queda, decisión cerrada.
- `.env` como asset: investigado — Google exige client_secret en OAuth Desktop incluso con PKCE, no hay alternativa sin secreto. Se deja como está (práctica estándar); scope ya mínimo (`drive.file`). Decisión cerrada.
- **Firma de producción Android**: keystore creado (`C:\Users\Hirieo\keystores\valleysave-release.jks`), `android/key.properties` + `android/keystore_password.txt` (gitignored), `build.gradle.kts` firma release leyendo `KEY_PASSWORD` del entorno (cae a debug si no existe el keystore). Verificado con `apksigner`.
- Release **v0.1.15** publicada con firma de producción (rompe upgrade de versiones anteriores — requiere desinstalar antes). Limpieza: 11 releases + 4 tags antiguos borrados de GitHub.
- **Split de los 3 archivos más grandes**: `saves_screen.dart` (2214→1793 líneas + 4 widgets nuevos), `settings_screen.dart` (1470→1177 + 1 widget), `save_card.dart` (1650→1195 + 1 widget). `flutter analyze` limpio en los 3, sin verificación visual en app corriendo todavía.
- Nombre "ValleySave": usuario verificó Play Store — no hay conflicto real, solo existen editores de partida ("Save Editor for SV"), funcionalidad distinta. Bloqueante de publicación descartado.
- **Cambio de keystore → SHA-1 nuevo** (`EC:9D:E2:7E:71:3E:42:21:C0:D4:6C:6E:6E:90:47:D7:71:FE:F6:EF`): actualizado en Google Auth Platform → Clientes → cliente OAuth "Android" (antes tenía la huella del debug keystore viejo, rompía el login de Drive). **Recordar este paso en cualquier futuro cambio de keystore.**
- Token de GitHub en texto plano en `.git/config`: detectado, usuario decidió aceptar el riesgo ("está en mi PC, buena seguridad"). Cerrado, no replantear.

Sesión 2026-07-01:
- Botón ▶ lanzar Stardew Valley desde Saves screen (Windows + Android)
- GameLaunchService: auto-detect exe Steam/GOG/Xbox, AndroidIntent, picker PowerShell
- IconCircleButton: parámetros tooltip + color estacional
- Settings → sección JUEGO (solo Windows): ruta exe + picker "Buscar…"
- HowItWorksScreen: tarjeta "Abrir el juego" con tips Windows/Android
- i18n: 11 claves nuevas × 13 idiomas (ARB + regenerado)
- AndroidManifest: <queries> para com.chucklefish.stardewvalley
- Release v0.1.9: builds Windows zip + APK subidos a GitHub Releases
- Limpieza repo: 462 MB de builds eliminados + .gitignore actualizado

Sesión 2026-06-27:
- Investigación: MCP servers inyectan 2000-3000 tokens en system prompt (cada sesión)
- Configuración global `~/.Codex/settings.json`: solo `computer-use`, `Codex-in-chrome`, `preview` activos (resto desactivado)
- Creación `.claudeignore`: Flutter artifacts (build/, .dart_tool/, *.g.dart, etc.) → reduce 10-30% scans

Patrón de preview (para todas las sesiones futuras):
- Flutter run -d windows (app nativa, no web — necesario para acceso al filesystem)
- Flutter bin: C:\flutter\bin\flutter.bat
- keytool / apksigner: C:\Program Files\Android\Android Studio\jbr\bin\ (JAVA_HOME apunta aquí para apksigner del SDK)
- DPI scale=150%

Pendiente (prioridad):
- Tests unitarios (UpdateService semver, SeasonService._seasonFromMonth)
- Actualizar AGENTS.md tras verificar en código real (no confiar en memoria vieja sin comprobar)
- Testear botón ▶ en APK real (Android)
- Alinear tema estacional con la estación de la última partida
- Crear log de uso con rotación mensual automática
- meta.json para preservar timestamps tras copia Drive
- SyncScreen design
- IDEAS ESTACIONALES APROBADAS EN CONCEPTO — implementar cuando toque:
  · INICIAL: estrellas pulsan/brillan al interactuar
  · PRIMAVERA: más pétalos o lluvia fina (DECISIÓN PENDIENTE: pétalos vs rain)
  · VERANO: luciérnagas brillan más intenso temporalmente
  · OTOÑO: más hojas + ráfaga de viento al interactuar
- Ciclo automático de estaciones (9s por estación)
- Auto-save watcher (desktop)
- AdMob integration + in_app_purchase (Play Store)

Bloqueantes:
- Root Android: dispositivo rooteado sigue pidiendo Shizuku; _canAccessDirect() no detecta correctamente el acceso root. Además, el botón "cambiar método" no muestra la opción Root como alternativa visible.
