import 'package:flutter/foundation.dart';

import '../models/save_entry.dart';
import '../models/season_settings.dart';
import '../models/season_state.dart';
import 'season_service.dart';

class SeasonController {
  static final instance = SeasonController._();
  SeasonController._();

  final ValueNotifier<SeasonState> season = ValueNotifier(SeasonState.initial);

  /// Inicializa desde ajustes: honra modos fixed/random; auto → save→geo→Inicial.
  Future<void> init() async {
    season.value = await SeasonService().resolve();
  }

  /// Sobreescribe solo en modos que dependen de las partidas (auto / savesOnly).
  /// Llamar tras cargar saves — propaga la estación de la partida más reciente.
  Future<void> setFromSaves(List<SaveEntry> entries) async {
    final settings = await SeasonService().loadSettings();
    final m = settings.mode;
    if (m == SeasonMode.auto || m == SeasonMode.savesOnly) {
      if (entries.isNotEmpty) {
        season.value = entries.first.primary.seasonState;
      } else if (m == SeasonMode.savesOnly) {
        season.value = SeasonState.initial;
      } else {
        // auto sin partidas → re-resolver para caer a geo→initial
        season.value = await SeasonService().resolve();
      }
    }
    // geoOnly/fixed/random → no tocar (la fuente no depende de las partidas)
  }

  /// Cambio directo desde Ajustes al seleccionar modo fixed o random.
  void set(SeasonState s) => season.value = s;
}
