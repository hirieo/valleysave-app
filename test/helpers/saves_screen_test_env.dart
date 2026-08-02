/// T822/T823 (spec 008) — infraestructura para montar `SavesScreen` REAL en
/// un test de widget, algo que no tenía precedente en el repo (ver nota en
/// `tasks.md`). Se investigaron y descartaron mocks de más alto nivel: la
/// única forma de ejercitar `_uploadToOwnerDrive`/`_handleSyncShared`/
/// `_confirmUploadToBoth` (métodos privados de `_SavesScreenState`) es a
/// través de la UI real, así que hace falta:
///
/// 1. Aislar CUALQUIER acceso a `dart:io` (Directory/File) del disco real —
///    `SaveService.scan()` lee `%APPDATA%\StardewValley\Saves`, que en esta
///    máquina de desarrollo puede contener partidas reales. [SandboxIOOverrides]
///    redirige cada `Directory(...)`/`File(...)` construido durante el test a
///    una carpeta temporal, sin tocar ninguna ruta real ni depender de
///    variables de entorno.
/// 2. Mockear `path_provider` (`getApplicationDocumentsDirectory`, usado por
///    `_backupsDirPath()`), que de otro modo lanza `MissingPluginException`
///    en el entorno de test (sin plugin nativo registrado).
/// 3. Un `AuthClient` falso (mismo patrón que
///    `test/drive_service_sharing_test.dart`) que captura cada request HTTP y
///    responde con JSON/bytes enlatados — permite construir un `DriveService`
///    REAL conectado a un Drive falso.
/// 4. NUNCA `tester.pumpAndSettle()` con `SavesScreen` montada entera:
///    `ValleyCanvasWidget` (fondo estacional) anima con un `Ticker` crudo
///    (`createTicker`, ver `lib/shared/widgets/valley_canvas_widget.dart`)
///    que nunca deja de pedir frames — confirmado empíricamente: la primera
///    versión de estos tests colgó 10 minutos reales por test (el timeout
///    por defecto de `pumpAndSettle`) porque `hasScheduledFrame` nunca baja a
///    `false`. [pumpBounded] pumpea un número fijo de frames cortos en su
///    lugar — suficiente para que resuelvan los `Future` de la carga/Drive
///    falso y las animaciones de diálogo, sin depender de que la pantalla
///    "se asiente" (nunca lo hace).
library;

import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:googleapis_auth/googleapis_auth.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider_platform_interface/path_provider_platform_interface.dart';

/// Redirige TODAS las operaciones de `dart:io` (Directory/File/Link)
/// construidas dentro de la zona a [root], preservando la ruta original como
/// sufijo (":" y "\" se sanean para ser válidos en cualquier plataforma).
/// Idempotente: una ruta que ya vive bajo [root] se devuelve tal cual, para
/// que una segunda construcción sobre un `Directory`/`File` ya redirigido
/// (p.ej. `folder.path` tras `Directory(dir).list()`) no se redirija dos
/// veces. `Zone.root.run` escapa la zona actual al construir el objeto real:
/// sin esto, `Directory(_remap(path))` volvería a disparar este mismo
/// override (recursión infinita).
base class SandboxIOOverrides extends IOOverrides {
  SandboxIOOverrides(this.root);

  final String root;

  String remap(String path) {
    if (path.startsWith(root)) return path;
    var sanitized = path.replaceAll(':', '_drive_').replaceAll('\\', '/');
    if (sanitized.startsWith('/')) sanitized = sanitized.substring(1);
    return '$root/$sanitized';
  }

  @override
  Directory createDirectory(String path) =>
      Zone.root.run(() => Directory(remap(path)));

  @override
  File createFile(String path) => Zone.root.run(() => File(remap(path)));

  @override
  Link createLink(String path) => Zone.root.run(() => Link(remap(path)));
}

/// Ejecuta [body] con [SandboxIOOverrides] activo y limpia la carpeta
/// temporal al terminar (usando el `Directory` real capturado ANTES de entrar
/// en la zona — `.delete()` es un método de instancia, no pasa por
/// `createDirectory`, así que borra el sandbox real sin re-redirigirse).
Future<void> runWithIOSandbox(Future<void> Function() body) async {
  final sandboxRoot = await Directory.systemTemp.createTemp(
    'valleysave_saves_screen_test_',
  );
  final overrides = SandboxIOOverrides(sandboxRoot.path);
  try {
    await IOOverrides.runZoned(
      body,
      createDirectory: overrides.createDirectory,
      createFile: overrides.createFile,
      createLink: overrides.createLink,
    );
  } finally {
    try {
      await sandboxRoot.delete(recursive: true);
    } catch (_) {
      // best-effort — carpeta temporal, el SO la limpia tarde o temprano.
    }
  }
}

/// `path_provider` no tiene implementación nativa en `flutter test` — sin
/// esto, `_backupsDirPath()` (llamado desde `_init()`) lanza
/// `MissingPluginException` sin que el test llegue a montar nada. La ruta
/// devuelta no necesita existir de antemano: `Directory(...)` sobre ella
/// pasa igualmente por [SandboxIOOverrides] si esta función se invoca dentro
/// de `runWithIOSandbox`.
class FakePathProviderPlatform extends PathProviderPlatform {
  @override
  Future<String?> getApplicationDocumentsPath() async =>
      'FAKE_APP_DOCUMENTS_ROOT';
}

/// Mismo patrón que `test/drive_service_sharing_test.dart` — captura cada
/// request HTTP saliente de `DriveService` y responde con lo que diga
/// [handler], sin tocar la red real.
/// Reemplazo de `tester.pumpAndSettle()` seguro con `SavesScreen` completa
/// (ver punto 4 de la doc de arriba). Pumpea [max] frames cortos — de sobra
/// para que se resuelvan microtasks/Futures del Drive falso y las
/// transiciones de diálogo (`FadeTransition`/`Transform` de ~200-300ms en
/// `saves_screen.dart`), sin esperar a que el `Ticker` decorativo se pare
/// (nunca lo hace).
Future<void> pumpBounded(
  WidgetTester tester, {
  int max = 40,
  Duration step = const Duration(milliseconds: 100),
}) async {
  for (var i = 0; i < max; i++) {
    await tester.pump(step);
  }
}

class FakeAuthClient extends http.BaseClient implements AuthClient {
  FakeAuthClient(this.handler);

  final http.StreamedResponse Function(http.BaseRequest request) handler;
  final List<http.BaseRequest> requests = [];

  @override
  AccessCredentials get credentials => AccessCredentials(
    AccessToken(
      'Bearer',
      'fake-token',
      DateTime.now().toUtc().add(const Duration(hours: 1)),
    ),
    null,
    const ['https://www.googleapis.com/auth/drive'],
  );

  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) async {
    requests.add(request);
    return handler(request);
  }

  /// Azúcar para las aserciones de G6/G9: ¿alguna request tocó el endpoint
  /// de subida de contenido (create/update de `files`) hacia [folderId]?
  bool hasUploadCallTo(String folderId) => requests.any(
    (r) =>
        (r.method == 'POST' || r.method == 'PATCH') &&
        r.url.path.contains('/files') &&
        (r.url.path.contains(folderId) ||
            r.url.queryParameters['uploadType'] != null),
  );
}

http.StreamedResponse jsonResponse(Object body, {int status = 200}) {
  final bytes = utf8.encode(jsonEncode(body));
  return http.StreamedResponse(
    Stream.value(bytes),
    status,
    headers: {'content-type': 'application/json; charset=utf-8'},
  );
}

/// Respuesta de error al estilo Google API — `DetailedApiRequestError`
/// (paquete `googleapis`) la reconstruye desde este JSON: `status` decide
/// tanto el código HTTP como `error.code` (los usa `_isPermissionError` en
/// `drive_service.dart`: 404 siempre cuenta como error de permiso, 403 solo
/// si el `reason` está en la lista confirmada — aquí no hace falta acertar
/// esa lista porque 404 basta para `SharedAccessRevokedException`).
http.StreamedResponse driveErrorResponse(int status, {String reason = 'notFound'}) {
  final body = {
    'error': {
      'code': status,
      'message': 'fake error ($reason)',
      'errors': [
        {'reason': reason},
      ],
    },
  };
  final bytes = utf8.encode(jsonEncode(body));
  return http.StreamedResponse(
    Stream.value(bytes),
    status,
    headers: {'content-type': 'application/json; charset=utf-8'},
  );
}

/// Respuesta de descarga de contenido (`downloadOptions: fullMedia`) — el
/// cliente googleapis exige una cabecera `content-type` (la usa para decidir
/// que es un `Media`, no JSON) — ver `_discoveryapis_commons/api_requester.dart`.
http.StreamedResponse mediaResponse(String content) {
  final bytes = utf8.encode(content);
  return http.StreamedResponse(
    Stream.value(bytes),
    200,
    headers: {
      'content-type': 'application/octet-stream',
      'content-length': '${bytes.length}',
    },
  );
}

/// XML mínimo de `SaveGameInfo` compatible con
/// `SaveService.parseSaveGameInfo` (mismos tags que
/// `test/fixtures/coop_save_fixture.dart`, pero parametrizable en
/// día/temporada/año para poder decidir a propósito qué lado "va por
/// delante" en las comparaciones de peligro (D4/D5, spec 008).
String fakeSaveGameInfoXml({
  required String playerName,
  required String farmName,
  int season = 0,
  int dayOfMonth = 5,
  int year = 1,
  int money = 500,
  int totalMoneyEarned = 500,
  int millisecondsPlayed = 100000,
  bool isCoop = false,
}) =>
    '''<?xml version="1.0" encoding="utf-8"?>
<$playerName>
  <name>$playerName</name>
  <farmName>$farmName</farmName>
  <slotCanHost>${isCoop ? 'true' : 'false'}</slotCanHost>
  <useSeparateWallets>false</useSeparateWallets>
  <seasonForSaveGame>$season</seasonForSaveGame>
  <dayOfMonthForSaveGame>$dayOfMonth</dayOfMonthForSaveGame>
  <yearForSaveGame>$year</yearForSaveGame>
  <gameVersion>1.6.15</gameVersion>
  <money>$money</money>
  <totalMoneyEarned>$totalMoneyEarned</totalMoneyEarned>
  <millisecondsPlayed>$millisecondsPlayed</millisecondsPlayed>
</$playerName>''';

/// Construye el manejador HTTP falso para el escenario "una partida
/// compartida coop, Mi Drive sin copia (`missing`), Drive del dueño con o
/// sin copia según [ownerInfoXml]" — el único que necesitan T822/T823 (ver
/// spec 008 tasks.md). Cubre TODA la secuencia de requests que dispara
/// `_load()` → `_loadSharedSaves()` (T822/T823 no necesitan que "Mis
/// partidas" tenga contenido: en los dos escenarios ownDrive se queda
/// `missing`, así que `listSaveSummaries()` siempre responde vacío).
///
/// [uploadPermissionResponse] controla la ÚNICA llamada que decide
/// G2 (`SharedAccessRevokedException`/`SharedAccessReadOnlyException`): el
/// `files.get(folderId, fields: 'capabilities(canEdit)')` que hace
/// `DriveService.uploadToSharedSave` ANTES de tocar ningún archivo — se
/// distingue de la comprobación de rol de `listSharedSaves` (que pide más
/// campos: `trashed`, `owners`) por tener `fields` EXACTAMENTE
/// `'capabilities(canEdit)'`.
http.StreamedResponse Function(http.BaseRequest) buildSharedDriveHandler({
  required String rootFolderId,
  required String sharedFolderId,
  required String folderName,
  required String ownerEmail,
  required String myEmail,
  List<Map<String, Object?>> ownerFolderChildren = const [],
  String? ownerInfoXml,
  http.StreamedResponse Function()? uploadPermissionResponse,
}) {
  return (request) {
    final url = request.url;
    final method = request.method;
    final q = url.queryParameters['q'] ?? '';
    final fields = url.queryParameters['fields'] ?? '';
    final alt = url.queryParameters['alt'];

    if (url.path.contains('/about')) {
      return jsonResponse({
        'user': {'emailAddress': myEmail},
      });
    }

    // ensureFolder(): busca la carpeta raíz "ValleySave".
    if (method == 'GET' && q.contains("name='ValleySave'")) {
      return jsonResponse({
        'files': [
          {'id': rootFolderId},
        ],
      });
    }

    // _ensureReadme (fire-and-forget tras ensureFolder): responder "ya
    // existe" para que NUNCA intente crearlo (no hay handler de creación).
    if (method == 'GET' && q.contains('LEEME')) {
      return jsonResponse({
        'files': [
          {'id': 'readme-existing'},
        ],
      });
    }

    // listSaveSummaries(): hijos de la carpeta raíz — "Mis partidas" se
    // queda vacío en TODOS los escenarios de T822/T823 (Mi Drive = missing).
    if (method == 'GET' && q.contains("'$rootFolderId' in parents")) {
      return jsonResponse({'files': []});
    }

    // listSharedFolders() (auto-detección, T por T no necesitamos que
    // encuentre nada — el registro ya trae la entrada compartida).
    if (method == 'GET' && q.contains('sharedWithMe')) {
      return jsonResponse({'files': [], 'nextPageToken': null});
    }

    // listSharedSaves(): refresco de rol/estado por entrada del registro.
    if (method == 'GET' &&
        url.path.contains(sharedFolderId) &&
        fields.contains('trashed') &&
        fields.contains('owners')) {
      return jsonResponse({
        'id': sharedFolderId,
        'name': folderName,
        'trashed': false,
        'capabilities': {'canEdit': true},
        'owners': [
          {'emailAddress': ownerEmail},
        ],
      });
    }

    // _resolveContent(sharedFolderId): hijos de la carpeta compartida.
    if (method == 'GET' && q.contains("'$sharedFolderId' in parents")) {
      return jsonResponse({'files': ownerFolderChildren});
    }

    // Descarga de SaveGameInfo del dueño (solo si ownerFolderChildren lo
    // incluye — ver `ownerInfoXml`).
    if (method == 'GET' && alt == 'media' && url.path.contains('owner-info')) {
      return mediaResponse(ownerInfoXml ?? '');
    }

    // uploadToSharedSave(): comprobación de permiso ANTES de tocar nada —
    // aquí es donde G2 decide revocado/solo-lectura/éxito.
    if (method == 'GET' &&
        url.path.contains(sharedFolderId) &&
        fields == 'capabilities(canEdit)') {
      return (uploadPermissionResponse ??
          () => jsonResponse({
            'capabilities': {'canEdit': true},
          }))();
    }

    fail('Request de Drive falso sin manejar: $method $url');
  };
}
