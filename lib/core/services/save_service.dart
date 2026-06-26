import 'dart:io';

import 'package:xml/xml.dart';

import '../models/save_file.dart';

class SaveService {
  static String? get savesDirectory {
    if (Platform.isWindows) {
      final appData = Platform.environment['APPDATA'];
      if (appData == null) return null;
      return '$appData\\StardewValley\\Saves';
    }
    if (Platform.isMacOS || Platform.isLinux) {
      final home = Platform.environment['HOME'];
      if (home == null) return null;
      return '$home/.config/StardewValley/Saves';
    }
    // Android: la carpeta del juego está protegida; el acceso es vía Shizuku
    // (ver ShizukuService). No hay path directo escaneable.
    return null;
  }

  Future<List<SaveFile>> scan() async {
    final dir = savesDirectory;
    if (dir == null) return [];
    return scanDir(dir);
  }

  /// Escanea cualquier carpeta que contenga subcarpetas de save (usado tanto
  /// para la carpeta nativa de desktop como para la copia-puente de Android).
  Future<List<SaveFile>> scanDir(String dir) async {
    final savesDir = Directory(dir);
    if (!await savesDir.exists()) return [];

    final results = <SaveFile>[];

    await for (final entity in savesDir.list()) {
      if (entity is! Directory) continue;
      final save = await _parseSave(entity);
      if (save != null) results.add(save);
    }

    results.sort((a, b) => b.lastModified.compareTo(a.lastModified));
    return results;
  }

  Future<SaveFile?> _parseSave(Directory folder) async {
    try {
      final infoFile = File('${folder.path}${Platform.pathSeparator}SaveGameInfo');
      if (!await infoFile.exists()) return null;

      final raw = await infoFile.readAsString();
      final lastMod = await infoFile.lastModified();

      return parseSaveGameInfo(
        raw,
        folderName: folder.path.split(Platform.pathSeparator).last,
        folderPath: folder.path,
        lastModified: lastMod,
      );
    } catch (_) {
      return null;
    }
  }

  /// Parsea el XML de un SaveGameInfo. Sirve tanto para archivos locales
  /// como para los bytes descargados de Drive. [lastModified] es la hora
  /// real de guardado (mtime local, o el modifiedTime del archivo en Drive).
  static SaveFile? parseSaveGameInfo(
    String raw, {
    required String folderName,
    String folderPath = '',
    required DateTime lastModified,
  }) {
    try {
      final doc = XmlDocument.parse(raw);
      final root = doc.rootElement;

      // Direct child text helper
      String tag(String name) =>
          root.findElements(name).firstOrNull?.innerText ?? '';

      // Stardew moderno guarda los stats numéricos en un diccionario
      // <stats><Values><item><key><string>X</string></key>
      //   <value><unsignedInt>N</unsignedInt></value></item>...</Values></stats>
      final statsEl  = root.findElements('stats').firstOrNull;
      final valuesEl = statsEl?.findElements('Values').firstOrNull;
      final statValues = <String, int>{};
      if (valuesEl != null) {
        for (final item in valuesEl.findElements('item')) {
          final key = item
              .findElements('key')
              .firstOrNull
              ?.findElements('string')
              .firstOrNull
              ?.innerText;
          final valText =
              item.findElements('value').firstOrNull?.innerText;
          final val = int.tryParse(valText ?? '');
          if (key != null && val != null) statValues[key] = val;
        }
      }
      int stat(String name) => statValues[name] ?? 0;

      final playerName = tag('name');
      final farmName   = tag('farmName');
      if (playerName.isEmpty) return null;

      final seasonInt  = int.tryParse(tag('seasonForSaveGame')) ?? 0;
      final seasonName = const ['spring', 'summer', 'fall', 'winter'][seasonInt.clamp(0, 3)];

      final isRaining   = tag('isRaining') == 'true';
      final isLightning = tag('isLightning') == 'true';
      final isSnowing   = tag('isSnowing') == 'true';
      final isDebris    = tag('isDebrisWeather') == 'true';
      final weather = isLightning ? WeatherType.stormy
          : isRaining              ? WeatherType.rainy
          : isSnowing              ? WeatherType.snowy
          : isDebris               ? WeatherType.windy
          : WeatherType.sunny;

      return SaveFile(
        folderPath:         folderPath,
        folderName:         folderName,
        playerName:         playerName,
        farmName:           farmName,
        dayOfMonth:         int.tryParse(tag('dayOfMonthForSaveGame')) ?? 1,
        currentSeason:      seasonName,
        year:               int.tryParse(tag('yearForSaveGame')) ?? 1,
        currentMoney:       int.tryParse(tag('money')) ?? 0,
        totalMoneyEarned:   int.tryParse(tag('totalMoneyEarned')) ?? 0,
        millisecondsPlayed: int.tryParse(tag('millisecondsPlayed')) ?? 0,
        lastModified:       lastModified,
        farmingLevel:       int.tryParse(tag('farmingLevel')) ?? 0,
        miningLevel:        int.tryParse(tag('miningLevel')) ?? 0,
        combatLevel:        int.tryParse(tag('combatLevel')) ?? 0,
        foragingLevel:      int.tryParse(tag('foragingLevel')) ?? 0,
        fishingLevel:       int.tryParse(tag('fishingLevel')) ?? 0,
        houseUpgradeLevel:  int.tryParse(tag('houseUpgradeLevel')) ?? 0,
        petType:            tag('whichPetType').toLowerCase() == 'dog' ? 'dog' : 'cat',
        gender:             tag('Gender').toLowerCase() == 'female' ? 1 : 0,
        deepestMineLevel:   int.tryParse(tag('deepestMineLevel')) ?? 0,
        monstersKilled:     stat('monstersKilled'),
        timesUnconscious:   stat('timesUnconscious'),
        goodFriends:        stat('goodFriends'),
        timeOfDay:          int.tryParse(tag('timeOfDay')) ?? 630,
        averageBedtime:     stat('averageBedtime'),
        weather:            weather,
        stamina:            (double.tryParse(tag('stamina')) ?? 0).round(),
        health:             int.tryParse(tag('health')) ?? 0,
        gameVersion:        tag('gameVersion'),
      );
    } catch (_) {
      return null;
    }
  }
}
