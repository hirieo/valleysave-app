# ValleySave

Sincroniza tus partidas de **Stardew Valley** con tu propia cuenta de Google Drive. Sin servidores propios. Sin suscripciones obligatorias.

## Plataformas

Android · iOS · macOS · Windows · Linux

## Cómo funciona

1. Conecta tu cuenta de Google — la app solo accede a los archivos que ella misma crea (`drive.file`)
2. ValleySave detecta tus partidas y las sube a una carpeta `ValleySave/` en tu Drive
3. Desde cualquier otro dispositivo puedes descargar y restaurar

## Compilar desde fuente

```bash
flutter pub get
cp .env.example .env
# Rellena GOOGLE_CLIENT_ID y GOOGLE_CLIENT_SECRET en .env
# (solo necesario en macOS / Windows / Linux — ver .env.example)
flutter run
```

> Android e iOS usan `google_sign_in` — las credenciales van en
> `google-services.json` (Android) y `GoogleService-Info.plist` (iOS),
> que debes obtener desde tu propio proyecto en Google Cloud Console.

## Estado

En desarrollo activo. Funcional en Android y escritorio (macOS/Windows).

## Licencia

[Polyform Noncommercial 1.0.0](./LICENSE) — puedes ver el código, estudiar cómo funciona y contribuir. No puedes usarlo con fines comerciales.
