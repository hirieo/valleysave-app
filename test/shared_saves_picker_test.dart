import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:googleapis_auth/googleapis_auth.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:valleysave/core/models/player_stats.dart';
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
    // Un cliente real consume el cuerpo antes de responder. Hacerlo también
    // aquí libera los streams de File.openRead() en Windows y permite que los
    // temporales de las pruebas de subida se eliminen correctamente.
    await request.finalize().drain<void>();
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

/// `listSharedSaves`/`listSharedFolders` consultan `about.get` una vez al
/// principio para descartar auto-compartidos contigo mismo — toda prueba que
/// llame a cualquiera de los dos necesita esta respuesta como la PRIMERA.
http.StreamedResponse _aboutResponse() =>
    _json({'user': {'emailAddress': 'me@example.com'}});

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

PlayerStats _player(String name, String id, {bool host = false}) =>
    PlayerStats.fromJson({'name': name, 'uniqueId': id, 'isHost': host});

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
          // Resuelve la clave por cuenta al guardar el registro (2026-07-15).
          _aboutResponse(),
        ]);
        final service = DriveService(client);

        final entry = await service.addSharedSave('f1');

        expect(entry.myRole, 'writer');
        expect(entry.folderName, 'Ajena');
        expect(entry.ownerEmail, 'owner@example.com');
        expect(entry.driveStats, isNotNull);

        final prefs = await SharedPreferences.getInstance();
        final stored =
            jsonDecode(
                  prefs.getString('shared_saves_registry::me@example.com')!,
                )
                as List;
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
          'shared_saves_registry::me@example.com': jsonEncode([
            {
              'folderId': 'f1',
              'folderName': 'Ajena',
              'ownerEmail': 'owner@example.com',
            },
          ]),
        });
        final client = _QueueAuthClient([
          _aboutResponse(),
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
          'shared_saves_registry::me@example.com': jsonEncode([
            {
              'folderId': 'f1',
              'folderName': 'Ajena',
              'ownerEmail': 'owner@example.com',
            },
          ]),
        });
        final client = _QueueAuthClient([
          _aboutResponse(),
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

    test(
      'un 404 conserva el registro para no ocultar una compartida',
      () async {
        SharedPreferences.setMockInitialValues({
          'shared_saves_registry::me@example.com': jsonEncode([
            {
              'folderId': 'f1',
              'folderName': 'Ajena',
              'ownerEmail': 'owner@example.com',
            },
          ]),
        });
        final client = _QueueAuthClient([
          _aboutResponse(),
          _json({
            'error': {
              'code': 404,
              'message': 'File not found',
              'errors': [
                {'reason': 'notFound'},
              ],
            },
          }, status: 404),
        ]);
        final service = DriveService(client);

        final result = await service.listSharedSaves();

        expect(result, hasLength(1));
        expect(result.single.ownerDriveVerified, isFalse);
        final prefs = await SharedPreferences.getInstance();
        final stored =
            jsonDecode(prefs.getString('shared_saves_registry::me@example.com')!) as List;
        expect(stored, hasLength(1));
      },
    );

    test('un 403 de cuota queda sin comprobar, nunca revocado', () async {
      SharedPreferences.setMockInitialValues({
        'shared_saves_registry::me@example.com': jsonEncode([
          {
            'folderId': 'f1',
            'folderName': 'Ajena',
            'ownerEmail': 'owner@example.com',
          },
        ]),
      });
      final client = _QueueAuthClient([
        _aboutResponse(),
        _json({
          'error': {
            'code': 403,
            'message': 'rate limit',
            'errors': [
              {'reason': 'rateLimitExceeded'},
            ],
          },
        }, status: 403),
      ]);

      final result = await DriveService(client).listSharedSaves();

      expect(result, hasLength(1));
      expect(result.single.revoked, isFalse);
      expect(result.single.ownerDriveVerified, isFalse);
      final prefs = await SharedPreferences.getInstance();
      final stored =
          jsonDecode(prefs.getString('shared_saves_registry::me@example.com')!) as List;
      expect(stored, hasLength(1));
      expect(
        (stored.single as Map)['unavailableSince'],
        isNotNull,
        reason: 'la primera vez que falla se marca el inicio de la racha',
      );
    });

    test(
      'un segundo 403 dentro de las 24h sigue sin revocar',
      () async {
        SharedPreferences.setMockInitialValues({
          'shared_saves_registry::me@example.com': jsonEncode([
            {
              'folderId': 'f1',
              'folderName': 'Ajena',
              'ownerEmail': 'owner@example.com',
              'unavailableSince': DateTime.now()
                  .toUtc()
                  .subtract(const Duration(hours: 1))
                  .toIso8601String(),
            },
          ]),
        });
        final client = _QueueAuthClient([
          _aboutResponse(),
          _json({
            'error': {'code': 403, 'message': 'rate limit'},
          }, status: 403),
        ]);

        final result = await DriveService(client).listSharedSaves();

        expect(result.single.revoked, isFalse);
        expect(result.single.ownerDriveVerified, isFalse);
      },
    );

    test(
      'un 403 tras 24h ININTERRUMPIDAS de fallo NUNCA revoca — puede ser '
      'cuota/red, Drive ya usa 404 para "sin ningún acceso" '
      '(2026-07-15, corrección tras comparar con Codex)',
      () async {
        SharedPreferences.setMockInitialValues({
          'shared_saves_registry::me@example.com': jsonEncode([
            {
              'folderId': 'f1',
              'folderName': 'Ajena',
              'ownerEmail': 'owner@example.com',
              'unavailableSince': DateTime.now()
                  .toUtc()
                  .subtract(const Duration(hours: 25))
                  .toIso8601String(),
            },
          ]),
        });
        final client = _QueueAuthClient([
          _aboutResponse(),
          _json({
            'error': {'code': 403, 'message': 'forbidden'},
          }, status: 403),
        ]);

        final result = await DriveService(client).listSharedSaves();

        expect(result.single.revoked, isFalse);
      },
    );

    test(
      'un 404 tras 24h ININTERRUMPIDAS de ausencia SÍ se da por revocado',
      () async {
        SharedPreferences.setMockInitialValues({
          'shared_saves_registry::me@example.com': jsonEncode([
            {
              'folderId': 'f1',
              'folderName': 'Ajena',
              'ownerEmail': 'owner@example.com',
              'missingSince': DateTime.now()
                  .toUtc()
                  .subtract(const Duration(hours: 25))
                  .toIso8601String(),
            },
          ]),
        });
        final client = _QueueAuthClient([
          _aboutResponse(),
          _json({
            'error': {'code': 404, 'message': 'File not found'},
          }, status: 404),
        ]);

        final result = await DriveService(client).listSharedSaves();

        expect(result.single.revoked, isTrue);
      },
    );

    test(
      'un 403 no reinicia ni sustituye una racha de 404 ya en curso',
      () async {
        SharedPreferences.setMockInitialValues({
          'shared_saves_registry::me@example.com': jsonEncode([
            {
              'folderId': 'f1',
              'folderName': 'Ajena',
              'ownerEmail': 'owner@example.com',
              'missingSince': DateTime.now()
                  .toUtc()
                  .subtract(const Duration(hours: 1))
                  .toIso8601String(),
            },
          ]),
        });
        final client = _QueueAuthClient([
          _aboutResponse(),
          _json({
            'error': {'code': 403, 'message': 'rate limit'},
          }, status: 403),
        ]);

        final result = await DriveService(client).listSharedSaves();

        expect(result.single.revoked, isFalse);
        final prefs = await SharedPreferences.getInstance();
        final stored =
            jsonDecode(
                  prefs.getString('shared_saves_registry::me@example.com')!,
                )
                as List;
        expect(
          (stored.single as Map)['missingSince'],
          isNull,
          reason:
              'un 403 no es señal de ausencia — limpia la racha de 404 en '
              'curso en vez de dejarla avanzar hacia una revocación falsa',
        );
      },
    );

    test('carpeta en papelera revoca al momento, sin esperar 24h', () async {
      SharedPreferences.setMockInitialValues({
        'shared_saves_registry::me@example.com': jsonEncode([
          {
            'folderId': 'f1',
            'folderName': 'Ajena',
            'ownerEmail': 'owner@example.com',
          },
        ]),
      });
      final client = _QueueAuthClient([
        _aboutResponse(),
        _json({
          'id': 'f1',
          'name': 'Ajena',
          'trashed': true,
          'capabilities': {'canEdit': true},
          'owners': [
            {'emailAddress': 'owner@example.com'},
          ],
        }),
      ]);

      final result = await DriveService(client).listSharedSaves();

      expect(result.single.revoked, isTrue);
    });

    test(
      'una comprobación con éxito borra la racha de fallos previa',
      () async {
        SharedPreferences.setMockInitialValues({
          'shared_saves_registry::me@example.com': jsonEncode([
            {
              'folderId': 'f1',
              'folderName': 'Ajena',
              'ownerEmail': 'owner@example.com',
              'unavailableSince': DateTime.now()
                  .toUtc()
                  .subtract(const Duration(hours: 20))
                  .toIso8601String(),
            },
          ]),
        });
        final client = _QueueAuthClient([
          _aboutResponse(),
          _json({
            'id': 'f1',
            'name': 'Ajena',
            'trashed': false,
            'capabilities': {'canEdit': true},
            'owners': [
              {'emailAddress': 'owner@example.com'},
            ],
          }),
          _json({'files': []}),
        ]);

        final result = await DriveService(client).listSharedSaves();

        expect(result.single.revoked, isFalse);
        expect(result.single.ownerDriveVerified, isTrue);
        final prefs = await SharedPreferences.getInstance();
        final stored =
            jsonDecode(prefs.getString('shared_saves_registry::me@example.com')!) as List;
        expect(
          (stored.single as Map)['unavailableSince'],
          isNull,
          reason: 'un éxito reinicia la racha, aunque llevara casi 24h',
        );
      },
    );

    test(
      'un 500 de Drive queda sin comprobar y conserva el registro',
      () async {
        SharedPreferences.setMockInitialValues({
          'shared_saves_registry::me@example.com': jsonEncode([
            {
              'folderId': 'f1',
              'folderName': 'Ajena',
              'ownerEmail': 'owner@example.com',
            },
          ]),
        });
        final client = _QueueAuthClient([
          _aboutResponse(),
          _json({
            'error': {'code': 500, 'message': 'backend error'},
          }, status: 500),
        ]);

        final result = await DriveService(client).listSharedSaves();

        expect(result.single.revoked, isFalse);
        expect(result.single.ownerDriveVerified, isFalse);
        final prefs = await SharedPreferences.getInstance();
        final stored =
            jsonDecode(
                  prefs.getString('shared_saves_registry::me@example.com')!,
                )
                as List;
        expect(
          (stored.single as Map)['missingSince'],
          isNull,
          reason:
              'un 500 no es señal de ausencia — solo un 404 puede iniciar '
              'la racha que confirma revocación',
        );
      },
    );

    test(
      'una racha de 500 ininterrumpida más de 24h NUNCA revoca '
      '(solo 403/404 cuentan para la racha, ver corrección 2026-07-15)',
      () async {
        SharedPreferences.setMockInitialValues({
          'shared_saves_registry::me@example.com': jsonEncode([
            {
              'folderId': 'f1',
              'folderName': 'Ajena',
              'ownerEmail': 'owner@example.com',
              // Si el código antiguo (sin filtrar por status) viera esto,
              // confirmaría revocación con un simple 500 aunque nunca haya
              // habido una señal real de permiso denegado.
              'unavailableSince': DateTime.now()
                  .toUtc()
                  .subtract(const Duration(hours: 48))
                  .toIso8601String(),
            },
          ]),
        });
        final client = _QueueAuthClient([
          _aboutResponse(),
          _json({
            'error': {'code': 500, 'message': 'backend error'},
          }, status: 500),
        ]);

        final result = await DriveService(client).listSharedSaves();

        expect(result.single.revoked, isFalse);
        expect(result.single.ownerDriveVerified, isFalse);
      },
    );

    test(
      'si la carpeta existe pero falla SaveGameInfo no dice que desapareció',
      () async {
        SharedPreferences.setMockInitialValues({
          'shared_saves_registry::me@example.com': jsonEncode([
            {
              'folderId': 'f1',
              'folderName': 'Ajena',
              'ownerEmail': 'owner@example.com',
            },
          ]),
        });
        final client = _QueueAuthClient([
          _aboutResponse(),
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
            ],
          }),
          _json({
            'error': {
              'code': 403,
              'message': 'rate limit',
              'errors': [
                {'reason': 'rateLimitExceeded'},
              ],
            },
          }, status: 403),
        ]);

        final result = await DriveService(client).listSharedSaves();

        expect(result.single.revoked, isFalse);
        expect(result.single.ownerDrivePresent, isTrue);
        expect(result.single.ownerDriveVerified, isFalse);
        expect(result.single.driveStats, isNull);
      },
    );

    test(
      'fallo al listar hijos NUNCA revoca aunque la racha lleve días — la '
      'carpeta en sí ya se confirmó accesible (2026-07-15, corrección: '
      'antes SÍ contaba para la misma racha de 24h)',
      () async {
        SharedPreferences.setMockInitialValues({
          'shared_saves_registry::me@example.com': jsonEncode([
            {
              'folderId': 'f1',
              'folderName': 'Ajena',
              'ownerEmail': 'owner@example.com',
              'unavailableSince': DateTime.now()
                  .toUtc()
                  .subtract(const Duration(days: 10))
                  .toIso8601String(),
            },
          ]),
        });
        final client = _QueueAuthClient([
          _aboutResponse(),
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
            'error': {'code': 500, 'message': 'backend error'},
          }, status: 500),
        ]);

        final result = await DriveService(client).listSharedSaves();

        expect(result.single.revoked, isFalse);
      },
    );
  });

  group('removeSharedSave (G8)', () {
    test(
      'G8: no toca Drive, solo el email (para la clave por cuenta) y borra '
      'el registro local de esa cuenta',
      () async {
        SharedPreferences.setMockInitialValues({
          'shared_saves_registry::me@example.com': jsonEncode([
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
        final client = _QueueAuthClient([_aboutResponse()]);
        final service = DriveService(client);

        await service.removeSharedSave('f1');

        // Una sola llamada (about.get, para resolver la clave por cuenta) —
        // cacheada, así que cargar Y guardar el registro no la duplican.
        expect(client.requests, hasLength(1));
        final prefs = await SharedPreferences.getInstance();
        final stored =
            jsonDecode(
                  prefs.getString('shared_saves_registry::me@example.com')!,
                )
                as List;
        expect(stored, hasLength(1));
        expect(stored.first['folderId'], 'f2');
      },
    );

    test(
      'G8b: si el email ya estaba cacheado, no hace ninguna llamada de red',
      () async {
        SharedPreferences.setMockInitialValues({
          'shared_saves_registry::me@example.com': jsonEncode([
            {
              'folderId': 'f1',
              'folderName': 'Ajena',
              'ownerEmail': 'owner@example.com',
            },
          ]),
        });
        final client = _QueueAuthClient([_aboutResponse()]);
        final service = DriveService(client);
        await service.myEmail(); // simula el warm-up que ya hace la pantalla

        await service.removeSharedSave('f1');

        expect(client.requests, hasLength(1)); // solo el warm-up de arriba
      },
    );
  });

  group('registro por cuenta (2026-07-15)', () {
    test(
      'una vez cacheado el email, addSharedSave escribe en la clave de esa '
      'cuenta sin tocar el registro de otra cuenta ya guardado',
      () async {
        SharedPreferences.setMockInitialValues({
          // Registro previo de OTRA cuenta que alternó en este dispositivo —
          // no debe verse afectado ni mezclado.
          'shared_saves_registry::otra@example.com': jsonEncode([
            {
              'folderId': 'f-otra',
              'folderName': 'DeOtraCuenta',
              'ownerEmail': 'x@example.com',
            },
          ]),
        });
        final client = _QueueAuthClient([
          // listSharedSaves() con el registro de esta cuenta vacío consume
          // solo esta respuesta (about.get) y cachea myEmail() de paso.
          _aboutResponse(),
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

        // No hay registro aún para esta cuenta -> lista vacía, pero esto
        // cachea myEmail() antes de que addSharedSave toque el registro.
        await service.listSharedSaves();
        await service.addSharedSave('f1');

        final prefs = await SharedPreferences.getInstance();
        final mine =
            jsonDecode(
                  prefs.getString('shared_saves_registry::me@example.com')!,
                )
                as List;
        expect(mine, hasLength(1));
        expect(mine.single['folderId'], 'f1');

        final otherAccount =
            jsonDecode(
                  prefs.getString('shared_saves_registry::otra@example.com')!,
                )
                as List;
        expect(
          otherAccount,
          hasLength(1),
          reason: 'el registro de la otra cuenta no se pierde ni se mezcla',
        );
        expect(otherAccount.single['folderId'], 'f-otra');
      },
    );

    test(
      'migra el registro global de antes de escopar por cuenta a la clave '
      'de quien esté conectado ahora, en vez de vaciarse (2026-07-15)',
      () async {
        SharedPreferences.setMockInitialValues({
          // Dato de antes de la clave por cuenta — sin migrar, listSharedSaves
          // leería la clave escopada (vacía) y "Compartidas conmigo" parecería
          // vacío para alguien que sí tenía saves ahí antes de actualizar.
          'shared_saves_registry': jsonEncode([
            {
              'folderId': 'f-vieja',
              'folderName': 'DeAntesDeEscopar',
              'ownerEmail': 'owner@example.com',
            },
          ]),
        });
        final client = _QueueAuthClient([
          _aboutResponse(),
          _json({
            'error': {'code': 404, 'message': 'not found'},
          }, status: 404),
        ]);

        final result = await DriveService(client).listSharedSaves();

        expect(
          result,
          hasLength(1),
          reason: 'el registro viejo se migra en vez de perderse',
        );
        expect(result.single.folderId, 'f-vieja');

        final prefs = await SharedPreferences.getInstance();
        expect(
          prefs.getString('shared_saves_registry'),
          isNull,
          reason: 'la clave vieja se borra una vez migrada, no queda duplicada',
        );
        final migrated =
            jsonDecode(
                  prefs.getString('shared_saves_registry::me@example.com')!,
                )
                as List;
        expect(migrated.single['folderId'], 'f-vieja');
      },
    );

    test(
      'si ya hay registro propio, NO se sobrescribe con el global viejo',
      () async {
        SharedPreferences.setMockInitialValues({
          'shared_saves_registry': jsonEncode([
            {
              'folderId': 'f-vieja',
              'folderName': 'DeAntesDeEscopar',
              'ownerEmail': 'owner@example.com',
            },
          ]),
          'shared_saves_registry::me@example.com': jsonEncode([
            {
              'folderId': 'f-actual',
              'folderName': 'YaMigrada',
              'ownerEmail': 'owner@example.com',
            },
          ]),
        });
        final client = _QueueAuthClient([
          _aboutResponse(),
          _json({
            'error': {'code': 404, 'message': 'not found'},
          }, status: 404),
        ]);

        final result = await DriveService(client).listSharedSaves();

        expect(result.single.folderId, 'f-actual');
      },
    );
  });

  group('uploadToSharedSave (G6)', () {
    test(
      'G6: rol refrescado de solo lectura lanza read-only, sin subir nada '
      'ni tratarlo como revocación (Drive respondió con éxito)',
      () async {
        final client = _QueueAuthClient([
          _json({
            'capabilities': {'canEdit': false},
          }),
        ]);
        final service = DriveService(client);

        await expectLater(
          () => service.uploadToSharedSave('f1', 'C:/no/existe'),
          throwsA(isA<SharedAccessReadOnlyException>()),
        );
        expect(client.requests, hasLength(1));
      },
    );

    test(
      'G6b: un 403 con motivo explícito de permiso insuficiente sí es '
      'revocación (2026-07-15, corregido: antes bastaba el status 403 solo)',
      () async {
        final client = _QueueAuthClient([
          _json({
            'error': {
              'code': 403,
              'message': 'forbidden',
              'errors': [
                {'reason': 'insufficientFilePermissions'},
              ],
            },
          }, status: 403),
        ]);
        final service = DriveService(client);

        await expectLater(
          () => service.uploadToSharedSave('f1', 'C:/no/existe'),
          throwsA(isA<SharedAccessRevokedException>()),
        );
        expect(client.requests, hasLength(1));
      },
    );

    test(
      'G6d: un 403 sin motivo explícito NUNCA se trata como revocación — '
      'por defecto es ambiguo, no permiso denegado',
      () async {
        final client = _QueueAuthClient([
          _json({
            'error': {'code': 403, 'message': 'forbidden'},
          }, status: 403),
        ]);
        final service = DriveService(client);

        await expectLater(
          () => service.uploadToSharedSave('f1', 'C:/no/existe'),
          throwsA(
            allOf(
              isNot(isA<SharedAccessRevokedException>()),
              isNot(isA<SharedAccessReadOnlyException>()),
            ),
          ),
        );
      },
    );

    test(
      'G6c: un 403 de cuota/rate-limit al refrescar el rol NUNCA se trata '
      'como revocación — debe propagarse como error temporal, conservando '
      'la compartida (2026-07-15, corrección: antes CUALQUIER 403 revocaba)',
      () async {
        final client = _QueueAuthClient([
          _json({
            'error': {
              'code': 403,
              'message': 'rate limit',
              'errors': [
                {'reason': 'rateLimitExceeded'},
              ],
            },
          }, status: 403),
        ]);
        final service = DriveService(client);

        await expectLater(
          () => service.uploadToSharedSave('f1', 'C:/no/existe'),
          throwsA(
            allOf(
              isNot(isA<SharedAccessRevokedException>()),
              isNot(isA<SharedAccessReadOnlyException>()),
            ),
          ),
        );
        expect(client.requests, hasLength(1));
      },
    );

    test('sincroniza players.json al Drive compartido', () async {
      final tempDir = await Directory.systemTemp.createTemp('vs_shared_up_');
      addTearDown(() async {
        if (await tempDir.exists()) await tempDir.delete(recursive: true);
      });
      final folderName = tempDir.path.split(Platform.pathSeparator).last;
      await File(
        '${tempDir.path}${Platform.pathSeparator}SaveGameInfo',
      ).writeAsString(_infoXml);
      await File(
        '${tempDir.path}${Platform.pathSeparator}$folderName',
      ).writeAsString(_fullSaveXml);

      final client = _QueueAuthClient([
        _json({
          'capabilities': {'canEdit': true},
        }),
        _json({'files': []}),
        _json({'id': 'info'}),
        _json({'files': []}),
        _json({'id': 'main'}),
        _json({'files': []}),
        _json({'id': 'players'}),
      ]);

      await DriveService(client).uploadToSharedSave(
        'f1',
        tempDir.path,
        players: [_player('Amiga', '1', host: true), _player('Hirieo', '2')],
      );

      expect(client.requests, hasLength(7));
      expect(
        client.requests.where(
          (r) => r.url.path.contains('/upload/drive/v3/files'),
        ),
        hasLength(3),
      );
    });

    test('retira players.json coop antiguo si queda un jugador', () async {
      final client = _QueueAuthClient([
        _json({
          'capabilities': {'canEdit': true},
        }),
        _json({
          'files': [
            {'id': 'players-old'},
          ],
        }),
        _text('', status: 204),
      ]);

      await DriveService(client).uploadToSharedSave(
        'f1',
        'C:${Platform.pathSeparator}no${Platform.pathSeparator}existe',
        players: [_player('Amiga', '1', host: true)],
      );

      expect(client.requests, hasLength(3));
      expect(client.requests.last.method, 'DELETE');
    });
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

    test('no copia players.json dentro de la carpeta del juego', () async {
      final tempDir = await Directory.systemTemp.createTemp('vs_shared_meta_');
      addTearDown(() async {
        if (await tempDir.exists()) await tempDir.delete(recursive: true);
      });
      final client = _QueueAuthClient([
        _json({
          'files': [
            {'id': 'i1', 'name': 'SaveGameInfo'},
            {'id': 'p1', 'name': 'players.json'},
          ],
        }),
        _text(_infoXml),
      ]);

      await DriveService(client).downloadSharedSave('f1', tempDir.path);

      expect(
        await File(
          '${tempDir.path}${Platform.pathSeparator}SaveGameInfo',
        ).exists(),
        isTrue,
      );
      expect(
        await File(
          '${tempDir.path}${Platform.pathSeparator}players.json',
        ).exists(),
        isFalse,
      );
      expect(client.requests, hasLength(2));
    });
  });
}
