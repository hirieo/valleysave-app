import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:valleysave/shared/widgets/pressable_scale.dart';

void main() {
  testWidgets('reduce al pulsar y vuelve a escala normal al soltar', (
    tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Center(
          child: PressableScale(
            onTap: () {},
            child: const SizedBox(
              key: ValueKey('target'),
              width: 80,
              height: 40,
            ),
          ),
        ),
      ),
    );

    final gesture = await tester.startGesture(
      tester.getCenter(find.byKey(const ValueKey('target'))),
    );
    await tester.pump(const Duration(milliseconds: 120));
    expect(
      tester.widget<AnimatedScale>(find.byType(AnimatedScale)).scale,
      0.97,
    );

    await gesture.up();
    await tester.pump(const Duration(milliseconds: 120));
    expect(tester.widget<AnimatedScale>(find.byType(AnimatedScale)).scale, 1);
  });

  testWidgets('respeta la preferencia de reducir animaciones', (tester) async {
    await tester.pumpWidget(
      MediaQuery(
        data: const MediaQueryData(disableAnimations: true),
        child: MaterialApp(
          home: PressableScale(
            onTap: () {},
            child: const SizedBox(width: 80, height: 40),
          ),
        ),
      ),
    );

    await tester.press(find.byType(PressableScale));
    await tester.pump();
    expect(
      tester.widget<AnimatedScale>(find.byType(AnimatedScale)).duration,
      Duration.zero,
    );
  });
}
