import 'package:flutter_test/flutter_test.dart';
import 'package:valleysave/core/models/player_stats.dart';

void main() {
  group('PlayerStats — ida y vuelta a JSON (resumen que sube a Drive)', () {
    const original = PlayerStats(
      name: 'Eltestosteron',
      isHost: false,
      uniqueId: '7315742846708293284',
      gender: 0,
      farmingLevel: 0,
      miningLevel: 0,
      combatLevel: 0,
      foragingLevel: 0,
      fishingLevel: 0,
      luckLevel: 0,
      currentMoney: 500,
      totalMoneyEarned: 228,
      millisecondsPlayed: 561536,
      health: 100,
      stamina: 270,
      deepestMineLevel: 0,
      houseUpgradeLevel: 0,
      monstersKilled: 0,
      timesUnconscious: 0,
      goodFriends: 0,
      averageBedtime: 0,
      daysPlayed: 1,
    );

    test('toJson → fromJson conserva todos los campos', () {
      final restored = PlayerStats.fromJson(original.toJson());
      expect(restored.name, original.name);
      expect(restored.isHost, original.isHost);
      expect(restored.uniqueId, original.uniqueId);
      expect(restored.currentMoney, original.currentMoney);
      expect(restored.millisecondsPlayed, original.millisecondsPlayed);
      expect(restored.daysPlayed, original.daysPlayed);
    });

    test('fromJson con mapa vacío no lanza, usa defaults', () {
      final p = PlayerStats.fromJson(const {});
      expect(p.name, '');
      expect(p.currentMoney, 0);
      expect(p.isHost, isFalse);
    });

    test('playtimeLabel formatea igual que el modelo original', () {
      expect(original.playtimeLabel, '9m');
    });
  });
}
