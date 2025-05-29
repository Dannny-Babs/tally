import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:heroicons/heroicons.dart';
import 'package:hugeicons_pro/hugeicons.dart';
import 'package:tally/features/transactions/views/add_expense_screen.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../bloc/transaction_bloc.dart';
import '../bloc/category_bloc.dart';
import '../bloc/category_state.dart';
import '../bloc/category_event.dart';
import '../bloc/transaction_event.dart';
import '../bloc/transaction_state.dart';
import '../bloc/transaction_model.dart';
import '../widgets/activity_card.dart';
import '../widgets/empty_state_placeholder.dart';
import '../widgets/error_screen.dart';
import '../widgets/top_categories_widget.dart';
import '../widgets/category_card.dart';
import '../widgets/date_filter_widget.dart';
import 'widgets/expense_header.dart';
import 'widgets/expense_summary.dart';
import 'widgets/transaction_list.dart';

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
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => TransactionBloc()..add(ExpensesLoaded()),
        ),
        BlocProvider(
          create: (context) => CategoryBloc()..add(CategoriesLoaded()),
        ),
      ],
      child: BlocBuilder<TransactionBloc, TransactionState>(
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
                    physics: const SmoothScrollPhysics(
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
                                      endDate = DateTime(
                                        now.year,
                                        now.month,
                                        0,
                                      );
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
                        SliverToBoxAdapter(
                          child: ExpenseSummary(state: state),
                        ),

                      // Transaction List
                      TransactionList(
                        state: state,
                        hasReachedMax: state is TransactionLoaded ? state.hasReachedMax : true,
                        onLoadMore: () {
                          context.read<TransactionBloc>().add(TransactionLoadMore());
                        },
                        ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
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
