import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';

class AppTextStyles {
  static final displayLarge = GoogleFonts.spaceGrotesk(
    fontSize: 57,
    fontWeight: FontWeight.w400,
    letterSpacing: -0.25,
    color: AppColors.textPrimaryLight,
  );

  static final displayMedium = GoogleFonts.spaceGrotesk(
    fontSize: 45,
    fontWeight: FontWeight.w400,
    letterSpacing: 0,
    color: AppColors.textPrimaryLight,
  );

  static final displaySmall = GoogleFonts.spaceGrotesk(
    fontSize: 36,
    fontWeight: FontWeight.w400,
    letterSpacing: 0,
    color: AppColors.textPrimaryLight,
  );

  static final headlineLarge = GoogleFonts.spaceGrotesk(
    fontSize: 32,
    fontWeight: FontWeight.w400,
    letterSpacing: 0,
    color: AppColors.textPrimaryLight,
  );

  static final headlineMedium = GoogleFonts.spaceGrotesk(
    fontSize: 28,
    fontWeight: FontWeight.w400,
    letterSpacing: 0,
    color: AppColors.textPrimaryLight,
  );

  static final headlineSmall = GoogleFonts.spaceGrotesk(
    fontSize: 24,
    fontWeight: FontWeight.w400,
    letterSpacing: 0,
    color: AppColors.textPrimaryLight,
  );

  static final titleLarge = GoogleFonts.spaceGrotesk(
    fontSize: 22,
    fontWeight: FontWeight.w500,
    letterSpacing: 0,
    color: AppColors.textPrimaryLight,
  );

  static final titleMedium = GoogleFonts.spaceGrotesk(
    fontSize: 16,
    fontWeight: FontWeight.w500,
    letterSpacing: 0.15,
    color: AppColors.textPrimaryLight,
  );

  static final titleSmall = GoogleFonts.spaceGrotesk(
    fontSize: 14,
    fontWeight: FontWeight.w500,
    letterSpacing: 0.1,
    color: AppColors.textPrimaryLight,
  );

  static final labelLarge = GoogleFonts.spaceGrotesk(
    fontSize: 14,
    fontWeight: FontWeight.w500,
    letterSpacing: 0.1,
    color: AppColors.textPrimaryLight,
  );

  static final labelMedium = GoogleFonts.spaceGrotesk(
    fontSize: 12,
    fontWeight: FontWeight.w500,
    letterSpacing: 0.5,
    color: AppColors.textPrimaryLight,
  );

  static final labelSmall = GoogleFonts.spaceGrotesk(
    fontSize: 11,
    fontWeight: FontWeight.w500,
    letterSpacing: 0.5,
    color: AppColors.textPrimaryLight         ,
  );

  static final bodyLarge = GoogleFonts.spaceGrotesk(
    fontSize: 16,
    fontWeight: FontWeight.w400,
    letterSpacing: 0.5,
    color: AppColors.textPrimaryLight,
  );

  static final bodyMedium = GoogleFonts.spaceGrotesk(
    fontSize: 14,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.25,
    color: AppColors.textPrimaryLight,
  );

  static final bodySmall = GoogleFonts.spaceGrotesk(
    fontSize: 12,
    fontWeight: FontWeight.w400,
    letterSpacing: 0.4,
    color: AppColors.textPrimaryLight,
  );

  // Convenience aliases
  static final heading1 = displayLarge;
  static final heading2 = displayMedium;
  static final heading3 = displaySmall;
  static final heading4 = headlineLarge;
  static final heading5 = headlineMedium;
  static final heading6 = headlineSmall;
  static final subtitle1 = titleLarge;
  static final subtitle2 = titleMedium;
  static final body = bodyMedium;
  static final caption = bodySmall;
  static final button = labelLarge;
  static final overline = labelSmall;
  static final label = labelMedium;
}
