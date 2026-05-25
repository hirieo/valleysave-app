import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:valleysave/shared/widgets/ghost_button.dart';

void main() {
  group('GhostButton', () {
    testWidgets('renders the label', (tester) async {
      await tester.pumpWidget(MaterialApp(
        home: Scaffold(body: GhostButton(label: 'Cómo funciona', onPressed: () {})),
      ));

      expect(find.text('Cómo funciona'), findsOneWidget);
    });

    testWidgets('invokes onPressed when tapped', (tester) async {
      int taps = 0;

      await tester.pumpWidget(MaterialApp(
        home: Scaffold(
          body: GhostButton(label: 'Cómo funciona', onPressed: () => taps++),
        ),
      ));

      await tester.tap(find.byType(GhostButton));
      await tester.pump();

      expect(taps, 1);
    });
  });
}
