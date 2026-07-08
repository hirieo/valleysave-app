/// Stats de UN jugador dentro de una partida (anfitrión o farmhand).
///
/// En solitario hay un único jugador (el anfitrión). En cooperativo hay el
/// anfitrión + un farmhand por cada cabaña reclamada. Los datos salen del
/// archivo grande del save (`<player>` para el anfitrión, `<farmhands><Farmer>`
/// para cada invitado) — el `SaveGameInfo` ligero solo trae al anfitrión.
class PlayerStats {
  const PlayerStats({
    required this.name,
    required this.isHost,
    required this.uniqueId,
    required this.gender,
    required this.farmingLevel,
    required this.miningLevel,
    required this.combatLevel,
    required this.foragingLevel,
    required this.fishingLevel,
    required this.luckLevel,
    required this.currentMoney,
    required this.totalMoneyEarned,
    required this.millisecondsPlayed,
    required this.health,
    required this.stamina,
    required this.deepestMineLevel,
    required this.houseUpgradeLevel,
    required this.monstersKilled,
    required this.timesUnconscious,
    required this.goodFriends,
    required this.averageBedtime,
    required this.daysPlayed,
  });

  final String name;
  final bool isHost;
  final String uniqueId; // UniqueMultiplayerID — empareja jugadores local↔Drive
  final int gender;      // 0=male 1=female
  final int farmingLevel;
  final int miningLevel;
  final int combatLevel;
  final int foragingLevel;
  final int fishingLevel;
  final int luckLevel;
  final int currentMoney;
  final int totalMoneyEarned;
  final int millisecondsPlayed;
  final int health;
  final int stamina;
  final int deepestMineLevel;
  final int houseUpgradeLevel;
  final int monstersKilled;
  final int timesUnconscious;
  final int goodFriends;
  final int averageBedtime; // formato militar de 4 dígitos, p.ej. 2063
  final int daysPlayed;

  Duration get playtime => Duration(milliseconds: millisecondsPlayed);

  String get playtimeLabel {
    final h = playtime.inHours;
    final m = playtime.inMinutes.remainder(60);
    if (h == 0) return '${m}m';
    return '${h}h';
  }

  String get genderLabel => gender == 0 ? '♂' : '♀';

  // ── JSON (para el resumen ligero que se sube junto al save) ─────────────
  Map<String, dynamic> toJson() => {
        'name': name,
        'isHost': isHost,
        'uniqueId': uniqueId,
        'gender': gender,
        'farmingLevel': farmingLevel,
        'miningLevel': miningLevel,
        'combatLevel': combatLevel,
        'foragingLevel': foragingLevel,
        'fishingLevel': fishingLevel,
        'luckLevel': luckLevel,
        'currentMoney': currentMoney,
        'totalMoneyEarned': totalMoneyEarned,
        'millisecondsPlayed': millisecondsPlayed,
        'health': health,
        'stamina': stamina,
        'deepestMineLevel': deepestMineLevel,
        'houseUpgradeLevel': houseUpgradeLevel,
        'monstersKilled': monstersKilled,
        'timesUnconscious': timesUnconscious,
        'goodFriends': goodFriends,
        'averageBedtime': averageBedtime,
        'daysPlayed': daysPlayed,
      };

  factory PlayerStats.fromJson(Map<String, dynamic> j) {
    int i(String k) => (j[k] as num?)?.toInt() ?? 0;
    return PlayerStats(
      name: j['name'] as String? ?? '',
      isHost: j['isHost'] as bool? ?? false,
      uniqueId: j['uniqueId'] as String? ?? '',
      gender: i('gender'),
      farmingLevel: i('farmingLevel'),
      miningLevel: i('miningLevel'),
      combatLevel: i('combatLevel'),
      foragingLevel: i('foragingLevel'),
      fishingLevel: i('fishingLevel'),
      luckLevel: i('luckLevel'),
      currentMoney: i('currentMoney'),
      totalMoneyEarned: i('totalMoneyEarned'),
      millisecondsPlayed: i('millisecondsPlayed'),
      health: i('health'),
      stamina: i('stamina'),
      deepestMineLevel: i('deepestMineLevel'),
      houseUpgradeLevel: i('houseUpgradeLevel'),
      monstersKilled: i('monstersKilled'),
      timesUnconscious: i('timesUnconscious'),
      goodFriends: i('goodFriends'),
      averageBedtime: i('averageBedtime'),
      daysPlayed: i('daysPlayed'),
    );
  }
}
