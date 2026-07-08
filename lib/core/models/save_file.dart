import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import 'player_stats.dart';
import 'season_state.dart';

enum WeatherType { sunny, rainy, stormy, snowy, windy }

class SaveFile {
  const SaveFile({
    required this.folderPath,
    required this.folderName,
    required this.playerName,
    required this.farmName,
    required this.dayOfMonth,
    required this.currentSeason,
    required this.year,
    required this.currentMoney,
    required this.totalMoneyEarned,
    required this.millisecondsPlayed,
    required this.lastModified,
    required this.farmingLevel,
    required this.miningLevel,
    required this.combatLevel,
    required this.foragingLevel,
    required this.fishingLevel,
    required this.houseUpgradeLevel,
    required this.petType,
    required this.gender,
    required this.deepestMineLevel,
    required this.monstersKilled,
    required this.timesUnconscious,
    required this.goodFriends,
    required this.timeOfDay,
    required this.averageBedtime,
    required this.weather,
    required this.stamina,
    required this.health,
    this.gameVersion = '',
    this.isCoop = false,
    this.separateWallets = false,
    this.players = const [],
  });

  final String folderPath;
  final String folderName;
  final String playerName;
  final String farmName;
  final int dayOfMonth;
  final String currentSeason;
  final int year;
  final int currentMoney;
  final int totalMoneyEarned;
  final int millisecondsPlayed;
  final DateTime lastModified;
  final int farmingLevel;
  final int miningLevel;
  final int combatLevel;
  final int foragingLevel;
  final int fishingLevel;
  final int houseUpgradeLevel;
  final String petType; // 'cat' | 'dog'
  final int gender;     // 0=male 1=female
  final int deepestMineLevel;
  final int monstersKilled;
  final int timesUnconscious;
  final int goodFriends;
  final int timeOfDay;       // e.g. 1430 = 14:30
  final int averageBedtime;  // e.g. 2356 = se acuesta a las 23:56
  final WeatherType weather;
  final int stamina;         // estamina actual al guardar
  final int health;          // vida actual al guardar
  final String gameVersion;  // e.g. "1.6.8"

  // ── Multijugador ─────────────────────────────────────────────────────
  final bool isCoop;           // farm con capacidad coop (slotCanHost=true)
  final bool separateWallets;  // cada jugador su dinero (useSeparateWallets)
  /// Todos los jugadores reales (anfitrión primero). Vacío si solo tenemos el
  /// SaveGameInfo (no se ha parseado el archivo grande ni hay resumen Drive).
  final List<PlayerStats> players;

  /// ¿Tenemos datos de más de un jugador para mostrar?
  bool get hasMultiplePlayers => players.length > 1;

  /// Devuelve una copia con los campos POR-JUGADOR reemplazados por los de [p],
  /// manteniendo los de la granja (nombre, estación, día, clima, mascota).
  /// Permite reutilizar las sub-widgets existentes sin reescribirlas: se les
  /// pasa `save.forPlayer(jugadorSeleccionado)`.
  SaveFile forPlayer(PlayerStats p) => SaveFile(
        folderPath: folderPath,
        folderName: folderName,
        playerName: p.name,
        farmName: farmName,
        dayOfMonth: dayOfMonth,
        currentSeason: currentSeason,
        year: year,
        currentMoney: p.currentMoney,
        totalMoneyEarned: p.totalMoneyEarned,
        millisecondsPlayed: p.millisecondsPlayed,
        lastModified: lastModified,
        farmingLevel: p.farmingLevel,
        miningLevel: p.miningLevel,
        combatLevel: p.combatLevel,
        foragingLevel: p.foragingLevel,
        fishingLevel: p.fishingLevel,
        houseUpgradeLevel: p.houseUpgradeLevel,
        petType: petType,
        gender: p.gender,
        deepestMineLevel: p.deepestMineLevel,
        monstersKilled: p.monstersKilled,
        timesUnconscious: p.timesUnconscious,
        goodFriends: p.goodFriends,
        timeOfDay: timeOfDay,
        averageBedtime: p.averageBedtime,
        weather: weather,
        stamina: p.stamina,
        health: p.health,
        gameVersion: gameVersion,
        isCoop: isCoop,
        separateWallets: separateWallets,
        players: players,
      );

  // ── Playtime ────────────────────────────────────────────────────────
  Duration get playtime => Duration(milliseconds: millisecondsPlayed);

  String get playtimeLabel {
    final h = playtime.inHours;
    final m = playtime.inMinutes.remainder(60);
    if (h == 0) return '${m}m';
    return '${h}h';
  }

  // ── Season ──────────────────────────────────────────────────────────
  SeasonState get seasonState => switch (currentSeason.toLowerCase()) {
    'spring' => SeasonState.spring,
    'summer' => SeasonState.summer,
    'fall'   => SeasonState.fall,
    'winter' => SeasonState.winter,
    _        => SeasonState.initial,
  };


  Color get seasonColor => switch (currentSeason.toLowerCase()) {
    'spring' => const Color(0xFFF0B8C8),
    'summer' => const Color(0xFFF0D060),
    'fall'   => const Color(0xFFE8783A),
    'winter' => const Color(0xFF90C8F0),
    _        => AppColors.accent,
  };

  // ── Game time & weather ──────────────────────────────────────────────
  String get gameTimeLabel {
    final h = (timeOfDay ~/ 100) % 24;
    final m = timeOfDay % 100;
    return '${h.toString().padLeft(2, '0')}:${m.toString().padLeft(2, '0')}';
  }

  String get bedtimeLabel {
    final h24 = (averageBedtime ~/ 100) % 24;
    final m   = averageBedtime % 100;
    final h12 = h24 % 12 == 0 ? 12 : h24 % 12;
    final suffix = h24 < 12 ? 'AM' : 'PM';
    return '$h12:${m.toString().padLeft(2, '0')} $suffix';
  }

  String get weatherEmoji {
    final h = (timeOfDay ~/ 100) % 24;
    if (h >= 20 || h < 6) return '🌙';
    return switch (weather) {
      WeatherType.stormy => '⛈️',
      WeatherType.rainy  => '🌧️',
      WeatherType.snowy  => '🌨️',
      WeatherType.windy  => '🍃',
      WeatherType.sunny  => '🌤️',
    };
  }

  // ── Farm info ────────────────────────────────────────────────────────
  String get genderLabel => gender == 0 ? '♂' : '♀';

  // ── Money ────────────────────────────────────────────────────────────
  String get currentMoneyLabel => _formatMoney(currentMoney);
  String get totalMoneyLabel   => _formatMoney(totalMoneyEarned);

  String _formatMoney(int amount) {
    if (amount >= 1000000) {
      return '${(amount / 1000000).toStringAsFixed(2)}M g';
    }
    return '${_thousands(amount)} g';
  }

  static String _thousands(int n) {
    final s = n.toString();
    final buf = StringBuffer();
    for (var i = 0; i < s.length; i++) {
      if (i > 0 && (s.length - i) % 3 == 0) buf.write('.');
      buf.write(s[i]);
    }
    return buf.toString();
  }

  static String formatCount(int n) => _thousands(n);
}
