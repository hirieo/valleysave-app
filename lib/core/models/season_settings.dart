import 'season_state.dart';

enum SeasonMode { auto, savesOnly, geoOnly, fixed, random }

class SeasonSettings {
  const SeasonSettings({
    this.mode = SeasonMode.auto,
    this.fixedSeason,
  });

  final SeasonMode mode;
  final SeasonState? fixedSeason; // only relevant when mode == fixed

  SeasonSettings copyWith({SeasonMode? mode, SeasonState? fixedSeason}) =>
      SeasonSettings(
        mode: mode ?? this.mode,
        fixedSeason: fixedSeason ?? this.fixedSeason,
      );
}
