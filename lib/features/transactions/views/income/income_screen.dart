import '../../../../core/utils/category_icons.dart';
import '../../../../utils/utils.dart';
import '../../../../utils/widgets.dart' hide ActivityCard;
import '../../widgets/common/empty_state_placeholder.dart';
import '../../widgets/exports.dart' hide ActivityCard;
import '../../widgets/shared/activity_card.dart';

class IncomeScreen extends StatelessWidget {
  const IncomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    DateRange _selectedRange = DateRange.thisMonth;

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
                        selectedRange: _selectedRange,
                        onRangeSelected: (range) {
                          _selectedRange = range;
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
                                  'Total income ${_selectedRange.name}',
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
                                        fontSize: 52,
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
                      const SliverToBoxAdapter(
                        child: SizedBox(
                          height: 200,
                          child: Center(
                            child: CircularProgressIndicator(),
                          ),
                        ),
                      )
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
                      _buildTransactionGroups(state.transactions, state.hasReachedMax),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildTransactionGroups(List<Transaction> transactions, bool hasReachedMax) {
    final groups = _groupTransactions(transactions);
    final entries = groups.entries.toList();

    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (context, index) {
          if (index >= entries.length * 2) {
            if (hasReachedMax) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  child: Text(
                    'Oops, that\'s all!',
                    style: AppTextStyles.bodySmall.copyWith(
                      color: AppColors.neutral600,
                      fontFamily: GoogleFonts.spaceGrotesk().fontFamily,
                    ),
                  ),
                ),
              );
            } else {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  child: SizedBox(
                    width: 24,
                    height: 24,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
                ),
              );
            }
          }

          final groupIndex = index ~/ 2;
          final isHeader = index.isEven;
          final group = entries[groupIndex];

          if (isHeader) {
            return Container(
              color: AppColors.backgroundLight,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              child: Text(
                group.key,
                style: AppTextStyles.bodyMedium.copyWith(
                  color: AppColors.textPrimaryLight,
                  fontWeight: FontWeight.w600,
                  fontFamily: GoogleFonts.spaceGrotesk().fontFamily,
                  fontSize: 14,
                  letterSpacing: -0.15,
                ),
              ),
            );
          } else {
            return Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.borderLight),
              ),
              padding: const EdgeInsets.all(8),
              margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              child: Column(
                children: group.value.map((transaction) {
                  return TweenAnimationBuilder<double>(
                    tween: Tween(begin: 0.0, end: 1.0),
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeOut,
                    builder: (context, value, child) {
                      return Transform.translate(
                        offset: Offset(0, 20 * (1 - value)),
                        child: Opacity(
                          opacity: value,
                          child: Padding(
                            padding: const EdgeInsets.only(bottom: 8),
                            child: ActivityCard(
                              icon: CategoryIcons.getIncomeIcon(transaction.source),
                              title: transaction.description,
                              subtitle: '${transaction.source} • ${transaction.date}',
                              amount: transaction.amount,
                              isIncome: true,
                            ),
                          ),
                        ),
                      );
                    },
                  );
                }).toList(),
              ),
            );
          }
        },
        childCount: entries.length * 2 + 1,
      ),
    );
  }

  Map<String, List<Transaction>> _groupTransactions(List<Transaction> transactions) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final thisWeek = today.subtract(Duration(days: today.weekday - 1));
    final lastWeek = thisWeek.subtract(const Duration(days: 7));
    final thisMonth = DateTime(now.year, now.month, 1);
    final lastMonth = DateTime(now.year, now.month - 1, 1);

    final groups = <String, List<Transaction>>{};
    
    for (final transaction in transactions) {
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
    }

    return Map.fromEntries(
      groups.entries.where((e) => e.value.isNotEmpty).toList()
        ..sort((a, b) => _getGroupOrder(a.key).compareTo(_getGroupOrder(b.key))),
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

  _getIconForSource(String source) {
    switch (source.toLowerCase()) {
      case 'freelance':
        return HugeIconsSolid.briefcase01;
      case 'job':
        return HugeIconsSolid.briefcase02;
      case 'design':
        return HugeIconsSolid.canvas;
      case 'development':
        return HugeIconsSolid.developer;
      case 'marketing':
        return HugeIconsSolid.megaphone01;
      case 'investment':
        return HugeIconsSolid.chart01;
      case 'family':
        return HugeIconsSolid.userGroup02;
      case 'refund':
        return HugeIconsSolid.cash02;
      case 'bonus':
        return HugeIconsSolid.tips;
      default:
        return HugeIconsSolid.money03;
    }
  }
} 