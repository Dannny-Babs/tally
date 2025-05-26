import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:heroicons/heroicons.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';

class ActivityCard extends StatelessWidget {
  final HeroIcons icon;
  final String title;
  final String subtitle;
  final double amount;
  final bool isIncome;

  const ActivityCard({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.amount,
    this.isIncome = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.backgroundLight,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppColors.borderLight,
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
            ),
            child: HeroIcon(
              icon,
              style: HeroIconStyle.solid,
              color: AppColors.textPrimaryLight,
              size: 20,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: AppColors.textPrimaryLight,
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                    letterSpacing: -0.15,
                    fontFamily: GoogleFonts.spaceGrotesk().fontFamily,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: AppTextStyles.bodySmall.copyWith(
                    color: AppColors.textPrimaryLight,
                    fontSize: 12,
                    letterSpacing: -0.08,
                    fontFamily: GoogleFonts.spaceGrotesk().fontFamily,
                  ),
                ),
              ],
            ),
          ),
          Text(
            '${isIncome ? '+' : '-'}\$${amount.toStringAsFixed(0)}',
            style: AppTextStyles.bodyMedium.copyWith(
              color: isIncome ? AppColors.primary500 : AppColors.neutral600,
              fontWeight: FontWeight.w600,
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