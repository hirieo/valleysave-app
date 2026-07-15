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
    this.sharedDriveFileId,
    required this.sizeBytes,
  });

  final String fileName;
  final String folderName;
  final DateTime timestamp;
  final String? localPath;
  final String? driveFileId;
  final String? sharedDriveFileId;
  final int sizeBytes;

  bool get isLocal => localPath != null;
  bool get isOnDrive => driveFileId != null;
  bool get isOnSharedDrive => sharedDriveFileId != null;
  int get locationCount =>
      (isLocal ? 1 : 0) + (isOnDrive ? 1 : 0) + (isOnSharedDrive ? 1 : 0);

  static final _pattern = RegExp(
    r'^(.+)_(?:pre-swap|backup)_(\d{8}-\d{6})\.zip$',
  );

  /// Parsea `<folderName>_pre-swap_<yyyyMMdd-HHmmss>.zip`. Devuelve `null`
  /// si el nombre no sigue el patrón (archivo ajeno en la misma carpeta).
  static ({String folderName, DateTime timestamp})? parseFileName(
    String fileName,
  ) {
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

  BackupEntry copyWith({
    String? localPath,
    String? driveFileId,
    String? sharedDriveFileId,
    int? sizeBytes,
    bool clearLocalPath = false,
    bool clearDriveFileId = false,
    bool clearSharedDriveFileId = false,
  }) {
    return BackupEntry(
      fileName: fileName,
      folderName: folderName,
      timestamp: timestamp,
      localPath: clearLocalPath ? null : localPath ?? this.localPath,
      driveFileId: clearDriveFileId ? null : driveFileId ?? this.driveFileId,
      sharedDriveFileId: clearSharedDriveFileId
          ? null
          : sharedDriveFileId ?? this.sharedDriveFileId,
      sizeBytes: sizeBytes ?? this.sizeBytes,
    );
  }

  /// Une las ubicaciones de dos descripciones del MISMO zip. El nombre
  /// exacto es la identidad; nunca se empareja por una fecha aproximada.
  BackupEntry mergeWith(BackupEntry other) {
    if (fileName != other.fileName) {
      throw ArgumentError('No se pueden unir backups con nombres distintos.');
    }
    return copyWith(
      localPath: other.localPath,
      driveFileId: other.driveFileId,
      sharedDriveFileId: other.sharedDriveFileId,
      sizeBytes: other.sizeBytes > sizeBytes ? other.sizeBytes : sizeBytes,
    );
  }
}
