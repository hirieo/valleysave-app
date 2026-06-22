import 'save_file.dart';

/// Estado de sincronización de una granja entre local y Drive.
enum SaveSyncStatus { synced, localAhead, driveAhead, localOnly, driveOnly }

/// Empareja una misma granja (mismo [SaveFile.folderName] = uniqueID)
/// en sus dos posibles ubicaciones: este equipo y Google Drive.
class SaveEntry {
  const SaveEntry({this.local, this.drive, this.driveFolderId});

  final SaveFile? local;
  final SaveFile? drive;
  final String? driveFolderId; // id de la subcarpeta en Drive (para descargar)

  String get folderName => (local ?? drive)!.folderName;

  /// Save mostrado como principal: el guardado más recientemente (reloj real).
  SaveFile get primary {
    final l = local, d = drive;
    if (l != null && d != null) {
      return l.lastModified.isAfter(d.lastModified) ? l : d;
    }
    return (l ?? d)!;
  }

  /// Estado calculado por progreso (millisecondsPlayed). "Sincronizado" =
  /// mismo tiempo jugado → mismo punto de la partida.
  SaveSyncStatus get status {
    final l = local, d = drive;
    if (l != null && d == null) return SaveSyncStatus.localOnly;
    if (l == null && d != null) return SaveSyncStatus.driveOnly;
    if (l!.millisecondsPlayed == d!.millisecondsPlayed) {
      return SaveSyncStatus.synced;
    }
    return l.millisecondsPlayed > d.millisecondsPlayed
        ? SaveSyncStatus.localAhead
        : SaveSyncStatus.driveAhead;
  }
}
