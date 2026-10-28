import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../core/models/backup_entry.dart';
import '../../../core/services/backup_service.dart';
import '../../../generated/app_localizations.dart';
import 'backup_action_button.dart';
import 'backup_game_summary.dart';

// Colores del mockup aprobado (spec 012, D7).
const _manualColor = Color(0xFFE0B850);
const _autoColor = Color(0xFF9FB3C8);
const _preRestoreColor = Color(0xFFE08A50);
const _useColor = Color(0xFF97C459);
const _restoreColor = Color(0xFF7FC4F5);
const _deleteColor = Color(0xFFE05252);
const _driveColor = Color(0xFF5AA8E0);
const _sharedColor = Color(0xFF42D392);

final _t2 = Colors.white.withValues(alpha: .72);
final _t3 = Colors.white.withValues(alpha: .62);

const _sectionOrder = [
  BackupOrigin.manual,
  BackupOrigin.auto,
  BackupOrigin.preRestore,
];

Color _colorOf(BackupOrigin origin) => switch (origin) {
  BackupOrigin.manual => _manualColor,
  BackupOrigin.auto => _autoColor,
  BackupOrigin.preRestore => _preRestoreColor,
};

const _foldDuration = Duration(milliseconds: 200);

/// Acciones de una fila. Las que van a `null` no se muestran.
class BackupRowActions {
  const BackupRowActions({
    required this.onRestore,
    this.onKeep,
    this.onDelete,
    this.onDownload,
    this.onUploadOwn,
    this.onUploadShared,
    this.ownActionCopiesRemote = false,
  });

  final Future<void> Function() onRestore;
  final Future<void> Function()? onKeep;
  final Future<void> Function()? onDelete;
  final Future<void> Function()? onDownload;
  final Future<void> Function()? onUploadOwn;
  final Future<void> Function()? onUploadShared;
  final bool ownActionCopiesRemote;
}

/// Secciones abiertas del diálogo, recordadas entre aperturas. Global, no por
/// partida (spec 012, D7).
abstract final class BackupsSectionsPrefs {
  static const key = 'backups_sections_open';

  static Future<Set<BackupOrigin>> load() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final names = prefs.getStringList(key) ?? const [];
      return {
        for (final origin in BackupOrigin.values)
          if (names.contains(origin.name)) origin,
      };
    } catch (_) {
      return {};
    }
  }

  static Future<void> save(Set<BackupOrigin> open) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setStringList(key, [for (final o in open) o.name]);
    } catch (_) {
      // Solo se pierde el recuerdo del plegado.
    }
  }
}

/// Contenido del diálogo de backups (spec 012, D7): barra con «Crear backup» y
/// «Desplegar todo», y una sección plegable por tipo — Manuales,
/// Automáticos, Antes de restaurar —; las vacías no se muestran.
class BackupsSections extends StatefulWidget {
  const BackupsSections({
    super.key,
    required this.entries,
    required this.inUseFileName,
    required this.initialOpen,
    required this.actionsFor,
    required this.loadSummary,
    this.onCreate,
    this.hint,
    this.showSharedLocation = false,
  });

  final List<BackupEntry> entries;

  /// `fileName` del backup restaurado que la partida aún conserva (D3).
  final String? inUseFileName;
  final Set<BackupOrigin> initialOpen;
  final BackupRowActions Function(BackupEntry entry) actionsFor;
  final Future<BackupGameSummary?> Function(BackupEntry entry) loadSummary;

  /// `null` oculta «Crear backup» (partida sin copia local).
  final Future<void> Function()? onCreate;

  /// Aviso fino bajo el título (11 px, sin borde); `null` lo oculta.
  final String? hint;
  final bool showSharedLocation;

  @override
  State<BackupsSections> createState() => _BackupsSectionsState();
}

class _BackupsSectionsState extends State<BackupsSections> {
  late final Set<BackupOrigin> _open = {...widget.initialOpen};

  void _toggle(BackupOrigin origin) {
    setState(() {
      if (!_open.remove(origin)) _open.add(origin);
    });
    unawaited(BackupsSectionsPrefs.save(_open));
  }

  void _toggleAll(List<BackupOrigin> visible, bool allOpen) {
    setState(() {
      if (allOpen) {
        _open.removeAll(visible);
      } else {
        _open.addAll(visible);
      }
    });
    unawaited(BackupsSectionsPrefs.save(_open));
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final sorted = [...widget.entries]
      ..sort((a, b) => b.timestamp.compareTo(a.timestamp));
    final groups = <BackupOrigin, List<BackupEntry>>{
      for (final origin in _sectionOrder)
        origin: [
          for (final e in sorted)
            if (_groupOf(e) == origin) e,
        ],
    };
    final visible = [
      for (final origin in _sectionOrder)
        if (groups[origin]!.isNotEmpty) origin,
    ];
    final allOpen = visible.isNotEmpty && visible.every(_open.contains);

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (widget.hint != null) ...[
          _Hint(text: widget.hint!),
          const SizedBox(height: 12),
        ],
        Row(
          children: [
            if (widget.onCreate != null)
              Flexible(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 235),
                  child: BackupActionButton(
                    key: const ValueKey('backup-create-action'),
                    label: l10n.backupsCreate,
                    icon: Icons.add_rounded,
                    color: _manualColor,
                    solid: true,
                    onPressed: widget.onCreate,
                  ),
                ),
              ),
            const Spacer(),
            if (visible.isNotEmpty)
              _ToggleAllChip(
                key: const ValueKey('backups-toggle-all'),
                label: allOpen
                    ? l10n.backupsCollapseAll
                    : l10n.backupsExpandAll,
                onTap: () => _toggleAll(visible, allOpen),
              ),
          ],
        ),
        if (sorted.isEmpty) ...[
          const SizedBox(height: 12),
          Text(
            l10n.backupsEmpty,
            style: GoogleFonts.firaCode(fontSize: 11, color: _t3),
          ),
        ],
        const SizedBox(height: 6),
        for (final origin in visible)
          _Section(
            key: ValueKey('backups-section-${origin.name}'),
            origin: origin,
            entries: groups[origin]!,
            open: _open.contains(origin),
            inUseFileName: widget.inUseFileName,
            showSharedLocation: widget.showSharedLocation,
            actionsFor: widget.actionsFor,
            loadSummary: widget.loadSummary,
            onToggle: () => _toggle(origin),
          ),
      ],
    );
  }

  /// Los antiguos `_pre-swap_` ya llegan como manuales desde el modelo.
  static BackupOrigin _groupOf(BackupEntry e) => e.origin;
}

/// Aviso tintado de verde, sin borde, como el de la opción B aprobada.
class _Hint extends StatelessWidget {
  const _Hint({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
      decoration: BoxDecoration(
        color: _useColor.withValues(alpha: .07),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.only(top: 1),
            child: Icon(Icons.laptop_mac_rounded, size: 13, color: _useColor),
          ),
          const SizedBox(width: 6),
          Expanded(
            child: Text(
              text,
              style: GoogleFonts.firaCode(
                fontSize: 11,
                height: 1.5,
                color: _useColor.withValues(alpha: .9),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ToggleAllChip extends StatelessWidget {
  const _ToggleAllChip({super.key, required this.label, required this.onTap});

  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: label,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.white.withValues(alpha: .18)),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            label,
            style: GoogleFonts.firaCode(fontSize: 11, color: _t2),
          ),
        ),
      ),
    );
  }
}

String _shortDate(DateTime ts) {
  String p(int n) => n.toString().padLeft(2, '0');
  return '${p(ts.day)}/${p(ts.month)} ${p(ts.hour)}:${p(ts.minute)}';
}

String _longDate(DateTime ts) {
  String p(int n) => n.toString().padLeft(2, '0');
  return '${p(ts.day)}/${p(ts.month)}/${ts.year} · ${p(ts.hour)}:${p(ts.minute)}';
}

class _Section extends StatelessWidget {
  const _Section({
    super.key,
    required this.origin,
    required this.entries,
    required this.open,
    required this.inUseFileName,
    required this.showSharedLocation,
    required this.actionsFor,
    required this.loadSummary,
    required this.onToggle,
  });

  final BackupOrigin origin;
  final List<BackupEntry> entries;
  final bool open;
  final String? inUseFileName;
  final bool showSharedLocation;
  final BackupRowActions Function(BackupEntry entry) actionsFor;
  final Future<BackupGameSummary?> Function(BackupEntry entry) loadSummary;
  final VoidCallback onToggle;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final color = _colorOf(origin);
    final reduceMotion =
        MediaQuery.maybeOf(context)?.disableAnimations ?? false;

    final name = switch (origin) {
      BackupOrigin.manual => l10n.backupsSectionManual,
      BackupOrigin.auto => l10n.backupsSectionAuto,
      BackupOrigin.preRestore => l10n.backupsSectionPreRestore,
    };
    final rule = switch (origin) {
      BackupOrigin.manual => l10n.backupsRuleManual,
      BackupOrigin.auto => l10n.backupsRuleKeep(kMaxAutoBackups),
      BackupOrigin.preRestore => l10n.backupsRuleKeep(kMaxPreRestoreBackups),
    };
    final inUse = entries.where((e) => e.fileName == inUseFileName).firstOrNull;
    // El backup «En uso» sube siempre al principio de su sección; el resto
    // conserva el orden por fecha.
    final ordered = [
      ?inUse,
      for (final e in entries)
        if (e.fileName != inUseFileName) e,
    ];

    final Widget summary;
    if (open) {
      summary = Text(
        rule,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        textAlign: TextAlign.right,
        style: GoogleFonts.firaCode(fontSize: 11, color: _t3),
      );
    } else if (inUse != null) {
      summary = Text.rich(
        TextSpan(
          children: [
            TextSpan(
              text: '● ${l10n.backupsInUseShort}',
              style: const TextStyle(color: _useColor),
            ),
            TextSpan(text: ' ${_shortDate(inUse.timestamp)}'),
          ],
        ),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        textAlign: TextAlign.right,
        style: GoogleFonts.firaCode(fontSize: 11, color: _t3),
      );
    } else {
      summary = Text(
        l10n.backupsSectionLast(_shortDate(entries.first.timestamp)),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        textAlign: TextAlign.right,
        style: GoogleFonts.firaCode(fontSize: 11, color: _t3),
      );
    }

    return Container(
      margin: const EdgeInsets.only(top: 10),
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: color.withValues(alpha: open ? .07 : .045),
        border: Border.all(color: color.withValues(alpha: open ? .30 : .16)),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Semantics(
            button: true,
            expanded: open,
            label: name,
            child: InkWell(
              key: ValueKey('backups-header-${origin.name}'),
              onTap: onToggle,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 13,
                  vertical: 11,
                ),
                decoration: BoxDecoration(
                  border: open
                      ? Border(
                          bottom: BorderSide(
                            color: color.withValues(alpha: .28),
                          ),
                        )
                      : null,
                ),
                child: Row(
                  children: [
                    AnimatedRotation(
                      turns: open ? .25 : 0,
                      duration: reduceMotion ? Duration.zero : _foldDuration,
                      curve: Curves.easeOutCubic,
                      child: Icon(
                        Icons.chevron_right_rounded,
                        size: 14,
                        color: open ? color : _t3,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      name,
                      style: GoogleFonts.firaCode(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: color,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 1,
                      ),
                      decoration: BoxDecoration(
                        color: color.withValues(alpha: .14),
                        borderRadius: BorderRadius.circular(999),
                      ),
                      child: Text(
                        '${entries.length}',
                        style: GoogleFonts.firaCode(
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          color: color,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(child: summary),
                  ],
                ),
              ),
            ),
          ),
          _Collapsible(
            open: open,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                for (var i = 0; i < ordered.length; i++)
                  _BackupRow(
                    key: ValueKey('backup-row-${ordered[i].fileName}'),
                    entry: ordered[i],
                    first: i == 0,
                    inUse: ordered[i].fileName == inUseFileName,
                    showSharedLocation: showSharedLocation,
                    actions: actionsFor(ordered[i]),
                    loadSummary: loadSummary,
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Pliega/despliega [child] con `SizeTransition` (200 ms, easeOutCubic). El
/// hijo no se construye mientras la sección está plegada del todo, así las
/// filas (y la lectura de sus datos de partida) solo existen si se ven.
class _Collapsible extends StatefulWidget {
  const _Collapsible({required this.open, required this.child});

  final bool open;
  final Widget child;

  @override
  State<_Collapsible> createState() => _CollapsibleState();
}

class _CollapsibleState extends State<_Collapsible>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: _foldDuration,
    value: widget.open ? 1 : 0,
  );
  late final Animation<double> _curve = CurvedAnimation(
    parent: _controller,
    curve: Curves.easeOutCubic,
  );

  @override
  void didUpdateWidget(_Collapsible oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.open == widget.open) return;
    final reduceMotion =
        MediaQuery.maybeOf(context)?.disableAnimations ?? false;
    final target = widget.open ? 1.0 : 0.0;
    if (reduceMotion) {
      _controller.value = target;
    } else {
      _controller.animateTo(target);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, _) {
        // `value`, no `isDismissed`: el controlador avisa del último valor
        // ANTES de actualizar su estado, y ese último aviso es el que debe
        // quitar las filas.
        if (_controller.value <= 0) {
          return const SizedBox(width: double.infinity);
        }
        return ClipRect(
          child: SizeTransition(
            sizeFactor: _curve,
            alignment: Alignment.topCenter,
            child: widget.child,
          ),
        );
      },
    );
  }
}

class _BackupRow extends StatefulWidget {
  const _BackupRow({
    super.key,
    required this.entry,
    required this.first,
    required this.inUse,
    required this.showSharedLocation,
    required this.actions,
    required this.loadSummary,
  });

  final BackupEntry entry;
  final bool first;
  final bool inUse;
  final bool showSharedLocation;
  final BackupRowActions actions;
  final Future<BackupGameSummary?> Function(BackupEntry entry) loadSummary;

  @override
  State<_BackupRow> createState() => _BackupRowState();
}

class _BackupRowState extends State<_BackupRow> {
  late Future<BackupGameSummary?> _summary = widget.loadSummary(widget.entry);

  @override
  void didUpdateWidget(_BackupRow oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Solo se relee si cambia el zip del que se lee (p. ej. al descargarlo).
    if (oldWidget.entry.localPath != widget.entry.localPath ||
        oldWidget.entry.fileName != widget.entry.fileName) {
      _summary = widget.loadSummary(widget.entry);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final entry = widget.entry;
    final actions = widget.actions;
    final hasRemoteActions =
        actions.onDownload != null ||
        actions.onUploadOwn != null ||
        actions.onUploadShared != null;

    return Container(
      padding: const EdgeInsets.fromLTRB(13, 11, 13, 12),
      decoration: BoxDecoration(
        color: widget.inUse ? _useColor.withValues(alpha: .09) : null,
        border: widget.first
            ? null
            : Border(
                top: BorderSide(color: Colors.white.withValues(alpha: .08)),
              ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (widget.inUse)
                Container(
                  margin: const EdgeInsets.only(bottom: 5),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 1,
                  ),
                  decoration: BoxDecoration(
                    color: _useColor,
                    borderRadius: BorderRadius.circular(999),
                  ),
                  child: Text(
                    l10n.backupsInUseTag,
                    style: GoogleFonts.firaCode(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      color: const Color(0xFF14110A),
                    ),
                  ),
                ),
              Text(
                _longDate(entry.timestamp),
                style: GoogleFonts.firaCode(
                  fontSize: 12.5,
                  color: Colors.white,
                ),
              ),
              FutureBuilder<BackupGameSummary?>(
                future: _summary,
                builder: (context, snapshot) {
                  // Datos de partida (si se pudieron leer) y lo que ocupa el
                  // zip, en la misma línea. Sin datos, solo el tamaño.
                  final data = snapshot.data;
                  final line = [
                    if (data != null) formatBackupGameSummary(data, l10n),
                    formatBackupSize(entry.sizeBytes, l10n.localeName),
                  ].join(' · ');
                  return Padding(
                    padding: const EdgeInsets.only(top: 2),
                    child: Text(
                      line,
                      style: GoogleFonts.firaCode(fontSize: 11, color: _t2),
                    ),
                  );
                },
              ),
            ],
          ),
          const SizedBox(height: 9),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              _LocationIcon(
                icon: Icons.laptop_mac_rounded,
                active: entry.isLocal,
                color: _manualColor,
                tooltip: l10n.backupsLocationLocal,
              ),
              const SizedBox(width: 6),
              _LocationIcon(
                icon: Icons.cloud_outlined,
                active: entry.isOnDrive,
                color: _driveColor,
                tooltip: l10n.backupsLocationOwnDrive,
              ),
              if (widget.showSharedLocation || entry.isOnSharedDrive) ...[
                const SizedBox(width: 6),
                _LocationIcon(
                  icon: Icons.link_rounded,
                  active: entry.isOnSharedDrive,
                  color: _sharedColor,
                  tooltip: l10n.backupsLocationSharedDrive,
                ),
              ],
              const SizedBox(width: 6),
              Expanded(
                child: Wrap(
                  alignment: WrapAlignment.end,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  spacing: 6,
                  runSpacing: 6,
                  children: [
                    BackupActionButton(
                      key: ValueKey('backup-restore-${entry.fileName}'),
                      label: l10n.backupsRestore,
                      icon: Icons.settings_backup_restore_rounded,
                      color: _restoreColor,
                      compact: true,
                      onPressed: actions.onRestore,
                    ),
                    if (actions.onKeep != null)
                      BackupActionButton(
                        key: ValueKey('backup-keep-${entry.fileName}'),
                        label: l10n.backupsKeep,
                        icon: Icons.bookmark_border_rounded,
                        color: _manualColor,
                        compact: true,
                        onPressed: actions.onKeep,
                      ),
                    // El backup en uso nunca se borra desde aquí (D3).
                    if (actions.onDelete != null && !widget.inUse)
                      BackupActionButton(
                        key: ValueKey('backup-delete-${entry.fileName}'),
                        label: l10n.backupsDelete,
                        icon: Icons.delete_outline_rounded,
                        color: _deleteColor,
                        compact: true,
                        iconOnly: true,
                        tooltip: l10n.backupsDelete,
                        onPressed: actions.onDelete,
                      ),
                  ],
                ),
              ),
            ],
          ),
          if (hasRemoteActions) ...[
            const SizedBox(height: 9),
            Wrap(
              spacing: 6,
              runSpacing: 6,
              children: [
                if (actions.onDownload != null)
                  BackupActionButton(
                    key: ValueKey('backup-download-${entry.fileName}'),
                    label: l10n.backupsDownload,
                    icon: Icons.download_rounded,
                    color: _restoreColor,
                    compact: true,
                    filled: true,
                    onPressed: actions.onDownload,
                  ),
                if (actions.onUploadOwn != null)
                  BackupActionButton(
                    key: ValueKey('backup-upload-own-${entry.fileName}'),
                    label: actions.ownActionCopiesRemote
                        ? l10n.backupsCopyOwn
                        : l10n.backupsUploadOwn,
                    icon: Icons.cloud_upload_outlined,
                    color: _driveColor,
                    compact: true,
                    onPressed: actions.onUploadOwn,
                  ),
                if (actions.onUploadShared != null)
                  BackupActionButton(
                    key: ValueKey('backup-upload-shared-${entry.fileName}'),
                    label: l10n.backupsUploadShared,
                    icon: Icons.link_rounded,
                    color: _sharedColor,
                    compact: true,
                    onPressed: actions.onUploadShared,
                  ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}

class _LocationIcon extends StatelessWidget {
  const _LocationIcon({
    required this.icon,
    required this.active,
    required this.color,
    required this.tooltip,
  });

  final IconData icon;
  final bool active;
  final Color color;
  final String tooltip;

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: tooltip,
      child: Container(
        width: 27,
        height: 27,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: active ? color.withValues(alpha: .10) : Colors.transparent,
          border: Border.all(
            color: active
                ? color.withValues(alpha: .55)
                : Colors.white.withValues(alpha: .14),
          ),
          borderRadius: BorderRadius.circular(7),
        ),
        child: Icon(
          icon,
          size: 15,
          color: active ? color : Colors.white.withValues(alpha: .4),
        ),
      ),
    );
  }
}
