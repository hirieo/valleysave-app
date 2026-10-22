import 'dart:convert';
import 'dart:io';

import 'package:shared_preferences/shared_preferences.dart';

import 'game_launch_service.dart';
import 'stardew_paths.dart';

/// SMAPI encontrado en una carpeta del juego (spec 010, research §1).
class SmapiInstall {
  const SmapiInstall({
    required this.gameDir,
    required this.modsDir,
    this.version,
  });

  final String gameDir;
  final String modsDir;

  /// Versión de SMAPI, leída del mod `ConsoleCommands` que el instalador
  /// pone siempre. `null` si el usuario lo borró: SMAPI sigue detectado.
  final String? version;
}

/// Detección de SMAPI en escritorio y rutas configurables de la sección
/// SMAPI. Nunca instala ni modifica SMAPI (spec 010 D5).
class SmapiService {
  SmapiService._();
  static final instance = SmapiService._();

  /// Ruta de `Mods` elegida a mano (`--mods-path`/`SMAPI_MODS_PATH` no se
  /// pueden detectar, D2).
  static const modsPathPrefKey = 'smapi_mods_path';

  /// El usuario activó la pestaña SMAPI aunque no se detecte SMAPI.
  static const sectionEnabledPrefKey = 'smapi_section_enabled';

  static final _versionRe = RegExp(r'"Version"\s*:\s*"([^"\r\n]{1,64})"');

  SmapiInstall? _install;
  bool _sectionEnabled = false;

  SmapiInstall? get install => _install;

  /// ¿Se muestra la pestaña SMAPI? Detectado, o activado a mano.
  bool get sectionVisible => _install != null || _sectionEnabled;

  /// Detecta SMAPI junto al ejecutable del juego que ya resuelve
  /// [GameLaunchService]. En Android no hace nada (fase F5).
  Future<void> init() async {
    if (!Platform.isWindows && !Platform.isLinux && !Platform.isMacOS) return;
    final prefs = await SharedPreferences.getInstance();
    _sectionEnabled = prefs.getBool(sectionEnabledPrefKey) ?? false;
    final modsOverride = prefs.getString(modsPathPrefKey);

    await GameLaunchService.instance.init();
    final exe = GameLaunchService.instance.resolvedExePath;
    _install = exe == null
        ? null
        : await detectIn(
            File(exe).parent.path,
            modsDirOverride: isValidLocalPath(modsOverride)
                ? modsOverride
                : null,
          );
  }

  Future<void> setSectionEnabled(bool enabled) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(sectionEnabledPrefKey, enabled);
    _sectionEnabled = enabled;
  }

  /// Guarda una ruta de `Mods` elegida a mano. `false` si no es válida.
  Future<bool> setModsPath(String path) async {
    if (!isValidLocalPath(path)) return false;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(modsPathPrefKey, path);
    await init();
    return true;
  }

  Future<void> resetModsPath() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(modsPathPrefKey);
    await init();
  }

  /// ¿Hay SMAPI en [gameDir]? Lo instala siempre con `StardewModdingAPI.dll`
  /// y `smapi-internal/` en todas las plataformas.
  static Future<SmapiInstall?> detectIn(
    String gameDir, {
    String? modsDirOverride,
  }) async {
    final sep = Platform.pathSeparator;
    final dll = File('$gameDir${sep}StardewModdingAPI.dll');
    final internal = Directory('$gameDir${sep}smapi-internal');
    if (!await dll.exists() || !await internal.exists()) return null;

    final modsDir = modsDirOverride ?? '$gameDir${sep}Mods';
    String? version;
    try {
      final manifest = File(
        '$modsDir${sep}ConsoleCommands${sep}manifest.json',
      );
      if (await manifest.exists()) {
        version = parseManifestVersion(
          utf8.decode(await manifest.readAsBytes(), allowMalformed: true),
        );
      }
    } on FileSystemException {
      version = null;
    }
    return SmapiInstall(gameDir: gameDir, modsDir: modsDir, version: version);
  }

  /// Campo `Version` de un `manifest.json`. Los manifiestos de mods admiten
  /// comentarios y comas finales, así que no se usa `jsonDecode`.
  static String? parseManifestVersion(String manifest) =>
      _versionRe.firstMatch(manifest)?.group(1)?.trim();

  /// Abre el juego con SMAPI (fase F2). Su consola queda abierta: es la que
  /// muestra qué mods cargó.
  Future<void> launch(SmapiInstall install) async {
    final exe = launcherPath(install.gameDir);
    if (!await File(exe).exists()) {
      throw StateError('SMAPI launcher not found');
    }
    await Process.start(
      exe,
      [],
      workingDirectory: install.gameDir,
      mode: ProcessStartMode.detached,
    );
  }

  /// Ejecutable de SMAPI dentro de [gameDir] (fase F2: "Abrir con SMAPI").
  static String launcherPath(String gameDir) {
    final sep = Platform.pathSeparator;
    return Platform.isWindows
        ? '$gameDir${sep}StardewModdingAPI.exe'
        : '$gameDir${sep}StardewModdingAPI';
  }

  /// Mismas garantías que [isValidSavesPath] en Unix; en Windows, ruta
  /// absoluta con unidad y sin segmentos `..`.
  static bool isValidLocalPath(String? path) {
    if (path == null || path.isEmpty || path.length > 512) return false;
    if (path.contains('\u0000') || path.contains('\n')) return false;
    if (Platform.isWindows) {
      if (!RegExp(r'^[A-Za-z]:\\').hasMatch(path)) return false;
      return !path.split(RegExp(r'[\\/]')).contains('..');
    }
    return isValidSavesPath(path);
  }
}
