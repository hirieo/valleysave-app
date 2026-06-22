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
  });

  final SaveEntry entry;
  final bool busy;
  final VoidCallback? onUpload;   // local → Drive
  final VoidCallback? onDownload; // Drive → local

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
            _TilesRow(save: save),
            _kDivider,
            _SkillsGrid(save: save),
            _kDivider,
            _PillsRow(save: save),
            _kDivider,
            _PresenceRow(entry: entry),
            _kDivider,
            _Footer(
              entry: entry,
              statusColor: st.color,
              statusLabel: st.label,
              busy: busy,
              onUpload: onUpload,
              onDownload: onDownload,
            ),
          ],
        ),
      ),
    );
  }

  static final _kDivider = Container(height: 1, color: Colors.white.withValues(alpha: 0.08));
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
    final mineLabel = save.deepestMineLevel == 0
        ? 'Sin explorar'
        : 'Nv. ${save.deepestMineLevel}';

    final bg  = _tileBg(save.seasonColor);
    final bdr = _tileBdr(save.seasonColor);

    return Padding(
      padding: const EdgeInsets.all(10),
      child: Row(
        children: [
          _BigTile(save: save),
          const SizedBox(width: 7),
          Expanded(
            child: _MiniTile(
              icon: _CoinIcon(),
              value: save.currentMoneyLabel,
              label: 'Monedas',
              valueColor: _kMoneyNow,
              bgColor: bg,
              borderColor: bdr,
            ),
          ),
          const SizedBox(width: 7),
          Expanded(
            child: _MiniTile(
              icon: const Text('💰', style: TextStyle(fontSize: 12)),
              value: save.totalMoneyLabel,
              label: 'Total',
              valueColor: _kMoneyTotal,
              bgColor: bg,
              borderColor: bdr,
            ),
          ),
          const SizedBox(width: 7),
          Expanded(
            child: _MiniTile(
              icon: const Text('⛏️', style: TextStyle(fontSize: 12)),
              value: mineLabel,
              label: 'Mina',
              valueColor: _kMineLevel,
              bgColor: bg,
              borderColor: bdr,
            ),
          ),
        ],
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
                child: Text(
                  value,
                  style: GoogleFonts.dmMono(
                    fontSize: 11,
                    fontWeight: FontWeight.w500,
                    color: valueColor,
                  ),
                  overflow: TextOverflow.ellipsis,
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
              const gap = 1.5;
              final pipW =
                  ((constraints.maxWidth - gap * 9) / 10).clamp(4.0, 7.0);
              return Row(
                children: List.generate(10, (i) {
                  return Padding(
                    padding: i < 9
                        ? const EdgeInsets.only(right: gap)
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
  const _PresenceRow({required this.entry});
  final SaveEntry entry;

  @override
  Widget build(BuildContext context) {
    final status = entry.status;
    final localAhead =
        status == SaveSyncStatus.localAhead || status == SaveSyncStatus.localOnly;
    final driveAhead =
        status == SaveSyncStatus.driveAhead || status == SaveSyncStatus.driveOnly;

    return Padding(
      padding: const EdgeInsets.fromLTRB(10, 9, 10, 9),
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: _SideTile(
                color: _kLocal,
                icon: '💻',
                title: 'EN ESTE EQUIPO',
                save: entry.local,
                highlight: localAhead && entry.drive != null,
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
  });

  final Color color;
  final String icon;
  final String title;
  final SaveFile? save;
  final bool highlight;

  @override
  Widget build(BuildContext context) {
    final present = save != null;
    final base = present ? color : Colors.white.withValues(alpha: 0.20);

    return Container(
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
  }
}

// ── Footer: estado + acciones ─────────────────────────────────────────────────

class _Footer extends StatelessWidget {
  const _Footer({
    required this.entry,
    required this.statusColor,
    required this.statusLabel,
    required this.busy,
    this.onUpload,
    this.onDownload,
  });

  final SaveEntry entry;
  final Color statusColor;
  final String statusLabel;
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
              statusLabel,
              style: GoogleFonts.dmMono(
                fontSize: 9.5,
                fontWeight: FontWeight.w500,
                color: statusColor,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          const Spacer(),
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
            if (hasLocal && hasDrive && recommendDownload)
              _TextAlt(label: 'Subir', onTap: onUpload),
            if (hasLocal && hasDrive && recommendUpload)
              _TextAlt(label: 'Descargar', onTap: onDownload),
            if (recommendUpload)
              _ActionBtn(
                label: 'Subir a Drive',
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

class _TextAlt extends StatelessWidget {
  const _TextAlt({required this.label, this.onTap});
  final String label;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 10),
      child: GestureDetector(
        onTap: onTap,
        child: Text(
          label,
          style: GoogleFonts.dmMono(
            fontSize: 9,
            color: Colors.white.withValues(alpha: 0.45),
            decoration: TextDecoration.underline,
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
