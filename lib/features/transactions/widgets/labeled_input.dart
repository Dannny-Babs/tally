import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';

class LabeledInput extends StatelessWidget {
  final String label;
  final String? hint;
  final String? errorText;
  final Widget child;

  const LabeledInput({
    super.key,
    required this.label,
    this.hint,
    this.errorText,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTextStyles.bodyMedium.copyWith(
            color: AppColors.accentLight,
            fontWeight: FontWeight.w600,
            fontSize: 14,
            letterSpacing: -0.15,
            fontFamily: GoogleFonts.spaceGrotesk().fontFamily,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: AppColors.secondary.withOpacity(0.3),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color:
                  errorText != null
                      ? Colors.red.withOpacity(0.5)
                      : AppColors.primaryLight.withAlpha(150),
            ),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: child,
        ),
        if (errorText != null) ...[
          const SizedBox(height: 4),
          Text(
            errorText!,
            style: AppTextStyles.bodySmall.copyWith(
              color: Colors.red,
              fontSize: 12,
            ),
          ),
        ],
      ],
    );
  }
}
