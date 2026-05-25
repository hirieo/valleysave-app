---
name: valleysave-project
description: >
  Especificación completa del proyecto ValleySave. Leer SIEMPRE al empezar
  cualquier sesión de trabajo. Contiene: visión, arquitectura, repos,
  funcionalidades, decisiones técnicas, rutas de save files, monetización
  y preguntas abiertas pendientes de investigar.
effort: low
---

## Visión del producto

ValleySave sincroniza archivos de guardado de **Stardew Valley** entre todos
los dispositivos del usuario usando su propia cuenta de **Google Drive**.

Sin servidores propios. Sin suscripciones. Los datos del usuario son suyos.

---

## Dos repositorios, un proyecto

### `valleysave-web`
Landing page + presencia web del proyecto.
- Stack: HTML/CSS/JS o framework ligero
- Ya existe un boceto completo de UI (ver skills de diseño)
- Incluye: landing con estaciones animadas, Ko-fi, información del proyecto

### `valleysave-app`
La aplicación multiplataforma.
- Stack: **Flutter/Dart** (única opción que cubre todos los targets)
- Targets: Android, iOS, macOS, Windows, Linux
- Puede incluir una versión web de la app en el futuro

---

## Framework elegido: Flutter/Dart

**Por qué Flutter:**
- Un solo codebase para Android + iOS + macOS + Windows + Linux
- Soporte oficial de Google → buena integración con Google Drive API
- Rendimiento nativo en todas las plataformas
- Comunidad activa, packages maduros

**Packages clave a investigar:**
- `google_sign_in` → autenticación Google OAuth
- `googleapis` → Google Drive API
- `watcher` o `package:watcher` → file system watcher (auto-save)
- `flutter_background_service` → servicio en background para auto-sync
- `path_provider` → rutas de sistema de archivos por plataforma
- `google_mobile_ads` → AdMob
- `in_app_purchase` → quitar publicidad (compra única)

---

## Funcionalidades core

### 1. Conexión Google Drive
- OAuth con cuenta Google del usuario
- Crear carpeta `ValleySave/` en el Drive del usuario
- Estructura en Drive:
  ```
  ValleySave/
    [NombreGranja]_[Plataforma]/
      save_[timestamp]/
        PlayerName_farmNumber    ← archivo XML principal
        SaveGameInfo             ← info del jugador
  ```

### 2. Detección automática de save files

Rutas por plataforma:
```
Windows:  %AppData%\StardewValley\Saves\
macOS:    ~/.config/StardewValley/Saves/
Linux:    ~/.config/StardewValley/Saves/
Android:  /Android/data/com.chucklefish.stardewvalley/files/  ← requiere permisos
iOS:      Files app > StardewValley (com.chucklefish.stardewvalley)
```

⚠️ **Android/iOS**: acceso limitado en versiones modernas del OS.
Investigar: backup API de Android, Files app en iOS, permisos necesarios.

### 3. Upload / Export
- El usuario elige qué save subir
- Opciones:
  - **Sobrescribir** el save existente en Drive
  - **Crear nueva versión** (guarda con timestamp)
- Si no se configura nada: sobrescribe por defecto
- El usuario puede configurar cuántas versiones conservar en Drive

### 4. Download / Import
- Lista los saves disponibles en Drive
- El usuario elige cuál importar
- Confirmación antes de sobrescribir el save local
- Detectar conflictos: si el save local es más nuevo que el de Drive → advertir

### 5. Auto-save (feature estrella en desktop)
- Watcher del proceso de Stardew Valley:
  - Cuando el juego **cierra** → upload automático
  - Opcionalmente: upload periódico cada N minutos mientras el juego está abierto
- Solo disponible en plataformas desktop (Windows, macOS, Linux)
- En móvil: sync manual o al abrir/cerrar la app

### 6. Gestión de versiones
- El usuario decide cuántos saves guardar en Drive (por defecto: 1 = sobrescribe)
- Interfaz para ver y eliminar versiones antiguas
- Indicador de cuánto espacio ocupa en Drive

### 7. Detección de versión y mods

⚠️ **A investigar juntos:**
- ¿Los saves de PC y móvil son directamente compatibles?
- ¿Qué campos del XML son platform-specific?
- SMAPI mods en PC añaden datos al save → save con mods NO compatible con móvil sin esos mods
- Stardew Valley actualiza ambas plataformas simultáneamente (en principio) → investigar desfases

**Comportamiento propuesto:**
- Detectar si el save tiene datos de mods (SMAPI) → advertir al importar en plataforma diferente
- Detectar versión del juego en el XML → advertir si versiones no coinciden
- Nunca bloquear: solo advertir, el usuario decide

---

## Monetización

### Publicidad (AdMob)
- Banners en la app (bottom de pantalla)
- Native ads integrados en listas de saves
- Test IDs en desarrollo, IDs reales en producción via variables de entorno
- En web: proveedor a determinar (Google AdSense o similar)

### Quitar publicidad
- Compra única dentro de la app (`in_app_purchase`)
- Una vez comprado: se elimina toda la publicidad permanentemente
- Implementar en ambas plataformas (Google Play, App Store)
- ⚠️ A investigar: ¿cómo sincronizar el estado "sin publicidad" entre dispositivos del mismo usuario?
  Propuesta: guardar flag en Google Drive del usuario (mismo Drive que los saves)

### Donaciones
- Ko-fi integrado (enlace en la app y en la web)
- No obligatorio, no condiciona funcionalidades

---

## UI — Referencias ya construidas

Ver skills:
- `valleysave-design` → sistema de diseño completo (tokens, componentes)
- `frontend-design` → principios estéticos (Fraunces italic, paleta dark gold/green)
- `canvas-seasons` → hero animado con estaciones (primavera/verano/otoño/invierno)

**Bocetos validados en esta sesión:**
- Landing page con hero estacional animado (Canvas 2D)
- App UI: sidebar + lista de saves + barra de sync + AdMob banner
- Sección Ko-fi en landing
- Native ad integrado en grid de saves

---

## Preguntas abiertas (investigar)

- [ ] Compatibilidad exacta save files PC ↔ móvil en versiones actuales
- [ ] Campos XML que difieren entre plataformas
- [ ] Acceso a save files en Android 11+ (scoped storage)
- [ ] Acceso a save files en iOS sin jailbreak
- [ ] Cómo detectar que Stardew Valley está corriendo (proceso) en cada plataforma
- [ ] Sincronizar estado "sin publicidad" entre dispositivos del mismo usuario
- [ ] Política de AdMob para apps de gaming utilities
- [ ] Nintendo Switch: ¿es posible acceder a saves? (probablemente no)

---

## Estado del proyecto

- [x] Boceto de UI web (landing + app UI)
- [x] Sistema de diseño definido
- [x] Efectos estacionales implementados (Canvas 2D)
- [x] Sección de monetización (Ko-fi + AdMob) bocetada
- [ ] Repositorio `valleysave-app` creado
- [ ] Repositorio `valleysave-web` creado
- [ ] Setup Flutter inicial
- [ ] Google OAuth flow
- [ ] Google Drive API integration
- [ ] Save file detection por plataforma
- [ ] Upload/Download básico
- [ ] Auto-save watcher (desktop)
- [ ] AdMob integration
- [ ] In-app purchase (quitar publicidad)
