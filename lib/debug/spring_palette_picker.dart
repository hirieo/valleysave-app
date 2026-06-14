import 'package:flutter/material.dart';
import '../core/models/season_state.dart';

// ─── Paletas de exploración de Primavera ──────────────────────────────────────

class _Palette {
  const _Palette(this.name, this.data);
  final String name;
  final SeasonData data;
}

const _kPalettes = <_Palette>[
  _Palette('Original', SeasonData(
    skyTop:       Color(0xFF221040),
    skyMid:       Color(0xFF6030a0),
    skyBottom:    Color(0xFFd04898),
    hillBack:     Color(0xFF4a8a2a),
    hillColor:    Color(0xFF2e5a18),
    starOpacity:  0.65,
    accentColor:  Color(0xFFf0b8c8),
    mountainFar:  Color(0xFF5030a0),
    mountainNear: Color(0xFF902870),
  )),
  _Palette('A - Indigo', SeasonData(
    skyTop:       Color(0xFF080e28),
    skyMid:       Color(0xFF1a2850),
    skyBottom:    Color(0xFF2a4830),
    hillBack:     Color(0xFF3a6820),
    hillColor:    Color(0xFF1e4010),
    starOpacity:  0.65,
    accentColor:  Color(0xFFf0b8c8),
    mountainFar:  Color(0xFF1a2840),
    mountainNear: Color(0xFF0e2818),
  )),
  _Palette('B - Violeta', SeasonData(
    skyTop:       Color(0xFF0c0820),
    skyMid:       Color(0xFF2a1550),
    skyBottom:    Color(0xFF5a2870),
    hillBack:     Color(0xFF2e5018),
    hillColor:    Color(0xFF1a3010),
    starOpacity:  0.65,
    accentColor:  Color(0xFFf0b8c8),
    mountainFar:  Color(0xFF2a1848),
    mountainNear: Color(0xFF1a1030),
  )),
  _Palette('C - Borgona', SeasonData(
    skyTop:       Color(0xFF0e0818),
    skyMid:       Color(0xFF281040),
    skyBottom:    Color(0xFF6a2850),
    hillBack:     Color(0xFF2e4818),
    hillColor:    Color(0xFF1a2e10),
    starOpacity:  0.65,
    accentColor:  Color(0xFFf0b8c8),
    mountainFar:  Color(0xFF221438),
    mountainNear: Color(0xFF160e28),
  )),
  _Palette('D - Crepusculo', SeasonData(
    skyTop:       Color(0xFF180830),
    skyMid:       Color(0xFF5a1878),
    skyBottom:    Color(0xFFc03888),
    hillBack:     Color(0xFF3a6820),
    hillColor:    Color(0xFF1e4010),
    starOpacity:  0.55,
    accentColor:  Color(0xFFf0b8c8),
    mountainFar:  Color(0xFF381060),
    mountainNear: Color(0xFF1a0838),
  )),
  _Palette('E - Madrugada', SeasonData(
    skyTop:       Color(0xFF100820),
    skyMid:       Color(0xFF3a1068),
    skyBottom:    Color(0xFF9030a0),
    hillBack:     Color(0xFF3a6820),
    hillColor:    Color(0xFF1e4010),
    starOpacity:  0.60,
    accentColor:  Color(0xFFf0b8c8),
    mountainFar:  Color(0xFF2a1050),
    mountainNear: Color(0xFF160830),
  )),
  _Palette('F - Vivida', SeasonData(
    skyTop:       Color(0xFF200838),
    skyMid:       Color(0xFF6820a8),
    skyBottom:    Color(0xFFf060b0),
    hillBack:     Color(0xFF4a7828),
    hillColor:    Color(0xFF2e5018),
    starOpacity:  0.45,
    accentColor:  Color(0xFFf0b8c8),
    mountainFar:  Color(0xFF481878),
    mountainNear: Color(0xFF280a48),
  )),
];

// ─── Widget ───────────────────────────────────────────────────────────────────

class SpringPalettePicker extends StatefulWidget {
  const SpringPalettePicker({super.key});

  @override
  State<SpringPalettePicker> createState() => _SpringPalettePickerState();
}

class _SpringPalettePickerState extends State<SpringPalettePicker> {
  int? _selected; // null = sin override (usa season_state.dart)

  void _pick(int? i) {
    setState(() => _selected = i);
    SeasonData.debugSpringOverride.value = i == null ? null : _kPalettes[i].data;
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
        decoration: BoxDecoration(
          color: const Color(0xCC000000),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.white.withValues(alpha: 0.12)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'DEBUG — Primavera',
              style: TextStyle(
                color: Color(0xFFf0b8c8),
                fontSize: 9,
                fontWeight: FontWeight.w700,
                letterSpacing: 1.2,
              ),
            ),
            const SizedBox(height: 6),
            Wrap(
              spacing: 4,
              runSpacing: 4,
              children: [
                _Chip(
                  label: 'actual',
                  selected: _selected == null,
                  onTap: () => _pick(null),
                ),
                for (int i = 0; i < _kPalettes.length; i++)
                  _Chip(
                    label: _kPalettes[i].name,
                    selected: _selected == i,
                    onTap: () => _pick(i),
                    skyColor: _kPalettes[i].data.skyBottom,
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _Chip extends StatelessWidget {
  const _Chip({
    required this.label,
    required this.selected,
    required this.onTap,
    this.skyColor,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;
  final Color? skyColor;

  @override
  Widget build(BuildContext context) {
    const accent = Color(0xFFf0b8c8);
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
        decoration: BoxDecoration(
          color: selected
              ? accent.withValues(alpha: 0.18)
              : Colors.white.withValues(alpha: 0.06),
          borderRadius: BorderRadius.circular(999),
          border: Border.all(
            color: selected
                ? accent.withValues(alpha: 0.85)
                : Colors.white.withValues(alpha: 0.18),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (skyColor != null) ...[
              Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                  color: skyColor,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 4),
            ],
            Text(
              label,
              style: TextStyle(
                color: selected ? accent : Colors.white54,
                fontSize: 10,
                fontWeight: selected ? FontWeight.w700 : FontWeight.w400,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
