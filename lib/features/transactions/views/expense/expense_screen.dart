// TODO (Phase C): Split this file into header, form, summary, filter, list widget files
// TODO (Phase D): Move business logic (calculations, grouping, formatting) out of build() into Bloc or Utils
// TODO (Phase E): Replace CircularProgressIndicator with ShimmerLoader in Phase B

import '../../../../utils/utils.dart';
import '../../widgets/exports.dart';
import '../../widgets/expense/expense_header.dart';
import '../../widgets/expense/expense_summary.dart';
import '../../widgets/common/empty_state_placeholder.dart';

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
    // Initialize the bloc to load expenses with This Month as default
    context.read<TransactionBloc>().add(ExpensesLoaded());
    final now = DateTime.now();
    final startDate = DateTime(now.year, now.month, 1);
    final endDate = DateTime(now.year, now.month + 1, 0);
    context.read<TransactionBloc>().add(DateFilterChanged(
      startDate: startDate,
      endDate: endDate,
    ));

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

                    // Summary Card - Always show, even when empty
                    SliverToBoxAdapter(
                      child: state is TransactionLoaded || state is TransactionEmpty
                          ? ExpenseSummary(state: state)
                          : const ShimmerCard(height: 300),
                    ),

                   

                    // Transaction List
                    if (state is TransactionLoaded)
                      TransactionList(
                        state: state,
                        hasReachedMax: state.hasReachedMax,
                        isIncome: false,
                        onLoadMore: () {
                          context.read<TransactionBloc>().add(
                            TransactionLoadMore(),
                          );
                        },
                      )
                    else if (state is TransactionLoading)
                      const SliverToBoxAdapter(child: ShimmerList())
                    else if (state is TransactionEmpty)
                      SliverToBoxAdapter(
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
                      )
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
