import 'package:flutter_test/flutter_test.dart';
import 'package:valleysave/core/models/save_file.dart';
import 'package:valleysave/core/models/shared_save_entry.dart';
import 'package:valleysave/core/models/shared_sync_state.dart';

SaveFile _save(int day) => SaveFile(
  folderPath: 'C:/Saves/Stardust',
  folderName: 'Stardust_123',
  playerName: 'Hirieo',
  farmName: 'Stardust',
  dayOfMonth: day,
  currentSeason: 'spring',
  year: 1,
  currentMoney: 0,
  totalMoneyEarned: 0,
  millisecondsPlayed: day * 1000,
  lastModified: DateTime(2026, 7, day),
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
  isCoop: true,
);

SharedSaveEntry _entry({
  SaveFile? local,
  SaveFile? own,
  SaveFile? owner,
  String role = 'writer',
  bool ownerVerified = true,
}) => SharedSaveEntry(
  folderId: 'owner-folder',
  folderName: 'Stardust_123',
  ownerEmail: 'owner@gmail.com',
  myRole: role,
  localMatch: local,
  ownDriveStats: own,
  ownDriveFolderId: own == null ? null : 'own-folder',
  driveStats: owner,
  ownerDrivePresent: owner != null,
  ownerDriveVerified: ownerVerified,
);

void main() {
  group('SharedSyncState', () {
    test('las tres copias en el mismo día están totalmente sincronizadas', () {
      final state = SharedSyncState.fromEntry(
        _entry(local: _save(4), own: _save(4), owner: _save(4)),
      );

      expect(state.summary, SharedSyncSummary.allSynced);
      expect(state.uploadTargets, isEmpty);
      expect(state.downloadSources, isEmpty);
    });

    test('solo Mi Drive coincide y el Drive del dueño está atrasado', () {
      final state = SharedSyncState.fromEntry(
        _entry(local: _save(6), own: _save(6), owner: _save(4)),
      );

      expect(state.summary, SharedSyncSummary.syncedWithOwnDrive);
      expect(state.uploadTargets, [SharedCloudLocation.ownerDrive]);
      expect(state.downloadSources, isEmpty);
    });

    test('solo el Drive del dueño coincide y Mi Drive no existe', () {
      final state = SharedSyncState.fromEntry(
        _entry(local: _save(6), owner: _save(6)),
      );

      expect(state.summary, SharedSyncSummary.syncedWithOwnerDrive);
      expect(state.uploadTargets, [SharedCloudLocation.ownDrive]);
    });

    test('local va por delante de ambos y permite elegir destino', () {
      final state = SharedSyncState.fromEntry(
        _entry(local: _save(6), own: _save(4), owner: _save(4)),
      );

      expect(state.summary, SharedSyncSummary.notInCloud);
      expect(state.uploadTargets, [
        SharedCloudLocation.ownDrive,
        SharedCloudLocation.ownerDrive,
      ]);
      expect(state.downloadSources, isEmpty);
    });

    test('un lector nunca puede subir al Drive del dueño', () {
      final state = SharedSyncState.fromEntry(
        _entry(local: _save(6), own: _save(4), owner: _save(4), role: 'reader'),
      );

      expect(state.uploadTargets, [SharedCloudLocation.ownDrive]);
    });

    test('Mi Drive por delante ofrece descargar desde Mi Drive', () {
      final state = SharedSyncState.fromEntry(
        _entry(local: _save(4), own: _save(6), owner: _save(4)),
      );

      expect(state.summary, SharedSyncSummary.ownDriveAhead);
      expect(state.downloadSources, [SharedCloudLocation.ownDrive]);
    });

    test('Drive del dueño por delante ofrece descargar desde el dueño', () {
      final state = SharedSyncState.fromEntry(
        _entry(local: _save(4), own: _save(4), owner: _save(6)),
      );

      expect(state.summary, SharedSyncSummary.ownerDriveAhead);
      expect(state.downloadSources, [SharedCloudLocation.ownerDrive]);
    });

    test('ambos Drives por delante permiten elegir origen', () {
      final state = SharedSyncState.fromEntry(
        _entry(local: _save(4), own: _save(5), owner: _save(6)),
      );

      expect(state.summary, SharedSyncSummary.bothDrivesAhead);
      expect(state.downloadSources, [
        SharedCloudLocation.ownDrive,
        SharedCloudLocation.ownerDrive,
      ]);
    });

    test('sin copia local ofrece los dos orígenes disponibles', () {
      final state = SharedSyncState.fromEntry(
        _entry(own: _save(5), owner: _save(6)),
      );

      expect(state.summary, SharedSyncSummary.localMissing);
      expect(state.downloadSources, [
        SharedCloudLocation.ownDrive,
        SharedCloudLocation.ownerDrive,
      ]);
      expect(state.uploadTargets, isEmpty);
    });

    test(
      'Drive del dueño sin verificar no se trata como ausente ni editable',
      () {
        final state = SharedSyncState.fromEntry(
          _entry(local: _save(6), own: _save(4), ownerVerified: false),
        );

        expect(state.summary, SharedSyncSummary.ownerUnavailable);
        expect(state.ownerDriveRelation, SharedCopyRelation.unavailable);
        expect(state.uploadTargets, [SharedCloudLocation.ownDrive]);
        expect(state.downloadSources, isEmpty);
      },
    );

    test('el progreso usa el calendario y no el tiempo del jugador', () {
      final local = _save(4);
      final owner = SaveFile(
        folderPath: local.folderPath,
        folderName: local.folderName,
        playerName: 'Otro anfitrión',
        farmName: local.farmName,
        dayOfMonth: local.dayOfMonth,
        currentSeason: local.currentSeason,
        year: local.year,
        currentMoney: 0,
        totalMoneyEarned: 0,
        millisecondsPlayed: 999999999,
        lastModified: DateTime(2030),
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
        isCoop: true,
      );

      final state = SharedSyncState.fromEntry(
        _entry(local: local, own: local, owner: owner),
      );

      expect(state.summary, SharedSyncSummary.allSynced);
    });
  });
}
