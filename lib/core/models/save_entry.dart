import 'save_file.dart';

/// Estado de sincronización de una granja entre local y Drive.
enum SaveSyncStatus { synced, localAhead, driveAhead, localOnly, driveOnly }

/// Empareja una misma granja (mismo [SaveFile.folderName] = uniqueID)
/// en sus dos posibles ubicaciones: este equipo y Google Drive.
class SaveEntry {
  const SaveEntry({
    this.local,
    this.drive,
    this.driveFolderId,
    this.driveComplete = true,
  });

  final SaveFile? local;
  final SaveFile? drive;
  final String? driveFolderId; // id de la subcarpeta en Drive (para descargar)

  /// `false` cuando a [drive] le falta el archivo principal en Drive (spec
  /// 001-integridad-transaccional-saves FR-015) — ver
  /// `DriveSaveSummary.complete`. La UI bloquea la descarga en ese caso, para
  /// no bajar algo a medias.
  final bool driveComplete;

  String get folderName => (local ?? drive)!.folderName;

  /// Save mostrado como principal: el guardado más recientemente (reloj real).
  SaveFile get primary {
    final l = local, d = drive;
    if (l != null && d != null) {
      return l.lastModified.isAfter(d.lastModified) ? l : d;
    }
    return (l ?? d)!;
  }

  /// Estado calculado por progreso de CALENDARIO (año/estación/día — nivel
  /// granja, igual para cualquier jugador). "Sincronizado" = mismo día →
  /// mismo punto de la partida. NUNCA se compara por `millisecondsPlayed`
  /// (tiempo jugado es por-jugador; tras un cambio de anfitrión, "el host"
  /// de cada lado puede ser una persona distinta — comparar sus tiempos
  /// jugados no dice nada del avance real de la granja).
  SaveSyncStatus get status {
    final l = local, d = drive;
    if (l != null && d == null) return SaveSyncStatus.localOnly;
    if (l == null && d != null) return SaveSyncStatus.driveOnly;
    if (l!.calendarDayOrdinal == d!.calendarDayOrdinal) {
      return SaveSyncStatus.synced;
    }
    return l.calendarDayOrdinal > d.calendarDayOrdinal
        ? SaveSyncStatus.localAhead
        : SaveSyncStatus.driveAhead;
  }
}
