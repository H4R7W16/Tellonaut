// lib/core/theming/app_spacing.dart – 4‑px Raster‑Helpers
// Auto‑generiert aus spacing.png (Design‑System)

import 'package:flutter/widgets.dart';

/// Spacing‑Konstanten im 4‑px‑Grid.
/// Namenskonvention: x1 = 4 px, x2 = 8 px usw.
class AppSpacing {
  AppSpacing._(); // keine Instanzierung

  static const double x1 = 4;
  static const double x2 = 8;
  static const double x3 = 12;
  static const double x4 = 16;
  static const double x6 = 24;
  static const double x8 = 32;
  static const double x10 = 40;
  static const double x14 = 56;
  static const double x18 = 72;

  // EdgeInsets Helfer ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░

  // Gleichmäßig
  static const all1 = EdgeInsets.all(x1);
  static const all2 = EdgeInsets.all(x2);
  static const all3 = EdgeInsets.all(x3);
  static const all4 = EdgeInsets.all(x4);
  static const all6 = EdgeInsets.all(x6);
  static const all8 = EdgeInsets.all(x8);
  static const all10 = EdgeInsets.all(x10);
  static const all14 = EdgeInsets.all(x14);
  static const all18 = EdgeInsets.all(x18);

  // Symmetrisch horizontal / vertikal
  static const h2 = EdgeInsets.symmetric(horizontal: x2);
  static const h4 = EdgeInsets.symmetric(horizontal: x4);
  static const v2 = EdgeInsets.symmetric(vertical: x2);
  static const v4 = EdgeInsets.symmetric(vertical: x4);
}
