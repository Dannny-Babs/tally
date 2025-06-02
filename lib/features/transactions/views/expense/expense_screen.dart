// TODO (Phase C): Split this file into header, form, summary, filter, list widget files
// TODO (Phase D): Move business logic (calculations, grouping, formatting) out of build() into Bloc or Utils
// TODO (Phase E): Replace CircularProgressIndicator with ShimmerLoader in Phase B

import '../../../../utils/utils.dart';
import '../../widgets/exports.dart';
import '../../widgets/expense/expense_header.dart';
import '../../widgets/expense/expense_summary.dart';

class SmoothScrollPhysics extends BouncingScrollPhysics {
  const SmoothScrollPhysics({super.parent});

  @override
  double applyBoundaryConditions(ScrollMetrics position, double value) {
    // Reduce overscroll distance for a gentler return
    final overscroll = super.applyBoundaryConditions(position, value);
    return overscroll * 0.3; // dampen bounce to 30%
  }

  @override
  SmoothScrollPhysics applyTo(ScrollPhysics? ancestor) =>
      SmoothScrollPhysics(parent: buildParent(ancestor));
}

class ExpenseScreen extends StatelessWidget {
  const ExpenseScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Initialize the bloc to load expenses
    context.read<TransactionBloc>().add(ExpensesLoaded());

    return BlocBuilder<TransactionBloc, TransactionState>(
      builder: (context, state) {
        if (state is TransactionError) {
          return ErrorScreen(
            message: state.message,
            onRetry: () {
              context.read<TransactionBloc>().add(ExpensesLoaded());
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
                    // Header
                    SliverPersistentHeader(
                      pinned: true,
                      delegate: _SliverHeaderDelegate(
                        child: const ExpenseHeader(),
                        minHeight: 75,
                        maxHeight: 75,
                      ),
                    ),

                    // Date Filter
                    SliverToBoxAdapter(
                      child: StatefulBuilder(
                        builder: (context, setState) {
                          return DateFilterWidget(
                            selectedRange: DateRange.thisMonth,
                            onRangeSelected: (range) {
                              setState(() {
                                final now = DateTime.now();
                                DateTime startDate;
                                DateTime endDate;

                                switch (range) {
                                  case DateRange.thisMonth:
                                    startDate = DateTime(
                                      now.year,
                                      now.month,
                                      1,
                                    );
                                    endDate = DateTime(
                                      now.year,
                                      now.month + 1,
                                      0,
                                    );
                                    break;
                                  case DateRange.lastMonth:
                                    startDate = DateTime(
                                      now.year,
                                      now.month - 1,
                                      1,
                                    );
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
                                    endDate = DateTime(
                                      now.year,
                                      now.month,
                                      now.day,
                                    );
                                    break;
                                }

                                context.read<TransactionBloc>().add(
                                  DateFilterChanged(
                                    startDate: startDate,
                                    endDate: endDate,
                                  ),
                                );
                              });
                            },
                          );
                        },
                      ),
                    ),

                    // Summary Card
                    if (state is TransactionLoaded)
                      SliverToBoxAdapter(child: ExpenseSummary(state: state))
                    else if (state is TransactionLoading)
                      const SliverToBoxAdapter(
                        child: ShimmerCard(height: 300),
                      )
                    else if (state is TransactionEmpty)
                      SliverToBoxAdapter(child: ExpenseSummary(state: state), )
                    else
                      const SliverToBoxAdapter(child: SizedBox.shrink()),

                    // Transaction List
                    if (state is TransactionLoaded)
                      TransactionList(
                        state: state,
                        hasReachedMax: state.hasReachedMax,
                        onLoadMore: () {
                          context.read<TransactionBloc>().add(
                            TransactionLoadMore(),
                          );
                        },
                      )
                    else if (state is TransactionLoading)
                      const SliverToBoxAdapter(child: ShimmerCard(height: 300))
                    else
                      const SliverToBoxAdapter(child: SizedBox.shrink()),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildExpenseSplitCard({required Map<String, double> categories}) {
    final entries = categories.entries.take(3).toList();
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.backgroundLight,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.borderLight),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children:
            entries.map((entry) {
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
