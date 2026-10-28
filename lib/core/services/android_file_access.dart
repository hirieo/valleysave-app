import 'dart:io';

typedef ProcessRunner =
    Future<ProcessResult> Function(String executable, List<String> args);

/// Da permiso de lectura y escritura al grupo sobre [dir] y todo lo que
/// contiene. Shizuku ejecuta como el usuario `shell`, que pertenece al grupo
/// de la carpeta externa pero no es dueño de lo que crea la app, y esos
/// archivos salen con modo 0600: sin esto Shizuku no puede leerlos para
/// copiarlos a la carpeta del juego (`cp: Permission denied`, 2026-10-28,
/// Android 16). `true` si `chmod` terminó bien.
Future<bool> makeGroupAccessible(String dir, {ProcessRunner? run}) async {
  final runner = run ?? (exe, args) => Process.run(exe, args);
  try {
    final result = await runner('chmod', ['-R', 'g+rwX', dir]);
    return result.exitCode == 0;
  } catch (_) {
    return false;
  }
}
