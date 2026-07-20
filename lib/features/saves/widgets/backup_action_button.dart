import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/services/season_controller.dart';
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
  });

  final String label;
  final IconData icon;
  final Color color;
  final Future<void> Function()? onPressed;
  final bool filled;
  final bool iconOnly;
  final String? tooltip;

  @override
  State<BackupActionButton> createState() => _BackupActionButtonState();
}

class _BackupActionButtonState extends State<BackupActionButton> {
  bool _pressed = false;
  bool _busy = false;
  bool _hovered = false;

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
    final backgroundAlpha = widget.filled
        ? (_pressed ? .22 : (_hovered ? .20 : .14))
        : (_pressed || _busy ? .12 : (_hovered ? .09 : .05));
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
      child: MouseRegion(
        cursor: enabled ? SystemMouseCursors.click : MouseCursor.defer,
        onEnter: enabled ? (_) => setState(() => _hovered = true) : null,
        onExit: enabled ? (_) => setState(() => _hovered = false) : null,
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
              minWidth: widget.iconOnly ? 40 : 0,
              minHeight: 40,
            ),
            padding: widget.iconOnly
                ? const EdgeInsets.all(9)
                : const EdgeInsets.symmetric(horizontal: 11, vertical: 8),
            decoration: BoxDecoration(
              color: color.withValues(alpha: backgroundAlpha),
              border: Border.all(
                color: color.withValues(
                  alpha: enabled ? (_hovered ? .85 : .66) : .28,
                ),
              ),
              borderRadius: BorderRadius.circular(9),
            ),
            child: widget.iconOnly
                ? Center(child: _iconOrProgress())
                : Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _iconOrProgress(),
                      const SizedBox(width: 6),
                      Flexible(
                        child: Text(
                          widget.label,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.firaCode(
                            fontSize: 10,
                            fontWeight: FontWeight.w500,
                            color: color.withValues(
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
    return Icon(widget.icon, size: 17, color: widget.color);
  }
}
