import 'stardew_paths.dart';

/// Lógica PURA (sin E/S) para detectar y explorar carpetas de saves de
/// Android vía shell protegido (Shizuku o root). Los scripts son constantes
/// (sin datos del usuario salvo rutas ya validadas y entrecomilladas) y el
/// parseo de su salida es testeable en escritorio.

/// Candidata detectada: ruta + nº de subcarpetas que contienen `SaveGameInfo`.
class SavesCandidate {
  const SavesCandidate(this.path, this.saveCount);
  final String path;
  final int saveCount;

  @override
  bool operator ==(Object other) =>
      other is SavesCandidate &&
      other.path == path &&
      other.saveCount == saveCount;

  @override
  int get hashCode => Object.hash(path, saveCount);
}

const _pkgSuffix = 'Android/data/com.chucklefish.stardewvalley/files/Saves';

/// Script de detección. Los globs sin coincidencia quedan literales y el
/// `[ -d ]` los descarta. `/data/media` solo es legible con root.
String detectScript({required bool root}) {
  final globs = [
    '/storage/emulated/*/$_pkgSuffix',
    if (root) '/data/media/*/$_pkgSuffix',
  ];
  final buf = StringBuffer();
  for (final g in globs) {
    buf.writeln(
      'for d in $g; do [ -d "\$d" ] || continue; n=0; '
      'for s in "\$d"/*/; do [ -f "\${s}SaveGameInfo" ] && n=\$((n+1)); done; '
      'echo "\$d|\$n"; done',
    );
  }
  return buf.toString();
}

/// Parsea líneas `ruta|n`. Descarta rutas inválidas/duplicadas. Si una
/// `/data/media/N/...` coincide con `/storage/emulated/N/...` (mismo
/// almacenamiento) se queda solo la segunda.
List<SavesCandidate> parseDetectOutput(String output) {
  final found = <SavesCandidate>[];
  final seen = <String>{};
  for (final raw in output.split('\n')) {
    final line = raw.trim();
    final bar = line.lastIndexOf('|');
    if (bar <= 0) continue;
    final path = line.substring(0, bar);
    final n = int.tryParse(line.substring(bar + 1));
    if (n == null || n < 0 || !isValidSavesPath(path)) continue;
    if (!seen.add(path)) continue;
    found.add(SavesCandidate(path, n));
  }
  final media = RegExp(r'^/data/media/(\d+)/(.*)$');
  return found.where((c) {
    final m = media.firstMatch(c.path);
    if (m == null) return true;
    final twin = '/storage/emulated/${m.group(1)}/${m.group(2)}';
    return !seen.contains(twin);
  }).toList();
}

/// Comando de listado del explorador (`ls -1p`: directorios con `/` final).
/// `null` si [dir] no es válido.
String? listDirCommand(String dir, String Function(String) shellQuote) {
  if (!isValidSavesPath(dir)) return null;
  return 'ls -1p ${shellQuote(dir)}';
}

/// De la salida de `ls -1p` devuelve los nombres de subcarpeta SEGUROS,
/// ordenados sin distinguir mayúsculas. Un nombre es seguro si
/// [dir]/nombre pasa [isValidSavesPath] y no es `.`/`..`.
List<String> parseLsDirs(String output, String dir) {
  final base = dir == '/' ? '' : dir;
  final names = <String>{};
  for (final raw in output.split('\n')) {
    var line = raw.replaceAll('\r', '');
    if (!line.endsWith('/')) continue;
    line = line.substring(0, line.length - 1);
    if (line.isEmpty || line == '.' || line == '..' || line.contains('/')) {
      continue;
    }
    if (!isValidSavesPath('$base/$line')) continue;
    names.add(line);
  }
  final list = names.toList()
    ..sort((a, b) => a.toLowerCase().compareTo(b.toLowerCase()));
  return list;
}

/// ¿Parece una carpeta de saves de Stardew por su ruta/nombre?
bool looksLikeSavesFolder(String path) => path.endsWith('/Saves');

/// Carpeta padre (`/a/b` → `/a`, `/a` → `/`, `/` → `/`).
String parentDir(String path) {
  if (path == '/' || path.isEmpty) return '/';
  final trimmed =
      path.endsWith('/') ? path.substring(0, path.length - 1) : path;
  final i = trimmed.lastIndexOf('/');
  return i <= 0 ? '/' : trimmed.substring(0, i);
}

/// Une [dir] y [name] (ambos ya validados).
String childDir(String dir, String name) =>
    dir == '/' ? '/$name' : '$dir/$name';

/// Script de verificación: `NODIR` si no existe, o `COUNT=n`. `null` si
/// [dir] no es válido.
String? verifyScript(String dir, String Function(String) shellQuote) {
  if (!isValidSavesPath(dir)) return null;
  final q = shellQuote(dir);
  return '[ -d $q ] || { echo NODIR; exit 0; }; n=0; '
      'for s in $q/*/; do [ -f "\${s}SaveGameInfo" ] && n=\$((n+1)); done; '
      'echo "COUNT=\$n"';
}

/// `null` = carpeta inexistente / salida ilegible; si no, nº de saves.
int? parseVerifyOutput(String output) {
  if (output.contains('NODIR')) return null;
  final m = RegExp(r'COUNT=(\d+)').firstMatch(output);
  return m == null ? null : int.parse(m.group(1)!);
}
