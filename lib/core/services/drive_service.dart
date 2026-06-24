import 'dart:convert';
import 'dart:io';

import 'package:googleapis/drive/v3.dart' as drive;
import 'package:googleapis_auth/auth_io.dart';

import '../models/save_file.dart';
import 'save_service.dart';

const _folderName = 'ValleySave';
const _folderMime = 'application/vnd.google-apps.folder';
const _readmeName = 'LEEME - ValleySave.txt';

const _readmeContent = '''ValleySave — Carpeta de sincronizacion
======================================

Esta carpeta es gestionada automaticamente por la app ValleySave.
Aqui se guardan tus archivos de partida de Stardew Valley para
sincronizarlos entre todos tus dispositivos.

IMPORTANTE — No borres esta carpeta ni los archivos que contiene.

Si eliminas la carpeta o algun save:
  - Los archivos iran a la Papelera de Google Drive.
  - ValleySave NO puede recuperarlos automaticamente.
  - Puedes restaurarlos tu mismo desde la Papelera de Drive
    antes de que se eliminen definitivamente (30 dias).

Una vez eliminados definitivamente, los saves se pierden para siempre.
La responsabilidad de gestionar los archivos en Drive es tuya.
''';

class DriveService {
  DriveService(AuthClient client) : _api = drive.DriveApi(client);

  final drive.DriveApi _api;
  String? _folderId;

  /// Busca o crea la carpeta ValleySave/ en el Drive del usuario.
  Future<String> ensureFolder() async {
    if (_folderId != null) return _folderId!;

    final result = await _api.files.list(
      q: "name='$_folderName' and mimeType='$_folderMime' and trashed=false",
      spaces: 'drive',
      $fields: 'files(id)',
    );

    if (result.files != null && result.files!.isNotEmpty) {
      _folderId = result.files!.first.id!;
    } else {
      final folder = drive.File()
        ..name = _folderName
        ..mimeType = _folderMime;

      final created = await _api.files.create(folder, $fields: 'id');
      _folderId = created.id!;
    }

    _ensureReadme(_folderId!).ignore();
    return _folderId!;
  }

  Future<void> _ensureReadme(String folderId) async {
    try {
      final result = await _api.files.list(
        q: "name='$_readmeName' and '$folderId' in parents and trashed=false",
        spaces: 'drive',
        $fields: 'files(id)',
      );
      if (result.files != null && result.files!.isNotEmpty) return;

      final bytes = utf8.encode(_readmeContent);
      final metadata = drive.File()
        ..name = _readmeName
        ..parents = [folderId]
        ..mimeType = 'text/plain';

      await _api.files.create(
        metadata,
        uploadMedia: drive.Media(Stream.fromIterable([bytes]), bytes.length),
        $fields: 'id',
      );
    } catch (_) {}
  }

  /// Lista saves dentro de ValleySave/ ordenados por fecha de modificación.
  Future<List<drive.File>> listSaves() async {
    final folderId = await ensureFolder();
    final result = await _api.files.list(
      q: "'$folderId' in parents and trashed=false",
      spaces: 'drive',
      orderBy: 'modifiedTime desc',
      $fields: 'files(id,name,modifiedTime,size)',
    );
    return result.files ?? [];
  }

  /// Sube un archivo local. Si [driveFileId] != null actualiza el existente,
  /// si no crea uno nuevo. Devuelve el id del archivo en Drive.
  Future<String> uploadFile(String localPath, {String? driveFileId}) async {
    final folderId = await ensureFolder();
    final file = File(localPath);
    final name = file.path.split(Platform.pathSeparator).last;
    final length = await file.length();
    final media = drive.Media(file.openRead(), length);

    if (driveFileId != null) {
      final updated = await _api.files.update(
        drive.File(),
        driveFileId,
        uploadMedia: media,
        $fields: 'id',
      );
      return updated.id!;
    }

    final metadata = drive.File()
      ..name = name
      ..parents = [folderId];

    final created = await _api.files.create(
      metadata,
      uploadMedia: media,
      $fields: 'id',
    );
    return created.id!;
  }

  /// Busca o crea subcarpeta ValleySave/[saveName]/.
  Future<String> _ensureSaveFolder(String saveName) async {
    final rootId = await ensureFolder();
    final result = await _api.files.list(
      q: "name='$saveName' and mimeType='$_folderMime' and '$rootId' in parents and trashed=false",
      spaces: 'drive',
      $fields: 'files(id)',
    );
    if (result.files != null && result.files!.isNotEmpty) {
      return result.files!.first.id!;
    }
    final folder = drive.File()
      ..name = saveName
      ..mimeType = _folderMime
      ..parents = [rootId];
    final created = await _api.files.create(folder, $fields: 'id');
    return created.id!;
  }

  /// Sube los dos archivos de un save (SaveGameInfo + archivo principal)
  /// a ValleySave/[folderName]/. Actualiza si ya existen en Drive.
  Future<void> uploadSave(String folderPath, String folderName) async {
    final saveFolderId = await _ensureSaveFolder(folderName);
    final sep = Platform.pathSeparator;
    final filePaths = [
      '$folderPath${sep}SaveGameInfo',
      '$folderPath$sep$folderName',
    ];

    for (final localPath in filePaths) {
      final file = File(localPath);
      if (!await file.exists()) continue;

      final name = localPath.split(sep).last;
      final existing = await _api.files.list(
        q: "name='$name' and '$saveFolderId' in parents and trashed=false",
        spaces: 'drive',
        $fields: 'files(id)',
      );

      final length = await file.length();
      final media = drive.Media(file.openRead(), length);
      // Graba la hora REAL de guardado del save (no la de subida) para
      // poder comparar local vs Drive de forma fiable más tarde.
      final savedAt = (await file.lastModified()).toUtc();

      if (existing.files != null && existing.files!.isNotEmpty) {
        await _api.files.update(
          drive.File()..modifiedTime = savedAt,
          existing.files!.first.id!,
          uploadMedia: media,
          $fields: 'id',
        );
      } else {
        final metadata = drive.File()
          ..name = name
          ..parents = [saveFolderId]
          ..modifiedTime = savedAt;
        await _api.files.create(metadata, uploadMedia: media, $fields: 'id');
      }
    }
  }

  /// Lista cada save en Drive con sus stats ya parseados (descarga el
  /// SaveGameInfo de cada subcarpeta). La hora de guardado = modifiedTime
  /// del archivo principal (que sellamos al subir).
  Future<List<DriveSaveSummary>> listSaveSummaries() async {
    final rootId = await ensureFolder();
    final folders = await _api.files.list(
      q: "'$rootId' in parents and mimeType='$_folderMime' and trashed=false",
      spaces: 'drive',
      $fields: 'files(id,name)',
    );

    // Todas las carpetas en paralelo: antes era serial (1+2N requests encadenados).
    Future<DriveSaveSummary?> fetchOne(drive.File folder) async {
      final folderId = folder.id;
      final folderName = folder.name;
      if (folderId == null || folderName == null) return null;

      final files = await _api.files.list(
        q: "'$folderId' in parents and trashed=false",
        spaces: 'drive',
        $fields: 'files(id,name,modifiedTime)',
      );

      drive.File? infoFile;
      drive.File? mainFile;
      for (final f in files.files ?? <drive.File>[]) {
        if (f.name == 'SaveGameInfo') infoFile = f;
        if (f.name == folderName) mainFile = f;
      }
      if (infoFile == null) return null;

      final media = await _api.files.get(
        infoFile.id!,
        downloadOptions: drive.DownloadOptions.fullMedia,
      ) as drive.Media;
      final bytes = await _readAll(media.stream);
      final xml = utf8.decode(bytes, allowMalformed: true);

      final savedAt =
          (mainFile?.modifiedTime ?? infoFile.modifiedTime ?? DateTime.now())
              .toLocal();

      final save = SaveService.parseSaveGameInfo(
        xml,
        folderName: folderName,
        lastModified: savedAt,
      );
      if (save == null) return null;
      return DriveSaveSummary(
        folderName: folderName,
        folderId: folderId,
        save: save,
      );
    }

    final results = await Future.wait(
      (folders.files ?? <drive.File>[]).map(fetchOne),
    );
    return results.whereType<DriveSaveSummary>().toList();
  }

  /// Descarga todos los archivos de un save de Drive a [localFolderPath],
  /// sobrescribiendo los locales.
  Future<void> downloadSave(String driveFolderId, String localFolderPath) async {
    final files = await _api.files.list(
      q: "'$driveFolderId' in parents and trashed=false",
      spaces: 'drive',
      $fields: 'files(id,name)',
    );
    final dir = Directory(localFolderPath);
    await dir.create(recursive: true);

    for (final f in files.files ?? <drive.File>[]) {
      if (f.id == null || f.name == null) continue;
      final media = await _api.files.get(
        f.id!,
        downloadOptions: drive.DownloadOptions.fullMedia,
      ) as drive.Media;
      final out = File('$localFolderPath${Platform.pathSeparator}${f.name}');
      await media.stream.pipe(out.openWrite());
    }
  }

  Future<List<int>> _readAll(Stream<List<int>> stream) async {
    final bytes = <int>[];
    await for (final chunk in stream) {
      bytes.addAll(chunk);
    }
    return bytes;
  }

  /// Descarga un archivo de Drive a [localPath].
  Future<void> downloadFile(String fileId, String localPath) async {
    final media = await _api.files.get(
      fileId,
      downloadOptions: drive.DownloadOptions.fullMedia,
    ) as drive.Media;

    final output = File(localPath);
    await output.create(recursive: true);
    await media.stream.pipe(output.openWrite());
  }
}

/// Un save tal como existe en Drive: su nombre de carpeta (= uniqueID),
/// el id de la subcarpeta y sus stats parseados.
class DriveSaveSummary {
  const DriveSaveSummary({
    required this.folderName,
    required this.folderId,
    required this.save,
  });

  final String folderName;
  final String folderId;
  final SaveFile save;
}
