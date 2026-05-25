import 'package:flutter/widgets.dart';

class AppRadius {
  AppRadius._();

  static const double sm   = 6;
  static const double md   = 12;
  static const double lg   = 18;
  static const double xl   = 24;
  static const double pill = 999;

  static const BorderRadius brSm   = BorderRadius.all(Radius.circular(sm));
  static const BorderRadius brMd   = BorderRadius.all(Radius.circular(md));
  static const BorderRadius brLg   = BorderRadius.all(Radius.circular(lg));
  static const BorderRadius brXl   = BorderRadius.all(Radius.circular(xl));
  static const BorderRadius brPill = BorderRadius.all(Radius.circular(pill));
}
