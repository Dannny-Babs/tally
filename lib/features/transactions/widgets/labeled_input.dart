import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';

class LabeledInput extends StatelessWidget {
  final String label;
  final String? hint;
  final String? errorText;
  final Widget child;
  final bool isRequired;

  const LabeledInput({
    super.key,
    required this.label,
    this.hint,
    this.errorText,
    required this.child,
    this.isRequired = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              label,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppColors.textPrimaryLight,
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                    height: 1.5,
                    letterSpacing: 0.5,
                    fontFamily: GoogleFonts.spaceGrotesk().fontFamily,
                  ),
            ),
            if (isRequired)
              Text(
                ' *',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: AppColors.error.withAlpha(76),
                      fontSize: 14,
                      height: 1.5,
                      letterSpacing: 0.5,
                      fontFamily: GoogleFonts.spaceGrotesk().fontFamily,
                    ),
              ),
          ],
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: errorText != null
                ? AppColors.error.withAlpha(127)
                : AppColors.backgroundLight,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: AppColors.borderLight,
              width: 1,
            ),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: child,
        ),
        if (errorText != null) ...[
          const SizedBox(height: 4),
          Text(
            errorText!,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: AppColors.error,
                  fontSize: 14,
                  height: 1.5,
                  letterSpacing: 0.5,
                  fontFamily: GoogleFonts.spaceGrotesk().fontFamily,

                ),
          ),
        ],
      ],
    );
  }
}
