import 'save_entry.dart';
import 'save_file.dart';

/// Save coop ajeno al que se tiene acceso porque otra persona lo compartió
/// (permiso `reader`/`writer` en Drive), añadido una vez vía Picker (ver
/// research.md D11/D12). Vive en su propia sección "Compartidas conmigo" —
/// NO es un [SaveEntry] (ese sigue siendo exclusivamente local↔Drive propio).
class SharedSaveEntry {
  const SharedSaveEntry({
    required this.folderId,
    required this.folderName,
    required this.ownerEmail,
    required this.myRole,
    this.driveStats,
    this.localMatch,
    this.revoked = false,
    this.ownDriveStats,
    this.ownDriveFolderId,
  });

  final String folderId;
  final String folderName;
  final String ownerEmail;

  /// `'reader'` | `'writer'` — refrescado contra Drive en cada
  /// `listSharedSaves()`, nunca se confía en un valor persistido viejo.
  final String myRole;

  final SaveFile? driveStats;

  /// Copia local con el mismo `folderName`, si existe — la resuelve el
  /// caller (mismo patrón que empareja `SaveEntry` en `saves_screen.dart`).
  final SaveFile? localMatch;

  /// `true` si el dueño revocó el acceso (o borró/movió la carpeta) — la UI
  /// solo debe ofrecer "Quitar de la lista" en este estado.
  final bool revoked;

  /// Copia en el Drive PROPIO del receptor (no el del dueño), si el usuario
  /// ya la subió alguna vez — modelo de 3 sitios (2026-07-12): este
  /// dispositivo / tu Drive / Drive del dueño, cada par se compara por
  /// separado. `null` = nunca se ha subido a tu Drive.
  final SaveFile? ownDriveStats;
  final String? ownDriveFolderId;

  bool get canSync => myRole == 'writer' && !revoked;

  /// Reutiliza el MISMO cálculo de estado que las tarjetas propias
  /// (`SaveEntry.status`) para LOCAL vs Drive DEL DUEÑO — controla la
  /// franja de color superior de la tarjeta.
  SaveEntry get asEntry => SaveEntry(
        local: localMatch,
        drive: driveStats,
        driveFolderId: folderId,
      );

  /// Mismo cálculo pero LOCAL vs TU PROPIO Drive — comparación
  /// independiente, usada solo para decidir qué botones de sync mostrar.
  SaveEntry get asOwnEntry => SaveEntry(
        local: localMatch,
        drive: ownDriveStats,
        driveFolderId: ownDriveFolderId,
      );

  /// `null` si no hay copia local con la que comparar (no debería pasar
  /// donde se usa esto — esos botones solo se muestran con `localMatch`).
  SaveSyncStatus? get ownDriveSyncStatus =>
      localMatch == null ? null : asOwnEntry.status;

  SharedSaveEntry copyWith({
    String? myRole,
    SaveFile? driveStats,
    SaveFile? localMatch,
    bool? revoked,
    SaveFile? ownDriveStats,
    String? ownDriveFolderId,
  }) {
    return SharedSaveEntry(
      folderId: folderId,
      folderName: folderName,
      ownerEmail: ownerEmail,
      myRole: myRole ?? this.myRole,
      driveStats: driveStats ?? this.driveStats,
      localMatch: localMatch ?? this.localMatch,
      revoked: revoked ?? this.revoked,
      ownDriveStats: ownDriveStats ?? this.ownDriveStats,
      ownDriveFolderId: ownDriveFolderId ?? this.ownDriveFolderId,
    );
  }
}
