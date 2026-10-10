import 'package:flutter/material.dart';

import '../../../core/services/saves_folder_scan.dart';
import '../../../core/services/shizuku_service.dart';
import '../../../core/services/stardew_paths.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../generated/app_localizations.dart';
import '../../../shared/widgets/glass_dialog.dart';
import '../../../shared/widgets/icon_circle_button.dart';
import '../../../shared/widgets/pressable_scale.dart';

/// Diálogo para elegir la carpeta de saves de Android (Shizuku o root):
/// carpetas detectadas automáticamente + explorador con filtro como
/// alternativa. Devuelve `true` si la ruta guardada cambió.
///
/// Todo lo que toca el shell sale de `saves_folder_scan.dart` (rutas
/// validadas con [isValidSavesPath] y entrecomilladas) — SIN verificar en un
/// dispositivo real todavía.
class SavesFolderDialog extends StatefulWidget {
  const SavesFolderDialog({
    super.key,
    required this.root,
    required this.accent,
  });

  /// `true` = acceso root (`su`), `false` = Shizuku.
  final bool root;
  final Color accent;

  @override
  State<SavesFolderDialog> createState() => _SavesFolderDialogState();
}

class _SavesFolderDialogState extends State<SavesFolderDialog> {
  final _store = AndroidSavesPath.instance;
  final _search = TextEditingController();
  String _query = '';

  late final String _initialPath = _store.current;
  bool _browsing = false;

  // Detección
  bool _detecting = true;
  List<SavesCandidate> _candidates = const [];

  // Explorador
  String _dir = '/storage/emulated/0';
  List<String>? _dirs;
  bool _loadingDir = false;
  _Verify? _verify;
  bool _verifying = false;

  @override
  void initState() {
    super.initState();
    _detect();
  }

  @override
  void dispose() {
    _search.dispose();
    super.dispose();
  }

  Future<void> _detect() async {
    final found = await ShizukuService.instance.detectSavesFolders(
      root: widget.root,
    );
    if (!mounted) return;
    setState(() {
      _candidates = found;
      _detecting = false;
    });
  }

  Future<void> _choose(String path) async {
    final ok = await _store.set(path);
    if (!ok || !mounted) return;
    Navigator.pop(context, _store.current != _initialPath);
  }

  Future<void> _reset() async {
    await _store.reset();
    if (!mounted) return;
    Navigator.pop(context, _store.current != _initialPath);
  }

  void _startBrowsing() {
    final parent = parentDir(_store.current);
    setState(() {
      _browsing = true;
      _dir = isValidSavesPath(parent) ? parent : '/storage/emulated/0';
    });
    _openDir(_dir);
  }

  Future<void> _openDir(String dir) async {
    if (!isValidSavesPath(dir)) return;
    setState(() {
      _dir = dir;
      _dirs = null;
      _loadingDir = true;
      _verify = null;
      _query = '';
      _search.clear();
    });
    final list = await ShizukuService.instance.listSubdirs(
      dir,
      root: widget.root,
    );
    if (!mounted || _dir != dir) return;
    setState(() {
      _dirs = list;
      _loadingDir = false;
    });
  }

  Future<void> _runVerify() async {
    final dir = _dir;
    setState(() => _verifying = true);
    final n = await ShizukuService.instance.countSavesIn(
      dir,
      root: widget.root,
    );
    if (!mounted || _dir != dir) return;
    setState(() {
      _verifying = false;
      _verify = _Verify(n);
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
      child: glassDialogShell(
        context,
        maxWidth: 420,
        accent: widget.accent,
        padding: EdgeInsets.zero,
        child: _browsing ? _explorer(l10n) : _detectView(l10n),
      ),
    );
  }

  // ── Vista 1: carpeta actual + detectadas ──────────────────────────────
  Widget _detectView(AppLocalizations l10n) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _header(l10n.savesFolderTitle, onClose: () => Navigator.pop(context, false)),
        Flexible(
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.savesFolderCurrent.toUpperCase(),
                  style: AppTypography.eyebrow(),
                ),
                const SizedBox(height: 6),
                Text(
                  _store.current,
                  style: AppTypography.mono(color: AppColors.statusOk, size: 11),
                ),
                const SizedBox(height: 18),
                Text(
                  l10n.savesFolderDetected.toUpperCase(),
                  style: AppTypography.eyebrow(),
                ),
                const SizedBox(height: 8),
                if (_detecting)
                  Text(l10n.savesFolderDetecting, style: AppTypography.body())
                else if (_candidates.isEmpty)
                  Text(l10n.savesFolderNoneDetected, style: AppTypography.body())
                else
                  for (final c in _candidates)
                    _row(
                      icon: Icons.folder_special_rounded,
                      title: c.path,
                      subtitle: l10n.savesFolderCount(c.saveCount),
                      selected: c.path == _store.current,
                      highlight: true,
                      onTap: () => _choose(c.path),
                    ),
                const SizedBox(height: 16),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    _pill(l10n.savesFolderBrowse, _startBrowsing, filled: true),
                    if (!_store.isDefault)
                      _pill(l10n.savesFolderReset, _reset),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  // ── Vista 2: explorador ───────────────────────────────────────────────
  Widget _explorer(AppLocalizations l10n) {
    final dirs = _dirs ?? const <String>[];
    final filtered = _query.isEmpty
        ? dirs
        : dirs.where((d) => d.toLowerCase().contains(_query)).toList();
    final v = _verify;
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(12, 12, 12, 8),
          child: Row(
            children: [
              IconCircleButton(
                icon: Icons.arrow_back_rounded,
                tooltip: l10n.savesFolderTitle,
                onTap: () => setState(() => _browsing = false),
              ),
              const SizedBox(width: 8),
              IconCircleButton(
                icon: Icons.arrow_upward_rounded,
                tooltip: l10n.savesFolderParent,
                onTap: parentDir(_dir) == '/'
                    ? () {}
                    : () => _openDir(parentDir(_dir)),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  _dir,
                  style: AppTypography.mono(color: AppColors.text, size: 11),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: _searchField(l10n),
        ),
        const SizedBox(height: 4),
        Flexible(
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxHeight: MediaQuery.of(context).size.height * 0.40,
            ),
            child: _loadingDir
                ? Padding(
                    padding: const EdgeInsets.all(16),
                    child: Text(
                      l10n.savesFolderDetecting,
                      style: AppTypography.body(),
                    ),
                  )
                : _dirs == null
                    ? Padding(
                        padding: const EdgeInsets.all(16),
                        child: Text(
                          l10n.savesFolderListError,
                          style: AppTypography.body(color: AppColors.statusErr),
                        ),
                      )
                    : filtered.isEmpty
                        ? Padding(
                            padding: const EdgeInsets.all(16),
                            child: Text(
                              l10n.savesFolderNoSubfolders,
                              style: AppTypography.body(),
                            ),
                          )
                        : ListView.builder(
                            shrinkWrap: true,
                            padding: const EdgeInsets.fromLTRB(8, 2, 8, 8),
                            itemCount: filtered.length,
                            itemBuilder: (_, i) {
                              final name = filtered[i];
                              final child = childDir(_dir, name);
                              final saves = looksLikeSavesFolder(child);
                              return _row(
                                icon: saves
                                    ? Icons.folder_special_rounded
                                    : Icons.folder_rounded,
                                title: name,
                                subtitle: saves ? l10n.savesFolderLooksLike : null,
                                selected: child == _store.current,
                                highlight: saves,
                                onTap: () => _openDir(child),
                              );
                            },
                          ),
          ),
        ),
        if (v != null)
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 4, 16, 0),
            child: Text(
              v.count == null
                  ? l10n.savesFolderVerifyMissing
                  : v.count == 0
                      ? l10n.savesFolderVerifyEmpty
                      : l10n.savesFolderVerifyOk(v.count!),
              style: AppTypography.body(
                color: v.count == null
                    ? AppColors.statusErr
                    : v.count == 0
                        ? AppColors.statusPend
                        : AppColors.statusOk,
              ),
            ),
          ),
        Padding(
          padding: const EdgeInsets.all(16),
          child: Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              _pill(l10n.savesFolderVerify, _verifying ? null : _runVerify),
              _pill(
                l10n.savesFolderUse,
                isValidSavesPath(_dir) ? () => _choose(_dir) : null,
                filled: true,
              ),
            ],
          ),
        ),
      ],
    );
  }

  // ── Piezas ────────────────────────────────────────────────────────────
  Widget _header(String title, {required VoidCallback onClose}) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 14, 12, 10),
      child: Row(
        children: [
          Expanded(
            child: Text(title.toUpperCase(), style: AppTypography.eyebrow()),
          ),
          PressableScale(
            autofocus: true,
            onTap: onClose,
            semanticLabel: AppLocalizations.of(context)!.cancel,
            child: Icon(
              Icons.close_rounded,
              size: 18,
              color: AppColors.textFaint,
            ),
          ),
        ],
      ),
    );
  }

  Widget _searchField(AppLocalizations l10n) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.40),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.white.withValues(alpha: 0.10)),
      ),
      child: Row(
        children: [
          const SizedBox(width: 12),
          Icon(Icons.search_rounded, size: 16, color: AppColors.textFaint),
          const SizedBox(width: 8),
          Expanded(
            child: TextField(
              controller: _search,
              onChanged: (v) => setState(() => _query = v.toLowerCase()),
              style: AppTypography.body(color: AppColors.text),
              decoration: InputDecoration(
                hintText: l10n.searchHint,
                hintStyle: AppTypography.body(color: AppColors.textFaint),
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(vertical: 10),
              ),
            ),
          ),
          if (_query.isNotEmpty)
            PressableScale(
              onTap: () {
                _search.clear();
                setState(() => _query = '');
              },
              child: Padding(
                padding: const EdgeInsets.all(8),
                child: Icon(
                  Icons.close_rounded,
                  size: 14,
                  color: AppColors.textFaint,
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _row({
    required IconData icon,
    required String title,
    String? subtitle,
    required bool selected,
    required bool highlight,
    required VoidCallback onTap,
  }) {
    return PressableScale(
      pressedScale: 0.985,
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 2),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 11),
        decoration: BoxDecoration(
          color: selected
              ? widget.accent.withValues(alpha: 0.10)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              size: 18,
              color: highlight ? widget.accent : AppColors.textFaint,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: AppTypography.bodyStrong(
                      color: selected ? widget.accent : AppColors.text,
                    ),
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),
                  if (subtitle != null)
                    Text(
                      subtitle,
                      style: AppTypography.mono(
                        color: AppColors.textFaint,
                        size: 11,
                      ),
                    ),
                ],
              ),
            ),
            if (selected)
              Icon(Icons.check_rounded, size: 18, color: widget.accent),
          ],
        ),
      ),
    );
  }

  Widget _pill(String label, VoidCallback? onTap, {bool filled = false}) {
    final enabled = onTap != null;
    return Opacity(
      opacity: enabled ? 1 : 0.45,
      child: PressableScale(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: widget.accent.withValues(alpha: filled ? 0.16 : 0.08),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: widget.accent.withValues(alpha: filled ? 0.45 : 0.30),
            ),
          ),
          child: Text(
            label,
            style: AppTypography.mono(color: widget.accent, size: 11),
          ),
        ),
      ),
    );
  }
}

class _Verify {
  const _Verify(this.count);

  /// `null` = carpeta inexistente o ilegible.
  final int? count;
}
