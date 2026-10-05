import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';

/// Feedback de presión reutilizable para controles que antes eran estáticos.
///
/// No sustituye animaciones existentes: se aplica únicamente a superficies
/// que no tenían respuesta al pulsar. Respeta la preferencia del sistema de
/// reducir animaciones.
///
/// Foco de teclado/mando (2026-08): al ser un envoltorio genérico usado con
/// hijos de formas muy distintas (pills, cards, filas), el anillo de las
/// demás piezas (`ActionBtn`/`IconCircleButton`, que dibujan su propio
/// borde a medida) no vale aquí — en su lugar, un halo exterior (solo
/// `boxShadow`, sin borde) que no asume ninguna forma concreta del hijo.
class PressableScale extends StatefulWidget {
  const PressableScale({
    super.key,
    required this.onTap,
    required this.child,
    this.pressedScale = 0.97,
    this.behavior = HitTestBehavior.opaque,
    this.semanticLabel,
    this.focusNode,
    this.onFocusHighlightChanged,
    this.autofocus = false,
  });

  final VoidCallback? onTap;
  final Widget child;
  final double pressedScale;
  final HitTestBehavior behavior;
  final String? semanticLabel;

  /// Opcionales — solo para el caso raro en que el propio hijo necesita
  /// reaccionar al foco con SU decoración a medida (p. ej. un borde de un
  /// color concreto), en vez de conformarse con el halo genérico que este
  /// widget ya pinta solo. La mayoría de usos no los necesitan.
  final FocusNode? focusNode;
  final ValueChanged<bool>? onFocusHighlightChanged;

  /// Foco inicial al abrir un diálogo — ver `ActionBtn.autofocus` para el
  /// porqué. Aquí solo se usa en los selectores de lista (idioma, carpeta
  /// compartida), donde la salida segura es la X de cerrar.
  final bool autofocus;

  @override
  State<PressableScale> createState() => _PressableScaleState();
}

class _PressableScaleState extends State<PressableScale> {
  bool _pressed = false;
  bool _hovered = false;
  bool _focused = false;
  FocusNode? _ownedFocusNode;
  FocusNode get _focusNode => widget.focusNode ?? _ownedFocusNode!;

  void _setPressed(bool value) {
    if (_pressed == value || widget.onTap == null) return;
    setState(() => _pressed = value);
  }

  void _setHovered(bool value) {
    if (_hovered == value || widget.onTap == null) return;
    setState(() => _hovered = value);
  }

  @override
  void initState() {
    super.initState();
    if (widget.focusNode == null) {
      _ownedFocusNode = FocusNode(debugLabel: 'PressableScale');
    }
  }

  @override
  void dispose() {
    _ownedFocusNode?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final reduceMotion =
        MediaQuery.maybeOf(context)?.disableAnimations ?? false;
    final enabled = widget.onTap != null;
    final scale = enabled && _pressed
        ? widget.pressedScale
        : enabled && _hovered
            ? 1.015
            : 1.0;
    final content = FocusableActionDetector(
      focusNode: _focusNode,
      autofocus: widget.autofocus,
      enabled: enabled,
      onShowFocusHighlight: (v) {
        setState(() => _focused = v);
        widget.onFocusHighlightChanged?.call(v);
      },
      onShowHoverHighlight: (v) => _setHovered(v),
      mouseCursor: enabled ? SystemMouseCursors.click : MouseCursor.defer,
      actions: {
        if (widget.onTap != null)
          ActivateIntent: CallbackAction<ActivateIntent>(
            onInvoke: (_) => widget.onTap!(),
          ),
      },
      child: GestureDetector(
        behavior: widget.behavior,
        onTap: widget.onTap,
        onTapDown: enabled ? (_) => _setPressed(true) : null,
        onTapUp: enabled ? (_) => _setPressed(false) : null,
        onTapCancel: enabled ? () => _setPressed(false) : null,
        child: AnimatedScale(
          scale: scale,
          duration: reduceMotion
              ? Duration.zero
              : const Duration(milliseconds: 120),
          curve: const Cubic(0.23, 1, 0.32, 1),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 140),
            curve: Curves.easeOut,
            decoration: BoxDecoration(
              boxShadow: _focused
                  ? [
                      BoxShadow(
                        color: AppColors.accentGlow,
                        blurRadius: 10,
                        spreadRadius: 2,
                      ),
                    ]
                  : null,
            ),
            child: widget.child,
          ),
        ),
      ),
    );

    if (widget.semanticLabel == null) return content;
    return Semantics(
      button: true,
      enabled: enabled,
      label: widget.semanticLabel,
      child: ExcludeSemantics(child: content),
    );
  }
}
