import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../theme/app_colors.dart';

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
    this.isRequired = false, required bool enabled,
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
                color: AppColors.neutral900,
                fontWeight: FontWeight.w600,
                fontSize: 14,
                letterSpacing: -0.15,
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
        const SizedBox(height: 4),
        child,
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
