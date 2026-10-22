import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:valleysave/core/models/mod_info.dart';
import 'package:valleysave/core/services/mod_update_service.dart';

void main() {
  const mod = ModInfo(
    uniqueId: 'Pathoschild.ContentPatcher',
    name: 'Content Patcher',
    author: 'Pathoschild',
    version: '2.4.1',
    kind: ModKind.csharp,
    folderPath: '',
    relativePath: 'ContentPatcher',
    updateKeys: ['Nexus:1915'],
  );

  test('respuesta con versión sugerida', () {
    final r = ModUpdateService.parseResponse(
      '[{"id":"Pathoschild.ContentPatcher","suggestedUpdate":'
      '{"version":"2.5.0","url":"https://x"},"errors":[]},'
      '{"id":"Otro","suggestedUpdate":null,"errors":[]}]',
    );
    expect(r.failed, isFalse);
    expect(r.updates, {'pathoschild.contentpatcher': '2.5.0'});
  });

  test('un fallo de red o HTTP nunca parece "al día"', () async {
    final down = MockClient((_) async => http.Response('nope', 503));
    final r = await ModUpdateService.instance.check(
      [mod],
      smapiVersion: '4.5.2',
      client: down,
    );
    expect(r.failed, isTrue);
    expect(r.error, 'HTTP 503');

    final broken = MockClient((_) async => throw http.ClientException('x'));
    final r2 = await ModUpdateService.instance.check(
      [mod],
      smapiVersion: '4.5.2',
      client: broken,
    );
    expect(r2.failed, isTrue);
    expect(ModUpdateService.parseResponse('{}').failed, isTrue);
  });

  test('envía todos los mods en una petición a la API de SMAPI', () async {
    late http.Request sent;
    final ok = MockClient((req) async {
      sent = req;
      return http.Response('[]', 200);
    });
    final r = await ModUpdateService.instance.check(
      [mod],
      smapiVersion: '4.5.2',
      client: ok,
    );
    expect(r.failed, isFalse);
    expect(sent.url.toString(), 'https://smapi.io/api/v4.5.2/mods');
    expect(sent.body, contains('"installedVersion":"2.4.1"'));
  });
}
