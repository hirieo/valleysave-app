import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../generated/app_localizations.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../shared/widgets/glass_dialog.dart';
import '../../../shared/widgets/pressable_scale.dart';

Widget flagView(String flag, double size) {
  if (flag.startsWith('assets/')) {
    if (Platform.isAndroid || Platform.isIOS) {
      return SvgPicture.asset(flag, width: size * 1.5, height: size);
    }
    final code = flag.split('/').last.split('.').first.toUpperCase();
    return Text(code, style: TextStyle(fontSize: size));
  }
  return Text(flag, style: TextStyle(fontSize: size));
}

class LanguageDialog extends StatefulWidget {
  const LanguageDialog({
    super.key,
    required this.current,
    required this.langs,
    required this.onSelect,
    required this.langMatch,
    required this.accent,
    required this.l10n,
  });

  final Locale? current;
  final List<(Locale?, String, String)> langs;
  final void Function(Locale?) onSelect;
  final bool Function(Locale?, Locale?) langMatch;
  final Color accent;
  final AppLocalizations l10n;

  @override
  State<LanguageDialog> createState() => _LanguageDialogState();
}

class _LanguageDialogState extends State<LanguageDialog>
    with SingleTickerProviderStateMixin {
  final _search = TextEditingController();
  String _query = '';
  late final AnimationController _staggerCtrl;

  @override
  void initState() {
    super.initState();
    _staggerCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    )..forward();
  }

  @override
  void dispose() {
    _search.dispose();
    _staggerCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final filtered = widget.langs.where((e) {
      if (_query.isEmpty) return true;
      final label = e.$1 == null ? widget.l10n.languageAuto : e.$3;
      return label.toLowerCase().contains(_query);
    }).toList();

    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 32, vertical: 48),
      child: glassDialogShell(
        context,
        maxWidth: 340,
        accent: widget.accent,
        // Selector de lista: quiere ir pegado a los bordes (su propia
        // cabecera y la lista ya traen su padding), no el hueco pensado
        // para título+cuerpo+acciones de un diálogo de confirmación.
        padding: EdgeInsets.zero,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 14, 12, 10),
                child: Row(
                  children: [
                    Text(
                      widget.l10n.languageDialogTitle.toUpperCase(),
                      style: AppTypography.eyebrow(),
                    ),
                    const Spacer(),
                    PressableScale(
                      onTap: () => Navigator.pop(context),
                      semanticLabel: widget.l10n.cancel,
                      child: Icon(
                        Icons.close_rounded,
                        size: 18,
                        color: AppColors.textFaint,
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: 0.40),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: Colors.white.withValues(alpha: 0.10),
                    ),
                  ),
                  child: Row(
                    children: [
                      const SizedBox(width: 12),
                      Icon(
                        Icons.search_rounded,
                        size: 16,
                        color: AppColors.textFaint,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: TextField(
                          controller: _search,
                          onChanged: (v) =>
                              setState(() => _query = v.toLowerCase()),
                          style: AppTypography.body(color: AppColors.text),
                          decoration: InputDecoration(
                            hintText: widget.l10n.searchHint,
                            hintStyle: AppTypography.body(
                              color: AppColors.textFaint,
                            ),
                            border: InputBorder.none,
                            contentPadding: const EdgeInsets.symmetric(
                              vertical: 10,
                            ),
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
                ),
              ),
              const SizedBox(height: 4),
              ConstrainedBox(
                constraints: BoxConstraints(
                  maxHeight: MediaQuery.of(context).size.height * 0.45,
                ),
                child: ListView.builder(
                  shrinkWrap: true,
                  padding: const EdgeInsets.fromLTRB(8, 2, 8, 12),
                  itemCount: filtered.length,
                  itemBuilder: (_, i) {
                    final (locale, flag, label) = filtered[i];
                    final selected = widget.langMatch(widget.current, locale);
                    return _LangRow(
                      flag: flag,
                      label: locale == null ? widget.l10n.languageAuto : label,
                      isAuto: locale == null,
                      selected: selected,
                      accent: widget.accent,
                      staggerIndex: i,
                      staggerCtrl: _staggerCtrl,
                      onTap: () => widget.onSelect(locale),
                      l10n: widget.l10n,
                    );
                  },
                ),
              ),
            ],
          ),
        ),
    );
  }
}

class _LangRow extends StatefulWidget {
  const _LangRow({
    required this.flag,
    required this.label,
    required this.isAuto,
    required this.selected,
    required this.accent,
    required this.staggerIndex,
    required this.staggerCtrl,
    required this.onTap,
    required this.l10n,
  });

  final String flag;
  final String label;
  final bool isAuto;
  final bool selected;
  final Color accent;
  final int staggerIndex;
  final AnimationController staggerCtrl;
  final VoidCallback onTap;
  final AppLocalizations l10n;

  @override
  State<_LangRow> createState() => _LangRowState();
}

class _LangRowState extends State<_LangRow> {
  bool _pressed = false;
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final start = (widget.staggerIndex * 0.06).clamp(0.0, 0.9);
    final end = (start + 0.50).clamp(start + 0.1, 1.0);
    final staggerAnim = CurvedAnimation(
      parent: widget.staggerCtrl,
      curve: Interval(start, end, curve: const Cubic(0.23, 1, 0.32, 1)),
    );

    return AnimatedBuilder(
      animation: staggerAnim,
      builder: (_, child) => Opacity(
        opacity: staggerAnim.value,
        child: Transform.translate(
          offset: Offset(0, 5 * (1 - staggerAnim.value)),
          child: child,
        ),
      ),
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        onEnter: (_) => setState(() => _hovered = true),
        onExit: (_) => setState(() => _hovered = false),
        child: GestureDetector(
        onTap: widget.onTap,
        onTapDown: (_) => setState(() => _pressed = true),
        onTapUp: (_) => setState(() => _pressed = false),
        onTapCancel: () => setState(() => _pressed = false),
        child: AnimatedScale(
          scale: _pressed ? 0.985 : (_hovered ? 1.01 : 1.0),
          duration: _pressed
              ? const Duration(milliseconds: 80)
              : const Duration(milliseconds: 200),
          curve: const Cubic(0.23, 1, 0.32, 1),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 160),
            curve: Curves.easeOut,
            margin: const EdgeInsets.symmetric(vertical: 2),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 13),
            decoration: BoxDecoration(
              color: widget.selected
                  ? widget.accent.withValues(alpha: 0.10)
                  : _pressed
                  ? Colors.white.withValues(alpha: 0.04)
                  : _hovered
                  ? Colors.white.withValues(alpha: 0.03)
                  : Colors.transparent,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              children: [
                flagView(widget.flag, 18),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.label,
                        style: AppTypography.bodyStrong(
                          color: widget.selected
                              ? widget.accent
                              : AppColors.text,
                        ),
                      ),
                      if (widget.isAuto)
                        Text(
                          widget.l10n.languageAutoDesc,
                          style: AppTypography.mono(
                            color: AppColors.textFaint,
                            size: 11,
                          ),
                        ),
                    ],
                  ),
                ),
                AnimatedOpacity(
                  opacity: widget.selected ? 1.0 : 0.0,
                  duration: const Duration(milliseconds: 180),
                  child: AnimatedScale(
                    scale: widget.selected ? 1.0 : 0.5,
                    duration: const Duration(milliseconds: 200),
                    curve: const Cubic(0.23, 1, 0.32, 1),
                    child: Icon(
                      Icons.check_rounded,
                      size: 18,
                      color: widget.accent,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        ),
      ),
    );
  }
}
