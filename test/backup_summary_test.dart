import 'dart:io';

import 'package:archive/archive.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:valleysave/core/services/backup_service.dart';
import 'package:valleysave/features/saves/widgets/backup_game_summary.dart';
import 'package:valleysave/generated/app_localizations_en.dart';
import 'package:valleysave/generated/app_localizations_es.dart';

import 'fixtures/zip_fixtures.dart';

/// Spec 012, D6: datos de partida por fila, leídos del SaveGameInfo del zip.
void main() {
  late Directory tempDir;
  final service = BackupService();
  const folderName = ZipFixtures.validFolderName;

  setUp(() async {
    BackupService.clearSummaryCache();
    tempDir = await Directory.systemTemp.createTemp('vs_summary_test_');
  });

  tearDown(() async {
    if (await tempDir.exists()) await tempDir.delete(recursive: true);
  });

  Future<File> zipWith({
    required String season,
    required String day,
    required String year,
    required String money,
    String name = 'a_backup_20260701-100000.zip',
  }) {
    final archive = Archive()
      ..addFile(
        ArchiveFile.string('$folderName/SaveGameInfo', '''<?xml version="1.0"?>
<Farmer>
  <name>Ana</name>
  <farmName>Granja</farmName>
  <seasonForSaveGame>$season</seasonForSaveGame>
  <dayOfMonthForSaveGame>$day</dayOfMonthForSaveGame>
  <yearForSaveGame>$year</yearForSaveGame>
  <money>$money</money>
</Farmer>'''),
      )
      ..addFile(ArchiveFile.string('$folderName/$folderName', '<SaveGame/>'));
    return ZipFixtures.writeZip(archive, tempDir, name);
  }

  group('readGameSummary', () {
    test('lee año, estación, día y dinero del zip', () async {
      final zip = await zipWith(
        season: '2',
        day: '12',
        year: '3',
        money: '248310',
      );

      final summary = await service.readGameSummary(zip.path);

      expect(summary, (year: 3, season: 'fall', day: 12, money: 248310));
    });

    test('con el zip de fixture estándar', () async {
      final zip = await ZipFixtures.writeZip(
        ZipFixtures.validArchive(),
        tempDir,
        'fixture.zip',
      );

      final summary = await service.readGameSummary(zip.path);

      expect(summary, (year: 1, season: 'spring', day: 5, money: 500));
    });

    test('un zip corrupto devuelve null sin lanzar', () async {
      final bad = File('${tempDir.path}${Platform.pathSeparator}bad.zip');
      await bad.writeAsBytes([1, 2, 3, 4]);

      expect(await service.readGameSummary(bad.path), isNull);
    });

    test('un archivo que no existe devuelve null', () async {
      expect(
        await service.readGameSummary(
          '${tempDir.path}${Platform.pathSeparator}no-existe.zip',
        ),
        isNull,
      );
    });

    test('un zip sin SaveGameInfo devuelve null', () async {
      final zip = await ZipFixtures.writeZip(
        ZipFixtures.notASaveArchive(),
        tempDir,
        'otro.zip',
      );
      expect(await service.readGameSummary(zip.path), isNull);
    });

    test(
      'caché por nombre de archivo: la segunda lectura no toca el disco',
      () async {
        final zip = await zipWith(
          season: '0',
          day: '1',
          year: '1',
          money: '10',
        );
        final first = await service.readGameSummary(zip.path);
        await zip.delete();

        expect(await service.readGameSummary(zip.path), first);
      },
    );

    test('un null no se cachea (el zip pudo estar a medio descargar)', () async {
      final path =
          '${tempDir.path}${Platform.pathSeparator}x_backup_20260701-100000.zip';
      await File(path).writeAsBytes([1, 2, 3]);
      expect(await service.readGameSummary(path), isNull);

      await File(path).delete();
      await zipWith(
        season: '3',
        day: '28',
        year: '2',
        money: '99',
        name: 'x_backup_20260701-100000.zip',
      );

      expect(await service.readGameSummary(path), (
        year: 2,
        season: 'winter',
        day: 28,
        money: 99,
      ));
    });
  });

  group('formatBackupSize', () {
    test('MB con el decimal del idioma', () {
      expect(formatBackupSize(13000000, 'es'), '12,4 MB');
      expect(formatBackupSize(13000000, 'en'), '12.4 MB');
    });

    test('por debajo de 1 MB en KB y por debajo de 1 KB en bytes', () {
      expect(formatBackupSize(512 * 1024, 'es'), '512 KB');
      expect(formatBackupSize(10, 'es'), '10 B');
    });
  });
  group('formatBackupGameSummary', () {
    const summary = (year: 3, season: 'fall', day: 12, money: 248310);

    test('español: estación traducida y miles con punto', () {
      expect(
        formatBackupGameSummary(summary, AppLocalizationsEs()),
        'Año 3 · Otoño 12 · 248.310 g',
      );
    });

    test('inglés: miles con coma', () {
      expect(
        formatBackupGameSummary(summary, AppLocalizationsEn()),
        'Year 3 · Fall 12 · 248,310 g',
      );
    });

    test('estación desconocida se muestra tal cual', () {
      expect(
        formatBackupGameSummary((
          year: 1,
          season: 'rare',
          day: 1,
          money: 5,
        ), AppLocalizationsEs()),
        'Año 1 · rare 1 · 5 g',
      );
    });
  });
}
