import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:heroicons/heroicons.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';

class EmptyStatePlaceholder extends StatelessWidget {
  final String message;

  const EmptyStatePlaceholder({
    super.key,
    required this.message,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.accent.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: HeroIcon(
              HeroIcons.documentText,
              style: HeroIconStyle.solid,
              color: AppColors.accent,
              size: 32,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            message,
            textAlign: TextAlign.center,
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.primary,
              fontSize: 16,
              letterSpacing: -0.15,
              fontFamily: GoogleFonts.spaceGrotesk().fontFamily,
            ),
          ),
        ],
      ),
    );
  }
} 