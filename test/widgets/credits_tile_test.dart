import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:valleysave/features/settings/widgets/credits_tile.dart';
import 'package:valleysave/generated/app_localizations.dart';

/// Créditos de Ajustes: desplegable con el autor y sus enlaces.
void main() {
  setUpAll(() => GoogleFonts.config.allowRuntimeFetching = false);

  const github = ValueKey('credits-link-github');
  const linkedin = ValueKey('credits-link-linkedin');
  const email = ValueKey('credits-link-email');

  Future<void> pump(
    WidgetTester tester, {
    bool disableAnimations = false,
  }) async {
    tester.view.physicalSize = const Size(900, 1600);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    await tester.pumpWidget(
      MaterialApp(
        locale: const Locale('es'),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        builder: (context, child) => MediaQuery(
          data: MediaQuery.of(
            context,
          ).copyWith(disableAnimations: disableAnimations),
          child: child!,
        ),
        home: const Scaffold(
          body: Center(
            child: SizedBox(
              width: 420,
              child: CreditsTile(accent: Color(0xFFF0B8C8)),
            ),
          ),
        ),
      ),
    );
  }

  testWidgets('cerrado enseña el nombre y oculta los enlaces', (tester) async {
    await pump(tester);

    expect(find.text('Hirieo'), findsOneWidget);
    expect(find.text('Licendey Nuñez'), findsOneWidget);
    expect(find.byKey(github), findsNothing);
    expect(find.byKey(linkedin), findsNothing);
    expect(find.byKey(email), findsNothing);
  });

  testWidgets('al pulsar la cabecera se abren los tres enlaces', (
    tester,
  ) async {
    await pump(tester);

    await tester.tap(find.byKey(const ValueKey('credits-header')));
    await tester.pumpAndSettle();

    expect(find.byKey(github), findsOneWidget);
    expect(find.byKey(linkedin), findsOneWidget);
    expect(find.byKey(email), findsOneWidget);
    expect(find.text('github.com/hirieo'), findsOneWidget);
    expect(find.text('linkedin.com/in/licendey'), findsOneWidget);
    expect(find.text('lhirieo@gmail.com'), findsOneWidget);
  });

  testWidgets('pulsar otra vez la cabecera los vuelve a ocultar', (
    tester,
  ) async {
    await pump(tester);

    await tester.tap(find.byKey(const ValueKey('credits-header')));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const ValueKey('credits-header')));
    await tester.pumpAndSettle();

    expect(find.byKey(github), findsNothing);
  });

  testWidgets('con reducir animaciones se abre sin esperar', (tester) async {
    await pump(tester, disableAnimations: true);

    await tester.tap(find.byKey(const ValueKey('credits-header')));
    await tester.pump();

    expect(find.byKey(github), findsOneWidget);
  });

  testWidgets('pulsar el correo lo copia y avisa', (tester) async {
    String? copied;
    tester.binding.defaultBinaryMessenger.setMockMethodCallHandler(
      SystemChannels.platform,
      (call) async {
        if (call.method == 'Clipboard.setData') {
          copied = (call.arguments as Map)['text'] as String?;
        }
        return null;
      },
    );
    addTearDown(
      () => tester.binding.defaultBinaryMessenger.setMockMethodCallHandler(
        SystemChannels.platform,
        null,
      ),
    );
    await pump(tester);

    await tester.tap(find.byKey(const ValueKey('credits-header')));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(email));
    await tester.pump();

    expect(copied, 'lhirieo@gmail.com');
    expect(find.text('Correo copiado'), findsOneWidget);
  });
}
