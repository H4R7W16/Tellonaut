// lib/core/theming/app_radii_shadows.dart – Radius‑ & Shadow‑Tokens
// Auto‑generiert aus radius_shadows.pdf + radius‑shadows.css

import 'package:flutter/material.dart';

/// Einheitliche Corner‑Radii nach Design‑System.
class AppRadii {
  AppRadii._();

  static const double sm = 8.0; // z. B. Buttons, Tags
  static const double md = 12.0; // Cards, Dialogs
  static const double lg = 16.0; // Modals, Floating‑Panels
}

/// Drei BoxShadow‑Stufen für helle Themes.
class AppShadows {
  AppShadows._();

  static const light = [
    BoxShadow(
      color: Colors.black12, // 12 % Opacity
      offset: Offset(0, 2),
      blurRadius: 4,
      spreadRadius: 0,
    ),
  ];

  static const medium = [
    BoxShadow(
      color: Colors.black26, // 26 % Opacity
      offset: Offset(0, 4),
      blurRadius: 8,
      spreadRadius: 0,
    ),
  ];

  static const heavy = [
    BoxShadow(
      color: Colors.black38, // 38 % Opacity
      offset: Offset(0, 8),
      blurRadius: 16,
      spreadRadius: 0,
    ),
  ];
}
