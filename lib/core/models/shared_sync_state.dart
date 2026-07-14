import 'save_file.dart';
import 'shared_save_entry.dart';

/// Las dos nubes que puede controlar una tarjeta COOP compartida.
enum SharedCloudLocation { ownDrive, ownerDrive }

/// Relación de una copia remota respecto a la copia local.
enum SharedCopyRelation { missing, behind, synced, ahead, unavailable }

/// Resumen único que presenta el footer. Las acciones concretas viven en
/// [uploadTargets] y [downloadSources], para que el texto nunca decida I/O.
enum SharedSyncSummary {
  allSynced,
  syncedWithOwnDrive,
  syncedWithOwnerDrive,
  ownDriveAhead,
  ownerDriveAhead,
  bothDrivesAhead,
  notInCloud,
  localMissing,
  ownerUnavailable,
}

/// Calcula el estado de local + Mi Drive + Drive del dueño usando únicamente
/// el calendario de la granja. Cambiar de anfitrión no altera este resultado.
class SharedSyncState {
  const SharedSyncState({
    required this.summary,
    required this.ownDriveRelation,
    required this.ownerDriveRelation,
    required this.uploadTargets,
    required this.downloadSources,
  });

  factory SharedSyncState.fromEntry(SharedSaveEntry entry) {
    final local = entry.localMatch;
    final own = entry.ownDriveStats;
    final owner = entry.driveStats;

    if (local == null) {
      final sources = <SharedCloudLocation>[
        if (own != null) SharedCloudLocation.ownDrive,
        if (entry.ownerDriveVerified && owner != null)
          SharedCloudLocation.ownerDrive,
      ];
      return SharedSyncState(
        summary: SharedSyncSummary.localMissing,
        ownDriveRelation: own == null
            ? SharedCopyRelation.missing
            : SharedCopyRelation.ahead,
        ownerDriveRelation: !entry.ownerDriveVerified
            ? SharedCopyRelation.unavailable
            : owner == null
            ? SharedCopyRelation.missing
            : SharedCopyRelation.ahead,
        uploadTargets: const [],
        downloadSources: sources,
      );
    }

    final ownRelation = _relation(local, own);
    final ownerRelation = entry.ownerDriveVerified
        ? _relation(local, owner)
        : SharedCopyRelation.unavailable;

    final uploads = <SharedCloudLocation>[
      if (_needsUpload(ownRelation)) SharedCloudLocation.ownDrive,
      if (entry.canSync && _needsUpload(ownerRelation))
        SharedCloudLocation.ownerDrive,
    ];
    final downloads = <SharedCloudLocation>[
      if (ownRelation == SharedCopyRelation.ahead) SharedCloudLocation.ownDrive,
      if (ownerRelation == SharedCopyRelation.ahead)
        SharedCloudLocation.ownerDrive,
    ];

    final SharedSyncSummary summary;
    if (downloads.length == 2) {
      summary = SharedSyncSummary.bothDrivesAhead;
    } else if (downloads.firstOrNull == SharedCloudLocation.ownDrive) {
      summary = SharedSyncSummary.ownDriveAhead;
    } else if (downloads.firstOrNull == SharedCloudLocation.ownerDrive) {
      summary = SharedSyncSummary.ownerDriveAhead;
    } else if (ownRelation == SharedCopyRelation.synced &&
        ownerRelation == SharedCopyRelation.synced) {
      summary = SharedSyncSummary.allSynced;
    } else if (ownRelation == SharedCopyRelation.synced) {
      summary = SharedSyncSummary.syncedWithOwnDrive;
    } else if (ownerRelation == SharedCopyRelation.synced) {
      summary = SharedSyncSummary.syncedWithOwnerDrive;
    } else if (ownerRelation == SharedCopyRelation.unavailable) {
      summary = SharedSyncSummary.ownerUnavailable;
    } else {
      summary = SharedSyncSummary.notInCloud;
    }

    return SharedSyncState(
      summary: summary,
      ownDriveRelation: ownRelation,
      ownerDriveRelation: ownerRelation,
      uploadTargets: uploads,
      downloadSources: downloads,
    );
  }

  final SharedSyncSummary summary;
  final SharedCopyRelation ownDriveRelation;
  final SharedCopyRelation ownerDriveRelation;
  final List<SharedCloudLocation> uploadTargets;
  final List<SharedCloudLocation> downloadSources;

  bool get needsUpload => uploadTargets.isNotEmpty;
  bool get needsDownload => downloadSources.isNotEmpty;

  static SharedCopyRelation _relation(SaveFile local, SaveFile? remote) {
    if (remote == null) return SharedCopyRelation.missing;
    final localDay = local.calendarDayOrdinal;
    final remoteDay = remote.calendarDayOrdinal;
    if (remoteDay == localDay) return SharedCopyRelation.synced;
    return remoteDay > localDay
        ? SharedCopyRelation.ahead
        : SharedCopyRelation.behind;
  }

  static bool _needsUpload(SharedCopyRelation relation) =>
      relation == SharedCopyRelation.missing ||
      relation == SharedCopyRelation.behind;
}

extension<T> on List<T> {
  T? get firstOrNull => isEmpty ? null : first;
}
