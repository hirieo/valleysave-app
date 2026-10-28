import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:valleysave/core/models/backup_entry.dart';
import 'package:valleysave/features/saves/widgets/backups_sections.dart';
import 'package:valleysave/generated/app_localizations.dart';

/// Spec 012, D7: diálogo de backups con secciones plegables.
BackupEntry _entry(
  String tag,
  String ts, {
  bool local = true,
  bool drive = false,
}) {
  final name = 'Granja_1_${tag}_$ts.zip';
  final parsed = BackupEntry.parseFileName(name)!;
  return BackupEntry(
    fileName: name,
    folderName: 'Granja_1',
    timestamp: parsed.timestamp,
    localPath: local ? 'C:/b/$name' : null,
    driveFileId: drive ? 'id-$ts' : null,
    sizeBytes: 10,
    origin: parsed.origin,
  );
}

final _manual1 = _entry('backup', '20261020-180200');
final _manual2 = _entry('backup', '20261015-120000');
final _autoInUse = _entry('autobackup', '20261025-214000');
final _auto2 = _entry('autobackup', '20261018-223100');
final _auto3 = _entry('autobackup', '20261017-100000');
final _pre = _entry('prerestore', '20261028-101500');

Key _header(BackupOrigin o) => ValueKey('backups-header-${o.name}');
Key _restore(BackupEntry e) => ValueKey('backup-restore-${e.fileName}');
Key _delete(BackupEntry e) => ValueKey('backup-delete-${e.fileName}');
Key _keep(BackupEntry e) => ValueKey('backup-keep-${e.fileName}');

void main() {
  setUpAll(() => GoogleFonts.config.allowRuntimeFetching = false);
  setUp(() => SharedPreferences.setMockInitialValues({}));

  Future<void> pump(
    WidgetTester tester, {
    List<BackupEntry>? entries,
    String? inUse,
    Set<BackupOrigin> open = const {},
    Future<void> Function()? onCreate,
    Future<void> Function(BackupEntry)? onKeep,
    bool disableAnimations = false,
  }) async {
    tester.view.physicalSize = const Size(900, 2400);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    await tester.pumpWidget(
      MaterialApp(
        locale: const Locale('es'),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        builder: (context, child) => MediaQuery(
          data: MediaQuery.of(
            context,
          ).copyWith(disableAnimations: disableAnimations),
          child: child!,
        ),
        home: Scaffold(
          body: SingleChildScrollView(
            child: SizedBox(
              width: 420,
              child: BackupsSections(
                entries:
                    entries ??
                    [_manual1, _manual2, _autoInUse, _auto2, _auto3, _pre],
                inUseFileName: inUse ?? _autoInUse.fileName,
                initialOpen: open,
                onCreate: onCreate,
                loadSummary: (_) async => null,
                actionsFor: (e) => BackupRowActions(
                  onRestore: () async {},
                  onKeep: e.origin == BackupOrigin.manual
                      ? null
                      : () async => onKeep?.call(e),
                  onDelete: () async {},
                ),
              ),
            ),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  testWidgets('abre plegado: tres cabeceras con número y resumen, sin filas', (
    tester,
  ) async {
    await pump(tester);

    expect(find.byKey(_header(BackupOrigin.manual)), findsOneWidget);
    expect(find.byKey(_header(BackupOrigin.auto)), findsOneWidget);
    expect(find.byKey(_header(BackupOrigin.preRestore)), findsOneWidget);
    expect(find.text('Manuales'), findsOneWidget);
    expect(find.text('Automáticos'), findsOneWidget);
    expect(find.text('Antes de restaurar'), findsOneWidget);
    expect(find.byKey(_restore(_manual1)), findsNothing);
    expect(find.byKey(_restore(_autoInUse)), findsNothing);
    // Resúmenes: último de cada sección y «en uso» sin desplegar.
    expect(find.text('último 20/10 18:02'), findsOneWidget);
    expect(find.textContaining('● en uso 25/10 21:40'), findsOneWidget);
    expect(find.text('último 28/10 10:15'), findsOneWidget);
    expect(find.text('Desplegar todo'), findsOneWidget);
  });

  testWidgets('tocar una cabecera despliega solo esa y enseña la regla', (
    tester,
  ) async {
    await pump(tester);

    await tester.tap(find.byKey(_header(BackupOrigin.auto)));
    await tester.pumpAndSettle();

    expect(find.byKey(_restore(_autoInUse)), findsOneWidget);
    expect(find.byKey(_restore(_auto2)), findsOneWidget);
    expect(find.byKey(_restore(_manual1)), findsNothing);
    expect(find.byKey(_restore(_pre)), findsNothing);
    expect(find.text('se guardan 5'), findsOneWidget);

    await tester.tap(find.byKey(_header(BackupOrigin.auto)));
    await tester.pumpAndSettle();
    expect(find.byKey(_restore(_auto2)), findsNothing);
  });

  testWidgets('«Desplegar todo» abre las 3 y pasa a «Plegar todo»', (
    tester,
  ) async {
    await pump(tester);

    await tester.tap(find.byKey(const ValueKey('backups-toggle-all')));
    await tester.pumpAndSettle();

    expect(find.byKey(_restore(_manual1)), findsOneWidget);
    expect(find.byKey(_restore(_autoInUse)), findsOneWidget);
    expect(find.byKey(_restore(_pre)), findsOneWidget);
    expect(find.text('Plegar todo'), findsOneWidget);
    expect(find.text('no se borran solos'), findsOneWidget);
    expect(find.text('se guardan 3'), findsOneWidget);

    await tester.tap(find.byKey(const ValueKey('backups-toggle-all')));
    await tester.pumpAndSettle();
    expect(find.byKey(_restore(_manual1)), findsNothing);
    expect(find.text('Desplegar todo'), findsOneWidget);
  });

  testWidgets('el backup en uso no tiene papelera; los demás sí', (
    tester,
  ) async {
    await pump(tester, open: BackupOrigin.values.toSet());

    expect(find.byKey(_delete(_autoInUse)), findsNothing);
    expect(find.text('En uso'), findsOneWidget);
    expect(find.byKey(_delete(_auto2)), findsOneWidget);
    expect(find.byKey(_delete(_manual1)), findsOneWidget);
    expect(find.byKey(_delete(_pre)), findsOneWidget);
  });

  testWidgets(
    '«Conservar» solo en automáticos y antes de restaurar, también en el en uso',
    (tester) async {
      await pump(tester, open: BackupOrigin.values.toSet());

      expect(find.byKey(_keep(_manual1)), findsNothing);
      expect(find.byKey(_keep(_autoInUse)), findsOneWidget);
      expect(find.byKey(_keep(_auto2)), findsOneWidget);
      expect(find.byKey(_keep(_pre)), findsOneWidget);
    },
  );

  testWidgets('pulsar «Conservar» llama a la acción de esa fila', (
    tester,
  ) async {
    BackupEntry? kept;
    await pump(
      tester,
      open: {BackupOrigin.auto},
      onKeep: (e) async => kept = e,
    );

    await tester.tap(find.byKey(_keep(_auto2)));
    await tester.pumpAndSettle();

    expect(kept, _auto2);
  });

  testWidgets('una sección vacía no se muestra', (tester) async {
    await pump(tester, entries: [_manual1, _manual2], inUse: 'ninguno');

    expect(find.byKey(_header(BackupOrigin.manual)), findsOneWidget);
    expect(find.byKey(_header(BackupOrigin.auto)), findsNothing);
    expect(find.byKey(_header(BackupOrigin.preRestore)), findsNothing);
  });

  testWidgets('sin backups: texto de vacío y sin botón de desplegar', (
    tester,
  ) async {
    await pump(tester, entries: [], inUse: 'x');

    expect(find.text('Sin respaldos todavía.'), findsOneWidget);
    expect(find.byKey(const ValueKey('backups-toggle-all')), findsNothing);
  });

  testWidgets('«Crear backup» solo aparece si hay copia local', (tester) async {
    await pump(tester);
    expect(find.byKey(const ValueKey('backup-create-action')), findsNothing);

    var created = 0;
    await pump(tester, onCreate: () async => created++);
    await tester.tap(find.byKey(const ValueKey('backup-create-action')));
    await tester.pumpAndSettle();
    expect(created, 1);
  });

  testWidgets('recuerda las secciones abiertas', (tester) async {
    await pump(tester);

    await tester.tap(find.byKey(_header(BackupOrigin.preRestore)));
    await tester.pumpAndSettle();
    expect(await BackupsSectionsPrefs.load(), {BackupOrigin.preRestore});

    await tester.tap(find.byKey(const ValueKey('backups-toggle-all')));
    await tester.pumpAndSettle();
    expect(await BackupsSectionsPrefs.load(), BackupOrigin.values.toSet());
  });

  testWidgets('initialOpen abre directamente las secciones recordadas', (
    tester,
  ) async {
    await pump(tester, open: {BackupOrigin.manual});

    expect(find.byKey(_restore(_manual1)), findsOneWidget);
    expect(find.byKey(_restore(_auto2)), findsNothing);
  });

  testWidgets('con animaciones desactivadas se despliega sin esperar', (
    tester,
  ) async {
    await pump(tester, disableAnimations: true);

    await tester.tap(find.byKey(_header(BackupOrigin.manual)));
    await tester.pump();

    expect(find.byKey(_restore(_manual1)), findsOneWidget);
    expect(
      tester
          .getSize(
            find.byKey(
              const ValueKey(
                'backup-row-${'Granja_1_backup_20261020-180200.zip'}',
              ),
            ),
          )
          .height,
      greaterThan(40),
    );
  });

  testWidgets(
    'el plegado anima 200 ms: a mitad la sección está a medio abrir',
    (tester) async {
      await pump(tester);
      final section = find.byKey(const ValueKey('backups-section-manual'));
      final closedHeight = tester.getSize(section).height;

      await tester.tap(find.byKey(_header(BackupOrigin.manual)));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));
      final midHeight = tester.getSize(section).height;
      await tester.pump(const Duration(milliseconds: 150));
      final openHeight = tester.getSize(section).height;

      expect(midHeight, greaterThan(closedHeight));
      expect(midHeight, lessThan(openHeight));
      await tester.pumpAndSettle();
    },
  );
  testWidgets('ningún texto del diálogo baja de 11 px', (tester) async {
    await pump(tester, open: BackupOrigin.values.toSet());

    final small = <String>[];
    for (final text in tester.widgetList<Text>(find.byType(Text))) {
      final size = text.style?.fontSize;
      if (size != null && size < 11) {
        small.add('${text.data ?? text.textSpan} ($size)');
      }
    }
    expect(small, isEmpty);
  });
}
