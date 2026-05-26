import 'package:flutter/material.dart';

enum SeasonState { initial, spring, summer, fall, winter }

@immutable
class SeasonData {
  const SeasonData({
    required this.skyTop,
    required this.skyMid,
    required this.skyBottom,
    required this.hillColor,
    required this.starOpacity,
    required this.accentColor,
    required this.mountainFar,
    required this.mountainNear,
  });

  final Color skyTop;
  final Color skyMid;
  final Color skyBottom;
  final Color hillColor;
  final double starOpacity;
  final Color accentColor;
  final Color mountainFar;
  final Color mountainNear;

  static const Map<SeasonState, SeasonData> data = {
    SeasonState.initial: SeasonData(
      skyTop:       Color(0xFF030810), // Midnight Valley — near black
      skyMid:       Color(0xFF0d2855), // deep navy
      skyBottom:    Color(0xFF163870), // dark blue horizon
      hillColor:    Color(0xFF0a2014),
      starOpacity:  0.92,
      accentColor:  Color(0xFF7ab8a0),
      mountainFar:  Color(0xFF0E203E),
      mountainNear: Color(0xFF091630),
    ),
    SeasonState.spring: SeasonData(
      skyTop:       Color(0xFF1a1035),
      skyMid:       Color(0xFF2a1640),
      skyBottom:    Color(0xFF3d1f3a),
      hillColor:    Color(0xFF142a10),
      starOpacity:  0.30,
      accentColor:  Color(0xFFf0b8c8),
      mountainFar:  Color(0xFF1a1030),
      mountainNear: Color(0xFF120a22),
    ),
    SeasonState.summer: SeasonData(
      skyTop:       Color(0xFF04080f),
      skyMid:       Color(0xFF071420),
      skyBottom:    Color(0xFF0a1a28),
      hillColor:    Color(0xFF0d2814),
      starOpacity:  0.80,
      accentColor:  Color(0xFFf0d060),
      mountainFar:  Color(0xFF081828),
      mountainNear: Color(0xFF051018),
    ),
    SeasonState.fall: SeasonData(
      skyTop:       Color(0xFF08060f),
      skyMid:       Color(0xFF120810),
      skyBottom:    Color(0xFF1a0c08),
      hillColor:    Color(0xFF180e08),
      starOpacity:  0.65,
      accentColor:  Color(0xFFe8783a),
      mountainFar:  Color(0xFF1a100a),
      mountainNear: Color(0xFF100806),
    ),
    SeasonState.winter: SeasonData(
      skyTop:       Color(0xFF020408),
      skyMid:       Color(0xFF050a14),
      skyBottom:    Color(0xFF080818),
      hillColor:    Color(0xFF0d1a28),
      starOpacity:  0.95,
      accentColor:  Color(0xFF90c8f0),
      mountainFar:  Color(0xFF0a1428),
      mountainNear: Color(0xFF060c1e),
    ),
  };
}
