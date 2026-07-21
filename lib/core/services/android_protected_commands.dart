import 'stardew_paths.dart';

/// Construye (sin ejecutar) el script shell que `su -c` correría para
/// publicar un save en la carpeta protegida de Android de forma
/// transaccional: copia a un temporal, respalda el destino existente,
/// sustituye, y revierte automáticamente (`trap ... EXIT`) si algo falla
/// a mitad de camino — mismo patrón preparar→respaldar→sustituir→revertir
/// que [SaveReplaceService] ya usa en escritorio.
///
/// Construir el comando en Dart (en vez de interpolarlo directo en Kotlin
/// o en el shell de Shizuku) permite testear la lógica de fases y el
/// escapado de shell en el escritorio, sin dispositivo root.
///
/// **Activado (2026-07-21)**: `ShizukuService.pushSaveAsRoot`/`pushSave` ya
/// usan este script en vez del `cp -rfp` plano anterior. La construcción del
/// script está testeada (incluida ejecución real en bash contra un
/// directorio temporal, ver `test/android_protected_commands_test.dart`),
/// pero la INTEGRACIÓN con `su`/Shizuku en un dispositivo real sigue SIN
/// verificar — no hay dispositivo rooteado en este entorno de desarrollo.
/// Probar a fondo (push normal, cambio de anfitrión, restaurar backup) antes
/// de confiar en esta vía con saves reales.
class AndroidProtectedCommands {
  AndroidProtectedCommands._();

  /// `null` si [folderName] o [transactionId] no son seguros para
  /// interpolar en shell (traversal, metacaracteres) — el rechazo ocurre
  /// ANTES de construir cualquier comando, nunca llega a interpolarse.
  /// [baseDir] es la carpeta protegida real (`gameSavesPath`) en producción;
  /// solo se sobreescribe en tests, para poder ejecutar el script contra un
  /// directorio temporal real en vez de la ruta de Android.
  static String? replace({
    required String src,
    required String folderName,
    required String transactionId,
    String baseDir = gameSavesPath,
  }) {
    if (!_isSafeName(folderName) || !_isSafeName(transactionId)) return null;

    final dest = '$baseDir/$folderName';
    final tmp = '$baseDir/.vs_tmp_$transactionId';
    final rollback = '$baseDir/.vs_rollback_$transactionId';
    final srcQ = _shellQuote(src);
    final destQ = _shellQuote(dest);
    final tmpQ = _shellQuote(tmp);
    final rollbackQ = _shellQuote(rollback);

    return '''
set -e
swap_done=0
rollback() {
  if [ "\$swap_done" = "1" ]; then
    rm -rf $destQ
  fi
  if [ -d $rollbackQ ]; then
    mv $rollbackQ $destQ
  fi
  rm -rf $tmpQ
}
trap rollback EXIT
echo '{"phase":"preparing"}'
rm -rf $tmpQ
cp -rfp $srcQ $tmpQ
if [ ! -s "$tmp/SaveGameInfo" ]; then exit 1; fi
if [ ! -s "$tmp/$folderName" ]; then exit 1; fi
echo '{"phase":"prepared"}'
rm -rf $rollbackQ
echo '{"phase":"backupVerified"}'
echo '{"phase":"movingOriginal"}'
if [ -d $destQ ]; then mv $destQ $rollbackQ; fi
echo '{"phase":"originalMoved"}'
mv $tmpQ $destQ
swap_done=1
echo '{"phase":"replacementPublished"}'
if [ ! -s "$dest/SaveGameInfo" ]; then exit 1; fi
if [ ! -s "$dest/$folderName" ]; then exit 1; fi
echo '{"phase":"verified"}'
rm -rf $rollbackQ
trap - EXIT
echo '{"phase":"completed"}'
''';
  }

  /// Mismo criterio que `_isSafeSaveName` en `shizuku_service.dart`:
  /// alfanumérico + `_.-`, sin traversal ni metacaracteres de shell.
  static bool _isSafeName(String value) =>
      RegExp(r'^[A-Za-z0-9_.-]{1,160}$').hasMatch(value) &&
      value != '.' &&
      value != '..';

  static String _shellQuote(String value) =>
      "'${value.replaceAll("'", "'\\''")}'";
}
