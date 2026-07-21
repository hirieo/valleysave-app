import 'dart:io';
import 'dart:math';

import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shizuku_api/shizuku_api.dart';

import 'android_protected_commands.dart';
import 'stardew_paths.dart';

final _rng = Random();

/// ID corto para nombrar los temporales de una transacción (`.vs_tmp_<id>`,
/// `.vs_rollback_<id>`) — no necesita ser criptográficamente único, solo no
/// colisionar entre operaciones concurrentes sobre el mismo save, algo que
/// la UI ya evita (estado `_busy` en `saves_screen.dart`). Se evita añadir
/// el paquete `uuid` como dependencia directa por esto (solo es transitiva
/// hoy) para algo que no lo necesita.
String _newTransactionId() =>
    '${DateTime.now().microsecondsSinceEpoch.toRadixString(36)}'
    '${_rng.nextInt(0xFFFFFF).toRadixString(36)}';

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

  /// Empuja un save (en [src]) a la carpeta del juego usando su, de forma
  /// transaccional (preparar→respaldar→sustituir→verificar→revertir ante
  /// cualquier fallo — mismo patrón que [SaveReplaceService] en escritorio).
  /// Antes hacía un `cp -rfp` plano en Kotlin: si el proceso moría a mitad
  /// de la copia, el destino quedaba a medias sin ninguna forma de saberlo
  /// ni de recuperar la versión anterior (2026-07-21, activación de
  /// [AndroidProtectedCommands] — construido y testeado desde 2026-07-19,
  /// pero SIN verificar hasta ahora en un dispositivo rooteado real).
  Future<bool> pushSaveAsRoot(String src, String name) async {
    if (!_isSafeSaveName(name)) return false;
    final script = AndroidProtectedCommands.replace(
      src: src,
      folderName: name,
      transactionId: _newTransactionId(),
    );
    if (script == null) return false;
    try {
      return (await _native.invokeMethod<bool>(
            'runProtectedScriptAsRoot',
            {'script': script},
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

  /// Empuja `game_out/<folderName>` al juego de forma transaccional (mismo
  /// motivo y patrón que [pushSaveAsRoot] — antes un `cp -rfp` plano sin
  /// respaldo ni rollback; 2026-07-21, SIN verificar en dispositivo real).
  /// Shizuku ejecuta el script a través de su propio shell (`_api.runCommand`,
  /// ya probado con comandos compuestos en [pullSaves]/[pushSave] anteriores),
  /// no requiere el canal nativo `su` que usa la vía root.
  Future<bool> pushSave(String folderName) async {
    if (!_isSafeSaveName(folderName)) return false;
    final ext = await getExternalStorageDirectory();
    final src = '${ext!.path}/game_out/$folderName';
    final script = AndroidProtectedCommands.replace(
      src: src,
      folderName: folderName,
      transactionId: _newTransactionId(),
    );
    if (script == null) return false;
    final output = await _api.runCommand(script) ?? '';
    return output.contains('"phase":"completed"');
  }

  /// Borra un save de la carpeta PROTEGIDA del juego vía Shizuku (sin root).
  ///
  /// Necesario porque en modo Shizuku `entry.local.folderPath` apunta a la
  /// copia puente (`pullSaves()`), nunca a la carpeta real del juego — borrar
  /// esa copia no borra nada de verdad, y en la siguiente carga [pullSaves]
  /// la vuelve a copiar desde el juego, haciendo que la partida "reaparezca"
  /// (2026-07-21, bug real: el borrado unificado solo tenía rama especial
  /// para root — `deleteLocalAsRoot` — y en Shizuku caía al borrado genérico
  /// de `folderPath`, que en este modo es justo la copia puente).
  Future<bool> deleteLocalViaShizuku(String folderName) async {
    if (!_isSafeSaveName(folderName)) return false;
    final path = '$gameSavesPath/$folderName';
    await _api.runCommand('rm -rf ${_shellQuote(path)}');
    // Verificación: tras un borrado real, listar esa ruta debe fallar.
    final check = await _api.runCommand('ls -d ${_shellQuote(path)}') ?? '';
    return check.toLowerCase().contains('no such') || check.trim().isEmpty;
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
