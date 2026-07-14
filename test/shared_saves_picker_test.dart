import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:googleapis_auth/googleapis_auth.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:valleysave/core/services/drive_service.dart';

/// [AuthClient] falso: responde con una respuesta enlatada por llamada, en
/// el ORDEN exacto en que `DriveService` las emite (conocido leyendo su
/// implementación) — sin llamadas reales a Google (contracts/shared_saves_picker.md).
class _QueueAuthClient extends http.BaseClient implements AuthClient {
  _QueueAuthClient(this._responses);
  final List<http.StreamedResponse> _responses;
  final List<http.BaseRequest> requests = [];
  int _i = 0;

  @override
  AccessCredentials get credentials => AccessCredentials(
    AccessToken(
      'Bearer',
      'fake-token',
      DateTime.now().toUtc().add(const Duration(hours: 1)),
    ),
    null,
    const ['https://www.googleapis.com/auth/drive.file'],
  );

  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) async {
    requests.add(request);
    if (_i >= _responses.length) {
      throw StateError(
        'No hay más respuestas enlatadas (petición ${_i + 1}: ${request.url})',
      );
    }
    return _responses[_i++];
  }
}

http.StreamedResponse _json(Object body, {int status = 200}) {
  final bytes = utf8.encode(jsonEncode(body));
  return http.StreamedResponse(
    Stream.value(bytes),
    status,
    headers: {'content-type': 'application/json; charset=utf-8'},
  );
}

http.StreamedResponse _text(String content, {int status = 200}) {
  final bytes = utf8.encode(content);
  return http.StreamedResponse(
    Stream.value(bytes),
    status,
    headers: {'content-type': 'text/plain; charset=utf-8'},
  );
}

const _infoXml = '''<?xml version="1.0" encoding="utf-8"?>
<Farmer>
  <name>Amiga</name>
  <farmName>Granja Compartida</farmName>
  <slotCanHost>true</slotCanHost>
  <useSeparateWallets>false</useSeparateWallets>
  <seasonForSaveGame>0</seasonForSaveGame>
  <dayOfMonthForSaveGame>1</dayOfMonthForSaveGame>
  <yearForSaveGame>1</yearForSaveGame>
  <money>0</money>
  <UniqueMultiplayerID>1234567890123456789</UniqueMultiplayerID>
</Farmer>''';

const _fullSaveXml = '''<SaveGame>
  <player><name>Amiga</name><UniqueMultiplayerID>1</UniqueMultiplayerID></player>
  <farmhands><Farmer><name>Hirieo</name><UniqueMultiplayerID>2</UniqueMultiplayerID></Farmer></farmhands>
</SaveGame>''';

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  group('addSharedSave (G1, G2)', () {
    test(
      'G1: rechaza una carpeta sin SaveGameInfo, sin persistir nada',
      () async {
        final client = _QueueAuthClient([
          _json({
            'id': 'f1',
            'name': 'Ajena',
            'trashed': false,
            'mimeType': 'application/vnd.google-apps.folder',
            'capabilities': {'canEdit': false},
            'owners': [
              {'emailAddress': 'owner@example.com'},
            ],
          }),
          _json({
            'files': [
              {'id': 'x1', 'name': 'readme.txt'},
            ],
          }),
        ]);
        final service = DriveService(client);

        await expectLater(() => service.addSharedSave('f1'), throwsStateError);

        final prefs = await SharedPreferences.getInstance();
        expect(prefs.getString('shared_saves_registry'), isNull);
      },
    );

    test(
      'G2: guarda el rol actual (writer) leído de capabilities.canEdit',
      () async {
        final client = _QueueAuthClient([
          _json({
            'id': 'f1',
            'name': 'Ajena',
            'trashed': false,
            'mimeType': 'application/vnd.google-apps.folder',
            'capabilities': {'canEdit': true},
            'owners': [
              {'emailAddress': 'owner@example.com'},
            ],
          }),
          _json({
            'files': [
              {'id': 'i1', 'name': 'SaveGameInfo'},
              {'id': 'm1', 'name': 'Ajena'},
            ],
          }),
          _text(_infoXml),
          _text(_fullSaveXml),
        ]);
        final service = DriveService(client);

        final entry = await service.addSharedSave('f1');

        expect(entry.myRole, 'writer');
        expect(entry.folderName, 'Ajena');
        expect(entry.ownerEmail, 'owner@example.com');
        expect(entry.driveStats, isNotNull);

        final prefs = await SharedPreferences.getInstance();
        final stored =
            jsonDecode(prefs.getString('shared_saves_registry')!) as List;
        expect(stored, hasLength(1));
        expect(stored.first['folderId'], 'f1');
      },
    );
  });

  group('listSharedSaves (G3, G4)', () {
    test(
      'G3: refresca el rol contra Drive aunque el registro no cambie',
      () async {
        SharedPreferences.setMockInitialValues({
          'shared_saves_registry': jsonEncode([
            {
              'folderId': 'f1',
              'folderName': 'Ajena',
              'ownerEmail': 'owner@example.com',
            },
          ]),
        });
        final client = _QueueAuthClient([
          _json({
            'id': 'f1',
            'name': 'Ajena',
            'trashed': false,
            'capabilities': {'canEdit': false},
            'owners': [
              {'emailAddress': 'owner@example.com'},
            ],
          }),
          _json({
            'files': [
              {'id': 'i1', 'name': 'SaveGameInfo'},
              {'id': 'm1', 'name': 'Ajena'},
            ],
          }),
          _text(_infoXml),
          _text(_fullSaveXml),
        ]);
        final service = DriveService(client);

        final result = await service.listSharedSaves();

        expect(result, hasLength(1));
        expect(result.single.myRole, 'reader');
        expect(result.single.revoked, isFalse);
        expect(result.single.driveStats!.players, hasLength(2));
      },
    );

    test(
      'carga players.json para conservar el selector en el Drive del dueño',
      () async {
        SharedPreferences.setMockInitialValues({
          'shared_saves_registry': jsonEncode([
            {
              'folderId': 'f1',
              'folderName': 'Ajena',
              'ownerEmail': 'owner@example.com',
            },
          ]),
        });
        final client = _QueueAuthClient([
          _json({
            'id': 'f1',
            'name': 'Ajena',
            'trashed': false,
            'capabilities': {'canEdit': true},
            'owners': [
              {'emailAddress': 'owner@example.com'},
            ],
          }),
          _json({
            'files': [
              {'id': 'i1', 'name': 'SaveGameInfo'},
              {'id': 'm1', 'name': 'Ajena'},
              {'id': 'p1', 'name': 'players.json'},
            ],
          }),
          _text(_infoXml),
          _text(
            jsonEncode({
              'players': [
                {'name': 'Amiga', 'isHost': true, 'uniqueId': '1'},
                {'name': 'Hirieo', 'isHost': false, 'uniqueId': '2'},
              ],
            }),
          ),
        ]);

        final result = await DriveService(client).listSharedSaves();

        expect(result.single.driveStats!.players, hasLength(2));
        expect(result.single.driveStats!.players.last.name, 'Hirieo');
      },
    );

    test('G4: acceso revocado (403) se marca revoked, no lanza', () async {
      SharedPreferences.setMockInitialValues({
        'shared_saves_registry': jsonEncode([
          {
            'folderId': 'f1',
            'folderName': 'Ajena',
            'ownerEmail': 'owner@example.com',
          },
        ]),
      });
      final client = _QueueAuthClient([
        _json({
          'error': {'code': 403, 'message': 'forbidden'},
        }, status: 403),
      ]);
      final service = DriveService(client);

      final result = await service.listSharedSaves();

      expect(result, hasLength(1));
      expect(result.single.revoked, isTrue);
      expect(result.single.folderName, 'Ajena');
    });
  });

  group('removeSharedSave (G8)', () {
    test(
      'G8: no hace ninguna llamada de red, solo borra el registro local',
      () async {
        SharedPreferences.setMockInitialValues({
          'shared_saves_registry': jsonEncode([
            {
              'folderId': 'f1',
              'folderName': 'Ajena',
              'ownerEmail': 'owner@example.com',
            },
            {
              'folderId': 'f2',
              'folderName': 'Otra',
              'ownerEmail': 'otro@example.com',
            },
          ]),
        });
        final client = _QueueAuthClient([]);
        final service = DriveService(client);

        await service.removeSharedSave('f1');

        expect(client.requests, isEmpty);
        final prefs = await SharedPreferences.getInstance();
        final stored =
            jsonDecode(prefs.getString('shared_saves_registry')!) as List;
        expect(stored, hasLength(1));
        expect(stored.first['folderId'], 'f2');
      },
    );
  });

  group('uploadToSharedSave (G6)', () {
    test(
      'G6: lanza si el rol refrescado no es writer, sin subir nada',
      () async {
        final client = _QueueAuthClient([
          _json({
            'capabilities': {'canEdit': false},
          }),
        ]);
        final service = DriveService(client);

        await expectLater(
          () => service.uploadToSharedSave('f1', 'C:/no/existe'),
          throwsStateError,
        );
        expect(client.requests, hasLength(1));
      },
    );
  });

  group('downloadSharedSave (G5)', () {
    test(
      'G5: descarga funciona igual sin importar el rol (delega en downloadSave)',
      () async {
        final tempDir = await Directory.systemTemp.createTemp('vs_shared_dl_');
        addTearDown(() async {
          if (await tempDir.exists()) await tempDir.delete(recursive: true);
        });

        final client = _QueueAuthClient([
          _json({
            'files': [
              {'id': 'i1', 'name': 'SaveGameInfo'},
            ],
          }),
          _text(_infoXml),
        ]);
        final service = DriveService(client);

        await service.downloadSharedSave('f1', tempDir.path);

        final downloaded = File(
          '${tempDir.path}${Platform.pathSeparator}SaveGameInfo',
        );
        expect(await downloaded.exists(), isTrue);
        expect(await downloaded.readAsString(), _infoXml);
      },
    );
  });
}
