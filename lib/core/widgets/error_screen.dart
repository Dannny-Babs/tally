import '../../utils/utils.dart';

class ErrorScreen extends StatelessWidget {
  final String? message;
  final VoidCallback? onRetry;

  const ErrorScreen({super.key, this.message, this.onRetry});

  @override
  Widget build(BuildContext context) {
    final message = switch (this.message) {
      'no_internet' => 'No internet connection, please check your internet connection and try again',
      'no_internet_connection' => 'No internet connection, please check your internet connection and try again',
      'no_data' => 'No data found, we are having some issues. Please try again later.',
      'server_error' => 'Server error, seems like we are having some issues. Please try again later.',
      'unknown' => 'Something went wrong, we are having some issues',

      _ => this.message,
    };

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: 64,
              color: Theme.of(context).colorScheme.error,
            ),
            const SizedBox(height: 16),
            Text(
              message ?? 'Something went wrong',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            if (onRetry != null) ...[
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: onRetry,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.backgroundDark,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                child: Text(
                  'Try Again',
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
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
