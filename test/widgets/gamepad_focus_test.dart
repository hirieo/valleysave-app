import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:valleysave/core/models/player_stats.dart';
import 'package:valleysave/core/models/save_entry.dart';
import 'package:valleysave/core/models/save_file.dart';
import 'package:valleysave/features/saves/save_card.dart';
import 'package:valleysave/features/saves/widgets/save_detail_sheet.dart';
import 'package:valleysave/generated/app_localizations.dart';
import 'package:valleysave/shared/widgets/glass_dialog.dart';

/// Navegación con mando/teclado (2026-08-14). Cubre las dos propiedades que
/// NO se pueden dar por buenas leyendo el código:
///
/// G1-G3: al abrir un diálogo el foco cae en la opción que no hace daño,
///        aunque la destructiva vaya ANTES en el árbol (que es el caso en
///        todos los diálogos de la app, por jerarquía visual).
/// G4-G5: en la hoja de detalle las flechas ←/→ siguen cambiando de cara
///        después de mover el manejo a `Shortcuts` — incluido el caso que
///        antes fallaba: con el foco puesto en un botón, no en la hoja.
void main() {
  setUpAll(() => GoogleFonts.config.allowRuntimeFetching = false);

  group('foco inicial en diálogos', () {
    testWidgets(
      'G1: el foco cae en Cancelar aunque el destructivo vaya primero',
      (tester) async {
        final pressed = <String>[];
        await _pumpDialogHost(tester, pressed);

        await tester.tap(find.text('abrir'));
        await tester.pumpAndSettle();

        // Ambos botones existen y el destructivo está declarado antes.
        expect(find.text('BORRAR'), findsOneWidget);
        expect(find.text('CANCELAR'), findsOneWidget);

        final focused = _focusedActionBtnLabel(tester);
        expect(
          focused,
          'CANCELAR',
          reason: 'el foco inicial debe estar en la opción segura',
        );
      },
    );

    testWidgets('G2: pulsar "aceptar" (A / Enter) cancela, no borra', (
      tester,
    ) async {
      final pressed = <String>[];
      await _pumpDialogHost(tester, pressed);

      await tester.tap(find.text('abrir'));
      await tester.pumpAndSettle();

      // Mismo camino que usa GamepadService para el botón A: invoca
      // ActivateIntent sobre el contexto de quien tiene el foco.
      final context = FocusManager.instance.primaryFocus!.context!;
      Actions.invoke(context, const ActivateIntent());
      await tester.pumpAndSettle();

      expect(pressed, ['cancelar']);
      expect(
        pressed,
        isNot(contains('borrar')),
        reason: 'una pulsación a ciegas nunca debe destruir nada',
      );
    });

    testWidgets('G3: en escritorio el botón enfocado pinta el anillo', (
      tester,
    ) async {
      // El anillo depende de `FocusManager.highlightMode`, que en los tests
      // arranca en `touch` (la plataforma por defecto es android). En
      // escritorio el modo real es `traditional`, así que hay que forzarlo
      // para probar lo que de verdad verá el usuario en Windows.
      FocusManager.instance.highlightStrategy =
          FocusHighlightStrategy.alwaysTraditional;
      addTearDown(
        () => FocusManager.instance.highlightStrategy =
            FocusHighlightStrategy.automatic,
      );

      final pressed = <String>[];
      await _pumpDialogHost(tester, pressed);

      await tester.tap(find.text('abrir'));
      await tester.pumpAndSettle();

      final decoration = _decorationOf(tester, 'CANCELAR');
      expect(decoration.boxShadow, isNotEmpty);
      expect(decoration.border!.top.width, greaterThan(1.0));

      // El botón destructivo NO lo pinta: el anillo debe distinguir uno de
      // otro, no encenderse en los dos.
      expect(_decorationOf(tester, 'BORRAR').boxShadow, anyOf(isNull, isEmpty));
    });

    testWidgets('G6: en móvil (touch) no aparece anillo alguno', (
      tester,
    ) async {
      // Contrapartida de G3: al tocar con el dedo el modo es `touch` y el
      // anillo se queda apagado — el foco existe igual, pero no se pinta.
      // Documenta por qué este cambio no altera nada en Android/iOS.
      expect(FocusManager.instance.highlightMode, FocusHighlightMode.touch);

      final pressed = <String>[];
      await _pumpDialogHost(tester, pressed);

      await tester.tap(find.text('abrir'));
      await tester.pumpAndSettle();

      expect(_focusedActionBtnLabel(tester), 'CANCELAR');
      expect(
        _decorationOf(tester, 'CANCELAR').boxShadow,
        anyOf(isNull, isEmpty),
      );
    });
  });

  group('hoja de detalle — flechas desacopladas del foco', () {
    testWidgets('G4: el foco inicial NO se queda en la hoja, va a un control', (
      tester,
    ) async {
      await _pumpDetailHost(tester);
      await tester.tap(find.text('abrir'));
      await tester.pumpAndSettle();

      final focused = FocusManager.instance.primaryFocus!;
      // Antes el foco se quedaba en un `Focus` invisible sin contexto de
      // widget interactivo: con mando, A no hacía nada.
      expect(focused.context, isNotNull);
      final hasActivate = Actions.maybeFind<ActivateIntent>(
        focused.context!,
        intent: const ActivateIntent(),
      );
      expect(
        hasActivate,
        isNotNull,
        reason: 'quien tiene el foco debe responder a A / Enter',
      );
    });

    testWidgets('G5: ←/→ cambian de cara con el foco puesto en un botón', (
      tester,
    ) async {
      await _pumpDetailHost(tester);
      await tester.tap(find.text('abrir'));
      await tester.pumpAndSettle();

      expect(find.byKey(const ValueKey('save-detail-local')), findsOneWidget);

      // Precondición explícita — sin esto el test pasaría con el foco puesto
      // en la propia hoja, que es justo el caso que YA funcionaba antes del
      // refactor: no probaría nada. Se exige que el foco esté en un control
      // con acción, o sea por debajo del `Shortcuts` pero no en él.
      final focused = FocusManager.instance.primaryFocus!;
      expect(
        focused.debugLabel,
        isNot('DetailSheetAnchor'),
        reason: 'el foco debe haberse cedido a un control antes de probar',
      );
      expect(
        Actions.maybeFind<ActivateIntent>(
          focused.context!,
          intent: const ActivateIntent(),
        ),
        isNotNull,
      );

      // Caso que fallaba antes: con `onKeyEvent` atado al `Focus` de la hoja,
      // la flecha se perdía en cuanto el foco estaba en un botón. Con
      // `Shortcuts` en la raíz sigue llegando.
      await tester.sendKeyEvent(LogicalKeyboardKey.arrowRight);
      await tester.pumpAndSettle();
      expect(find.byKey(const ValueKey('save-detail-drive')), findsOneWidget);

      await tester.sendKeyEvent(LogicalKeyboardKey.arrowLeft);
      await tester.pumpAndSettle();
      expect(find.byKey(const ValueKey('save-detail-local')), findsOneWidget);
    });
  });
}

/// Reproduce la forma real de los diálogos de la app: `dialogBody` con el
/// botón destructivo declarado ANTES del seguro, y `autofocus` en el seguro.
Future<void> _pumpDialogHost(WidgetTester tester, List<String> pressed) async {
  await tester.pumpWidget(
    MaterialApp(
      locale: const Locale('es'),
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: Builder(
        builder: (context) => TextButton(
          onPressed: () => showDialog<void>(
            context: context,
            builder: (ctx) => Dialog(
              backgroundColor: Colors.transparent,
              child: glassDialogShell(
                ctx,
                accent: const Color(0xFFE8B84A),
                child: dialogBody(
                  title: const Text('¿Borrar la partida?'),
                  content: const Text('No se puede deshacer.'),
                  actions: [
                    ActionBtn(
                      label: 'BORRAR',
                      color: const Color(0xFFE05252),
                      filled: true,
                      onTap: () => pressed.add('borrar'),
                    ),
                    ActionBtn(
                      label: 'CANCELAR',
                      autofocus: true,
                      color: Colors.white.withValues(alpha: 0.55),
                      filled: false,
                      onTap: () => pressed.add('cancelar'),
                    ),
                  ],
                ),
              ),
            ),
          ),
          child: const Text('abrir'),
        ),
      ),
    ),
  );
}

Future<void> _pumpDetailHost(WidgetTester tester) async {
  tester.view.physicalSize = const Size(900, 1600);
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.resetPhysicalSize);
  addTearDown(tester.view.resetDevicePixelRatio);

  final host = _player('Ana', '111', isHost: true);
  final local = _save(players: [host]);
  final drive = _save(players: [host]);

  await tester.pumpWidget(
    MaterialApp(
      locale: const Locale('es'),
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: Builder(
        builder: (context) => TextButton(
          onPressed: () => showSaveDetail(
            context,
            entry: SaveEntry(local: local, drive: drive),
            startOnLocal: true,
            onUpload: () {},
            onDownload: () {},
          ),
          child: const Text('abrir'),
        ),
      ),
    ),
  );
}

/// Decoración que `ActionBtn` pinta para la etiqueta dada.
BoxDecoration _decorationOf(WidgetTester tester, String label) {
  final container = tester.widget<AnimatedContainer>(
    find
        .descendant(
          of: find.ancestor(
            of: find.text(label),
            matching: find.byType(ActionBtn),
          ),
          matching: find.byType(AnimatedContainer),
        )
        .first,
  );
  return container.decoration! as BoxDecoration;
}

/// Etiqueta del `ActionBtn` que tiene el foco primario, o null si el foco no
/// está en ninguno.
String? _focusedActionBtnLabel(WidgetTester tester) {
  final focused = FocusManager.instance.primaryFocus;
  if (focused?.context == null) return null;
  final ancestor = focused!.context!
      .findAncestorWidgetOfExactType<ActionBtn>();
  return ancestor?.label;
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
    gameVersion: '1.6.15',
    players: players,
  );
}
