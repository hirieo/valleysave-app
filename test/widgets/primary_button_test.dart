import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:valleysave/shared/widgets/primary_button.dart';

void main() {
  group('PrimaryButton', () {
    testWidgets('renders the label', (tester) async {
      await tester.pumpWidget(MaterialApp(
        home: Scaffold(body: PrimaryButton(label: 'Conectar', onPressed: () {})),
      ));

      expect(find.text('Conectar'), findsOneWidget);
    });

    testWidgets('invokes onPressed when tapped', (tester) async {
      int taps = 0;

      await tester.pumpWidget(MaterialApp(
        home: Scaffold(
          body: PrimaryButton(label: 'Conectar', onPressed: () => taps++),
        ),
      ));

      await tester.tap(find.byType(PrimaryButton));
      await tester.pump();

      expect(taps, 1);
    });

    testWidgets('disables when onPressed is null', (tester) async {
      await tester.pumpWidget(const MaterialApp(
        home: Scaffold(body: PrimaryButton(label: 'Conectar', onPressed: null)),
      ));

      final button = tester.widget<ElevatedButton>(find.byType(ElevatedButton));
      expect(button.onPressed, isNull);
    });
  });
}
