import 'package:flutter/material.dart';

class AppPageRoute<T> extends PageRouteBuilder<T> {
  AppPageRoute({required this.builder, super.settings})
      : super(
          pageBuilder: (context, animation, secondaryAnimation) =>
              builder(context),
          transitionDuration: const Duration(milliseconds: 280),
          reverseTransitionDuration: const Duration(milliseconds: 220),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            const curve = Cubic(0.23, 1, 0.32, 1);
            final fade = animation.drive(
              Tween<double>(begin: 0.0, end: 1.0).chain(CurveTween(curve: curve)),
            );
            final scale = animation.drive(
              Tween<double>(begin: 0.96, end: 1.0).chain(CurveTween(curve: curve)),
            );
            return FadeTransition(
              opacity: fade,
              child: ScaleTransition(scale: scale, child: child),
            );
          },
        );

  /// Guardado (no solo pasado al `pageBuilder`) para que `GamepadService`
  /// pueda reabrir la MISMA pantalla si el mando la cierra con LT y luego
  /// la reabre con RT — sin esto, una vez hecho pop no hay forma de saber
  /// cómo reconstruirla.
  final WidgetBuilder builder;
}
