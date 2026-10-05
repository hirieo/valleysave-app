import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show LogicalKeyboardKey;
import 'package:flutter_test/flutter_test.dart';
import 'package:gamepads/gamepads.dart';
import 'package:valleysave/core/services/gamepad_service.dart';
import 'package:valleysave/features/saves/widgets/card_focus_frame.dart';

/// Selección de partida a dos niveles (2026-08-15). Nivel 1 (recuadro
/// entero, arriba/abajo mueve la selección) / nivel 2 (A entra, B sale).
/// Cada test dispara el despacho REAL: `DirectionalFocusIntent`/
/// `ActivateIntent`/`DismissIntent` vía `Actions.invoke`, el mismo camino
/// que usa el teclado de serie y que `GamepadService._moveOnce` usa ahora
/// (antes llamaba a `focusInDirection` directo, sin pasar por aquí — sin
/// ese cambio, estos tests pasarían con teclado pero el mando seguiría
/// saltándose por completo la selección a dos niveles).
void main() {
  setUp(() => GamepadService.instance.debugReset());

  Widget buildHost({
    required List<String> cardIds,
    required Map<String, FocusNode> registry,
  }) {
    return MaterialApp(
      home: Scaffold(
        body: Column(
          children: [
            for (var i = 0; i < cardIds.length; i++)
              CardFocusFrame(
                cardId: cardIds[i],
                registerNode: (id, node) => registry[id] = node,
                unregisterNode: registry.remove,
                canMoveSelection: (delta) {
                  final target = i + delta;
                  return target >= 0 && target < cardIds.length;
                },
                onMoveSelection: (delta) {
                  final target = i + delta;
                  if (target < 0 || target >= cardIds.length) return;
                  registry[cardIds[target]]?.requestFocus();
                },
                child: SizedBox(
                  key: ValueKey('card-${cardIds[i]}'),
                  height: 80,
                  child: TextButton(
                    key: ValueKey('button-${cardIds[i]}'),
                    onPressed: () {},
                    child: Text('botón de ${cardIds[i]}'),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  // Despacha SIEMPRE desde el contexto del nodo con foco real — igual que
  // `GamepadService._moveOnce`/`_activate`/`_dismiss` en producción.
  // `Actions.invoke` solo busca hacia ARRIBA desde el contexto dado; pasar
  // el contexto del `Scaffold` (ancestro común de las 3 tarjetas) se salta
  // por completo el `Actions` propio de `CardFocusFrame`, que está por
  // DEBAJO — primer intento de este archivo, corregido tras verlo fallar.
  BuildContext focusedContext() {
    final ctx = FocusManager.instance.primaryFocus?.context;
    expect(ctx, isNotNull, reason: 'nada tiene el foco en este punto');
    return ctx!;
  }

  void moveDirection(WidgetTester tester, TraversalDirection dir) {
    Actions.maybeInvoke(focusedContext(), DirectionalFocusIntent(dir));
  }

  testWidgets(
    'G1: abajo en nivel 1 mueve la selección entera a la siguiente '
    'tarjeta, no a un botón interno',
    (tester) async {
      final registry = <String, FocusNode>{};
      await tester.pumpWidget(
        buildHost(cardIds: ['a', 'b', 'c'], registry: registry),
      );
      registry['a']!.requestFocus();
      await tester.pumpAndSettle();
      expect(registry['a']!.hasFocus, isTrue);

      moveDirection(tester, TraversalDirection.down);
      await tester.pumpAndSettle();

      expect(registry['b']!.hasPrimaryFocus, isTrue);
      expect(registry['a']!.hasFocus, isFalse);
      // Y sobre todo: NO aterriza en el botón interno de 'a' ni de 'b' — el
      // nodo con el foco PRIMARIO debe ser el propio nivel 1 de 'b', no un
      // descendiente suyo (`hasFocus` sería true en ambos casos, por eso
      // `hasPrimaryFocus` es la comprobación que de verdad distingue esto).
      expect(FocusManager.instance.primaryFocus, same(registry['b']));
    },
  );

  testWidgets('G2: arriba en nivel 1 vuelve a la tarjeta anterior', (
    tester,
  ) async {
    final registry = <String, FocusNode>{};
    await tester.pumpWidget(
      buildHost(cardIds: ['a', 'b', 'c'], registry: registry),
    );
    registry['b']!.requestFocus();
    await tester.pumpAndSettle();

    moveDirection(tester, TraversalDirection.up);
    await tester.pumpAndSettle();

    expect(registry['a']!.hasFocus, isTrue);
  });

  testWidgets(
    'G3: en los extremos, arriba/abajo no hace nada (no hay tarjeta en '
    'esa dirección)',
    (tester) async {
      final registry = <String, FocusNode>{};
      await tester.pumpWidget(
        buildHost(cardIds: ['a', 'b', 'c'], registry: registry),
      );
      registry['a']!.requestFocus();
      await tester.pumpAndSettle();

      moveDirection(tester, TraversalDirection.up);
      await tester.pumpAndSettle();
      expect(registry['a']!.hasFocus, isTrue, reason: 'sigue en la primera');

      registry['c']!.requestFocus();
      await tester.pumpAndSettle();
      moveDirection(tester, TraversalDirection.down);
      await tester.pumpAndSettle();
      expect(registry['c']!.hasFocus, isTrue, reason: 'sigue en la última');
    },
  );

  testWidgets(
    'G4: A entra — el foco pasa al botón interno de la tarjeta actual',
    (tester) async {
      final registry = <String, FocusNode>{};
      await tester.pumpWidget(
        buildHost(cardIds: ['a', 'b', 'c'], registry: registry),
      );
      registry['b']!.requestFocus();
      await tester.pumpAndSettle();

      Actions.maybeInvoke(focusedContext(), const ActivateIntent());
      await tester.pumpAndSettle();

      expect(
        find
            .descendant(
              of: find.byKey(const ValueKey('card-b')),
              matching: find.byKey(const ValueKey('button-b')),
            )
            .evaluate()
            .isNotEmpty,
        isTrue,
      );
      final btnFinder = find.byKey(const ValueKey('button-b'));
      final btnElement = tester.element(btnFinder);
      expect(
        Focus.of(btnElement).hasFocus,
        isTrue,
        reason: 'A debe mover el foco real al botón interno',
      );
      // `_level1Node` ENVUELVE al botón, así que `hasFocus` (que mira todo
      // el subárbol) seguiría dando true aunque el foco ya se haya movido
      // dentro — la comprobación real es que ya NO es el foco PRIMARIO.
      expect(registry['b']!.hasPrimaryFocus, isFalse);
    },
  );

  testWidgets(
    'G5: en nivel 2 (ya entrado), abajo deja de estar interceptado por '
    'CardFocusFrame — usa el comportamiento normal de foco, EXACTAMENTE '
    'como pidió el usuario ("eso lo definimos después"). En este arnés '
    '(una tarjeta = un solo botón) eso significa que, al no haber más '
    'controles dentro de "b", el foco geométrico cae en el SELECTOR de '
    'nivel 1 de "c" — nunca en un botón interno de otra tarjeta, porque '
    'esos siguen excluidos (ExcludeFocus) mientras no se ha entrado en '
    'ellas. No es un salto de "nivel 2 de b" a "nivel 2 de c": es "salir '
    'de b hacia el nivel 1 de c", el mismo aterrizaje que arriba/abajo '
    'usa en cualquier otro punto del nivel 1.',
    (tester) async {
      final registry = <String, FocusNode>{};
      await tester.pumpWidget(
        buildHost(cardIds: ['a', 'b', 'c'], registry: registry),
      );
      registry['b']!.requestFocus();
      await tester.pumpAndSettle();
      Actions.maybeInvoke(focusedContext(), const ActivateIntent());
      await tester.pumpAndSettle();
      expect(Focus.of(tester.element(find.byKey(const ValueKey('button-b')))).hasFocus, isTrue);

      moveDirection(tester, TraversalDirection.down);
      await tester.pumpAndSettle();

      // Nunca aterriza en el BOTÓN interno de otra tarjeta (seguiría
      // excluido) — a lo sumo, en su selector de nivel 1.
      expect(
        Focus.of(
          tester.element(find.byKey(const ValueKey('button-c'))),
        ).hasFocus,
        isFalse,
        reason: 'el botón interno de "c" sigue excluido — no se ha entrado en ella',
      );
    },
  );

  testWidgets(
    'G6: B sale — devuelve el foco al nivel 1 de la MISMA tarjeta',
    (tester) async {
      final registry = <String, FocusNode>{};
      await tester.pumpWidget(
        buildHost(cardIds: ['a', 'b', 'c'], registry: registry),
      );
      registry['b']!.requestFocus();
      await tester.pumpAndSettle();
      Actions.maybeInvoke(focusedContext(), const ActivateIntent());
      await tester.pumpAndSettle();

      Actions.maybeInvoke(focusedContext(), const DismissIntent());
      await tester.pumpAndSettle();

      expect(registry['b']!.hasFocus, isTrue);
    },
  );

  testWidgets(
    'G7: sin haber entrado (nivel 1), B no hace nada raro — sigue en la '
    'misma tarjeta',
    (tester) async {
      final registry = <String, FocusNode>{};
      await tester.pumpWidget(
        buildHost(cardIds: ['a', 'b', 'c'], registry: registry),
      );
      registry['b']!.requestFocus();
      await tester.pumpAndSettle();

      Actions.maybeInvoke(focusedContext(), const DismissIntent());
      await tester.pumpAndSettle();

      expect(registry['b']!.hasFocus, isTrue);
    },
  );

  testWidgets(
    'G8: el botón interno queda excluido del foco mientras no se ha '
    'entrado (ExcludeFocus) — Tab no puede aterrizar ahí',
    (tester) async {
      final registry = <String, FocusNode>{};
      await tester.pumpWidget(
        buildHost(cardIds: ['a'], registry: registry),
      );
      registry['a']!.requestFocus();
      await tester.pumpAndSettle();

      await tester.sendKeyEvent(LogicalKeyboardKey.tab);
      await tester.pumpAndSettle();

      final btnElement = tester.element(
        find.byKey(const ValueKey('button-a')),
      );
      expect(
        Focus.of(btnElement).hasFocus,
        isFalse,
        reason: 'con una sola tarjeta, Tab no debe poder entrar en su botón',
      );
    },
  );

  testWidgets(
    'G9: integración real con GamepadService — dpadDown mueve la '
    'selección de tarjeta igual que el teclado (verifica el fix de '
    '_moveOnce, que antes se saltaba Actions por completo)',
    (tester) async {
      final registry = <String, FocusNode>{};
      await tester.pumpWidget(
        buildHost(cardIds: ['a', 'b', 'c'], registry: registry),
      );
      registry['a']!.requestFocus();
      await tester.pumpAndSettle();

      GamepadService.instance.debugHandleButton(GamepadButton.dpadDown, 1);
      await tester.pumpAndSettle();

      expect(registry['b']!.hasFocus, isTrue);
    },
  );

  testWidgets(
    'G10: arriba en la PRIMERA tarjeta escapa a un control de fuera de la '
    'lista, en vez de quedarse consumido sin hacer nada (feedback en vivo '
    '2026-08: antes no escapaba)',
    (tester) async {
      final registry = <String, FocusNode>{};
      final aboveNode = FocusNode(debugLabel: 'FueraDeLaLista');
      addTearDown(aboveNode.dispose);
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Column(
              children: [
                Focus(
                  focusNode: aboveNode,
                  child: const SizedBox(
                    key: ValueKey('above'),
                    height: 40,
                    width: 200,
                  ),
                ),
                for (final id in ['a', 'b'])
                  CardFocusFrame(
                    cardId: id,
                    registerNode: (i, n) => registry[i] = n,
                    unregisterNode: registry.remove,
                    canMoveSelection: (delta) {
                      final ids = ['a', 'b'];
                      final target = ids.indexOf(id) + delta;
                      return target >= 0 && target < ids.length;
                    },
                    onMoveSelection: (delta) {
                      final ids = ['a', 'b'];
                      final target = ids.indexOf(id) + delta;
                      if (target < 0 || target >= ids.length) return;
                      registry[ids[target]]?.requestFocus();
                    },
                    child: SizedBox(height: 80, width: 200),
                  ),
              ],
            ),
          ),
        ),
      );
      registry['a']!.requestFocus();
      await tester.pumpAndSettle();

      Actions.maybeInvoke(
        focusedContext(),
        const DirectionalFocusIntent(TraversalDirection.up),
      );
      await tester.pumpAndSettle();

      expect(
        aboveNode.hasPrimaryFocus,
        isTrue,
        reason:
            'al no poder subir dentro de la lista, el intent debe '
            'propagarse y el `DirectionalFocusAction` por defecto debe '
            'encontrar el control de arriba geométricamente',
      );
    },
  );

  testWidgets(
    'G11: al mover la selección a una tarjeta fuera de la vista, la '
    'pantalla hace scroll para mostrarla (feedback en vivo 2026-08: antes '
    'la selección se movía pero la pantalla no la seguía)',
    (tester) async {
      final registry = <String, FocusNode>{};
      final scrollController = ScrollController();
      addTearDown(scrollController.dispose);
      final ids = List.generate(12, (i) => 'card$i');

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SizedBox(
              height: 400,
              child: ListView(
                controller: scrollController,
                children: [
                  for (var i = 0; i < ids.length; i++)
                    CardFocusFrame(
                      cardId: ids[i],
                      registerNode: (id, n) => registry[id] = n,
                      unregisterNode: registry.remove,
                      canMoveSelection: (delta) {
                        final target = i + delta;
                        return target >= 0 && target < ids.length;
                      },
                      onMoveSelection: (delta) {
                        final target = i + delta;
                        if (target < 0 || target >= ids.length) return;
                        registry[ids[target]]?.requestFocus();
                      },
                      child: SizedBox(
                        key: ValueKey('card-${ids[i]}'),
                        height: 120,
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),
      );
      registry[ids[0]]!.requestFocus();
      await tester.pumpAndSettle();
      final initialOffset = scrollController.offset;

      // Salta varias tarjetas de golpe — todas fuera del viewport inicial
      // de 400px con tarjetas de 120px.
      for (var i = 0; i < 6; i++) {
        Actions.maybeInvoke(
          focusedContext(),
          const DirectionalFocusIntent(TraversalDirection.down),
        );
        await tester.pumpAndSettle();
      }

      expect(
        scrollController.offset,
        greaterThan(initialOffset),
        reason:
            'la lista debe haber hecho scroll para seguir la tarjeta '
            'seleccionada, que ya no cabía en el viewport inicial',
      );
    },
  );
}
