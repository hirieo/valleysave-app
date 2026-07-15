import 'dart:convert';
import 'dart:io';

import 'package:googleapis/drive/v3.dart' as drive;
import 'package:googleapis_auth/auth_io.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/backup_entry.dart';
import '../models/player_stats.dart';
import '../models/save_file.dart';
import '../models/shared_save_entry.dart';
import 'save_service.dart';

const _backupsFolderName = 'Backups';

const _sharedSavesRegistryKey = 'shared_saves_registry';

const _playersJsonName = 'players.json';

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

/// Señal fuerte e inmediata de revocación: Drive respondió con ÉXITO a la
/// lectura de metadatos pero indicó explícitamente que ya no hay permiso de
/// escritura (`capabilities.canEdit == false`). A diferencia de un fallo de
/// red o cuota (ambiguo, ver [DriveService.listSharedSaves]), esto es una
/// respuesta completa y actual de Drive — se trata como revocación
/// confirmada al momento, sin esperar la racha pasiva de 24h.
class SharedAccessRevokedException implements Exception {
  const SharedAccessRevokedException(this.folderId);
  final String folderId;
}

/// Señal de que el acceso SIGUE siendo válido pero ya no incluye escritura
/// (el dueño bajó de escritor a lector, o el rol nunca fue de escritor).
/// A diferencia de [SharedAccessRevokedException], aquí Drive respondió con
/// éxito a la lectura de metadatos — el usuario sigue viendo/descargando,
/// solo no puede sincronizar hacia el Drive del dueño.
class SharedAccessReadOnlyException implements Exception {
  const SharedAccessReadOnlyException(this.folderId);
  final String folderId;
}

/// Motivos de 403 que SÍ confirman permiso insuficiente de verdad. Drive
/// reutiliza el mismo status 403 para cuota, rate-limit y otros fallos
/// transitorios, así que solo estos motivos explícitos cuentan — cualquier
/// otro (incluido un 403 sin `errors`/`reason`, o uno de cuota) se trata
/// como ambiguo, NUNCA como revocación. Por defecto se asume ambigüedad
/// salvo prueba de permiso — no al revés — para no sacar una partida válida
/// de "Compartidas conmigo" por un simple 429/cuota durante un intento de
/// sincronizar o subir un backup (2026-07-15, corrección: mi primera versión
/// asumía permiso denegado por defecto salvo que reconociera cuota, más
/// arriesgado; alineado con la solución independiente de Codex sobre el
/// mismo diagnóstico).
const _confirmedPermissionReasons = {
  'insufficientfilepermissions',
  'insufficientpermissions',
  'permissiondenied',
};

bool _isPermissionError(drive.DetailedApiRequestError e) {
  if (e.status == 404) return true;
  if (e.status != 403) return false;
  return e.errors.any(
    (d) => _confirmedPermissionReasons.contains(d.reason?.toLowerCase()),
  );
}

class DriveService {
  DriveService(this._client) : _api = drive.DriveApi(_client);

  final AuthClient _client;
  final drive.DriveApi _api;
  String? _folderId;
  String? _myEmail;

  /// Token OAuth vigente — solo lo necesita el WebView de Picker (US5), que
  /// se autentica como el usuario ya logueado sin ampliar el scope.
  String get accessToken => _client.credentials.accessToken.data;

  /// Email de la cuenta Google conectada — para descartar carpetas que
  /// Drive devuelve como `sharedWithMe` pero cuyo dueño eres tú mismo (ver
  /// [listSharedFolders]). Cacheado: no cambia dentro de una sesión.
  Future<String?> myEmail() async {
    if (_myEmail != null) return _myEmail;
    try {
      final about = await _api.about.get($fields: 'user(emailAddress)');
      _myEmail = about.user?.emailAddress;
    } catch (_) {}
    return _myEmail;
  }

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

  /// Carpetas compartidas directamente conmigo en Drive ("Compartido
  /// conmigo"), para el selector de US5. Cada save se comparte como carpeta
  /// individual (F2), así que no hace falta navegar subcarpetas: todas
  /// aparecen al nivel raíz de sharedWithMe. Requiere scope completo
  /// `drive` (no `drive.file`): con drive.file esta query siempre devuelve
  /// vacío, y aunque el usuario eligiera la carpeta a través del Picker de
  /// Google, ni el propio Picker podía ver su contenido (no es dueño de la
  /// carpeta) — ver research 2026-07-12.
  ///
  /// Filtra a carpetas que de verdad contienen una partida. Drive marca como
  /// `sharedWithMe` la carpeta compartida directamente; sus hijos solo heredan
  /// el permiso, por lo que buscar `SaveGameInfo` con ese mismo predicado deja
  /// fuera saves válidos. Primero lista carpetas y luego valida cada candidata.
  Future<List<drive.File>> listSharedFolders() async {
    // Drive puede devolver `sharedWithMe: true` para una carpeta cuyo dueño
    // eres tú mismo (relación recíproca cuando el colaborador te vuelve a
    // dar acceso a SU copia con el mismo nombre, u otras rarezas de la API)
    // — no tiene sentido "compartírtela a ti mismo", se descarta. Una sola
    // llamada al principio (posición fija, se cachea el resto de la sesión).
    final myEmail = await this.myEmail();

    final candidates = <drive.File>[];
    String? pageToken;
    do {
      final page = await _api.files.list(
        q: "sharedWithMe and mimeType='$_folderMime' and trashed=false",
        spaces: 'drive',
        pageSize: 1000,
        pageToken: pageToken,
        $fields:
            'nextPageToken,files(id,name,mimeType,trashed,modifiedTime,owners(emailAddress,displayName))',
      );
      candidates.addAll(page.files ?? const <drive.File>[]);
      pageToken = page.nextPageToken;
    } while (pageToken != null && pageToken.isNotEmpty);

    final folders = <drive.File>[];
    for (final folder in candidates) {
      final folderId = folder.id;
      if (folderId == null) continue;
      final ownerEmail = (folder.owners != null && folder.owners!.isNotEmpty)
          ? folder.owners!.first.emailAddress
          : null;
      if (myEmail != null && ownerEmail == myEmail) continue;
      try {
        final info = await _api.files.list(
          q: "'$folderId' in parents and name='SaveGameInfo' and trashed=false",
          spaces: 'drive',
          pageSize: 1,
          $fields: 'files(id)',
        );
        if (info.files?.isNotEmpty == true) {
          folders.add(folder);
        }
      } catch (_) {
        // Carpeta revocada entre listado y validación: omitir sin romper todo.
      }
    }
    folders.sort(
      (a, b) => (b.modifiedTime ?? DateTime(0)).compareTo(
        a.modifiedTime ?? DateTime(0),
      ),
    );
    return folders;
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
  /// Si [players] trae más de un jugador real (partida coop), sube además
  /// un resumen ligero (`players.json`) para que Drive pueda mostrar a todos
  /// los jugadores sin tener que descargar el archivo grande del save.
  Future<void> uploadSave(
    String folderPath,
    String folderName, {
    List<PlayerStats> players = const [],
  }) async {
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

    await _syncPlayersJson(saveFolderId, players);
  }

  /// Mantiene el resumen de jugadores coherente con los archivos reales.
  ///
  /// - varios jugadores: crea o actualiza `players.json`;
  /// - un jugador confirmado: elimina un resumen coop antiguo;
  /// - lista vacía: no toca nada, porque significa "no se pudo determinar"
  ///   y no queremos borrar metadatos válidos por un fallo de parseo.
  Future<void> _syncPlayersJson(
    String saveFolderId,
    List<PlayerStats> players,
  ) async {
    if (players.isEmpty) return;
    if (players.length > 1) {
      await _uploadPlayersJson(saveFolderId, players);
      return;
    }

    final existing = await _api.files.list(
      q: "name='$_playersJsonName' and '$saveFolderId' in parents and trashed=false",
      spaces: 'drive',
      $fields: 'files(id)',
    );
    for (final file in existing.files ?? <drive.File>[]) {
      if (file.id != null) await _api.files.delete(file.id!);
    }
  }

  Future<void> _uploadPlayersJson(
    String saveFolderId,
    List<PlayerStats> players,
  ) async {
    final json = jsonEncode({
      'players': players.map((p) => p.toJson()).toList(),
    });
    final bytes = utf8.encode(json);
    final media = drive.Media(Stream.fromIterable([bytes]), bytes.length);

    final existing = await _api.files.list(
      q: "name='$_playersJsonName' and '$saveFolderId' in parents and trashed=false",
      spaces: 'drive',
      $fields: 'files(id)',
    );

    if (existing.files != null && existing.files!.isNotEmpty) {
      await _api.files.update(
        drive.File(),
        existing.files!.first.id!,
        uploadMedia: media,
        $fields: 'id',
      );
    } else {
      final metadata = drive.File()
        ..name = _playersJsonName
        ..parents = [saveFolderId];
      await _api.files.create(metadata, uploadMedia: media, $fields: 'id');
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
      drive.File? playersFile;
      for (final f in files.files ?? <drive.File>[]) {
        if (f.name == 'SaveGameInfo') infoFile = f;
        if (f.name == folderName) mainFile = f;
        if (f.name == _playersJsonName) playersFile = f;
      }
      if (infoFile == null) return null;

      final media =
          await _api.files.get(
                infoFile.id!,
                downloadOptions: drive.DownloadOptions.fullMedia,
              )
              as drive.Media;
      final bytes = await _readAll(media.stream);
      final xml = utf8.decode(bytes, allowMalformed: true);

      final savedAt =
          (mainFile?.modifiedTime ?? infoFile.modifiedTime ?? DateTime.now())
              .toLocal();

      final players = await _fetchPlayersJson(playersFile);

      final save = SaveService.parseSaveGameInfo(
        xml,
        folderName: folderName,
        lastModified: savedAt,
        players: players,
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

  /// Descarga y parsea `players.json` si existe. Partidas coop subidas antes
  /// de esta función no lo tienen — devuelve vacío (solo se verá al anfitrión,
  /// como hasta ahora, hasta que se vuelva a subir esa partida).
  Future<List<PlayerStats>> _fetchPlayersJson(drive.File? playersFile) async {
    if (playersFile?.id == null) return const [];
    try {
      final media =
          await _api.files.get(
                playersFile!.id!,
                downloadOptions: drive.DownloadOptions.fullMedia,
              )
              as drive.Media;
      final bytes = await _readAll(media.stream);
      final json = jsonDecode(utf8.decode(bytes)) as Map<String, dynamic>;
      final list = json['players'] as List<dynamic>? ?? [];
      return list
          .map((e) => PlayerStats.fromJson(e as Map<String, dynamic>))
          .toList();
    } catch (_) {
      return const [];
    }
  }

  /// Las versiones recientes suben `players.json`, ligero y suficiente para
  /// pintar el selector. En compartidos antiguos aún no existe: como último
  /// recurso leemos el archivo principal ya accesible para extraer la lista
  /// real, evitando que la cara del Drive del dueño pierda sus jugadores.
  Future<List<PlayerStats>> _fetchSharedPlayers({
    required drive.File? playersFile,
    required drive.File? mainFile,
  }) async {
    final players = await _fetchPlayersJson(playersFile);
    if (players.isNotEmpty || mainFile?.id == null) return players;
    try {
      final media =
          await _api.files.get(
                mainFile!.id!,
                downloadOptions: drive.DownloadOptions.fullMedia,
              )
              as drive.Media;
      final bytes = await _readAll(media.stream);
      return SaveService.parseFullSave(
        utf8.decode(bytes, allowMalformed: true),
      );
    } catch (_) {
      return const [];
    }
  }

  /// Descarga todos los archivos de un save de Drive a [localFolderPath],
  /// sobrescribiendo los locales.
  Future<void> downloadSave(
    String driveFolderId,
    String localFolderPath,
  ) async {
    final files = await _api.files.list(
      q: "'$driveFolderId' in parents and trashed=false",
      spaces: 'drive',
      $fields: 'files(id,name)',
    );
    final dir = Directory(localFolderPath);
    await dir.create(recursive: true);

    for (final f in files.files ?? <drive.File>[]) {
      if (f.id == null || f.name == null) continue;
      // `players.json` es metadato de ValleySave para pintar el selector en
      // la nube. Stardew no lo necesita dentro de su carpeta de saves.
      if (f.name == _playersJsonName) continue;
      final media =
          await _api.files.get(
                f.id!,
                downloadOptions: drive.DownloadOptions.fullMedia,
              )
              as drive.Media;
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

  /// Mueve la subcarpeta de un save a la Papelera de Google Drive.
  Future<void> trashSave(String folderId) async {
    await _api.files.update(
      drive.File()..trashed = true,
      folderId,
      $fields: 'id',
    );
  }

  /// Restaura una subcarpeta desde la Papelera de Drive.
  Future<void> restoreSave(String folderId) async {
    await _api.files.update(
      drive.File()..trashed = false,
      folderId,
      $fields: 'id',
    );
  }

  /// Lista subcarpetas de saves en la Papelera de Drive.
  Future<List<drive.File>> listTrashedSaves() async {
    final rootId = await ensureFolder();
    final result = await _api.files.list(
      q: "'$rootId' in parents and mimeType='$_folderMime' and trashed=true",
      spaces: 'drive',
      $fields: 'files(id,name,modifiedTime)',
    );
    return result.files ?? [];
  }

  /// Comparte la subcarpeta de un save con [email]. Individual: SIEMPRE
  /// `role: 'reader'` (decisión cerrada, sin excepción). Coop: el caller
  /// puede pasar `role: 'writer'` ("sincronizar") — la UI es quien decide
  /// cuándo ofrecer esa opción (solo `entry.isCoop == true`), este método
  /// no conoce el tipo de save, solo valida el rol.
  Future<String> shareSave(
    String saveFolderId,
    String email, {
    String role = 'reader',
  }) async {
    assert(role == 'reader' || role == 'writer');
    final permission = drive.Permission()
      ..type = 'user'
      ..role = role
      ..emailAddress = email;
    final created = await _api.permissions.create(
      permission,
      saveFolderId,
      sendNotificationEmail: true,
      $fields: 'id',
    );
    return created.id!;
  }

  /// Personas con acceso a la subcarpeta de un save (excluye al propio
  /// dueño). Expone `role` para que la UI coop pinte el control editable.
  Future<List<drive.Permission>> listPermissions(String saveFolderId) async {
    final result = await _api.permissions.list(
      saveFolderId,
      $fields: 'permissions(id,emailAddress,displayName,role,type)',
    );
    return (result.permissions ?? [])
        .where((p) => p.role != 'owner' && p.type == 'user')
        .toList();
  }

  Future<void> unshareSave(String saveFolderId, String permissionId) async {
    await _api.permissions.delete(saveFolderId, permissionId);
  }

  /// US5 — "Salir del compartido": revoca TU PROPIO acceso a una carpeta
  /// que no es tuya (a diferencia de `removeSharedSave`, que solo borra el
  /// registro local — esto sí toca Drive de verdad, irreversible sin que
  /// el dueño vuelva a compartir). La API de Drive admite `'me'` como
  /// permissionId especial para el propio usuario autenticado — no hace
  /// falta averiguar tu email ni listar permisos para encontrar el tuyo.
  Future<void> leaveSharedSave(String folderId) async {
    await _api.permissions.delete(folderId, 'me');
  }

  /// Cambia el rol de una persona ya con acceso, sin revocar ni volver a
  /// notificar por email. SOLO tiene sentido para saves coop (ver contrato).
  Future<void> updatePermission(
    String saveFolderId,
    String permissionId,
    String role,
  ) async {
    assert(role == 'reader' || role == 'writer');
    await _api.permissions.update(
      drive.Permission()..role = role,
      saveFolderId,
      permissionId,
      $fields: 'id',
    );
  }

  // ── Respaldos pre-swap en Drive (spec 007) ──

  Future<String> _ensureBackupsFolder() async {
    final rootId = await ensureFolder();
    final result = await _api.files.list(
      q:
          "name='$_backupsFolderName' and mimeType='$_folderMime' and "
          "'$rootId' in parents and trashed=false",
      spaces: 'drive',
      $fields: 'files(id)',
    );
    if (result.files != null && result.files!.isNotEmpty) {
      return result.files!.first.id!;
    }
    final folder = drive.File()
      ..name = _backupsFolderName
      ..mimeType = _folderMime
      ..parents = [rootId];
    final created = await _api.files.create(folder, $fields: 'id');
    return created.id!;
  }

  /// Sube el zip a `ValleySave/Backups/` — NUNCA dentro de la subcarpeta de
  /// un save (G6 del contrato 007).
  Future<String> uploadBackupZip(String localPath) async {
    final backupsFolderId = await _ensureBackupsFolder();
    return _uploadBackupZipToFolder(localPath, backupsFolderId);
  }

  /// Sube un respaldo al mismo folder de un save compartido. Solo se permite
  /// cuando Drive confirma permiso de edición: no se crea nada en partidas
  /// compartidas como lectura.
  Future<String> uploadBackupZipToSharedSave(
    String folderId,
    String localPath,
  ) async {
    drive.File folder;
    try {
      folder =
          await _api.files.get(folderId, $fields: 'capabilities(canEdit)')
              as drive.File;
    } on drive.DetailedApiRequestError catch (e) {
      if (_isPermissionError(e)) throw SharedAccessRevokedException(folderId);
      rethrow;
    }
    if (folder.capabilities?.canEdit != true) {
      throw SharedAccessReadOnlyException(folderId);
    }
    return _uploadBackupZipToFolder(localPath, folderId);
  }

  Future<String> _uploadBackupZipToFolder(
    String localPath,
    String folderId,
  ) async {
    final file = File(localPath);
    final name = file.path.split(Platform.pathSeparator).last;
    final length = await file.length();
    final media = drive.Media(file.openRead(), length);
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

  /// Lista respaldos en `ValleySave/Backups/`, filtrando por [folderName] si
  /// se pasa. Archivos que no siguen el patrón de nombre se ignoran.
  Future<List<BackupEntry>> listDriveBackups({String? folderName}) async {
    final backupsFolderId = await _ensureBackupsFolder();
    return _listBackupsInFolder(
      backupsFolderId,
      folderName: folderName,
      shared: false,
    );
  }

  /// Lista los respaldos que el propietario guardó dentro de la carpeta de
  /// una partida compartida. Se mantienen separados de "Mi Drive" para que
  /// la UI pueda decidir con precisión qué ubicación falta o se va a borrar.
  Future<List<BackupEntry>> listSharedSaveBackups(
    String sharedFolderId, {
    String? folderName,
  }) => _listBackupsInFolder(
    sharedFolderId,
    folderName: folderName,
    shared: true,
  );

  Future<List<BackupEntry>> _listBackupsInFolder(
    String folderId, {
    required bool shared,
    String? folderName,
  }) async {
    final result = await _api.files.list(
      q: "'$folderId' in parents and trashed=false",
      spaces: 'drive',
      $fields: 'files(id,name,size,modifiedTime)',
    );
    final out = <BackupEntry>[];
    for (final f in result.files ?? <drive.File>[]) {
      final name = f.name;
      final id = f.id;
      if (name == null || id == null) continue;
      final parsed = BackupEntry.parseFileName(name);
      if (parsed == null) continue;
      if (folderName != null && parsed.folderName != folderName) continue;
      out.add(
        BackupEntry(
          fileName: name,
          folderName: parsed.folderName,
          timestamp: parsed.timestamp,
          driveFileId: shared ? null : id,
          sharedDriveFileId: shared ? id : null,
          sizeBytes: int.tryParse(f.size ?? '0') ?? 0,
        ),
      );
    }
    return out;
  }

  /// Borra el archivo directamente (NO `trashed:true`) — un backup no
  /// necesita pasar por la papelera de 30 días, es descartable a propósito.
  Future<void> deleteDriveBackup(String fileId) async {
    await _api.files.delete(fileId);
  }

  /// Descarga un archivo de Drive a [localPath].
  Future<void> downloadFile(String fileId, String localPath) async {
    final media =
        await _api.files.get(
              fileId,
              downloadOptions: drive.DownloadOptions.fullMedia,
            )
            as drive.Media;

    final output = File(localPath);
    await output.create(recursive: true);
    await media.stream.pipe(output.openWrite());
  }

  // ── Compartidas conmigo (F2/US5) — ver contracts/shared_saves_picker.md ──

  /// Clave por cuenta (`shared_saves_registry::<email>`) — antes era una
  /// única clave global y se borraba entera en `signOut()` para no mezclar
  /// cuentas; eso también borraba el historial de la cuenta que se
  /// desconectaba. Con la clave por email, cada cuenta tiene su propio
  /// registro de forma natural y no hace falta borrar nada al desconectar
  /// (2026-07-15, corrección: alternar cuentas ya no pierde el registro).
  /// SIEMPRE async y resuelve `myEmail()` — antes era síncrona y caía a la
  /// clave global si el email aún no estaba cacheado; eso permitía que
  /// `addSharedSave` escribiera en la clave global mientras una carga
  /// posterior (que sí cachea el email antes) leyera ya la clave por
  /// cuenta, vacía — la partida recién añadida "desaparecía". Resolver
  /// siempre el mismo email garantiza que lectura y escritura usan
  /// exactamente la misma clave (2026-07-15, corrección).
  Future<String> _registryKey() async {
    final email = await myEmail();
    return email == null
        ? _sharedSavesRegistryKey
        : '$_sharedSavesRegistryKey::$email';
  }

  Future<List<Map<String, String>>> _loadSharedRegistry() async {
    final prefs = await SharedPreferences.getInstance();
    final key = await _registryKey();
    var raw = prefs.getString(key);
    if (raw == null && key != _sharedSavesRegistryKey) {
      // Migración desde la clave global de antes de escopar por cuenta
      // (2026-07-15): solo podía haber una cuenta conectada a la vez, así
      // que ese registro le pertenece a quien esté conectado ahora. Se
      // mueve UNA sola vez (se borra la clave vieja) para que actualizar la
      // app no vacíe "Compartidas conmigo" de quien ya tenía saves ahí.
      final legacy = prefs.getString(_sharedSavesRegistryKey);
      if (legacy != null) {
        await prefs.setString(key, legacy);
        await prefs.remove(_sharedSavesRegistryKey);
        raw = legacy;
      }
    }
    if (raw == null) return [];
    final list = jsonDecode(raw) as List<dynamic>;
    return list.map((e) => Map<String, String>.from(e as Map)).toList();
  }

  /// IDs de carpeta ya registrados en "Compartidas conmigo" — solo lee el
  /// registro local, sin llamadas de red propias (resolver el email puede
  /// añadir una si aún no está cacheado en esta sesión). Lo usa el
  /// auto-detector de saves ya en "Mis partidas" para no volver a
  /// registrar lo que ya está.
  Future<Set<String>> sharedFolderIds() async {
    final registry = await _loadSharedRegistry();
    return {
      for (final e in registry)
        if (e['folderId'] != null) e['folderId']!,
    };
  }

  Future<void> _saveSharedRegistry(List<Map<String, String>> entries) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(await _registryKey(), jsonEncode(entries));
  }

  /// Se llama tras el flujo de Picker: [folderId] es la carpeta elegida.
  /// Valida que es un save real antes de persistir el registro local (G1).
  Future<SharedSaveEntry> addSharedSave(String folderId) async {
    final file =
        await _api.files.get(
              folderId,
              $fields:
                  'id,name,trashed,mimeType,capabilities(canEdit),owners(emailAddress)',
            )
            as drive.File;
    if (file.trashed == true || file.mimeType != _folderMime) {
      throw StateError('No es una carpeta de save válida.');
    }
    final folderName = file.name ?? '';

    final children = await _api.files.list(
      q: "'$folderId' in parents and trashed=false",
      spaces: 'drive',
      $fields: 'files(id,name,modifiedTime)',
    );
    drive.File? infoFile;
    drive.File? mainFile;
    drive.File? playersFile;
    for (final f in children.files ?? <drive.File>[]) {
      if (f.name == 'SaveGameInfo') infoFile = f;
      if (f.name == folderName) mainFile = f;
      if (f.name == _playersJsonName) playersFile = f;
    }
    if (infoFile == null || mainFile == null) {
      throw StateError('Esta carpeta no contiene un save reconocible.');
    }

    final media =
        await _api.files.get(
              infoFile.id!,
              downloadOptions: drive.DownloadOptions.fullMedia,
            )
            as drive.Media;
    final bytes = await _readAll(media.stream);
    final xml = utf8.decode(bytes, allowMalformed: true);
    final savedAt =
        (mainFile.modifiedTime ?? infoFile.modifiedTime ?? DateTime.now())
            .toLocal();
    final save = SaveService.parseSaveGameInfo(
      xml,
      folderName: folderName,
      lastModified: savedAt,
      players: await _fetchPlayersJson(playersFile),
    );
    if (save == null) {
      throw StateError('Esta carpeta no contiene un save reconocible.');
    }

    final ownerEmail = (file.owners != null && file.owners!.isNotEmpty)
        ? (file.owners!.first.emailAddress ?? '')
        : '';
    final role = file.capabilities?.canEdit == true ? 'writer' : 'reader';

    final registry = await _loadSharedRegistry();
    registry.removeWhere((e) => e['folderId'] == folderId);
    registry.add({
      'folderId': folderId,
      'folderName': folderName,
      'ownerEmail': ownerEmail,
    });
    await _saveSharedRegistry(registry);

    return SharedSaveEntry(
      folderId: folderId,
      folderName: folderName,
      ownerEmail: ownerEmail,
      myRole: role,
      driveStats: save,
      ownerDrivePresent: true,
      ownerDriveVerified: true,
    );
  }

  /// Umbral para una carpeta que Drive devuelve continuamente como ausente
  /// (2026-07-15, corregido tras comparar con la solución independiente de
  /// Codex sobre el mismo diagnóstico). Los errores 403, 429 y 5xx pueden
  /// ser cuota, red o backend y NUNCA convierten una compartida en partida
  /// normal, por muy larga que sea la racha — Drive ya devuelve 404 (no
  /// 403) cuando de verdad no tienes ningún acceso, precisamente para no
  /// filtrar si un archivo existe. Solo un 404 ininterrumpido durante esta
  /// ventana se da por acceso perdido de verdad.
  static const _unavailableRevokeThreshold = Duration(hours: 24);

  /// Refresca `myRole`/stats/estado de revocación contra Drive en cada
  /// llamada — NUNCA confía en el registro local para esos campos (G3, G4).
  Future<List<SharedSaveEntry>> listSharedSaves() async {
    // Una sola llamada al principio (posición fija) — se usa por entrada
    // más abajo para descartar auto-compartidos contigo mismo. `myEmail()`
    // está cacheado, así que esto no añade una segunda llamada aparte de la
    // que ya hace `_loadSharedRegistry()` para resolver la clave por cuenta.
    final myEmail = await this.myEmail();
    final registry = await _loadSharedRegistry();
    final results = <SharedSaveEntry>[];
    var registryChanged = false;

    for (final entry in registry) {
      final folderId = entry['folderId'];
      if (folderId == null) continue;
      final storedName = entry['folderName'] ?? '';
      final storedEmail = entry['ownerEmail'] ?? '';

      // "unavailableSince": racha genérica de "sin comprobar" — CUALQUIER
      // fallo la marca, solo informa a la UI (ownerDriveVerified=false), NO
      // decide revocación por sí sola.
      void markUnavailable() {
        if (entry['unavailableSince'] == null) {
          entry['unavailableSince'] = DateTime.now().toUtc().toIso8601String();
          registryChanged = true;
        }
      }

      // "missingSince": racha ESTRICTA, solo avanza con 404 (carpeta
      // realmente ausente) — la única que puede confirmar revocación.
      bool missingForLongEnough() {
        final since = entry['missingSince'];
        if (since == null) return false;
        final parsed = DateTime.tryParse(since);
        if (parsed == null) return false;
        return DateTime.now().toUtc().difference(parsed) >=
            _unavailableRevokeThreshold;
      }

      void markMissingCandidate() {
        if (entry['missingSince'] == null) {
          entry['missingSince'] = DateTime.now().toUtc().toIso8601String();
          registryChanged = true;
        }
      }

      void clearMissingCandidate() {
        if (entry.remove('missingSince') != null) registryChanged = true;
      }

      void markAvailable() {
        if (entry.remove('unavailableSince') != null) registryChanged = true;
        clearMissingCandidate();
      }

      drive.File file;
      try {
        file =
            await _api.files.get(
                  folderId,
                  $fields:
                      'id,name,trashed,capabilities(canEdit),owners(emailAddress)',
                )
                as drive.File;
      } on drive.DetailedApiRequestError catch (e) {
        // Solo un 404 (carpeta realmente ausente) puede avanzar la racha
        // que confirma revocación — el resto (403, 429, 5xx) es ambigüedad
        // de red/cuota/servidor y NUNCA cuenta para ello, por larga que sea
        // la racha (2026-07-15, corrección tras comparar con Codex).
        final isMissing = e.status == 404;
        final reallyRevoked = isMissing && missingForLongEnough();
        markUnavailable();
        if (isMissing) {
          markMissingCandidate();
        } else {
          clearMissingCandidate();
        }
        results.add(
          SharedSaveEntry(
            folderId: folderId,
            folderName: storedName,
            ownerEmail: storedEmail,
            myRole: 'reader',
            revoked: reallyRevoked,
            ownerDriveVerified: false,
          ),
        );
        continue;
      }

      if (file.trashed == true) {
        results.add(
          SharedSaveEntry(
            folderId: folderId,
            folderName: storedName,
            ownerEmail: storedEmail,
            myRole: 'reader',
            // Drive confirmó con éxito que la carpeta está en la papelera —
            // señal completa y actual, no hace falta esperar la racha
            // (2026-07-15, corrección: antes esperaba 24h también aquí).
            revoked: true,
            ownerDriveVerified: false,
          ),
        );
        continue;
      }

      final folderName = file.name ?? storedName;
      final ownerEmail = (file.owners != null && file.owners!.isNotEmpty)
          ? (file.owners!.first.emailAddress ?? storedEmail)
          : storedEmail;

      // Auto-saneado: una entrada cuyo dueño eres tú mismo no puede ser un
      // save "compartido contigo" de verdad (ver `listSharedFolders`) — se
      // trata como revocación confirmada al momento, sin esperar racha.
      if (myEmail != null && ownerEmail == myEmail) {
        results.add(
          SharedSaveEntry(
            folderId: folderId,
            folderName: folderName,
            ownerEmail: ownerEmail,
            myRole: 'reader',
            revoked: true,
          ),
        );
        continue;
      }

      final role = file.capabilities?.canEdit == true ? 'writer' : 'reader';
      try {
        final children = await _api.files.list(
          q: "'$folderId' in parents and trashed=false",
          spaces: 'drive',
          $fields: 'files(id,name,modifiedTime)',
        );
        drive.File? infoFile;
        drive.File? mainFile;
        drive.File? playersFile;
        for (final f in children.files ?? <drive.File>[]) {
          if (f.name == 'SaveGameInfo') infoFile = f;
          if (f.name == folderName) mainFile = f;
          if (f.name == _playersJsonName) playersFile = f;
        }

        SaveFile? save;
        if (infoFile != null) {
          final media =
              await _api.files.get(
                    infoFile.id!,
                    downloadOptions: drive.DownloadOptions.fullMedia,
                  )
                  as drive.Media;
          final bytes = await _readAll(media.stream);
          final xml = utf8.decode(bytes, allowMalformed: true);
          final savedAt =
              (mainFile?.modifiedTime ??
                      infoFile.modifiedTime ??
                      DateTime.now())
                  .toLocal();
          save = SaveService.parseSaveGameInfo(
            xml,
            folderName: folderName,
            lastModified: savedAt,
            // `SaveGameInfo` solo conoce al anfitrión. El resumen ligero se
            // comparte junto al save y conserva el selector de jugadores en
            // la cara "Drive en …"; saves antiguos usan el fallback seguro.
            players: await _fetchSharedPlayers(
              playersFile: playersFile,
              mainFile: mainFile,
            ),
          );
        }

        markAvailable();
        results.add(
          SharedSaveEntry(
            folderId: folderId,
            folderName: folderName,
            ownerEmail: ownerEmail,
            myRole: role,
            driveStats: save,
            ownerDrivePresent: true,
            ownerDriveVerified: true,
          ),
        );
      } on drive.DetailedApiRequestError {
        // La carpeta YA se leyó arriba con éxito: un fallo al listar/
        // descargar sus hijos no demuestra revocación — el acceso a la
        // carpeta en sí ya está confirmado, sigue siendo accesible y
        // descargable (2026-07-15, corrección: antes también contaba para
        // la racha, pudiendo revocar por un 500 pasajero).
        markUnavailable();
        clearMissingCandidate();
        results.add(
          SharedSaveEntry(
            folderId: folderId,
            folderName: folderName,
            ownerEmail: ownerEmail,
            myRole: role,
            revoked: false,
            ownerDrivePresent: true,
            ownerDriveVerified: false,
          ),
        );
      }
    }
    if (registryChanged) await _saveSharedRegistry(registry);
    return results;
  }

  /// Deliberadamente SOLO borra el registro local — CERO llamadas de red
  /// (G8). La carpeta sigue intacta en el Drive del propietario.
  Future<void> removeSharedSave(String folderId) async {
    final registry = await _loadSharedRegistry();
    registry.removeWhere((e) => e['folderId'] == folderId);
    await _saveSharedRegistry(registry);
  }

  /// Funciona igual sin importar el rol (G5) — mismo patrón que [downloadSave].
  Future<void> downloadSharedSave(String folderId, String localFolderPath) =>
      downloadSave(folderId, localFolderPath);

  /// Sobrescribe la copia del propietario. Refresca el rol ANTES de subir
  /// (no confía en un valor cacheado) y lanza si no es `writer` — defensa en
  /// profundidad aunque la UI ya oculte el botón (G6).
  Future<void> uploadToSharedSave(
    String folderId,
    String localFolderPath, {
    List<PlayerStats> players = const [],
  }) async {
    drive.File file;
    try {
      file =
          await _api.files.get(folderId, $fields: 'capabilities(canEdit)')
              as drive.File;
    } on drive.DetailedApiRequestError catch (e) {
      if (_isPermissionError(e)) throw SharedAccessRevokedException(folderId);
      rethrow;
    }
    if (file.capabilities?.canEdit != true) {
      throw SharedAccessReadOnlyException(folderId);
    }

    final sep = Platform.pathSeparator;
    final folderName = localFolderPath.split(sep).last;
    final filePaths = [
      '$localFolderPath${sep}SaveGameInfo',
      '$localFolderPath$sep$folderName',
    ];

    for (final localPath in filePaths) {
      final localFile = File(localPath);
      if (!await localFile.exists()) continue;

      final name = localPath.split(sep).last;
      final existing = await _api.files.list(
        q: "name='$name' and '$folderId' in parents and trashed=false",
        spaces: 'drive',
        $fields: 'files(id)',
      );

      final length = await localFile.length();
      final media = drive.Media(localFile.openRead(), length);
      final savedAt = (await localFile.lastModified()).toUtc();

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
          ..parents = [folderId]
          ..modifiedTime = savedAt;
        await _api.files.create(metadata, uploadMedia: media, $fields: 'id');
      }
    }

    // Mismo contrato que Mi Drive: un swap o cambio de jugadores debe quedar
    // reflejado también en el Drive del propietario.
    await _syncPlayersJson(folderId, players);
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
