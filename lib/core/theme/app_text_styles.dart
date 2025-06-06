import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';

class AppTextStyles {
  // Space Grotesk for large numbers and headings
  static final displayLarge = GoogleFonts.spaceGrotesk(
    fontSize: 32,
    fontWeight: FontWeight.w500,
    color: AppColors.textPrimaryLight,
  );

  static final displayMedium = GoogleFonts.spaceGrotesk(
    fontSize: 24,
    fontWeight: FontWeight.w500,
    color: AppColors.textPrimaryLight,
  );

  static final displaySmall = GoogleFonts.spaceGrotesk(
    fontSize: 20,
    fontWeight: FontWeight.w500,
    color: AppColors.textPrimaryLight,
  );

  // Space Mono for labels and body text
  static final bodyLarge = GoogleFonts.spaceMono(
    fontSize: 16,
    color: AppColors.textPrimaryLight,
  );

  static final bodyMedium = GoogleFonts.spaceGrotesk(
    fontSize: 14,
    color: AppColors.textPrimaryLight,
  );

  static final bodySmall = GoogleFonts.spaceMono(
    fontSize: 12,
    color: AppColors.textPrimaryLight.withAlpha((0.7 * 255).round()),
  );
}
