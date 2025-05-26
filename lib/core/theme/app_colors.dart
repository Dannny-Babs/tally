import 'package:flutter/material.dart';

/// Defines the app’s semantic color system using your warm-brown palette.
/// Organized for light/dark theming and clear visual hierarchy.
class AppColors {
  // Primary Brown Scale
  static const Color primary50  = Color(0xFFFAF7F5);
  static const Color primary100 = Color(0xFFF5F0EC);
  static const Color primary200 = Color(0xFFEEE3D9);
  static const Color primary300 = Color(0xFFE7D6C6);
  static const Color primary400 = Color(0xFFE0C9B3);
  static const Color primary500 = Color(0xFFC5B1A4); // Main primary
  static const Color primary600 = Color(0xFFB39E91);
  static const Color primary700 = Color(0xFFA18B7E);
  static const Color primary800 = Color(0xFF8F796B);
  static const Color primary900 = Color(0xFF7D5852);

  // Neutral Scale (beige‐offwhite)
  static const Color neutral50  = Color(0xFFFCFBFA);
  static const Color neutral100 = Color(0xFFF7F5F2);
  static const Color neutral200 = Color(0xFFF1EFEA);
  static const Color neutral300 = Color(0xFFECE9E3);
  static const Color neutral400 = Color(0xFFE7E3DD);
  static const Color neutral500 = Color(0xFFDED5CE); // Soft beige
  static const Color neutral600 = Color(0xFFD4C3B8);
  static const Color neutral700 = Color(0xFFB39E91);
  static const Color neutral800 = Color(0xFF806754);
  static const Color neutral900 = Color(0xFF5E4235); // Dark brown

  // Semantic Surface & Background
  static const Color backgroundLight = neutral50;
  static const Color backgroundDark  = neutral900;
  static const Color surfaceLight    = Colors.white;
  static const Color surfaceDark     = Color(0xFF3E332A);

  // Text Colors
  static const Color textPrimaryLight   = neutral900;
  static const Color textSecondaryLight = neutral600;
  static const Color textPrimaryDark    = neutral50;
  static const Color textSecondaryDark  = neutral300;

  // Border & Divider
  static const Color borderLight = neutral200;
  static const Color borderDark  = Color(0xFF5E4B41);

  // Status Colors
  static const Color success = Color(0xFF22C55E);
  static const Color error   = Color(0xFFEF4444);
  static const Color warning = Color(0xFFFACC15);
  static const Color info    = primary500;

  // Overlays & Shadows
  static const Color overlayLight = Color(0x0A000000); // 4% black
  static const Color overlayDark  = Color(0x0AFFFFFF); // 4% white
  static const Color shadowLight  = Color(0x1A000000); // 10% black
  static const Color shadowDark   = Color(0x1A000000); // 10% black
}
