import 'dart:io';

import 'package:archive/archive.dart';

import 'host_swap_service.dart' show copyDirectory;
import 'save_replace_service.dart';
import 'save_service.dart';

/// Motivo por el que `importSave` no pudo completarse.
enum ImportError {
  invalidZip,
  unsafePath,
  tooLarge,
  notASave,
  writeFailure,
  backupFailed,
}

ImportError _mapReplaceError(ReplaceError? error) => switch (error) {
  ReplaceError.prepareFailed || ReplaceError.validationFailed =>
    ImportError.notASave,
  ReplaceError.backupFailed => ImportError.backupFailed,
  ReplaceError.swapFailed ||
  ReplaceError.postValidationFailed ||
  ReplaceError.busy ||
  null =>
    ImportError.writeFailure,
};

/// Resultado de [TransferService.importSave].
class ImportResult {
  const ImportResult({
    required this.ok,
    this.error,
    this.conflict = false,
    this.importedFolderName,
  });

  final bool ok;
  final ImportError? error;

  /// `true` si el nombre de carpeta ya existe localmente — la UI debe
  /// preguntar sobrescribir/cancelar ANTES de volver a llamar con
  /// `overwrite: true`.
  final bool conflict;

  /// Nombre final de la carpeta importada, presente si `ok` o `conflict`.
  final String? importedFolderName;
}

/// Límite de tamaño total descomprimido y nº de archivos, comprobados ANTES
/// de escribir nada en disco (zip bomb / zip-slip — ver research.md D3).
const _kMaxUncompressedBytes = 500 * 1024 * 1024;
const _kMaxEntryCount = 2000;

/// Exportar/importar saves como zip transportable — mismo pipeline para un
/// zip generado por [exportSave] que para uno descargado de Drive (D5).
///
/// Puerto del mismo estilo que `host_swap_service.dart`: Dart puro, sin
/// imports de Flutter, `_safeDelete` best-effort en cualquier fallo tras
/// crear un directorio temporal.
class TransferService {
  /// Zipea [folderPath] completo (todos sus archivos, sin filtrar) con
  /// [folderName] como carpeta raíz del zip — mismo formato que entrega
  /// Drive al descargar una carpeta, para que [importSave] use un solo
  /// pipeline sin importar el origen. Nunca modifica el original.
  Future<File> exportSave(String folderPath, String folderName) async {
    final sourceDir = Directory(folderPath);
    final archive = Archive();
    await for (final entity in sourceDir.list(recursive: false)) {
      if (entity is! File) continue;
      final name = entity.uri.pathSegments.last;
      final bytes = await entity.readAsBytes();
      archive.addFile(ArchiveFile.bytes('$folderName/$name', bytes));
    }

    final zipBytes = ZipEncoder().encodeBytes(archive);
    final outDir = await Directory.systemTemp.createTemp('vs_export_');
    final outFile = File('${outDir.path}${Platform.pathSeparator}$folderName.zip');
    await outFile.writeAsBytes(zipBytes);
    return outFile;
  }

  /// [overwrite] solo se pasa `true` en la segunda llamada, tras confirmar
  /// el diálogo de conflicto sobre un [ImportResult] con `conflict == true`.
  Future<ImportResult> importSave(
    String zipPath, {
    required String savesDir,
    required String backupsDir,
    bool overwrite = false,
  }) async {
    final List<int> bytes;
    try {
      bytes = await File(zipPath).readAsBytes();
    } catch (_) {
      return const ImportResult(ok: false, error: ImportError.invalidZip);
    }

    final Archive archive;
    try {
      archive = ZipDecoder().decodeBytes(bytes);
    } catch (_) {
      return const ImportResult(ok: false, error: ImportError.invalidZip);
    }

    return importArchive(
      archive,
      savesDir: savesDir,
      backupsDir: backupsDir,
      overwrite: overwrite,
    );
  }

  /// Núcleo del import, separado de la lectura de disco para poder probar
  /// los casos G3-G10 con un [Archive] construido en memoria (ver
  /// `test/fixtures/zip_fixtures.dart`) sin depender de la fidelidad de un
  /// zip real re-codificado.
  Future<ImportResult> importArchive(
    Archive archive, {
    required String savesDir,
    required String backupsDir,
    bool overwrite = false,
  }) async {
    // 1) Seguridad de rutas ANTES de tocar disco: rechaza symlinks, `..` y
    //    rutas absolutas en cualquier entrada.
    if (archive.files.length > _kMaxEntryCount) {
      return const ImportResult(ok: false, error: ImportError.tooLarge);
    }
    var totalSize = 0;
    for (final entry in archive.files) {
      if (entry.isSymbolicLink || _isUnsafeEntryName(entry.name)) {
        return const ImportResult(ok: false, error: ImportError.unsafePath);
      }
      totalSize += entry.size;
    }
    if (totalSize > _kMaxUncompressedBytes) {
      return const ImportResult(ok: false, error: ImportError.tooLarge);
    }

    // 2) Localizar SaveGameInfo + archivo principal (mismo nombre que su
    //    carpeta contenedora) — incluso si el zip los envuelve en un nivel
    //    extra de carpeta.
    ArchiveFile? infoEntry;
    for (final f in archive.files) {
      if (f.isFile && _basename(f.name) == 'SaveGameInfo') {
        infoEntry = f;
        break;
      }
    }
    if (infoEntry == null) {
      return const ImportResult(ok: false, error: ImportError.notASave);
    }
    final containingDir = _dirname(_normalize(infoEntry.name));
    if (containingDir.isEmpty) {
      return const ImportResult(ok: false, error: ImportError.notASave);
    }
    final folderName = _basename(containingDir);
    final prefix = '$containingDir/';
    ArchiveFile? mainEntry;
    for (final f in archive.files) {
      if (f.isFile && _normalize(f.name) == '$containingDir/$folderName') {
        mainEntry = f;
        break;
      }
    }
    if (mainEntry == null) {
      return const ImportResult(ok: false, error: ImportError.notASave);
    }

    // 3) Extraer a un directorio temporal (nunca al destino final todavía).
    final sep = Platform.pathSeparator;
    final tempRoot = await Directory.systemTemp.createTemp('vs_import_');
    final tempSaveDir = Directory('${tempRoot.path}$sep$folderName');
    try {
      for (final entry in archive.files) {
        if (!entry.isFile) continue;
        final normalized = _normalize(entry.name);
        if (!normalized.startsWith(prefix)) continue;
        final relative = normalized.substring(prefix.length);
        if (relative.isEmpty) continue;
        final outFile = File(
          '${tempSaveDir.path}$sep${relative.split('/').join(sep)}',
        );
        await outFile.parent.create(recursive: true);
        await outFile.writeAsBytes(entry.content);
      }

      // 4) Validar estructura de save real (reutiliza SaveService, no
      //    duplica el parser).
      final infoFile = File('${tempSaveDir.path}${sep}SaveGameInfo');
      final mainFile = File('${tempSaveDir.path}$sep$folderName');
      if (!await infoFile.exists() || !await mainFile.exists()) {
        await _safeDelete(tempRoot);
        return const ImportResult(ok: false, error: ImportError.notASave);
      }
      final parsed = SaveService.parseSaveGameInfo(
        await infoFile.readAsString(),
        folderName: folderName,
        lastModified: DateTime.now(),
      );
      if (parsed == null) {
        await _safeDelete(tempRoot);
        return const ImportResult(ok: false, error: ImportError.notASave);
      }
      try {
        await mainFile.readAsString();
      } catch (_) {
        await _safeDelete(tempRoot);
        return const ImportResult(ok: false, error: ImportError.notASave);
      }

      // 5) Conflicto: si ya existe localmente, el caller decide antes de
      //    que se mueva nada.
      final destination = Directory('$savesDir$sep$folderName');
      if (await destination.exists() && !overwrite) {
        await _safeDelete(tempRoot);
        return ImportResult(
          ok: false,
          conflict: true,
          importedFolderName: folderName,
        );
      }

      // 6) Sustitución transaccional (respaldo automático + swap con
      //    rollback) — nunca un `delete()` + `rename()` directo (spec
      //    001-integridad-transaccional-saves FR-013).
      final result = await SaveReplaceService.instance.replaceSaveFolder(
        savesDir: savesDir,
        folderName: folderName,
        backupsDir: backupsDir,
        prepare: (stagingDir) => copyDirectory(tempSaveDir, stagingDir),
      );
      await _safeDelete(tempRoot);

      if (!result.ok) {
        return ImportResult(ok: false, error: _mapReplaceError(result.error));
      }
      return ImportResult(ok: true, importedFolderName: folderName);
    } catch (_) {
      await _safeDelete(tempRoot);
      return const ImportResult(ok: false, error: ImportError.writeFailure);
    }
  }
}

bool _isUnsafeEntryName(String name) {
  final normalized = _normalize(name);
  if (normalized.startsWith('/')) return true;
  if (RegExp(r'^[a-zA-Z]:').hasMatch(normalized)) return true;
  return normalized.split('/').contains('..');
}

String _normalize(String name) => name.replaceAll('\\', '/');

String _basename(String name) {
  final normalized = _normalize(name);
  final segments = normalized.split('/')..removeWhere((s) => s.isEmpty);
  return segments.isEmpty ? '' : segments.last;
}

String _dirname(String normalizedName) {
  final idx = normalizedName.lastIndexOf('/');
  return idx <= 0 ? '' : normalizedName.substring(0, idx);
}

Future<void> _safeDelete(Directory dir) async {
  try {
    if (await dir.exists()) await dir.delete(recursive: true);
  } catch (_) {
    // best-effort: si no se puede borrar, el error original ya se reporta
  }
}
