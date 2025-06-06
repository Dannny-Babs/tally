import '../../../../utils/utils.dart';
import '../../../../utils/widgets.dart' hide ActivityCard;
import '../../widgets/common/empty_state_placeholder.dart';
import '../../widgets/exports.dart' hide ActivityCard;

class IncomeScreen extends StatelessWidget {
  const IncomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    DateRange selectedRange = DateRange.thisMonth;

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
                color: AppColors.backgroundLight,
                borderRadius: BorderRadius.only(
                  bottomRight: Radius.circular(24),
                  bottomLeft: Radius.circular(24),
                ),
                border: Border.all(color: AppColors.borderLight),
              ),
              child: NotificationListener<ScrollNotification>(
                onNotification: (ScrollNotification scrollInfo) {
                  if (scrollInfo is ScrollEndNotification &&
                      scrollInfo.metrics.pixels >=
                          scrollInfo.metrics.maxScrollExtent - 200) {
                    if (state is TransactionLoaded && !state.hasReachedMax) {
                      context.read<TransactionBloc>().add(
                        TransactionLoadMore(),
                      );
                    }
                  }
                  return true;
                },
                child: CustomScrollView(
                  physics: const BouncingScrollPhysics(
                    parent: AlwaysScrollableScrollPhysics(),
                  ),
                  slivers: [
                    // Title
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.all(8),
                        child: Text(
                          'Income',
                          style: AppTextStyles.displaySmall.copyWith(
                            color: AppColors.textPrimaryLight,
                            fontFamily: GoogleFonts.spaceGrotesk().fontFamily,
                            fontSize: 22,
                            letterSpacing: -0.5,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),

                    // Date Filter
                    SliverToBoxAdapter(
                      child: DateFilterWidget(
                        selectedRange: selectedRange,
                        onRangeSelected: (range) {
                          selectedRange = range;
                          final now = DateTime.now();
                          DateTime startDate;
                          DateTime endDate;

                          switch (range) {
                            case DateRange.thisMonth:
                              startDate = DateTime(now.year, now.month, 1);
                              endDate = DateTime(now.year, now.month + 1, 0);
                              break;
                            case DateRange.lastMonth:
                              startDate = DateTime(now.year, now.month - 1, 1);
                              endDate = DateTime(now.year, now.month, 0);
                              break;
                            case DateRange.thisYear:
                              startDate = DateTime(now.year, 1, 1);
                              endDate = DateTime(now.year, 12, 31);
                              break;
                            case DateRange.custom:
                              // TODO: Implement custom date picker
                              return;
                            case DateRange.all:
                              startDate = DateTime(1900, 1, 1);
                              endDate = DateTime(now.year, now.month, now.day);
                              break;
                          }

                          context.read<TransactionBloc>().add(
                            DateFilterChanged(
                              startDate: startDate,
                              endDate: endDate,
                            ),
                          );
                        },
                      ),
                    ),

                    // Total Income Card
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.all(8),
                        child: Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                            side: BorderSide(color: AppColors.borderLight),
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
                                  'Total income ${selectedRange.name.replaceAll(RegExp(r'(?=[A-Z])'), ' ')}',
                                  style: AppTextStyles.bodyMedium.copyWith(
                                    color: AppColors.textPrimaryLight,
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
                                        color: AppColors.primary500,
                                      ),
                                    ),
                                    const SizedBox(width: 4),
                                    Text(
                                      state is TransactionLoaded
                                          ? state.transactions.fold<double>(
                                              0,
                                              (sum, transaction) => sum + transaction.amount,
                                            ).toStringAsFixed(2)
                                          : '0.00',
                                      style: AppTextStyles.displayLarge.copyWith(
                                        fontSize: 48,
                                        color: AppColors.textPrimaryLight,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 16),
                                _buildIncomeSplitCard(
                                  sources: state is TransactionLoaded
                                      ? _calculateSourceTotals(state.transactions)
                                      : {'Freelance': 0, 'Job': 0, 'Other': 0},
                                ),
                                const SizedBox(height: 4),
                                SizedBox(
                                  width: double.infinity,
                                  child: ElevatedButton.icon(
                                    onPressed: () {
                                      showModalBottomSheet(
                                        context: context,
                                        backgroundColor: Colors.transparent,
                                        isScrollControlled: true,
                                        builder: (_) => const AddIncomeModal(),
                                      );
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
                                        fontFamily: GoogleFonts.spaceMono().fontFamily,
                                      ),
                                    ),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: AppColors.neutral900,
                                      foregroundColor: AppColors.surfaceLight,
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
                      ),
                    ),

                    // Transaction Groups
                    if (state is TransactionLoading)
                      const SliverToBoxAdapter(child: ShimmerList())
                    else if (state is TransactionEmpty)
                      SliverToBoxAdapter(
                        child: Container(
                          height: MediaQuery.of(context).size.height * 0.52,
                          margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: AppColors.borderLight),
                          ),
                          child: const EmptyCardStatePlaceholder(
                            image: 'assets/images/no_income.png',
                            title: 'No Income Recorded',
                            message: 'You haven\'t recorded any income yet. Tap + Add to record your first payment.',
                            
                          ),
                        ),
                      )
                    else if (state is TransactionLoaded)
                      TransactionList(
                        state: state,
                        hasReachedMax: state.hasReachedMax,
                        isIncome: true,
                        onLoadMore: () {
                          context.read<TransactionBloc>().add(
                            TransactionLoadMore(),
                          );
                        },
                      )

                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildIncomeSplitCard({required Map<String, double> sources}) {
    final entries = sources.entries.take(3).toList();
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.backgroundLight,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.borderLight),
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
                    color: AppColors.neutral700,
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
                    color: AppColors.textPrimaryLight,
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

  Map<String, double> _calculateSourceTotals(List<Transaction> transactions) {
    final totals = <String, double>{};
    
    for (final transaction in transactions) {
      final source = transaction.source.toLowerCase();
      if (source.contains('freelance')) {
        totals['Freelance'] = (totals['Freelance'] ?? 0) + transaction.amount;
      } else if (source.contains('job')) {
        totals['Job'] = (totals['Job'] ?? 0) + transaction.amount;
      } else {
        totals['Other'] = (totals['Other'] ?? 0) + transaction.amount;
      }
    }
    
    // Ensure all categories exist with at least 0
    totals.putIfAbsent('Freelance', () => 0);
    totals.putIfAbsent('Job', () => 0);
    totals.putIfAbsent('Other', () => 0);
    
    return totals;
  }

} 