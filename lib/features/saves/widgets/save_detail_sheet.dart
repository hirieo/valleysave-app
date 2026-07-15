import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../generated/app_localizations.dart';
import '../../../core/models/player_stats.dart';
import '../../../core/models/save_entry.dart';
import '../../../core/models/save_file.dart';
import '../../../core/theme/app_colors.dart';
import '../save_card.dart';

enum SaveDetailLocation { local, drive, extraDrive }

/// Resuelve la misma persona en copias donde el cambio de anfitrión alteró el
/// orden de `players`. `UniqueMultiplayerID` es estable; el índice no lo es.
int playerIndexForId(SaveFile save, String? playerId, {int fallbackIndex = 0}) {
  if (save.players.isEmpty) return 0;
  if (playerId != null && playerId.isNotEmpty) {
    final matched = save.players.indexWhere((p) => p.uniqueId == playerId);
    if (matched >= 0) return matched;
  }
  return fallbackIndex.clamp(0, save.players.length - 1);
}

/// Una cara del detalle (local o Drive) con su identidad y acción.
class _DetailSide {
  const _DetailSide({
    required this.location,
    required this.save,
    required this.color,
    required this.icon,
    required this.title,
    required this.actionLabel,
    required this.actionIcon,
    required this.onAction,
    this.onDelete,
    this.onMakeHost,
    this.onExport,
    this.onShare,
    this.onBackups,
    this.backupCount = 0,
    this.onRemove,
    this.removeLabel = '',
  });
  final SaveDetailLocation location;
  final SaveFile save;
  final Color color;
  final String icon;
  final String title;
  final String actionLabel;
  final IconData actionIcon;
  final VoidCallback? onAction;
  final VoidCallback? onDelete;

  /// US5 — "Quitar de la lista" (deja de rastrear el save compartido, no
  /// borra nada en Drive). Se presenta como acción naranja diferenciada:
  /// afecta a la relación de sincronización, no a los datos del propietario.
  final VoidCallback? onRemove;
  final String removeLabel;

  /// Cambio de anfitrión (F3) — solo la cara LOCAL lo recibe (nunca Drive).
  final void Function(PlayerStats target)? onMakeHost;

  /// Exportar a archivo (F1) — solo la cara LOCAL lo recibe (nunca Drive).
  final VoidCallback? onExport;

  /// Compartir por email (F2) — solo en la cara de Mi Drive. Una copia local
  /// por sí sola no se puede compartir mediante la API de Drive.
  final VoidCallback? onShare;

  /// Respaldos pre-swap (spec 007) — solo la cara LOCAL, solo si hay al
  /// menos uno (el caller decide, ver `backupCount`).
  final VoidCallback? onBackups;
  final int backupCount;
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
  void Function(PlayerStats target)? onMakeHost,
  VoidCallback? onExport,
  VoidCallback? onShare,
  VoidCallback? onBackups,
  int backupCount = 0,
  bool backupsOnRemote = false,
  int initialPlayerIndex = 0,
  ValueChanged<int>? onPlayerIndexChanged,
  String? initialPlayerId,
  ValueChanged<String>? onPlayerIdChanged,
  SaveDetailLocation? initialLocation,
  String? localActionLabel,
  // US5 — un save compartido tiene DOS Drives posibles en juego (el del
  // dueño y el propio); "EN DRIVE" a secas es ambiguo entre ambas vistas.
  // El caller (SharedSaveCard) sobrescribe con "DRIVE EN {email}" / "MI
  // DRIVE" — en saves propios se queda sin usar y sale el genérico de
  // siempre.
  String? driveTitle,
  // Mismo caso: el color de la cara Drive es fijo (kDrive) salvo que el
  // caller lo sobrescriba — "Drive del dueño" usa morado en vez de azul
  // en toda la tarjeta compartida, esta cara no es la excepción.
  Color? driveColor,
  // US5 — "Quitar de la lista" (deja de rastrear el compartido). Solo se
  // muestra en la cara del Drive del dueño: es el origen de esa relación.
  VoidCallback? onRemove,
  String? removeLabel,
  // Tercera cara opcional. En compartidas se usa con `entry.asOwnEntry`:
  // local → Mi Drive → Drive del dueño.
  SaveFile? extraDrive,
  String? extraDriveTitle,
  Color? extraDriveColor,
  VoidCallback? onExtraDownload,
}) {
  final l10n = AppLocalizations.of(context)!;
  final isMobile = Platform.isAndroid || Platform.isIOS;

  // Caras presentes — local primero, Drive después.
  final sides = <_DetailSide>[
    if (entry.local != null)
      _DetailSide(
        location: SaveDetailLocation.local,
        save: entry.local!,
        color: kLocal,
        icon: isMobile ? '📱' : '💻',
        title: l10n.cardDetailLocalTitle,
        actionLabel: localActionLabel ?? l10n.cardDetailUpload,
        actionIcon: Icons.cloud_upload_outlined,
        onAction: onUpload,
        onDelete: onDeleteLocal,
        onMakeHost: onMakeHost, // solo la cara local — nunca Drive
        onExport: onExport, // solo la cara local — nunca Drive
        onBackups: onBackups, // solo la cara local — nunca Drive
        backupCount: backupCount,
      ),
    if (entry.drive != null)
      _DetailSide(
        location: SaveDetailLocation.drive,
        save: entry.drive!,
        color: driveColor ?? kDrive,
        icon: '☁️',
        title: driveTitle ?? l10n.cardDetailRemoteTitle,
        actionLabel: l10n.cardDetailDownload,
        actionIcon: Icons.cloud_download_outlined,
        onAction: onDownload,
        onDelete: onDeleteFromDrive,
        onShare: onShare,
        onBackups: backupsOnRemote ? onBackups : null,
        backupCount: backupCount,
      ),
    if (extraDrive != null)
      _DetailSide(
        location: SaveDetailLocation.extraDrive,
        save: extraDrive,
        color: extraDriveColor ?? kDrive,
        icon: '🔗',
        title: extraDriveTitle ?? l10n.cardDetailRemoteTitle,
        actionLabel: l10n.cardDetailDownload,
        actionIcon: Icons.cloud_download_outlined,
        onAction: onExtraDownload,
        onBackups: backupsOnRemote ? onBackups : null,
        backupCount: backupCount,
        onRemove: onRemove,
        removeLabel: removeLabel ?? '',
      ),
  ];
  if (sides.isEmpty) return;

  // startOnLocal → primera (local si existe); si no, la última (Drive).
  final targetLocation =
      initialLocation ??
      (startOnLocal ? SaveDetailLocation.local : SaveDetailLocation.drive);
  final requestedPage = sides.indexWhere(
    (side) => side.location == targetLocation,
  );
  final initialPage = requestedPage >= 0
      ? requestedPage
      : (startOnLocal ? 0 : sides.length - 1).clamp(0, sides.length - 1);

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
      child: _DetailSheet(
        sides: sides,
        initialPage: initialPage,
        initialPlayerIndex: initialPlayerIndex,
        onPlayerIndexChanged: onPlayerIndexChanged,
        initialPlayerId: initialPlayerId,
        onPlayerIdChanged: onPlayerIdChanged,
      ),
    ),
  );
}

class _DetailSheet extends StatefulWidget {
  const _DetailSheet({
    required this.sides,
    required this.initialPage,
    this.initialPlayerIndex = 0,
    this.onPlayerIndexChanged,
    this.initialPlayerId,
    this.onPlayerIdChanged,
  });
  final List<_DetailSide> sides;
  final int initialPage;
  final int initialPlayerIndex;
  final ValueChanged<int>? onPlayerIndexChanged;
  final String? initialPlayerId;
  final ValueChanged<String>? onPlayerIdChanged;

  @override
  State<_DetailSheet> createState() => _DetailSheetState();
}

class _DetailSheetState extends State<_DetailSheet>
    with SingleTickerProviderStateMixin {
  late int _index = widget.initialPage;
  int _direction = 1;
  bool _leftPressed = false;
  bool _rightPressed = false;
  // Compartido entre local y Drive: cambiar de jugador mueve las dos caras
  // aunque solo una esté visible en cada momento. Se siembra con lo que ya
  // estaba seleccionado en la tarjeta (y se propaga de vuelta al cambiar
  // aquí) para que abrir la OTRA cara no lo resetee (feedback 2026-07-12).
  late int _fallbackPlayerIndex = widget.initialPlayerIndex;
  late String? _selectedPlayerId =
      widget.initialPlayerId ??
      _playerIdAt(
        widget.sides[widget.initialPage].save,
        widget.initialPlayerIndex,
      );
  final _focusNode = FocusNode();

  // Entrada escalonada de los botones de acción: corre UNA vez al abrir la
  // hoja. Al completarse queda en 1.0, así los rebuilds por cambio de jugador
  // no la repiten (los botones quedan visibles sin re-animar).
  late final AnimationController _entrance = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 420),
  )..forward();

  @override
  void dispose() {
    _entrance.dispose();
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

  void _selectPlayer(int i) {
    final players = widget.sides[_index].save.players;
    if (i < 0 || i >= players.length) return;
    final id = players[i].uniqueId;
    setState(() {
      _fallbackPlayerIndex = i;
      _selectedPlayerId = id;
    });
    widget.onPlayerIndexChanged?.call(i);
    if (id.isNotEmpty) widget.onPlayerIdChanged?.call(id);
  }

  static String? _playerIdAt(SaveFile save, int index) {
    if (save.players.isEmpty) return null;
    return save.players[index.clamp(0, save.players.length - 1)].uniqueId;
  }

  Widget _navArrow(
    IconData icon, {
    Key? key,
    required bool enabled,
    required Color color,
    required bool pressed,
    required VoidCallback onTap,
    required ValueChanged<bool> onPressChange,
  }) {
    return StatefulBuilder(
      key: key,
      builder: (_, setHover) {
        bool hovered = false;
        return MouseRegion(
          cursor: enabled ? SystemMouseCursors.click : MouseCursor.defer,
          onEnter: enabled ? (_) => setHover(() => hovered = true) : null,
          onExit: enabled ? (_) => setHover(() => hovered = false) : null,
          child: GestureDetector(
            onTap: enabled ? onTap : null,
            onTapDown: enabled ? (_) => onPressChange(true) : null,
            onTapUp: (_) => onPressChange(false),
            onTapCancel: () => onPressChange(false),
            child: AnimatedScale(
              scale: (enabled && pressed) ? 0.88 : (enabled && hovered ? 1.10 : 1.0),
              duration: (enabled && pressed)
                  ? const Duration(milliseconds: 100)
                  : const Duration(milliseconds: 200),
              curve: const Cubic(0.23, 1, 0.32, 1),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 140),
                curve: Curves.easeOut,
                width: 28,
                height: 28,
                decoration: BoxDecoration(
                  color: enabled
                      ? color.withValues(alpha: hovered ? 0.22 : 0.14)
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(
                    color: enabled
                        ? color.withValues(alpha: hovered ? 0.60 : 0.40)
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
          ),
        );
      },
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
        constraints: BoxConstraints(maxWidth: 420, maxHeight: maxH),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(18),
          child: Container(
            key: const ValueKey('save-detail-sheet'),
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
                  const SizedBox(height: 7),
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
                          key: const ValueKey('save-detail-nav-left'),
                          enabled: _index > 0,
                          color: sides[0].color,
                          pressed: _leftPressed,
                          onTap: () => _navigate(-1),
                          onPressChange: (v) =>
                              setState(() => _leftPressed = v),
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
                          key: const ValueKey('save-detail-nav-right'),
                          enabled: _index < sides.length - 1,
                          color: sides[sides.length - 1].color,
                          pressed: _rightPressed,
                          onTap: () => _navigate(1),
                          onPressChange: (v) =>
                              setState(() => _rightPressed = v),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                  ],
                  Flexible(
                    fit: FlexFit.loose,
                    child: SingleChildScrollView(
                      child: Stack(
                        children: [
                          // El IndexedStack invisible mide TODAS las caras.
                          // Así la hoja usa la altura natural de la más alta
                          // de esta partida, no un 90 % fijo de la ventana.
                          ExcludeSemantics(
                            child: IgnorePointer(
                              child: Opacity(
                                opacity: 0,
                                child: IndexedStack(
                                  index: 0,
                                  children: [
                                    for (final side in sides)
                                      _DetailPage(
                                        side: side,
                                        selectedPlayerId: _selectedPlayerId,
                                        fallbackPlayerIndex:
                                            _fallbackPlayerIndex,
                                        onSelectPlayer: _selectPlayer,
                                        entrance: const AlwaysStoppedAnimation(
                                          1,
                                        ),
                                        fillAvailable: false,
                                      ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          Positioned.fill(
                            child: GestureDetector(
                              onHorizontalDragEnd: (details) {
                                final v = details.primaryVelocity ?? 0;
                                if (v < -100 && _index < sides.length - 1) {
                                  _navigate(1);
                                } else if (v > 100 && _index > 0) {
                                  _navigate(-1);
                                }
                              },
                              child: AnimatedSwitcher(
                                duration: const Duration(milliseconds: 260),
                                transitionBuilder: (child, animation) {
                                  const curve = Cubic(0.23, 1, 0.32, 1);
                                  final isNew = child.key == ValueKey(_index);
                                  final dir = _direction.toDouble();
                                  return FadeTransition(
                                    opacity: CurvedAnimation(
                                      parent: animation,
                                      curve: curve,
                                    ),
                                    child: SlideTransition(
                                      position:
                                          Tween<Offset>(
                                            begin: isNew
                                                ? Offset(dir * 0.08, 0)
                                                : Offset(-dir * 0.08, 0),
                                            end: Offset.zero,
                                          ).animate(
                                            CurvedAnimation(
                                              parent: animation,
                                              curve: curve,
                                            ),
                                          ),
                                      child: child,
                                    ),
                                  );
                                },
                                layoutBuilder: (current, previous) => Stack(
                                  fit: StackFit.expand,
                                  alignment: Alignment.topCenter,
                                  children: [...previous, ?current],
                                ),
                                child: KeyedSubtree(
                                  key: ValueKey(
                                    'save-detail-${active.location.name}',
                                  ),
                                  child: _DetailPage(
                                    side: active,
                                    selectedPlayerId: _selectedPlayerId,
                                    fallbackPlayerIndex: _fallbackPlayerIndex,
                                    onSelectPlayer: _selectPlayer,
                                    entrance: _entrance,
                                    fillAvailable: true,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
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
  const _DetailPage({
    required this.side,
    required this.selectedPlayerId,
    required this.fallbackPlayerIndex,
    required this.onSelectPlayer,
    required this.entrance,
    required this.fillAvailable,
  });
  final _DetailSide side;
  final String? selectedPlayerId;
  final int fallbackPlayerIndex;
  final ValueChanged<int> onSelectPlayer;
  final Animation<double> entrance;
  final bool fillAvailable;

  @override
  Widget build(BuildContext context) {
    final base = side.save;
    final coop = base.hasMultiplePlayers;
    final idx = coop
        ? playerIndexForId(
            base,
            selectedPlayerId,
            fallbackIndex: fallbackPlayerIndex,
          )
        : 0;
    final s = coop ? base.forPlayer(base.players[idx]) : base;
    final hostSelected = coop && base.players[idx].isHost;

    final baseContent = Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(14, 6, 14, 7),
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
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Flexible(
                          child: Text(
                            s.farmName,
                            style: GoogleFonts.bodoniModa(
                              fontSize: 24,
                              fontStyle: FontStyle.italic,
                              fontWeight: FontWeight.w700,
                              color: AppColors.text,
                              height: 1,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        if (coop) ...[
                          const SizedBox(width: 8),
                          const CoopBadge(),
                        ],
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      if (hostSelected) ...[
                        const HostCrown(),
                        const SizedBox(width: 8),
                      ],
                      DateBox(save: s),
                    ],
                  ),
                ],
              ),
              if (coop) ...[
                const SizedBox(height: 10),
                PlayerNameLabel(
                  name: s.playerName,
                  gender: s.genderLabel,
                  isHost: hostSelected,
                ),
                const SizedBox(height: 6),
                PlayerSwitcher(
                  count: base.players.length,
                  index: idx,
                  hostIndex: base.players.indexWhere((p) => p.isHost),
                  onSelect: onSelectPlayer,
                ),
              ],
            ],
          ),
        ),
        kDivider,
        SaveStatsView(save: s),
      ],
    );
    final actions = _buildActions(
      context,
      coop: coop,
      hostSelected: hostSelected,
      base: base,
      idx: idx,
    );
    final hasActions =
        side.onAction != null ||
        side.onShare != null ||
        side.onExport != null ||
        side.onBackups != null ||
        side.onDelete != null ||
        side.onRemove != null ||
        (coop && !hostSelected && side.onMakeHost != null);

    if (!fillAvailable) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [baseContent, if (hasActions) actions],
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        baseContent,
        if (hasActions) Expanded(child: Center(child: actions)),
      ],
    );
  }

  /// Región de acciones — Option A (aprobada 2026-07-11): 1 botón principal
  /// (la dirección de sync de esta cara), fila de acciones secundarias con
  /// icono, y una acción destructiva/contextual con el mismo lenguaje visual.
  /// Entrada escalonada + press a través de [_Pressable].
  Widget _buildActions(
    BuildContext context, {
    required bool coop,
    required bool hostSelected,
    required SaveFile base,
    required int idx,
  }) {
    final l10n = AppLocalizations.of(context)!;
    final makeHostVisible =
        coop &&
        !hostSelected &&
        side.onMakeHost != null &&
        base.players[idx].name.isNotEmpty;

    final secondary = <Widget>[
      if (side.onShare != null)
        _SecondaryAction(
          icon: Icons.person_add_alt_1_rounded,
          label: l10n.shareAction,
          onTap: () {
            Navigator.pop(context);
            side.onShare!.call();
          },
        ),
      if (side.onExport != null)
        _SecondaryAction(
          icon: Icons.ios_share_rounded,
          label: l10n.exportAction,
          onTap: () {
            Navigator.pop(context);
            side.onExport!.call();
          },
        ),
      if (makeHostVisible)
        _SecondaryAction(
          icon: Icons.workspace_premium_rounded,
          label: l10n.makeHostAction,
          experimental: true,
          onTap: () {
            final target = base.players[idx];
            Navigator.pop(context);
            side.onMakeHost!(target);
          },
        ),
      if (side.onBackups != null)
        _SecondaryAction(
          icon: Icons.inventory_2_outlined,
          label: l10n.backupsAction,
          badgeCount: side.backupCount,
          accentColor: const Color(0xFF97C459),
          onTap: () {
            Navigator.pop(context);
            side.onBackups!.call();
          },
        ),
      if (side.onDelete != null)
        _SecondaryAction(
          key: ValueKey('save-detail-delete-${side.location.name}'),
          icon: Icons.delete_outline_rounded,
          label: l10n.cardDetailDeleteLabel,
          accentColor: const Color(0xFFE05252),
          onTap: () {
            Navigator.pop(context);
            side.onDelete!.call();
          },
        ),
    ];

    // Índices de stagger: primario = 0 y la fila secundaria completa sigue.
    var staggerIndex = 0;
    final children = <Widget>[];

    if (side.onAction != null) {
      children.add(
        _stagger(
          staggerIndex++,
          _Pressable(
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
                border: Border.all(color: side.color.withValues(alpha: 0.55)),
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
      );
    }

    if (secondary.isNotEmpty) {
      children.add(const SizedBox(height: 8));
      children.add(
        _stagger(
          staggerIndex++,
          Row(
            children: [
              for (var i = 0; i < secondary.length; i++) ...[
                if (i > 0) const SizedBox(width: 7),
                Expanded(child: secondary[i]),
              ],
            ],
          ),
        ),
      );
    }

    if (side.onRemove != null) {
      children.add(const SizedBox(height: 10));
      children.add(
        _stagger(
          staggerIndex++,
          _DestructiveAction(
            key: const ValueKey('save-detail-remove-extraDrive'),
            icon: Icons.sync_disabled_rounded,
            label: side.removeLabel,
            color: const Color(0xFFE8783A),
            onTap: () {
              Navigator.pop(context);
              side.onRemove!.call();
            },
          ),
        ),
      );
    }

    if (children.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        kDivider,
        Padding(
          padding: const EdgeInsets.fromLTRB(14, 12, 14, 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: children,
          ),
        ),
      ],
    );
  }

  /// Aparición en cascada: opacidad + leve subida, con retraso creciente por
  /// índice. [entrance] corre una sola vez (ver `_DetailSheetState`); tras
  /// completarse, `value == 1` y no se re-anima al cambiar de jugador.
  Widget _stagger(int i, Widget child) {
    final start = (i * 0.12).clamp(0.0, 0.5);
    final anim = CurvedAnimation(
      parent: entrance,
      curve: Interval(
        start,
        (start + 0.5).clamp(0.0, 1.0),
        curve: const Cubic(0.23, 1, 0.32, 1),
      ),
    );
    return AnimatedBuilder(
      animation: anim,
      builder: (_, c) => Opacity(
        opacity: anim.value.clamp(0.0, 1.0),
        child: Transform.translate(
          offset: Offset(0, 8 * (1 - anim.value)),
          child: c,
        ),
      ),
      child: child,
    );
  }
}

/// Acción de borrado/desvinculación coherente con los botones principales:
/// fondo tintado, borde visible, icono real y feedback de presión 0.97.
class _DestructiveAction extends StatelessWidget {
  const _DestructiveAction({
    super.key,
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return _Pressable(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 12),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.08),
          border: Border.all(color: color.withValues(alpha: 0.52)),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 17, color: color),
            const SizedBox(width: 7),
            Flexible(
              child: Text(
                label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: GoogleFonts.firaCode(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: color,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Botón secundario compacto (icono + etiqueta apilados) para la fila de
/// acciones de la hoja de detalle. Dorado como el resto de acciones; marca
/// `experimental` para un punto de aviso discreto (host-swap).
class _SecondaryAction extends StatelessWidget {
  const _SecondaryAction({
    super.key,
    required this.icon,
    required this.label,
    required this.onTap,
    this.experimental = false,
    this.badgeCount = 0,
    this.accentColor = const Color(0xFFE0B850),
  });
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final bool experimental;

  /// Contador numérico (p.ej. nº de backups) — se pinta en vez del punto de
  /// `experimental` cuando > 0. Los dos badges no se combinan.
  final int badgeCount;
  final Color accentColor;

  @override
  Widget build(BuildContext context) {
    final accent = accentColor;
    return _Pressable(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 9, horizontal: 4),
        decoration: BoxDecoration(
          border: Border.all(color: accent.withValues(alpha: 0.40)),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Stack(
              clipBehavior: Clip.none,
              children: [
                Icon(icon, size: 20, color: accent),
                if (experimental)
                  Positioned(
                    top: -3,
                    right: -6,
                    child: Container(
                      width: 6,
                      height: 6,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Color(0xFFE09020),
                      ),
                    ),
                  ),
                if (badgeCount > 0)
                  Positioned(
                    top: -6,
                    right: -8,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 4,
                        vertical: 1,
                      ),
                      constraints: const BoxConstraints(minWidth: 14),
                      decoration: BoxDecoration(
                        color: accent,
                        borderRadius: BorderRadius.circular(999),
                      ),
                      child: Text(
                        '$badgeCount',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.firaCode(
                          fontSize: 8,
                          fontWeight: FontWeight.w700,
                          color: const Color(0xFF14110A),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 4),
            Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: GoogleFonts.firaCode(
                fontSize: 9.5,
                fontWeight: FontWeight.w500,
                color: accent,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Envoltorio de feedback al pulsar: `scale(0.97)` en 140ms con la curva de
/// la app (Emil — botones deben "sentirse" al presionar).
class _Pressable extends StatefulWidget {
  const _Pressable({required this.onTap, required this.child});
  final VoidCallback onTap;
  final Widget child;

  @override
  State<_Pressable> createState() => _PressableState();
}

class _PressableState extends State<_Pressable> {
  bool _pressed = false;
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        onTapDown: (_) => setState(() => _pressed = true),
        onTapUp: (_) => setState(() => _pressed = false),
        onTapCancel: () => setState(() => _pressed = false),
        child: AnimatedScale(
          scale: _pressed ? 0.97 : (_hovered ? 1.02 : 1.0),
          duration: const Duration(milliseconds: 140),
          curve: const Cubic(0.23, 1, 0.32, 1),
          child: widget.child,
        ),
      ),
    );
  }
}
