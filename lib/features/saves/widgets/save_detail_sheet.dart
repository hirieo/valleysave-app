import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../generated/app_localizations.dart';
import '../../../core/models/save_entry.dart';
import '../../../core/models/save_file.dart';
import '../../../core/theme/app_colors.dart';
import '../save_card.dart';

/// Una cara del detalle (local o Drive) con su identidad y acción.
class _DetailSide {
  const _DetailSide({
    required this.save,
    required this.color,
    required this.icon,
    required this.title,
    required this.actionLabel,
    required this.actionIcon,
    required this.onAction,
    this.onDelete,
    this.deleteLabel = '',  // will be set by caller
  });
  final SaveFile save;
  final Color color;
  final String icon;
  final String title;
  final String actionLabel;
  final IconData actionIcon;
  final VoidCallback? onAction;
  final VoidCallback? onDelete;
  final String deleteLabel;
}

/// Hoja inferior con los stats completos de una versión, con título de la cara,
/// swipe entre local↔Drive (si existen ambas) y la acción propia de cada una.
void showSaveDetail(
  BuildContext context, {
  required SaveEntry entry,
  required bool startOnLocal,
  VoidCallback? onUpload,
  VoidCallback? onDownload,
  VoidCallback? onDeleteFromDrive,
  VoidCallback? onDeleteLocal,
}) {
  final l10n = AppLocalizations.of(context)!;
  final isMobile = Platform.isAndroid || Platform.isIOS;

  // Caras presentes — local primero, Drive después.
  final sides = <_DetailSide>[
    if (entry.local != null)
      _DetailSide(
        save: entry.local!,
        color: kLocal,
        icon: isMobile ? '📱' : '💻',
        title: l10n.cardDetailLocalTitle,
        actionLabel: l10n.cardDetailUpload,
        actionIcon: Icons.cloud_upload_outlined,
        onAction: onUpload,
        onDelete: onDeleteLocal,
        deleteLabel: l10n.cardDetailDeleteLocal,
      ),
    if (entry.drive != null)
      _DetailSide(
        save: entry.drive!,
        color: kDrive,
        icon: '☁️',
        title: l10n.cardDetailRemoteTitle,
        actionLabel: l10n.cardDetailDownload,
        actionIcon: Icons.cloud_download_outlined,
        onAction: onDownload,
        onDelete: onDeleteFromDrive,
        deleteLabel: l10n.cardDetailDeleteRemote,
      ),
  ];
  if (sides.isEmpty) return;

  // startOnLocal → primera (local si existe); si no, la última (Drive).
  final initialPage = (startOnLocal ? 0 : sides.length - 1).clamp(0, sides.length - 1);

  showGeneralDialog<void>(
    context: context,
    barrierDismissible: true,
    barrierLabel: l10n.cardCloseBarrier,
    barrierColor: Colors.black.withValues(alpha: 0.70),
    transitionDuration: const Duration(milliseconds: 260),
    transitionBuilder: (ctx, animation, _, child) {
      const curve = Cubic(0.23, 1, 0.32, 1);
      final curved = CurvedAnimation(parent: animation, curve: curve);
      return FadeTransition(
        opacity: curved,
        child: ScaleTransition(
          scale: Tween<double>(begin: 0.96, end: 1.0).animate(curved),
          child: child,
        ),
      );
    },
    pageBuilder: (ctx, anim, secAnim) => Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 40),
      child: _DetailSheet(sides: sides, initialPage: initialPage),
    ),
  );
}

class _DetailSheet extends StatefulWidget {
  const _DetailSheet({required this.sides, required this.initialPage});
  final List<_DetailSide> sides;
  final int initialPage;

  @override
  State<_DetailSheet> createState() => _DetailSheetState();
}

class _DetailSheetState extends State<_DetailSheet> {
  late int _index = widget.initialPage;
  int _direction = 1;
  bool _leftPressed = false;
  bool _rightPressed = false;
  final _focusNode = FocusNode();

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  void _navigate(int delta) {
    final next = _index + delta;
    if (next >= 0 && next < widget.sides.length) {
      setState(() {
        _direction = delta > 0 ? 1 : -1;
        _index = next;
      });
    }
  }

  Widget _navArrow(IconData icon,
      {required bool enabled,
      required Color color,
      required bool pressed,
      required VoidCallback onTap,
      required ValueChanged<bool> onPressChange}) {
    return GestureDetector(
      onTap: enabled ? onTap : null,
      onTapDown: enabled ? (_) => onPressChange(true) : null,
      onTapUp: (_) => onPressChange(false),
      onTapCancel: () => onPressChange(false),
      child: AnimatedScale(
        scale: (enabled && pressed) ? 0.88 : 1.0,
        duration: (enabled && pressed)
            ? const Duration(milliseconds: 100)
            : const Duration(milliseconds: 200),
        curve: const Cubic(0.23, 1, 0.32, 1),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeOut,
          width: 28,
          height: 28,
          decoration: BoxDecoration(
            color: enabled ? color.withValues(alpha: 0.14) : Colors.transparent,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: enabled
                  ? color.withValues(alpha: 0.40)
                  : Colors.white.withValues(alpha: 0.10),
            ),
          ),
          child: Icon(
            icon,
            size: 16,
            color: enabled
                ? color.withValues(alpha: 0.90)
                : Colors.white.withValues(alpha: 0.20),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final sides = widget.sides;
    final active = sides[_index];
    final maxH = MediaQuery.of(context).size.height * 0.90;

    return Focus(
      focusNode: _focusNode,
      autofocus: true,
      onKeyEvent: (_, event) {
        if (event is! KeyDownEvent) return KeyEventResult.ignored;
        if (event.logicalKey == LogicalKeyboardKey.arrowLeft) {
          _navigate(-1);
          return KeyEventResult.handled;
        }
        if (event.logicalKey == LogicalKeyboardKey.arrowRight) {
          _navigate(1);
          return KeyEventResult.handled;
        }
        return KeyEventResult.ignored;
      },
      child: ConstrainedBox(
      constraints: BoxConstraints(maxHeight: maxH, maxWidth: 420),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(18),
        child: Container(
          decoration: BoxDecoration(
            color: Color.alphaBlend(
              active.color.withValues(alpha: 0.06),
              const Color(0xFF0B0B0D),
            ),
            border: Border.all(
              color: active.color.withValues(alpha: 0.55),
              width: 1.5,
            ),
          ),
          child: SafeArea(
            top: false,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(height: 10),
                Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.20),
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                if (sides.length > 1) ...[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _navArrow(
                        Icons.chevron_left_rounded,
                        enabled: _index > 0,
                        color: sides[0].color,
                        pressed: _leftPressed,
                        onTap: () => _navigate(-1),
                        onPressChange: (v) => setState(() => _leftPressed = v),
                      ),
                      const SizedBox(width: 12),
                      ...List.generate(sides.length, (i) {
                        final on = i == _index;
                        final c = sides[i].color;
                        return AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          curve: Curves.easeOut,
                          margin: const EdgeInsets.symmetric(horizontal: 3),
                          width: on ? 18 : 6,
                          height: 6,
                          decoration: BoxDecoration(
                            color: on ? c : c.withValues(alpha: 0.35),
                            borderRadius: BorderRadius.circular(3),
                          ),
                        );
                      }),
                      const SizedBox(width: 12),
                      _navArrow(
                        Icons.chevron_right_rounded,
                        enabled: _index < sides.length - 1,
                        color: sides[sides.length - 1].color,
                        pressed: _rightPressed,
                        onTap: () => _navigate(1),
                        onPressChange: (v) => setState(() => _rightPressed = v),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                ],
                Flexible(
                child: GestureDetector(
                  onHorizontalDragEnd: (details) {
                    final v = details.primaryVelocity ?? 0;
                    if (v < -100 && _index < sides.length - 1) { _navigate(1); }
                    else if (v > 100 && _index > 0) { _navigate(-1); }
                  },
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 260),
                    transitionBuilder: (child, animation) {
                      const curve = Cubic(0.23, 1, 0.32, 1);
                      final isNew = child.key == ValueKey(_index);
                      final dir = _direction.toDouble();
                      return FadeTransition(
                        opacity: CurvedAnimation(parent: animation, curve: curve),
                        child: SlideTransition(
                          position: Tween<Offset>(
                            begin: isNew ? Offset(dir * 0.08, 0) : Offset(-dir * 0.08, 0),
                            end: Offset.zero,
                          ).animate(CurvedAnimation(parent: animation, curve: curve)),
                          child: child,
                        ),
                      );
                    },
                    layoutBuilder: (current, previous) => Stack(
                      alignment: Alignment.topCenter,
                      children: [...previous, ?current],
                    ),
                    child: KeyedSubtree(
                      key: ValueKey(_index),
                      child: _DetailPage(side: active),
                    ),
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

class _DetailPage extends StatelessWidget {
  const _DetailPage({required this.side});
  final _DetailSide side;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final s = side.save;
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Flexible(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(14, 8, 14, 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(side.icon, style: const TextStyle(fontSize: 14)),
                          const SizedBox(width: 7),
                          Text(
                            side.title.toUpperCase(),
                            style: GoogleFonts.firaCode(
                              fontSize: 10,
                              letterSpacing: 1.0,
                              fontWeight: FontWeight.w700,
                              color: side.color,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        s.farmName,
                        style: GoogleFonts.bodoniModa(
                          fontSize: 24,
                          fontStyle: FontStyle.italic,
                          fontWeight: FontWeight.w700,
                          color: AppColors.text,
                          height: 1,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        l10n.statDayYear(s.dayOfMonth, s.year),
                        style: GoogleFonts.firaCode(
                          fontSize: 11,
                          color: s.seasonColor.withValues(alpha: 0.90),
                        ),
                      ),
                    ],
                  ),
                ),
                kDivider,
                SaveStatsView(save: s),
              ],
            ),
          ),
        ),
        if (side.onAction != null || side.onDelete != null) ...[
          kDivider,
          if (side.onAction != null)
            Padding(
              padding: EdgeInsets.fromLTRB(
                  14, 12, 14, side.onDelete != null ? 6 : 14),
              child: GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                  side.onAction!.call();
                },
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 13),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: side.color.withValues(alpha: 0.16),
                    border:
                        Border.all(color: side.color.withValues(alpha: 0.55)),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(side.actionIcon, size: 16, color: side.color),
                      const SizedBox(width: 7),
                      Text(
                        side.actionLabel,
                        style: GoogleFonts.firaCode(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: side.color,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          if (side.onDelete != null)
            Padding(
              padding: const EdgeInsets.fromLTRB(14, 0, 14, 14),
              child: GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                  side.onDelete!.call();
                },
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: const Color(0xFFE05252).withValues(alpha: 0.08),
                    border: Border.all(
                        color: const Color(0xFFE05252).withValues(alpha: 0.30)),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.delete_outline_rounded,
                          size: 14, color: Color(0xFFE05252)),
                      const SizedBox(width: 6),
                      Text(
                        side.deleteLabel,
                        style: GoogleFonts.firaCode(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: const Color(0xFFE05252),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
        ],
      ],
    );
  }
}
