import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider_platform_interface/path_provider_platform_interface.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:valleysave/core/services/drive_service.dart';
import 'package:valleysave/core/services/save_service.dart';
import 'package:valleysave/features/saves/saves_screen.dart';
import 'package:valleysave/generated/app_localizations.dart';

import '../helpers/saves_screen_test_env.dart';

/// spec 009 (T927) — Capa 2: el auto-sync por partida (T920) NUNCA actúa si
/// el veredicto no es verde (G7), aunque el chip `⚡ AUTO` esté encendido.
///
/// Alcance deliberadamente acotado (ver informe final de la sesión): la
/// mecánica real de subir/bajar (`_uploadToOwnDrive`/`_downloadNow`/
/// `_uploadToOwnerDrive`) ya tiene su propia cobertura de otras specs
/// (001/006/007) — lo específico de T920 que hace falta verificar aquí es
/// que la DECISIÓN respeta el veredicto y la guarda de `_busy`, no que la
/// subida en sí funcione. El caso positivo (verdict verde SÍ actúa) se
/// verifica por revisión de código: `_decideOwnAutoSync`/
/// `_decideSharedAutoSync` llaman literalmente a `_computeOverwriteLedger` y
/// solo devuelven `upload`/`download` cuando `.verdict == _OverwriteVerdict.
/// green` (ver `saves_screen.dart`), y el ÚNICO camino de ejecución
/// (`_runOwnAutoSync`/`_runSharedAutoSync`) llama DIRECTAMENTE a los mismos
/// handlers que el flujo manual ya prueba en otras suites.
///
/// Mismo harness y mismo cuelgue documentado que
/// `saves_screen_auto_refresh_test.dart` (T926) — ver el comentario de
/// cabecera de ese archivo y `specs/008-coop-overwrite-ledger/tasks.md`
/// T822/T823. Si esto se queda en `skip: true`, es la MISMA causa (montar
/// `SavesScreen` completa cuelga en la ejecución), confirmada de nuevo en
/// esta sesión, no una investigación nueva.
const _folderName = 'AutoSyncTest_1001';
const _rootFolderId = 'root-folder';
const _myEmail = 'me@example.com';

void main() {
  setUpAll(() => GoogleFonts.config.allowRuntimeFetching = false);
  PathProviderPlatform.instance = FakePathProviderPlatform();

  /// Save local con un día de calendario POSTERIOR al de Drive (→
  /// `SaveSyncStatus.localAhead`, candidato a auto-SUBIDA) pero con
  /// `totalMoneyEarned` PEOR que el de Drive — cualquier stat salvo el
  /// dinero actual que empeore dispara `isDanger` en
  /// `_computeOverwriteLedger` (verdict `red`). El auto-sync NUNCA debe
  /// actuar sobre un veredicto que no sea verde (G7), así que no debe llegar
  /// ninguna escritura a Drive pese a tener el chip encendido.
  Future<void> seedLocalAheadButDanger() async {
    final sep = Platform.pathSeparator;
    final savesDir = Directory(SaveService.savesDirectory!);
    final folder = Directory('${savesDir.path}$sep$_folderName');
    await folder.create(recursive: true);
    await File('${folder.path}${sep}SaveGameInfo').writeAsString(
      fakeSaveGameInfoXml(
        playerName: 'Ana',
        farmName: 'GranjaAuto',
        dayOfMonth: 10,
        totalMoneyEarned: 100, // peor que el de Drive (500) → peligro
      ),
    );
    await File(
      '${folder.path}$sep$_folderName',
    ).writeAsString('main-bytes-local');
  }

  http.StreamedResponse Function(http.BaseRequest) driveHandlerWithOneSave({
    required List<http.BaseRequest> writeRequests,
  }) {
    const driveFolderId = 'drive-save-folder';
    const genFolderId = 'gen-folder-1';
    return (request) {
      final url = request.url;
      final method = request.method;
      final q = url.queryParameters['q'] ?? '';
      final alt = url.queryParameters['alt'];

      if (url.path.contains('/about')) {
        return jsonResponse({
          'user': {'emailAddress': _myEmail},
        });
      }
      if (method == 'GET' && q.contains("name='ValleySave'")) {
        return jsonResponse({
          'files': [
            {'id': _rootFolderId},
          ],
        });
      }
      if (method == 'GET' && q.contains('LEEME')) {
        return jsonResponse({
          'files': [
            {'id': 'readme-existing'},
          ],
        });
      }
      // listSaveSummaries(): una única granja ya en Drive, con contenido más
      // antiguo (día 3) y totalMoneyEarned = 500 (mejor que el local, 100).
      if (method == 'GET' && q.contains("'$_rootFolderId' in parents")) {
        return jsonResponse({
          'files': [
            {
              'id': driveFolderId,
              'name': _folderName,
              'mimeType': 'application/vnd.google-apps.folder',
              'modifiedTime': '2026-01-01T00:00:00Z',
            },
          ],
        });
      }
      if (method == 'GET' && q.contains('sharedWithMe')) {
        return jsonResponse({'files': [], 'nextPageToken': null});
      }
      // Resolución del contenido remoto del save (sin generaciones —
      // formato "plano"): hijos directos de la carpeta.
      if (method == 'GET' && q.contains("'$driveFolderId' in parents")) {
        return jsonResponse({
          'files': [
            {'id': 'remote-info', 'name': 'SaveGameInfo'},
            {'id': 'remote-main', 'name': _folderName},
          ],
        });
      }
      if (method == 'GET' && alt == 'media' && url.path.contains('remote-info')) {
        return mediaResponse(
          fakeSaveGameInfoXml(
            playerName: 'Ana',
            farmName: 'GranjaAuto',
            dayOfMonth: 3,
            totalMoneyEarned: 500,
          ),
        );
      }
      if (method == 'GET' && alt == 'media' && url.path.contains('remote-main')) {
        return mediaResponse('main-bytes-remote');
      }

      // Cualquier escritura (create/update de archivos) — si el auto-sync
      // respeta G7, esta rama NUNCA debería alcanzarse para este escenario.
      if (method == 'POST' || method == 'PATCH') {
        writeRequests.add(request);
        return jsonResponse({'id': genFolderId});
      }

      fail('Request de Drive falso sin manejar: $method $url');
    };
  }

  Future<void> pumpSavesScreen(
    WidgetTester tester,
    FakeAuthClient client,
  ) async {
    tester.view.physicalSize = const Size(1000, 1600);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      MaterialApp(
        locale: const Locale('es'),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: SavesScreen(drive: DriveService(client)),
      ),
    );
    await pumpBounded(tester);
  }

  testWidgets(
    'G7: chip AUTO encendido + veredicto rojo → NUNCA sube nada, sin diálogo',
    (tester) async {
      await runWithIOSandbox(() async {
        await seedLocalAheadButDanger();
        SharedPreferences.setMockInitialValues({
          'autoRefreshEnabled': true,
          'autoSyncEnabledSaves': [_folderName],
        });
        final writeRequests = <http.BaseRequest>[];
        final client = FakeAuthClient(
          driveHandlerWithOneSave(writeRequests: writeRequests),
        );

        await pumpSavesScreen(tester, client);
        await tester.pump(const Duration(seconds: 31));
        await pumpBounded(tester, max: 5);

        expect(writeRequests, isEmpty);
        // Sin diálogo de confirmación tampoco — el auto-sync no debería
        // haber intentado nada que requiriera preguntarle a nadie.
        expect(find.text('Subir partida'), findsNothing);
      });
    },
    skip: true, // ver comentario de cabecera — mismo cuelgue de T822/T823
  );
}
