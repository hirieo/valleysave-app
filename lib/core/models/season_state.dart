import 'package:flutter/material.dart';

enum SeasonState { initial, spring, summer, fall, winter }

@immutable
class SeasonData {
  const SeasonData({
    required this.skyTop,
    required this.skyBottom,
    required this.hillColor,
    required this.starOpacity,
    required this.accentColor,
  });

  final Color skyTop;
  final Color skyBottom;
  final Color hillColor;
  final double starOpacity;
  final Color accentColor;

  static const Map<SeasonState, SeasonData> data = {
    SeasonState.initial: SeasonData(
      skyTop:      Color(0xFF0a1428),
      skyBottom:   Color(0xFF1a2a18),
      hillColor:   Color(0xFF0d2416),
      starOpacity: 0.55,
      accentColor: Color(0xFF7ab8a0),
    ),
    SeasonState.spring: SeasonData(
      skyTop:      Color(0xFF1a1035),
      skyBottom:   Color(0xFF3d1f3a),
      hillColor:   Color(0xFF142a10),
      starOpacity: 0.30,
      accentColor: Color(0xFFf0b8c8),
    ),
    SeasonState.summer: SeasonData(
      skyTop:      Color(0xFF04080f),
      skyBottom:   Color(0xFF0a1a28),
      hillColor:   Color(0xFF0d2814),
      starOpacity: 0.80,
      accentColor: Color(0xFFf0d060),
    ),
    SeasonState.fall: SeasonData(
      skyTop:      Color(0xFF08060f),
      skyBottom:   Color(0xFF1a0c08),
      hillColor:   Color(0xFF180e08),
      starOpacity: 0.65,
      accentColor: Color(0xFFe8783a),
    ),
    SeasonState.winter: SeasonData(
      skyTop:      Color(0xFF020408),
      skyBottom:   Color(0xFF080818),
      hillColor:   Color(0xFF0d1a28),
      starOpacity: 0.95,
      accentColor: Color(0xFF90c8f0),
    ),
  };
}
