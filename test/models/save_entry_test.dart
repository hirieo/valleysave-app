import 'package:flutter_test/flutter_test.dart';
import 'package:valleysave/core/models/save_entry.dart';
import 'package:valleysave/core/models/save_file.dart';

void main() {
  group('SaveEntry.status', () {
    test('ignora tiempo y jugador anfitrión cuando el calendario coincide', () {
      final local = _save(
        day: 4,
        season: 'spring',
        year: 1,
        playerName: 'Nuevo anfitrión',
        millisecondsPlayed: 60 * 60 * 1000,
      );
      final drive = _save(
        day: 4,
        season: 'spring',
        year: 1,
        playerName: 'Anfitrión anterior',
        millisecondsPlayed: 900 * 60 * 60 * 1000,
      );

      expect(
        SaveEntry(local: local, drive: drive).status,
        SaveSyncStatus.synced,
      );
    });

    test('compara el día absoluto incluyendo estación y año', () {
      final winter = _save(day: 28, season: 'winter', year: 1);
      final nextYear = _save(day: 1, season: 'spring', year: 2);

      expect(
        SaveEntry(local: nextYear, drive: winter).status,
        SaveSyncStatus.localAhead,
      );
      expect(
        SaveEntry(local: winter, drive: nextYear).status,
        SaveSyncStatus.driveAhead,
      );
    });
  });
}

SaveFile _save({
  required int day,
  required String season,
  required int year,
  String playerName = 'Hirieo',
  int millisecondsPlayed = 0,
}) {
  return SaveFile(
    folderPath: 'C:/Saves/Stardust_1',
    folderName: 'Stardust_1',
    playerName: playerName,
    farmName: 'Stardust',
    dayOfMonth: day,
    currentSeason: season,
    year: year,
    currentMoney: 0,
    totalMoneyEarned: 0,
    millisecondsPlayed: millisecondsPlayed,
    lastModified: DateTime(2026, 7, 13),
    farmingLevel: 0,
    miningLevel: 0,
    combatLevel: 0,
    foragingLevel: 0,
    fishingLevel: 0,
    houseUpgradeLevel: 0,
    petType: 'cat',
    gender: 0,
    deepestMineLevel: 0,
    monstersKilled: 0,
    timesUnconscious: 0,
    goodFriends: 0,
    timeOfDay: 600,
    averageBedtime: 2200,
    weather: WeatherType.sunny,
    stamina: 270,
    health: 100,
  );
}
