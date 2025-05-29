import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../bloc/transaction_state.dart';
import '../../bloc/transaction_model.dart';
import '../widgets/activity_card.dart';
import '../widgets/empty_state_placeholder.dart';

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
    if (state is TransactionLoading) {
      return const SliverToBoxAdapter(
        child: SizedBox(
          height: 200,
          child: Center(
            child: CircularProgressIndicator(),
          ),
        ),
      );
    }

    if (state is TransactionEmpty) {
      return SliverToBoxAdapter(
        child: Container(
          height: MediaQuery.of(context).size.height * 0.52,
          margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
          child: const EmptyStatePlaceholder(
            title: 'No Expenses Recorded',
            message: 'You haven\'t recorded any expenses yet. Tap + Add to record your first expense.',
          ),
        ),
      );
    }

    if (state is TransactionLoaded) {
      final transactions = state.transactions;
      final groups = _groupTransactions(transactions);
      final entries = groups.entries.toList();

      return SliverList(
        delegate: SliverChildBuilderDelegate(
          (context, index) {
            if (index == entries.length) {
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
                ...entry.value.map((transaction) => ActivityCard(
                      transaction: transaction,
                      onTap: () {
                        // TODO: Implement transaction details
                      },
                    )),
              ],
            );
          },
          childCount: entries.length + (hasReachedMax ? 0 : 1),
        ),
      );
    }

    return const SliverToBoxAdapter(child: SizedBox.shrink());
  }

  Map<DateTime, List<Transaction>> _groupTransactions(List<Transaction> transactions) {
    final groups = <DateTime, List<Transaction>>{};
    for (final transaction in transactions) {
      final date = DateTime(
        transaction.date.year,
        transaction.date.month,
        transaction.date.day,
      );
      groups.putIfAbsent(date, () => []).add(transaction);
    }
    return Map.fromEntries(
      groups.entries.toList()
        ..sort((a, b) => b.key.compareTo(a.key)),
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