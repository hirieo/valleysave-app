import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:valleysave/features/saves/widgets/backup_action_button.dart';

void main() {
  testWidgets('muestra feedback de presión a escala 0.97', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: BackupActionButton(
            label: 'Restaurar',
            icon: Icons.settings_backup_restore_rounded,
            color: Colors.blue,
            onPressed: () async {},
          ),
        ),
      ),
    );

    final gesture = await tester.startGesture(
      tester.getCenter(find.text('Restaurar')),
    );
    await tester.pump();
    expect(tester.widget<AnimatedScale>(find.byType(AnimatedScale)).scale, .97);
    await gesture.up();
  });

  testWidgets('spinner bloquea el doble toque mientras trabaja', (
    tester,
  ) async {
    final completer = Completer<void>();
    var calls = 0;
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: BackupActionButton(
            label: 'Descargar',
            icon: Icons.download_rounded,
            color: Colors.blue,
            onPressed: () {
              calls++;
              return completer.future;
            },
          ),
        ),
      ),
    );

    await tester.tap(find.text('Descargar'));
    await tester.pump();
    await tester.tap(find.byType(BackupActionButton));
    await tester.pump();

    expect(calls, 1);
    expect(
      find.byKey(const ValueKey('backup-action-progress')),
      findsOneWidget,
    );

    completer.complete();
    await tester.pumpAndSettle();
    expect(find.byKey(const ValueKey('backup-action-progress')), findsNothing);
  });
}
