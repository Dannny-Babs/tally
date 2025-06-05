import 'package:tally/features/transactions/widgets/shared/activity_card.dart';

import '../../../../core/utils/category_icons.dart';
import '../../../../utils/utils.dart';
import '../../views/transaction_detail_screen.dart';
import '../common/empty_state_placeholder.dart';

/// List widget for displaying transactions with grouping by date
class TransactionList extends StatelessWidget {
  final TransactionState state;
  final bool hasReachedMax;
  final VoidCallback? onLoadMore;
  final bool isIncome;

  const TransactionList({
    super.key,
    required this.state,
    required this.hasReachedMax,
    this.onLoadMore,
    this.isIncome = false,
  });

  @override
  Widget build(BuildContext context) {
    if (state is TransactionError) {
      return SliverToBoxAdapter(
        child: ErrorScreen(
          message: (state as TransactionError).message,
          onRetry: () => onLoadMore?.call(),
        ),
      );
    }

    if (state is TransactionLoading) {
      return const SliverToBoxAdapter(
        child: ShimmerCard(height: 300),
      );
    }

    if (state is TransactionLoaded) {
      final transactions = state.transactions.where((t) => t.isIncome == isIncome).toList();
      if (transactions.isEmpty) {
        return SliverToBoxAdapter(
          child: Container(
            height: MediaQuery.of(context).size.height * 0.52,
            margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            child: EmptyCardStatePlaceholder(
              image: isIncome ? 'assets/images/no_income.png' : 'assets/images/no_expenses.png',
              actionLabel: isIncome ? 'Add Income' : 'Add Expense',
              title: isIncome ? 'No Income Recorded' : 'No Expenses Recorded',
              message: isIncome 
                  ? 'You haven\'t recorded any income yet. Tap + Add to record your first payment.'
                  : 'You haven\'t recorded any expenses yet. Tap + Add to record your first expense.',
            ),
          ),
        );
      }

      final groups = _groupTransactions(transactions);
      final entries = groups.entries.toList();

      return SliverList(
        delegate: SliverChildBuilderDelegate(
          (context, index) {
            if (index >= entries.length) {
              if (!hasReachedMax) {
                onLoadMore?.call();
                return const Center(
                  child: Padding(
                    padding: EdgeInsets.all(16),
                    child: CircularProgressIndicator(),
                  ),
                );
              }
              return Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  child: Text(
                    'Oops, that\'s all!',
                    style: AppTextStyles.bodySmall.copyWith(
                      color: AppColors.neutral700,
                      fontFamily: GoogleFonts.spaceGrotesk().fontFamily,
                    ),
                  ),
                ),
              );
            }

            final entry = entries[index];
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                Container(
                  color: AppColors.backgroundLight,
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
                  child: Text(
                    entry.key,
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: AppColors.textPrimaryLight,
                      fontWeight: FontWeight.w600,
                      fontFamily: GoogleFonts.spaceGrotesk().fontFamily,
                      fontSize: 14,
                      letterSpacing: -0.15,
                    ),
                  ),
                ),
                // Transactions
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: AppColors.borderLight),
                  ),
                  child: ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
                    itemCount: entry.value.length,
                    separatorBuilder: (context, index) => const SizedBox(height: 8),
                    itemBuilder: (context, index) {
                      final transaction = entry.value[index];
                      return TweenAnimationBuilder<double>(
                        tween: Tween(begin: 0.0, end: 1.0),
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeOut,
                        builder: (context, value, child) {
                          return Transform.translate(
                            offset: Offset(0, 20 * (1 - value)),
                            child: Opacity(
                              opacity: value,
                              child: GestureDetector(
                                onTap: () {
                                  showModalBottomSheet(
                                    context: context,
                                    backgroundColor: Colors.transparent,
                                    isScrollControlled: true,
                                    builder: (_) => TransactionDetailScreen(transaction: transaction),
                                  );
                                },
                                child: ActivityCard(
                                  icon: transaction.isIncome 
                                      ? CategoryIcons.getIncomeIcon(transaction.source)
                                      : CategoryIcons.getExpenseIcon(transaction.source),
                                  title: transaction.isIncome 
                                      ? ' ${transaction.description}'
                                      : '${transaction.source}: ${transaction.description}',
                                  subtitle: transaction.isIncome 
                                      ? '${transaction.payeeName} • ${transaction.date} • ${transaction.time}'
                                      : '${transaction.date} • ${transaction.time}',
                                  amount: transaction.amount,
                                  isIncome: transaction.isIncome,
                                ),
                              ),
                            ),
                          );
                        },
                      );
                    },
                  ),
                ),
              ],
            );
          },
          childCount: entries.length + 1,
        ),
      );
    }

    return const SliverToBoxAdapter(child: SizedBox.shrink());
  }

  Map<String, List<Transaction>> _groupTransactions(
    List<Transaction> transactions,
  ) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final thisWeek = today.subtract(Duration(days: today.weekday - 1));
    final lastWeek = thisWeek.subtract(const Duration(days: 7));
    final thisMonth = DateTime(now.year, now.month, 1);
    final lastMonth = DateTime(now.year, now.month - 1, 1);

    final groups = <String, List<Transaction>>{};

    for (final transaction in transactions) {
      try {
        // Parse date in format "YYYY-MM-DD"
        final date = DateTime.parse(transaction.date);
        
        String group;
        if (date.isAtSameMomentAs(today)) {
          group = 'Today';
        } else if (date.isAfter(thisWeek.subtract(const Duration(days: 1)))) {
          group = 'This Week';
        } else if (date.isAfter(lastWeek.subtract(const Duration(days: 1)))) {
          group = 'Last Week';
        } else if (date.isAfter(thisMonth.subtract(const Duration(days: 1)))) {
          group = 'This Month';
        } else if (date.isAfter(lastMonth.subtract(const Duration(days: 1)))) {
          group = 'Last Month';
        } else {
          group = 'Older';
        }

        groups.putIfAbsent(group, () => []).add(transaction);
      } catch (e) {
        print('Error parsing date for transaction: ${transaction.date}');
        continue;
      }
    }

    return Map.fromEntries(
      groups.entries.where((e) => e.value.isNotEmpty).toList()..sort(
        (a, b) => _getGroupOrder(a.key).compareTo(_getGroupOrder(b.key)),
      ),
    );
  }

  int _getGroupOrder(String group) {
    switch (group) {
      case 'Today':
        return 0;
      case 'This Week':
        return 1;
      case 'Last Week':
        return 2;
      case 'This Month':
        return 3;
      case 'Last Month':
        return 4;
      case 'Older':
        return 5;
      default:
        return 6;
    }
  }
}

class _SliverHeaderDelegate extends SliverPersistentHeaderDelegate {
  final Widget child;
  final double minHeight;
  final double maxHeight;

  _SliverHeaderDelegate({
    required this.child,
    required this.minHeight,
    required this.maxHeight,
  });

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    return SizedBox.expand(
      child: Container(color: AppColors.backgroundLight, child: child),
    );
  }

  @override
  double get maxExtent => maxHeight;

  @override
  double get minExtent => minHeight;

  @override
  bool shouldRebuild(covariant _SliverHeaderDelegate oldDelegate) {
    return child != oldDelegate.child ||
        maxHeight != oldDelegate.maxHeight ||
        minHeight != oldDelegate.minHeight;
  }
}
