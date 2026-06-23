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

  /// Solo sobreescribe si el modo es AUTO.
  /// Llamar tras cargar saves — propaga la estación de la partida más reciente.
  Future<void> setFromSaves(List<SaveEntry> entries) async {
    final settings = await SeasonService().loadSettings();
    if (settings.mode != SeasonMode.auto) return;
    season.value = entries.isEmpty
        ? SeasonState.initial
        : entries.first.primary.seasonState;
  }

  /// Cambio directo desde Ajustes al seleccionar modo fixed o random.
  void set(SeasonState s) => season.value = s;
}
