import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';

/// Nivel 1/nivel 2 de selección de partida (2026-08-15, petición explícita
/// del usuario). Envuelve una tarjeta (`SaveCard`/`SharedSaveCard`) para que
/// arriba/abajo mueva la selección entre RECUADROS enteros (nivel 1) en vez
/// de aterrizar en un botón suelto de dentro — sin esto, con todo ya
/// focusable tras el barrido "vamos con todos", D-pad/stick trataban cada
/// botón interno de cada tarjeta como un paso más del mismo recorrido
/// plano, sin ningún nivel de "qué partida estoy mirando".
///
/// - **Nivel 1** (nada más llegar, o tras B): la tarjeta ENTERA tiene el
///   anillo. Arriba/abajo mueve esa selección a la tarjeta anterior/
///   siguiente — los botones internos quedan excluidos del árbol de foco
///   ([ExcludeFocus]), así no compiten geométricamente con el salto entre
///   tarjetas.
/// - **Nivel 2** (tras A): el marco exterior baja a un borde tenue fijo
///   (marca "sigues dentro de esta"), los botones internos vuelven a ser
///   focusables y la navegación entre ellos es la que ya existía antes de
///   este cambio (sin cambios — el usuario pidió dejarlo para más
///   adelante). B devuelve el foco al nivel 1 de esta misma tarjeta.
class CardFocusFrame extends StatefulWidget {
  const CardFocusFrame({
    super.key,
    required this.cardId,
    required this.registerNode,
    required this.unregisterNode,
    required this.canMoveSelection,
    required this.onMoveSelection,
    required this.child,
  });

  /// Identidad estable (p. ej. `folderName`) — clave bajo la que el padre
  /// guarda el `FocusNode` de nivel 1 de esta tarjeta.
  final String cardId;
  final void Function(String cardId, FocusNode node) registerNode;
  final void Function(String cardId) unregisterNode;

  /// `-1` = tarjeta anterior, `1` = siguiente. Comprobación PURA (sin
  /// efectos) de si existe una tarjeta en esa dirección — decide si este
  /// widget intercepta el intent o lo deja caer al comportamiento por
  /// defecto (feedback en vivo 2026-08: en la primera tarjeta, arriba debe
  /// escapar hacia la barra superior, no quedarse sin hacer nada).
  final bool Function(int delta) canMoveSelection;

  /// `-1` = tarjeta anterior, `1` = siguiente. Solo se llama cuando
  /// [canMoveSelection] ya devolvió `true` para ese mismo delta.
  final ValueChanged<int> onMoveSelection;

  final Widget child;

  @override
  State<CardFocusFrame> createState() => _CardFocusFrameState();
}

class _CardFocusFrameState extends State<CardFocusFrame> {
  final _level1Node = FocusNode(debugLabel: 'CardLevel1');
  bool _entered = false;

  @override
  void initState() {
    super.initState();
    widget.registerNode(widget.cardId, _level1Node);
  }

  @override
  void didUpdateWidget(CardFocusFrame old) {
    super.didUpdateWidget(old);
    if (old.cardId != widget.cardId) {
      old.unregisterNode(old.cardId);
      widget.registerNode(widget.cardId, _level1Node);
    }
  }

  @override
  void dispose() {
    widget.unregisterNode(widget.cardId);
    _level1Node.dispose();
    super.dispose();
  }

  void _enter() {
    setState(() => _entered = true);
    // Mismo patrón que `_DetailSheetState._handOffFocusOnce` (2026-08-15,
    // verificado con test G4 de esa pantalla): un `addPostFrameCallback`
    // aquí llegaría ANTES de que `setState` termine de aplicarse, pero lo
    // que de verdad importa es que `ExcludeFocus` ya haya dejado de excluir
    // — como eso ocurre en ESTE mismo build (más abajo), un post-frame
    // simple es suficiente y no hay carrera con ningún `autofocus` externo.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) _level1Node.nextFocus();
    });
  }

  void _exit() {
    setState(() => _entered = false);
    _level1Node.requestFocus();
  }

  void _onFocusChange(bool focused) {
    setState(() {});
    if (!focused) return;
    // Mismo patrón que `_SideTile._onFocusHighlight` (save_card.dart):
    // sin esto, moverse entre tarjetas con mando/teclado seleccionaba la
    // siguiente pero la pantalla no la seguía — feedback en vivo 2026-08.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final ctx = _level1Node.context;
      if (ctx == null || !ctx.mounted) return;
      Scrollable.ensureVisible(
        ctx,
        alignment: 0.5,
        duration: const Duration(milliseconds: 220),
        curve: Curves.easeOut,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Actions(
      actions: <Type, Action<Intent>>{
        ActivateIntent: CallbackAction<ActivateIntent>(
          onInvoke: (_) {
            if (_level1Node.hasFocus) _enter();
            return null;
          },
        ),
        // Ni `enabled`/`isEnabled` sirven aquí para "dejar pasar" el
        // intent hacia el `DirectionalFocusAction` por defecto de la app:
        // `Actions.invoke` para en el PRIMER `Actions` que declara ese tipo
        // de intent, esté habilitado o no — nunca sigue buscando más
        // arriba (verificado en el código fuente de `actions.dart`,
        // `_visitActionsAncestors`). Encontrado en pruebas en vivo: sin
        // este ajuste, arriba en la primera tarjeta quedaba consumido sin
        // hacer nada, en vez de escapar a la barra superior. Por eso este
        // `invoke` SIEMPRE reclama el intent, pero cuando no le toca
        // interceptar (nivel 2, izquierda/derecha, o borde de la lista)
        // hace EXACTAMENTE lo que haría el handler por defecto —
        // `primaryFocus.focusInDirection` — en vez de intentar cedérselo.
        DirectionalFocusIntent: CallbackAction<DirectionalFocusIntent>(
          onInvoke: (intent) {
            final delta = switch (intent.direction) {
              TraversalDirection.down => 1,
              TraversalDirection.up => -1,
              TraversalDirection.left ||
              TraversalDirection.right => null,
            };
            if (_entered || delta == null || !widget.canMoveSelection(delta)) {
              FocusManager.instance.primaryFocus?.focusInDirection(
                intent.direction,
              );
              return null;
            }
            widget.onMoveSelection(delta);
            return null;
          },
        ),
        DismissIntent: CallbackAction<DismissIntent>(
          onInvoke: (_) {
            if (_entered) _exit();
            return null;
          },
        ),
      },
      child: Focus(
        focusNode: _level1Node,
        onFocusChange: _onFocusChange,
        child: Builder(
          builder: (context) {
            final level1Focused = Focus.of(context).hasPrimaryFocus;
            return AnimatedContainer(
              duration: const Duration(milliseconds: 140),
              curve: Curves.easeOut,
              padding: const EdgeInsets.all(3),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                border: level1Focused
                    ? Border.all(color: AppColors.accent, width: 1.8)
                    : _entered
                        ? Border.all(
                            color: AppColors.accent.withValues(alpha: 0.45),
                            width: 1.4,
                          )
                        : null,
                boxShadow: level1Focused
                    ? [
                        BoxShadow(
                          color: AppColors.accentGlow,
                          blurRadius: 14,
                          spreadRadius: 1,
                        ),
                      ]
                    : null,
              ),
              child: ExcludeFocus(excluding: !_entered, child: widget.child),
            );
          },
        ),
      ),
    );
  }
}
