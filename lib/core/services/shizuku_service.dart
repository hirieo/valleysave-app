import 'dart:io';

import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shizuku_api/shizuku_api.dart';

import 'stardew_paths.dart';

/// Acceso a la carpeta protegida `/Android/data` del juego usando Shizuku
/// (ADB sin root). Patrón "puente": el shell de Shizuku solo COPIA entre la
/// carpeta del juego y nuestra propia sandbox accesible; la lectura/escritura
/// real la hace File API normal sobre la copia.
class ShizukuService {
  ShizukuService._();
  static final ShizukuService instance = ShizukuService._();

  final _api = ShizukuApi();
  static const _native = MethodChannel('valleysave/shizuku');

  /// ¿El binder de Shizuku responde? (instalado y en marcha)
  /// Usa el canal nativo con listener fiable; cae a pingBinder si falla.
  Future<bool> isRunning() async {
    try {
      return (await _native.invokeMethod<bool>('isAlive')) ?? false;
    } catch (_) {
      return (await _api.pingBinder()) ?? false;
    }
  }

  /// Abre la app Shizuku directamente (sin diálogo de selección).
  Future<bool> openShizukuApp() async {
    try {
      return (await _native.invokeMethod<bool>('openShizuku')) ?? false;
    } catch (_) {
      return false;
    }
  }

  /// Abre Opciones de desarrollador resaltando "Depuración inalámbrica".
  Future<bool> openWirelessDebug() async {
    try {
      return (await _native.invokeMethod<bool>('openWirelessDebug')) ?? false;
    } catch (_) {
      return false;
    }
  }

  /// Versión del SDK de Android (Build.VERSION.SDK_INT). En otras plataformas → 0.
  Future<int> sdkInt() async {
    try {
      return (await _native.invokeMethod<int>('sdkInt')) ?? 0;
    } catch (_) {
      return 0;
    }
  }

  /// ¿El dispositivo tiene root y lo concede a ValleySave?
  /// Lanza el diálogo de Magisk/SuperSU la primera vez. Timeout 15 s.
  Future<bool> checkRoot() async {
    try {
      return (await _native.invokeMethod<bool>('checkRoot')) ?? false;
    } catch (_) {
      return false;
    }
  }

  /// Copia los saves del juego a una carpeta nuestra legible usando su.
  /// Devuelve la ruta de la copia, o null si falló.
  Future<String?> pullSavesAsRoot() async {
    try {
      final dst = await _freshDir('game_in');
      final ok =
          (await _native.invokeMethod<bool>('pullSavesAsRoot', {'dst': dst.path})) ?? false;
      if (!ok) return null;
      final empty = await dst.list().isEmpty;
      return empty ? null : dst.path;
    } catch (_) {
      return null;
    }
  }

  /// Empuja un save (en [src]) a la carpeta del juego usando su.
  Future<bool> pushSaveAsRoot(String src, String name) async {
    if (!_isSafeSaveName(name)) return false;
    try {
      return (await _native.invokeMethod<bool>(
            'pushSaveAsRoot',
            {'src': src, 'name': name},
          )) ??
          false;
    } catch (_) {
      return false;
    }
  }

  /// Elimina un save de la carpeta del juego usando su.
  Future<bool> deleteLocalAsRoot(String name) async {
    if (!_isSafeSaveName(name)) return false;
    try {
      return (await _native.invokeMethod<bool>('deleteLocalAsRoot', {'name': name})) ?? false;
    } catch (_) {
      return false;
    }
  }

  /// ¿El usuario ya concedió permiso a ValleySave dentro de Shizuku?
  Future<bool> hasPermission() async => (await _api.checkPermission()) ?? false;

  /// Lanza el diálogo de permiso de Shizuku.
  Future<bool> requestPermission() async =>
      (await _api.requestPermission()) ?? false;

  Future<Directory> _freshDir(String sub) async {
    final ext = await getExternalStorageDirectory(); // /Android/data/<pkg>/files
    final dir = Directory('${ext!.path}/$sub');
    if (await dir.exists()) await dir.delete(recursive: true);
    await dir.create(recursive: true);
    return dir;
  }

  /// Copia los saves del juego a una carpeta nuestra legible.
  /// Devuelve su ruta, o null si el juego no tiene saves / falló la copia.
  Future<String?> pullSaves() async {
    final dst = await _freshDir('game_in');
    // -p preserva mtime → la comparación local vs Drive sigue siendo válida.
    // Rutas propias de la app, pero se escapan igual por uniformidad.
    await _api.runCommand('cp -rfp ${_shellQuote('$gameSavesPath/.')} ${_shellQuote('${dst.path}/')}');
    // Verificación robusta vía File API: ¿llegó algo? (no parseamos stdout)
    final empty = await dst.list().isEmpty;
    return empty ? null : dst.path;
  }

  /// Prepara una carpeta vacía `game_out/<folderName>` y devuelve su ruta
  /// para que el caller escriba ahí el save descargado antes de [pushSave].
  Future<String> prepareOut(String folderName) async {
    // El nombre viene de un save de Drive (posiblemente compartido por otra
    // persona) o de un zip importado — un `../` aquí escaparía de la sandbox.
    if (!_isSafeSaveName(folderName)) {
      throw ArgumentError('Nombre de save no seguro: $folderName');
    }
    final parent = await _freshDir('game_out');
    final dir = Directory('${parent.path}/$folderName');
    await dir.create(recursive: true);
    return dir.path;
  }

  /// Empuja `game_out/<folderName>` al juego y verifica que llegó.
  Future<bool> pushSave(String folderName) async {
    if (!_isSafeSaveName(folderName)) return false;
    final ext = await getExternalStorageDirectory();
    final src = '${ext!.path}/game_out/$folderName';
    // El nombre de save (o la ruta que lo contiene) puede llegar de un
    // compartido ajeno / zip importado — se escapa siempre antes de entrar
    // en un shell root, nunca se interpola crudo (defensa contra inyección).
    await _api.runCommand('cp -rfp ${_shellQuote(src)} ${_shellQuote('$gameSavesPath/')}');
    // Verificación: listar la carpeta destino dentro del juego.
    final check =
        await _api.runCommand('ls ${_shellQuote('$gameSavesPath/$folderName')}') ?? '';
    final low = check.toLowerCase();
    return check.trim().isNotEmpty &&
        !low.contains('no such') &&
        !low.contains('denied') &&
        !low.contains('not permitted');
  }
}

/// Nombres de save aceptados en cualquier comando shell root — mismo criterio
/// que el formato real de Stardew (`<Nombre>_<uniqueID>`, alfanumérico +
/// `_.-`). Rechaza traversal (`.`/`..`, `/`) y metacaracteres de shell antes
/// de que lleguen a `su` (integrado de la implementación paralela de Codex,
/// 2026-07-18 — nuestro código anterior los interpolaba crudos). Android-only,
/// no ejercitado por la suite de escritorio.
bool _isSafeSaveName(String value) =>
    RegExp(r'^[A-Za-z0-9_.-]{1,160}$').hasMatch(value) &&
    value != '.' &&
    value != '..';

/// Envuelve un valor en comillas simples POSIX escapando las comillas simples
/// internas (`'` → `'\''`) — hace inofensivo cualquier metacarácter dentro de
/// un comando shell, sin rechazar nombres legítimos.
String _shellQuote(String value) => "'${_shellLiteral(value)}'";
String _shellLiteral(String value) => value.replaceAll("'", "'\\''");
