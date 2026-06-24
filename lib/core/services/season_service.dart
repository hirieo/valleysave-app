import 'dart:math';

import 'package:geolocator/geolocator.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/season_settings.dart';
import '../models/season_state.dart';
import 'save_service.dart';

class SeasonService {
  static const _keyMode       = 'season_mode';
  static const _keyFixed      = 'season_fixed';
  static const _keyHasLaunched = 'has_launched';

  final _rng = Random();

  // ── Main resolution chain ─────────────────────────────────────────────────

  /// Returns which SeasonState to show, following the priority chain:
  ///   user override (fixed/random) → first launch → last save → geo → default
  Future<SeasonState> resolve() async {
    final settings = await loadSettings();

    if (settings.mode == SeasonMode.fixed && settings.fixedSeason != null) {
      return settings.fixedSeason!;
    }
    if (settings.mode == SeasonMode.random) {
      return _randomSeason();
    }
    if (settings.mode == SeasonMode.savesOnly) {
      return await _seasonFromLastSave() ?? SeasonState.initial;
    }
    if (settings.mode == SeasonMode.geoOnly) {
      return await _geoSeason() ?? SeasonState.initial;
    }

    // Auto mode
    if (await _isFirstLaunch()) return SeasonState.initial;

    final saveSeason = await _seasonFromLastSave();
    if (saveSeason != null) return saveSeason;

    final geoSeason = await _geoSeason();
    if (geoSeason != null) return geoSeason;

    return SeasonState.initial;
  }

  // ── Settings persistence ──────────────────────────────────────────────────

  Future<SeasonSettings> loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    final modeStr  = prefs.getString(_keyMode)  ?? 'auto';
    final fixedStr = prefs.getString(_keyFixed);

    final mode = SeasonMode.values.firstWhere(
      (m) => m.name == modeStr,
      orElse: () => SeasonMode.auto,
    );

    SeasonState? fixed;
    if (fixedStr != null) {
      fixed = SeasonState.values.firstWhere(
        (s) => s.name == fixedStr,
        orElse: () => SeasonState.initial,
      );
    }

    return SeasonSettings(mode: mode, fixedSeason: fixed);
  }

  Future<void> saveSettings(SeasonSettings settings) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyMode, settings.mode.name);
    if (settings.fixedSeason != null) {
      await prefs.setString(_keyFixed, settings.fixedSeason!.name);
    }
  }

  // ── First launch detection ────────────────────────────────────────────────

  Future<bool> _isFirstLaunch() async {
    final prefs   = await SharedPreferences.getInstance();
    final launched = prefs.getBool(_keyHasLaunched) ?? false;
    if (!launched) await prefs.setBool(_keyHasLaunched, true);
    return !launched;
  }

  // ── Season from last local save ───────────────────────────────────────────

  Future<SeasonState?> _seasonFromLastSave() async {
    final saves = await SaveService().scan();
    if (saves.isEmpty) return null;
    return saves.first.seasonState;
  }

  // ── Geo-based season ──────────────────────────────────────────────────────

  Future<SeasonState?> _geoSeason() async {
    try {
      var perm = await Geolocator.checkPermission();
      if (perm == LocationPermission.denied) {
        perm = await Geolocator.requestPermission();
      }
      if (perm == LocationPermission.denied ||
          perm == LocationPermission.deniedForever) {
        return null;
      }

      final pos = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(accuracy: LocationAccuracy.low),
      ).timeout(const Duration(seconds: 8));

      return _seasonFromMonth(DateTime.now().month, isNorthern: pos.latitude >= 0);
    } catch (_) {
      return null;
    }
  }

  // ── Helpers ───────────────────────────────────────────────────────────────

  SeasonState _seasonFromMonth(int month, {required bool isNorthern}) {
    final northern = switch (month) {
      3 || 4 || 5   => SeasonState.spring,
      6 || 7 || 8   => SeasonState.summer,
      9 || 10 || 11 => SeasonState.fall,
      _             => SeasonState.winter,
    };
    if (isNorthern) return northern;
    return switch (northern) {
      SeasonState.spring => SeasonState.fall,
      SeasonState.fall   => SeasonState.spring,
      SeasonState.summer => SeasonState.winter,
      SeasonState.winter => SeasonState.summer,
      _                  => northern,
    };
  }

  SeasonState _randomSeason() {
    const seasons = [
      SeasonState.spring,
      SeasonState.summer,
      SeasonState.fall,
      SeasonState.winter,
    ];
    return seasons[_rng.nextInt(seasons.length)];
  }
}
