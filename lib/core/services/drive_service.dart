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

/// Metadato pequeño que apunta a la generación remota activa de un save —
/// spec 001-integridad-transaccional-saves, Clarifications 2026-07-18
/// (FR-006): cada subida escribe en una subcarpeta de generación nueva y
/// solo al final actualiza este archivo, en una única operación, para
/// publicarla. Un save de antes de esta versión no tiene este archivo —
/// se sigue leyendo en formato plano (ver `DriveService._resolveContent`).
const _manifestFileName = 'manifest.json';

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

/// FR-006: falta [missingFileName] localmente — `uploadSave` aborta ANTES
/// de cualquier escritura remota, sin dejar a Drive con una versión mixta.
class UploadIncompleteSaveException implements Exception {
  const UploadIncompleteSaveException(this.missingFileName);
  final String missingFileName;
}

/// Un `manifest.json` EXISTE en la carpeta del save pero no se puede resolver
/// a una generación activa válida (ilegible, sin `activeGeneration`, o apunta
/// a una generación inexistente). NUNCA se cae al formato plano heredado en
/// este caso: la presencia del manifiesto significa que la carpeta ya adoptó
/// el sistema por generaciones, así que los archivos sueltos del nivel
/// superior (si quedaron de antes de migrar) son una versión OBSOLETA —
/// servirlos silenciosamente mostraría o descargaría una partida vieja sin
/// avisar. Solo la AUSENCIA de manifiesto habilita el formato plano legítimo
/// (hallazgo de la implementación paralela de Codex, 2026-07-18: antes ambos
/// casos caían al plano por igual).
class CorruptManifestException implements Exception {
  const CorruptManifestException(this.folderId);
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

/// Dónde viven de verdad los archivos de un save y su listado — ver
/// [DriveService._resolveContent]. [children] son los archivos del JUEGO
/// (de la generación activa, o del propio folder si es formato heredado).
/// [topLevelChildren] son SIEMPRE los hijos del folder estable original —
/// ahí es donde viven `players.json`, `manifest.json` y `Backups/`,
/// independientemente de si el save usa generaciones o no.
class _ResolvedContent {
  const _ResolvedContent(this.folderId, this.children, this.topLevelChildren);
  final String folderId;
  final List<drive.File> children;
  final List<drive.File> topLevelChildren;
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
    return _ensureSubfolder(saveName, rootId);
  }

  /// Busca o crea una subcarpeta [name] dentro de [parentId]. Punto único
  /// (FR-002): reutilizado por `_ensureSaveFolder`, `_ensureBackupsFolder` y
  /// la carpeta de generación de `uploadSave`.
  Future<String> _ensureSubfolder(String name, String parentId) async {
    final result = await _api.files.list(
      q: "name='$name' and mimeType='$_folderMime' and '$parentId' in parents and trashed=false",
      spaces: 'drive',
      $fields: 'files(id)',
    );
    if (result.files != null && result.files!.isNotEmpty) {
      return result.files!.first.id!;
    }
    final folder = drive.File()
      ..name = name
      ..mimeType = _folderMime
      ..parents = [parentId];
    final created = await _api.files.create(folder, $fields: 'id');
    return _dedupeJustCreated(name, parentId, created.id!);
  }

  /// `files.list` de Drive tiene retraso de indexación tras un `create()` —
  /// si esta subcarpeta ya se subió antes en la misma sesión (o desde otro
  /// dispositivo) y esa carpeta previa aún no aparecía en el listado de
  /// arriba, ambas llamadas ven "no existe" y crean la suya propia, dejando
  /// dos carpetas con el mismo nombre (2026-07-21, bug reportado: compartir
  /// con una persona "quitaba" el acceso de la anterior porque cada subida
  /// apuntaba a una carpeta distinta — confirmado por el usuario: dos
  /// carpetas duplicadas en Drive, sin que hubiera dos dispositivos a la
  /// vez). Se relista tras crear; si ya hay más de una, se conserva la más
  /// antigua y se manda a la papelera la sobrante para converger a una sola.
  Future<String> _dedupeJustCreated(
    String name,
    String parentId,
    String justCreatedId,
  ) async {
    final recheck = await _api.files.list(
      q: "name='$name' and mimeType='$_folderMime' and '$parentId' in parents and trashed=false",
      spaces: 'drive',
      orderBy: 'createdTime',
      $fields: 'files(id)',
    );
    final all = recheck.files ?? [];
    if (all.length <= 1) return justCreatedId;

    final oldestId = all.first.id!;
    for (final f in all.skip(1)) {
      if (f.id == null) continue;
      try {
        await _api.files.update(drive.File()..trashed = true, f.id!, $fields: 'id');
      } catch (_) {
        // Best-effort: si falla el borrado de un duplicado, no bloquea el
        // resto — se reintentará solo la próxima vez que esta carpeta se
        // vuelva a tocar.
      }
    }
    return oldestId;
  }

  /// Sube un save a ValleySave/[folderName]/ mediante el modelo de
  /// generación + manifiesto (spec 001-integridad-transaccional-saves,
  /// Clarifications 2026-07-18; FR-006, FR-007):
  ///
  /// 1. Verifica ANTES de cualquier escritura remota que `SaveGameInfo` y el
  ///    archivo principal existen y son legibles — si no, aborta con
  ///    [UploadIncompleteSaveException] sin tocar Drive.
  /// 2. Escribe TODOS los archivos (obligatorios + `_old` si existen) en una
  ///    subcarpeta de generación nueva (`gen_<timestamp>`), inmutable.
  /// 3. Publica esa generación con una ÚNICA actualización final de
  ///    `manifest.json` — hasta ese momento, cualquier otro dispositivo
  ///    sigue viendo la generación anterior completa; si la subida se corta
  ///    antes de este paso, la generación nueva queda huérfana e inerte,
  ///    nunca se hace visible a medias.
  /// 4. Limpia (best-effort) las generaciones anteriores — Drive no crece
  ///    sin límite.
  ///
  /// Si [players] trae más de un jugador real (partida coop), sube además
  /// un resumen ligero (`players.json`) para que Drive pueda mostrar a todos
  /// los jugadores sin tener que descargar el archivo grande del save.
  Future<void> uploadSave(
    String folderPath,
    String folderName, {
    List<PlayerStats> players = const [],
  }) async {
    final sep = Platform.pathSeparator;
    final infoFile = File('$folderPath${sep}SaveGameInfo');
    final mainFile = File('$folderPath$sep$folderName');
    if (!await infoFile.exists()) {
      throw const UploadIncompleteSaveException('SaveGameInfo');
    }
    if (!await mainFile.exists()) {
      throw UploadIncompleteSaveException(folderName);
    }

    final saveFolderId = await _ensureSaveFolder(folderName);
    final generationName =
        'gen_${DateTime.now().toUtc().millisecondsSinceEpoch}';
    final generationId = await _ensureSubfolder(generationName, saveFolderId);

    final localPaths = [infoFile.path, mainFile.path];
    if (await _hasValidOldPair(folderPath, folderName)) {
      localPaths.add('$folderPath${sep}SaveGameInfo_old');
      localPaths.add('$folderPath$sep${folderName}_old');
    }

    for (final localPath in localPaths) {
      final file = File(localPath);
      if (!await file.exists()) continue; // los `_old` son opcionales

      final name = localPath.split(sep).last;
      final length = await file.length();
      final media = drive.Media(file.openRead(), length);
      // Graba la hora REAL de guardado del save (no la de subida) para
      // poder comparar local vs Drive de forma fiable más tarde.
      final savedAt = (await file.lastModified()).toUtc();
      // La generación es nueva — nunca hay un archivo previo que actualizar.
      final metadata = drive.File()
        ..name = name
        ..parents = [generationId]
        ..modifiedTime = savedAt;
      await _api.files.create(metadata, uploadMedia: media, $fields: 'id');
    }

    await _publishManifest(saveFolderId, generationName);
    await _cleanupOldGenerations(saveFolderId, keep: generationName);
    await _syncPlayersJson(saveFolderId, players);
  }

  /// Saneado no destructivo del par `_old` ANTES de subir (integrado de
  /// Codex, 2026-07-19, versión adaptada): un `_old` corrupto no invalida el
  /// save principal (ver [SaveReplaceService._isValidSaveDir]), pero
  /// publicarlo tal cual en la generación nueva propaga esa corrupción a
  /// cualquier otro dispositivo que lo descargue después. Si el par no está
  /// completo Y sano (`SaveGameInfo_old` parseable, `<folderName>_old` no
  /// vacío), se omite de la subida — nunca se toca ni se borra el origen
  /// local, solo se decide qué entra en la instantánea remota.
  Future<bool> _hasValidOldPair(String folderPath, String folderName) async {
    final sep = Platform.pathSeparator;
    final infoOld = File('$folderPath${sep}SaveGameInfo_old');
    final mainOld = File('$folderPath$sep${folderName}_old');
    if (!await infoOld.exists() || !await mainOld.exists()) return false;
    if (await mainOld.length() == 0) return false;
    return SaveService.parseSaveGameInfo(
          await infoOld.readAsString(),
          folderName: folderName,
          lastModified: DateTime.now(),
        ) !=
        null;
  }

  /// Única actualización final que hace visible una generación — el
  /// "publicar" de FR-006. Antes de esta llamada, la generación nueva es
  /// invisible para cualquier lector (nadie la referencia todavía).
  Future<void> _publishManifest(
    String saveFolderId,
    String generationName,
  ) async {
    // `schema` versiona el formato del manifiesto para poder evolucionarlo
    // sin romper lectores antiguos (integrado de Codex, 2026-07-18).
    final json = jsonEncode({'schema': 1, 'activeGeneration': generationName});
    final bytes = utf8.encode(json);
    final media = drive.Media(Stream.fromIterable([bytes]), bytes.length);

    final existing = await _api.files.list(
      q:
          "name='$_manifestFileName' and '$saveFolderId' in parents and "
          "trashed=false",
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
        ..name = _manifestFileName
        ..parents = [saveFolderId];
      await _api.files.create(metadata, uploadMedia: media, $fields: 'id');
    }
  }

  /// Borra las subcarpetas de generación (`gen_*`) que no sean [keep] —
  /// best-effort: un fallo al limpiar una generación vieja nunca revierte
  /// ni interrumpe la subida que ya se publicó con éxito. Nunca toca
  /// `Backups/` ni ninguna otra carpeta que no empiece por `gen_`.
  Future<void> _cleanupOldGenerations(
    String saveFolderId, {
    required String keep,
  }) async {
    try {
      final children = await _api.files.list(
        q:
            "'$saveFolderId' in parents and trashed=false and "
            "mimeType='$_folderMime'",
        spaces: 'drive',
        $fields: 'files(id,name)',
      );
      for (final f in children.files ?? <drive.File>[]) {
        if (f.id == null || f.name == null) continue;
        if (f.name == keep || !f.name!.startsWith('gen_')) continue;
        try {
          await _api.files.delete(f.id!);
        } catch (_) {
          // best-effort: una generación vieja huérfana no rompe nada — solo
          // ocupa espacio hasta que una limpieza futura lo consiga.
        }
      }
    } catch (_) {
      // best-effort
    }
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
  /// del archivo principal (que sellamos al subir). Resuelve la generación
  /// activa vía [_resolveContent] — spec 001-integridad-transaccional-saves
  /// FR-015: sin esto, un save subido con el modelo de generación quedaría
  /// invisible aquí (sus archivos viven en `gen_<ts>/`, no al nivel raíz).
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

      final _ResolvedContent resolved;
      try {
        resolved = await _resolveContent(folderId);
      } on CorruptManifestException {
        // Un save con el índice de generación corrupto no se puede resolver
        // con seguridad — se omite de la lista (nunca se muestra la versión
        // plana obsoleta). Si fue un fallo transitorio de red al leer el
        // manifiesto, reaparece en el próximo refresco.
        return null;
      }

      drive.File? infoFile;
      drive.File? mainFile;
      for (final f in resolved.children) {
        if (f.name == 'SaveGameInfo') infoFile = f;
        if (f.name == folderName) mainFile = f;
      }
      final playersFile = resolved.topLevelChildren
          .where((f) => f.name == _playersJsonName)
          .firstOrNull;
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
        // FR-015: "completa" = tiene los dos archivos que Stardew necesita
        // para cargar — ver `save_card.dart` para el badge correspondiente.
        complete: mainFile != null,
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

  /// Descarga SOLO los archivos que Stardew reconoce de un save de Drive a
  /// [destino] — lista blanca exacta, no lista negra (spec
  /// 001-integridad-transaccional-saves FR-009, constitución III):
  /// `SaveGameInfo`, `SaveGameInfo_old`, `<folderName>`, `<folderName>_old`.
  /// Cualquier otro archivo en la carpeta remota (backups `.zip`,
  /// `players.json`, restos de versiones futuras de la app) NUNCA aterriza
  /// en la carpeta del juego, sin necesidad de conocer su nombre de
  /// antemano. No se hace ninguna llamada de red por archivo descartado.
  /// Resuelve primero la generación activa vía [_resolveContent] — si el
  /// save usa el modelo plano heredado (sin `manifest.json`), lee del nivel
  /// superior exactamente como antes de esta spec.
  Future<void> downloadSaveToDir(
    String driveFolderId,
    String folderName,
    Directory destino,
  ) async {
    final resolved = await _resolveContent(driveFolderId);
    await destino.create(recursive: true);

    final whitelist = {
      'SaveGameInfo',
      'SaveGameInfo_old',
      folderName,
      '${folderName}_old',
    };

    for (final f in resolved.children) {
      if (f.id == null || f.name == null) continue;
      if (!whitelist.contains(f.name)) continue;
      final media =
          await _api.files.get(
                f.id!,
                downloadOptions: drive.DownloadOptions.fullMedia,
              )
              as drive.Media;
      final out = File('${destino.path}${Platform.pathSeparator}${f.name}');
      await media.stream.pipe(out.openWrite());
    }
  }

  /// Compatibilidad con callers que aún no migraron a
  /// [downloadSaveToDir]/`SaveReplaceService` — deriva `folderName` del
  /// nombre base de [localFolderPath] (mismo valor que ya usaban todos los
  /// callers reales: la carpeta de destino siempre se llama como el save).
  Future<void> downloadSave(
    String driveFolderId,
    String localFolderPath,
  ) {
    final folderName = localFolderPath.split(Platform.pathSeparator).last;
    return downloadSaveToDir(
      driveFolderId,
      folderName,
      Directory(localFolderPath),
    );
  }

  /// Resuelve la carpeta real de contenido de un save. Distingue TRES casos
  /// (spec 001-integridad-transaccional-saves; corrección tras comparar con
  /// la implementación paralela de Codex, 2026-07-18):
  ///
  /// - `manifest.json` AUSENTE → formato plano heredado (todo save de antes
  ///   de esta versión, legítimo — nunca tuvo manifiesto).
  /// - `manifest.json` presente y resoluble → la generación activa.
  /// - `manifest.json` presente pero NO resoluble (ilegible, sin
  ///   `activeGeneration`, o apunta a una generación inexistente) → lanza
  ///   [CorruptManifestException]. NUNCA cae al nivel superior: los archivos
  ///   planos que puedan quedar ahí son una versión obsoleta anterior a la
  ///   migración, y servirlos sin avisar mostraría/descargaría una partida
  ///   vieja en silencio.
  Future<_ResolvedContent> _resolveContent(String folderId) async {
    final top = await _api.files.list(
      q: "'$folderId' in parents and trashed=false",
      spaces: 'drive',
      $fields: 'files(id,name,modifiedTime)',
    );
    final children = top.files ?? <drive.File>[];

    final manifestFile = children
        .where((f) => f.name == _manifestFileName)
        .firstOrNull;
    if (manifestFile?.id == null) {
      // Sin manifiesto → formato plano legítimo.
      return _ResolvedContent(folderId, children, children);
    }

    // Manifiesto presente: a partir de aquí, cualquier fallo es corrupción,
    // NO un fallback al plano.
    final activeGeneration = await _readActiveGeneration(manifestFile!.id!);
    if (activeGeneration == null) {
      throw CorruptManifestException(folderId);
    }

    final genEntry = children
        .where((f) => f.name == activeGeneration)
        .firstOrNull;
    if (genEntry?.id == null) {
      throw CorruptManifestException(folderId);
    }

    final genListing = await _api.files.list(
      q: "'${genEntry!.id}' in parents and trashed=false",
      spaces: 'drive',
      $fields: 'files(id,name,modifiedTime)',
    );
    return _ResolvedContent(
      genEntry.id!,
      genListing.files ?? <drive.File>[],
      children,
    );
  }

  /// Lee y parsea `manifest.json` — devuelve `null` (nunca lanza) si el
  /// contenido no es JSON válido o no trae `activeGeneration`, para que
  /// [_resolveContent] pueda caer de vuelta al nivel superior sin más.
  Future<String?> _readActiveGeneration(String manifestFileId) async {
    try {
      final media =
          await _api.files.get(
                manifestFileId,
                downloadOptions: drive.DownloadOptions.fullMedia,
              )
              as drive.Media;
      final bytes = await _readAll(media.stream);
      final json =
          jsonDecode(utf8.decode(bytes, allowMalformed: true))
              as Map<String, dynamic>;
      return json['activeGeneration'] as String?;
    } catch (_) {
      return null;
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
    return _ensureSubfolder(_backupsFolderName, rootId);
  }

  /// Sube el zip a `ValleySave/Backups/` — NUNCA dentro de la subcarpeta de
  /// un save (G6 del contrato 007).
  Future<String> uploadBackupZip(String localPath) async {
    final backupsFolderId = await _ensureBackupsFolder();
    return _uploadBackupZipToFolder(localPath, backupsFolderId);
  }

  /// Sube un respaldo a `<compartida>/Backups/` (spec
  /// 001-integridad-transaccional-saves FR-010) — mismo layout que "Mi
  /// Drive", nunca suelto en la raíz de la carpeta compartida (que además
  /// contiene la propia partida). Solo se permite cuando Drive confirma
  /// permiso de edición: no se crea nada en partidas compartidas como
  /// lectura.
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
    final backupsFolderId = await _ensureSubfolder(
      _backupsFolderName,
      folderId,
    );
    return _uploadBackupZipToFolder(localPath, backupsFolderId);
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
  ///
  /// Busca en `Backups/` (formato actual, spec
  /// 001-integridad-transaccional-saves FR-010) Y en la raíz de la carpeta
  /// compartida (legado — versiones anteriores subían el zip suelto ahí) —
  /// un lector sin permiso de escritura puede LEER `Backups/` aunque nunca
  /// pudo crearla, así que esto nunca intenta crearla (a diferencia de
  /// [uploadBackupZipToSharedSave]).
  Future<List<BackupEntry>> listSharedSaveBackups(
    String sharedFolderId, {
    String? folderName,
  }) async {
    final legacy = await _listBackupsInFolder(
      sharedFolderId,
      folderName: folderName,
      shared: true,
    );
    final backupsFolderId = await _findSubfolder(
      _backupsFolderName,
      sharedFolderId,
    );
    if (backupsFolderId == null) return legacy;
    final current = await _listBackupsInFolder(
      backupsFolderId,
      folderName: folderName,
      shared: true,
    );
    return [...current, ...legacy];
  }

  /// Busca una subcarpeta [name] dentro de [parentId] SIN crearla si no
  /// existe — a diferencia de [_ensureSubfolder], para caminos de solo
  /// lectura donde el caller puede no tener permiso de escritura.
  Future<String?> _findSubfolder(String name, String parentId) async {
    final result = await _api.files.list(
      q: "name='$name' and mimeType='$_folderMime' and '$parentId' in parents and trashed=false",
      spaces: 'drive',
      $fields: 'files(id)',
    );
    if (result.files == null || result.files!.isEmpty) return null;
    return result.files!.first.id!;
  }

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

    final resolved = await _resolveContent(folderId);
    drive.File? infoFile;
    drive.File? mainFile;
    for (final f in resolved.children) {
      if (f.name == 'SaveGameInfo') infoFile = f;
      if (f.name == folderName) mainFile = f;
    }
    final playersFile = resolved.topLevelChildren
        .where((f) => f.name == _playersJsonName)
        .firstOrNull;
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
        final resolved = await _resolveContent(folderId);
        drive.File? infoFile;
        drive.File? mainFile;
        for (final f in resolved.children) {
          if (f.name == 'SaveGameInfo') infoFile = f;
          if (f.name == folderName) mainFile = f;
        }
        final playersFile = resolved.topLevelChildren
            .where((f) => f.name == _playersJsonName)
            .firstOrNull;

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
            // FR-015: idéntico criterio que `listSaveSummaries` — completo
            // solo si el archivo principal está en la generación activa.
            complete: mainFile != null,
          ),
        );
      } on CorruptManifestException {
        // El save existe y es accesible, pero su índice de generación está
        // corrupto — se muestra como presente pero SIN stats ni completo
        // (misma cara "no verificado" que un fallo de red al leer sus
        // hijos), nunca con la versión plana obsoleta. No cuenta como
        // revocación: la carpeta en sí sigue accesible.
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
            complete: false,
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
    this.complete = true,
  });

  final String folderName;
  final String folderId;
  final SaveFile save;

  /// FR-015: `false` cuando falta el archivo principal en la generación
  /// activa (o el nivel raíz, en formato heredado) — nunca se descarga algo
  /// a medias, ver `SaveEntry.driveComplete` y el badge en `save_card.dart`.
  final bool complete;
}
