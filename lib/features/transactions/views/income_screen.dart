import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:heroicons/heroicons.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../bloc/transaction_bloc.dart';
import '../widgets/activity_card.dart';
import '../widgets/empty_state_placeholder.dart';
import '../widgets/error_screen.dart';

class IncomeScreen extends StatelessWidget {
  const IncomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TransactionBloc, TransactionState>(
      builder: (context, state) {
        if (state is TransactionError) {
          return ErrorScreen(
            message: state.message,
            onRetry: () {
              context.read<TransactionBloc>().add(IncomeLoaded());
            },
          );
        }

        return Scaffold(
          backgroundColor: Colors.white,
          body: SafeArea(
            child: Container(
              decoration: BoxDecoration(
                color: AppColors.background,
                borderRadius: BorderRadius.only(
                  bottomRight: Radius.circular(24),
                  bottomLeft: Radius.circular(24),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Income',
                      style: AppTextStyles.displaySmall.copyWith(
                        color: AppColors.accent,
                        fontFamily: GoogleFonts.spaceGrotesk().fontFamily,
                        fontSize: 24,
                        letterSpacing: -0.5,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 20),
                    Card(
                      shape: RoundedRectangleBorder(                      
                        borderRadius: BorderRadius.circular(12),
                        side: BorderSide(
                          color: AppColors.primaryLight.withAlpha(150),
                        ),
                      ),
                      color: Colors.white,
                      elevation: 0,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          vertical: 4,
                          horizontal: 4,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const SizedBox(height: 12),
                            Text(
                              'Total income this month',
                              style: AppTextStyles.bodyMedium.copyWith(
                                color: AppColors.primary,
                                letterSpacing: -0.5,
                              ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(
                                  '\$',
                                  style: AppTextStyles.bodyMedium.copyWith(
                                    fontSize: 28,
                                    color: AppColors.primary,
                                  ),
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  '4200.00',
                                  style: AppTextStyles.displayLarge.copyWith(
                                    fontSize: 52,
                                    color: AppColors.accent,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),
                            _buildIncomeSplitCard(
                              sources: {'Freelance': 2800, 'Job': 1400},
                            ),
                            const SizedBox(height: 4),
                            SizedBox(
                              width: double.infinity,
                              child: ElevatedButton.icon(
                                onPressed: () {
                                  // TODO: Navigate to AddTransactionScreen
                                },
                                icon: const Icon(
                                  Icons.add,
                                  color: Colors.white,
                                ),
                                label: Text(
                                  'Add Income / Payment',
                                  style: AppTextStyles.bodyMedium.copyWith(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w600,
                                    letterSpacing: -0.15,
                                    fontFamily:
                                        GoogleFonts.spaceMono().fontFamily,
                                  ),
                                ),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppColors.accent,
                                  foregroundColor: Colors.white,
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 16,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    Expanded(
                      child: state is TransactionLoading
                          ? const Center(child: CircularProgressIndicator())
                          : state is TransactionEmpty
                              ? const EmptyStatePlaceholder(
                                  message:
                                      'No income logged yet. Tap + Add to record your first payment.',
                                )
                              : state is TransactionLoaded
                                  ? _buildIncomeList(
                                      (state).transactions,
                                    )
                                  : const SizedBox(),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildIncomeList(List<Transaction> transactions) {
    return ListView.separated(
      itemCount: transactions.length,
      separatorBuilder: (context, index) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        final transaction = transactions[index];
        return ActivityCard(
          icon: _getIconForSource(transaction.source),
          title: '${transaction.source}: ${transaction.description}',
          subtitle: '${transaction.date} • ${transaction.time}',
          amount: transaction.amount,
          isIncome: true,
        );
      },
    );
  }

  HeroIcons _getIconForSource(String source) {
    switch (source.toLowerCase()) {
      case 'freelance':
        return HeroIcons.computerDesktop;
      case 'job':
        return HeroIcons.briefcase;
      default:
        return HeroIcons.banknotes;
    }
  }

  Widget _buildIncomeSplitCard({required Map<String, double> sources}) {
    final entries = sources.entries.take(3).toList();
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.primaryLight.withAlpha(150)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: entries.map((entry) {
          return Expanded(
            child: Column(
              children: [
                Text(
                  entry.key,
                  style: AppTextStyles.bodySmall.copyWith(
                    color: AppColors.primary,
                    fontSize: 12,
                    fontFamily: GoogleFonts.spaceGrotesk().fontFamily,
                    fontWeight: FontWeight.w600,
                    letterSpacing: -0.25,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '\$${entry.value.toStringAsFixed(0)}',
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: AppColors.accent,
                    fontWeight: FontWeight.w600,
                    fontSize: 22,
                    letterSpacing: -0.25,
                    fontFamily: GoogleFonts.spaceGrotesk().fontFamily,
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }
}
