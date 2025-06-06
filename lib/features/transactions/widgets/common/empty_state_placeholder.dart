import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/theme/app_colors.dart';

class EmptyCardStatePlaceholder extends StatelessWidget {
  final String title;
  final String message;
  final VoidCallback? onAction;
  final String? actionLabel;
  final String? image;

  const EmptyCardStatePlaceholder({
    required this.title,
    required this.message,
    this.onAction,
    this.actionLabel,
    this.image,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        height: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (image != null) Image.asset(image!, width: 150, height: 150),
            const SizedBox(height: 16),

            Text(
              title,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: AppColors.textPrimaryLight,
                fontWeight: FontWeight.w600,
                fontFamily: GoogleFonts.spaceGrotesk().fontFamily,
                fontSize: 17,
                letterSpacing: -0.15,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              message,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: AppColors.neutral800,
                fontWeight: FontWeight.w500,
                fontFamily: GoogleFonts.spaceGrotesk().fontFamily,
                fontSize: 14,
                letterSpacing: -0.15,
              ),
              textAlign: TextAlign.center,
            ),
            if (onAction != null && actionLabel != null) ...[
              const SizedBox(height: 16),
              TextButton(
                onPressed: onAction,
                child: Text(
                  actionLabel!,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppColors.primary500,
                    fontWeight: FontWeight.w500,
                    fontFamily: GoogleFonts.spaceGrotesk().fontFamily,
                    fontSize: 14,
                    letterSpacing: -0.15,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
