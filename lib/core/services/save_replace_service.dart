import 'dart:io';

import '../models/backup_entry.dart';
import 'backup_service.dart';
import 'save_service.dart';

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
  SaveReplaceService._();
  static final SaveReplaceService instance = SaveReplaceService._();

  /// `folderName` con una operación en curso — reentrada rechazada (T002).
  final Set<String> _inFlight = {};

  static const _tmpPrefix = '.vs_tmp_';
  static const _rollbackPrefix = '.vs_rollback_';

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
  }) async {
    if (_inFlight.contains(folderName)) return ReplaceResult.busy;
    _inFlight.add(folderName);

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

      // 3) Validar.
      final parsed = SaveService.parseSaveGameInfo(
        await infoFile.readAsString(),
        folderName: folderName,
        lastModified: DateTime.now(),
      );
      if (parsed == null) {
        await _safeDelete(tmpRoot);
        return const ReplaceResult(
          ok: false,
          error: ReplaceError.validationFailed,
        );
      }
      try {
        await mainFile.readAsString();
      } catch (_) {
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

      // 4) Respaldo automático del destino existente.
      final destination = Directory('$savesDir$sep$folderName');
      final destinationExists = await destination.exists();
      BackupEntry? autoBackup;
      if (destinationExists) {
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
        await destination.rename(rollbackDir.path);
      }
      try {
        await stagingDir.rename(destination.path);
      } catch (_) {
        if (rollbackRoot != null) {
          final rollbackDir = Directory(
            '${rollbackRoot.path}$sep$folderName',
          );
          try {
            await rollbackDir.rename(destination.path);
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

      // 6) Limpieza.
      if (rollbackRoot != null) await _safeDelete(rollbackRoot);
      await _safeDelete(tmpRoot);

      return ReplaceResult(ok: true, autoBackup: autoBackup);
    } finally {
      _inFlight.remove(folderName);
    }
  }

  /// Barrido de temporales huérfanas de una sesión anterior (crash, cierre
  /// forzado). Se llama una vez al arrancar la pantalla de saves.
  ///
  /// - `.vs_tmp_*`: siempre seguro borrarlas — el destino nunca dependió de
  ///   ellas (solo se usan para preparar, nunca son ellas mismas el destino).
  /// - `.vs_rollback_*/<folderName>`: estructura anidada (igual que la
  ///   staging — nunca se codifica folderName en el nombre de la carpeta
  ///   temporal, ver [replaceSaveFolder]). Si `<savesDir>/<folderName>` NO
  ///   existe (el segundo rename del swap se completó pero la limpieza no
  ///   llegó, o el original desapareció por otra vía), se restaura moviéndola
  ///   de vuelta. Si SÍ existe (swap completo y limpio salvo por esta carpeta
  ///   sobrante), se conserva como respaldo automático verificado en vez de
  ///   borrarla sin más — nunca se descarta contenido de partida sin pasar
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
          try {
            await saveDir.rename(destination.path);
            await _safeDelete(entity);
          } catch (_) {
            // best-effort: si el rename falla aquí también, se reintenta en
            // el próximo arranque — la carpeta sigue oculta (prefijo `.`) y
            // por tanto invisible en el listado de saves mientras tanto.
          }
        } else {
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
        }
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
