import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:googleapis_auth/googleapis_auth.dart';
import 'package:http/http.dart' as http;
import 'package:valleysave/core/services/drive_service.dart';

/// [AuthClient] falso que captura cada request y responde con JSON
/// enlatado — sin llamadas reales a Google (ver contracts/drive_service_sharing.md).
class _FakeAuthClient extends http.BaseClient implements AuthClient {
  _FakeAuthClient(this._handler);
  final http.StreamedResponse Function(http.BaseRequest request) _handler;
  final List<http.BaseRequest> requests = [];

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
    return _handler(request);
  }
}

http.StreamedResponse _jsonResponse(Object body, {int status = 200}) {
  final bytes = utf8.encode(jsonEncode(body));
  return http.StreamedResponse(
    Stream.value(bytes),
    status,
    headers: {'content-type': 'application/json; charset=utf-8'},
  );
}

http.StreamedResponse _emptyResponse({int status = 204}) {
  return http.StreamedResponse(const Stream.empty(), status);
}

Future<String> _bodyOf(http.BaseRequest request) async {
  if (request is http.Request) return request.body;
  final bytes = await request.finalize().toBytes();
  return utf8.decode(bytes);
}

void main() {
  group('listSharedFolders', () {
    test(
      'lista carpetas compartidas y conserva solo las que contienen un save',
      () async {
        final client = _FakeAuthClient((request) {
          if (request.url.path.contains('/about')) {
            return _jsonResponse({
              'user': {'emailAddress': 'me@example.com'},
            });
          }
          final q = request.url.queryParameters['q'] ?? '';
          if (q.contains('sharedWithMe')) {
            return _jsonResponse({
              'files': [
                {
                  'id': 'valid-folder',
                  'name': 'Stardust_1',
                  'mimeType': 'application/vnd.google-apps.folder',
                  'modifiedTime': '2026-07-13T10:00:00Z',
                  'owners': [
                    {'emailAddress': 'licendey@gmail.com'},
                  ],
                },
                {
                  'id': 'other-folder',
                  'name': 'Documentos',
                  'mimeType': 'application/vnd.google-apps.folder',
                  'modifiedTime': '2026-07-12T10:00:00Z',
                },
              ],
            });
          }
          if (q.contains("'valid-folder' in parents")) {
            return _jsonResponse({
              'files': [
                {'id': 'info-1', 'name': 'SaveGameInfo'},
              ],
            });
          }
          if (q.contains("'other-folder' in parents")) {
            return _jsonResponse({'files': []});
          }
          fail('Consulta inesperada: $q');
        });

        final folders = await DriveService(client).listSharedFolders();

        expect(folders.map((f) => f.id), ['valid-folder']);
        expect(folders.single.name, 'Stardust_1');
        expect(
          folders.single.owners!.single.emailAddress,
          'licendey@gmail.com',
        );
        expect(
          client.requests[1].url.queryParameters['q'],
          contains("mimeType='application/vnd.google-apps.folder'"),
        );
        expect(client.requests, hasLength(4));
      },
    );
  });

  group('shareSave (G1, G2)', () {
    test(
      'G1: crea permiso type=user con el rol pedido (reader por defecto)',
      () async {
        final client = _FakeAuthClient(
          (_) => _jsonResponse({
            'id': 'perm1',
            'type': 'user',
            'role': 'reader',
            'emailAddress': 'friend@example.com',
          }),
        );
        final service = DriveService(client);

        final id = await service.shareSave('folder123', 'friend@example.com');

        expect(id, 'perm1');
        expect(client.requests, hasLength(1));
        final req = client.requests.single;
        expect(req.method, 'POST');
        expect(req.url.path, contains('folder123'));
        expect(req.url.path, contains('permissions'));

        final body = jsonDecode(await _bodyOf(req)) as Map<String, dynamic>;
        expect(body['type'], 'user');
        expect(body['role'], 'reader');
        expect(body['emailAddress'], 'friend@example.com');
      },
    );

    test('G1b: acepta role=writer explícito (coop)', () async {
      final client = _FakeAuthClient(
        (_) => _jsonResponse({'id': 'perm2', 'type': 'user', 'role': 'writer'}),
      );
      final service = DriveService(client);

      await service.shareSave(
        'folder123',
        'friend@example.com',
        role: 'writer',
      );

      final body =
          jsonDecode(await _bodyOf(client.requests.single))
              as Map<String, dynamic>;
      expect(body['role'], 'writer');
    });

    test('G1c: rechaza un rol que no sea reader/writer', () async {
      final client = _FakeAuthClient((_) => _emptyResponse());
      final service = DriveService(client);

      expect(
        () => service.shareSave('folder123', 'x@example.com', role: 'owner'),
        throwsA(isA<AssertionError>()),
      );
    });

    test('G2: siempre pasa sendNotificationEmail=true', () async {
      final client = _FakeAuthClient(
        (_) => _jsonResponse({'id': 'perm1', 'type': 'user', 'role': 'reader'}),
      );
      final service = DriveService(client);

      await service.shareSave('folder123', 'friend@example.com');

      final req = client.requests.single;
      expect(req.url.queryParameters['sendNotificationEmail'], 'true');
    });
  });

  group('listPermissions (G3)', () {
    test('G3: excluye role=owner y expone el role de cada persona', () async {
      final client = _FakeAuthClient(
        (_) => _jsonResponse({
          'permissions': [
            {
              'id': 'p0',
              'type': 'user',
              'role': 'owner',
              'emailAddress': 'me@x.com',
            },
            {
              'id': 'p1',
              'type': 'user',
              'role': 'reader',
              'emailAddress': 'a@x.com',
            },
            {
              'id': 'p2',
              'type': 'user',
              'role': 'writer',
              'emailAddress': 'b@x.com',
            },
          ],
        }),
      );
      final service = DriveService(client);

      final result = await service.listPermissions('folder123');

      expect(result, hasLength(2));
      expect(result.map((p) => p.emailAddress), ['a@x.com', 'b@x.com']);
      expect(result.map((p) => p.role), ['reader', 'writer']);
    });
  });

  group('unshareSave (G4)', () {
    test(
      'G4: llama a permissions.delete con fileId y permissionId correctos',
      () async {
        final client = _FakeAuthClient((_) => _emptyResponse());
        final service = DriveService(client);

        await service.unshareSave('folder123', 'perm1');

        final req = client.requests.single;
        expect(req.method, 'DELETE');
        expect(req.url.path, contains('folder123'));
        expect(req.url.path, contains('perm1'));
      },
    );
  });

  group('updatePermission (G6)', () {
    test('G6: cambia el rol sin pasar sendNotificationEmail', () async {
      final client = _FakeAuthClient(
        (_) => _jsonResponse({'id': 'perm1', 'type': 'user', 'role': 'reader'}),
      );
      final service = DriveService(client);

      await service.updatePermission('folder123', 'perm1', 'reader');

      final req = client.requests.single;
      expect(req.url.path, contains('folder123'));
      expect(req.url.path, contains('perm1'));
      expect(
        req.url.queryParameters.containsKey('sendNotificationEmail'),
        isFalse,
      );

      final body = jsonDecode(await _bodyOf(req)) as Map<String, dynamic>;
      expect(body['role'], 'reader');
    });

    test('G6b: rechaza un rol que no sea reader/writer', () async {
      final client = _FakeAuthClient((_) => _emptyResponse());
      final service = DriveService(client);

      expect(
        () => service.updatePermission('folder123', 'perm1', 'owner'),
        throwsA(isA<AssertionError>()),
      );
    });
  });
}
