import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:valleysave/core/models/player_stats.dart';
import 'package:valleysave/core/models/save_entry.dart';
import 'package:valleysave/core/models/save_file.dart';
import 'package:valleysave/core/models/shared_save_entry.dart';
import 'package:valleysave/features/saves/save_card.dart';
import 'package:valleysave/features/saves/widgets/shared_save_card.dart';
import 'package:valleysave/features/saves/widgets/save_detail_sheet.dart';
import 'package:valleysave/generated/app_localizations.dart';

void main() {
  final ana = _player('Ana', '111', isHost: true);
  final bruno = _player('Bruno', '222');

  setUpAll(() => GoogleFonts.config.allowRuntimeFetching = false);

  test('playerIndexForId conserva la persona aunque cambie el anfitrión', () {
    final beforeSwap = _save(players: [ana, bruno]);
    final afterSwap = _save(
      players: [_player('Bruno', '222', isHost: true), _player('Ana', '111')],
    );

    expect(playerIndexForId(beforeSwap, '222'), 1);
    expect(playerIndexForId(afterSwap, '222'), 0);
  });

  testWidgets('detalle recorre local, Mi Drive y Drive del dueño', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(900, 1600);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    final local = _save(players: [ana, bruno]);
    final ownDrive = _save(players: [ana, bruno]);
    final ownerDrive = _save(
      players: [_player('Bruno', '222', isHost: true), _player('Ana', '111')],
    );

    await tester.pumpWidget(
      MaterialApp(
        locale: const Locale('es'),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: Builder(
          builder: (context) => TextButton(
            onPressed: () => showSaveDetail(
              context,
              entry: SaveEntry(local: local, drive: ownDrive),
              startOnLocal: true,
              driveTitle: 'MI DRIVE',
              extraDrive: ownerDrive,
              extraDriveTitle: 'DRIVE EN OWNER@GMAIL.COM',
              initialPlayerId: '222',
            ),
            child: const Text('abrir'),
          ),
        ),
      ),
    );

    await tester.tap(find.text('abrir'));
    await tester.pumpAndSettle();
    final sheetHeight = tester
        .getSize(find.byKey(const ValueKey('save-detail-sheet')))
        .height;
    expect(sheetHeight, lessThan(1600 * 0.90));
    expect(find.byKey(const ValueKey('save-detail-local')), findsOneWidget);
    expect(find.textContaining('Bruno').hitTestable(), findsOneWidget);

    await tester.tap(find.byKey(const ValueKey('save-detail-nav-right')));
    await tester.pumpAndSettle();
    expect(find.byKey(const ValueKey('save-detail-drive')), findsOneWidget);
    expect(
      tester.getSize(find.byKey(const ValueKey('save-detail-sheet'))).height,
      sheetHeight,
    );
    expect(find.textContaining('Bruno').hitTestable(), findsOneWidget);

    await tester.tap(find.byKey(const ValueKey('save-detail-nav-right')));
    await tester.pumpAndSettle();
    expect(
      find.byKey(const ValueKey('save-detail-extraDrive')),
      findsOneWidget,
    );
    expect(
      tester.getSize(find.byKey(const ValueKey('save-detail-sheet'))).height,
      sheetHeight,
    );
    expect(find.textContaining('Bruno').hitTestable(), findsOneWidget);
  });

  testWidgets('Compartir solo aparece en la cara de Mi Drive', (tester) async {
    tester.view.physicalSize = const Size(900, 1600);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    final save = _save(players: [ana, bruno]);
    var shares = 0;
    await tester.pumpWidget(
      MaterialApp(
        locale: const Locale('es'),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: Builder(
          builder: (context) => TextButton(
            onPressed: () => showSaveDetail(
              context,
              entry: SaveEntry(local: save, drive: save),
              startOnLocal: true,
              onShare: () => shares++,
            ),
            child: const Text('abrir'),
          ),
        ),
      ),
    );

    await tester.tap(find.text('abrir'));
    await tester.pumpAndSettle();
    expect(find.text('Compartir').hitTestable(), findsNothing);

    await tester.tap(find.byKey(const ValueKey('save-detail-nav-right')));
    await tester.pumpAndSettle();
    expect(find.text('Compartir').hitTestable(), findsOneWidget);
    await tester.tap(find.text('Compartir').hitTestable());
    await tester.pumpAndSettle();
    expect(shares, 1);
  });

  testWidgets('quitar de la lista solo aparece en Drive del dueño', (
    tester,
  ) async {
    final local = _save(players: [ana, bruno]);

    await tester.pumpWidget(
      MaterialApp(
        locale: const Locale('es'),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: Builder(
          builder: (context) => TextButton(
            onPressed: () => showSaveDetail(
              context,
              entry: SaveEntry(local: local, drive: local),
              startOnLocal: true,
              extraDrive: local,
              onRemove: () {},
              removeLabel: 'Quitar de la lista',
            ),
            child: const Text('abrir'),
          ),
        ),
      ),
    );

    await tester.tap(find.text('abrir'));
    await tester.pumpAndSettle();
    expect(find.text('Quitar de la lista'), findsNothing);

    await tester.tap(find.byKey(const ValueKey('save-detail-nav-right')));
    await tester.pumpAndSettle();
    expect(find.text('Quitar de la lista'), findsNothing);

    await tester.tap(find.byKey(const ValueKey('save-detail-nav-right')));
    await tester.pumpAndSettle();
    expect(find.text('Quitar de la lista'), findsOneWidget);
  });

  testWidgets('cada card elimina únicamente su propia ubicación', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(900, 1600);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    final save = _save(players: [ana, bruno]);
    var localDeletes = 0;
    var driveDeletes = 0;

    await tester.pumpWidget(
      MaterialApp(
        locale: const Locale('es'),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: Builder(
          builder: (context) => TextButton(
            onPressed: () => showSaveDetail(
              context,
              entry: SaveEntry(local: save, drive: save),
              startOnLocal: true,
              onExport: () {},
              onBackups: () {},
              backupCount: 2,
              onDeleteLocal: () => localDeletes++,
              onDeleteFromDrive: () => driveDeletes++,
            ),
            child: const Text('abrir'),
          ),
        ),
      ),
    );

    await tester.tap(find.text('abrir'));
    await tester.pumpAndSettle();
    expect(
      find.byKey(const ValueKey('save-detail-delete-local')).hitTestable(),
      findsOneWidget,
    );
    expect(find.text('Eliminar').hitTestable(), findsOneWidget);
    final secondaryRow = find
        .ancestor(
          of: find
              .byKey(const ValueKey('save-detail-delete-local'))
              .hitTestable(),
          matching: find.byType(Row),
        )
        .first;
    expect(
      find.descendant(of: secondaryRow, matching: find.text('Exportar')),
      findsOneWidget,
    );
    expect(
      find.descendant(of: secondaryRow, matching: find.text('Backups')),
      findsOneWidget,
    );

    await tester.tap(
      find.byKey(const ValueKey('save-detail-delete-local')).hitTestable(),
    );
    await tester.pumpAndSettle();
    expect(localDeletes, 1);
    expect(driveDeletes, 0);

    await tester.tap(find.text('abrir'));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const ValueKey('save-detail-nav-right')));
    await tester.pumpAndSettle();
    expect(
      find.byKey(const ValueKey('save-detail-delete-drive')).hitTestable(),
      findsOneWidget,
    );
    expect(find.text('Eliminar').hitTestable(), findsOneWidget);

    await tester.tap(
      find.byKey(const ValueKey('save-detail-delete-drive')).hitTestable(),
    );
    await tester.pumpAndSettle();
    expect(localDeletes, 1);
    expect(driveDeletes, 1);
  });

  testWidgets('coop sincronizado no ofrece transferencias redundantes', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(900, 1600);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    final save = _save(players: [ana, bruno]);
    await tester.pumpWidget(
      MaterialApp(
        locale: const Locale('es'),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: Scaffold(
          body: SingleChildScrollView(
            child: SharedSaveCard(
              entry: SharedSaveEntry(
                folderId: 'owner-folder',
                folderName: save.folderName,
                ownerEmail: 'owner@gmail.com',
                myRole: 'writer',
                driveStats: save,
                localMatch: save,
                ownDriveStats: save,
                ownDriveFolderId: 'own-folder',
              ),
              onUploadToOwnDrive: () {},
              onDownloadFromOwnDrive: () {},
              onSync: () {},
              onSyncBoth: () {},
              onDownload: () {},
              onSyncRequested: () {},
              onDownloadRequested: () {},
            ),
          ),
        ),
      ),
    );
    await tester.pump();

    expect(find.text('Totalmente sincronizado'), findsOneWidget);
    expect(find.text('Backups'), findsNothing);
    expect(find.text('HACER ANFITRIÓN'), findsNothing);
    expect(find.text('Subir a mi Drive'), findsNothing);
    expect(find.text('Sincronizar'), findsNothing);
    expect(find.text('Descargar'), findsNothing);

    await tester.tap(find.text('EN ESTE DISPOSITIVO'));
    await tester.pumpAndSettle();
    expect(find.text('Subir a mi Drive'), findsNothing);
    expect(find.text('Sincronizar ambos'), findsNothing);

    await tester.tap(find.byKey(const ValueKey('save-detail-nav-right')));
    await tester.pumpAndSettle();
    expect(find.text('Descargar partida'), findsNothing);

    await tester.tap(find.byKey(const ValueKey('save-detail-nav-right')));
    await tester.pumpAndSettle();
    expect(find.text('Descargar partida'), findsNothing);
  });

  testWidgets('estado ocupado muestra indicador y bloquea la acción', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(900, 1600);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    var uploads = 0;
    final save = _save(players: [ana, bruno]);

    await tester.pumpWidget(
      MaterialApp(
        locale: const Locale('es'),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: Scaffold(
          body: SingleChildScrollView(
            child: SharedSaveCard(
              entry: SharedSaveEntry(
                folderId: 'owner-folder',
                folderName: save.folderName,
                ownerEmail: 'owner@gmail.com',
                myRole: 'writer',
                driveStats: save,
                localMatch: save,
              ),
              busy: true,
              onSyncRequested: () => uploads++,
            ),
          ),
        ),
      ),
    );
    await tester.pump();

    expect(
      find.byKey(const ValueKey('shared-save-busy-indicator')),
      findsOneWidget,
    );
    expect(find.text('Sincronizar'), findsNothing);
    expect(
      find.byKey(const ValueKey('shared-manage-copies-action')),
      findsNothing,
    );
    expect(uploads, 0);
  });

  testWidgets(
    'coop no comprobable no confunde el Drive del dueño con ausente',
    (tester) async {
      tester.view.physicalSize = const Size(900, 1600);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      final local = _save(players: [ana, bruno]);
      await tester.pumpWidget(
        MaterialApp(
          locale: const Locale('es'),
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: Scaffold(
            body: SingleChildScrollView(
              child: SharedSaveCard(
                entry: SharedSaveEntry(
                  folderId: 'owner-folder',
                  folderName: local.folderName,
                  ownerEmail: 'owner@gmail.com',
                  myRole: 'reader',
                  localMatch: local,
                  ownerDrivePresent: true,
                  ownerDriveVerified: false,
                ),
                onSyncRequested: () {},
              ),
            ),
          ),
        ),
      );
      await tester.pump();

      expect(find.text('EN ESTE DISPOSITIVO'), findsOneWidget);
      expect(find.text('MI DRIVE'), findsOneWidget);
      expect(find.text('DRIVE EN OWNER@GMAIL.COM'), findsOneWidget);
      expect(find.text('No está aquí'), findsOneWidget);
      expect(find.text('No se pudo comprobar'), findsOneWidget);
      expect(
        find.text('No se pudo comprobar Drive en owner@gmail.com'),
        findsOneWidget,
      );
      expect(find.text('Ya no tienes acceso'), findsNothing);
    },
  );

  testWidgets('coop muestra desconectar y papelera como iconos compactos', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(900, 1600);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    var disconnects = 0;
    var manages = 0;
    final save = _save(players: [ana, bruno]);

    await tester.pumpWidget(
      MaterialApp(
        locale: const Locale('es'),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: Scaffold(
          body: SingleChildScrollView(
            child: SharedSaveCard(
              entry: SharedSaveEntry(
                folderId: 'owner-folder',
                folderName: save.folderName,
                ownerEmail: 'owner@gmail.com',
                myRole: 'writer',
                driveStats: save,
                localMatch: save,
                ownDriveStats: save,
                ownDriveFolderId: 'own-folder',
              ),
              onRemove: () => disconnects++,
              onManageCopies: () => manages++,
            ),
          ),
        ),
      ),
    );
    await tester.pump();

    expect(find.text('Desconectar'), findsNothing);
    expect(find.byIcon(Icons.sync_disabled_rounded), findsOneWidget);
    final statusCenter = tester.getCenter(find.text('Totalmente sincronizado'));
    final disconnectCenter = tester.getCenter(
      find.byKey(const ValueKey('shared-disconnect-action')),
    );
    expect((statusCenter.dy - disconnectCenter.dy).abs(), lessThan(20));
    await tester.tap(find.byKey(const ValueKey('shared-disconnect-action')));
    await tester.tap(find.byKey(const ValueKey('shared-manage-copies-action')));
    expect(disconnects, 1);
    expect(manages, 1);
  });

  testWidgets('partida normal muestra papelera compacta', (tester) async {
    tester.view.physicalSize = const Size(900, 1600);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    var manages = 0;
    final save = _save(players: [ana, bruno]);
    await tester.pumpWidget(
      MaterialApp(
        locale: const Locale('es'),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: Scaffold(
          body: SingleChildScrollView(
            child: SaveCard(
              entry: SaveEntry(local: save),
              onManageCopies: () => manages++,
            ),
          ),
        ),
      ),
    );
    await tester.pump();

    await tester.tap(find.byKey(const ValueKey('save-manage-copies-action')));
    expect(manages, 1);
  });

  testWidgets('carga de partida normal ocupa el inicio de la fila de estado', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(900, 1600);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    final save = _save(players: [ana, bruno]);
    await tester.pumpWidget(
      MaterialApp(
        locale: const Locale('es'),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: Scaffold(
          body: SaveCard(entry: SaveEntry(local: save), busy: true),
        ),
      ),
    );
    await tester.pump();

    final loader = find.byKey(const ValueKey('save-busy-indicator'));
    final status = find.text('Solo en este equipo');
    expect(loader, findsOneWidget);
    expect(status, findsOneWidget);
    expect(tester.getCenter(loader).dx, lessThan(tester.getCenter(status).dx));
  });

  testWidgets('partida compartida abre Backups solo desde el detalle', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(900, 1600);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    var opens = 0;
    final save = _save(players: [ana, bruno]);
    await tester.pumpWidget(
      MaterialApp(
        locale: const Locale('es'),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: Scaffold(
          body: SingleChildScrollView(
            child: SharedSaveCard(
              entry: SharedSaveEntry(
                folderId: 'owner-folder',
                folderName: save.folderName,
                ownerEmail: 'owner@gmail.com',
                myRole: 'reader',
                driveStats: save,
              ),
              onDownload: () {},
              onBackups: () => opens++,
            ),
          ),
        ),
      ),
    );
    await tester.pump();

    expect(find.text('Backups'), findsNothing);
    await tester.tap(find.text('DRIVE EN OWNER@GMAIL.COM'));
    await tester.pumpAndSettle();
    expect(find.text('Backups').hitTestable(), findsOneWidget);
    await tester.tap(find.text('Backups').hitTestable());
    expect(opens, 1);
  });

  testWidgets('coop local por delante ofrece una única sincronización', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(900, 1600);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    var syncs = 0;
    final local = _save(players: [ana, bruno], dayOfMonth: 5);
    final cloud = _save(players: [ana, bruno], dayOfMonth: 4);
    await tester.pumpWidget(
      MaterialApp(
        locale: const Locale('es'),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: Scaffold(
          body: SingleChildScrollView(
            child: SharedSaveCard(
              entry: SharedSaveEntry(
                folderId: 'owner-folder',
                folderName: local.folderName,
                ownerEmail: 'owner@gmail.com',
                myRole: 'writer',
                driveStats: cloud,
                localMatch: local,
              ),
              onSyncRequested: () => syncs++,
              onRemove: () {},
              onManageCopies: () {},
              onBackups: () {},
              onMakeHost: (_) {},
            ),
          ),
        ),
      ),
    );
    await tester.pump();

    expect(find.text('Solo en este equipo'), findsOneWidget);
    expect(find.text('Sincronizar'), findsOneWidget);
    expect(find.text('Backups'), findsNothing);
    expect(find.text('HACER ANFITRIÓN'), findsNothing);
    expect(find.text('Subir a mi Drive'), findsNothing);
    await tester.tap(find.text('Sincronizar'));
    expect(syncs, 1);
  });

  testWidgets('detalle individual ofrece Backups con contador cero', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(900, 1600);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    var opens = 0;
    final save = _save(players: [ana, bruno]);
    await tester.pumpWidget(
      MaterialApp(
        locale: const Locale('es'),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: Scaffold(
          body: SaveCard(
            entry: SaveEntry(local: save),
            onBackups: () => opens++,
            backupCount: 0,
          ),
        ),
      ),
    );
    await tester.pump();

    await tester.tap(find.text('EN ESTE DISPOSITIVO'));
    await tester.pumpAndSettle();
    expect(find.text('Backups').hitTestable(), findsOneWidget);
    await tester.tap(find.text('Backups').hitTestable());
    expect(opens, 1);
  });
}

PlayerStats _player(String name, String id, {bool isHost = false}) {
  return PlayerStats(
    name: name,
    isHost: isHost,
    uniqueId: id,
    gender: 0,
    farmingLevel: 1,
    miningLevel: 1,
    combatLevel: 1,
    foragingLevel: 1,
    fishingLevel: 1,
    luckLevel: 0,
    currentMoney: 128,
    totalMoneyEarned: 228,
    millisecondsPlayed: 3600000,
    health: 100,
    stamina: 270,
    deepestMineLevel: 0,
    houseUpgradeLevel: 0,
    monstersKilled: 0,
    timesUnconscious: 0,
    goodFriends: 0,
    averageBedtime: 2200,
    daysPlayed: 4,
  );
}

SaveFile _save({required List<PlayerStats> players, int dayOfMonth = 4}) {
  final host = players.firstWhere((player) => player.isHost);
  return SaveFile(
    folderPath: 'C:/Saves/Stardust_1',
    folderName: 'Stardust_1',
    playerName: host.name,
    farmName: 'Stardust',
    dayOfMonth: dayOfMonth,
    currentSeason: 'spring',
    year: 1,
    currentMoney: host.currentMoney,
    totalMoneyEarned: host.totalMoneyEarned,
    millisecondsPlayed: host.millisecondsPlayed,
    lastModified: DateTime(2026, 7, 13),
    farmingLevel: host.farmingLevel,
    miningLevel: host.miningLevel,
    combatLevel: host.combatLevel,
    foragingLevel: host.foragingLevel,
    fishingLevel: host.fishingLevel,
    houseUpgradeLevel: host.houseUpgradeLevel,
    petType: 'cat',
    gender: host.gender,
    deepestMineLevel: host.deepestMineLevel,
    monstersKilled: host.monstersKilled,
    timesUnconscious: host.timesUnconscious,
    goodFriends: host.goodFriends,
    timeOfDay: 600,
    averageBedtime: host.averageBedtime,
    weather: WeatherType.sunny,
    stamina: host.stamina,
    health: host.health,
    gameVersion: '1.6.15.3',
    isCoop: true,
    players: players,
  );
}
