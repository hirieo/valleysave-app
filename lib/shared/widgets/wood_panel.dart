import 'package:flutter/material.dart';

/// Panel estilo Stardew Valley con bordes de madera.
/// Simula el nine-patch de los menús del juego usando BoxDecoration en capas.
class WoodPanel extends StatelessWidget {
  const WoodPanel({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(20),
  });

  final Widget child;
  final EdgeInsetsGeometry padding;

  // Paleta madera SDV
  static const Color _woodLight  = Color(0xFF9D653C);
  static const Color _woodDark   = Color(0xFF5D3A21);
  static const Color _woodInner  = Color(0xFF7B4E2D);
  static const Color _bgFill     = Color(0x99000000); // negro 60% — deja ver el canvas

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        // Relleno semitransparente
        color: _bgFill,
        // Borde exterior oscuro (marco)
        border: Border.all(color: _woodDark, width: 4),
        borderRadius: BorderRadius.circular(4),
        // Sombra interior simulada con boxShadow
        boxShadow: const [
          // Sombra exterior profunda
          BoxShadow(
            color: Color(0xCC000000),
            blurRadius: 0,
            spreadRadius: 2,
            offset: Offset(3, 4),
          ),
          // Borde interior claro (highlight madera)
          BoxShadow(
            color: Color(0x00000000), // placeholder — ver inner border abajo
            blurRadius: 0,
          ),
        ],
      ),
      child: Container(
        // Borde interior claro — simula el highlight del nine-patch
        decoration: BoxDecoration(
          border: Border.all(color: _woodLight, width: 2),
          borderRadius: BorderRadius.circular(2),
        ),
        child: Container(
          // Segundo borde interior oscuro — profundidad
          decoration: BoxDecoration(
            border: Border.all(color: _woodInner, width: 1),
          ),
          padding: padding,
          child: child,
        ),
      ),
    );
  }
}
