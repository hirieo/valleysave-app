import 'dart:io';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../generated/app_localizations.dart';
import '../../core/models/player_stats.dart';
import '../../core/models/save_entry.dart';
import '../../core/models/save_file.dart';
import '../../core/services/season_controller.dart';
import '../../core/theme/app_colors.dart';
import '../../shared/widgets/save_busy_indicator.dart';
import '../../shared/widgets/pressable_scale.dart';
import 'widgets/save_detail_sheet.dart';

// Card-local color tokens
const _kSkillName = Color(0xFF8AB890);
const _kMoneyNow = Color(0xFFC8A830);
const _kMoneyTotal = Color(0xFF8898A8);
const _kMineLevel = Color(0xFFA888D8);
const _kTileLbl = Color(0xFFA8B898);

const _kMonstruos = Color(0xFFE07040);
const _kAmigos = Color(0xFFE878A0);
const _kDesmayos = Color(0xFFA8B0D8);

// Estado de sincronización
const kLocal = Color(0xFFE0B850); // dorado = en tu equipo
const kDrive = Color(0xFF5AA8E0); // azul = nube
const _kSynced = Color(0xFF62B074); // verde = coinciden

// Card surface: negro semitransparente + tinte estacional
Color _cardSurface(Color s) => Color.alphaBlend(
  s.withValues(alpha: 0.10),
  const Color(0xFF040405),
).withValues(alpha: 0.62);

// Tiles: negro más oscuro + tinte
Color _tileBg(Color s) => Color.alphaBlend(
  s.withValues(alpha: 0.14),
  Colors.black,
).withValues(alpha: 0.42);
Color _tileBdr(Color s) => s.withValues(alpha: 0.32);

// Divisor horizontal sutil (compartido por la card y por SaveStatsView).
final kDivider = Container(
  height: 1,
  color: Colors.white.withValues(alpha: 0.08),
);

const _kPipFarming = Color(0xFFC8960A);
const _kPipMining = Color(0xFFA878C0);
const _kPipCombat = Color(0xFFE07040);
const _kPipForaging = Color(0xFF60A858);
const _kPipFishing = Color(0xFF4888C8);

({Color color, String label}) _statusStyle(
  SaveSyncStatus s,
  AppLocalizations l10n,
) => switch (s) {
  SaveSyncStatus.synced => (color: _kSynced, label: l10n.cardSynced),
  SaveSyncStatus.localAhead => (color: kLocal, label: l10n.cardLocalAhead),
  SaveSyncStatus.driveAhead => (color: kDrive, label: l10n.cardDriveAhead),
  SaveSyncStatus.localOnly => (color: kLocal, label: l10n.cardLocalOnly),
  SaveSyncStatus.driveOnly => (color: kDrive, label: l10n.cardDriveOnly),
};

// Etiqueta de estado corta para la fila de acción (evita truncado en móvil).

String _rel(DateTime t, AppLocalizations l10n) {
  final d = DateTime.now().difference(t);
  if (d.inMinutes < 1) return l10n.cardTimeNow;
  if (d.inMinutes < 60) return l10n.cardTimeMinutesAgo(d.inMinutes);
  if (d.inHours < 24) return l10n.cardTimeHoursAgo(d.inHours);
  if (d.inDays < 30) return l10n.cardTimeDaysAgo(d.inDays);
  final m = (d.inDays / 30).floor();
  return l10n.cardTimeMonthsAgo(m);
}

typedef SaveCardFooterBuilder =
    Widget Function(
      BuildContext context,
      String? selectedPlayerId,
      ValueChanged<String> onPlayerIdChanged,
    );

class SaveCard extends StatefulWidget {
  const SaveCard({
    super.key,
    required this.entry,
    this.busy = false,
    this.onUpload,
    this.onDownload,
    this.onDeleteFromDrive,
    this.onDeleteLocal,
    this.onManageCopies,
    this.onMakeHost,
    this.onExport,
    this.onShare,
    this.onBackups,
    this.backupCount = 0,
    this.footer,
    this.footerBuilder,
    this.sharedOwnerEmail,
  });

  final SaveEntry entry;
  final bool busy;
  final VoidCallback? onUpload; // local → Drive
  final VoidCallback? onDownload; // Drive → local
  final VoidCallback? onDeleteFromDrive; // Drive → papelera
  final VoidCallback? onDeleteLocal; // local → delete
  final VoidCallback? onManageCopies; // elige local / Drive / ambas
  final void Function(PlayerStats target)? onMakeHost; // F3 — solo cara local
  final VoidCallback? onExport; // F1 — solo cara local
  final VoidCallback? onShare; // F2 — solo cara Mi Drive
  final VoidCallback? onBackups; // spec 007 — solo cara local
  final int backupCount;

  /// US5 — no-null cuando este save (por `folderName`) proviene de un
  /// compartido de otra persona: pinta la píldora dorada COMPARTIDA + línea
  /// "de {email}". NUNCA capa acciones (Subir a Drive propio y cambio de
  /// anfitrión siguen disponibles — decisión del usuario 2026-07-12: si el
  /// dueño revoca, la copia local + Drive propio vuelven a ser partida
  /// normal).
  final String? sharedOwnerEmail;

  /// US5 — cuando no es `null`, SUSTITUYE `_PresenceRow`+`_Footer` (que
  /// hablan de "este equipo" vs "Drive propio", sin sentido para un save
  /// ajeno). Cabecera/chips/selector/stats se quedan exactamente igual —
  /// mismo `SaveCard`, la tarjeta de "Compartidas conmigo" no es una versión
  /// reducida (ver contracts/shared_saves_picker.md).
  final Widget? footer;

  /// Variante dinámica del footer para vistas que necesitan compartir el
  /// jugador seleccionado con diálogos externos. El ID estable evita que un
  /// cambio de anfitrión (que reordena la lista) cambie de persona al navegar.
  final SaveCardFooterBuilder? footerBuilder;

  @override
  State<SaveCard> createState() => _SaveCardState();
}

class _SaveCardState extends State<SaveCard> {
  String? _selectedPlayerId;

  int _playerIndexFor(SaveFile base) {
    if (!base.hasMultiplePlayers || _selectedPlayerId == null) return 0;
    final index = base.players.indexWhere(
      (player) => player.uniqueId == _selectedPlayerId,
    );
    return index < 0 ? 0 : index;
  }

  void _selectPlayer(int i) {
    final players = widget.entry.primary.players;
    if (i < 0 || i >= players.length) return;
    _selectPlayerId(players[i].uniqueId);
  }

  void _selectPlayerId(String id) {
    if (id.isEmpty || id == _selectedPlayerId) return;
    setState(() => _selectedPlayerId = id);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final base = widget.entry.primary;
    final coop = base.hasMultiplePlayers;
    final idx = coop ? _playerIndexFor(base) : 0;
    // La tarjeta muestra el jugador seleccionado (o el anfitrión en solitario).
    final save = coop ? base.forPlayer(base.players[idx]) : base;
    final status = widget.entry.status;
    final st = _statusStyle(status, l10n);

    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: Container(
        decoration: BoxDecoration(
          color: _cardSurface(save.seasonColor),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: st.color.withValues(alpha: 0.65)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(height: 3, color: st.color),
            _Header(
              save: save,
              players: coop ? base.players : const [],
              playerIndex: idx,
              hostSelected: coop && base.players[idx].isHost,
              onSelectPlayer: _selectPlayer,
              sharedOwnerEmail: widget.sharedOwnerEmail,
            ),
            kDivider,
            // Los stats por-jugador se cruzan con un fundido al cambiar.
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 190),
              switchInCurve: const Cubic(0.23, 1, 0.32, 1),
              switchOutCurve: const Cubic(0.23, 1, 0.32, 1),
              transitionBuilder: (child, anim) =>
                  FadeTransition(opacity: anim, child: child),
              child: SaveStatsView(key: ValueKey(idx), save: save),
            ),
            if (widget.footerBuilder != null) ...[
              kDivider,
              widget.footerBuilder!(
                context,
                coop ? base.players[idx].uniqueId : null,
                _selectPlayerId,
              ),
            ] else if (widget.footer != null) ...[
              kDivider,
              widget.footer!,
            ] else ...[
              kDivider,
              _PresenceRow(
                entry: widget.entry,
                selectedPlayerId: coop ? base.players[idx].uniqueId : null,
                onPlayerIdChanged: _selectPlayerId,
                onUpload: widget.onUpload,
                onDownload: widget.onDownload,
                onDeleteFromDrive: widget.onDeleteFromDrive,
                onDeleteLocal: widget.onDeleteLocal,
                onMakeHost: widget.onMakeHost,
                onExport: widget.onExport,
                onShare: widget.onShare,
                onBackups: widget.onBackups,
                backupCount: widget.backupCount,
              ),
              kDivider,
              _Footer(
                entry: widget.entry,
                statusColor: st.color,
                busy: widget.busy,
                onUpload: widget.onUpload,
                onDownload: widget.onDownload,
                onManageCopies: widget.onManageCopies,
              ),
            ],
          ],
        ),
      ),
    );
  }
}

/// Stats de UNA versión (tiles + skills + pills), reutilizable fuera de la card
/// principal (p. ej. en la hoja de detalle de una cara de presencia).
class SaveStatsView extends StatelessWidget {
  const SaveStatsView({super.key, required this.save});
  final SaveFile save;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _TilesRow(save: save),
        kDivider,
        _SkillsGrid(save: save),
        kDivider,
        _PillsRow(save: save),
      ],
    );
  }
}

// ── Header ───────────────────────────────────────────────────────────────────

class _Header extends StatelessWidget {
  const _Header({
    required this.save,
    this.players = const [],
    this.playerIndex = 0,
    this.hostSelected = false,
    this.onSelectPlayer,
    this.sharedOwnerEmail,
  });

  final SaveFile save;
  final List<PlayerStats> players; // vacío = solitario (sin selector)
  final int playerIndex;
  final bool hostSelected;
  final ValueChanged<int>? onSelectPlayer;
  final String? sharedOwnerEmail;

  bool get _coop => players.length > 1;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Padding(
      padding: const EdgeInsets.fromLTRB(14, 12, 14, 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Nombre de granja (+ COOP al lado) · corona centrada + fecha a la derecha
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Flexible(
                      child: Text(
                        save.farmName,
                        style: GoogleFonts.bodoniModa(
                          fontSize: 26,
                          fontStyle: FontStyle.italic,
                          fontWeight: FontWeight.w700,
                          color: AppColors.text,
                          height: 1,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    if (_coop) ...[const SizedBox(width: 8), const CoopBadge()],
                    if (sharedOwnerEmail != null) ...[
                      const SizedBox(width: 6),
                      SharedOriginBadge(label: l10n.sharedOriginBadge),
                    ],
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Row(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  if (_coop && hostSelected) ...[
                    const HostCrown(),
                    const SizedBox(width: 8),
                  ],
                  DateBox(save: save),
                ],
              ),
            ],
          ),
          if (sharedOwnerEmail != null) ...[
            const SizedBox(height: 5),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.link_rounded,
                  size: 11,
                  color: Color(0xFFE0B850),
                ),
                const SizedBox(width: 4),
                Flexible(
                  child: Text(
                    l10n.sharedOriginFrom(sharedOwnerEmail!),
                    style: GoogleFonts.firaCode(
                      fontSize: 9.5,
                      color: const Color(0xFFE0B850),
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ],
          const SizedBox(height: 8),
          // Chips a todo el ancho (ya no compiten con la fecha)
          Wrap(
            spacing: 6,
            runSpacing: 4,
            children: [
              _Chip(
                '🧑 ${save.playerName} ${save.genderLabel}',
                textColor: const Color(0xFFF0D060),
                borderColor: const Color(0xFF5A3E08),
                bgColor: const Color(0xFF140E04),
                onTap: _coop
                    ? () => onSelectPlayer?.call(
                        (playerIndex + 1) % players.length,
                      )
                    : null,
              ),
              _Chip(
                save.petType == 'cat'
                    ? '🐱 ${l10n.petCat}'
                    : '🐶 ${l10n.petDog}',
                textColor: const Color(0xFF60A858),
                borderColor: const Color(0xFF264A20),
                bgColor: const Color(0xFF080E08),
              ),
              _Chip(
                '🏠 ${_houseLabel(save.houseUpgradeLevel, l10n)}',
                textColor: const Color(0xFF8898A8),
                borderColor: const Color(0xFF283848),
                bgColor: const Color(0xFF08100E),
              ),
            ],
          ),
          if (_coop) ...[
            const SizedBox(height: 10),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                PlayerSwitcher(
                  count: players.length,
                  index: playerIndex,
                  hostIndex: players.indexWhere((p) => p.isHost),
                  onSelect: (i) => onSelectPlayer?.call(i),
                ),
                const SizedBox(width: 8),
                Text(
                  l10n.viewPlayersHint,
                  style: GoogleFonts.firaCode(
                    fontSize: 9,
                    color: Colors.white.withValues(alpha: 0.32),
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}

/// Insignia COOP junto al nombre de la granja.
class CoopBadge extends StatelessWidget {
  const CoopBadge({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: const Color(0xFF97C459).withValues(alpha: 0.14),
        border: Border.all(
          color: const Color(0xFF97C459).withValues(alpha: 0.40),
        ),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.groups_rounded, size: 11, color: Color(0xFF97C459)),
          const SizedBox(width: 4),
          Text(
            'COOP',
            style: GoogleFonts.firaCode(
              fontSize: 8.5,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.5,
              color: const Color(0xFF97C459),
            ),
          ),
        ],
      ),
    );
  }
}

/// Insignia dorada junto al nombre: este save local proviene de un
/// compartido de otra persona (US5). Solo informa — no capa acciones.
class SharedOriginBadge extends StatelessWidget {
  const SharedOriginBadge({super.key, required this.label});
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: const Color(0xFFE0B850).withValues(alpha: 0.10),
        border: Border.all(
          color: const Color(0xFFE0B850).withValues(alpha: 0.55),
        ),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.link_rounded, size: 11, color: Color(0xFFE0B850)),
          const SizedBox(width: 4),
          Text(
            label.toUpperCase(),
            style: GoogleFonts.firaCode(
              fontSize: 8.5,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.5,
              color: const Color(0xFFE0B850),
            ),
          ),
        ],
      ),
    );
  }
}

/// Marca al anfitrión, junto a la fecha. Solo visible cuando el jugador
/// seleccionado es el anfitrión. Estrella de la suerte de 5 puntas (como la
/// del noticiero de Stardew Valley) en el índigo real del Stardrop del
/// juego — antes un emoji 👑 genérico sin relación con la estética del
/// juego (reemplazado 2026-07-15, mockup aprobado con color extraído del
/// sprite real).
class HostCrown extends StatelessWidget {
  const HostCrown({super.key});

  static const _kIndigo = Color(0xFF8020E0);

  @override
  Widget build(BuildContext context) {
    return Container(
      // El emoji 👑 anterior no tenía tamaño fijo (fontSize 21 + padding 3
      // por lado) — su glifo renderiza más grande que el fontSize nominal,
      // así que el badge real rondaba los 32px, no 27. Se iguala aquí.
      width: 32,
      height: 32,
      decoration: BoxDecoration(
        color: _kIndigo.withValues(alpha: 0.14),
        border: Border.all(color: _kIndigo.withValues(alpha: 0.55)),
        borderRadius: BorderRadius.circular(7),
      ),
      child: const CustomPaint(painter: _LuckStarPainter()),
    );
  }
}

class _LuckStarPainter extends CustomPainter {
  const _LuckStarPainter();

  static const _outer = Color(0xFF8020E0);
  static const _inner = Color(0xFFD8A8F5);

  Path _star(Offset center, double outerR, double innerR) {
    final path = Path();
    for (var i = 0; i < 10; i++) {
      final a = -math.pi / 2 + i * math.pi / 5;
      final r = i.isEven ? outerR : innerR;
      final x = center.dx + math.cos(a) * r;
      final y = center.dy + math.sin(a) * r;
      i == 0 ? path.moveTo(x, y) : path.lineTo(x, y);
    }
    path.close();
    return path;
  }

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final outerR = size.width * 0.41;

    canvas.drawCircle(center, size.width * 0.44, Paint()..color = _outer.withValues(alpha: 0.35));
    canvas.drawPath(_star(center, outerR, outerR * 0.382), Paint()..color = _outer);
    canvas.drawPath(_star(center, outerR * 0.52, outerR * 0.52 * 0.382), Paint()..color = _inner);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

/// Nombre + género del jugador seleccionado. Para usar junto a [PlayerSwitcher]
/// en superficies que no tienen ya un chip de granjero (hoja de detalle, diálogo
/// de comparación). Mismo criterio de color que el punto activo del switcher.
class PlayerNameLabel extends StatelessWidget {
  const PlayerNameLabel({
    super.key,
    required this.name,
    required this.gender,
    required this.isHost,
  });

  final String name;
  final String gender;
  final bool isHost;

  @override
  Widget build(BuildContext context) {
    return Text(
      '$name $gender',
      style: GoogleFonts.firaCode(
        fontSize: 11,
        fontWeight: FontWeight.w700,
        color: isHost ? const Color(0xFFE0B850) : const Color(0xFFF0D060),
      ),
    );
  }
}

/// Selector en línea: insignia COOP + puntos de recorrido + flechas ‹ ›.
class PlayerSwitcher extends StatelessWidget {
  const PlayerSwitcher({
    super.key,
    required this.count,
    required this.index,
    required this.hostIndex,
    required this.onSelect,
  });

  final int count;
  final int index;
  final int hostIndex;
  final ValueChanged<int> onSelect;

  @override
  Widget build(BuildContext context) {
    // Grupo compacto: ‹ · ▬ · ›  (flechas junto a los puntos)
    return Row(
      children: [
        _SwitchArrow(
          icon: Icons.chevron_left_rounded,
          enabled: index > 0,
          onTap: () => onSelect(index - 1),
        ),
        const SizedBox(width: 8),
        for (var i = 0; i < count; i++)
          PressableScale(
            onTap: () => onSelect(i),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 240),
              curve: const Cubic(0.23, 1, 0.32, 1),
              margin: const EdgeInsets.symmetric(horizontal: 2.5),
              width: i == index ? 18 : 6,
              height: 6,
              decoration: BoxDecoration(
                color: i == index
                    ? (i == hostIndex
                          ? const Color(0xFFE0B850)
                          : const Color(0xFFF0D060))
                    : Colors.white.withValues(alpha: 0.30),
                borderRadius: BorderRadius.circular(3),
              ),
            ),
          ),
        const SizedBox(width: 8),
        _SwitchArrow(
          icon: Icons.chevron_right_rounded,
          enabled: index < count - 1,
          onTap: () => onSelect(index + 1),
        ),
      ],
    );
  }
}

class _SwitchArrow extends StatelessWidget {
  const _SwitchArrow({
    required this.icon,
    required this.enabled,
    required this.onTap,
  });
  final IconData icon;
  final bool enabled;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return PressableScale(
      onTap: enabled ? onTap : null,
      child: Container(
        width: 24,
        height: 24,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(
            color: const Color(
              0xFFF0B8C8,
            ).withValues(alpha: enabled ? 0.30 : 0.10),
          ),
        ),
        child: Icon(
          icon,
          size: 15,
          color: const Color(
            0xFFF0B8C8,
          ).withValues(alpha: enabled ? 0.75 : 0.20),
        ),
      ),
    );
  }
}

class DateBox extends StatelessWidget {
  const DateBox({super.key, required this.save});
  final SaveFile save;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: _tileBg(save.seasonColor),
        border: Border.all(color: _tileBdr(save.seasonColor)),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(
            _saveDateLabel(save, l10n).toUpperCase(),
            style: GoogleFonts.firaCode(
              fontSize: 8,
              letterSpacing: 1.0,
              color: save.seasonColor.withValues(alpha: 0.80),
            ),
          ),
          Text(
            l10n.statDayOnly(save.dayOfMonth),
            style: GoogleFonts.bodoniModa(
              fontSize: 22,
              fontStyle: FontStyle.italic,
              fontWeight: FontWeight.w700,
              color: save.seasonColor,
              height: 1.1,
            ),
          ),
        ],
      ),
    );
  }
}

// ── Tiles ────────────────────────────────────────────────────────────────────

class _TilesRow extends StatelessWidget {
  const _TilesRow({required this.save});
  final SaveFile save;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final mineValue = save.deepestMineLevel == 0
        ? l10n.statMineUnexplored
        : '${save.deepestMineLevel}';
    final mineLabel = save.deepestMineLevel == 0
        ? l10n.statMine
        : l10n.statMineLvl;

    final bg = _tileBg(save.seasonColor);
    final bdr = _tileBdr(save.seasonColor);

    final coins = _MiniTile(
      icon: _CoinIcon(),
      value: save.currentMoneyLabel,
      label: l10n.statMoney,
      valueColor: _kMoneyNow,
      bgColor: bg,
      borderColor: bdr,
    );
    final total = _MiniTile(
      icon: const Text('💰', style: TextStyle(fontSize: 12)),
      value: save.totalMoneyLabel,
      label: l10n.statTotal,
      valueColor: _kMoneyTotal,
      bgColor: bg,
      borderColor: bdr,
    );
    final mine = _MiniTile(
      icon: const Text('⛏️', style: TextStyle(fontSize: 12)),
      value: mineValue,
      label: mineLabel,
      valueColor: _kMineLevel,
      bgColor: bg,
      borderColor: bdr,
    );

    return Padding(
      padding: const EdgeInsets.fromLTRB(10, 7, 10, 7),
      child: LayoutBuilder(
        builder: (context, constraints) {
          // Estrecho (móvil): apilar Monedas/Total/Mina en columna junto al
          // BigTile, a su misma altura.
          if (constraints.maxWidth < 360) {
            return IntrinsicHeight(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _BigTile(save: save),
                  const SizedBox(width: 7),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Expanded(child: coins),
                        const SizedBox(height: 5),
                        Expanded(child: total),
                        const SizedBox(height: 5),
                        Expanded(child: mine),
                      ],
                    ),
                  ),
                ],
              ),
            );
          }
          // Amplio (desktop): layout horizontal actual.
          return Row(
            children: [
              _BigTile(save: save),
              const SizedBox(width: 7),
              Expanded(child: coins),
              const SizedBox(width: 7),
              Expanded(child: total),
              const SizedBox(width: 7),
              Expanded(child: mine),
            ],
          );
        },
      ),
    );
  }
}

class _BigTile extends StatelessWidget {
  const _BigTile({required this.save});
  final SaveFile save;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: _tileBg(save.seasonColor),
        border: Border.all(color: _tileBdr(save.seasonColor)),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            save.playtimeLabel,
            style: GoogleFonts.bodoniModa(
              fontSize: 38,
              fontStyle: FontStyle.italic,
              fontWeight: FontWeight.w700,
              color: save.seasonColor,
              height: 1,
              letterSpacing: -0.8,
            ),
          ),
          const SizedBox(height: 5),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('⏱', style: TextStyle(fontSize: 11)),
              const SizedBox(width: 4),
              Text(
                l10n.statPlaytime.toUpperCase(),
                style: GoogleFonts.firaCode(
                  fontSize: 7,
                  letterSpacing: 0.8,
                  color: save.seasonColor.withValues(alpha: 0.45),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _MiniTile extends StatelessWidget {
  const _MiniTile({
    required this.icon,
    required this.value,
    required this.label,
    required this.valueColor,
    required this.bgColor,
    required this.borderColor,
  });

  final Widget icon;
  final String value;
  final String label;
  final Color valueColor;
  final Color bgColor;
  final Color borderColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 8),
      decoration: BoxDecoration(
        color: bgColor,
        border: Border.all(color: borderColor),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              icon,
              const SizedBox(width: 4),
              Flexible(
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  alignment: Alignment.centerLeft,
                  child: Text(
                    value,
                    style: GoogleFonts.firaCode(
                      fontSize: 11,
                      fontWeight: FontWeight.w500,
                      color: valueColor,
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 3),
          Text(
            label.toUpperCase(),
            style: GoogleFonts.firaCode(
              fontSize: 7,
              letterSpacing: 0.7,
              color: _kTileLbl,
            ),
          ),
        ],
      ),
    );
  }
}

class _CoinIcon extends StatelessWidget {
  const _CoinIcon();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 14,
      height: 14,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: const Color(0xFFE8C030),
        border: Border.all(color: const Color(0xFFC8960A), width: 1.2),
      ),
      child: Center(
        child: Text(
          'G',
          style: GoogleFonts.bodoniModa(
            fontSize: 7.5,
            fontStyle: FontStyle.italic,
            fontWeight: FontWeight.w700,
            color: const Color(0xFF804808),
            height: 1,
          ),
        ),
      ),
    );
  }
}

// ── Skills ───────────────────────────────────────────────────────────────────

class _SkillsGrid extends StatelessWidget {
  const _SkillsGrid({required this.save});
  final SaveFile save;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final skills = [
      (l10n.skillFarming, save.farmingLevel, _kPipFarming),
      (l10n.skillForaging, save.foragingLevel, _kPipForaging),
      (l10n.skillMining, save.miningLevel, _kPipMining),
      (l10n.skillFishing, save.fishingLevel, _kPipFishing),
      (l10n.skillCombat, save.combatLevel, _kPipCombat),
    ];

    final rows = <Widget>[];
    for (var i = 0; i < skills.length; i += 2) {
      final a = skills[i];
      final b = i + 1 < skills.length ? skills[i + 1] : null;
      rows.add(
        Row(
          children: [
            Expanded(
              child: _SkillRow(name: a.$1, level: a.$2, color: a.$3),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: b != null
                  ? _SkillRow(name: b.$1, level: b.$2, color: b.$3)
                  : const SizedBox(),
            ),
          ],
        ),
      );
      if (i + 2 < skills.length) rows.add(const SizedBox(height: 4));
    }

    return Padding(
      padding: const EdgeInsets.fromLTRB(14, 7, 14, 7),
      child: Column(children: rows),
    );
  }
}

class _SkillRow extends StatelessWidget {
  const _SkillRow({
    required this.name,
    required this.level,
    required this.color,
  });

  final String name;
  final int level;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(
          width: 42,
          child: Text(
            name.toUpperCase(),
            style: GoogleFonts.firaCode(
              fontSize: 8,
              letterSpacing: 0.4,
              color: _kSkillName,
            ),
          ),
        ),
        const SizedBox(width: 5),
        Expanded(
          child: LayoutBuilder(
            builder: (context, constraints) {
              final available = constraints.maxWidth;
              final pipW = ((available - 1.5 * 9) / 10).clamp(0.0, 7.0);
              final actualGap = pipW * 10 < available
                  ? (available - pipW * 10) / 9
                  : 0.0;
              return Row(
                children: List.generate(10, (i) {
                  return Padding(
                    padding: i < 9
                        ? EdgeInsets.only(right: actualGap)
                        : EdgeInsets.zero,
                    child: Container(
                      width: pipW,
                      height: pipW,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: i < level
                            ? color
                            : color.withValues(alpha: 0.25),
                      ),
                    ),
                  );
                }),
              );
            },
          ),
        ),
        const SizedBox(width: 4),
        SizedBox(
          width: 16,
          child: Text(
            '$level',
            style: GoogleFonts.firaCode(
              fontSize: 10,
              fontWeight: FontWeight.w500,
              color: color,
            ),
            textAlign: TextAlign.right,
          ),
        ),
      ],
    );
  }
}

// ── Pills ────────────────────────────────────────────────────────────────────

class _PillsRow extends StatelessWidget {
  const _PillsRow({required this.save});
  final SaveFile save;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
      child: Wrap(
        spacing: 6,
        runSpacing: 6,
        children: [
          _Pill(
            '💀 ${SaveFile.formatCount(save.monstersKilled)} ${l10n.pillMonsters}',
            textColor: _kMonstruos,
            borderColor: const Color(0xFF5A2010),
            bgColor: const Color(0xFF100806),
          ),
          _Pill(
            '❤️ ${save.goodFriends} ${l10n.pillFriends}',
            textColor: _kAmigos,
            borderColor: const Color(0xFF5A1838),
            bgColor: const Color(0xFF100610),
          ),
          _Pill(
            '😵‍💫 ${save.timesUnconscious} ${l10n.pillFaints}',
            textColor: _kDesmayos,
            borderColor: const Color(0xFF303858),
            bgColor: const Color(0xFF08090E),
          ),
          if (save.averageBedtime > 0)
            _Pill(
              '🛏️ ${l10n.pillSleeps} ${save.bedtimeLabel}',
              textColor: const Color(0xFF9888C8),
              borderColor: const Color(0xFF2C2848),
              bgColor: const Color(0xFF0A080E),
            ),
          _Pill(
            '⚡ ${save.stamina} sta · ${save.health} hp',
            textColor: const Color(0xFFE8C050),
            borderColor: const Color(0xFF4A3A08),
            bgColor: const Color(0xFF0E0C04),
          ),
        ],
      ),
    );
  }
}

// ── Presencia: este equipo vs Drive ──────────────────────────────────────────

class _PresenceRow extends StatelessWidget {
  const _PresenceRow({
    required this.entry,
    this.selectedPlayerId,
    this.onPlayerIdChanged,
    this.onUpload,
    this.onDownload,
    this.onDeleteFromDrive,
    this.onDeleteLocal,
    this.onMakeHost,
    this.onExport,
    this.onShare,
    this.onBackups,
    this.backupCount = 0,
  });
  final SaveEntry entry;

  /// Jugador seleccionado ahora mismo en la tarjeta — se pasa como valor
  /// inicial al abrir la hoja de detalle, y se actualiza si se cambia
  /// DENTRO de la hoja, para que abrir la otra cara no lo resetee
  /// (feedback 2026-07-12).
  final String? selectedPlayerId;
  final ValueChanged<String>? onPlayerIdChanged;
  final VoidCallback? onUpload;
  final VoidCallback? onDownload;
  final VoidCallback? onDeleteFromDrive;
  final VoidCallback? onDeleteLocal;
  final void Function(PlayerStats target)? onMakeHost;
  final VoidCallback? onExport;
  final VoidCallback? onShare;
  final VoidCallback? onBackups;
  final int backupCount;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final status = entry.status;
    final localAhead =
        status == SaveSyncStatus.localAhead ||
        status == SaveSyncStatus.localOnly;
    final driveAhead =
        status == SaveSyncStatus.driveAhead ||
        status == SaveSyncStatus.driveOnly;
    final isMobile = Platform.isAndroid || Platform.isIOS;

    return Padding(
      padding: const EdgeInsets.fromLTRB(10, 9, 10, 9),
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: _SideTile(
                color: kLocal,
                icon: isMobile ? '📱' : '💻',
                title: l10n.cardLocalPresence,
                save: entry.local,
                highlight: localAhead && entry.drive != null,
                entry: entry,
                isLocalSide: true,
                selectedPlayerId: selectedPlayerId,
                onPlayerIdChanged: onPlayerIdChanged,
                onUpload: onUpload,
                onDownload: onDownload,
                onDeleteFromDrive: onDeleteFromDrive,
                onDeleteLocal: onDeleteLocal,
                onMakeHost: onMakeHost,
                onExport: onExport,
                onShare: onShare,
                onBackups: onBackups,
                backupCount: backupCount,
              ),
            ),
            const SizedBox(width: 7),
            Expanded(
              child: _SideTile(
                color: kDrive,
                icon: '☁️',
                title: l10n.cardRemotePresence,
                save: entry.drive,
                highlight: driveAhead && entry.local != null,
                entry: entry,
                isLocalSide: false,
                selectedPlayerId: selectedPlayerId,
                onPlayerIdChanged: onPlayerIdChanged,
                onUpload: onUpload,
                onDownload: onDownload,
                onDeleteFromDrive: onDeleteFromDrive,
                onDeleteLocal: onDeleteLocal,
                onMakeHost: onMakeHost,
                onExport: onExport,
                onShare: onShare,
                onBackups: onBackups,
                backupCount: backupCount,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SideTile extends StatefulWidget {
  const _SideTile({
    required this.color,
    required this.icon,
    required this.title,
    required this.save,
    required this.highlight,
    required this.entry,
    required this.isLocalSide,
    this.selectedPlayerId,
    this.onPlayerIdChanged,
    this.onUpload,
    this.onDownload,
    this.onDeleteFromDrive,
    this.onDeleteLocal,
    this.onMakeHost,
    this.onExport,
    this.onShare,
    this.onBackups,
    this.backupCount = 0,
  });

  final Color color;
  final String icon;
  final String title;
  final SaveFile? save;
  final bool highlight;
  final SaveEntry entry;
  final bool isLocalSide;
  final String? selectedPlayerId;
  final ValueChanged<String>? onPlayerIdChanged;
  final VoidCallback? onUpload;
  final VoidCallback? onDownload;
  final VoidCallback? onDeleteFromDrive;
  final VoidCallback? onDeleteLocal;
  final void Function(PlayerStats target)? onMakeHost;
  final VoidCallback? onExport;
  final VoidCallback? onShare;
  final VoidCallback? onBackups;
  final int backupCount;

  @override
  State<_SideTile> createState() => _SideTileState();
}

class _SideTileState extends State<_SideTile> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final present = widget.save != null;
    final base = present ? widget.color : Colors.white.withValues(alpha: 0.20);

    final content = Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: present
            ? widget.color.withValues(alpha: 0.08)
            : Colors.white.withValues(alpha: 0.02),
        border: Border.all(
          color: base.withValues(alpha: widget.highlight ? 0.9 : 0.36),
          width: widget.highlight ? 1.4 : 1,
        ),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(widget.icon, style: const TextStyle(fontSize: 11)),
              const SizedBox(width: 5),
              Text(
                widget.title,
                style: GoogleFonts.firaCode(
                  fontSize: 7.5,
                  letterSpacing: 0.6,
                  color: base.withValues(alpha: 0.95),
                ),
              ),
              if (widget.highlight) ...[
                const SizedBox(width: 4),
                Text('▲', style: TextStyle(fontSize: 8, color: widget.color)),
              ],
            ],
          ),
          const SizedBox(height: 5),
          if (present) ...[
            Text(
              l10n.statDayYear(widget.save!.dayOfMonth, widget.save!.year),
              style: GoogleFonts.firaCode(
                fontSize: 11,
                fontWeight: FontWeight.w500,
                color: Colors.white.withValues(alpha: 0.88),
              ),
            ),
            const SizedBox(height: 2),
            Text(
              '${widget.save!.playtimeLabel} · ${_rel(widget.save!.lastModified, l10n)}',
              style: GoogleFonts.firaCode(
                fontSize: 8.5,
                color: Colors.white.withValues(alpha: 0.42),
              ),
            ),
            if (widget.save!.gameVersion.isNotEmpty) ...[
              const SizedBox(height: 1),
              Text(
                'v${widget.save!.gameVersion}',
                style: GoogleFonts.firaCode(
                  fontSize: 8,
                  color: Colors.white.withValues(alpha: 0.28),
                ),
              ),
            ],
          ] else
            Text(
              l10n.cardNotPresent,
              style: GoogleFonts.firaCode(
                fontSize: 10,
                color: Colors.white.withValues(alpha: 0.35),
              ),
            ),
        ],
      ),
    );

    if (!present) return content;
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => showSaveDetail(
        context,
        entry: widget.entry,
        startOnLocal: widget.isLocalSide,
        onUpload: widget.onUpload,
        onDownload: widget.onDownload,
        onDeleteFromDrive: widget.onDeleteFromDrive,
        onDeleteLocal: widget.onDeleteLocal,
        onMakeHost: widget.onMakeHost,
        onExport: widget.onExport,
        onShare: widget.onShare,
        onBackups: widget.onBackups,
        backupCount: widget.backupCount,
        initialPlayerId: widget.selectedPlayerId,
        onPlayerIdChanged: widget.onPlayerIdChanged,
      ),
      onTapDown: (_) => setState(() => _pressed = true),
      onTapUp: (_) => setState(() => _pressed = false),
      onTapCancel: () => setState(() => _pressed = false),
      child: AnimatedScale(
        scale: _pressed ? 0.97 : 1.0,
        duration: _pressed
            ? const Duration(milliseconds: 100)
            : const Duration(milliseconds: 200),
        curve: const Cubic(0.23, 1, 0.32, 1),
        child: content,
      ),
    );
  }
}

// ── Footer: estado + acciones ─────────────────────────────────────────────────

class _Footer extends StatelessWidget {
  const _Footer({
    required this.entry,
    required this.statusColor,
    required this.busy,
    this.onUpload,
    this.onDownload,
    this.onManageCopies,
  });

  final SaveEntry entry;
  final Color statusColor;
  final bool busy;
  final VoidCallback? onUpload;
  final VoidCallback? onDownload;
  final VoidCallback? onManageCopies;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final status = entry.status;
    final hasLocal = entry.local != null;
    final hasDrive = entry.drive != null;
    final recommendUpload =
        status == SaveSyncStatus.localOnly ||
        status == SaveSyncStatus.localAhead;
    final recommendDownload =
        status == SaveSyncStatus.driveOnly ||
        status == SaveSyncStatus.driveAhead;
    final isMobile = Platform.isAndroid || Platform.isIOS;

    // Mientras sube/baja, el texto acompaña al icono estacional en vez de
    // quedarse con la etiqueta/color de antes de empezar (2026-07-15,
    // auditoría de consistencia visual — antes decía p. ej. "Local por
    // delante" en dorado durante toda la subida).
    final displayColor = busy
        ? seasonBusyColor(SeasonController.instance.season.value)
        : statusColor;
    final displayLabel = busy
        ? l10n.sharedStatusWorking
        : _statusStyle(status, l10n).label;

    if (isMobile) {
      return Padding(
        padding: const EdgeInsets.fromLTRB(14, 10, 14, 12),
        child: Row(
          children: [
            if (busy)
              SaveBusyIndicator(
                key: const ValueKey('save-busy-indicator'),
                season: SeasonController.instance.season.value,
              )
            else
              _Dot(color: statusColor),
            const SizedBox(width: 6),
            Expanded(
              child: Text(
                displayLabel,
                style: GoogleFonts.firaCode(
                  fontSize: 10,
                  fontWeight: FontWeight.w600,
                  color: displayColor,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const SizedBox(width: 8),
            if (!busy && status == SaveSyncStatus.synced)
              Icon(Icons.check_rounded, size: 16, color: _kSynced)
            else if (!busy) ...[
              // Secundario siempre a la izquierda, principal a la derecha
              if (hasLocal && hasDrive && recommendUpload) ...[
                ActionBtn(
                  label: '',
                  color: kDrive,
                  icon: Icons.cloud_download_outlined,
                  filled: false,
                  iconOnly: true,
                  onTap: onDownload,
                ),
                const SizedBox(width: 8),
              ],
              if (hasLocal && hasDrive && recommendDownload) ...[
                ActionBtn(
                  label: '',
                  color: kLocal,
                  icon: Icons.cloud_upload_outlined,
                  filled: false,
                  iconOnly: true,
                  onTap: onUpload,
                ),
                const SizedBox(width: 8),
              ],
              if (recommendUpload)
                ActionBtn(
                  label: '',
                  color: kLocal,
                  icon: Icons.cloud_upload_outlined,
                  filled: true,
                  iconOnly: true,
                  onTap: onUpload,
                ),
              if (recommendDownload)
                ActionBtn(
                  label: '',
                  color: kDrive,
                  icon: Icons.cloud_download_outlined,
                  filled: true,
                  iconOnly: true,
                  onTap: onDownload,
                ),
            ],
            if (!busy && onManageCopies != null) ...[
              const SizedBox(width: 8),
              _ManageCopiesButton(onTap: onManageCopies!),
            ],
          ],
        ),
      );
    }

    // Desktop: dot + etiqueta descriptiva + botones con label
    return Padding(
      padding: const EdgeInsets.fromLTRB(14, 10, 14, 12),
      child: Row(
        children: [
          if (busy)
            SaveBusyIndicator(
              key: const ValueKey('save-busy-indicator'),
              season: SeasonController.instance.season.value,
            )
          else
            _Dot(color: statusColor),
          const SizedBox(width: 6),
          Expanded(
            child: Text(
              displayLabel,
              style: GoogleFonts.firaCode(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: displayColor,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          const SizedBox(width: 8),
          if (!busy && status != SaveSyncStatus.synced) ...[
            if (hasLocal && hasDrive && recommendDownload) ...[
              ActionBtn(
                label: l10n.cardActionUpload,
                color: kLocal,
                icon: Icons.cloud_upload_outlined,
                filled: false,
                onTap: onUpload,
              ),
              const SizedBox(width: 8),
            ],
            if (hasLocal && hasDrive && recommendUpload) ...[
              ActionBtn(
                label: l10n.cardActionDownload,
                color: kDrive,
                icon: Icons.cloud_download_outlined,
                filled: false,
                onTap: onDownload,
              ),
              const SizedBox(width: 8),
            ],
            if (recommendUpload)
              ActionBtn(
                label: l10n.cardActionUpload,
                color: kLocal,
                icon: Icons.cloud_upload_outlined,
                filled: true,
                onTap: onUpload,
              ),
            if (recommendDownload)
              ActionBtn(
                label: l10n.cardActionDownload,
                color: kDrive,
                icon: Icons.cloud_download_outlined,
                filled: true,
                onTap: onDownload,
              ),
          ],
          if (!busy && onManageCopies != null) ...[
            const SizedBox(width: 8),
            _ManageCopiesButton(onTap: onManageCopies!),
          ],
        ],
      ),
    );
  }
}

class _ManageCopiesButton extends StatelessWidget {
  const _ManageCopiesButton({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Tooltip(
      message: l10n.deleteDataTitle,
      child: SizedBox(
        width: 42,
        height: 36,
        child: ActionBtn(
          key: const ValueKey('save-manage-copies-action'),
          label: '',
          color: const Color(0xFFE05252),
          icon: Icons.delete_outline_rounded,
          filled: true,
          iconOnly: true,
          onTap: onTap,
        ),
      ),
    );
  }
}

class _Dot extends StatelessWidget {
  const _Dot({required this.color});
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 7,
      height: 7,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: color,
        boxShadow: [
          BoxShadow(color: color.withValues(alpha: 0.6), blurRadius: 6),
        ],
      ),
    );
  }
}

class ActionBtn extends StatefulWidget {
  const ActionBtn({
    super.key,
    required this.label,
    required this.color,
    this.icon,
    required this.filled,
    this.iconOnly = false,
    this.iconSize = 15,
    this.onTap,
  });

  final String label;
  final Color color;
  final IconData? icon;
  final bool filled;
  final bool iconOnly;
  final double iconSize;
  final VoidCallback? onTap;

  @override
  State<ActionBtn> createState() => _ActionBtnState();
}

class _ActionBtnState extends State<ActionBtn> {
  bool _pressed = false;
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final enabled = widget.onTap != null;
    return MouseRegion(
      cursor: enabled ? SystemMouseCursors.click : MouseCursor.defer,
      onEnter: enabled ? (_) => setState(() => _hovered = true) : null,
      onExit: enabled ? (_) => setState(() => _hovered = false) : null,
      child: GestureDetector(
      onTap: widget.onTap,
      onTapDown: widget.onTap != null
          ? (_) => setState(() => _pressed = true)
          : null,
      onTapUp: (_) => setState(() => _pressed = false),
      onTapCancel: () => setState(() => _pressed = false),
      child: AnimatedScale(
        scale: _pressed ? 0.93 : 1.0,
        duration: _pressed
            ? const Duration(milliseconds: 100)
            : const Duration(milliseconds: 200),
        curve: const Cubic(0.23, 1, 0.32, 1),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 140),
          curve: Curves.easeOut,
          padding: widget.iconOnly
              ? const EdgeInsets.all(8)
              : const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: widget.color.withValues(
              alpha: widget.filled
                  ? (_hovered ? 0.24 : 0.16)
                  : (_hovered ? 0.08 : 0.0),
            ),
            border: Border.all(
              color: widget.color.withValues(alpha: _hovered ? 0.75 : 0.50),
            ),
            borderRadius: BorderRadius.circular(8),
          ),
          child: widget.iconOnly
              ? Icon(widget.icon, size: widget.iconSize, color: widget.color)
              : Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (widget.icon != null) ...[
                      Icon(widget.icon, size: 13, color: widget.color),
                      const SizedBox(width: 5),
                    ],
                    Text(
                      widget.label,
                      style: GoogleFonts.firaCode(
                        fontSize: 10,
                        color: widget.color,
                      ),
                    ),
                  ],
                ),
        ),
      ),
      ),
    );
  }
}

// ── Shared small widgets ─────────────────────────────────────────────────────

class _Chip extends StatelessWidget {
  const _Chip(
    this.label, {
    required this.textColor,
    required this.borderColor,
    required this.bgColor,
    this.onTap,
  });

  final String label;
  final Color textColor;
  final Color borderColor;
  final Color bgColor;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final chip = Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: bgColor,
        border: Border.all(color: borderColor),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: GoogleFonts.firaCode(
          fontSize: 10,
          fontWeight: FontWeight.w500,
          color: textColor,
        ),
      ),
    );
    if (onTap == null) return chip;
    return PressableScale(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: chip,
    );
  }
}

class _Pill extends StatelessWidget {
  const _Pill(
    this.label, {
    required this.textColor,
    required this.borderColor,
    required this.bgColor,
  });

  final String label;
  final Color textColor;
  final Color borderColor;
  final Color bgColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: bgColor,
        border: Border.all(color: borderColor),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: GoogleFonts.firaCode(fontSize: 10, color: textColor),
      ),
    );
  }
}

String _saveDateLabel(SaveFile save, AppLocalizations l10n) {
  final season = switch (save.currentSeason.toLowerCase()) {
    'spring' => l10n.seasonSpring,
    'summer' => l10n.seasonSummer,
    'fall' => l10n.seasonFall,
    'winter' => l10n.seasonWinter,
    _ => save.currentSeason,
  };
  return l10n.saveDateLabel(season, save.year);
}

String _houseLabel(int level, AppLocalizations l10n) => switch (level) {
  0 => l10n.houseBasic,
  1 => l10n.houseKitchen,
  2 => l10n.houseBedroom,
  3 => l10n.houseCellar,
  _ => l10n.houseLevelN(level),
};
