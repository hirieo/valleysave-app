import 'dart:io';

import 'package:archive/archive.dart';

/// Fixtures de zip para `transfer_service_test.dart` — generadas en memoria
/// con `package:archive`, sin tocar disco hasta que un test concreto lo
/// pida (ver [writeZip]). Cubren los casos G1-G10 de
/// `contracts/transfer_service.md`.
class ZipFixtures {
  static const validFolderName = 'TestExport_123456789';

  /// Zip válido: carpeta con `SaveGameInfo` + archivo principal, estructura
  /// mínima de save solitario (un solo `<player>`, sin `<farmhands>`).
  static Archive validArchive({String folderName = validFolderName}) {
    final archive = Archive();
    archive.addFile(ArchiveFile.string(
      '$folderName/SaveGameInfo',
      _infoXml(),
    ));
    archive.addFile(ArchiveFile.string(
      '$folderName/$folderName',
      _mainXml(),
    ));
    return archive;
  }

  /// Zip con una entrada zip-slip (`../../evil.txt`) junto a contenido
  /// por lo demás válido — debe rechazarse ANTES de escribir nada.
  static Archive zipSlipArchive() {
    final archive = validArchive();
    archive.addFile(ArchiveFile.string('../../evil.txt', 'malicious'));
    return archive;
  }

  /// Zip con una entrada symlink — mismo tratamiento que zip-slip.
  static Archive symlinkArchive() {
    final archive = validArchive();
    archive.addFile(ArchiveFile.symlink(
      '$validFolderName/link',
      '/etc/passwd',
    ));
    return archive;
  }

  /// Zip "bomba": declara un tamaño descomprimido por encima del límite
  /// (~500MB) sin necesidad de datos reales de cientos de MB — el campo
  /// `size` de `ArchiveFile` es independiente de los bytes reales que lleva.
  static Archive zipBombArchive() {
    final archive = Archive();
    archive.addFile(ArchiveFile(
      '$validFolderName/SaveGameInfo',
      600 * 1024 * 1024,
      [1, 2, 3],
    ));
    return archive;
  }

  /// Zip con más entradas que el límite permitido, cada una diminuta (cubre
  /// el límite de Nº de archivos, no solo el de tamaño).
  static Archive tooManyEntriesArchive({int count = 2001}) {
    final archive = Archive();
    for (var i = 0; i < count; i++) {
      archive.addFile(ArchiveFile.string('$validFolderName/file_$i', 'x'));
    }
    return archive;
  }

  /// Zip sin `SaveGameInfo` en ningún punto — no reconocible como save.
  static Archive notASaveArchive() {
    final archive = Archive();
    archive.addFile(ArchiveFile.string('Random/readme.txt', 'hola'));
    return archive;
  }

  /// Zip con `SaveGameInfo` pero sin el archivo principal correspondiente.
  static Archive missingMainFileArchive() {
    final archive = Archive();
    archive.addFile(ArchiveFile.string(
      '$validFolderName/SaveGameInfo',
      _infoXml(),
    ));
    return archive;
  }

  /// Zip con `SaveGameInfo` cuyo contenido no es XML interpretable.
  static Archive corruptInfoArchive() {
    final archive = Archive();
    archive.addFile(ArchiveFile.string(
      '$validFolderName/SaveGameInfo',
      'esto no es xml',
    ));
    archive.addFile(ArchiveFile.string(
      '$validFolderName/$validFolderName',
      _mainXml(),
    ));
    return archive;
  }

  /// Codifica [archive] a bytes de zip reales y los escribe en [dir] — para
  /// los tests que ejercitan `TransferService.importSave` (lectura de disco
  /// real), no solo `importArchive` (nivel de memoria).
  static Future<File> writeZip(
    Archive archive,
    Directory dir,
    String fileName,
  ) async {
    final bytes = ZipEncoder().encodeBytes(archive);
    final file = File('${dir.path}${Platform.pathSeparator}$fileName');
    await file.writeAsBytes(bytes);
    return file;
  }

  static String _infoXml() => '''<?xml version="1.0" encoding="utf-8"?>
<Farmer>
  <name>Ana</name>
  <farmName>Granja Test</farmName>
  <slotCanHost>false</slotCanHost>
  <useSeparateWallets>false</useSeparateWallets>
  <seasonForSaveGame>0</seasonForSaveGame>
  <dayOfMonthForSaveGame>5</dayOfMonthForSaveGame>
  <yearForSaveGame>1</yearForSaveGame>
  <money>500</money>
  <UniqueMultiplayerID>9999999999999999999</UniqueMultiplayerID>
</Farmer>''';

  static String _mainXml() => '''<?xml version="1.0" encoding="utf-8"?>
<SaveGame xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">
  <uniqueIDForThisGame>123456789</uniqueIDForThisGame>
  <player>
    <name>Ana</name>
    <UniqueMultiplayerID>9999999999999999999</UniqueMultiplayerID>
    <slotCanHost>false</slotCanHost>
    <homeLocation>FarmHouse</homeLocation>
    <houseUpgradeLevel>0</houseUpgradeLevel>
    <Gender>Female</Gender>
    <money>500</money>
    <totalMoneyEarned>500</totalMoneyEarned>
    <millisecondsPlayed>10000</millisecondsPlayed>
    <farmingLevel>0</farmingLevel><miningLevel>0</miningLevel>
    <combatLevel>0</combatLevel><foragingLevel>0</foragingLevel>
    <fishingLevel>0</fishingLevel><deepestMineLevel>0</deepestMineLevel>
    <health>100</health><stamina>270</stamina>
  </player>
  <locations/>
</SaveGame>''';
}
