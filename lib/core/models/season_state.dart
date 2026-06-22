import 'package:flutter/material.dart';

enum SeasonState { initial, spring, summer, fall, winter }

@immutable
class SeasonData {
  const SeasonData({
    required this.skyTop,
    required this.skyMid,
    required this.skyBottom,
    required this.hillBack,
    required this.hillColor,
    required this.starOpacity,
    required this.accentColor,
    required this.mountainFar,
    required this.mountainNear,
  });

  final Color skyTop;
  final Color skyMid;
  final Color skyBottom;
  final Color hillBack;   // colina trasera — más clara
  final Color hillColor;  // colina delantera — más oscura
  final double starOpacity;
  final Color accentColor;
  final Color mountainFar;
  final Color mountainNear;


  static const Map<SeasonState, SeasonData> data = {
    SeasonState.initial: SeasonData(
      skyTop:       Color(0xFF093375), // noche profunda
      skyMid:       Color(0xFF2E9DE6), // cerúleo (centro del gradiente 5-stop)
      skyBottom:    Color(0xFF7DF1E1), // aguamarina horizonte
      hillBack:     Color(0xFF5BAF3B), // SDV: verde vibrante iluminado
      hillColor:    Color(0xFF3A6324), // SDV: verde oscuro sombra
      starOpacity:  0.75,              // estrellas visibles arriba
      accentColor:  Color(0xFF7ab8a0),
      mountainFar:  Color(0xFF688A6E), // SDV: verde azulado lejanía
      mountainNear: Color(0xFF3A6324), // SDV: verde oscuro sombra
    ),
    SeasonState.spring: SeasonData(
      skyTop:       Color(0xFF221040),
      skyMid:       Color(0xFF6030a0),
      skyBottom:    Color(0xFFd04898),
      hillBack:     Color(0xFF4a8a2a),
      hillColor:    Color(0xFF2e5a18),
      starOpacity:  0.65,
      accentColor:  Color(0xFFf0b8c8),
      mountainFar:  Color(0xFF5030a0),
      mountainNear: Color(0xFF902870),
    ),
    SeasonState.summer: SeasonData(
      skyTop:       Color(0xFF0d1a38), // azul noche cálida
      skyMid:       Color(0xFF1a3a5a), // azul marino verano
      skyBottom:    Color(0xFF2a5870), // azul-verde horizonte
      hillBack:     Color(0xFF5BAF3B), // verde vibrante SDV
      hillColor:    Color(0xFF3A6324), // verde oscuro SDV
      starOpacity:  0.45,             // noche de verano
      accentColor:  Color(0xFFf0d060), // luna dorada
      mountainFar:  Color(0xFF3a6850), // verde azulado montaña
      mountainNear: Color(0xFF284830), // verde oscuro montaña
    ),
    SeasonState.fall: SeasonData(
      skyTop:       Color(0xFF130a02), // marrón oscuro
      skyMid:       Color(0xFF3a1806), // ámbar saturado
      skyBottom:    Color(0xFF6a2c0c), // naranja quemado vívido
      hillBack:     Color(0xFFe06010), // naranja vívido — capa media
      hillColor:    Color(0xFF9a3808), // naranja-marrón — primer plano
      starOpacity:  0.70,
      accentColor:  Color(0xFFe8783a), // naranja luna otoñal
      mountainFar:  Color(0xFF1a0a02), // silueta casi negra — fondo
      mountainNear: Color(0xFF4a1c06), // silueta siena oscuro
    ),
    SeasonState.winter: SeasonData(
      skyTop:       Color(0xFF04060f), // negro azul
      skyMid:       Color(0xFF0a1428), // azul oscuro
      skyBottom:    Color(0xFF121e3a), // azul marino
      hillBack:     Color(0xFFa8c8e0), // azul nieve — segunda capa
      hillColor:    Color(0xFFf0f8ff), // blanco nieve — primer plano
      starOpacity:  0.90,             // noche clara de invierno
      accentColor:  Color(0xFF90c8f0), // azul hielo
      mountainFar:  Color(0xFF243850), // azul oscuro — fondo
      mountainNear: Color(0xFF507898), // azul medio
    ),
  };
}
