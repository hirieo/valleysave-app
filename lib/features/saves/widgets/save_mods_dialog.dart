import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/models/mod_info.dart';
import '../../../core/services/mod_prefs.dart';
import '../../../core/services/mod_scanner.dart';
import '../../../core/theme/app_colors.dart';
import '../../../generated/app_localizations.dart';
import '../../../shared/widgets/glass_dialog.dart';
import '../save_card.dart' show ActionBtn;
import 'save_area_tabs.dart' show smapiAccent;

const _gold = Color(0xFFE8B84A);

/// "Mods de {granja}" (spec 010, mockup aprobado 2026-10-23, bloque 2): qué
/// mods viajan con esta partida (check grande), "llevar siempre" y "con sus
/// ajustes" por mod, versión y compatibilidad PC/Android. Las elecciones se
/// guardan al momento en [ModPrefs]. Con Drive conectado, [onUpload] sube
/// los mods marcados y la lista de la partida (fase F3).
Future<void> showSaveModsDialog(
  BuildContext context, {
  required String farmName,
  required String folderName,
  required List<ModInfo> mods,
  required String? smapiVersion,
  Future<void> Function(List<ModInfo> carried)? onUpload,
}) async {
  await ModPrefs.instance.ensureLoaded();
  if (!context.mounted) return;
  await showDialog<void>(
    context: context,
    builder: (ctx) => Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
      child: glassDialogShell(
        ctx,
        maxWidth: 460,
        accent: smapiAccent,
        child: _SaveModsBody(
          farmName: farmName,
          folderName: folderName,
          mods: mods,
          smapiVersion: smapiVersion,
          onUpload: onUpload,
        ),
      ),
    ),
  );
}

class _SaveModsBody extends StatefulWidget {
  const _SaveModsBody({
    required this.farmName,
    required this.folderName,
    required this.mods,
    required this.smapiVersion,
    this.onUpload,
  });

  final String farmName;
  final String folderName;
  final List<ModInfo> mods;
  final String? smapiVersion;
  final Future<void> Function(List<ModInfo> carried)? onUpload;

  @override
  State<_SaveModsBody> createState() => _SaveModsBodyState();
}

class _SaveModsBodyState extends State<_SaveModsBody> {
  final _prefs = ModPrefs.instance;
  bool _uploading = false;

  List<ModInfo> get _carried => [
    for (final m in widget.mods)
      if (m.kind != ModKind.invalid &&
          _prefs.carries(widget.folderName, m.key))
        m,
  ];

  Future<void> _upload() async {
    final carried = _carried;
    if (_uploading || carried.isEmpty || widget.onUpload == null) return;
    setState(() => _uploading = true);
    try {
      await widget.onUpload!(carried);
    } finally {
      if (mounted) setState(() => _uploading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final sub = l10n.modsDialogSubtitle(
      widget.mods.length,
      widget.smapiVersion ?? '?',
    );
    return dialogBody(
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.modsDialogTitle(widget.farmName),
            style: GoogleFonts.bodoniModa(
              color: AppColors.text,
              fontStyle: FontStyle.italic,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            sub,
            style: GoogleFonts.firaCode(
              fontSize: 10.5,
              color: AppColors.textMuted,
            ),
          ),
        ],
      ),
      content: ConstrainedBox(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.sizeOf(context).height * 0.55,
        ),
        child: widget.mods.isEmpty
            ? Text(
                l10n.modsDialogEmpty,
                style: GoogleFonts.firaCode(
                  fontSize: 11,
                  color: AppColors.textMuted,
                ),
              )
            : SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    for (var i = 0; i < widget.mods.length; i++)
                      _modRow(widget.mods[i], l10n, first: i == 0),
                    const SizedBox(height: 10),
                    _legend(l10n),
                  ],
                ),
              ),
      ),
      actions: [
        if (widget.onUpload != null && _carried.isNotEmpty)
          ActionBtn(
            label: _uploading
                ? l10n.modsUploading
                : l10n.modsUploadAction(_carried.length),
            color: _gold,
            icon: Icons.cloud_upload_outlined,
            filled: true,
            onTap: _uploading ? null : _upload,
          ),
        ActionBtn(
          label: l10n.modsDialogClose,
          autofocus: true,
          color: Colors.white.withValues(alpha: 0.55),
          filled: false,
          onTap: () => Navigator.pop(context),
        ),
      ],
    );
  }

  Widget _modRow(ModInfo mod, AppLocalizations l10n, {required bool first}) {
    final carries = _prefs.carries(widget.folderName, mod.key);
    final invalid = mod.kind == ModKind.invalid;
    final kindLabel = switch (mod.kind) {
      ModKind.csharp => l10n.modKindCode,
      ModKind.contentPack => l10n.modKindContent,
      ModKind.invalid => l10n.modKindInvalid,
    };
    final meta = [
      'v${mod.version}',
      if (mod.author.isNotEmpty) mod.author,
      kindLabel,
    ].join(' · ');

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
          _check(
            on: carries && !invalid,
            size: 16,
            onTap: invalid
                ? null
                : () async {
                    await _prefs.setCarries(
                      widget.folderName,
                      mod.key,
                      !carries,
                    );
                    if (mounted) setState(() {});
                  },
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  mod.name,
                  style: GoogleFonts.firaCode(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: AppColors.text,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  meta,
                  style: GoogleFonts.firaCode(
                    fontSize: 9.5,
                    color: AppColors.textFaint,
                  ),
                ),
                if (!invalid) ...[
                  const SizedBox(height: 6),
                  Wrap(
                    spacing: 12,
                    runSpacing: 4,
                    children: [
                      _miniCheck(
                        l10n.modAlwaysCarry,
                        _prefs.alwaysCarry(mod.key),
                        (v) => _prefs.setAlwaysCarry(mod.key, v),
                      ),
                      if (mod.hasConfig)
                        _miniCheck(
                          l10n.modWithConfig,
                          _prefs.includeConfig(mod.key),
                          (v) => _prefs.setIncludeConfig(mod.key, v),
                        ),
                    ],
                  ),
                ],
              ],
            ),
          ),
          const SizedBox(width: 8),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              _compatPill(
                'PC',
                ModScanner.pcCompat(mod, widget.smapiVersion),
              ),
              const SizedBox(height: 3),
              _compatPill('Android', ModScanner.androidCompat(mod)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _miniCheck(
    String label,
    bool value,
    Future<void> Function(bool) onChanged,
  ) {
    return InkWell(
      onTap: () async {
        await onChanged(!value);
        if (mounted) setState(() {});
      },
      borderRadius: BorderRadius.circular(4),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _check(on: value, size: 12),
          const SizedBox(width: 4),
          Text(
            label,
            style: GoogleFonts.firaCode(
              fontSize: 9.5,
              color: AppColors.textMuted,
            ),
          ),
        ],
      ),
    );
  }

  Widget _check({required bool on, required double size, VoidCallback? onTap}) {
    final box = Container(
      width: size,
      height: size,
      margin: EdgeInsets.only(top: size > 12 ? 2 : 0),
      decoration: BoxDecoration(
        color: on ? _gold : Colors.transparent,
        border: Border.all(
          color: on ? _gold : AppColors.textFaint,
          width: 1.5,
        ),
        borderRadius: BorderRadius.circular(size > 12 ? 4 : 3),
      ),
      child: on
          ? Icon(
              Icons.check_rounded,
              size: size - 4,
              color: const Color(0xFF14110A),
            )
          : null,
    );
    if (onTap == null) return box;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(4),
      child: box,
    );
  }

  Widget _compatPill(String platform, ModCompat compat) {
    final (color, mark) = switch (compat) {
      ModCompat.works => (AppColors.statusOk, '✓'),
      ModCompat.mayFail => (AppColors.statusPend, '⚠'),
      ModCompat.unsupported => (AppColors.statusErr, '✗'),
    };
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        border: Border.all(color: color.withValues(alpha: 0.45)),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        '$platform $mark',
        style: GoogleFonts.firaCode(
          fontSize: 8.5,
          fontWeight: FontWeight.w700,
          color: color,
        ),
      ),
    );
  }

  Widget _legend(AppLocalizations l10n) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: _gold.withValues(alpha: 0.07),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(
        l10n.modsCompatLegend,
        style: GoogleFonts.firaCode(
          fontSize: 10,
          height: 1.5,
          color: AppColors.textMuted,
        ),
      ),
    );
  }
}
