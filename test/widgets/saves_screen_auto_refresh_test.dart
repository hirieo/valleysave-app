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

/// spec 009 (T926) — Capa 1: el timer de sondeo de Drive (T913) respeta el
/// interruptor global (G2) y avanza con `didChangeAppLifecycleState` (G3).
///
/// Usa el MISMO harness que T822/T823 (spec 008,
/// `test/helpers/saves_screen_test_env.dart`) — montar `SavesScreen` completa
/// es la ÚNICA forma de ejercitar el timer privado de `_SavesScreenState`.
/// Ese harness ya documentó un cuelgue bloqueante de la EJECUCIÓN (no del
/// tipado) al montar la pantalla completa, sin causa raíz confirmada tras 3
/// intentos en una sesión anterior — ver `specs/008-coop-overwrite-ledger/
/// tasks.md` T822.
///
/// RECONFIRMADO 2026-07-31 (spec 009): se intentó UNA ejecución real de este
/// archivo (protocolo de la sesión: una sola iteración, matar tras ~2min).
/// `flutter test test/widgets/saves_screen_auto_refresh_test.dart` no
/// imprimió NADA en más de 2 minutos (mismo síntoma que T822: sin señal de
/// vida, apunta a bloqueo síncrono del event loop, no a un `Future` lento) —
/// se mató el proceso. Dato nuevo: este escenario NO usa coop/compartidas
/// (ni una sola carpeta compartida, registro vacío), así que el cuelgue NO
/// depende de esa complejidad — es estructural a montar `SavesScreen`
/// completa en este entorno de test, con cualquier escenario. Se deja en
/// `skip: true` sin más intentos (regla de la sesión: no repetir la
/// investigación ni gastar horas en el mismo cuelgue).
const _rootFolderId = 'root-folder';
const _myEmail = 'me@example.com';

void main() {
  setUpAll(() => GoogleFonts.config.allowRuntimeFetching = false);
  PathProviderPlatform.instance = FakePathProviderPlatform();

  Future<void> seedEmptySavesDir() async {
    final dir = Directory(SaveService.savesDirectory!);
    await dir.create(recursive: true);
  }

  /// Handler mínimo para un escenario SIN saves (ni propios ni compartidos):
  /// cubre exactamente la secuencia que dispara `_init()` → `_load()` →
  /// `_loadSharedSaves()` con listas vacías, más los dos endpoints nuevos de
  /// T912 (`changes/startPageToken` y `changes`).
  http.StreamedResponse Function(http.BaseRequest) emptyDriveHandler({
    required List<http.BaseRequest> changesRequests,
  }) {
    return (request) {
      final url = request.url;
      final method = request.method;
      final q = url.queryParameters['q'] ?? '';

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
      if (method == 'GET' && q.contains("'$_rootFolderId' in parents")) {
        return jsonResponse({'files': []});
      }
      if (method == 'GET' && q.contains('sharedWithMe')) {
        return jsonResponse({'files': [], 'nextPageToken': null});
      }
      if (url.path.contains('changes/startPageToken')) {
        changesRequests.add(request);
        return jsonResponse({'startPageToken': 'start-token'});
      }
      if (method == 'GET' && url.path.contains('changes')) {
        changesRequests.add(request);
        return jsonResponse({'changes': [], 'newStartPageToken': 'start-token'});
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
    'G2: con autoRefreshEnabled=true y Drive conectado, el timer sondea '
    'changes a los 30s',
    (tester) async {
      await runWithIOSandbox(() async {
        await seedEmptySavesDir();
        SharedPreferences.setMockInitialValues({'autoRefreshEnabled': true});
        final changesRequests = <http.BaseRequest>[];
        final client = FakeAuthClient(
          emptyDriveHandler(changesRequests: changesRequests),
        );

        await pumpSavesScreen(tester, client);
        expect(changesRequests, isEmpty); // aún no ha pasado el primer ciclo

        await tester.pump(const Duration(seconds: 31));
        await pumpBounded(tester, max: 5);

        expect(changesRequests, isNotEmpty);
      });
    },
    skip: true, // ver comentario de cabecera — reconfirmado 2026-07-31
  );

  testWidgets(
    'G2: con autoRefreshEnabled=false, el timer NUNCA sondea changes',
    (tester) async {
      await runWithIOSandbox(() async {
        await seedEmptySavesDir();
        SharedPreferences.setMockInitialValues({'autoRefreshEnabled': false});
        final changesRequests = <http.BaseRequest>[];
        final client = FakeAuthClient(
          emptyDriveHandler(changesRequests: changesRequests),
        );

        await pumpSavesScreen(tester, client);
        await tester.pump(const Duration(seconds: 31));
        await pumpBounded(tester, max: 5);

        expect(changesRequests, isEmpty);
      });
    },
    skip: true, // ver comentario de cabecera — reconfirmado 2026-07-31
  );
}
