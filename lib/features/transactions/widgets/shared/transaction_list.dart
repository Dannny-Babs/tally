import 'package:tally/features/transactions/widgets/shared/activity_card.dart';

import '../../../../core/utils/category_icons.dart';
import '../../../../utils/utils.dart';
import '../common/empty_state_placeholder.dart';

/// List widget for displaying transactions with grouping by date
class TransactionList extends StatelessWidget {
  final TransactionState state;
  final bool hasReachedMax;
  final VoidCallback? onLoadMore;

  const TransactionList({
    super.key,
    required this.state,
    required this.hasReachedMax,
    this.onLoadMore,
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
      final transactions = state.transactions;
      if (transactions.isEmpty) {
        return SliverToBoxAdapter(
          child: Container(
            height: MediaQuery.of(context).size.height * 0.52,
            margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            child: const EmptyCardStatePlaceholder(
              image: 'assets/images/no_expenses.png',
              actionLabel: 'Add Expense',
              title: 'No Expenses Recorded',
              message:
                  'You haven\'t recorded any expenses yet. Tap + Add to record your first expense.',
            ),
          ),
        );
      }

      print(transactions);

      final groups = _groupTransactions(transactions);
      final entries = groups.entries.toList();
      if (entries.isEmpty) {
        return SliverToBoxAdapter(
          child: Container(
            height: MediaQuery.of(context).size.height * 0.52,
            margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            child: const EmptyCardStatePlaceholder(
              image: 'assets/images/no_expenses.png',
              actionLabel: 'Add Expense',
              title: 'No Expenses Recorded',
              message:
                  'You haven\'t recorded any expenses yet. Tap + Add to record your first expense.',
            ),
          ),
        );
      }

      return SliverList(
        delegate: SliverChildBuilderDelegate(
          (context, index) {
            // Handle loading indicator at the end
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
              return const SizedBox.shrink();
            }

            final entry = entries[index];
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                  child: Text(
                    _formatDate(entry.key),
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: AppColors.neutral600,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                ...entry.value.map(
                  (transaction) => ActivityCard(
                    icon: transaction.isIncome 
                        ? CategoryIcons.getIncomeIcon(transaction.source)
                        : CategoryIcons.getExpenseIcon(transaction.source),
                    title: transaction.description,
                    subtitle: '${transaction.source} • ${transaction.date}',
                    amount: transaction.amount,
                    isIncome: transaction.isIncome,
                  ),
                ),
              ],
            );
          },
          childCount: entries.isEmpty ? 0 : entries.length + (hasReachedMax ? 0 : 1),
        ),
      );
    }

    return const SliverToBoxAdapter(child: SizedBox.shrink());
  }

  Map<DateTime, List<Transaction>> _groupTransactions(
    List<Transaction> transactions,
  ) {
    final groups = <DateTime, List<Transaction>>{};
    for (final transaction in transactions) {
      try {
        final dateParts = transaction.date.split('/');
        if (dateParts.length != 3) continue;

        final date = DateTime(
          int.parse(dateParts[2]), // year
          int.parse(dateParts[1]), // month
          int.parse(dateParts[0]), // day
        );
        groups.putIfAbsent(date, () => []).add(transaction);
      } catch (e) {
        // Skip invalid dates
        continue;
      }
    }
    return Map.fromEntries(
      groups.entries.toList()..sort((a, b) => b.key.compareTo(a.key)),
    );
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(const Duration(days: 1));

    if (date == today) {
      return 'Today';
    } else if (date == yesterday) {
      return 'Yesterday';
    } else {
      return '${date.day}/${date.month}/${date.year}';
    }
  }
}
