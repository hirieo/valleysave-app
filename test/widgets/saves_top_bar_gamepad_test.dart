import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gamepads/gamepads.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:valleysave/core/services/gamepad_service.dart';
import 'package:valleysave/features/saves/widgets/saves_top_bar.dart';
import 'package:valleysave/generated/app_localizations.dart';

/// Integración real (no solo `GamepadService` aislado): confirma que
/// `SavesTopBar` REGISTRA de verdad sus iconos con las claves que
/// `GamepadService` espera — si alguien renombra un `gamepadKey` o se le
/// olvida en un botón nuevo, esto lo detecta; los tests de
/// `gamepad_shortcuts_test.dart` no lo harían, ya que ahí el target se
/// registra a mano.
void main() {
  setUpAll(() => GoogleFonts.config.allowRuntimeFetching = false);
  setUp(() => GamepadService.instance.debugReset());

  Future<void> pumpTopBar(
    WidgetTester tester, {
    VoidCallback? onBack,
    VoidCallback? onSettings,
    VoidCallback? onLaunch,
    bool canLaunchGame = true,
  }) async {
    await tester.pumpWidget(
      MaterialApp(
        locale: const Locale('es'),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: Scaffold(
          body: SavesTopBar(
            onBack: onBack ?? () {},
            onSettings: onSettings ?? () {},
            onRefresh: () {},
            refreshing: false,
            canLaunchGame: canLaunchGame,
            onLaunch: onLaunch ?? () {},
            onImport: () {},
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  testWidgets('G12: RB enfoca de verdad el icono ⚙ de SavesTopBar', (
    tester,
  ) async {
    await pumpTopBar(tester);

    GamepadService.instance.debugHandleButton(GamepadButton.rightBumper, 1);
    await tester.pumpAndSettle();

    // El nodo con foco primario debe envolver, como descendiente, el icono
    // de Opciones — o sea, el foco cayó justo en ESE botón, no en cualquier
    // otro `IconCircleButton` de la barra.
    final focusedContext = FocusManager.instance.primaryFocus?.context;
    expect(focusedContext, isNotNull);
    expect(
      find
          .descendant(
            of: find.byWidgetPredicate(
              (w) => identical(w, focusedContext!.widget),
            ),
            matching: find.byIcon(Icons.settings_rounded),
          )
          .evaluate()
          .isNotEmpty,
      isTrue,
      reason: 'el nodo enfocado debe envolver el icono de Opciones',
    );
  });

  testWidgets('G13: LB enfoca de verdad el icono ← de SavesTopBar', (
    tester,
  ) async {
    await pumpTopBar(tester);

    GamepadService.instance.debugHandleButton(GamepadButton.leftBumper, 1);
    await tester.pumpAndSettle();

    final focusedContext = FocusManager.instance.primaryFocus?.context;
    expect(focusedContext, isNotNull);
    expect(
      find
          .descendant(
            of: find.byWidgetPredicate((w) => identical(w, focusedContext!.widget)),
            matching: find.byIcon(Icons.arrow_back_rounded),
          )
          .evaluate()
          .isNotEmpty,
      isTrue,
      reason: 'el nodo enfocado debe envolver el icono de atrás',
    );
  });

  testWidgets('G14: View/Select abre Opciones directo (invoca onSettings)', (
    tester,
  ) async {
    var opened = false;
    await pumpTopBar(tester, onSettings: () => opened = true);

    GamepadService.instance.debugHandleButton(GamepadButton.back, 1);
    await tester.pumpAndSettle();

    expect(opened, isTrue);
  });

  testWidgets('G15: Start lanza el juego (invoca onLaunch)', (tester) async {
    var launched = false;
    await pumpTopBar(tester, onLaunch: () => launched = true);

    GamepadService.instance.debugHandleButton(GamepadButton.start, 1);
    await tester.pumpAndSettle();

    expect(launched, isTrue);
  });

  testWidgets(
    'G16: sin botón ▶ visible (canLaunchGame: false), Start no crashea y '
    'no llama a onLaunch',
    (tester) async {
      var launched = false;
      await pumpTopBar(
        tester,
        onLaunch: () => launched = true,
        canLaunchGame: false,
      );

      GamepadService.instance.debugHandleButton(GamepadButton.start, 1);
      await tester.pumpAndSettle();

      expect(launched, isFalse);
    },
  );
}
