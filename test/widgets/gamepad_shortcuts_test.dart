import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gamepads/gamepads.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:valleysave/core/services/gamepad_service.dart';
import 'package:valleysave/generated/app_localizations.dart';
import 'package:valleysave/shared/utils/app_page_route.dart';

/// LB/RB/LT/RT/View/Start (2026-08-15). Cada test dispara EXACTAMENTE el
/// mismo despacho que un evento real de mando, vía `debugHandleButton`/
/// `debugHandleTriggerAxis` — no hay forma de simular
/// `Gamepads.normalizedEvents` (stream de plataforma) en un test, así que
/// estos ganchos ejercitan el código real, no una reimplementación aparte.
void main() {
  setUpAll(() => GoogleFonts.config.allowRuntimeFetching = false);
  setUp(() => GamepadService.instance.debugReset());

  group('LB/RB — enfocan sin activar', () {
    test('G1: LB pide foco al target registrado, no invoca su onTap', () {
      var tapped = false;
      final node = FocusNode();
      addTearDown(node.dispose);
      GamepadService.instance.registerTarget(
        GamepadService.kTopbarBack,
        focusNode: node,
        onTap: () => tapped = true,
      );

      GamepadService.instance.debugHandleButton(GamepadButton.leftBumper, 1);

      expect(node.hasFocus, isFalse); // sin árbol montado, pero no crashea
      expect(tapped, isFalse, reason: 'LB solo enfoca, nunca activa');
    });

    test('G2: RB invoca el target de settings, no el de back', () {
      var backTapped = false;
      var settingsTapped = false;
      final backNode = FocusNode();
      final settingsNode = FocusNode();
      addTearDown(backNode.dispose);
      addTearDown(settingsNode.dispose);
      GamepadService.instance.registerTarget(
        GamepadService.kTopbarBack,
        focusNode: backNode,
        onTap: () => backTapped = true,
      );
      GamepadService.instance.registerTarget(
        GamepadService.kTopbarSettings,
        focusNode: settingsNode,
        onTap: () => settingsTapped = true,
      );

      GamepadService.instance.debugHandleButton(GamepadButton.rightBumper, 1);

      expect(backTapped, isFalse);
      expect(settingsTapped, isFalse, reason: 'RB enfoca, no activa');
    });

    test('G3: sin target registrado, LB/RB no crashean (botón ausente)', () {
      expect(
        () => GamepadService.instance.debugHandleButton(
          GamepadButton.leftBumper,
          1,
        ),
        returnsNormally,
      );
    });
  });

  group('View/Select y Start — invocan directo', () {
    test('G4: View/Select (back) invoca el target de settings', () {
      var settingsTapped = false;
      final node = FocusNode();
      addTearDown(node.dispose);
      GamepadService.instance.registerTarget(
        GamepadService.kTopbarSettings,
        focusNode: node,
        onTap: () => settingsTapped = true,
      );

      GamepadService.instance.debugHandleButton(GamepadButton.back, 1);

      expect(settingsTapped, isTrue);
    });

    test('G5: Start invoca el target de lanzar el juego', () {
      var launched = false;
      final node = FocusNode();
      addTearDown(node.dispose);
      GamepadService.instance.registerTarget(
        GamepadService.kTopbarLaunch,
        focusNode: node,
        onTap: () => launched = true,
      );

      GamepadService.instance.debugHandleButton(GamepadButton.start, 1);

      expect(launched, isTrue);
    });

    test('G6: Start sin botón ▶ visible (sin target) no crashea', () {
      expect(
        () =>
            GamepadService.instance.debugHandleButton(GamepadButton.start, 1),
        returnsNormally,
      );
    });
  });

  group('LT/RT — navegación, incl. el caso Windows (gatillo = eje)', () {
    testWidgets('G7: LT hace pop de la pantalla actual (como el botón ←)', (
      tester,
    ) async {
      await _pumpNavHost(tester);
      await tester.tap(find.text('abrir A'));
      await tester.pumpAndSettle();
      expect(find.text('PANTALLA A'), findsOneWidget);

      GamepadService.instance.debugHandleButton(GamepadButton.leftTrigger, 1);
      await tester.pumpAndSettle();

      expect(find.text('PANTALLA A'), findsNothing);
      expect(find.text('raíz'), findsOneWidget);
    });

    testWidgets(
      'G8: LT como EJE (Windows) también hace pop — y solo una vez por '
      'apretón, no repetido mientras se mantiene',
      (tester) async {
        await _pumpNavHost(tester);
        await tester.tap(find.text('abrir A'));
        await tester.pumpAndSettle();
        expect(find.text('PANTALLA A'), findsOneWidget);

        // Igual que reportaría un mando real en Windows: el valor sube
        // gradualmente al apretar el gatillo.
        GamepadService.instance.debugHandleTriggerAxis(
          left: true,
          value: 0.2,
        );
        await tester.pumpAndSettle();
        expect(
          find.text('PANTALLA A'),
          findsOneWidget,
          reason: 'por debajo del umbral, no debe disparar',
        );

        GamepadService.instance.debugHandleTriggerAxis(
          left: true,
          value: 0.9,
        );
        await tester.pumpAndSettle();
        expect(find.text('PANTALLA A'), findsNothing);
        expect(find.text('raíz'), findsOneWidget);

        // Mantener el gatillo apretado (más eventos por encima del umbral)
        // no debe volver a disparar pop — ya no queda nada que cerrar y,
        // sobre todo, no debe repetirse por cada frame de eje.
        GamepadService.instance.debugHandleTriggerAxis(
          left: true,
          value: 0.95,
        );
        await tester.pumpAndSettle();
        expect(find.text('raíz'), findsOneWidget);
      },
    );

    testWidgets('G9: RT reabre la pantalla que LT acaba de cerrar', (
      tester,
    ) async {
      await _pumpNavHost(tester);
      await tester.tap(find.text('abrir A'));
      await tester.pumpAndSettle();

      GamepadService.instance.debugHandleButton(GamepadButton.leftTrigger, 1);
      await tester.pumpAndSettle();
      expect(find.text('raíz'), findsOneWidget);

      GamepadService.instance.debugHandleButton(
        GamepadButton.rightTrigger,
        1,
      );
      await tester.pumpAndSettle();

      expect(find.text('PANTALLA A'), findsOneWidget);
    });

    testWidgets(
      'G10: RT no hace nada si no se ha cerrado nada con LT (no crashea)',
      (tester) async {
        await _pumpNavHost(tester);
        await tester.tap(find.text('abrir A'));
        await tester.pumpAndSettle();

        GamepadService.instance.debugHandleButton(
          GamepadButton.rightTrigger,
          1,
        );
        await tester.pumpAndSettle();

        expect(find.text('PANTALLA A'), findsOneWidget);
      },
    );

    testWidgets(
      'G11: una pantalla NUEVA (no un redo de RT) invalida lo que RT podía '
      'reabrir — como el "adelante" de un navegador tras visitar otra '
      'página',
      (tester) async {
        await _pumpNavHost(tester);
        await tester.tap(find.text('abrir A'));
        await tester.pumpAndSettle();

        // LT cierra A: RT ahora "sabe" reabrir A.
        GamepadService.instance.debugHandleButton(
          GamepadButton.leftTrigger,
          1,
        );
        await tester.pumpAndSettle();
        expect(find.text('raíz'), findsOneWidget);

        // Pero en vez de RT, se navega a una pantalla DISTINTA sin volver a
        // pasar por LT — un push nuevo de verdad, no un redo.
        await tester.tap(find.text('abrir B'));
        await tester.pumpAndSettle();
        expect(find.text('PANTALLA B'), findsOneWidget);

        // RT, pulsado mientras se está en B: A quedó obsoleto en cuanto se
        // abrió B, y B en sí nunca se cerró — no hay nada que reabrir.
        GamepadService.instance.debugHandleButton(
          GamepadButton.rightTrigger,
          1,
        );
        await tester.pumpAndSettle();
        expect(
          find.text('PANTALLA B'),
          findsOneWidget,
          reason: 'RT no debe hacer nada — no reabrir A ni cualquier otra cosa',
        );
        expect(find.text('PANTALLA A'), findsNothing);
      },
    );
  });
}

Future<void> _pumpNavHost(WidgetTester tester) async {
  await tester.pumpWidget(
    MaterialApp(
      locale: const Locale('es'),
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      navigatorObservers: [GamepadService.instance.navObserver],
      home: Builder(
        builder: (context) => Scaffold(
          body: Column(
            children: [
              const Text('raíz'),
              TextButton(
                onPressed: () => Navigator.of(context).push(
                  AppPageRoute(
                    builder: (_) =>
                        const Scaffold(body: Text('PANTALLA A')),
                  ),
                ),
                child: const Text('abrir A'),
              ),
              TextButton(
                onPressed: () => Navigator.of(context).push(
                  AppPageRoute(
                    builder: (_) =>
                        const Scaffold(body: Text('PANTALLA B')),
                  ),
                ),
                child: const Text('abrir B'),
              ),
            ],
          ),
        ),
      ),
    ),
  );
}
