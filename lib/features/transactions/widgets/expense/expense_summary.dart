import 'package:tally/features/transactions/widgets/expense/top_categories_widget.dart';

import '../../../../utils/utils.dart';

/// Summary widget for the expense screen showing total amount and top categories
class ExpenseSummary extends StatelessWidget {
  final TransactionState state;

  const ExpenseSummary({super.key, required this.state});

  @override
  Widget build(BuildContext context) {
    if (state is! TransactionLoaded) {
      return Container(
        padding: const EdgeInsets.all(8),
        margin: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
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

            const SizedBox(height: 2),
            Text(
              '\$0.00',
              style: AppTextStyles.bodyLarge.copyWith(
                color: AppColors.neutral900,
                fontWeight: FontWeight.w600,
                fontFamily: GoogleFonts.spaceGrotesk().fontFamily,
                fontSize: 32,
                letterSpacing: -0.15,
              ),
            ),

            const SizedBox(height: 16),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4.0),
              child: const TopCategoriesWidget(categoryTotals: {}),
            ),

            const SizedBox(height: 12),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () {
                  showModalBottomSheet(
                    context: context,
                    backgroundColor: Colors.transparent,
                    isScrollControlled: true,
                    builder: (_) => const AddExpenseModal(),
                  );
                },
                icon: const Icon(Icons.add, color: Colors.white),
                label: Text(
                  'Add Expense',
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                    letterSpacing: -0.15,
                    fontFamily: GoogleFonts.spaceMono().fontFamily,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.neutral900,
                  foregroundColor: AppColors.surfaceLight,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    }

    final loadedState = state as TransactionLoaded;
    final totalAmount = loadedState.totalAmount;
    final categoryTotals = loadedState.categoryTotals;

    return Container(
      padding: const EdgeInsets.all(8),
      margin: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.borderLight),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(4.0),
            child: Text(
              'Total Spent',
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.neutral700,
                fontWeight: FontWeight.w500,
                fontFamily: GoogleFonts.spaceGrotesk().fontFamily,
                fontSize: 14,
                letterSpacing: -0.15,
              ),
            ),
          ),
          const SizedBox(height: 2),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4.0),
            child: Text(
              '\$${totalAmount.toStringAsFixed(2)}',
              style: AppTextStyles.bodyLarge.copyWith(
                color: AppColors.neutral900,
                fontWeight: FontWeight.w600,
                fontFamily: GoogleFonts.spaceGrotesk().fontFamily,
                fontSize: 32,
                letterSpacing: -0.15,
              ),
            ),
          ),
          const SizedBox(height: 16),

          if (categoryTotals.isNotEmpty) ...[
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4.0),
              child: TopCategoriesWidget(categoryTotals: categoryTotals),
            ),
          ] else ...[
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4.0),
              child: TopCategoriesWidget(categoryTotals: categoryTotals),
            ),
          ],
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () {
                showModalBottomSheet(
                  context: context,
                  backgroundColor: Colors.transparent,
                  isScrollControlled: true,
                  builder: (_) => const AddExpenseModal(),
                );
              },
              icon: const Icon(Icons.add, color: Colors.white),
              label: Text(
                'Add Expense',
                style: AppTextStyles.bodyMedium.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                  letterSpacing: -0.15,
                  fontFamily: GoogleFonts.spaceMono().fontFamily,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.neutral900,
                foregroundColor: AppColors.surfaceLight,
                padding: const EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
