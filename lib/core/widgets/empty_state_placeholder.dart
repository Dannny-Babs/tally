import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';

class EmptyStatePlaceholder extends StatelessWidget {
  final String title;
  final String message;
  final IconData? icon;
  final VoidCallback? onActionPressed;
  final String? actionLabel;
  final String? imagePath;

  const EmptyStatePlaceholder({
    super.key,
    required this.title,
    required this.message,
     this.icon,
    this.onActionPressed,
    this.actionLabel,
    this.imagePath,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (icon != null)
              Icon(
                icon!,
                size: 64,
                color: AppColors.textSecondaryLight,
              ),
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.asset(
                imagePath ?? '',
                width: 220,
                height: 220,
                
              ),
            ),
            const SizedBox(height: 16),
            Text(
              title,
              style: AppTextStyles.titleLarge.copyWith(
                color: AppColors.textPrimaryLight,
                fontWeight: FontWeight.w600,
                fontSize: 24,
                letterSpacing: -0.3,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 4),
            Text(
              message,
              style: AppTextStyles.body.copyWith(
                color: AppColors.textSecondaryLight,
                fontWeight: FontWeight.w500,
                fontSize: 16,
                letterSpacing: -0.3,
              ),
              textAlign: TextAlign.center,
            ),
            if (onActionPressed != null && actionLabel != null) ...[
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: onActionPressed,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.textPrimaryLight,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 12,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(
                  actionLabel!,
                  style: AppTextStyles.button.copyWith(
                    color: AppColors.neutral50,
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                    letterSpacing: -0.2,
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