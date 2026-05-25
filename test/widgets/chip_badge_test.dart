import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:valleysave/shared/widgets/chip_badge.dart';

void main() {
  group('ChipBadge', () {
    testWidgets('renders the provided label text', (tester) async {
      await tester.pumpWidget(const MaterialApp(
        home: Scaffold(body: ChipBadge(label: 'Código abierto · MIT')),
      ));

      expect(find.text('CÓDIGO ABIERTO · MIT'), findsOneWidget);
    });

    testWidgets('eyebrow style has positive letterSpacing', (tester) async {
      await tester.pumpWidget(const MaterialApp(
        home: Scaffold(body: ChipBadge(label: 'gratis')),
      ));

      final texts = tester.widgetList<Text>(find.byType(Text));
      final labelText = texts.firstWhere((t) => t.data == 'GRATIS');
      expect(labelText.style?.letterSpacing, greaterThan(0));
    });
  });
}
