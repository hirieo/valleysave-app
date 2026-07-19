import 'stardew_paths.dart';

/// Construye (sin ejecutar) el script shell que `su -c` correría para
/// publicar un save en la carpeta protegida de Android de forma
/// transaccional: copia a un temporal, respalda el destino existente,
/// sustituye, y revierte automáticamente (`trap ... EXIT`) si algo falla
/// a mitad de camino — mismo patrón preparar→respaldar→sustituir→revertir
/// que [SaveReplaceService] ya usa en escritorio.
///
/// Construir el comando en Dart (en vez de interpolarlo directo en Kotlin,
/// como hace hoy `pushSaveAsRoot`) permite testear la lógica de fases y el
/// escapado de shell en el escritorio, sin dispositivo root.
///
/// **NO está activado**: `ShizukuService.pushSaveAsRoot` sigue usando el
/// `cp -rfp` plano existente. Este builder queda como candidato hasta poder
/// verificarse en un dispositivo rooteado real (ninguna de las dos
/// implementaciones —esta ni la de la implementación paralela de Codex—
/// se ha probado en un dispositivo físico todavía).
class AndroidProtectedCommands {
  AndroidProtectedCommands._();

  /// `null` si [folderName] o [transactionId] no son seguros para
  /// interpolar en shell (traversal, metacaracteres) — el rechazo ocurre
  /// ANTES de construir cualquier comando, nunca llega a interpolarse.
  static String? replace({
    required String src,
    required String folderName,
    required String transactionId,
  }) {
    if (!_isSafeName(folderName) || !_isSafeName(transactionId)) return null;

    final dest = '$gameSavesPath/$folderName';
    final tmp = '$gameSavesPath/.vs_tmp_$transactionId';
    final rollback = '$gameSavesPath/.vs_rollback_$transactionId';
    final srcQ = _shellQuote(src);
    final destQ = _shellQuote(dest);
    final tmpQ = _shellQuote(tmp);
    final rollbackQ = _shellQuote(rollback);

    return '''
set -e
rollback() {
  if [ -d $rollbackQ ]; then
    rm -rf $destQ
    mv $rollbackQ $destQ
  fi
  rm -rf $tmpQ
}
trap rollback EXIT
echo '{"phase":"preparing"}'
rm -rf $tmpQ
cp -rfp $srcQ $tmpQ
if [ ! -s "$tmp/SaveGameInfo" ]; then exit 1; fi
echo '{"phase":"prepared"}'
rm -rf $rollbackQ
if [ -d $destQ ]; then mv $destQ $rollbackQ; fi
echo '{"phase":"backupVerified"}'
echo '{"phase":"movingOriginal"}'
mv $tmpQ $destQ
echo '{"phase":"originalMoved"}'
echo '{"phase":"replacementPublished"}'
if [ ! -s "$dest/SaveGameInfo" ]; then exit 1; fi
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
