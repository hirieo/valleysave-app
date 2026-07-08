import 'package:flutter_test/flutter_test.dart';
import 'package:valleysave/core/services/save_service.dart';

/// Campos de un Farmer (sin el elemento contenedor). En el save real, el
/// anfitrión los lleva directos dentro de `<player>` y cada invitado dentro de
/// su propio `<Farmer>`.
String _fields({
  required String name,
  required String uid,
  int money = 0,
  int foraging = 0,
  int msPlayed = 0,
  int daysPlayed = 0,
}) =>
    '''
      <name>$name</name>
      <Gender>Male</Gender>
      <farmingLevel>0</farmingLevel>
      <miningLevel>0</miningLevel>
      <combatLevel>0</combatLevel>
      <foragingLevel>$foraging</foragingLevel>
      <fishingLevel>0</fishingLevel>
      <deepestMineLevel>0</deepestMineLevel>
      <houseUpgradeLevel>0</houseUpgradeLevel>
      <health>100</health>
      <stamina>270</stamina>
      <totalMoneyEarned>228</totalMoneyEarned>
      <millisecondsPlayed>$msPlayed</millisecondsPlayed>
      <UniqueMultiplayerID>$uid</UniqueMultiplayerID>
      <money>$money</money>
      <stats><Values>
        <item><key><string>daysPlayed</string></key><value><unsignedInt>$daysPlayed</unsignedInt></value></item>
        <item><key><string>monstersKilled</string></key><value><unsignedInt>7</unsignedInt></value></item>
      </Values></stats>''';

String _bigSave() => '''<?xml version="1.0" encoding="utf-8"?>
<SaveGame>
  <player>
    ${_fields(name: 'Hirieo', uid: '2321001960493971870', money: 128, foraging: 1, msPlayed: 4778704, daysPlayed: 4)}
  </player>
  <farmhands>
    <Farmer>${_fields(name: 'Eltestosteron', uid: '7315742846708293284', money: 500, msPlayed: 561536, daysPlayed: 1)}</Farmer>
    <Farmer>${_fields(name: '', uid: '5346915482428432340')}</Farmer>
  </farmhands>
</SaveGame>''';

String _saveGameInfo({required bool coop, required bool separateWallets}) =>
    '''<?xml version="1.0" encoding="utf-8"?>
<Farmer>
  <name>Hirieo</name>
  <farmName>Stardust</farmName>
  <seasonForSaveGame>0</seasonForSaveGame>
  <dayOfMonthForSaveGame>4</dayOfMonthForSaveGame>
  <yearForSaveGame>1</yearForSaveGame>
  <money>128</money>
  <slotCanHost>$coop</slotCanHost>
  <useSeparateWallets>$separateWallets</useSeparateWallets>
</Farmer>''';

void main() {
  group('SaveService.parseFullSave', () {
    final players = SaveService.parseFullSave(_bigSave());

    test('extrae anfitrión + farmhand real, salta cabaña vacía', () {
      expect(players.length, 2);
      expect(players.map((p) => p.name), ['Hirieo', 'Eltestosteron']);
    });

    test('el anfitrión va primero y marcado isHost', () {
      expect(players.first.isHost, isTrue);
      expect(players[1].isHost, isFalse);
    });

    test('lee dinero por jugador (carteras separadas)', () {
      expect(players[0].currentMoney, 128);
      expect(players[1].currentMoney, 500);
    });

    test('lee el UniqueMultiplayerID de cada jugador', () {
      expect(players[0].uniqueId, '2321001960493971870');
      expect(players[1].uniqueId, '7315742846708293284');
    });

    test('parsea el diccionario de stats por jugador', () {
      expect(players[0].daysPlayed, 4);
      expect(players[0].monstersKilled, 7);
      expect(players[1].daysPlayed, 1);
    });

    test('XML corrupto → lista vacía sin lanzar', () {
      expect(SaveService.parseFullSave('<no-cerrado'), isEmpty);
    });
  });

  group('SaveService.parseSaveGameInfo — coop flags', () {
    test('slotCanHost=true → isCoop', () {
      final s = SaveService.parseSaveGameInfo(
        _saveGameInfo(coop: true, separateWallets: true),
        folderName: 'Stardust_1',
        lastModified: DateTime(2026),
      );
      expect(s, isNotNull);
      expect(s!.isCoop, isTrue);
      expect(s.separateWallets, isTrue);
    });

    test('slotCanHost=false → individual', () {
      final s = SaveService.parseSaveGameInfo(
        _saveGameInfo(coop: false, separateWallets: false),
        folderName: 'Pleyades_1',
        lastModified: DateTime(2026),
      );
      expect(s, isNotNull);
      expect(s!.isCoop, isFalse);
      expect(s.separateWallets, isFalse);
    });
  });
}
