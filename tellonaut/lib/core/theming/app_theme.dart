/// lib/core/theming/app_theme.dart – zentrale Design‑Tokens & Theme
/// Auto‑generiert (Tellonaut Design‑System)
///
/// Enthält:
///   • AppColors – Farbpalette für Drohnen‑Kategorien & UI
///   • AppSpacing – 4‑px‑Raster‑Helpers
///   • AppRadii   – Corner‑Radius‑Stufen
///   • AppShadows – 3‑stufiges Shadow‑Preset
///   • AppTypography – TextStyles basierend auf Inter & JetBrains Mono
///   • buildAppTheme() – ThemeData für Material 3
///
/// Positioniere diese Datei in `lib/core/theming/app_theme.dart`.
/// Alle Feature‑Packages importieren Theme über:
///   import 'package:tellonaut/core/theming/app_theme.dart';

import 'package:flutter/material.dart';

//══════════════════════════════════════════════════════════════════════════════
// 🟣  COLORS
//══════════════════════════════════════════════════════════════════════════════
class AppColors {
  // Brand & Surfaces
  static const primary = Color(0xFF006CFF);
  static const surface = Color(0xFFF7F9FC);
  static const error = Color(0xFFB00020);
  static const success = Color(0xFF00C853);

  // Drohnen‑Kategorien (Blockly‑Hue‑Mapping)
  static const flight = Color(0xFF006CFF); // Flug & Safety
  static const movement = Color(0xFFFF9100); // Bewegung & Stunts
  static const sensors = Color(0xFF009688); // Sensoren & Daten
  static const light = Color(0xFFD500F9); // Licht & Matrix
  static const vision = Color(0xFF673AB7); // Vision / QR / Bild
  static const settings = Color(0xFF607D8B); // Einstellungen & System
}

//══════════════════════════════════════════════════════════════════════════════
// 🟡  SPACING
//══════════════════════════════════════════════════════════════════════════════
class AppSpacing {
  static const double x1 = 4;
  static const double x2 = 8;
  static const double x3 = 12;
  static const double x4 = 16;
  static const double x6 = 24;
  static const double x8 = 32;
  static const double x10 = 40;
  static const double x14 = 56;
  static const double x18 = 72;
}

//══════════════════════════════════════════════════════════════════════════════
// 🟢  RADII
//══════════════════════════════════════════════════════════════════════════════
class AppRadii {
  static const double sm = 8;
  static const double md = 12;
  static const double lg = 16;
}

//══════════════════════════════════════════════════════════════════════════════
// 🔵  SHADOWS
//══════════════════════════════════════════════════════════════════════════════
class AppShadows {
  static final light = [
    BoxShadow(
      color: Colors.black.withOpacity(0.04),
      blurRadius: 2,
      offset: const Offset(0, 1),
    ),
  ];
  static final medium = [
    BoxShadow(
      color: Colors.black.withOpacity(0.08),
      blurRadius: 4,
      offset: const Offset(0, 2),
    ),
  ];
  static final heavy = [
    BoxShadow(
      color: Colors.black.withOpacity(0.16),
      blurRadius: 8,
      offset: const Offset(0, 4),
    ),
  ];
}

//══════════════════════════════════════════════════════════════════════════════
// 🟠  TYPOGRAPHY
//══════════════════════════════════════════════════════════════════════════════
class AppTypography {
  static const _fontUI = 'Inter';
  static const _fontCode = 'JetBrainsMono';

  static final displayLarge = TextStyle(
    fontFamily: _fontUI,
    fontWeight: FontWeight.w700,
    fontSize: 32,
    letterSpacing: -0.5,
    height: 1.2,
    color: Colors.black87,
  );
  static final headlineMedium = TextStyle(
    fontFamily: _fontUI,
    fontWeight: FontWeight.w600,
    fontSize: 20,
    height: 1.3,
    color: Colors.black87,
  );
  static final bodyLarge = TextStyle(
    fontFamily: _fontUI,
    fontWeight: FontWeight.w400,
    fontSize: 16,
    height: 1.5,
    color: Colors.black87,
  );
  static final bodySmall = TextStyle(
    fontFamily: _fontUI,
    fontWeight: FontWeight.w400,
    fontSize: 12,
    height: 1.4,
    color: Colors.black54,
  );
  static final code = TextStyle(
    fontFamily: _fontCode,
    fontWeight: FontWeight.w400,
    fontSize: 14,
    height: 1.5,
    color: Colors.black87,
  );
}

//══════════════════════════════════════════════════════════════════════════════
// 🟣  THEME BUILDER
//══════════════════════════════════════════════════════════════════════════════
ThemeData buildAppTheme() {
  return ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.fromSeed(
      seedColor: AppColors.primary,
      surface: AppColors.surface,
      error: AppColors.error,
    ),
    scaffoldBackgroundColor: AppColors.surface,
    textTheme: TextTheme(
      displayLarge: AppTypography.displayLarge,
      headlineMedium: AppTypography.headlineMedium,
      bodyLarge: AppTypography.bodyLarge,
      bodySmall: AppTypography.bodySmall,
      labelSmall: AppTypography.bodySmall,
    ),
    appBarTheme: const AppBarTheme(
      elevation: 0,
      backgroundColor: AppColors.surface,
      foregroundColor: Colors.black87,
    ),
    cardTheme: CardTheme(
      color: Colors.white,
      elevation: 0,
      margin: const EdgeInsets.all(AppSpacing.x4),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppRadii.md),
      ),
      shadowColor: Colors.black.withOpacity(0.08),
    ),
    dialogTheme: DialogTheme(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppRadii.lg),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppRadii.sm),
        borderSide: BorderSide(color: Colors.grey.shade400),
      ),
    ),
  );
}
