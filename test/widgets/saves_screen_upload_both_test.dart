import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:path_provider_platform_interface/path_provider_platform_interface.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:valleysave/core/services/drive_service.dart';
import 'package:valleysave/core/services/save_service.dart';
import 'package:valleysave/features/saves/saves_screen.dart';
import 'package:valleysave/generated/app_localizations.dart';

import '../helpers/saves_screen_test_env.dart';

/// T823 (spec 008) — G6/G7 del diálogo combinado `_confirmUploadToBoth`
/// (`_handleSyncBoth`, D3): cancelar no sube a NINGÚN destino (G6), y el
/// peligro en solo uno de los dos destinos dispara una única doble
/// confirmación que nombra el destino correcto (G7).
///
/// Antes marcada "NO IMPLEMENTADA" en `tasks.md` (verificada solo por
/// revisión de código). Reutiliza la misma infraestructura que
/// `saves_screen_owner_upload_test.dart` (T822) — ver
/// `test/helpers/saves_screen_test_env.dart`.
///
/// SKIP (2026-07-30): mismo bloqueo que T822 — montar `SavesScreen`
/// completa cuelga de forma síncrona (ni `pumpBounded` ni
/// `flutter test --timeout=20s` lo resuelven). Ver el comentario SKIP en
/// `saves_screen_owner_upload_test.dart` y `tasks.md` T822/T823 para el
/// diagnóstico completo.
const _folderName = 'TestCoop_9002';
const _sharedFolderId = 'owner-folder-2';
const _rootFolderId = 'root-folder';
const _ownerEmail = 'owner@example.com';
const _myEmail = 'me@example.com';

void main() {
  setUpAll(() => GoogleFonts.config.allowRuntimeFetching = false);
  PathProviderPlatform.instance = FakePathProviderPlatform();

  Future<void> seedLocalSave({
    required int dayOfMonth,
    required int totalMoneyEarned,
  }) async {
    final sep = Platform.pathSeparator;
    final savesDir = Directory(SaveService.savesDirectory!);
    final folder = Directory('${savesDir.path}$sep$_folderName');
    await folder.create(recursive: true);
    await File('${folder.path}${sep}SaveGameInfo').writeAsString(
      fakeSaveGameInfoXml(
        playerName: 'Ana',
        farmName: 'Granja Test',
        dayOfMonth: dayOfMonth,
        totalMoneyEarned: totalMoneyEarned,
      ),
    );
    await File('${folder.path}$sep$_folderName').writeAsString('main-bytes');
  }

  void seedSharedRegistry() {
    SharedPreferences.setMockInitialValues({
      'shared_saves_registry::$_myEmail': jsonEncode([
        {
          'folderId': _sharedFolderId,
          'folderName': _folderName,
          'ownerEmail': _ownerEmail,
        },
      ]),
    });
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

  /// Abre el selector desde el footer y elige "Los dos Drive"
  /// (`shared-choice-2`: 0=own, 1=owner, 2=both — ver
  /// `_chooseSharedSyncTarget`) → dispara `_handleSyncBoth` →
  /// `_confirmUploadToBoth`.
  Future<void> openBothUploadFromFooter(WidgetTester tester) async {
    expect(find.text('Subir'), findsOneWidget);
    await tester.tap(find.text('Subir'));
    await pumpBounded(tester);
    await tester.tap(find.byKey(const ValueKey('shared-choice-2')));
    await pumpBounded(tester);
  }

  bool onlyReadRequests(FakeAuthClient client) =>
      client.requests.every((r) => r.method == 'GET');

  testWidgets(
    'G6: cancelar el diálogo combinado no sube a NINGÚN destino',
    (tester) async {
      await runWithIOSandbox(() async {
        // Mi Drive y Drive del dueño MISSING (ninguno resuelve stats) — los
        // dos son destinos de subida válidos, sin peligro (isNewCopy en
        // los dos), suficiente para ejercitar G6 sin necesitar contenido
        // remoto real.
        await seedLocalSave(dayOfMonth: 5, totalMoneyEarned: 500);
        seedSharedRegistry();

        final client = FakeAuthClient(
          buildSharedDriveHandler(
            rootFolderId: _rootFolderId,
            sharedFolderId: _sharedFolderId,
            folderName: _folderName,
            ownerEmail: _ownerEmail,
            myEmail: _myEmail,
          ),
        );

        await pumpSavesScreen(tester, client);
        await openBothUploadFromFooter(tester);

        // El diálogo combinado está abierto, sin peligro (título Y botón
        // comparten el mismo texto "Subir a los dos Drive" cuando no hay
        // peligro — por eso se espera 2 coincidencias aquí).
        expect(find.text('Subir a los dos Drive'), findsNWidgets(2));

        await tester.tap(find.text('Cancelar'));
        await pumpBounded(tester);

        // El diálogo se cierra y CERO requests de escritura ocurrieron —
        // todo lo que se llamó a Drive fue de solo lectura (la carga
        // inicial de la pantalla).
        expect(find.text('Subir a los dos Drive'), findsNothing);
        expect(onlyReadRequests(client), isTrue);
      });
    },
    skip: true, // WIP: ver comentario SKIP arriba y tasks.md T822/T823
  );

  testWidgets(
    'G7: peligro en un solo destino activa una única doble confirmación '
    'que nombra el destino correcto',
    (tester) async {
      await runWithIOSandbox(() async {
        // Local por delante en día (10 > 5, así que el Drive del dueño
        // cuenta como "behind" → sigue siendo destino de subida válido) pero
        // con MENOS dinero total ganado que la copia del dueño — dispara
        // peligro (D4: cualquier stat salvo el dinero ACTUAL que empeore;
        // el dinero TOTAL sí cuenta). Mi Drive se queda `missing` (no hay
        // entrada en "Mis partidas" en estos tests) — sin ledger, sin
        // peligro por ese lado.
        await seedLocalSave(dayOfMonth: 10, totalMoneyEarned: 100);
        seedSharedRegistry();

        final client = FakeAuthClient(
          buildSharedDriveHandler(
            rootFolderId: _rootFolderId,
            sharedFolderId: _sharedFolderId,
            folderName: _folderName,
            ownerEmail: _ownerEmail,
            myEmail: _myEmail,
            ownerFolderChildren: const [
              {'id': 'owner-info', 'name': 'SaveGameInfo'},
            ],
            ownerInfoXml: fakeSaveGameInfoXml(
              playerName: 'Ana',
              farmName: 'Granja Test',
              dayOfMonth: 5,
              totalMoneyEarned: 5000,
            ),
          ),
        );

        await pumpSavesScreen(tester, client);
        await openBothUploadFromFooter(tester);

        // Con peligro, el botón principal cambia de texto (deja de
        // coincidir con el título) — confirma que el ledger del dueño se
        // resolvió con datos reales y detectó el retroceso.
        expect(find.text('Subir a los dos Drive'), findsOneWidget); // título
        expect(find.text('⚠️ Subir de todas formas'), findsOneWidget);

        await tester.tap(find.text('⚠️ Subir de todas formas'));
        await pumpBounded(tester);

        // G7: una ÚNICA doble confirmación, nombrando el destino que
        // retrocede (Drive del dueño) y NO el que no pierde nada (Mi
        // Drive / "tu Drive").
        expect(find.text('¿Confirmas las dos subidas?'), findsOneWidget);
        expect(
          find.textContaining('Drive en $_ownerEmail'),
          findsWidgets,
        );
        expect(find.textContaining('tu Drive'), findsNothing);

        // Cancelar la doble confirmación tampoco sube nada (G6 se sostiene
        // también en el camino de peligro).
        await tester.tap(find.text('Cancelar').last);
        await pumpBounded(tester);
        expect(onlyReadRequests(client), isTrue);
      });
    },
    skip: true, // WIP: ver comentario SKIP arriba y tasks.md T822/T823
  );
}
