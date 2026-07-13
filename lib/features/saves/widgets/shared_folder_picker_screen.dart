import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:googleapis/drive/v3.dart' as drive;

import '../../../core/services/drive_service.dart';
import '../../../generated/app_localizations.dart';
import '../save_card.dart' show ActionBtn;
import 'stagger_item.dart';

const _kAccent = Color(0xFF97C459);
const _kMonths = [
  'ene', 'feb', 'mar', 'abr', 'may', 'jun',
  'jul', 'ago', 'sep', 'oct', 'nov', 'dic',
];

/// Selector de carpetas de "Compartido conmigo" en Drive, como diálogo
/// compacto (mismo `_glassDialogShell` que "Compartir"/"Backups" — nunca
/// pantalla completa). Cada save se comparte como carpeta individual (F2),
/// así que no hace falta navegar subcarpetas: se listan directamente al
/// nivel raíz de sharedWithMe.
Future<String?> showPickerScreen(
  BuildContext context, {
  required DriveService drive,
}) {
  return showDialog<String?>(
    context: context,
    builder: (_) => Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
      child: _SharedFolderPickerDialog(drive: drive),
    ),
  );
}

class _SharedFolderPickerDialog extends StatefulWidget {
  const _SharedFolderPickerDialog({required this.drive});
  final DriveService drive;

  @override
  State<_SharedFolderPickerDialog> createState() =>
      _SharedFolderPickerDialogState();
}

class _SharedFolderPickerDialogState
    extends State<_SharedFolderPickerDialog> {
  List<drive.File>? _folders;
  String? _error;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    try {
      final folders = await widget.drive.listSharedFolders();
      if (mounted) setState(() => _folders = folders);
    } catch (e) {
      if (mounted) setState(() => _error = e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return ConstrainedBox(
      constraints: BoxConstraints(
        maxWidth: 420,
        maxHeight: MediaQuery.of(context).size.height * 0.7,
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(22),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 6, sigmaY: 6),
          child: Container(
            decoration: BoxDecoration(
              color: const Color(0xFF14110A).withValues(alpha: 0.92),
              borderRadius: BorderRadius.circular(22),
              border: Border.all(color: _kAccent.withValues(alpha: 0.22)),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.55),
                  blurRadius: 44,
                  offset: const Offset(0, 16),
                ),
              ],
            ),
            padding: const EdgeInsets.fromLTRB(22, 20, 22, 16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.sharedWithMePickerTitle,
                  style: const TextStyle(color: Colors.white, fontSize: 14),
                ),
                const SizedBox(height: 12),
                Flexible(child: _buildBody(l10n)),
                const SizedBox(height: 14),
                Align(
                  alignment: Alignment.centerRight,
                  child: GestureDetector(
                    onTap: () => Navigator.of(context).pop(),
                    child: Container(
                      padding:
                          const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
                      decoration: BoxDecoration(
                        border: Border.all(
                            color: const Color(0xFFE05252).withValues(alpha: 0.5)),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        l10n.cancel,
                        style: const TextStyle(color: Color(0xFFE05252), fontSize: 10),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBody(AppLocalizations l10n) {
    if (_error != null) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 20),
        child: Text(
          _error!,
          style: const TextStyle(color: Colors.white54, fontSize: 12),
          textAlign: TextAlign.center,
        ),
      );
    }
    if (_folders == null) {
      return const Padding(
        padding: EdgeInsets.symmetric(vertical: 28),
        child: Center(
          child: SizedBox(
            width: 18,
            height: 18,
            child: CircularProgressIndicator(
                color: Colors.white38, strokeWidth: 2),
          ),
        ),
      );
    }
    if (_folders!.isEmpty) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 20),
        child: Text(
          l10n.sharedPickerEmptyHint,
          style: const TextStyle(color: Colors.white38, fontSize: 12),
          textAlign: TextAlign.center,
        ),
      );
    }
    return SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          for (var i = 0; i < _folders!.length; i++) ...[
            if (i > 0) const Divider(height: 1, color: Color(0x0FFFFFFF)),
            StaggerItem(
              index: i,
              child: _SharedFolderRow(
                file: _folders![i],
                addLabel: l10n.sharedPickerAddButton,
                onAdd: () => Navigator.of(context).pop(_folders![i].id),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _SharedFolderRow extends StatelessWidget {
  const _SharedFolderRow({
    required this.file,
    required this.addLabel,
    required this.onAdd,
  });

  final drive.File file;
  final String addLabel;
  final VoidCallback onAdd;

  static String _formatDate(DateTime? d) {
    if (d == null) return '';
    final local = d.toLocal();
    return '${local.day} ${_kMonths[local.month - 1]}';
  }

  @override
  Widget build(BuildContext context) {
    final owners = file.owners;
    final owner = (owners != null && owners.isNotEmpty)
        ? owners.first.emailAddress ?? ''
        : '';
    final modified = _formatDate(file.modifiedTime);
    final subtitle = [
      if (owner.isNotEmpty) owner,
      if (modified.isNotEmpty) 'modificado $modified',
    ].join(' · ');

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          const Icon(Icons.folder_outlined, size: 16, color: Colors.white38),
          const SizedBox(width: 9),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  file.name ?? '',
                  style: const TextStyle(color: Colors.white, fontSize: 12.5),
                  overflow: TextOverflow.ellipsis,
                ),
                if (subtitle.isNotEmpty) ...[
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style:
                        const TextStyle(color: Colors.white38, fontSize: 10.5),
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ],
            ),
          ),
          const SizedBox(width: 8),
          ActionBtn(
            label: addLabel,
            color: _kAccent,
            filled: true,
            onTap: onAdd,
          ),
        ],
      ),
    );
  }
}
