import 'dart:io';

import 'package:meta/meta.dart';

import '../models/backup_entry.dart';
import 'backup_service.dart';
import 'save_service.dart';

Future<void> _systemRename(Directory src, String destinationPath) =>
    src.rename(destinationPath).then((_) {});

/// Motivo por el que [SaveReplaceService.replaceSaveFolder] no pudo
/// completarse. En todos los casos salvo [busy] el destino queda intacto —
/// ver contrato de [SaveReplaceService.replaceSaveFolder].
enum ReplaceError {
  /// [prepare] lanzó una excepción o no dejó los archivos mínimos.
  prepareFailed,

  /// El contenido preparado no pasa la validación (XML no parseable, falta
  /// el archivo principal, nombre incoherente).
  validationFailed,

  /// El respaldo automático del destino existente no pudo crearse o
  /// verificarse — no hay sustitución sin respaldo (constitución I).
  backupFailed,

  /// Falló el swap final (rename). Si esto ocurre DESPUÉS de mover el
  /// original a rollback, el servicio ya lo restauró — el caller solo ve
  /// este error, nunca un estado a medias.
  swapFailed,

  /// El swap terminó pero el destino recién publicado NO es un save
  /// cargable (corrupción a nivel de filesystem durante el rename, muy
  /// rara). El servicio ya revirtió al original desde el rollback — el
  /// caller nunca ve un save a medias (integrado de la implementación
  /// paralela de Codex, 2026-07-18).
  postValidationFailed,

  /// Ya hay una operación en curso sobre el mismo `folderName`.
  busy,
}

/// Resultado de [SaveReplaceService.replaceSaveFolder].
class ReplaceResult {
  const ReplaceResult({required this.ok, this.error, this.autoBackup});

  final bool ok;
  final ReplaceError? error;

  /// Respaldo automático del contenido previo del destino — presente solo si
  /// `ok` y el destino ya existía antes de la operación.
  final BackupEntry? autoBackup;

  static const ReplaceResult busy = ReplaceResult(
    ok: false,
    error: ReplaceError.busy,
  );
}

/// Sustituye de forma transaccional el contenido de una carpeta de save.
///
/// Único punto del código que reemplaza una carpeta de save viva. Usado por
/// descarga, importación y restauración de backups (spec
/// 001-integridad-transaccional-saves) — antes cada uno tenía su propio
/// camino, ninguno con respaldo ni rollback real.
///
/// El patrón es el mismo que ya prueba `HostSwapService.execute` en
/// producción: preparar en una carpeta HERMANA del destino (nunca
/// `Directory.systemTemp` — un rename entre filesystems distintos falla,
/// lección de host swap en Android, commit `9f976b5`) → validar → respaldar
/// el original si existe → swap por doble rename con reversión si el
/// segundo falla → limpiar.
class SaveReplaceService {
  SaveReplaceService._(this._renameDirectory);
  static final SaveReplaceService instance = SaveReplaceService._(
    _systemRename,
  );

  /// Construye una instancia AISLADA (su propio `_inFlight`, nunca la
  /// compartida por producción) con el rename del swap sustituido — permite
  /// forzar de forma determinista y multiplataforma el punto exacto en el
  /// que falla el segundo rename, sin la técnica `chmod` (POSIX-only, no
  /// funciona en Windows). Solo para tests (integrado de la implementación
  /// paralela de Codex, 2026-07-18 — antes ese camino de rollback no tenía
  /// ninguna cobertura en Windows).
  @visibleForTesting
  factory SaveReplaceService.withRename(
    Future<void> Function(Directory src, String destinationPath) rename,
  ) => SaveReplaceService._(rename);

  /// `<savesDir absoluto>/<folderName>` con una operación en curso —
  /// reentrada rechazada (T002). Clave por ruta completa, no solo
  /// `folderName` (ver [replaceSaveFolder]).
  final Set<String> _inFlight = {};

  final Future<void> Function(Directory src, String destinationPath)
  _renameDirectory;

  static const _tmpPrefix = '.vs_tmp_';
  static const _rollbackPrefix = '.vs_rollback_';
  static const _invalidPrefix = '.vs_invalid_';

  /// Sustituye `<savesDir>/<folderName>` por lo que escriba [prepare] en el
  /// directorio de staging que se le pasa.
  ///
  /// Contrato:
  /// 1. Crea `<savesDir>/.vs_tmp_<uuid>/<folderName>` (hermana del destino,
  ///    mismo filesystem).
  /// 2. Invoca `prepare(stagingDir)`. Si lanza, o si al volver no existen
  ///    `SaveGameInfo` + `<folderName>` dentro de `stagingDir` → aborta con
  ///    [ReplaceError.prepareFailed], limpia la temporal, destino intacto.
  /// 3. Valida el contenido preparado ([ReplaceError.validationFailed] si
  ///    falla) — y [validate] adicional si el caller lo pasa.
  /// 4. Si el destino ya existe: crea un respaldo automático (zip vía
  ///    [BackupService]) y lo verifica. Si falla, aborta
  ///    ([ReplaceError.backupFailed]), destino intacto.
  /// 5. Swap: si el destino existe, rename destino → `.vs_rollback_<uuid>`;
  ///    rename staging → destino. Si el segundo rename falla, revierte el
  ///    primero antes de devolver [ReplaceError.swapFailed] — el destino
  ///    NUNCA queda sin carpeta válida.
  /// 6. Limpia rollback y temporal.
  Future<ReplaceResult> replaceSaveFolder({
    required String savesDir,
    required String folderName,
    required Future<void> Function(Directory stagingDir) prepare,
    Future<bool> Function(Directory stagingDir)? validate,
    required String backupsDir,
    String? preverifiedBackupPath,
  }) async {
    // Clave por RUTA ABSOLUTA, no solo `folderName` — dos partidas con el
    // mismo nombre en raíces `savesDir` distintas (p. ej. dos discos, o un
    // futuro caso con más de una raíz activa por proceso) son operaciones
    // independientes y no deben bloquearse entre sí (hallazgo de Codex,
    // 2026-07-18 — antes esto era un supuesto implícito, nunca garantizado).
    final targetKey =
        '${Directory(savesDir).absolute.path}${Platform.pathSeparator}$folderName';
    if (_inFlight.contains(targetKey)) return ReplaceResult.busy;
    _inFlight.add(targetKey);

    final sep = Platform.pathSeparator;
    Directory? tmpRoot;
    try {
      await Directory(savesDir).create(recursive: true);

      // 1) Staging hermana del destino.
      tmpRoot = await Directory(savesDir).createTemp(_tmpPrefix);
      final stagingDir = Directory('${tmpRoot.path}$sep$folderName');
      await stagingDir.create(recursive: true);

      // 2) Preparar.
      try {
        await prepare(stagingDir);
      } catch (_) {
        await _safeDelete(tmpRoot);
        return const ReplaceResult(ok: false, error: ReplaceError.prepareFailed);
      }

      final mainFile = File('${stagingDir.path}$sep$folderName');
      final infoFile = File('${stagingDir.path}${sep}SaveGameInfo');
      if (!await mainFile.exists() || !await infoFile.exists()) {
        await _safeDelete(tmpRoot);
        return const ReplaceResult(ok: false, error: ReplaceError.prepareFailed);
      }

      // 3) Validar el contenido preparado (XML parseable, archivo principal
      //    no vacío, `_old` coherentes) más el [validate] opcional del caller.
      if (!await _isValidSaveDir(stagingDir, folderName)) {
        await _safeDelete(tmpRoot);
        return const ReplaceResult(
          ok: false,
          error: ReplaceError.validationFailed,
        );
      }
      if (validate != null && !await validate(stagingDir)) {
        await _safeDelete(tmpRoot);
        return const ReplaceResult(
          ok: false,
          error: ReplaceError.validationFailed,
        );
      }

      // 4) Respaldo del destino existente. Si el caller ya trae un respaldo
      //    verificado ([preverifiedBackupPath] — p. ej. el zip `_pre-swap_`
      //    permanente de `HostSwapService`), se reutiliza tal cual y NO se
      //    crea un auto-backup: así ese respaldo del caller conserva su
      //    propio nombre/permanencia y nunca lo poda la retención automática
      //    (integrado de Codex, 2026-07-18).
      final destination = Directory('$savesDir$sep$folderName');
      final destinationExists = await destination.exists();
      BackupEntry? autoBackup;
      if (destinationExists && preverifiedBackupPath == null) {
        try {
          autoBackup = await BackupService().createBackup(
            saveFolderPath: destination.path,
            folderName: folderName,
            backupsDir: backupsDir,
            origin: BackupOrigin.auto,
          );
          final verified = await verifyBackupZipContents(
            autoBackup.localPath!,
            folderName,
          );
          if (!verified) {
            await BackupService().deleteLocalBackup(autoBackup.localPath!);
            await _safeDelete(tmpRoot);
            return const ReplaceResult(
              ok: false,
              error: ReplaceError.backupFailed,
            );
          }
          await BackupService().enforceAutoRetention(backupsDir, folderName);
        } catch (_) {
          await _safeDelete(tmpRoot);
          return const ReplaceResult(
            ok: false,
            error: ReplaceError.backupFailed,
          );
        }
      }

      // 5) Swap con doble rename y reversión. El rollback usa la MISMA
      // estructura anidada que la staging (`.vs_rollback_<uuid>/<folderName>`)
      // — nunca se codifica folderName en el nombre de la carpeta temporal:
      // los nombres de save de Stardew ya contienen `_` (p. ej.
      // `Pleyades_395187544`), así que intentar recuperar folderName
      // recortando el sufijo aleatorio de `createTemp` sería ambiguo.
      // Anidar evita ese parseo por completo — sweepOrphans solo mira el
      // único hijo que hay dentro.
      Directory? rollbackRoot;
      if (destinationExists) {
        rollbackRoot = await Directory(savesDir).createTemp(_rollbackPrefix);
        final rollbackDir = Directory('${rollbackRoot.path}$sep$folderName');
        await _renameDirectory(destination, rollbackDir.path);
      }
      try {
        await _renameDirectory(stagingDir, destination.path);
      } catch (_) {
        if (rollbackRoot != null) {
          final rollbackDir = Directory(
            '${rollbackRoot.path}$sep$folderName',
          );
          try {
            await _renameDirectory(rollbackDir, destination.path);
            await _safeDelete(rollbackRoot);
          } catch (_) {
            // El original queda en rollbackRoot — sweepOrphans lo recupera
            // en el próximo arranque. No hay forma más segura de
            // reportarlo aquí sin arriesgar perder el mensaje de error real.
          }
        }
        await _safeDelete(tmpRoot);
        return const ReplaceResult(ok: false, error: ReplaceError.swapFailed);
      }

      // 5b) Validación post-swap: el destino recién publicado debe seguir
      //     siendo un save cargable, y volver a pasar el [validate] del
      //     caller (que puede detectar algo que solo se manifiesta ya en el
      //     sitio final). Si algo falla, se revierte desde el rollback — el
      //     original nunca se pierde (integrado de Codex, 2026-07-18).
      if (!await _isValidSaveDir(destination, folderName) ||
          (validate != null && !await validate(destination))) {
        await _safeDelete(destination);
        if (rollbackRoot != null) {
          final rollbackDir = Directory('${rollbackRoot.path}$sep$folderName');
          try {
            await _renameDirectory(rollbackDir, destination.path);
            // Solo se borra el rollback DESPUÉS de que la restauración tuvo
            // éxito — nunca antes. Si el rename falla, el original SIGUE en
            // rollbackRoot y se conserva para que `sweepOrphans` lo restaure
            // en el próximo arranque. Borrarlo incondicionalmente aquí
            // destruiría la última copia válida (bug crítico de pérdida de
            // datos detectado por Codex, 2026-07-18 — el camino `swapFailed`
            // de arriba ya lo hacía bien, este 5b se había quedado atrás).
            await _safeDelete(rollbackRoot);
          } catch (_) {
            // El original queda intacto en rollbackRoot — NO se toca.
          }
        }
        await _safeDelete(tmpRoot);
        return const ReplaceResult(
          ok: false,
          error: ReplaceError.postValidationFailed,
        );
      }

      // 6) Limpieza.
      if (rollbackRoot != null) await _safeDelete(rollbackRoot);
      await _safeDelete(tmpRoot);

      return ReplaceResult(ok: true, autoBackup: autoBackup);
    } finally {
      _inFlight.remove(targetKey);
    }
  }

  /// Un directorio es un save cargable si tiene `SaveGameInfo` (XML
  /// parseable) y el archivo principal existe y NO está vacío. El rechazo de
  /// 0 bytes se integró de la implementación paralela de Codex (2026-07-18):
  /// antes un archivo principal truncado a 0 bytes que "existía" pasaba la
  /// validación.
  ///
  /// A DIFERENCIA de Codex, NO se valida el contenido de los `_old`: son la
  /// red de seguridad del propio juego (la versión anterior del save), no
  /// archivos esenciales. Rechazar un save principal perfectamente válido
  /// porque su `_old` compañero esté corrupto castigaría al usuario por un
  /// archivo secundario que ni siquiera bloquea la carga del juego. Se
  /// descargan/copian tal cual (whitelist), pero no deciden la validez.
  ///
  /// Compartido por la validación previa al swap (paso 3) y la posterior
  /// (paso 5b).
  Future<bool> _isValidSaveDir(Directory dir, String folderName) async {
    final sep = Platform.pathSeparator;
    final info = File('${dir.path}${sep}SaveGameInfo');
    final main = File('${dir.path}$sep$folderName');
    if (!await info.exists() || !await main.exists()) return false;
    if (await main.length() == 0) return false;
    return SaveService.parseSaveGameInfo(
          await info.readAsString(),
          folderName: folderName,
          lastModified: DateTime.now(),
        ) !=
        null;
  }

  /// Barrido de temporales huérfanas de una sesión anterior (crash, cierre
  /// forzado). Se llama una vez al arrancar la pantalla de saves.
  ///
  /// - `.vs_tmp_*`: siempre seguro borrarlas — el destino nunca dependió de
  ///   ellas (solo se usan para preparar, nunca son ellas mismas el destino).
  /// - `.vs_rollback_*/<folderName>`: estructura anidada (igual que la
  ///   staging — nunca se codifica folderName en el nombre de la carpeta
  ///   temporal, ver [replaceSaveFolder]). La decisión NO se basa solo en si
  ///   `<savesDir>/<folderName>` existe, sino en si es un save VÁLIDO
  ///   (hallazgo cruzado con Codex, 2026-07-18 — antes "destino existe" se
  ///   trataba como "destino bueno", perdiendo un rollback sano si el
  ///   proceso moría justo tras el segundo rename pero antes de validar):
  ///   destino ausente → se restaura el rollback tal cual, sea válido o no
  ///   (es la única copia); destino válido → se conserva, el rollback se
  ///   archiva como respaldo automático verificado; destino inválido con
  ///   rollback válido → el destino roto se aparta a `.vs_invalid_<uuid>/`
  ///   (nunca se borra sin más) y el rollback lo sustituye; si ninguno de
  ///   los dos demuestra ser válido, no se toca nada — queda para inspección
  ///   manual. Nunca se descarta contenido de partida sin pasar
  ///   antes por el gestor de respaldos.
  Future<void> sweepOrphans(String savesDir, {required String backupsDir}) async {
    final dir = Directory(savesDir);
    if (!await dir.exists()) return;
    final sep = Platform.pathSeparator;

    await for (final entity in dir.list(recursive: false)) {
      if (entity is! Directory) continue;
      final name = entity.path.split(sep).last;

      if (name.startsWith(_tmpPrefix)) {
        await _safeDelete(entity);
        continue;
      }

      if (name.startsWith(_rollbackPrefix)) {
        final children = await entity.list(recursive: false).toList();
        final saveDir = children.whereType<Directory>().firstOrNull;
        if (saveDir == null) {
          await _safeDelete(entity);
          continue;
        }
        final folderName = saveDir.path.split(sep).last;
        final destination = Directory('$savesDir$sep$folderName');

        if (!await destination.exists()) {
          // Destino ausente, rollback presente → restaurarlo, sea válido o
          // no: es la única copia que hay, y `sweepOrphans` nunca decide
          // "descartar la única copia" — eso lo haría invisible al listado
          // de saves sin pasar por el gestor de respaldos.
          try {
            await saveDir.rename(destination.path);
            await _safeDelete(entity);
          } catch (_) {
            // best-effort: si el rename falla aquí también, se reintenta en
            // el próximo arranque — la carpeta sigue oculta (prefijo `.`) y
            // por tanto invisible en el listado de saves mientras tanto.
          }
          continue;
        }

        // Destino presente: antes de decidir su destino hay que saber si es
        // CARGABLE, no solo si existe — un crash justo después del segundo
        // rename pero antes de la validación post-swap puede dejar un
        // destino corrupto con un rollback perfectamente válido al lado.
        // Tratar "destino existe" como "destino bueno" perdería ese rollback
        // (hallazgo cruzado con la implementación paralela de Codex,
        // 2026-07-18 — el mismo patrón de bug que arregló en su propia
        // recuperación, aquí en `sweepOrphans` en vez de en `replaceSaveFolder`).
        if (await _isValidSaveDir(destination, folderName)) {
          // Destino válido + rollback (sea cual sea su estado): el destino
          // manda, el rollback se archiva como respaldo automático — nunca
          // se borra sin verificar que el zip resultante es un save real.
          try {
            final zip = await BackupService().createBackup(
              saveFolderPath: saveDir.path,
              folderName: folderName,
              backupsDir: backupsDir,
              origin: BackupOrigin.auto,
            );
            if (await verifyBackupZipContents(zip.localPath!, folderName)) {
              await _safeDelete(entity);
            }
          } catch (_) {
            // best-effort: se reintenta en el próximo arranque.
          }
          continue;
        }

        // Destino INVÁLIDO. Si el rollback SÍ es válido, es la única copia
        // cargable — sustituye al destino roto. El destino roto no se borra
        // directamente: se aparta a cuarentena (oculta, nunca se limpia
        // sola) para no destruir evidencia ni contenido potencialmente
        // recuperable a mano.
        if (await _isValidSaveDir(saveDir, folderName)) {
          final quarantineRoot = await Directory(
            savesDir,
          ).createTemp(_invalidPrefix);
          try {
            await destination.rename(
              '${quarantineRoot.path}$sep$folderName',
            );
            await saveDir.rename(destination.path);
            await _safeDelete(entity);
          } catch (_) {
            // best-effort: si algo falla a mitad, el próximo arranque vuelve
            // a intentarlo — ninguna de las dos copias se pierde porque
            // ninguna se borra hasta que el rename de sustitución confirma.
          }
          continue;
        }

        // Ni el destino ni el rollback demuestran ser una copia válida y
        // recuperable — no hay base para decidir cuál conservar. Se deja
        // todo tal cual para inspección manual: ningún rollback se elimina
        // sin demostrar que hay otra copia válida o que quedó archivado en
        // un backup verificado (regla acordada con Codex, 2026-07-18).
      }
    }
  }
}

Future<void> _safeDelete(Directory dir) async {
  try {
    if (await dir.exists()) await dir.delete(recursive: true);
  } catch (_) {
    // best-effort
  }
}
