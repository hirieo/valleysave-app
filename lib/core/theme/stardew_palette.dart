import 'package:flutter/material.dart';

/// Paleta extraída de Stardew Valley (screenshot verano).
///
/// Referencia visual para partículas, fondos atmosféricos y elementos
/// de la UI que deben evocar el juego.
///
/// OKLCH equivalentes incluidos como comentarios para uso en web/CSS.
class StardewPalette {
  StardewPalette._();

  // ── Cielo ────────────────────────────────────────────────────────────────
  // oklch(62% 0.14 240)
  static const Color skyTop         = Color(0xFF3A96E5); // azul claro superior
  // oklch(72% 0.11 228)
  static const Color skyMid         = Color(0xFF62B8EE); // interpolado
  // oklch(85% 0.08 218)
  static const Color skyBottom      = Color(0xFF8DD6F8); // azul cielo claro inferior

  // ── Montañas ─────────────────────────────────────────────────────────────
  // oklch(42% 0.08 152)
  static const Color mountainFar    = Color(0xFF688A6E); // verde azulado lejanía
  // oklch(37% 0.12 138)
  static const Color mountainNear   = Color(0xFF3A6324); // verde oscuro sombra
  // oklch(63% 0.16 138)
  static const Color mountainVivid  = Color(0xFF5BAF3B); // verde vibrante iluminado

  // ── Vegetación (árboles / arbustos) ──────────────────────────────────────
  // oklch(46% 0.18 138)
  static const Color foliageMid     = Color(0xFF258525); // hoja media
  // oklch(28% 0.14 140)
  static const Color foliageDark    = Color(0xFF154B15); // hoja oscura / sombra
  // oklch(38% 0.09 55)
  static const Color trunkBrown     = Color(0xFF6E472A); // tronco

  // ── Suelo / tierra ───────────────────────────────────────────────────────
  // oklch(75% 0.10 72)
  static const Color dirtLight      = Color(0xFFE6B86C); // terreno base
  // oklch(42% 0.10 58)
  static const Color dirtDark       = Color(0xFF7D5535); // tierra arada / sombra

  // ── Gallinero / edificios ────────────────────────────────────────────────
  // oklch(49% 0.10 55)
  static const Color woodBase       = Color(0xFF9D653C); // madera base
  // oklch(30% 0.09 50)
  static const Color woodDark       = Color(0xFF5D3A21); // contornos / sombra madera
  // oklch(44% 0.16 32)
  static const Color roofClay       = Color(0xFFB34720); // techo arcilla / tejas

  // ── Girasoles ────────────────────────────────────────────────────────────
  // oklch(85% 0.18 88)
  static const Color flowerYellow   = Color(0xFFFFD700); // pétalos amarillo oro
  // oklch(38% 0.10 52)
  static const Color flowerCenter   = Color(0xFF8B4513); // centro marrón
}
