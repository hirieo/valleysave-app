# Flutter / Dart — Reglas del proyecto

## Naming
- Clases: `PascalCase` → `SaveFileCard`, `DriveSync`
- Archivos: `snake_case` → `save_file_card.dart`, `drive_sync_service.dart`
- Variables/métodos: `camelCase` → `syncSaveFile()`, `lastSyncDate`
- Constantes: `kConstantName` o `SCREAMING_SNAKE` si es global
- Widgets: sufijo describe su tipo → `SaveListView`, `SyncStatusBadge`

## Estructura de carpetas
```
lib/
  core/         # lógica de negocio, servicios, modelos
    models/
    services/
    repositories/
  features/     # feature-first: cada carpeta = pantalla/flujo
    home/
    sync/
    settings/
  shared/       # widgets y utilidades compartidas
    widgets/
    utils/
  main.dart
```

## Widgets
- Preferir `StatelessWidget` siempre que sea posible
- `StatefulWidget` solo cuando el estado es local y no compartido
- Estado compartido: usar Provider, Riverpod o Bloc según lo que ya use el proyecto
- Nunca lógica de negocio dentro de un widget — separar en service/controller
- Widgets grandes (>100 líneas): dividir en sub-widgets

## Errores
- Siempre manejar errores en operaciones async con try/catch
- No usar `!` para null assertion sin estar seguro — preferir `?.` y `??`
- Logging de errores antes de relanzar o mostrar al usuario

## Google Drive / APIs externas
- Credenciales NUNCA en código — cargar de variables de entorno o flutter_dotenv
- Tokens de OAuth en secure storage (flutter_secure_storage), nunca SharedPreferences
- Manejar `GoogleAuthException`, `DriveException` explícitamente

## AdMob
- Inicializar en `main.dart` antes de `runApp()`
- Test IDs en desarrollo, reales solo en producción
- IDs en variables de entorno / flavor, nunca hardcodeados

## Comandos útiles
```bash
flutter pub get           # instalar dependencias
flutter run               # ejecutar en dispositivo/emulador
flutter build apk         # build Android release
flutter build ios         # build iOS release
flutter test              # ejecutar tests
dart fix --apply          # fix automático de lint
dart format .             # formatear todo el proyecto
```

## Gotchas
- `async`/`await` en `initState`: usar `WidgetsBinding.instance.addPostFrameCallback`
- No hacer `setState` después de `dispose` — siempre comprobar `mounted`
- Hot reload no regenera providers — hacer hot restart si el estado no se actualiza
