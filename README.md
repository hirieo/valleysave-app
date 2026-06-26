# ValleySave

<div align="center">

<img src="assets/icons/icon.png" width="200" height="200" alt="ValleySave Logo">

**Sincroniza tus partidas de Stardew Valley con tu propia cuenta de Google Drive.**

[![License: Polyform NC](https://img.shields.io/badge/License-Polyform%20NC-orange)](./LICENSE)
![Status: Active Development](https://img.shields.io/badge/Status-Active%20Development-blue)
![Platforms](https://img.shields.io/badge/Platforms-Android%20%7C%20iOS%20%7C%20macOS%20%7C%20Windows%20%7C%20Linux-brightgreen)

</div>

---

> ⚠️ **En desarrollo activo.** Funcional en Android y escritorio (macOS/Windows). iOS y Linux aún en testing.

## Introducción

ValleySave es una aplicación multiplataforma que sincroniza automáticamente tus partidas de Stardew Valley usando tu propia cuenta de Google Drive. 

**Sin servidores propios. Sin suscripciones. Sin seguimiento.**

- 🔒 Solo accede a los archivos que ella misma crea (`drive.file`)
- 📱 Disponible en Android, iOS, macOS, Windows y Linux
- 🎯 Detecta y sincroniza partidas automáticamente
- 📊 Interfaz estacional con temática de Stardew Valley

## Características

- **Sincronización automática** — detecta cambios en tus partidas y los sube a Drive
- **Multi-dispositivo** — descarga y restaura desde cualquier plataforma
- **Sin intermediarios** — tus datos viven en tu propia cuenta de Google, no en servidores ajenos
- **Interfaz temática** — diseño estacional que respeta la atmósfera de Stardew Valley
- **Polyform NC** — código disponible, no comercial

## Descargas

Las compilaciones oficiales aparecerán en [Releases](../../releases) cuando la app esté lista para producción.

Por ahora, [compila desde fuente](#compilar-desde-fuente).

## Compilar desde fuente

### Requisitos

- [Flutter](https://flutter.dev/docs/get-started/install) (≥3.12)
- Android Studio (para Android) o Xcode (para iOS/macOS)

### Instrucciones

```bash
git clone https://github.com/hirieo/valleysave-app.git
cd valleysave-app

flutter pub get
cp .env.example .env
# En macOS/Windows/Linux: rellena GOOGLE_CLIENT_ID y GOOGLE_CLIENT_SECRET en .env
flutter run
```

**Nota:** Android e iOS requieren credenciales propias de Google Cloud:
- **Android:** `google-services.json` (obtén desde tu proyecto en Google Cloud Console)
- **iOS:** `GoogleService-Info.plist` (lo mismo)
- **Desktop:** usa las variables en `.env.example`

## Cómo funciona

1. **Conecta tu cuenta** — abre la app y vincula tu Google Drive
2. **Detecta partidas** — ValleySave encuentra tus archivos de Stardew Valley
3. **Sincroniza automáticamente** — crea una carpeta `ValleySave/` en tu Drive y sube tus archivos
4. **Sincroniza en otro dispositivo** — descarga y restaura desde cualquier plataforma soportada

## Reportes de errores

Solo reporta bugs que afecten la funcionalidad core. Los bugs cosméticos (UI, temas) se ignoran temporalmente mientras la app esté en desarrollo temprano.

Para reportar: [Issues](../../issues)

## Contribuciones

ValleySave es código disponible bajo Polyform Noncommercial. Puedes:
- Ver el código fuente
- Aprender cómo funciona
- Contribuir con mejoras (pull requests bienvenidos)

**Restricción:** No puedes usar este código con fines comerciales sin autorización explícita.

## Licencia

[Polyform Noncommercial 1.0.0](./LICENSE)

Este programa se distribuye bajo la esperanza de que sea útil, pero **sin ninguna garantía**. Usa a tu propio riesgo.

---

**Repo hermano:** [`valleysave-web`](../valleysave-web) (landing y presencia web)
