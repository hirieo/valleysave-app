import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:googleapis_auth/googleapis_auth.dart';
import 'package:http/http.dart' as http;
import 'package:valleysave/core/services/drive_service.dart';

/// [AuthClient] falso enrutado por CONTENIDO de la request (no por orden) —
/// necesario porque `ensureFolder()` dispara `_ensureReadme` en segundo
/// plano sin esperarlo (`.ignore()`), así que el orden exacto de llamadas no
/// es determinista. Cualquier request no reconocida recibe una respuesta
/// vacía inofensiva en vez de fallar el test.
class _FakeAuthClient extends http.BaseClient implements AuthClient {
  _FakeAuthClient(this._handler);
  final http.StreamedResponse? Function(http.BaseRequest request, String body) _handler;
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
    final body =
        request is http.Request ? request.body : utf8.decode(await request.finalize().toBytes());
    return _handler(request, body) ?? _json({'files': []});
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

void main() {
  group('uploadBackupZip / listDriveBackups (G6)', () {
    test('G6: sube el zip a ValleySave/Backups/, nunca a la subcarpeta de un save', () async {
      final tempDir = await Directory.systemTemp.createTemp('vs_backup_upload_');
      addTearDown(() async {
        if (await tempDir.exists()) await tempDir.delete(recursive: true);
      });
      final zip =
          File('${tempDir.path}${Platform.pathSeparator}Farm_pre-swap_20260101-000000.zip');
      await zip.writeAsBytes([1, 2, 3]);

      final client = _FakeAuthClient((request, body) {
        final q = request.url.queryParameters['q'] ?? '';
        if (request.method == 'GET' && q.contains("name='Backups'")) {
          return _json({
            'files': [
              {'id': 'backups-id', 'name': 'Backups'}
            ]
          });
        }
        if (request.method == 'GET' && q.contains("name='ValleySave'")) {
          return _json({
            'files': [
              {'id': 'root-id', 'name': 'ValleySave'}
            ]
          });
        }
        if (request.method == 'POST' && body.contains('"parents":["backups-id"]')) {
          return _json({'id': 'zip-id'});
        }
        return null; // resto (readme fire-and-forget) → respuesta vacía inofensiva
      });
      final service = DriveService(client);

      final id = await service.uploadBackupZip(zip.path);
      expect(id, 'zip-id');
    });

    test('listDriveBackups filtra por folderName y descarta nombres que no encajan',
        () async {
      final client = _FakeAuthClient((request, body) {
        final q = request.url.queryParameters['q'] ?? '';
        if (request.method == 'GET' && q.contains("name='Backups'")) {
          return _json({
            'files': [
              {'id': 'backups-id', 'name': 'Backups'}
            ]
          });
        }
        if (request.method == 'GET' && q.contains("name='ValleySave'")) {
          return _json({
            'files': [
              {'id': 'root-id', 'name': 'ValleySave'}
            ]
          });
        }
        if (request.method == 'GET' && q.contains("'backups-id' in parents")) {
          return _json({
            'files': [
              {
                'id': 'b1',
                'name': 'Farm_443121237_pre-swap_20260101-000000.zip',
                'size': '1024',
              },
              {
                'id': 'b2',
                'name': 'Other_999_pre-swap_20260102-000000.zip',
                'size': '2048',
              },
              {'id': 'b3', 'name': 'readme.txt', 'size': '10'},
            ],
          });
        }
        return null;
      });
      final service = DriveService(client);

      final result = await service.listDriveBackups(folderName: 'Farm_443121237');
      expect(result, hasLength(1));
      expect(result.single.driveFileId, 'b1');
      expect(result.single.sizeBytes, 1024);
    });
  });

  group('deleteDriveBackup', () {
    test('llama a files.delete directo, sin trashed:true', () async {
      final client = _FakeAuthClient((request, body) => null);
      final service = DriveService(client);

      await service.deleteDriveBackup('b1');

      final deleteReq = client.requests.firstWhere((r) => r.method == 'DELETE');
      expect(deleteReq.url.path, contains('b1'));
    });
  });
}
