import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/services/mod_transfer_service.dart';
import '../../../core/theme/app_colors.dart';
import '../../../generated/app_localizations.dart';
import '../../../shared/widgets/glass_dialog.dart';
import '../save_card.dart' show ActionBtn;
import 'save_area_tabs.dart' show currentSeasonAccent;


enum ModNeedStatus { update, missing, notInDrive }

/// Un mod de la partida que este equipo no tiene igual (spec 010 D8).
class ModNeed {
  const ModNeed({
    required this.entry,
    required this.status,
    this.localVersion,
    this.localFolder,
    this.unsupportedHere = false,
  });

  final SaveModEntry entry;
  final ModNeedStatus status;
  final String? localVersion;

  /// Carpeta del mod ya instalado (se sustituye ahí), si lo hay.
  final String? localFolder;

  /// No funcionaría en esta plataforma: se ofrece desmarcado.
  final bool unsupportedHere;

  bool get installable => status != ModNeedStatus.notInDrive;
}

/// "{granja} usa N mods" antes de bajar una partida SMAPI (mockup aprobado
/// 2026-10-23, bloque 3). Devuelve los mods elegidos (vacío = solo la
/// partida) o `null` si se cierra sin elegir: entonces no se baja nada.
Future<Set<String>?> showSaveModsDownloadDialog(
  BuildContext context, {
  required String farmName,
  required int totalMods,
  required List<ModNeed> needs,
}) {
  return showDialog<Set<String>>(
    context: context,
    builder: (ctx) => Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
      child: glassDialogShell(
        ctx,
        maxWidth: 460,
        accent: currentSeasonAccent,
        child: _Body(farmName: farmName, totalMods: totalMods, needs: needs),
      ),
    ),
  );
}

class _Body extends StatefulWidget {
  const _Body({
    required this.farmName,
    required this.totalMods,
    required this.needs,
  });

  final String farmName;
  final int totalMods;
  final List<ModNeed> needs;

  @override
  State<_Body> createState() => _BodyState();
}

class _BodyState extends State<_Body> {
  late final Set<String> _selected = {
    for (final n in widget.needs)
      if (n.installable && !n.unsupportedHere) n.entry.key,
  };

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final missingNames = [
      for (final n in widget.needs)
        if (n.status == ModNeedStatus.missing &&
            !_selected.contains(n.entry.key))
          n.entry.name,
    ];
    return dialogBody(
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.modsDownloadTitle(widget.farmName, widget.totalMods),
            style: GoogleFonts.bodoniModa(
              color: AppColors.text,
              fontStyle: FontStyle.italic,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            l10n.modsDownloadSubtitle,
            style: GoogleFonts.firaCode(
              fontSize: 10.5,
              height: 1.5,
              color: AppColors.textMuted,
            ),
          ),
        ],
      ),
      content: ConstrainedBox(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.sizeOf(context).height * 0.5,
        ),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              for (var i = 0; i < widget.needs.length; i++)
                _row(widget.needs[i], l10n, first: i == 0),
              if (missingNames.isNotEmpty) ...[
                const SizedBox(height: 10),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 10,
                  ),
                  decoration: BoxDecoration(
                    color: currentSeasonAccent.withValues(alpha: 0.07),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    l10n.modsDownloadWarning(missingNames.join(', ')),
                    style: GoogleFonts.firaCode(
                      fontSize: 10,
                      height: 1.5,
                      color: AppColors.textMuted,
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
      actions: [
        ActionBtn(
          label: l10n.modsDownloadWithMods(_selected.length),
          color: currentSeasonAccent,
          icon: Icons.cloud_download_outlined,
          filled: true,
          onTap: () => Navigator.pop(context, Set<String>.of(_selected)),
        ),
        ActionBtn(
          label: l10n.modsDownloadOnlySave,
          autofocus: true,
          color: Colors.white.withValues(alpha: 0.55),
          filled: false,
          onTap: () => Navigator.pop(context, <String>{}),
        ),
      ],
    );
  }

  Widget _row(ModNeed n, AppLocalizations l10n, {required bool first}) {
    final on = _selected.contains(n.entry.key);
    final (pillText, pillColor) = switch (n.status) {
      ModNeedStatus.update => (l10n.modsNeedUpdate, AppColors.statusPend),
      ModNeedStatus.missing => (l10n.modsNeedNew, currentSeasonAccent),
      ModNeedStatus.notInDrive => (l10n.modsNeedNotInDrive, AppColors.statusErr),
    };
    final detail = switch (n.status) {
      ModNeedStatus.update => l10n.modsNeedUpdateDetail(
        n.entry.version,
        n.localVersion ?? '?',
      ),
      ModNeedStatus.missing => l10n.modsNeedNewDetail(n.entry.version),
      ModNeedStatus.notInDrive => n.entry.pageUrl ?? l10n.modsNeedNoLink,
    };
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 9, horizontal: 2),
      decoration: BoxDecoration(
        border: first
            ? null
            : Border(
                top: BorderSide(color: Colors.white.withValues(alpha: 0.08)),
              ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          InkWell(
            onTap: n.installable
                ? () => setState(
                    () => on
                        ? _selected.remove(n.entry.key)
                        : _selected.add(n.entry.key),
                  )
                : null,
            borderRadius: BorderRadius.circular(4),
            child: Container(
              width: 16,
              height: 16,
              margin: const EdgeInsets.only(top: 2),
              decoration: BoxDecoration(
                color: on ? currentSeasonAccent : Colors.transparent,
                border: Border.all(
                  color: on
                      ? currentSeasonAccent
                      : AppColors.textFaint.withValues(
                          alpha: n.installable ? 1 : 0.4,
                        ),
                  width: 1.5,
                ),
                borderRadius: BorderRadius.circular(4),
              ),
              child: on
                  ? const Icon(
                      Icons.check_rounded,
                      size: 12,
                      color: Color(0xFF14110A),
                    )
                  : null,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  n.entry.name,
                  style: GoogleFonts.firaCode(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: AppColors.text,
                  ),
                ),
                const SizedBox(height: 2),
                SelectableText(
                  n.unsupportedHere ? l10n.modsNeedUnsupportedHere : detail,
                  style: GoogleFonts.firaCode(
                    fontSize: 9.5,
                    color: AppColors.textFaint,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
            decoration: BoxDecoration(
              color: pillColor.withValues(alpha: 0.12),
              border: Border.all(color: pillColor.withValues(alpha: 0.45)),
              borderRadius: BorderRadius.circular(999),
            ),
            child: Text(
              pillText,
              style: GoogleFonts.firaCode(
                fontSize: 8.5,
                fontWeight: FontWeight.w700,
                color: pillColor,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
