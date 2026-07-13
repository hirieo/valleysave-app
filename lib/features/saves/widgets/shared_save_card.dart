import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/models/player_stats.dart';
import '../../../core/models/save_entry.dart';
import '../../../core/models/save_file.dart';
import '../../../core/models/shared_save_entry.dart';
import '../../../generated/app_localizations.dart';
import '../save_card.dart';
import 'save_detail_sheet.dart';

const _kSyncAccent = Color(0xFFE0B850);
const _kReadAccent = Color(0xFFC8C4B8);
const _kDanger = Color(0xFFE05252);
const _kBlue = Color(0xFF5AA8E0);
// Mismo verde que `_kSynced` (privado) en save_card.dart — misma semántica
// de "coinciden" en toda la app.
const _kSyncedGreen = Color(0xFF62B074);

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
    this.onRemove,
    this.onMakeHost,
    this.onUploadToOwnDrive,
    this.onSyncBoth,
    this.onExport,
    this.onBackups,
    this.backupCount = 0,
  });

  final SharedSaveEntry entry;
  final bool busy;
  final VoidCallback? onDownload;
  final VoidCallback? onSync;
  final VoidCallback? onRemove;

  /// Cambio de anfitrión sobre la copia LOCAL ya descargada (F3) — siempre
  /// disponible mientras exista, independientemente del rol/revocación
  /// (decisión 2026-07-12: nunca capar esta acción en un save compartido).
  final void Function(PlayerStats target)? onMakeHost;

  /// Modelo de 3 sitios (2026-07-12): compara LOCAL contra TU PROPIO Drive
  /// (nunca el del dueño) — disponible siempre que haga falta subir algo,
  /// activo o revocado por igual.
  final VoidCallback? onUploadToOwnDrive;

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

  @override
  Widget build(BuildContext context) {
    return SaveCard(
      entry: entry.asEntry,
      busy: busy,
      footer: _SharedFooter(
        entry: entry,
        onDownload: onDownload,
        onSync: onSync,
        onRemove: onRemove,
        onMakeHost: onMakeHost,
        onExport: onExport,
        onBackups: onBackups,
        backupCount: backupCount,
        onUploadToOwnDrive: onUploadToOwnDrive,
        onSyncBoth: onSyncBoth,
      ),
    );
  }
}

class _SharedFooter extends StatelessWidget {
  const _SharedFooter({
    required this.entry,
    this.onDownload,
    this.onSync,
    this.onRemove,
    this.onMakeHost,
    this.onUploadToOwnDrive,
    this.onSyncBoth,
    this.onExport,
    this.onBackups,
    this.backupCount = 0,
  });

  final SharedSaveEntry entry;
  final VoidCallback? onDownload;
  final VoidCallback? onSync;
  final VoidCallback? onRemove;
  final void Function(PlayerStats target)? onMakeHost;
  final VoidCallback? onUploadToOwnDrive;
  final VoidCallback? onSyncBoth;
  final VoidCallback? onExport;
  final VoidCallback? onBackups;
  final int backupCount;

  /// Hoja de detalle de SIEMPRE (stats por cara, swipe, HACER ANFITRIÓN con
  /// su lógica de anfitrión-visible, comparativas, Exportar, Backups) sobre
  /// el par local ↔ Drive del dueño. "Subir" de la cara local = sincronizar
  /// con el dueño. Deliberadamente sin `onShare` (ver doc de `SharedSaveCard`).
  void _openDetail(BuildContext context, {required bool startOnLocal}) {
    showSaveDetail(
      context,
      entry: entry.asEntry,
      startOnLocal: startOnLocal,
      onUpload: onSync,
      onDownload: onDownload,
      onMakeHost: onMakeHost,
      onExport: onExport,
      onBackups: onBackups,
      backupCount: backupCount,
    );
  }

  /// Misma hoja sobre el par local ↔ MI Drive. "Subir" = subir a mi Drive.
  void _openOwnDetail(BuildContext context) {
    showSaveDetail(
      context,
      entry: entry.asOwnEntry,
      startOnLocal: entry.ownDriveStats == null,
      onUpload: onUploadToOwnDrive,
      onMakeHost: onMakeHost,
      onExport: onExport,
      onBackups: onBackups,
      backupCount: backupCount,
    );
  }

  /// Estado combinado de los 3 sitios (local siempre existe aquí — solo se
  /// llama cuando `entry.localMatch != null`). Reutiliza los MISMOS colores
  /// que la franja de estado propia (`kLocal`/`kDrive`/verde sincronizado)
  /// para no inventar un vocabulario de color nuevo.
  ({Color color, String text}) _combinedStatus(AppLocalizations l10n) {
    final ownerStatus = entry.asEntry.status;
    final ownStatus = entry.ownDriveSyncStatus;
    final hasOwnDrive = entry.ownDriveStats != null;

    if (!hasOwnDrive) {
      return switch (ownerStatus) {
        SaveSyncStatus.synced => (
            color: _kSyncedGreen,
            text: l10n.sharedStatusSyncedNoOwnDrive
          ),
        SaveSyncStatus.localAhead => (
            color: kLocal,
            text: l10n.sharedStatusAheadNoOwnDrive
          ),
        _ => (
            color: kDrive,
            text: l10n.sharedStatusOwnerAheadNoOwnDrive(entry.ownerEmail)
          ),
      };
    }

    if (ownerStatus == SaveSyncStatus.synced && ownStatus == SaveSyncStatus.synced) {
      return (color: _kSyncedGreen, text: l10n.sharedStatusAllSynced);
    }
    if (ownerStatus == SaveSyncStatus.localAhead && ownStatus == SaveSyncStatus.localAhead) {
      return (color: kLocal, text: l10n.sharedStatusAheadBoth);
    }
    return (color: _kReadAccent, text: l10n.sharedStatusMixed);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    final canMakeHost = Platform.isWindows &&
        onMakeHost != null &&
        entry.localMatch?.hasMultiplePlayers == true;

    if (entry.revoked) {
      return Container(
        padding: const EdgeInsets.fromLTRB(14, 10, 14, 12),
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
                        color: Colors.white.withValues(alpha: 0.35)),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Text(
                  l10n.sharedWithMeRevoked,
                  style: GoogleFonts.firaCode(
                      fontSize: 10, color: _kDanger.withValues(alpha: 0.85)),
                ),
              ],
            ),
            if (onUploadToOwnDrive != null || canMakeHost) ...[
              const SizedBox(height: 8),
              Row(
                children: [
                  if (onUploadToOwnDrive != null)
                    Expanded(
                      child: _FooterAction(
                        label: l10n.sharedWithMeUploadOwn,
                        icon: Icons.cloud_upload_outlined,
                        color: _kBlue,
                        onTap: onUploadToOwnDrive,
                      ),
                    ),
                  if (onUploadToOwnDrive != null && canMakeHost)
                    const SizedBox(width: 8),
                  if (canMakeHost)
                    Expanded(
                      child: _FooterAction(
                        label: l10n.makeHostAction,
                        icon: Icons.workspace_premium_rounded,
                        color: const Color(0xFFF0C040),
                        // Revocado: el Drive del dueño ya no existe para
                        // nosotros — la hoja abre sobre local ↔ mi Drive.
                        onTap: () => _openOwnDetail(context),
                      ),
                    ),
                ],
              ),
            ],
            const SizedBox(height: 8),
            _RemoveLink(label: l10n.sharedWithMeRemove, onTap: onRemove),
          ],
        ),
      );
    }

    final canSync = entry.canSync;
    final hasLocal = entry.localMatch != null;

    // Sin copia local todavía: nada que comparar, comportamiento simple de
    // siempre (Descargar + Sincronizar si el rol lo permite).
    if (!hasLocal) {
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
                        fontSize: 10.5, color: Colors.white.withValues(alpha: 0.55)),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const SizedBox(width: 6),
                _RoleBadge(sync: canSync, label: canSync ? l10n.sharedWithMeRoleSync : l10n.sharedWithMeRoleRead),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: _FooterAction(
                    label: l10n.sharedWithMeDownload,
                    icon: Icons.cloud_download_outlined,
                    color: _kBlue,
                    onTap: onDownload,
                  ),
                ),
                if (onSync != null) ...[
                  const SizedBox(width: 8),
                  Expanded(
                    child: _FooterAction(
                      label: l10n.sharedWithMeSync,
                      icon: Icons.sync_rounded,
                      color: _kSyncAccent,
                      onTap: onSync,
                    ),
                  ),
                ],
              ],
            ),
            const SizedBox(height: 6),
            _RemoveLink(label: l10n.sharedWithMeRemove, onTap: onRemove),
          ],
        ),
      );
    }

    // Modelo de 3 sitios: local ya existe, se compara contra tu Drive Y el
    // del dueño por separado (decisión 2026-07-12).
    final ownerStatus = entry.asEntry.status;
    final ownStatus = entry.ownDriveSyncStatus;
    final status = _combinedStatus(l10n);

    final showDownload =
        onDownload != null && ownerStatus == SaveSyncStatus.driveAhead;
    final showSyncOwner =
        onSync != null && ownerStatus == SaveSyncStatus.localAhead;
    final showUploadOwn = onUploadToOwnDrive != null &&
        (ownStatus == SaveSyncStatus.localOnly ||
            ownStatus == SaveSyncStatus.localAhead);
    final showSyncBoth = onSyncBoth != null && showUploadOwn && showSyncOwner;
    final anyAction = showDownload || showSyncOwner || showUploadOwn;

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
                      fontSize: 10.5, color: Colors.white.withValues(alpha: 0.55)),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(width: 6),
              _RoleBadge(sync: canSync, label: canSync ? l10n.sharedWithMeRoleSync : l10n.sharedWithMeRoleRead),
            ],
          ),
          const SizedBox(height: 10),
          // Cada caja abre la hoja de detalle de SIEMPRE sobre esa cara
          // (stats completos, comparativa por swipe, HACER ANFITRIÓN con su
          // gating de anfitrión, etc.) — misma interacción que la tarjeta
          // de "Mis partidas".
          _ThreeSitesRow(
            entry: entry,
            onTapLocal: () => _openDetail(context, startOnLocal: true),
            onTapOwnDrive: () => _openOwnDetail(context),
            onTapOwnerDrive: () => _openDetail(context, startOnLocal: false),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Container(
                width: 6,
                height: 6,
                decoration: BoxDecoration(shape: BoxShape.circle, color: status.color),
              ),
              const SizedBox(width: 7),
              Expanded(
                child: Text(
                  status.text,
                  style: GoogleFonts.firaCode(fontSize: 10.5, color: status.color),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          if (anyAction) ...[
            const SizedBox(height: 8),
            Row(
              children: [
                if (showDownload)
                  Expanded(
                    child: _FooterAction(
                      label: l10n.sharedWithMeDownload,
                      icon: Icons.cloud_download_outlined,
                      color: kDrive,
                      onTap: onDownload,
                    ),
                  ),
                if (showDownload && (showSyncOwner || showUploadOwn))
                  const SizedBox(width: 8),
                if (showSyncOwner)
                  Expanded(
                    child: _FooterAction(
                      label: l10n.sharedWithMeSync,
                      icon: Icons.sync_rounded,
                      color: _kSyncAccent,
                      onTap: onSync,
                    ),
                  ),
                if (showSyncOwner && showUploadOwn) const SizedBox(width: 8),
                if (showUploadOwn)
                  Expanded(
                    child: _FooterAction(
                      label: l10n.sharedWithMeUploadOwn,
                      icon: Icons.cloud_upload_outlined,
                      color: kLocal,
                      onTap: onUploadToOwnDrive,
                    ),
                  ),
              ],
            ),
            if (showSyncBoth) ...[
              const SizedBox(height: 6),
              _FooterAction(
                label: l10n.sharedSyncBoth,
                icon: Icons.publish_rounded,
                color: _kSyncedGreen,
                onTap: onSyncBoth,
              ),
            ],
          ],
          const SizedBox(height: 6),
          _RemoveLink(label: l10n.sharedWithMeRemove, onTap: onRemove),
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
            save: entry.localMatch,
            color: Colors.white.withValues(alpha: 0.5),
            onTap: entry.localMatch != null ? onTapLocal : null,
          ),
        ),
        const SizedBox(width: 6),
        Expanded(
          child: _SiteBox(
            label: l10n.sharedSideMyDrive,
            save: entry.ownDriveStats,
            color: kLocal,
            onTap: entry.ownDriveStats != null ? onTapOwnDrive : null,
          ),
        ),
        const SizedBox(width: 6),
        Expanded(
          child: _SiteBox(
            label: l10n.sharedSideOwnerDrive(entry.ownerEmail),
            save: entry.driveStats,
            color: kDrive,
            onTap: entry.driveStats != null ? onTapOwnerDrive : null,
          ),
        ),
      ],
    );
  }
}

class _SiteBox extends StatelessWidget {
  const _SiteBox({
    required this.label,
    required this.save,
    required this.color,
    this.onTap,
  });
  final String label;
  final SaveFile? save;
  final Color color;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final present = save != null;
    final box = Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 7),
      decoration: BoxDecoration(
        border: Border.all(
          color: present ? color.withValues(alpha: 0.4) : Colors.white.withValues(alpha: 0.12),
          style: present ? BorderStyle.solid : BorderStyle.none,
        ),
        borderRadius: BorderRadius.circular(9),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label.toUpperCase(),
            style: GoogleFonts.firaCode(
              fontSize: 7.5,
              letterSpacing: 0.3,
              color: present ? color.withValues(alpha: 0.85) : Colors.white.withValues(alpha: 0.3),
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 3),
          Text(
            present
                ? l10n.sharedSideDate(save!.dayOfMonth, save!.year)
                : l10n.cardNotPresent,
            style: GoogleFonts.firaCode(
              fontSize: 10,
              color: present ? Colors.white.withValues(alpha: 0.9) : Colors.white.withValues(alpha: 0.3),
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
    if (onTap == null) return box;
    return GestureDetector(onTap: onTap, child: box);
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
          Icon(sync ? Icons.sync_rounded : Icons.visibility_outlined,
              size: 10, color: color),
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

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      onTapDown: widget.onTap != null ? (_) => setState(() => _pressed = true) : null,
      onTapUp: (_) => setState(() => _pressed = false),
      onTapCancel: () => setState(() => _pressed = false),
      child: AnimatedScale(
        scale: _pressed ? 0.96 : 1.0,
        duration: const Duration(milliseconds: 140),
        curve: const Cubic(0.23, 1, 0.32, 1),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 9),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: widget.color.withValues(alpha: 0.16),
            border: Border.all(color: widget.color.withValues(alpha: 0.5)),
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
    );
  }
}

class _RemoveLink extends StatelessWidget {
  const _RemoveLink({required this.label, this.onTap});
  final String label;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Text(
        label,
        textAlign: TextAlign.right,
        style: GoogleFonts.firaCode(
          fontSize: 10,
          color: Colors.white.withValues(alpha: 0.4),
          decoration: TextDecoration.underline,
          decorationColor: Colors.white.withValues(alpha: 0.15),
        ),
      ),
    );
  }
}
