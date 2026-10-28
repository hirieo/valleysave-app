import 'dart:ui';

import 'package:flutter/material.dart';

/// Cristal translúcido común a la hoja «En este equipo» y al diálogo de
/// Backups (valores elegidos con el usuario sobre el mockup, 2026-10-28):
/// la lista de atrás se queda visible al 40 %, el panel oscurece al 64 % y
/// el desenfoque es mínimo para que lo de atrás siga reconociéndose.
const double kGlassBehindOpacity = 0.40;
const double kGlassPanelAlpha = 0.64;
const double kGlassBlurSigma = 2;

/// Relleno del panel translúcido: oscuro puro, sin tinte (el color de la
/// estación o de la cara queda en el borde; un tinte amarilleaba la cara de
/// Drive, 2026-10-28).
Color glassPanelFill() =>
    const Color(0xFF14110A).withValues(alpha: kGlassPanelAlpha);

/// Cuántas hojas de cristal (hoja de detalle, Backups) están abiertas. La
/// pantalla de partidas atenúa su lista mientras sea > 0. Backups se abre
/// desde la hoja, que se cierra antes: el contador sube antes de que baje,
/// así la lista no vuelve a verse entera entre una y otra.
class GlassBackdrop {
  GlassBackdrop._();
  static final ValueNotifier<int> depth = ValueNotifier<int>(0);
  static void open() => depth.value++;
  static void close() {
    if (depth.value > 0) depth.value--;
  }
}

/// Cristal oscuro con blur + borde de acento — el fondo de TODOS los
/// diálogos de la app (antes solo vivía duplicado dentro de
/// `saves_screen.dart`; extraído 2026-07-15 para que cualquier pantalla
/// pueda usar el mismo, en vez de reinventar un contenedor plano propio).
///
/// [fill] y [blurSigma] solo los cambia un diálogo que quiera dejar ver el
/// fondo animado (Backups): por defecto, el cristal casi opaco de siempre.
Widget glassDialogShell(
  BuildContext context, {
  required Widget child,
  double maxWidth = 380,
  required Color accent,
  EdgeInsets padding = const EdgeInsets.fromLTRB(22, 20, 22, 16),
  Color? fill,
  double blurSigma = 6,
}) {
  final borderColor = accent.withValues(alpha: 0.22);
  return ConstrainedBox(
    constraints: BoxConstraints(
      maxWidth: maxWidth,
      maxHeight: MediaQuery.of(context).size.height * 0.85,
    ),
    child: ClipRRect(
      borderRadius: BorderRadius.circular(22),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: blurSigma, sigmaY: blurSigma),
        child: Container(
          decoration: BoxDecoration(
            color: fill ?? const Color(0xFF14110A).withValues(alpha: 0.92),
            borderRadius: BorderRadius.circular(22),
            border: Border.all(color: borderColor),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.55),
                blurRadius: 44,
                offset: const Offset(0, 16),
              ),
            ],
          ),
          padding: padding,
          child: child,
        ),
      ),
    ),
  );
}

/// Estructura título/contenido-scrollable/acciones común a los diálogos de
/// confirmación (no a los selectores tipo lista, que usan solo
/// [glassDialogShell] con su propio layout interno).
Widget dialogBody({
  required Widget title,
  required Widget content,
  required List<Widget> actions,
}) {
  return Column(
    mainAxisSize: MainAxisSize.min,
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      title,
      const SizedBox(height: 12),
      Flexible(child: SingleChildScrollView(child: content)),
      const SizedBox(height: 14),
      Wrap(
        alignment: WrapAlignment.end,
        spacing: 8,
        runSpacing: 8,
        children: actions,
      ),
    ],
  );
}
