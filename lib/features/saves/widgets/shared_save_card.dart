import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/models/player_stats.dart';
import '../../../core/models/save_file.dart';
import '../../../core/models/shared_save_entry.dart';
import '../../../core/models/shared_sync_state.dart';
import '../../../core/services/season_controller.dart';
import '../../../generated/app_localizations.dart';
import '../../../shared/widgets/save_busy_indicator.dart';
import '../../../shared/widgets/pressable_scale.dart';
import '../save_card.dart';
import 'save_detail_sheet.dart';

const _kSyncAccent = Color(0xFFE0B850);
const _kReadAccent = Color(0xFFC8C4B8);
const _kBlue = Color(0xFF5AA8E0);
const _kLocalOnly = Color(0xFFE8783A);
// Mismo verde que `_kSynced` (privado) en save_card.dart — misma semántica
// de "coinciden" en toda la app.
const _kSyncedGreen = Color(0xFF62B074);
// Verde menta — identidad de "Drive del dueño" (nunca el tuyo): caja,
// hoja de detalle, texto de estado y botones que actúan sobre ESE Drive
// comparten este color. Se diferencia de `_kSyncedGreen`: este identifica
// el origen compartido; aquel confirma que dos copias coinciden.
const _kOwnerAccent = Color(0xFF42D392);

/// Tarjeta de "Compartidas conmigo" — MISMO `SaveCard` que "Mis partidas"
/// (cabecera, chips, selector de jugador, stats completos), solo cambia la
/// franja inferior: quién la compartió, el rol, y las acciones propias de un
/// save ajeno (descargar / sincronizar / quitar de la lista — NUNCA borrar).
/// Ver mockup aprobado 2026-07-11 (contracts/shared_saves_picker.md).
class SharedSaveCard extends StatelessWidget {
  const SharedSaveCard({
    super.key,
    required this.entry,
    this.busy = false,
    this.onDownload,
    this.onSync,
    this.onDownloadRequested,
    this.onSyncRequested,
    this.onRemove,
    this.onMakeHost,
    this.onUploadToOwnDrive,
    this.onDownloadFromOwnDrive,
    this.onSyncBoth,
    this.onExport,
    this.onBackups,
    this.backupCount = 0,
    this.onDeleteLocal,
    this.onDeleteFromOwnDrive,
    this.onManageCopies,
  });

  final SharedSaveEntry entry;
  final bool busy;
  final VoidCallback? onDownload;
  final VoidCallback? onSync;
  final VoidCallback? onDownloadRequested;
  final VoidCallback? onSyncRequested;
  final VoidCallback? onRemove;

  /// Cambio de anfitrión sobre la copia LOCAL ya descargada (F3) — siempre
  /// disponible mientras exista, independientemente del rol/revocación
  /// (decisión 2026-07-12: nunca capar esta acción en un save compartido).
  final void Function(PlayerStats target)? onMakeHost;

  /// Modelo de 3 sitios (2026-07-12): compara LOCAL contra TU PROPIO Drive
  /// (nunca el del dueño) — disponible siempre que haga falta subir algo,
  /// activo o revocado por igual.
  final VoidCallback? onUploadToOwnDrive;

  /// Caso inverso: tu Drive tiene una versión más avanzada que la local
  /// (jugaste en otro equipo y subiste desde ahí) — bajarla aquí. Solo
  /// tiene sentido dentro de la hoja "Mi Drive" (`_openOwnDetail`).
  final VoidCallback? onDownloadFromOwnDrive;

  /// Sube a tu Drive Y sincroniza con el dueño en una sola acción — solo
  /// tiene sentido cuando ambas hacen falta a la vez (ver `_SharedFooter`).
  final VoidCallback? onSyncBoth;

  /// Exportar (F1) y Backups (spec 007) operan sobre la copia LOCAL —
  /// tienen sentido independientemente de con qué Drive se compare, así
  /// que se ofrecen en la hoja de detalle igual que en "Mis partidas".
  /// Deliberadamente NO hay `onShare` aquí: compartir un save que no es
  /// tuyo no tiene sentido (regla no negociable — nunca acciones de dueño
  /// sobre datos ajenos).
  final VoidCallback? onExport;
  final VoidCallback? onBackups;
  final int backupCount;

  /// Acciones separadas para que cada cara borre solo su propia ubicación.
  /// NUNCA apuntan al Drive del dueño.
  final VoidCallback? onDeleteLocal;
  final VoidCallback? onDeleteFromOwnDrive;
  final VoidCallback? onManageCopies;

  @override
  Widget build(BuildContext context) {
    return SaveCard(
      entry: entry.asEntry,
      busy: busy,
      footerBuilder: (context, selectedPlayerId, onPlayerIdChanged) =>
          _SharedFooter(
            entry: entry,
            busy: busy,
            selectedPlayerId: selectedPlayerId,
            onPlayerIdChanged: onPlayerIdChanged,
            onDownload: onDownload,
            onSync: onSync,
            onDownloadRequested: onDownloadRequested,
            onSyncRequested: onSyncRequested,
            onRemove: onRemove,
            onMakeHost: onMakeHost,
            onExport: onExport,
            onBackups: onBackups,
            backupCount: backupCount,
            onUploadToOwnDrive: onUploadToOwnDrive,
            onDownloadFromOwnDrive: onDownloadFromOwnDrive,
            onSyncBoth: onSyncBoth,
            onDeleteLocal: onDeleteLocal,
            onDeleteFromOwnDrive: onDeleteFromOwnDrive,
            onManageCopies: onManageCopies,
          ),
    );
  }
}

class _SharedFooter extends StatelessWidget {
  const _SharedFooter({
    required this.entry,
    required this.busy,
    required this.selectedPlayerId,
    required this.onPlayerIdChanged,
    this.onDownload,
    this.onSync,
    this.onDownloadRequested,
    this.onSyncRequested,
    this.onRemove,
    this.onMakeHost,
    this.onUploadToOwnDrive,
    this.onDownloadFromOwnDrive,
    this.onSyncBoth,
    this.onExport,
    this.onBackups,
    this.backupCount = 0,
    this.onDeleteLocal,
    this.onDeleteFromOwnDrive,
    this.onManageCopies,
  });

  final SharedSaveEntry entry;
  final bool busy;
  final String? selectedPlayerId;
  final ValueChanged<String> onPlayerIdChanged;
  final VoidCallback? onDownload;
  final VoidCallback? onSync;
  final VoidCallback? onDownloadRequested;
  final VoidCallback? onSyncRequested;
  final VoidCallback? onRemove;
  final void Function(PlayerStats target)? onMakeHost;
  final VoidCallback? onUploadToOwnDrive;
  final VoidCallback? onDownloadFromOwnDrive;
  final VoidCallback? onSyncBoth;
  final VoidCallback? onExport;
  final VoidCallback? onBackups;
  final int backupCount;
  final VoidCallback? onDeleteLocal;
  final VoidCallback? onDeleteFromOwnDrive;
  final VoidCallback? onManageCopies;

  /// Única hoja para los tres sitios. El orden siempre es local → Mi Drive →
  /// Drive del dueño, independientemente de la caja desde la que se abra.
  void _openDetail(
    BuildContext context, {
    required SaveDetailLocation initialLocation,
  }) {
    final l10n = AppLocalizations.of(context)!;
    final syncState = SharedSyncState.fromEntry(entry);
    final ownerNeedsUpload = syncState.uploadTargets.contains(
      SharedCloudLocation.ownerDrive,
    );
    final ownNeedsUpload = syncState.uploadTargets.contains(
      SharedCloudLocation.ownDrive,
    );
    final ownerNeedsDownload = syncState.downloadSources.contains(
      SharedCloudLocation.ownerDrive,
    );
    final ownNeedsDownload = syncState.downloadSources.contains(
      SharedCloudLocation.ownDrive,
    );

    var localActionLabel = l10n.sharedWithMeUploadOwn;
    VoidCallback? localAction;
    if (ownerNeedsUpload && ownNeedsUpload && onSyncBoth != null) {
      localActionLabel = l10n.sharedSyncBoth;
      localAction = onSyncBoth;
    } else if (ownerNeedsUpload && onSync != null) {
      localActionLabel = l10n.sharedWithMeSync;
      localAction = onSync;
    } else if (ownNeedsUpload && onUploadToOwnDrive != null) {
      localActionLabel = l10n.sharedWithMeUploadOwn;
      localAction = onUploadToOwnDrive;
    }

    showSaveDetail(
      context,
      entry: entry.asOwnEntry,
      startOnLocal: initialLocation == SaveDetailLocation.local,
      initialLocation: initialLocation,
      onUpload: localAction,
      localActionLabel: localActionLabel,
      onDownload: ownNeedsDownload ? onDownloadFromOwnDrive : null,
      onMakeHost: onMakeHost,
      onExport: onExport,
      onBackups: onBackups,
      backupCount: backupCount,
      backupsOnRemote: true,
      onDeleteLocal: onDeleteLocal,
      onDeleteFromDrive: onDeleteFromOwnDrive,
      driveTitle: l10n.sharedSideMyDrive,
      extraDrive: entry.ownerDriveVerified ? entry.driveStats : null,
      extraDriveTitle: l10n.sharedSideOwnerDrive(entry.ownerEmail),
      extraDriveColor: _kOwnerAccent,
      onExtraDownload: ownerNeedsDownload ? onDownload : null,
      onRemove: onRemove,
      removeLabel: l10n.sharedWithMeRemove,
      initialPlayerId: selectedPlayerId,
      onPlayerIdChanged: onPlayerIdChanged,
    );
  }

  ({Color color, String text}) _statusSpec(
    AppLocalizations l10n,
    SharedSyncState state,
  ) => switch (state.summary) {
    SharedSyncSummary.allSynced => (
      color: _kSyncedGreen,
      text: l10n.sharedStatusFullySynced,
    ),
    SharedSyncSummary.syncedWithOwnDrive => (
      color: kDrive,
      text: l10n.sharedStatusSyncedOwn,
    ),
    SharedSyncSummary.syncedWithOwnerDrive => (
      color: _kSyncAccent,
      text: l10n.sharedStatusSyncedOwner,
    ),
    SharedSyncSummary.ownDriveAhead => (
      color: kDrive,
      text: l10n.sharedStatusOwnDriveAhead,
    ),
    SharedSyncSummary.ownerDriveAhead => (
      color: _kOwnerAccent,
      text: l10n.sharedStatusOwnerAhead(entry.ownerEmail),
    ),
    SharedSyncSummary.bothDrivesAhead => (
      color: _kBlue,
      text: l10n.sharedStatusBothAhead,
    ),
    SharedSyncSummary.localMissing => (
      color: _kBlue,
      text: l10n.sharedStatusLocalMissing,
    ),
    SharedSyncSummary.ownerUnavailable => (
      color: _kReadAccent,
      text: l10n.sharedStatusOwnerUnavailable(entry.ownerEmail),
    ),
    SharedSyncSummary.notInCloud => (
      color: _kLocalOnly,
      text: l10n.sharedStatusNotCloud,
    ),
  };

  Widget _animatedState(
    BuildContext context, {
    required Widget child,
    required Object stateKey,
  }) {
    final reduceMotion =
        MediaQuery.maybeOf(context)?.disableAnimations ?? false;
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 200),
      switchInCurve: const Cubic(0.77, 0, 0.175, 1),
      switchOutCurve: const Cubic(0.23, 1, 0.32, 1),
      transitionBuilder: (transitionChild, animation) => FadeTransition(
        opacity: animation,
        child: Transform.translate(
          offset: Offset(reduceMotion ? 0 : (1 - animation.value) * 6, 0),
          child: transitionChild,
        ),
      ),
      child: KeyedSubtree(key: ValueKey(stateKey), child: child),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final state = SharedSyncState.fromEntry(entry);
    // Mismo color que el icono estacional de al lado (pétalo rosa en
    // primavera, hoja naranja en otoño…) — antes era un dorado fijo que no
    // combinaba (2026-07-15, auditoría de consistencia visual).
    final status = busy
        ? (
            color: seasonBusyColor(SeasonController.instance.season.value),
            text: l10n.sharedStatusWorking,
          )
        : _statusSpec(l10n, state);
    final showDownload =
        !busy && state.needsDownload && onDownloadRequested != null;
    final showSync =
        !busy &&
        !state.needsDownload &&
        state.needsUpload &&
        onSyncRequested != null;

    return Container(
      padding: const EdgeInsets.fromLTRB(14, 10, 14, 12),
      decoration: BoxDecoration(color: _kSyncAccent.withValues(alpha: 0.04)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  l10n.sharedWithMeOwnedBy(entry.ownerEmail),
                  style: GoogleFonts.firaCode(
                    fontSize: 10.5,
                    color: Colors.white.withValues(alpha: 0.55),
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(width: 6),
              _RoleBadge(
                sync: entry.canSync,
                label: entry.canSync
                    ? l10n.sharedWithMeRoleSync
                    : l10n.sharedWithMeRoleRead,
              ),
            ],
          ),
          const SizedBox(height: 10),
          _ThreeSitesRow(
            entry: entry,
            onTapLocal: entry.localMatch == null
                ? null
                : () => _openDetail(
                    context,
                    initialLocation: SaveDetailLocation.local,
                  ),
            onTapOwnDrive: entry.ownDriveStats == null
                ? null
                : () => _openDetail(
                    context,
                    initialLocation: SaveDetailLocation.drive,
                  ),
            onTapOwnerDrive:
                !entry.ownerDriveVerified || entry.driveStats == null
                ? null
                : () => _openDetail(
                    context,
                    initialLocation: SaveDetailLocation.extraDrive,
                  ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: _animatedState(
                  context,
                  stateKey: '${state.summary.name}-$busy',
                  child: Row(
                    children: [
                      if (busy) ...[
                        SaveBusyIndicator(
                          key: const ValueKey('shared-save-busy-indicator'),
                          season: SeasonController.instance.season.value,
                          size: 16,
                        ),
                        const SizedBox(width: 7),
                      ] else ...[
                        Container(
                          width: 6,
                          height: 6,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: status.color,
                          ),
                        ),
                        const SizedBox(width: 7),
                      ],
                      Expanded(
                        child: Text(
                          status.text,
                          style: GoogleFonts.firaCode(
                            fontSize: 10.5,
                            color: status.color,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              if (showDownload) ...[
                const SizedBox(width: 8),
                _animatedState(
                  context,
                  stateKey: 'download-${state.summary.name}',
                  child: _FooterAction(
                    label: l10n.sharedWithMeDownload,
                    icon: Icons.cloud_download_outlined,
                    color: _kBlue,
                    onTap: onDownloadRequested,
                  ),
                ),
              ] else if (showSync) ...[
                const SizedBox(width: 8),
                _animatedState(
                  context,
                  stateKey: 'sync-${state.summary.name}',
                  child: _FooterAction(
                    label: l10n.sharedWithMeSync,
                    icon: Icons.sync_rounded,
                    color: _kSyncAccent,
                    onTap: onSyncRequested,
                  ),
                ),
              ],
              if (!busy && (onRemove != null || onManageCopies != null)) ...[
                const SizedBox(width: 8),
                _ManagementActions(
                  disconnectLabel: l10n.sharedWithMeRemove,
                  manageLabel: l10n.deleteDataTitle,
                  onDisconnect: onRemove,
                  onManageCopies: onManageCopies,
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }
}

/// Fila de 3 cajas: este dispositivo / tu Drive / Drive del dueño. Caja
/// punteada + "No está aquí" cuando ese sitio no tiene copia todavía.
/// Cada caja es TOCABLE y abre la hoja de detalle sobre su cara.
class _ThreeSitesRow extends StatelessWidget {
  const _ThreeSitesRow({
    required this.entry,
    this.onTapLocal,
    this.onTapOwnDrive,
    this.onTapOwnerDrive,
  });
  final SharedSaveEntry entry;
  final VoidCallback? onTapLocal;
  final VoidCallback? onTapOwnDrive;
  final VoidCallback? onTapOwnerDrive;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Row(
      children: [
        Expanded(
          child: _SiteBox(
            label: l10n.cardLocalPresence,
            emoji: '💻',
            save: entry.localMatch,
            color: kLocal,
            onTap: entry.localMatch != null ? onTapLocal : null,
          ),
        ),
        const SizedBox(width: 6),
        Expanded(
          child: _SiteBox(
            label: l10n.sharedSideMyDrive,
            emoji: '☁',
            save: entry.ownDriveStats,
            color: kDrive,
            onTap: entry.ownDriveStats != null ? onTapOwnDrive : null,
          ),
        ),
        const SizedBox(width: 6),
        Expanded(
          child: _SiteBox(
            label: l10n.sharedSideOwnerDrive(entry.ownerEmail),
            emoji: '🔗',
            save: entry.driveStats,
            color: _kOwnerAccent,
            unavailable: !entry.ownerDriveVerified,
            onTap: entry.ownerDriveVerified && entry.driveStats != null
                ? onTapOwnerDrive
                : null,
          ),
        ),
      ],
    );
  }
}

/// Caja de un sitio (dispositivo/Drive). Mismo formato que las cajas
/// "EN ESTE DISPOSITIVO"/"EN DRIVE" de un save propio (emoji + fecha +
/// versión) — sin la hora relativa, para caber en 3 columnas.
class _SiteBox extends StatelessWidget {
  const _SiteBox({
    required this.label,
    required this.emoji,
    required this.save,
    required this.color,
    this.unavailable = false,
    this.onTap,
  });
  final String label;
  final String emoji;
  final SaveFile? save;
  final Color color;
  final bool unavailable;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final present = save != null;
    final identifiable = present || unavailable;
    final box = Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 7),
      decoration: BoxDecoration(
        border: Border.all(
          color: identifiable
              ? color.withValues(alpha: 0.4)
              : Colors.white.withValues(alpha: 0.12),
          style: identifiable ? BorderStyle.solid : BorderStyle.none,
        ),
        borderRadius: BorderRadius.circular(9),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(emoji, style: const TextStyle(fontSize: 9)),
              const SizedBox(width: 3),
              Expanded(
                child: Text(
                  label.toUpperCase(),
                  style: GoogleFonts.firaCode(
                    fontSize: 7.5,
                    letterSpacing: 0.3,
                    color: identifiable
                        ? color.withValues(alpha: 0.85)
                        : Colors.white.withValues(alpha: 0.3),
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: 3),
          Text(
            unavailable
                ? l10n.sharedSideUnavailable
                : present
                ? l10n.sharedSideDate(save!.dayOfMonth, save!.year)
                : l10n.cardNotPresent,
            style: GoogleFonts.firaCode(
              fontSize: 10,
              color: identifiable
                  ? Colors.white.withValues(alpha: 0.9)
                  : Colors.white.withValues(alpha: 0.3),
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          if (present && save!.gameVersion.isNotEmpty) ...[
            const SizedBox(height: 2),
            Text(
              'v${save!.gameVersion}',
              style: GoogleFonts.firaCode(
                fontSize: 8.5,
                color: Colors.white.withValues(alpha: 0.35),
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ],
      ),
    );
    if (onTap == null) return box;
    return PressableScale(onTap: onTap, child: box);
  }
}

class _RoleBadge extends StatelessWidget {
  const _RoleBadge({required this.sync, required this.label});
  final bool sync;
  final String label;

  @override
  Widget build(BuildContext context) {
    final color = sync ? _kSyncAccent : _kReadAccent;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
      decoration: BoxDecoration(
        color: color.withValues(alpha: sync ? 0.14 : 0.06),
        border: Border.all(color: color.withValues(alpha: sync ? 0.4 : 0.16)),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            sync ? Icons.sync_rounded : Icons.visibility_outlined,
            size: 10,
            color: color,
          ),
          const SizedBox(width: 3),
          Text(
            label.toUpperCase(),
            style: GoogleFonts.firaCode(
              fontSize: 8,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.4,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}

class _FooterAction extends StatefulWidget {
  const _FooterAction({
    required this.label,
    required this.icon,
    required this.color,
    this.onTap,
  });
  final String label;
  final IconData icon;
  final Color color;
  final VoidCallback? onTap;

  @override
  State<_FooterAction> createState() => _FooterActionState();
}

class _FooterActionState extends State<_FooterAction> {
  bool _pressed = false;
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final enabled = widget.onTap != null;
    return MouseRegion(
      cursor: enabled ? SystemMouseCursors.click : MouseCursor.defer,
      onEnter: enabled ? (_) => setState(() => _hovered = true) : null,
      onExit: enabled ? (_) => setState(() => _hovered = false) : null,
      child: GestureDetector(
      onTap: enabled ? widget.onTap : null,
      onTapDown: enabled ? (_) => setState(() => _pressed = true) : null,
      onTapUp: (_) => setState(() => _pressed = false),
      onTapCancel: () => setState(() => _pressed = false),
      child: AnimatedScale(
        scale: _pressed ? 0.96 : 1.0,
        duration: const Duration(milliseconds: 140),
        curve: const Cubic(0.23, 1, 0.32, 1),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 140),
          curve: Curves.easeOut,
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 9),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: widget.color.withValues(alpha: _hovered ? 0.24 : 0.16),
            border: Border.all(
              color: widget.color.withValues(alpha: _hovered ? 0.75 : 0.5),
            ),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(widget.icon, size: 14, color: widget.color),
              const SizedBox(width: 5),
              Text(
                widget.label,
                style: GoogleFonts.firaCode(
                  fontSize: 11.5,
                  fontWeight: FontWeight.w600,
                  color: widget.color,
                ),
              ),
            ],
          ),
        ),
      ),
      ),
    );
  }
}

class _ManagementActions extends StatelessWidget {
  const _ManagementActions({
    required this.disconnectLabel,
    required this.manageLabel,
    this.onDisconnect,
    this.onManageCopies,
  });

  final String disconnectLabel;
  final String manageLabel;
  final VoidCallback? onDisconnect;
  final VoidCallback? onManageCopies;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerRight,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Tooltip(
            message: disconnectLabel,
            child: SizedBox(
              width: 42,
              height: 36,
              child: ActionBtn(
                key: const ValueKey('shared-disconnect-action'),
                label: '',
                icon: Icons.sync_disabled_rounded,
                iconSize: 15,
                color: const Color(0xFFE8783A),
                filled: true,
                iconOnly: true,
                onTap: onDisconnect,
              ),
            ),
          ),
          if (onManageCopies != null) ...[
            const SizedBox(width: 8),
            Tooltip(
              message: manageLabel,
              child: SizedBox(
                width: 42,
                height: 36,
                child: ActionBtn(
                  key: const ValueKey('shared-manage-copies-action'),
                  label: '',
                  icon: Icons.delete_outline_rounded,
                  color: const Color(0xFFE05252),
                  filled: true,
                  iconOnly: true,
                  onTap: onManageCopies,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
