import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:googleapis_auth/googleapis_auth.dart';
import 'package:http/http.dart' as http;
import 'package:valleysave/core/services/drive_service.dart';

/// [AuthClient] falso enrutado por contenido de la request (método+url+query),
/// no por orden — necesario porque `uploadSave` genera nombres de carpeta de
/// generación basados en timestamp, impredecibles para un fake basado en
/// secuencia. Mismo patrón que `drive_service_sharing_test.dart`.
class _FakeAuthClient extends http.BaseClient implements AuthClient {
  _FakeAuthClient(this._handler);
  final Future<http.StreamedResponse> Function(http.BaseRequest request)
  _handler;
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

Future<String> _bodyOf(http.BaseRequest request) async {
  if (request is http.Request) return request.body;
  final bytes = await request.finalize().toBytes();
  return utf8.decode(bytes);
}

/// Extrae el JSON de metadata de una request multipart de `files.create` —
/// la primera parte del cuerpo (antes del contenido binario/base64).
Future<Map<String, dynamic>> _multipartMetadata(
  http.BaseRequest request,
) async {
  final body = await _bodyOf(request);
  final match = RegExp(
    r'\r?\n\r?\n(\{.*?\})\r?\n--',
    dotAll: true,
  ).firstMatch(body);
  if (match == null) fail('No se encontró metadata JSON en el multipart');
  return jsonDecode(match.group(1)!) as Map<String, dynamic>;
}

/// Extrae y decodifica el contenido base64 embebido en un multipart —
/// usado para leer `manifest.json` subido por `_publishManifest`.
Future<String> _multipartMediaContent(http.BaseRequest request) async {
  final body = await _bodyOf(request);
  final match = RegExp(
    r'Content-Transfer-Encoding: base64\r?\n\r?\n([A-Za-z0-9+/=]+)',
  ).firstMatch(body);
  if (match == null) fail('No se encontró contenido base64 en el multipart');
  return utf8.decode(base64.decode(match.group(1)!));
}

Future<Directory> _createLocalSave(
  Directory parent,
  String folderName, {
  bool withInfo = true,
  bool withMain = true,
}) async {
  final dir = Directory('${parent.path}${Platform.pathSeparator}$folderName');
  await dir.create(recursive: true);
  if (withInfo) {
    await File(
      '${dir.path}${Platform.pathSeparator}SaveGameInfo',
    ).writeAsString('<xml/>');
  }
  if (withMain) {
    await File(
      '${dir.path}${Platform.pathSeparator}$folderName',
    ).writeAsString('save-data');
  }
  return dir;
}

void main() {
  late Directory tempDir;

  setUp(() async {
    tempDir = await Directory.systemTemp.createTemp('drive_sync_test_');
  });

  tearDown(() async {
    if (await tempDir.exists()) await tempDir.delete(recursive: true);
  });

  group('uploadSave — validación local previa (FR-006)', () {
    test('falta SaveGameInfo → aborta ANTES de tocar Drive', () async {
      final localDir = await _createLocalSave(
        tempDir,
        'Granja_1',
        withInfo: false,
      );
      final client = _FakeAuthClient((_) async {
        fail('No debería llamar a Drive si falta SaveGameInfo');
      });

      await expectLater(
        DriveService(client).uploadSave(localDir.path, 'Granja_1'),
        throwsA(isA<UploadIncompleteSaveException>()),
      );
      expect(client.requests, isEmpty);
    });

    test('falta el archivo principal → aborta ANTES de tocar Drive', () async {
      final localDir = await _createLocalSave(
        tempDir,
        'Granja_1',
        withMain: false,
      );
      final client = _FakeAuthClient((_) async {
        fail('No debería llamar a Drive si falta el archivo principal');
      });

      await expectLater(
        DriveService(client).uploadSave(localDir.path, 'Granja_1'),
        throwsA(isA<UploadIncompleteSaveException>()),
      );
      expect(client.requests, isEmpty);
    });
  });

  group('uploadSave — saneado del par _old antes de subir (2026-07-19)', () {
    const validOldXml = '''<?xml version="1.0" encoding="utf-8"?>
<Farmer>
  <name>Ana</name>
  <farmName>Granja Test</farmName>
</Farmer>''';

    Future<void> writeOldPair(
      Directory localDir,
      String folderName, {
      required String infoOldContent,
      required String mainOldContent,
    }) async {
      final sep = Platform.pathSeparator;
      await File(
        '${localDir.path}${sep}SaveGameInfo_old',
      ).writeAsString(infoOldContent);
      await File(
        '${localDir.path}$sep${folderName}_old',
      ).writeAsString(mainOldContent);
    }

    _FakeAuthClient uploadOnlyClient(List<String> createdInGen) {
      var genFolderId = '';
      return _FakeAuthClient((request) async {
        final method = request.method;
        final path = request.url.path;
        final query = request.url.queryParameters;

        if (method == 'GET' &&
            path.endsWith('/files') &&
            (query['q'] ?? '').contains("name='ValleySave'")) {
          return _jsonResponse({
            'files': [
              {'id': 'root-id'},
            ],
          });
        }
        if (method == 'GET' &&
            path.endsWith('/files') &&
            (query['q'] ?? '').contains("name='Granja_1'") &&
            (query['q'] ?? '').contains("'root-id' in parents")) {
          return _jsonResponse({
            'files': [
              {'id': 'save-folder-id'},
            ],
          });
        }
        if (method == 'GET' &&
            path.endsWith('/files') &&
            (query['q'] ?? '').contains('gen_')) {
          return _jsonResponse({'files': []});
        }
        if (method == 'POST' &&
            path.endsWith('/drive/v3/files') &&
            !path.contains('/upload/')) {
          final meta = jsonDecode(await _bodyOf(request));
          final name = meta['name'] as String;
          if (name.startsWith('gen_')) {
            genFolderId = 'gen-new-id';
            return _jsonResponse({'id': genFolderId});
          }
          fail('POST metadata-only inesperado: $meta');
        }
        if (method == 'POST' && path.contains('/upload/drive/v3/files')) {
          final meta = await _multipartMetadata(request);
          if (meta['name'] == 'manifest.json') {
            return _jsonResponse({'id': 'manifest-id'});
          }
          createdInGen.add(meta['name'] as String);
          return _jsonResponse({'id': 'file-${meta['name']}'});
        }
        if (method == 'GET' &&
            path.endsWith('/files') &&
            (query['q'] ?? '').contains("name='manifest.json'")) {
          return _jsonResponse({'files': []});
        }
        if (method == 'GET' &&
            path.endsWith('/files') &&
            (query['q'] ?? '').contains("'save-folder-id' in parents") &&
            (query['q'] ?? '').contains('mimeType')) {
          return _jsonResponse({'files': []});
        }
        fail('Request inesperada: $method $path?${request.url.query}');
      });
    }

    test('_old completo y válido → se sube junto al resto', () async {
      final localDir = await _createLocalSave(tempDir, 'Granja_1');
      await writeOldPair(
        localDir,
        'Granja_1',
        infoOldContent: validOldXml,
        mainOldContent: 'save-data-old',
      );
      final createdInGen = <String>[];

      await DriveService(
        uploadOnlyClient(createdInGen),
      ).uploadSave(localDir.path, 'Granja_1');

      expect(
        createdInGen,
        containsAll(['SaveGameInfo', 'Granja_1', 'SaveGameInfo_old', 'Granja_1_old']),
      );
    });

    test(
      '_old corrupto → se omite de la subida sin tocar el origen local',
      () async {
        final localDir = await _createLocalSave(tempDir, 'Granja_1');
        await writeOldPair(
          localDir,
          'Granja_1',
          infoOldContent: 'esto no es xml válido de save',
          mainOldContent: 'save-data-old',
        );
        final createdInGen = <String>[];

        await DriveService(
          uploadOnlyClient(createdInGen),
        ).uploadSave(localDir.path, 'Granja_1');

        expect(createdInGen, containsAll(['SaveGameInfo', 'Granja_1']));
        expect(createdInGen, isNot(contains('SaveGameInfo_old')));
        expect(createdInGen, isNot(contains('Granja_1_old')));

        final sep = Platform.pathSeparator;
        expect(
          await File(
            '${localDir.path}${sep}SaveGameInfo_old',
          ).readAsString(),
          'esto no es xml válido de save',
        );
        expect(
          await File('${localDir.path}${sep}Granja_1_old').readAsString(),
          'save-data-old',
        );
      },
    );

    test(
      '_old incompleto (solo un archivo del par) → se omite de la subida',
      () async {
        final localDir = await _createLocalSave(tempDir, 'Granja_1');
        final sep = Platform.pathSeparator;
        await File(
          '${localDir.path}${sep}SaveGameInfo_old',
        ).writeAsString(validOldXml);
        // Falta 'Granja_1_old' — el par está incompleto.
        final createdInGen = <String>[];

        await DriveService(
          uploadOnlyClient(createdInGen),
        ).uploadSave(localDir.path, 'Granja_1');

        expect(createdInGen, isNot(contains('SaveGameInfo_old')));
        expect(createdInGen, isNot(contains('Granja_1_old')));
      },
    );
  });

  group('uploadSave — modelo generación + manifiesto (FR-006, FR-007)', () {
    test(
      'sube a gen_<ts>/, publica manifest.json y limpia generación previa',
      () async {
        final localDir = await _createLocalSave(tempDir, 'Granja_1');
        const rootId = 'root-id';
        const saveFolderId = 'save-folder-id';
        const oldGenId = 'gen-old-id';
        const manifestId = 'manifest-id';
        var genFolderId = '';
        final createdInGen = <String>[];

        final client = _FakeAuthClient((request) async {
          final method = request.method;
          final path = request.url.path;
          final query = request.url.queryParameters;

          // 1. ensureFolder(): busca ValleySave/
          if (method == 'GET' &&
              path.endsWith('/files') &&
              (query['q'] ?? '').contains("name='ValleySave'")) {
            return _jsonResponse({
              'files': [
                {'id': rootId},
              ],
            });
          }
          // 2. _ensureSaveFolder(): busca subcarpeta Granja_1 dentro de root
          if (method == 'GET' &&
              path.endsWith('/files') &&
              (query['q'] ?? '').contains("name='Granja_1'") &&
              (query['q'] ?? '').contains("'$rootId' in parents")) {
            return _jsonResponse({
              'files': [
                {'id': saveFolderId},
              ],
            });
          }
          // 3. _ensureSubfolder(gen_<ts>): no existe → se crea (metadata-only POST)
          if (method == 'POST' &&
              path.endsWith('/drive/v3/files') &&
              !path.contains('/upload/')) {
            final meta = jsonDecode(await _bodyOf(request));
            final name = meta['name'] as String;
            if (name.startsWith('gen_')) {
              genFolderId = 'gen-new-id';
              return _jsonResponse({'id': genFolderId});
            }
            fail('POST metadata-only inesperado: $meta');
          }
          // 3b. la propia búsqueda "existe gen_<ts>" antes de crearla
          if (method == 'GET' &&
              path.endsWith('/files') &&
              (query['q'] ?? '').contains('gen_')) {
            return _jsonResponse({'files': []});
          }
          // 4. subida multipart de SaveGameInfo / Granja_1 dentro de la generación
          if (method == 'POST' && path.contains('/upload/drive/v3/files')) {
            final meta = await _multipartMetadata(request);
            final parents = (meta['parents'] as List).cast<String>();
            if (meta['name'] == 'manifest.json') {
              expect(parents, [saveFolderId]);
              return _jsonResponse({'id': manifestId});
            }
            expect(parents, [genFolderId]);
            createdInGen.add(meta['name'] as String);
            return _jsonResponse({'id': 'file-${meta['name']}'});
          }
          // 5. publishManifest: busca si ya existe manifest.json
          if (method == 'GET' &&
              path.endsWith('/files') &&
              (query['q'] ?? '').contains("name='manifest.json'")) {
            return _jsonResponse({'files': []});
          }
          // 6. cleanupOldGenerations: lista subcarpetas del save
          if (method == 'GET' &&
              path.endsWith('/files') &&
              (query['q'] ?? '').contains("'$saveFolderId' in parents") &&
              (query['q'] ?? '').contains('mimeType')) {
            return _jsonResponse({
              'files': [
                {'id': oldGenId, 'name': 'gen_111'},
              ],
            });
          }
          // 7. cleanupOldGenerations: borra la generación vieja
          if (method == 'DELETE' && path.endsWith('/files/$oldGenId')) {
            return http.StreamedResponse(const Stream.empty(), 204);
          }
          fail('Request inesperada: $method $path?${request.url.query}');
        });

        await DriveService(client).uploadSave(localDir.path, 'Granja_1');

        expect(createdInGen, containsAll(['SaveGameInfo', 'Granja_1']));
        // Los `_old` son opcionales y no existen en este fixture.
        expect(createdInGen, isNot(contains('SaveGameInfo_old')));
      },
    );

    test('manifest.json ya existe → lo actualiza (update, no create)', () async {
      final localDir = await _createLocalSave(tempDir, 'Granja_1');
      const rootId = 'root-id';
      const saveFolderId = 'save-folder-id';
      const manifestId = 'existing-manifest-id';
      var genFolderId = '';
      var manifestUpdated = false;
      String? publishedGeneration;

      final client = _FakeAuthClient((request) async {
        final method = request.method;
        final path = request.url.path;
        final query = request.url.queryParameters;

        if (method == 'GET' &&
            path.endsWith('/files') &&
            (query['q'] ?? '').contains("name='ValleySave'")) {
          return _jsonResponse({
            'files': [
              {'id': rootId},
            ],
          });
        }
        if (method == 'GET' &&
            path.endsWith('/files') &&
            (query['q'] ?? '').contains("name='Granja_1'")) {
          return _jsonResponse({
            'files': [
              {'id': saveFolderId},
            ],
          });
        }
        if (method == 'GET' &&
            path.endsWith('/files') &&
            (query['q'] ?? '').contains('gen_')) {
          return _jsonResponse({'files': []});
        }
        if (method == 'POST' &&
            path.endsWith('/drive/v3/files') &&
            !path.contains('/upload/')) {
          genFolderId = 'gen-new-id';
          return _jsonResponse({'id': genFolderId});
        }
        if (method == 'POST' && path.contains('/upload/drive/v3/files')) {
          final meta = await _multipartMetadata(request);
          return _jsonResponse({'id': 'file-${meta['name']}'});
        }
        if (method == 'GET' &&
            path.endsWith('/files') &&
            (query['q'] ?? '').contains("name='manifest.json'")) {
          return _jsonResponse({
            'files': [
              {'id': manifestId},
            ],
          });
        }
        if (method == 'PATCH' &&
            path.contains('/upload/drive/v3/files/$manifestId')) {
          manifestUpdated = true;
          final content = await _multipartMediaContent(request);
          publishedGeneration =
              (jsonDecode(content) as Map)['activeGeneration'] as String?;
          return _jsonResponse({'id': manifestId});
        }
        if (method == 'GET' &&
            path.endsWith('/files') &&
            (query['q'] ?? '').contains("'$saveFolderId' in parents") &&
            (query['q'] ?? '').contains('mimeType')) {
          return _jsonResponse({'files': []});
        }
        fail('Request inesperada: $method $path?${request.url.query}');
      });

      await DriveService(client).uploadSave(localDir.path, 'Granja_1');

      expect(manifestUpdated, isTrue);
      expect(publishedGeneration, isNotNull);
      expect(publishedGeneration, startsWith('gen_'));
    });
  });

  group('downloadSaveToDir — resolución de generación (FR-009)', () {
    test('con manifest.json: descarga solo lo de la generación activa', () async {
      final destino = Directory(
        '${tempDir.path}${Platform.pathSeparator}destino',
      );
      const saveFolderId = 'save-folder-id';
      const genId = 'gen-active-id';

      final client = _FakeAuthClient((request) async {
        final method = request.method;
        final path = request.url.path;
        final query = request.url.queryParameters;

        if (method == 'GET' &&
            path.endsWith('/files') &&
            (query['q'] ?? '') == "'$saveFolderId' in parents and trashed=false") {
          return _jsonResponse({
            'files': [
              {'id': 'manifest-id', 'name': 'manifest.json'},
              {'id': genId, 'name': 'gen_222'},
              // Basura de una generación vieja que YA no debe descargarse:
              // no está en `children` de la generación activa.
            ],
          });
        }
        if (method == 'GET' && path.endsWith('/files/manifest-id')) {
          final bytes = utf8.encode(jsonEncode({'activeGeneration': 'gen_222'}));
          return http.StreamedResponse(
            Stream.value(bytes),
            200,
            headers: {'content-type': 'application/octet-stream'},
          );
        }
        if (method == 'GET' &&
            path.endsWith('/files') &&
            (query['q'] ?? '') == "'$genId' in parents and trashed=false") {
          return _jsonResponse({
            'files': [
              {'id': 'info-id', 'name': 'SaveGameInfo'},
              {'id': 'main-id', 'name': 'Granja_1'},
              {'id': 'players-id', 'name': 'players.json'},
            ],
          });
        }
        if (method == 'GET' && path.endsWith('/files/info-id')) {
          return http.StreamedResponse(
            Stream.value(utf8.encode('<xml/>')),
            200,
            headers: {'content-type': 'application/octet-stream'},
          );
        }
        if (method == 'GET' && path.endsWith('/files/main-id')) {
          return http.StreamedResponse(
            Stream.value(utf8.encode('save-data')),
            200,
            headers: {'content-type': 'application/octet-stream'},
          );
        }
        fail('Request inesperada: $method $path?${request.url.query}');
      });

      await DriveService(
        client,
      ).downloadSaveToDir(saveFolderId, 'Granja_1', destino);

      final downloaded = destino
          .listSync()
          .map((f) => f.path.split(Platform.pathSeparator).last)
          .toSet();
      expect(downloaded, {'SaveGameInfo', 'Granja_1'});
      expect(downloaded, isNot(contains('players.json')));
    });

    test('manifest AUSENTE → formato plano heredado (legítimo)', () async {
      final destino = Directory(
        '${tempDir.path}${Platform.pathSeparator}destino',
      );
      const saveFolderId = 'legacy-save-id';

      final client = _FakeAuthClient((request) async {
        final method = request.method;
        final path = request.url.path;
        final query = request.url.queryParameters;

        if (method == 'GET' &&
            path.endsWith('/files') &&
            (query['q'] ?? '') == "'$saveFolderId' in parents and trashed=false") {
          return _jsonResponse({
            'files': [
              {'id': 'info-id', 'name': 'SaveGameInfo'},
              {'id': 'main-id', 'name': 'Granja_1'},
            ],
          });
        }
        if (method == 'GET' && path.endsWith('/files/info-id')) {
          return http.StreamedResponse(
            Stream.value(utf8.encode('<xml/>')),
            200,
            headers: {'content-type': 'application/octet-stream'},
          );
        }
        if (method == 'GET' && path.endsWith('/files/main-id')) {
          return http.StreamedResponse(
            Stream.value(utf8.encode('save-data')),
            200,
            headers: {'content-type': 'application/octet-stream'},
          );
        }
        fail('Request inesperada: $method $path?${request.url.query}');
      });

      await DriveService(
        client,
      ).downloadSaveToDir(saveFolderId, 'Granja_1', destino);

      final downloaded = destino
          .listSync()
          .map((f) => f.path.split(Platform.pathSeparator).last)
          .toSet();
      expect(downloaded, {'SaveGameInfo', 'Granja_1'});
    });

    test(
      'manifest PRESENTE pero corrupto → CorruptManifestException (NO sirve el plano obsoleto)',
      () async {
        // Corrección tras comparar con Codex (2026-07-18): un save migrado a
        // generaciones deja archivos planos viejos en el nivel superior; si
        // el manifiesto se corrompe, servirlos silenciosamente mostraría una
        // partida obsoleta. La presencia del manifiesto obliga a error.
        final destino = Directory(
          '${tempDir.path}${Platform.pathSeparator}destino',
        );
        const saveFolderId = 'migrated-save-id';

        final client = _FakeAuthClient((request) async {
          final method = request.method;
          final path = request.url.path;
          final query = request.url.queryParameters;

          if (method == 'GET' &&
              path.endsWith('/files') &&
              (query['q'] ?? '') ==
                  "'$saveFolderId' in parents and trashed=false") {
            return _jsonResponse({
              'files': [
                // Archivos planos OBSOLETOS de antes de migrar.
                {'id': 'old-info-id', 'name': 'SaveGameInfo'},
                {'id': 'old-main-id', 'name': 'Granja_1'},
                // Manifiesto presente → la carpeta ya usa generaciones.
                {'id': 'manifest-id', 'name': 'manifest.json'},
              ],
            });
          }
          // El manifiesto se descarga pero es JSON inválido (corrupto).
          if (method == 'GET' && path.endsWith('/files/manifest-id')) {
            return http.StreamedResponse(
              Stream.value(utf8.encode('esto no es json {{{')),
              200,
              headers: {'content-type': 'application/octet-stream'},
            );
          }
          fail('Request inesperada: $method $path?${request.url.query}');
        });

        await expectLater(
          DriveService(
            client,
          ).downloadSaveToDir(saveFolderId, 'Granja_1', destino),
          throwsA(isA<CorruptManifestException>()),
        );
        // Y NO se descargó nada (ningún archivo plano obsoleto aterrizó).
        expect(destino.existsSync() ? destino.listSync() : const [], isEmpty);
      },
    );
  });

  group('listSaveSummaries — completitud (FR-015)', () {
    const validInfoXml = '''<?xml version="1.0" encoding="utf-8"?>
<Farmer>
  <name>Amiga</name>
  <farmName>Granja</farmName>
  <slotCanHost>true</slotCanHost>
  <useSeparateWallets>false</useSeparateWallets>
  <seasonForSaveGame>0</seasonForSaveGame>
  <dayOfMonthForSaveGame>1</dayOfMonthForSaveGame>
  <yearForSaveGame>1</yearForSaveGame>
  <money>0</money>
  <UniqueMultiplayerID>1234567890123456789</UniqueMultiplayerID>
</Farmer>''';

    Future<http.StreamedResponse> handleFor(
      http.BaseRequest request, {
      required String rootId,
      required String saveFolderId,
      required bool includeMain,
    }) async {
      final method = request.method;
      final path = request.url.path;
      final query = request.url.queryParameters;

      if (method == 'GET' &&
          path.endsWith('/files') &&
          (query['q'] ?? '').contains("name='ValleySave'")) {
        return _jsonResponse({
          'files': [
            {'id': rootId},
          ],
        });
      }
      if (method == 'GET' &&
          path.endsWith('/files') &&
          (query['q'] ?? '').contains("'$rootId' in parents") &&
          (query['q'] ?? '').contains('mimeType')) {
        return _jsonResponse({
          'files': [
            {'id': saveFolderId, 'name': 'Granja_1'},
          ],
        });
      }
      if (method == 'GET' &&
          path.endsWith('/files') &&
          (query['q'] ?? '') == "'$saveFolderId' in parents and trashed=false") {
        return _jsonResponse({
          'files': [
            {'id': 'info-id', 'name': 'SaveGameInfo'},
            if (includeMain) {'id': 'main-id', 'name': 'Granja_1'},
          ],
        });
      }
      if (method == 'GET' && path.endsWith('/files/info-id')) {
        return http.StreamedResponse(
          Stream.value(utf8.encode(validInfoXml)),
          200,
          headers: {'content-type': 'application/octet-stream'},
        );
      }
      fail('Request inesperada: $method $path?${request.url.query}');
    }

    test('falta el archivo principal → complete=false', () async {
      const rootId = 'root-id';
      const saveFolderId = 'save-folder-id';
      final client = _FakeAuthClient(
        (request) => handleFor(
          request,
          rootId: rootId,
          saveFolderId: saveFolderId,
          includeMain: false,
        ),
      );

      final summaries = await DriveService(client).listSaveSummaries();

      expect(summaries, hasLength(1));
      expect(summaries.single.complete, isFalse);
    });

    test('con archivo principal → complete=true', () async {
      const rootId = 'root-id';
      const saveFolderId = 'save-folder-id';
      final client = _FakeAuthClient(
        (request) => handleFor(
          request,
          rootId: rootId,
          saveFolderId: saveFolderId,
          includeMain: true,
        ),
      );

      final summaries = await DriveService(client).listSaveSummaries();

      expect(summaries, hasLength(1));
      expect(summaries.single.complete, isTrue);
    });
  });
}
