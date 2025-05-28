import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';

class LabeledInput extends StatelessWidget {
  final String label;
  final Widget child;
  final String? errorText;

  const LabeledInput({
    super.key,
    required this.label,
    required this.child,
    this.errorText,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTextStyles.bodyMedium.copyWith(
            color: AppColors.textPrimaryLight,
            fontWeight: FontWeight.w600,
            fontSize: 14,
            letterSpacing: -0.15,
            fontFamily: GoogleFonts.spaceGrotesk().fontFamily,
          ),
        ),
        const SizedBox(height: 4),
        child,
        if (errorText != null) ...[
          const SizedBox(height: 4),
          Text(
            errorText!,
            style: AppTextStyles.bodySmall.copyWith(
              color: AppColors.error,
              fontSize: 12,
              letterSpacing: -0.15,
              fontFamily: GoogleFonts.spaceGrotesk().fontFamily,
            ),
          ),
        ],
      ],
    );
  }
} 