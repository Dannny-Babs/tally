import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';

class AppTextStyles {
  // Space Grotesk for large numbers and headings
  static final displayLarge = GoogleFonts.spaceGrotesk(
    fontSize: 32,
    fontWeight: FontWeight.w500,
    color: AppColors.accent,
  );

  static final displayMedium = GoogleFonts.spaceGrotesk(
    fontSize: 24,
    fontWeight: FontWeight.w500,
    color: AppColors.accent,
  );

  static final displaySmall = GoogleFonts.spaceGrotesk(
    fontSize: 20,
    fontWeight: FontWeight.w500,
    color: AppColors.accent,
  );

  // Space Mono for labels and body text
  static final bodyLarge = GoogleFonts.spaceMono(
    fontSize: 16,
    color: AppColors.accent,
  );

  static final bodyMedium = GoogleFonts.spaceMono(
    fontSize: 14,
    color: AppColors.accent,
  );

  static final bodySmall = GoogleFonts.spaceMono(
    fontSize: 12,
    color: AppColors.accent.withOpacity(0.7),
  );
} 