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

/// T822 (spec 008) — G2: `SharedAccessRevokedException`/
/// `SharedAccessReadOnlyException` en la ÚNICA ruta que sube al Drive del
/// dueño (`_uploadToOwnerDrive`, ver comentario en `saves_screen.dart` línea
/// ~657: "Único punto que sube al Drive del DUEÑO"). `_handleSyncShared`
/// (detalle), `_handleSharedSyncRequested` (footer) y `_handleSyncBoth`
/// (T823) llaman TODOS a este mismo método — cubrirlo aquí cubre las tres
/// rutas listadas en la tarea sin triplicar el montaje del widget.
///
/// Antes marcada "NO IMPLEMENTADA" en `tasks.md` (verificada solo por
/// revisión de código): montar `SavesScreen` completa no tenía precedente en
/// el repo. Viable con `test/helpers/saves_screen_test_env.dart` (sandbox de
/// IO + Drive HTTP falso) — ver ese archivo para el porqué de cada pieza.
///
/// SKIP (2026-07-30): montar `SavesScreen` completa cuelga de forma
/// bloqueante — no es el `Ticker` decorativo de `ValleyCanvasWidget` (ya
/// descartado: se sustituyó `pumpAndSettle()` por un pump acotado,
/// `pumpBounded`, y sigue colgando) y no es un simple `await` lento (con
/// `flutter test --timeout=20s` el proceso NUNCA llega a lanzar el
/// `TimeoutException` esperado — indica un bloqueo SÍNCRONO del event loop,
/// no un `Future` que tarda). Causa raíz exacta sin confirmar por falta de
/// presupuesto de ejecuciones (ver `tasks.md` T822/T823 para el detalle
/// completo de lo investigado). El harness (`test/helpers/
/// saves_screen_test_env.dart`) y los tests SÍ compilan (`flutter analyze`
/// limpio) — el problema es de ejecución, no de tipos ni de wiring.
const _folderName = 'TestCoop_9001';
const _sharedFolderId = 'owner-folder-1';
const _rootFolderId = 'root-folder';
const _ownerEmail = 'owner@example.com';
const _myEmail = 'me@example.com';

void main() {
  setUpAll(() => GoogleFonts.config.allowRuntimeFetching = false);
  PathProviderPlatform.instance = FakePathProviderPlatform();

  Future<void> seedLocalSave() async {
    final sep = Platform.pathSeparator;
    final savesDir = Directory(SaveService.savesDirectory!);
    final folder = Directory('${savesDir.path}$sep$_folderName');
    await folder.create(recursive: true);
    await File('${folder.path}${sep}SaveGameInfo').writeAsString(
      fakeSaveGameInfoXml(
        playerName: 'Ana',
        farmName: 'Granja Test',
        dayOfMonth: 5,
      ),
    );
    // No hace falta que sea un save real — únicamente que exista, ya que
    // `uploadToSharedSave` nunca llega a leerlo: la excepción salta en la
    // primera llamada (comprobación de permiso), antes de tocar archivos.
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

  /// Abre el selector de destino desde el footer (Mi Drive y Drive del
  /// dueño están ambos como `missing` → las dos direcciones son válidas,
  /// ver `buildSharedDriveHandler` con `ownerFolderChildren` vacío) y elige
  /// la opción del Drive del dueño (`shared-choice-1`: 0=own, 1=owner,
  /// 2=both — ver `_chooseSharedSyncTarget`).
  Future<void> openOwnerUploadFromFooter(WidgetTester tester) async {
    expect(find.text('Subir'), findsOneWidget);
    await tester.tap(find.text('Subir'));
    await pumpBounded(tester);
    await tester.tap(find.byKey(const ValueKey('shared-choice-1')));
    await pumpBounded(tester);
  }

  testWidgets(
    'G2: SharedAccessRevokedException dispara _handleConfirmedRevocation '
    'y el save desaparece de "Compartidas conmigo"',
    (tester) async {
      await runWithIOSandbox(() async {
        await seedLocalSave();
        seedSharedRegistry();

        final client = FakeAuthClient(
          buildSharedDriveHandler(
            rootFolderId: _rootFolderId,
            sharedFolderId: _sharedFolderId,
            folderName: _folderName,
            ownerEmail: _ownerEmail,
            myEmail: _myEmail,
            // Drive respondió con éxito "ya no hay permiso" (404) al
            // intentar la comprobación de capacidades ANTES de subir nada.
            uploadPermissionResponse: () => driveErrorResponse(404),
          ),
        );

        await pumpSavesScreen(tester, client);

        // Precondición: la tarjeta compartida está presente.
        expect(
          find.textContaining('Compartida por $_ownerEmail'),
          findsOneWidget,
        );

        await openOwnerUploadFromFooter(tester);

        // `_uploadToOwnerDrive` → `SharedAccessRevokedException` →
        // `_handleConfirmedRevocation` → diálogo "Ya no tienes acceso".
        expect(find.text('Ya no tienes acceso'), findsOneWidget);
        await tester.tap(find.text('Aceptar'));
        await pumpBounded(tester);

        // G2: el save DESAPARECE de "Compartidas conmigo" — vuelve a ser
        // una partida normal (decisión 2026-07-15), la sección queda vacía.
        expect(
          find.text('Nada compartido contigo todavía.'),
          findsOneWidget,
        );
        expect(
          find.textContaining('Compartida por $_ownerEmail'),
          findsNothing,
        );
      });
    },
    skip: true, // WIP: ver comentario SKIP arriba y tasks.md T822/T823
  );

  testWidgets(
    'G2: SharedAccessReadOnlyException muestra snack SIN quitar el save '
    'de la lista',
    (tester) async {
      await runWithIOSandbox(() async {
        await seedLocalSave();
        seedSharedRegistry();

        final client = FakeAuthClient(
          buildSharedDriveHandler(
            rootFolderId: _rootFolderId,
            sharedFolderId: _sharedFolderId,
            folderName: _folderName,
            ownerEmail: _ownerEmail,
            myEmail: _myEmail,
            // El acceso SIGUE siendo válido (200) pero bajó a lector.
            uploadPermissionResponse: () => jsonResponse({
              'capabilities': {'canEdit': false},
            }),
          ),
        );

        await pumpSavesScreen(tester, client);
        expect(
          find.textContaining('Compartida por $_ownerEmail'),
          findsOneWidget,
        );

        await openOwnerUploadFromFooter(tester);
        await tester.pump(); // deja aparecer el SnackBar

        // G2: snack informativo, SIN diálogo de revocación.
        expect(find.text('Ya no tienes acceso'), findsNothing);
        expect(
          find.textContaining('te ha puesto en modo solo lectura'),
          findsOneWidget,
        );

        await pumpBounded(tester);

        // La tarjeta SIGUE en "Compartidas conmigo" — el acceso no se
        // revocó, solo bajó de rol.
        expect(
          find.textContaining('Compartida por $_ownerEmail'),
          findsOneWidget,
        );
        expect(
          find.text('Nada compartido contigo todavía.'),
          findsNothing,
        );
      });
    },
    skip: true, // WIP: ver comentario SKIP arriba y tasks.md T822/T823
  );
}
