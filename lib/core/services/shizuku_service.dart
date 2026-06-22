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
    await _api.runCommand('cp -rfp $gameSavesPath/. ${dst.path}/');
    // Verificación robusta vía File API: ¿llegó algo? (no parseamos stdout)
    final empty = await dst.list().isEmpty;
    return empty ? null : dst.path;
  }

  /// Prepara una carpeta vacía `game_out/<folderName>` y devuelve su ruta
  /// para que el caller escriba ahí el save descargado antes de [pushSave].
  Future<String> prepareOut(String folderName) async {
    final parent = await _freshDir('game_out');
    final dir = Directory('${parent.path}/$folderName');
    await dir.create(recursive: true);
    return dir.path;
  }

  /// Empuja `game_out/<folderName>` al juego y verifica que llegó.
  Future<bool> pushSave(String folderName) async {
    final ext = await getExternalStorageDirectory();
    final src = '${ext!.path}/game_out/$folderName';
    await _api.runCommand('cp -rfp $src $gameSavesPath/');
    // Verificación: listar la carpeta destino dentro del juego.
    final check = await _api.runCommand('ls $gameSavesPath/$folderName') ?? '';
    final low = check.toLowerCase();
    return check.trim().isNotEmpty &&
        !low.contains('no such') &&
        !low.contains('denied') &&
        !low.contains('not permitted');
  }
}
