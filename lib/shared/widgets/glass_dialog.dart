import 'dart:ui';

import 'package:flutter/material.dart';

/// Cristal oscuro con blur + borde de acento — el fondo de TODOS los
/// diálogos de la app (antes solo vivía duplicado dentro de
/// `saves_screen.dart`; extraído 2026-07-15 para que cualquier pantalla
/// pueda usar el mismo, en vez de reinventar un contenedor plano propio).
Widget glassDialogShell(
  BuildContext context, {
  required Widget child,
  double maxWidth = 380,
  required Color accent,
  EdgeInsets padding = const EdgeInsets.fromLTRB(22, 20, 22, 16),
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
        filter: ImageFilter.blur(sigmaX: 6, sigmaY: 6),
        child: Container(
          decoration: BoxDecoration(
            color: const Color(0xFF14110A).withValues(alpha: 0.92),
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
