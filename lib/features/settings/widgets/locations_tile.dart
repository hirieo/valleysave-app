import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../core/services/save_service.dart';
import '../../../core/services/smapi_service.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../generated/app_localizations.dart';
import '../../saves/widgets/save_area_tabs.dart' show currentSeasonAccent;

/// Ajustes → Ubicaciones en escritorio (spec 010 D2, mockup aprobado
/// 2026-10-23, bloque 4): carpeta de partidas normales y estado de SMAPI con
/// su carpeta de `Mods`. Lo que no se detecta se elige a mano.
class LocationsTile extends StatefulWidget {
  const LocationsTile({super.key, required this.accent});

  final Color accent;

  @override
  State<LocationsTile> createState() => _LocationsTileState();
}

class _LocationsTileState extends State<LocationsTile> {
  bool _working = false;

  Future<void> _run(Future<void> Function() action) async {
    if (_working) return;
    setState(() => _working = true);
    try {
      await action();
    } finally {
      if (mounted) setState(() => _working = false);
    }
  }

  void _snack(String text) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(text)));
  }

  Future<void> _pickSavesDir(AppLocalizations l10n) => _run(() async {
    final path = await FilePicker.platform.getDirectoryPath(
      dialogTitle: l10n.settingsLocationsNormalSaves,
      initialDirectory: SaveService.savesDirectory,
    );
    if (path == null) return;
    if (!await SaveService.setCustomDirectory(path)) {
      _snack(l10n.snackInvalidFolder);
    }
  });

  Future<void> _pickModsDir(AppLocalizations l10n) => _run(() async {
    final path = await FilePicker.platform.getDirectoryPath(
      dialogTitle: l10n.settingsSmapiChangeMods,
      initialDirectory: SmapiService.instance.install?.modsDir,
    );
    if (path == null) return;
    if (!await SmapiService.instance.setModsPath(path)) {
      _snack(l10n.snackInvalidFolder);
    }
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final install = SmapiService.instance.install;
    final customSaves = SaveService.customDirectory != null;

    return Column(
      children: [
        _box(
          title: l10n.settingsLocationsNormalSaves,
          pill: customSaves
              ? _pill(l10n.settingsLocationsCustom, widget.accent)
              : _pill(l10n.settingsLocationsDetected, AppColors.statusOk),
          lines: [SaveService.savesDirectory ?? '—'],
          actions: [
            _action(l10n.settingsLocationsChange, () => _pickSavesDir(l10n)),
            if (customSaves)
              _action(
                l10n.settingsLocationsReset,
                () => _run(() => SaveService.setCustomDirectory(null)),
              ),
          ],
        ),
        const SizedBox(height: 8),
        if (install != null)
          _box(
            title: '🧩 SMAPI',
            titleColor: currentSeasonAccent,
            pill: _pill(install.version ?? '?', AppColors.statusOk),
            lines: [
              l10n.settingsSmapiSavesShared,
              l10n.settingsSmapiModsPath(install.modsDir),
            ],
            actions: [
              _action(l10n.settingsSmapiChangeMods, () => _pickModsDir(l10n)),
              _action(
                l10n.settingsLocationsReset,
                () => _run(SmapiService.instance.resetModsPath),
              ),
            ],
          )
        else
          _box(
            title: '🧩 SMAPI',
            titleColor: currentSeasonAccent,
            pill: _pill(l10n.settingsSmapiNotDetected, AppColors.statusPend),
            lines: [l10n.settingsSmapiNotFoundHint],
            actions: [
              _action(
                l10n.settingsSmapiSearch,
                () => _run(SmapiService.instance.init),
              ),
              _action(
                'smapi.io ↗',
                () => launchUrl(
                  Uri.parse('https://smapi.io/'),
                  mode: LaunchMode.externalApplication,
                ),
              ),
            ],
          ),
      ],
    );
  }

  Widget _box({
    required String title,
    Color titleColor = AppColors.text,
    required Widget pill,
    required List<String> lines,
    required List<Widget> actions,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.45),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white.withValues(alpha: 0.10)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Flexible(
                child: Text(
                  title,
                  style: AppTypography.bodyStrong(color: titleColor),
                ),
              ),
              const SizedBox(width: 8),
              pill,
            ],
          ),
          for (final line in lines) ...[
            const SizedBox(height: 4),
            Text(
              line,
              style: AppTypography.mono(size: 10),
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),
          ],
          const SizedBox(height: 10),
          Wrap(spacing: 8, runSpacing: 8, children: actions),
        ],
      ),
    );
  }

  Widget _pill(String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: color.withValues(alpha: 0.45)),
      ),
      child: Text(text, style: AppTypography.mono(color: color, size: 9)),
    );
  }

  Widget _action(String label, VoidCallback onTap) {
    final accent = widget.accent;
    return InkWell(
      onTap: _working ? null : onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          color: accent.withValues(alpha: 0.12),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: accent.withValues(alpha: 0.35)),
        ),
        child: Text(label, style: AppTypography.mono(color: accent, size: 11)),
      ),
    );
  }
}
