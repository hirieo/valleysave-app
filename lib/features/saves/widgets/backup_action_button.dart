import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/services/season_controller.dart';
import '../../../core/theme/app_colors.dart';
import '../../../shared/widgets/save_busy_indicator.dart';

/// Acción de backup con feedback inmediato y protección contra doble toque.
/// La animación solo comunica la pulsación; el spinner comunica la operación.
class BackupActionButton extends StatefulWidget {
  const BackupActionButton({
    super.key,
    required this.label,
    required this.icon,
    required this.color,
    required this.onPressed,
    this.filled = false,
    this.iconOnly = false,
    this.tooltip,
    this.compact = false,
    this.solid = false,
  });

  final String label;
  final IconData icon;
  final Color color;
  final Future<void> Function()? onPressed;
  final bool filled;
  final bool iconOnly;
  final String? tooltip;

  /// Variante de las filas del diálogo de backups (spec 012, D7): texto de
  /// 11 px sin icono (salvo [iconOnly]), relleno 10×6 y sin altura mínima.
  final bool compact;

  /// Variante rellena del botón principal del diálogo de backups: fondo del
  /// color, texto oscuro en negrita de 12 px.
  final bool solid;

  @override
  State<BackupActionButton> createState() => _BackupActionButtonState();
}

class _BackupActionButtonState extends State<BackupActionButton> {
  bool _pressed = false;
  bool _busy = false;
  bool _hovered = false;
  bool _focused = false;
  final _focusNode = FocusNode(debugLabel: 'BackupActionButton');

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  Future<void> _run() async {
    if (_busy || widget.onPressed == null) return;
    setState(() {
      _busy = true;
      _pressed = false;
    });
    try {
      await widget.onPressed!.call();
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final enabled = widget.onPressed != null && !_busy;
    final reduceMotion =
        MediaQuery.maybeOf(context)?.disableAnimations ?? false;
    final backgroundAlpha = widget.solid
        ? (_pressed || _hovered ? .88 : 1.0)
        : widget.filled
        ? (_pressed ? .22 : (_hovered ? .20 : .14))
        : (_pressed || _busy ? .12 : (_hovered ? .09 : .05));
    final compact = widget.compact || widget.solid;
    final fontSize = widget.solid ? 12.0 : (widget.compact ? 11.0 : 10.0);
    // Mientras trabaja, TODO el botón (icono, borde, fondo, texto) pasa al
    // color estacional — no solo el icono. Antes solo cambiaba el icono y
    // el resto se quedaba con el color fijo del botón (azul/verde/rojo),
    // inconsistente con la estética por estación que ya usan subir/bajar
    // (2026-07-19, aprobado tras mockup comparando antes/después).
    final color = _busy
        ? seasonBusyColor(SeasonController.instance.season.value)
        : widget.color;

    Widget button = Semantics(
      button: true,
      enabled: enabled,
      label: widget.label,
      child: FocusableActionDetector(
        focusNode: _focusNode,
        enabled: enabled,
        onShowFocusHighlight: (v) => setState(() => _focused = v),
        onShowHoverHighlight: (v) => setState(() => _hovered = v),
        mouseCursor: enabled ? SystemMouseCursors.click : MouseCursor.defer,
        actions: {
          if (enabled)
            ActivateIntent: CallbackAction<ActivateIntent>(
              onInvoke: (_) => _run(),
            ),
        },
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: enabled ? _run : null,
          onTapDown: enabled ? (_) => setState(() => _pressed = true) : null,
          onTapUp: (_) => setState(() => _pressed = false),
          onTapCancel: () => setState(() => _pressed = false),
          child: AnimatedScale(
            scale: reduceMotion || !_pressed ? 1 : .97,
            duration: reduceMotion
                ? Duration.zero
                : const Duration(milliseconds: 140),
            curve: const Cubic(.23, 1, .32, 1),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 140),
              curve: const Cubic(.23, 1, .32, 1),
              constraints: BoxConstraints(
                minWidth: widget.iconOnly && !compact ? 40 : 0,
                minHeight: compact ? 0 : 40,
              ),
              padding: widget.iconOnly
                  ? (compact
                        ? const EdgeInsets.symmetric(horizontal: 7, vertical: 5)
                        : const EdgeInsets.all(9))
                  : widget.solid
                  ? const EdgeInsets.symmetric(horizontal: 12, vertical: 7)
                  : widget.compact
                  ? const EdgeInsets.symmetric(horizontal: 10, vertical: 6)
                  : const EdgeInsets.symmetric(horizontal: 11, vertical: 8),
              decoration: BoxDecoration(
                color: color.withValues(alpha: backgroundAlpha),
                border: Border.all(
                  color: _focused
                      ? AppColors.accent
                      : color.withValues(
                          alpha: enabled ? (_hovered ? .85 : .66) : .28,
                        ),
                  width: _focused ? 1.6 : 1.0,
                ),
                borderRadius: BorderRadius.circular(widget.solid ? 10 : 9),
                boxShadow: _focused
                    ? [
                        BoxShadow(
                          color: AppColors.accentGlow,
                          blurRadius: 10,
                          spreadRadius: 1,
                        ),
                      ]
                    : null,
              ),
              child: widget.iconOnly
                  ? Center(child: _iconOrProgress())
                  : Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        if (!widget.compact || _busy) ...[
                          _iconOrProgress(),
                          const SizedBox(width: 6),
                        ],
                        Flexible(
                          child: Text(
                            widget.label,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: GoogleFonts.firaCode(
                              fontSize: fontSize,
                              fontWeight: widget.solid
                                  ? FontWeight.w700
                                  : FontWeight.w500,
                              color: widget.solid && !_busy
                                  ? _solidForeground
                                  : color.withValues(
                                      alpha: enabled || _busy ? 1 : .45,
                                    ),
                            ),
                          ),
                        ),
                      ],
                    ),
            ),
          ),
        ),
      ),
    );

    if (widget.tooltip != null) {
      button = Tooltip(message: widget.tooltip!, child: button);
    }
    return button;
  }

  Widget _iconOrProgress() {
    if (_busy) {
      return SizedBox.square(
        key: const ValueKey('backup-action-progress'),
        dimension: 15,
        child: SaveBusyIndicator(
          season: SeasonController.instance.season.value,
          size: 15,
        ),
      );
    }
    return Icon(
      widget.icon,
      size: widget.solid ? 13 : (widget.compact && widget.iconOnly ? 14 : 17),
      color: widget.solid ? _solidForeground : widget.color,
    );
  }

  static const _solidForeground = Color(0xFF14110A);
}
