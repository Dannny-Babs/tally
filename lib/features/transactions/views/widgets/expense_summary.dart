import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../utils/utils.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../bloc/transaction_state.dart';

class ExpenseSummary extends StatelessWidget {
  final TransactionState state;

  const ExpenseSummary({
    super.key,
    required this.state,
  });

  @override
  Widget build(BuildContext context) {
    if (state is! TransactionLoaded) return const SizedBox.shrink();

    final loadedState = state as TransactionLoaded;
    final totalAmount = loadedState.totalAmount;
    final categoryTotals = loadedState.categoryTotals;

    return Container(
      padding: const EdgeInsets.all(12),
      margin: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.borderLight),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Total Spent',
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.neutral700,
              fontWeight: FontWeight.w500,
              fontFamily: GoogleFonts.spaceGrotesk().fontFamily,
              fontSize: 14,
              letterSpacing: -0.15,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            '\$${totalAmount.toStringAsFixed(2)}',
            style: AppTextStyles.headlineMedium.copyWith(
              color: AppColors.neutral900,
              fontWeight: FontWeight.w600,
              fontFamily: GoogleFonts.spaceGrotesk().fontFamily,
              fontSize: 24,
              letterSpacing: -0.5,
            ),
          ),
          const SizedBox(height: 16),
          if (categoryTotals.isNotEmpty) ...[
            Text(
              'Top Categories',
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.neutral700,
                fontWeight: FontWeight.w500,
                fontFamily: GoogleFonts.spaceGrotesk().fontFamily,
                fontSize: 14,
                letterSpacing: -0.15,
              ),
            ),
            const SizedBox(height: 8),
            ...categoryTotals.entries.take(3).map((entry) {
              final percentage = (entry.value / totalAmount * 100).toStringAsFixed(1);
              return Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        entry.key,
                        style: AppTextStyles.bodySmall.copyWith(
                          color: AppColors.neutral600,
                          fontFamily: GoogleFonts.spaceGrotesk().fontFamily,
                          fontSize: 12,
                        ),
                      ),
                    ),
                    Text(
                      '$percentage%',
                      style: AppTextStyles.bodySmall.copyWith(
                        color: AppColors.neutral600,
                        fontFamily: GoogleFonts.spaceGrotesk().fontFamily,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              );
            }),
          ],
        ],
      ),
    );
  }
} 