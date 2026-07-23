<div align="center">

<img src="../../assets/icons/icon.png" width="200" height="200" alt="ValleySave — logo de la app de sincronización de partidas de Stardew Valley">

# ValleySave

**Sincroniza tus partidas de Stardew Valley entre Windows, macOS, Linux y Android — con tu propio Google Drive.**

Sin servidores de terceros. Sin suscripciones. Sin rastreo. Tus partidas nunca salen de tu propia cuenta de Google.

[![Última versión](https://img.shields.io/github/v/release/hirieo/valleysave-app?label=Descargar&color=brightgreen)](https://github.com/hirieo/valleysave-app/releases/latest)
[![Descargas](https://img.shields.io/github/downloads/hirieo/valleysave-app/total?color=blue)](https://github.com/hirieo/valleysave-app/releases)
[![Licencia: Polyform NC](https://img.shields.io/badge/Licencia-Polyform%20NC-orange)](../../LICENSE)
![Plataformas](https://img.shields.io/badge/Windows%20%7C%20macOS%20%7C%20Linux%20%7C%20Android-lightgrey)

[🇬🇧 English](../../README.md) · 🇪🇸 Español · [🇫🇷 Français](README.fr.md) · [🇩🇪 Deutsch](README.de.md) · [🇮🇹 Italiano](README.it.md) · [🇵🇹 Português](README.pt.md) · [Euskera](README.eu.md) · [🇷🇺 Русский](README.ru.md) · [🇺🇦 Українська](README.uk.md) · [🇯🇵 日本語](README.ja.md) · [🇰🇷 한국어](README.ko.md) · [🇨🇳 中文](README.zh.md) · [🇹🇼 中文（繁體）](README.zh-Hant.md) · [🇹🇭 ไทย](README.th.md)

</div>

---

> [!IMPORTANT]
> **ValleySave está en acceso anticipado.** La pantalla de inicio de sesión de Google todavía está pendiente de verificación por parte de Google, así que solo las cuentas de Google en la lista blanca pueden conectarse por ahora. Para conseguir acceso, escribe a **lhirieo@gmail.com** con la cuenta de Google (correo) que vayas a usar con ValleySave. Se abrirá a todo el mundo en cuanto Google complete la verificación.

## ¿Qué es ValleySave?

Stardew Valley no tiene sincronización oficial de partidas en la nube entre PC y móvil. **ValleySave cubre ese hueco**: detecta tus granjas, las sube a una carpeta `ValleySave/` en **tu propio Google Drive**, y te deja descargarlas y seguir jugando en cualquier otro dispositivo — Windows, macOS, Linux o Android.

- 🔒 **Privacidad primero** — usa el scope restringido `drive.file` de Google: la app solo ve los archivos que ella misma crea, nunca el resto de tu Drive.
- 🖥️ **Multiplataforma de verdad** — un solo código (Flutter), builds nativas para las cuatro plataformas.
- 🌍 **14 idiomas** — español, inglés, euskera, francés, alemán, italiano, portugués, ruso, ucraniano, japonés, coreano, chino (simplificado y tradicional) y tailandés.

## Características

### Sincronización y transferencia de partidas
- **Detección automática de granjas** — encuentra tus saves de Stardew Valley en todas las plataformas, incluido Steam (nativo, Flatpak y Snap en Linux) y la carpeta protegida `Android/data` en Android (modos root, [Shizuku](https://shizuku.rikka.app/) o puente manual).
- **Subir / bajar con un clic** — cada granja muestra qué lado va por delante (local o Drive) y recomienda la acción correcta.
- **Protección contra saves incompletos** — una partida a la que le faltan archivos en Drive se marca y no se puede descargar a medias.

### Seguridad de datos (de lo que más orgullosos estamos)
- **Sustitución transaccional** — cada descarga, importación y restauración usa un flujo *preparar → validar → respaldar → sustituir → verificar* con rollback automático. Si el PC se cuelga a mitad de descarga, tu partida original queda intacta o se restaura sola. Nunca una granja a medio escribir.
- **Subidas atómicas** — las subidas van a una carpeta de "generación" nueva e inmutable y se publican con una única actualización final del manifiesto. Otros dispositivos jamás ven una partida a medio subir.
- **Respaldos automáticos con retención** — antes de sustituir cualquier partida se crea un respaldo verificado; se conservan los últimos 5 automáticos por granja (los manuales no se borran nunca).
- **Recuperación tras cierres inesperados** — las carpetas temporales de una operación interrumpida se detectan y resuelven de forma segura al arrancar, priorizando siempre la copia válida.

### Multijugador cooperativo
- **Cambio de anfitrión** — transfiere el rol de anfitrión de una granja coop a otro jugador dentro del archivo de la partida, con validación de integridad completa antes y después. Seguid jugando la misma granja aunque el anfitrión habitual no esté.
- **Comparte granjas con amigos** — comparte una granja por Drive para que otros jugadores la descarguen y sigan jugando, con distintivos de rol (solo lectura o sincronización).
- **Fichas con todos los jugadores** — las granjas coop muestran a todos los granjeros, no solo al anfitrión.

### Calidad de vida
- **Lanza el juego desde la app** — detecta y arranca Stardew Valley en Windows, macOS y Linux (Steam nativo / Flatpak / Snap).
- **Importa partidas desde .zip** — con la misma seguridad transaccional que las descargas.
- **Actualizador integrado** — comprueba GitHub Releases y descarga la versión nueva por ti.
- **Interfaz estacional** — toda la interfaz sigue la estación del juego: pétalos en primavera, luciérnagas en verano, hojas en otoño, nieve en invierno.

## Descargas

Descarga la última versión desde **[Releases](https://github.com/hirieo/valleysave-app/releases/latest)**:

| Plataforma | Archivo | Notas |
|---|---|---|
| **Windows** | `ValleySave-Setup-*.exe` | Instalador — incluye runtime VC++, 14 idiomas |
| **Windows** (portable) | `ValleySave-*-windows.zip` | Descomprimir y ejecutar |
| **macOS** | `valleysave-macos.zip` | Descomprimir, mover a Aplicaciones |
| **Linux** (Ubuntu/Debian) | `valleysave_*_amd64.deb` | Doble clic para instalar — con icono en el menú |
| **Linux** (portable) | `valleysave-linux-x64.tar.gz` | Extraer y ejecutar, cualquier distro |
| **Android** | `ValleySave-*.apk` | Android 8+ |

> [!NOTE]
> **📱 iOS:** Ya la tengo hecha. Lo que no tengo son los 99 USD/año que Apple pide como peaje de entrada — [ayúdame a pagarlo en Ko-fi](https://ko-fi.com/hirieo) y en cuanto se junte, iOS entra a la fiesta.

## Cómo funciona

1. **Conecta** — vincula tu propia cuenta de Google (OAuth, solo scope `drive.file`).
2. **Detecta** — ValleySave encuentra tus granjas de Stardew Valley automáticamente.
3. **Sincroniza** — sube las granjas a una carpeta `ValleySave/` de tu Drive.
4. **Continúa donde quieras** — instala ValleySave en otro dispositivo, conecta la misma cuenta, descarga y juega.

## Preguntas frecuentes

**¿Stardew Valley tiene guardado en la nube oficial entre PC y móvil?**
No — las partidas de PC y móvil se guardan en local y no existe sincronización oficial entre plataformas. ValleySave la aporta usando tu propio Google Drive.

**¿Están seguras mis partidas?**
Toda operación destructiva es transaccional: tu partida original se respalda y verifica antes de sustituirse, y se restaura automáticamente si algo falla. Los datos corruptos o incompletos se rechazan antes de que puedan pisar una partida buena.

**¿Dónde se guardan mis partidas?**
En una carpeta `ValleySave/` dentro de *tu propio* Google Drive. No existe ningún servidor de ValleySave. La app usa el scope restringido `drive.file`, así que no puede leer nada más de tu Drive.

**¿Puedo mover una granja entre Windows y Android?**
Sí — es el caso de uso principal. También macOS y Linux, en cualquier dirección.

**¿Podemos seguir jugando nuestra granja coop si el anfitrión no está?**
Sí. ValleySave puede transferir el rol de anfitrión a otro jugador (cambio de anfitrión) y compartir la granja por Drive.

## Compilar desde fuente

Requisitos: [Flutter](https://docs.flutter.dev/get-started/install) ≥ 3.12 · Android Studio (para builds de Android)

```bash
git clone https://github.com/hirieo/valleysave-app.git
cd valleysave-app

flutter pub get
cp .env.example .env
# Escritorio: rellena GOOGLE_CLIENT_ID y GOOGLE_CLIENT_SECRET en .env
flutter run
```

Android necesita credenciales propias de Google Cloud (`google-services.json`).

## Errores y contribuciones

- Bugs que afecten a la funcionalidad principal: [abre un issue](https://github.com/hirieo/valleysave-app/issues).
- Los pull requests son bienvenidos — el código está disponible bajo Polyform Noncommercial.

## Licencia

[Polyform Noncommercial 1.0.0](../../LICENSE) — puedes leer el código, aprender de él y contribuir; el uso comercial requiere autorización explícita.

Se distribuye con la esperanza de que sea útil, **sin ninguna garantía**. Úsalo bajo tu propio riesgo.

---

**Repo hermano:** [`valleysave-web`](https://github.com/hirieo/valleysave-web) — landing y presencia web.
