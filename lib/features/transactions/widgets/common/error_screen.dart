import '../../../../utils/utils.dart';

class ErrorScreen extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const ErrorScreen({
    super.key,
    required this.message,
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.error,
                shape: BoxShape.circle,
              ),
              child: HeroIcon(
                HeroIcons.exclamationTriangle,
                style: HeroIconStyle.solid,
                color: Colors.red,
                size: 32,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              message,
              textAlign: TextAlign.center,
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.primary500,
                fontSize: 16,
                letterSpacing: -0.15,
                fontFamily: GoogleFonts.spaceGrotesk().fontFamily,
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: onRetry,
              icon: HeroIcon(
                HeroIcons.arrowPath,
                style: HeroIconStyle.solid,
                color: Colors.white,
                size: 20,
              ),
              label: Text(
                'Retry',
                style: AppTextStyles.bodyMedium.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                  letterSpacing: -0.15,
                  fontFamily: GoogleFonts.spaceGrotesk().fontFamily,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.neutral900,
                foregroundColor: AppColors.surfaceLight,
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
} 