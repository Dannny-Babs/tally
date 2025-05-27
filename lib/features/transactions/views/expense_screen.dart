import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:heroicons/heroicons.dart';
import 'package:tally/features/transactions/views/add_expense_screen.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../bloc/transaction_bloc.dart';
import '../bloc/category_bloc.dart';
import '../bloc/category_state.dart';
import '../bloc/category_event.dart';
import '../bloc/transaction_event.dart';
import '../bloc/transaction_state.dart';
import '../widgets/activity_card.dart';
import '../widgets/empty_state_placeholder.dart';
import '../widgets/error_screen.dart';
import '../widgets/top_categories_widget.dart';
import '../widgets/category_card.dart';

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
                    physics: const BouncingScrollPhysics(
                      parent: AlwaysScrollableScrollPhysics(),
                    ),
                    slivers: [
                      // Header with parallax effect                  
                      SliverPersistentHeader(
                        pinned: true,
                        delegate: _SliverHeaderDelegate(
                          child: Container(
                            color: AppColors.backgroundLight,
                            child: Padding(
                              padding: const EdgeInsets.all(12),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Expenses',
                                        style: AppTextStyles.displaySmall.copyWith(
                                          color: AppColors.neutral900,
                                          fontFamily:
                                              GoogleFonts.spaceGrotesk().fontFamily,
                                          fontSize: 20,
                                          letterSpacing: -0.5,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      Text(
                                        'Track your spending',
                                        style: AppTextStyles.bodyMedium.copyWith(
                                          color: AppColors.neutral700,
                                          letterSpacing: -0.15,
                                          fontFamily:
                                              GoogleFonts.spaceGrotesk().fontFamily,
                                          fontSize: 14,
                                        ),
                                      ),
                                    ],
                                  ),
                                  IconButton(
                                    onPressed: () {
                                      showModalBottomSheet(
                                        context: context,
                                        isScrollControlled: true,
                                        backgroundColor: Colors.transparent,
                                        builder:
                                            (context) => const AddExpenseModal(),
                                      );
                                    },
                                    icon: HeroIcon(
                                      HeroIcons.plus,
                                      color: AppColors.neutral900,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),

                      // Summary Card
                      if (state is TransactionLoaded)
                        SliverToBoxAdapter(
                          child: Container(
                            padding: const EdgeInsets.all(16),
                            margin: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(16),
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
                                    fontFamily:
                                        GoogleFonts.spaceGrotesk().fontFamily,
                                    fontSize: 14,
                                    letterSpacing: -0.15,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  '\$${state.totalAmount.toStringAsFixed(2)}',
                                  style: AppTextStyles.displaySmall.copyWith(
                                    color: AppColors.primary900,
                                    fontWeight: FontWeight.w600,
                                    fontFamily:
                                        GoogleFonts.spaceGrotesk().fontFamily,
                                    fontSize: 32,
                                    letterSpacing: -0.3,
                                  ),
                                ),
                                const SizedBox(height: 16),
                                TopCategoriesWidget(
                                  categoryTotals: state.categoryTotals,
                                ),
                              ],
                            ),
                          ),
                        ),

                      // Categories Section
                      SliverToBoxAdapter(
                        child: Padding(
                          padding: const EdgeInsets.all(12),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Categories',
                                style: AppTextStyles.bodyMedium.copyWith(
                                  color: AppColors.textPrimaryLight,
                                  fontWeight: FontWeight.w600,
                                  fontFamily: GoogleFonts.spaceGrotesk().fontFamily,
                                  fontSize: 14,
                                  letterSpacing: -0.15,
                                ),
                              ),
                              IconButton(
                                onPressed: () {},
                                icon: HeroIcon(
                                  HeroIcons.plus,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                      // Categories Grid
                      BlocBuilder<CategoryBloc, CategoryState>(
                        builder: (context, categoryState) {
                          if (categoryState is CategoryLoading) {
                            return const SliverToBoxAdapter(
                              child: Center(child: CircularProgressIndicator()),
                            );
                          }

                          if (categoryState is CategoryError) {
                            return SliverToBoxAdapter(
                              child: Center(
                                child: Text(
                                  categoryState.message,
                                  style: AppTextStyles.bodyMedium.copyWith(
                                    color: AppColors.error,
                                  ),
                                ),
                              ),
                            );
                          }

                          if (categoryState is CategoryLoaded) {
                            final colors = [
                              AppColors.primary500,
                              AppColors.success,
                              AppColors.warning,
                              AppColors.primary900,
                              AppColors.error,
                              AppColors.neutral400,
                              Colors.purple,
                              Colors.orange,
                              Colors.blue,
                              Colors.pink,
                              Colors.grey,
                              Colors.teal,
                            ];

                            final txnState =
                                context.read<TransactionBloc>().state;
                            final categoryTotals =
                                txnState is TransactionLoaded
                                    ? txnState.categoryTotals
                                    : <String, double>{};

                            final categories = categoryState.categories;

                            return SliverPadding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                              ),
                              sliver: SliverGrid(
                                gridDelegate:
                                    const SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 2,
                                      mainAxisSpacing: 8,
                                      crossAxisSpacing: 8,
                                      childAspectRatio: 1.5,
                                    ),
                                delegate: SliverChildBuilderDelegate((
                                  context,
                                  idx,
                                ) {
                                  final cat = categories[idx];
                                  final amt = categoryTotals[cat.name] ?? 0.0;
                                  final dotColor = colors[idx % colors.length];

                                  return CategoryCard(
                                    category: cat.name,
                                    amount: amt,
                                    color: dotColor,
                                  );
                                }, childCount: categories.length),
                              ),
                            );
                          }

                          return const SliverToBoxAdapter(child: SizedBox());
                        },
                      ),

                      // Recent Expenses Section
                      SliverToBoxAdapter(
                        child: Padding(
                          padding: const EdgeInsets.all(12),
                          child: Text(
                            'Recent Expenses',
                            style: AppTextStyles.bodyMedium.copyWith(
                              color: AppColors.textPrimaryLight,
                              fontWeight: FontWeight.w600,
                              fontFamily: GoogleFonts.spaceGrotesk().fontFamily,
                              fontSize: 14,
                              letterSpacing: -0.15,
                            ),
                          ),
                        ),
                      ),

                      // Recent Expenses List
                      if (state is TransactionLoading)
                        const SliverToBoxAdapter(
                          child: Center(child: CircularProgressIndicator()),
                        )
                      else if (state is TransactionEmpty)
                        const SliverToBoxAdapter(
                          child: EmptyStatePlaceholder(
                            title: 'No Expenses Recorded',
                            message:
                                'You haven\'t recorded any expenses yet. Tap + Add to log your first expense.',
                          ),
                        )
                      else if (state is TransactionLoaded)
                        SliverPadding(
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          sliver: SliverToBoxAdapter(
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(
                                  color: AppColors.borderLight,
                                ),
                              ),
                              child: ListView.builder(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                padding: const EdgeInsets.symmetric(
                                  vertical: 8,
                                  horizontal: 8,
                                ),
                                itemCount: state.transactions.length + 1,
                                itemBuilder: (context, index) {
                                  if (index == state.transactions.length) {
                                    if (!state.hasReachedMax) {
                                      return const Padding(
                                        padding: EdgeInsets.symmetric(
                                          vertical: 16,
                                        ),
                                        child: Center(
                                          child: SizedBox(
                                            width: 24,
                                            height: 24,
                                            child: CircularProgressIndicator(
                                              strokeWidth: 2,
                                            ),
                                          ),
                                        ),
                                      );
                                    }
                                    return const SizedBox();
                                  }

                                  final transaction = state.transactions[index];
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
                                            padding: const EdgeInsets.only(
                                              bottom: 8,
                                            ),
                                            child: ActivityCard(
                                              icon: _getIconForCategory(
                                                transaction.source,
                                              ),
                                              title:
                                                  '${transaction.source}: ${transaction.description}',
                                              subtitle:
                                                  '${transaction.date} • ${transaction.time}',
                                              amount: transaction.amount,
                                              isIncome: false,
                                            ),
                                          ),
                                        ),
                                      );
                                    },
                                  );
                                },
                              ),
                            ),
                          ),
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

  HeroIcons _getIconForCategory(String category) {
    switch (category.toLowerCase()) {
      case 'food & dining':
        return HeroIcons.cake;
      case 'transportation':
        return HeroIcons.truck;
      case 'housing':
        return HeroIcons.home;
      case 'entertainment':
        return HeroIcons.tv;
      case 'shopping':
        return HeroIcons.shoppingBag;
      default:
        return HeroIcons.tag;
    }
  }
}

class _SliverHeaderDelegate extends SliverPersistentHeaderDelegate {
  final Widget child;

  _SliverHeaderDelegate({required this.child});

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return child;
  }

  @override
  double get maxExtent => 75;

  @override
  double get minExtent => 73;

  @override
  bool shouldRebuild(covariant _SliverHeaderDelegate oldDelegate) {
    return child != oldDelegate.child;
  }
}
