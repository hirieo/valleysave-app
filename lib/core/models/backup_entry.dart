/// Respaldo pre-swap de un save (zip generado por `HostSwapService.execute`,
/// formato `TransferService.exportSave`). Emparejamiento local↔Drive por
/// [fileName] EXACTO — el nombre ya es único por swap (spec 007 G10).
class BackupEntry {
  const BackupEntry({
    required this.fileName,
    required this.folderName,
    required this.timestamp,
    this.localPath,
    this.driveFileId,
    required this.sizeBytes,
  });

  final String fileName;
  final String folderName;
  final DateTime timestamp;
  final String? localPath;
  final String? driveFileId;
  final int sizeBytes;

  bool get isLocal => localPath != null;
  bool get isOnDrive => driveFileId != null;

  static final _pattern = RegExp(r'^(.+)_pre-swap_(\d{8}-\d{6})\.zip$');

  /// Parsea `<folderName>_pre-swap_<yyyyMMdd-HHmmss>.zip`. Devuelve `null`
  /// si el nombre no sigue el patrón (archivo ajeno en la misma carpeta).
  static ({String folderName, DateTime timestamp})? parseFileName(String fileName) {
    final match = _pattern.firstMatch(fileName);
    if (match == null) return null;
    final folderName = match.group(1)!;
    final ts = match.group(2)!; // yyyyMMdd-HHmmss
    try {
      final year = int.parse(ts.substring(0, 4));
      final month = int.parse(ts.substring(4, 6));
      final day = int.parse(ts.substring(6, 8));
      final hour = int.parse(ts.substring(9, 11));
      final minute = int.parse(ts.substring(11, 13));
      final second = int.parse(ts.substring(13, 15));
      return (
        folderName: folderName,
        timestamp: DateTime(year, month, day, hour, minute, second),
      );
    } catch (_) {
      return null;
    }
  }

  BackupEntry copyWith({String? localPath, String? driveFileId, int? sizeBytes}) {
    return BackupEntry(
      fileName: fileName,
      folderName: folderName,
      timestamp: timestamp,
      localPath: localPath ?? this.localPath,
      driveFileId: driveFileId ?? this.driveFileId,
      sizeBytes: sizeBytes ?? this.sizeBytes,
    );
  }
}
