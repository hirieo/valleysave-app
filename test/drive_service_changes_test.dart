// spec 009 (T925) — `getStartPageToken`/`listChanges` (Capa 1, Fuente 2:
// sondeo barato de Drive vía Changes API). Mismo patrón `_FakeAuthClient`
// que `test/drive_service_sharing_test.dart` — sin llamadas reales a Google.
// Reutiliza los helpers públicos ya construidos en
// `test/helpers/saves_screen_test_env.dart` (spec 008) en vez de duplicarlos.
import 'package:flutter_test/flutter_test.dart';
import 'package:valleysave/core/services/drive_service.dart';

import 'helpers/saves_screen_test_env.dart';

void main() {
  group('getStartPageToken', () {
    test('éxito: devuelve el startPageToken de la respuesta', () async {
      final client = FakeAuthClient((request) {
        expect(request.url.path, contains('changes/startPageToken'));
        return jsonResponse({'startPageToken': '12345'});
      });

      final token = await DriveService(client).getStartPageToken();

      expect(token, '12345');
    });

    test('fallo de red: propaga la excepción sin capturarla aquí', () async {
      final client = FakeAuthClient(
        (request) => driveErrorResponse(500, reason: 'backendError'),
      );

      expect(
        () => DriveService(client).getStartPageToken(),
        throwsA(anything),
      );
    });
  });

  group('listChanges', () {
    test(
      'éxito, una sola página: devuelve fileIds y el newPageToken',
      () async {
        final client = FakeAuthClient((request) {
          expect(request.url.path, contains('changes'));
          expect(request.url.queryParameters['pageToken'], 'start-token');
          return jsonResponse({
            'changes': [
              {'fileId': 'file-1'},
              {'fileId': 'file-2'},
            ],
            'newStartPageToken': 'next-token',
          });
        });

        final result = await DriveService(client).listChanges('start-token');

        expect(result.changedFileIds, ['file-1', 'file-2']);
        expect(result.newPageToken, 'next-token');
      },
    );

    test('sin cambios: changedFileIds vacío, newPageToken igual se persiste', () async {
      final client = FakeAuthClient(
        (request) => jsonResponse({'changes': [], 'newStartPageToken': 'same-token'}),
      );

      final result = await DriveService(client).listChanges('start-token');

      expect(result.changedFileIds, isEmpty);
      expect(result.newPageToken, 'same-token');
    });

    test('ignora cambios de tipo "drive" sin fileId (D5: no filtra por tipo, solo recoge fileId)', () async {
      final client = FakeAuthClient(
        (request) => jsonResponse({
          'changes': [
            {'fileId': 'file-1'},
            {'kind': 'drive#change', 'changeType': 'drive'},
          ],
          'newStartPageToken': 'next-token',
        }),
      );

      final result = await DriveService(client).listChanges('start-token');

      expect(result.changedFileIds, ['file-1']);
    });

    test('pagina internamente hasta agotar nextPageToken, acumulando fileIds', () async {
      var call = 0;
      final client = FakeAuthClient((request) {
        call++;
        final pageToken = request.url.queryParameters['pageToken'];
        if (call == 1) {
          expect(pageToken, 'start-token');
          return jsonResponse({
            'changes': [
              {'fileId': 'file-1'},
            ],
            'nextPageToken': 'page-2',
          });
        }
        expect(pageToken, 'page-2');
        return jsonResponse({
          'changes': [
            {'fileId': 'file-2'},
          ],
          'newStartPageToken': 'final-token',
        });
      });

      final result = await DriveService(client).listChanges('start-token');

      expect(call, 2);
      expect(result.changedFileIds, ['file-1', 'file-2']);
      expect(result.newPageToken, 'final-token');
    });

    test(
      'G5: fallo de red / token inválido o caducado propaga la excepción '
      '(el caller en saves_screen.dart decide pedir un token nuevo)',
      () async {
        final client = FakeAuthClient(
          (request) => driveErrorResponse(400, reason: 'invalid'),
        );

        expect(
          () => DriveService(client).listChanges('stale-token'),
          throwsA(anything),
        );
      },
    );
  });
}
