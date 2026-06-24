import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../core/models/save_entry.dart';
import '../../core/models/save_file.dart';
import '../../core/theme/app_colors.dart';

// Card-local color tokens
const _kSkillName  = Color(0xFF8AB890);
const _kMoneyNow   = Color(0xFFC8A830);
const _kMoneyTotal = Color(0xFF8898A8);
const _kMineLevel  = Color(0xFFA888D8);
const _kTileLbl    = Color(0xFFA8B898);

const _kMonstruos = Color(0xFFE07040);
const _kAmigos    = Color(0xFFE878A0);
const _kDesmayos  = Color(0xFFA8B0D8);

// Estado de sincronización
const _kLocal  = Color(0xFFE0B850); // dorado = en tu equipo
const _kDrive  = Color(0xFF5AA8E0); // azul = nube
const _kSynced = Color(0xFF62B074); // verde = coinciden

// Card surface: negro semitransparente + tinte estacional
Color _cardSurface(Color s) =>
    Color.alphaBlend(s.withValues(alpha: 0.10), const Color(0xFF040405))
        .withValues(alpha: 0.62);

// Tiles: negro más oscuro + tinte
Color _tileBg(Color s) =>
    Color.alphaBlend(s.withValues(alpha: 0.14), Colors.black)
        .withValues(alpha: 0.42);
Color _tileBdr(Color s) => s.withValues(alpha: 0.32);

// Divisor horizontal sutil (compartido por la card y por SaveStatsView).
final _kDivider =
    Container(height: 1, color: Colors.white.withValues(alpha: 0.08));

const _kPipFarming  = Color(0xFFC8960A);
const _kPipMining   = Color(0xFFA878C0);
const _kPipCombat   = Color(0xFFE07040);
const _kPipForaging = Color(0xFF60A858);
const _kPipFishing  = Color(0xFF4888C8);

({Color color, String label}) _statusStyle(SaveSyncStatus s) => switch (s) {
      SaveSyncStatus.synced     => (color: _kSynced, label: 'Sincronizado'),
      SaveSyncStatus.localAhead => (color: _kLocal,  label: 'Local más avanzada'),
      SaveSyncStatus.driveAhead => (color: _kDrive,  label: 'Drive más avanzada'),
      SaveSyncStatus.localOnly  => (color: _kLocal,  label: 'Solo en este equipo'),
      SaveSyncStatus.driveOnly  => (color: _kDrive,  label: 'Solo en Drive'),
    };

// Etiqueta de estado corta para la fila de acción (evita truncado en móvil).
String _shortStatus(SaveSyncStatus s) => switch (s) {
      SaveSyncStatus.synced     => 'Sync',
      SaveSyncStatus.localAhead => 'Local +',
      SaveSyncStatus.driveAhead => 'Drive +',
      SaveSyncStatus.localOnly  => 'Solo local',
      SaveSyncStatus.driveOnly  => 'Solo Drive',
    };

String _rel(DateTime t) {
  final d = DateTime.now().difference(t);
  if (d.inMinutes < 1) return 'ahora';
  if (d.inMinutes < 60) return 'hace ${d.inMinutes} min';
  if (d.inHours < 24) return 'hace ${d.inHours} h';
  if (d.inDays < 30) return 'hace ${d.inDays} d';
  final m = (d.inDays / 30).floor();
  return 'hace $m mes${m > 1 ? 'es' : ''}';
}

class SaveCard extends StatelessWidget {
  const SaveCard({
    super.key,
    required this.entry,
    this.busy = false,
    this.onUpload,
    this.onDownload,
    this.onDeleteFromDrive,
    this.onDeleteLocal,
  });

  final SaveEntry entry;
  final bool busy;
  final VoidCallback? onUpload;           // local → Drive
  final VoidCallback? onDownload;         // Drive → local
  final VoidCallback? onDeleteFromDrive;  // Drive → papelera
  final VoidCallback? onDeleteLocal;      // local → delete

  @override
  Widget build(BuildContext context) {
    final save = entry.primary;
    final status = entry.status;
    final st = _statusStyle(status);

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
            _Header(save: save),
            _kDivider,
            SaveStatsView(save: save),
            _kDivider,
            _PresenceRow(
              entry: entry,
              onUpload: onUpload,
              onDownload: onDownload,
              onDeleteFromDrive: onDeleteFromDrive,
              onDeleteLocal: onDeleteLocal,
            ),
            _kDivider,
            _Footer(
              entry: entry,
              statusColor: st.color,
              busy: busy,
              onUpload: onUpload,
              onDownload: onDownload,
            ),
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
        _kDivider,
        _SkillsGrid(save: save),
        _kDivider,
        _PillsRow(save: save),
      ],
    );
  }
}

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
  });
  final SaveFile save;
  final Color color;
  final String icon;
  final String title;
  final String actionLabel;
  final IconData actionIcon;
  final VoidCallback? onAction;
  final VoidCallback? onDelete;
}

/// Hoja inferior con los stats completos de una versión, con título de la cara,
/// swipe entre local↔Drive (si existen ambas) y la acción propia de cada una.
void _showSaveDetail(
  BuildContext context, {
  required SaveEntry entry,
  required bool startOnLocal,
  VoidCallback? onUpload,
  VoidCallback? onDownload,
  VoidCallback? onDeleteFromDrive,
  VoidCallback? onDeleteLocal,
}) {
  final isMobile = Platform.isAndroid || Platform.isIOS;

  // Caras presentes — local primero, Drive después.
  final sides = <_DetailSide>[
    if (entry.local != null)
      _DetailSide(
        save: entry.local!,
        color: _kLocal,
        icon: isMobile ? '📱' : '💻',
        title: isMobile ? 'En este móvil' : 'En este equipo',
        actionLabel: 'Subir a Drive',
        actionIcon: Icons.cloud_upload_outlined,
        onAction: onUpload,
        onDelete: onDeleteLocal,
      ),
    if (entry.drive != null)
      _DetailSide(
        save: entry.drive!,
        color: _kDrive,
        icon: '☁️',
        title: 'En Drive',
        actionLabel: 'Descargar partida',
        actionIcon: Icons.cloud_download_outlined,
        onAction: onDownload,
        onDelete: onDeleteFromDrive,
      ),
  ];
  if (sides.isEmpty) return;

  // startOnLocal → primera (local si existe); si no, la última (Drive).
  final initialPage = (startOnLocal ? 0 : sides.length - 1).clamp(0, sides.length - 1);

  showDialog<void>(
    context: context,
    barrierColor: Colors.black.withValues(alpha: 0.70),
    builder: (ctx) => Dialog(
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

  Widget _navArrow(IconData icon,
      {required bool enabled,
      required Color color,
      required VoidCallback onTap}) {
    return GestureDetector(
      onTap: enabled ? onTap : null,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
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
    );
  }

  @override
  Widget build(BuildContext context) {
    final sides = widget.sides;
    final active = sides[_index];
    final maxH = MediaQuery.of(context).size.height * 0.90;

    return ConstrainedBox(
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
                        onTap: () => setState(() => _index--),
                      ),
                      const SizedBox(width: 12),
                      ...List.generate(sides.length, (i) {
                        final on = i == _index;
                        final c = sides[i].color;
                        return AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
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
                        onTap: () => setState(() => _index++),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                ],
                GestureDetector(
                  onHorizontalDragEnd: (details) {
                    if (details.primaryVelocity == null) return;
                    if (details.primaryVelocity! < 0 &&
                        _index < sides.length - 1) {
                      setState(() => _index++);
                    } else if (details.primaryVelocity! > 0 && _index > 0) {
                      setState(() => _index--);
                    }
                  },
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 220),
                    child: KeyedSubtree(
                      key: ValueKey(_index),
                      child: _DetailPage(side: active),
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
}

class _DetailPage extends StatelessWidget {
  const _DetailPage({required this.side});
  final _DetailSide side;

  @override
  Widget build(BuildContext context) {
    final s = side.save;
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SingleChildScrollView(
          physics: const NeverScrollableScrollPhysics(),
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
                            style: GoogleFonts.dmMono(
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
                        style: GoogleFonts.fraunces(
                          fontSize: 24,
                          fontStyle: FontStyle.italic,
                          fontWeight: FontWeight.w700,
                          color: AppColors.text,
                          height: 1,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Día ${s.dayOfMonth} · Año ${s.year}',
                        style: GoogleFonts.dmMono(
                          fontSize: 11,
                          color: s.seasonColor.withValues(alpha: 0.90),
                        ),
                      ),
                    ],
                  ),
                ),
                _kDivider,
                SaveStatsView(save: s),
              ],
            ),
          ),
        if (side.onAction != null || side.onDelete != null) ...[
          _kDivider,
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
                        style: GoogleFonts.dmMono(
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
                        'Eliminar de Drive',
                        style: GoogleFonts.dmMono(
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

// ── Header ───────────────────────────────────────────────────────────────────

class _Header extends StatelessWidget {
  const _Header({required this.save});
  final SaveFile save;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(14, 12, 14, 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  save.farmName,
                  style: GoogleFonts.fraunces(
                    fontSize: 26,
                    fontStyle: FontStyle.italic,
                    fontWeight: FontWeight.w700,
                    color: AppColors.text,
                    height: 1,
                  ),
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 6,
                  runSpacing: 4,
                  children: [
                    _Chip(
                      '🧑 ${save.playerName} ${save.genderLabel}',
                      textColor: const Color(0xFFF0D060),
                      borderColor: const Color(0xFF5A3E08),
                      bgColor: const Color(0xFF140E04),
                    ),
                    _Chip(
                      save.petLabel,
                      textColor: const Color(0xFF60A858),
                      borderColor: const Color(0xFF264A20),
                      bgColor: const Color(0xFF080E08),
                    ),
                    _Chip(
                      '🏠 ${save.houseLabel}',
                      textColor: const Color(0xFF8898A8),
                      borderColor: const Color(0xFF283848),
                      bgColor: const Color(0xFF08100E),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          _DateBox(save: save),
        ],
      ),
    );
  }
}

class _DateBox extends StatelessWidget {
  const _DateBox({required this.save});
  final SaveFile save;

  @override
  Widget build(BuildContext context) {
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
            save.dateLabel.toUpperCase(),
            style: GoogleFonts.dmMono(
              fontSize: 8,
              letterSpacing: 1.0,
              color: save.seasonColor.withValues(alpha: 0.80),
            ),
          ),
          Text(
            'Día ${save.dayOfMonth}',
            style: GoogleFonts.fraunces(
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
    final mineValue = save.deepestMineLevel == 0
        ? 'Sin explorar'
        : '${save.deepestMineLevel}';
    final mineLabel = save.deepestMineLevel == 0 ? 'Mina' : 'Mina · Nv';

    final bg  = _tileBg(save.seasonColor);
    final bdr = _tileBdr(save.seasonColor);

    final coins = _MiniTile(
      icon: _CoinIcon(),
      value: save.currentMoneyLabel,
      label: 'Monedas',
      valueColor: _kMoneyNow,
      bgColor: bg,
      borderColor: bdr,
    );
    final total = _MiniTile(
      icon: const Text('💰', style: TextStyle(fontSize: 12)),
      value: save.totalMoneyLabel,
      label: 'Total',
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
      padding: const EdgeInsets.all(10),
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
                        const SizedBox(height: 7),
                        Expanded(child: total),
                        const SizedBox(height: 7),
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
            style: GoogleFonts.fraunces(
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
                'TIEMPO JUGADO',
                style: GoogleFonts.dmMono(
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
                    style: GoogleFonts.dmMono(
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
            style: GoogleFonts.dmMono(
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
          style: GoogleFonts.fraunces(
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
    final skills = [
      ('Cultivo',  save.farmingLevel,  _kPipFarming),
      ('Recolec.', save.foragingLevel, _kPipForaging),
      ('Minería',  save.miningLevel,   _kPipMining),
      ('Pesca',    save.fishingLevel,  _kPipFishing),
      ('Combate',  save.combatLevel,   _kPipCombat),
    ];

    final rows = <Widget>[];
    for (var i = 0; i < skills.length; i += 2) {
      final a = skills[i];
      final b = i + 1 < skills.length ? skills[i + 1] : null;
      rows.add(Row(
        children: [
          Expanded(child: _SkillRow(name: a.$1, level: a.$2, color: a.$3)),
          const SizedBox(width: 14),
          Expanded(
            child: b != null
                ? _SkillRow(name: b.$1, level: b.$2, color: b.$3)
                : const SizedBox(),
          ),
        ],
      ));
      if (i + 2 < skills.length) rows.add(const SizedBox(height: 5));
    }

    return Padding(
      padding: const EdgeInsets.fromLTRB(14, 10, 14, 10),
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
            style: GoogleFonts.dmMono(
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
            style: GoogleFonts.dmMono(
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
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      child: Wrap(
        spacing: 6,
        runSpacing: 6,
        children: [
          _Pill(
            '💀 ${SaveFile.formatCount(save.monstersKilled)} monstruos',
            textColor: _kMonstruos,
            borderColor: const Color(0xFF5A2010),
            bgColor: const Color(0xFF100806),
          ),
          _Pill(
            '❤️ ${save.goodFriends} amigos',
            textColor: _kAmigos,
            borderColor: const Color(0xFF5A1838),
            bgColor: const Color(0xFF100610),
          ),
          _Pill(
            '😵‍💫 ${save.timesUnconscious} desmayos',
            textColor: _kDesmayos,
            borderColor: const Color(0xFF303858),
            bgColor: const Color(0xFF08090E),
          ),
          if (save.averageBedtime > 0)
            _Pill(
              '🛏️ Duerme ${save.bedtimeLabel}',
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
    this.onUpload,
    this.onDownload,
    this.onDeleteFromDrive,
    this.onDeleteLocal,
  });
  final SaveEntry entry;
  final VoidCallback? onUpload;
  final VoidCallback? onDownload;
  final VoidCallback? onDeleteFromDrive;
  final VoidCallback? onDeleteLocal;

  @override
  Widget build(BuildContext context) {
    final status = entry.status;
    final localAhead =
        status == SaveSyncStatus.localAhead || status == SaveSyncStatus.localOnly;
    final driveAhead =
        status == SaveSyncStatus.driveAhead || status == SaveSyncStatus.driveOnly;
    final isMobile = Platform.isAndroid || Platform.isIOS;

    return Padding(
      padding: const EdgeInsets.fromLTRB(10, 9, 10, 9),
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: _SideTile(
                color: _kLocal,
                icon: isMobile ? '📱' : '💻',
                title: isMobile ? 'EN ESTE MÓVIL' : 'EN ESTE EQUIPO',
                save: entry.local,
                highlight: localAhead && entry.drive != null,
                entry: entry,
                isLocalSide: true,
                onUpload: onUpload,
                onDownload: onDownload,
                onDeleteFromDrive: onDeleteFromDrive,
                onDeleteLocal: onDeleteLocal,
              ),
            ),
            const SizedBox(width: 7),
            Expanded(
              child: _SideTile(
                color: _kDrive,
                icon: '☁️',
                title: 'EN DRIVE',
                save: entry.drive,
                highlight: driveAhead && entry.local != null,
                entry: entry,
                isLocalSide: false,
                onUpload: onUpload,
                onDownload: onDownload,
                onDeleteFromDrive: onDeleteFromDrive,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SideTile extends StatelessWidget {
  const _SideTile({
    required this.color,
    required this.icon,
    required this.title,
    required this.save,
    required this.highlight,
    required this.entry,
    required this.isLocalSide,
    this.onUpload,
    this.onDownload,
    this.onDeleteFromDrive,
    this.onDeleteLocal,
  });

  final Color color;
  final String icon;
  final String title;
  final SaveFile? save;
  final bool highlight;
  final SaveEntry entry;
  final bool isLocalSide;
  final VoidCallback? onUpload;
  final VoidCallback? onDownload;
  final VoidCallback? onDeleteFromDrive;
  final VoidCallback? onDeleteLocal;

  @override
  Widget build(BuildContext context) {
    final present = save != null;
    final base = present ? color : Colors.white.withValues(alpha: 0.20);

    final content = Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: present
            ? color.withValues(alpha: 0.08)
            : Colors.white.withValues(alpha: 0.02),
        border: Border.all(
          color: base.withValues(alpha: highlight ? 0.9 : 0.36),
          width: highlight ? 1.4 : 1,
        ),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(icon, style: const TextStyle(fontSize: 11)),
              const SizedBox(width: 5),
              Text(
                title,
                style: GoogleFonts.dmMono(
                  fontSize: 7.5,
                  letterSpacing: 0.6,
                  color: base.withValues(alpha: 0.95),
                ),
              ),
              if (highlight) ...[
                const SizedBox(width: 4),
                Text('▲', style: TextStyle(fontSize: 8, color: color)),
              ],
            ],
          ),
          const SizedBox(height: 5),
          if (present) ...[
            Text(
              'Día ${save!.dayOfMonth} · Año ${save!.year}',
              style: GoogleFonts.dmMono(
                fontSize: 11,
                fontWeight: FontWeight.w500,
                color: Colors.white.withValues(alpha: 0.88),
              ),
            ),
            const SizedBox(height: 2),
            Text(
              '${save!.playtimeLabel} · ${_rel(save!.lastModified)}',
              style: GoogleFonts.dmMono(
                fontSize: 8.5,
                color: Colors.white.withValues(alpha: 0.42),
              ),
            ),
          ] else
            Text(
              'No está aquí',
              style: GoogleFonts.dmMono(
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
      onTap: () => _showSaveDetail(
        context,
        entry: entry,
        startOnLocal: isLocalSide,
        onUpload: onUpload,
        onDownload: onDownload,
        onDeleteFromDrive: onDeleteFromDrive,
        onDeleteLocal: onDeleteLocal,
      ),
      child: content,
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
  });

  final SaveEntry entry;
  final Color statusColor;
  final bool busy;
  final VoidCallback? onUpload;
  final VoidCallback? onDownload;

  @override
  Widget build(BuildContext context) {
    final status = entry.status;
    final hasLocal = entry.local != null;
    final hasDrive = entry.drive != null;
    final recommendUpload =
        status == SaveSyncStatus.localOnly || status == SaveSyncStatus.localAhead;
    final recommendDownload =
        status == SaveSyncStatus.driveOnly || status == SaveSyncStatus.driveAhead;

    return Padding(
      padding: const EdgeInsets.fromLTRB(14, 10, 14, 12),
      child: Row(
        children: [
          _Dot(color: statusColor),
          const SizedBox(width: 6),
          Flexible(
            child: Text(
              _shortStatus(status),
              style: GoogleFonts.dmMono(
                fontSize: 10,
                fontWeight: FontWeight.w600,
                color: statusColor,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          const SizedBox(width: 8),
          if (busy)
            const SizedBox(
              width: 15,
              height: 15,
              child: CircularProgressIndicator(strokeWidth: 1.5),
            )
          else if (status == SaveSyncStatus.synced)
            const _ActionBtn(
              label: 'Sincronizado',
              color: _kSynced,
              icon: Icons.check_rounded,
              filled: false,
            )
          else ...[
            // Acción alternativa (ghost) primero; recomendada (filled) a la derecha.
            if (hasLocal && hasDrive && recommendDownload) ...[
              _ActionBtn(
                label: 'Subir',
                color: _kLocal,
                icon: Icons.cloud_upload_outlined,
                filled: false,
                onTap: onUpload,
              ),
              const SizedBox(width: 8),
            ],
            if (hasLocal && hasDrive && recommendUpload) ...[
              _ActionBtn(
                label: 'Descargar',
                color: _kDrive,
                icon: Icons.cloud_download_outlined,
                filled: false,
                onTap: onDownload,
              ),
              const SizedBox(width: 8),
            ],
            if (recommendUpload)
              _ActionBtn(
                label: 'Subir',
                color: _kLocal,
                icon: Icons.cloud_upload_outlined,
                filled: true,
                onTap: onUpload,
              ),
            if (recommendDownload)
              _ActionBtn(
                label: 'Descargar',
                color: _kDrive,
                icon: Icons.cloud_download_outlined,
                filled: true,
                onTap: onDownload,
              ),
          ],
        ],
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
        boxShadow: [BoxShadow(color: color.withValues(alpha: 0.6), blurRadius: 6)],
      ),
    );
  }
}

class _ActionBtn extends StatelessWidget {
  const _ActionBtn({
    required this.label,
    required this.color,
    required this.icon,
    required this.filled,
    this.onTap,
  });

  final String label;
  final Color color;
  final IconData icon;
  final bool filled;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
        decoration: BoxDecoration(
          color: color.withValues(alpha: filled ? 0.16 : 0.0),
          border: Border.all(color: color.withValues(alpha: 0.50)),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 13, color: color),
            const SizedBox(width: 5),
            Text(
              label,
              style: GoogleFonts.dmMono(fontSize: 10, color: color),
            ),
          ],
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
  });

  final String label;
  final Color textColor;
  final Color borderColor;
  final Color bgColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: bgColor,
        border: Border.all(color: borderColor),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: GoogleFonts.dmMono(
          fontSize: 10,
          fontWeight: FontWeight.w500,
          color: textColor,
        ),
      ),
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
        style: GoogleFonts.dmMono(fontSize: 10, color: textColor),
      ),
    );
  }
}
