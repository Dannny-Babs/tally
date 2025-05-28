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
                      // Header with parallax effect
                      SliverPersistentHeader(
                        pinned: true,
                        delegate: _SliverHeaderDelegate(
                          child: Container(
                            color: AppColors.backgroundLight,
                            child: Padding(
                              padding: const EdgeInsets.all(12),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Expenses',
                                        style: AppTextStyles.displaySmall
                                            .copyWith(
                                              color: AppColors.neutral900,
                                              fontFamily:
                                                  GoogleFonts.spaceGrotesk()
                                                      .fontFamily,
                                              fontSize: 20,
                                              letterSpacing: -0.5,
                                              fontWeight: FontWeight.w600,
                                            ),
                                      ),
                                      Text(
                                        'Track your spending',
                                        style: AppTextStyles.bodyMedium
                                            .copyWith(
                                              color: AppColors.neutral700,
                                              letterSpacing: -0.15,
                                              fontFamily:
                                                  GoogleFonts.spaceGrotesk()
                                                      .fontFamily,
                                              fontSize: 14,
                                            ),
                                      ),
                                    ],
                                  ),
                                  IconButton(
                                    onPressed: () {
                                      showModalBottomSheet(
                                        context: context,
                                        backgroundColor: Colors.transparent,
                                        isScrollControlled: true,
                                        builder: (_) => const AddExpenseModal(),
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
                          child: Container(
                            padding: const EdgeInsets.all(12),
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
                                  '\$${state.totalAmount.toStringAsFixed(2).replaceAllMapped(RegExp(r'(\d)(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')}',
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
                                const SizedBox(height: 12),
                                SizedBox(
                                  width: double.infinity,
                                  child: ElevatedButton.icon(
                                    onPressed: () {
                                      showModalBottomSheet(
                                        context: context,
                                        backgroundColor: Colors.transparent,
                                        isScrollControlled: true,
                                        builder: (_) => const AddExpenseModal(),
                                      );
                                    },
                                    icon: const Icon(
                                      Icons.add,
                                      color: Colors.white,
                                    ),
                                    label: Text(
                                      'Add Expense',
                                      style: AppTextStyles.bodyMedium.copyWith(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w600,
                                        letterSpacing: -0.15,
                                        fontFamily:
                                            GoogleFonts.spaceMono().fontFamily,
                                      ),
                                    ),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: AppColors.neutral900,
                                      foregroundColor: AppColors.surfaceLight,
                                      padding: const EdgeInsets.symmetric(
                                        vertical: 12,
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
                        )else if(state is TransactionEmpty)
                          SliverToBoxAdapter(
                            child: Container(
                            padding: const EdgeInsets.all(12),
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
                                  '\$0.00',
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
                                    categoryTotals: const {},
                                ),
                                const SizedBox(height: 12),
                                SizedBox(
                                  width: double.infinity,
                                  child: ElevatedButton.icon(
                                    onPressed: () {
                                      showModalBottomSheet(
                                        context: context,
                                        backgroundColor: Colors.transparent,
                                        isScrollControlled: true,
                                        builder: (_) => const AddExpenseModal(),
                                      );
                                    },
                                    icon: const Icon(
                                      Icons.add,
                                      color: Colors.white,
                                    ),
                                    label: Text(
                                      'Add Expense',
                                      style: AppTextStyles.bodyMedium.copyWith(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w600,
                                        letterSpacing: -0.15,
                                        fontFamily:
                                            GoogleFonts.spaceMono().fontFamily,
                                      ),
                                    ),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: AppColors.neutral900,
                                      foregroundColor: AppColors.surfaceLight,
                                      padding: const EdgeInsets.symmetric(
                                        vertical: 12,
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
                                  fontFamily:
                                      GoogleFonts.spaceGrotesk().fontFamily,
                                  fontSize: 14,
                                  letterSpacing: -0.15,
                                ),
                              ),
                              InkWell(
                                onTap: () {},
                                child: Text(
                                  'See All',
                                  style: AppTextStyles.bodyMedium.copyWith(
                                    color: AppColors.primary500,
                                    fontWeight: FontWeight.w600,
                                    fontFamily:
                                        GoogleFonts.spaceGrotesk().fontFamily,
                                    fontSize: 14,
                                    letterSpacing: -0.15,
                                  ),
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
                              child: Padding(
                                padding: EdgeInsets.all(80.0),
                                child: Center(
                                  child: CircularProgressIndicator(),
                                ),
                              ),
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

                      // Transaction Groups
                      if (state is TransactionLoading)
                        const SliverToBoxAdapter(
                          child: Center(
                            child: Padding(
                              padding: EdgeInsets.symmetric(vertical: 50),
                              child: CircularProgressIndicator(),
                            ),
                          ),
                        )
                      else if (state is TransactionEmpty)
                        SliverToBoxAdapter(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(
                                  bottom: 8,
                                  top: 16,
                                  left: 12,
                                ),
                                child: Text(
                                  'Expenses',
                                  style: AppTextStyles.bodyMedium.copyWith(
                                    color: AppColors.textPrimaryLight,
                                    fontWeight: FontWeight.w600,
                                    fontFamily:
                                        GoogleFonts.spaceGrotesk().fontFamily,
                                    fontSize: 14,
                                    letterSpacing: -0.15,
                                  ),
                                ),
                              ),
                              Container(
                                height: MediaQuery.of(context).size.height * 0.5,
                                margin: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 4,
                                ),
                                child: const EmptyStatePlaceholder(
                                  title: 'No Expenses Recorded',
                                  message:
                                      'You haven\'t recorded any expenses yet. Tap + Add to log your first expense.',
                                ),
                              ),
                            ],
                          ),
                        )
                      else if (state is TransactionLoaded)
                        ..._buildTransactionGroups(
                          state.transactions,
                          state.hasReachedMax,
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

  List<Widget> _buildTransactionGroups(
    List<Transaction> transactions,
    bool hasReachedMax,
  ) {
    final groups = _groupTransactions(transactions);
    final entries = groups.entries.toList();
    final widgets = <Widget>[];

    for (var i = 0; i < entries.length; i++) {
      final group = entries[i];

      // Add header
      widgets.add(
        SliverPersistentHeader(
          pinned: true,
          delegate: _SliverHeaderDelegate(
            child: Container(
              color: AppColors.backgroundLight,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
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
            ),
            minHeight: 45,
            maxHeight: 50,
          ),
        ),
      );

      // Add transactions
      widgets.add(
        SliverPadding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          sliver: SliverToBoxAdapter(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.borderLight),
              ),
              child: ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
                itemCount: group.value.length,
                separatorBuilder: (context, index) => const SizedBox(height: 8),
                itemBuilder: (context, index) {
                  final transaction = group.value[index];
                  return TweenAnimationBuilder<double>(
                    tween: Tween(begin: 0.0, end: 1.0),
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeOut,
                    builder: (context, value, child) {
                      return Transform.translate(
                        offset: Offset(0, 20 * (1 - value)),
                        child: Opacity(
                          opacity: value,
                          child: ActivityCard(
                            icon: _getIconForCategory(transaction.source),
                            title:
                                '${transaction.source}: ${transaction.description}',
                            subtitle:
                                '${transaction.date} • ${transaction.time}',
                            amount: transaction.amount,
                            isIncome: false,
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
      );
    }

    // Add end message or loading indicator
    widgets.add(
      SliverToBoxAdapter(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 16),
            child:
                hasReachedMax
                    ? Text(
                      'Oops, that\'s all!',
                      style: AppTextStyles.bodySmall.copyWith(
                        color: AppColors.neutral700,
                        fontFamily: GoogleFonts.spaceGrotesk().fontFamily,
                      ),
                    )
                    : const SizedBox(
                      width: 24,
                      height: 24,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    ),
          ),
        ),
      ),
    );

    return widgets;
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

  _getIconForCategory(String category) {
    switch (category.toLowerCase()) {
      // Food & Dining
      case 'food':
        return HugeIconsSolid.bread04;
      case 'dining':
        return HugeIconsSolid.restaurant02;

      case 'restaurants':
        return HugeIconsSolid.restaurant02;
      case 'groceries':
        return HugeIconsSolid.store03;

      // Shopping & Personal
      case 'shopping':
        return HugeIconsSolid.shoppingCart01;
      case 'clothing':
        return HugeIconsSolid.shirt01;
      case 'school':
        return HugeIconsSolid.school;
      case 'education':
        return HugeIconsSolid.book01;
      case 'toys':
        return HugeIconsSolid.gift;
      case 'personal care':
        return HugeIconsSolid.userLock01;
      case 'hair':
        return HugeIconsSolid.userLock01;
      case 'beauty':
        return HugeIconsSolid.userLock01;
      case 'skincare':
        return HugeIconsSolid.userLock01;

      // Bills & Payments
      case 'credit cards':
        return HugeIconsSolid.creditCard;
      case 'taxes':
        return HugeIconsSolid.taxes;
      case 'phone':
        return HugeIconsSolid.smartPhone01;

      // Education
      case 'tuition':
        return HugeIconsSolid.school;
      case 'books':
        return HugeIconsSolid.book01;
      case 'music lessons':
        return HugeIconsSolid.musicNote01;

      // Entertainment & Hobbies
      case 'concerts/shows':
        return HugeIconsSolid.musicNote01;
      case 'games':
        return HugeIconsSolid.gameController01;
      case 'hobbies':
        return HugeIconsSolid.canvas;
      case 'movies':
        return HugeIconsSolid.tv01;
      case 'music':
        return HugeIconsSolid.musicNote01;
      case 'sports':
        return HugeIconsSolid.footballPitch;
      case 'tv':
        return HugeIconsSolid.tv01;

      // Personal Care & Subscriptions
      case 'laundry/dry cleaning':
      case 'laundry':
        return HugeIconsSolid.home01;
      case 'subscriptions':
        return HugeIconsSolid.creditCard;

      // Technology
      case 'domains & hosting':
        return HugeIconsSolid.developer;
      case 'online services':
        return HugeIconsSolid.developer;
      case 'hardware':
        return HugeIconsSolid.developer;
      case 'software':
        return HugeIconsSolid.developer;

      // Transportation
      case 'public transit':
        return HugeIconsSolid.metro;
      case 'ride hailing':
        return HugeIconsSolid.taxi;

      // Travel
      case 'airfare':
        return HugeIconsSolid.airplane01;
      case 'hotels':
        return HugeIconsSolid.home01;
      case 'transportation':
        return HugeIconsSolid.car01;

      // Housing
      case 'rent':
        return HugeIconsSolid.home02;
      case 'housing':
        return HugeIconsSolid.home01;

      // Income Categories
      case 'investment':
        return HugeIconsSolid.chart01;
      case 'job payment':
        return HugeIconsSolid.briefcase01;
      case 'family':
        return HugeIconsSolid.userGroup02;
      case 'design':
        return HugeIconsSolid.canvas;
      case 'development':
        return HugeIconsSolid.developer;
      case 'marketing':
        return HugeIconsSolid.megaphone01;

      // Other Categories
      case 'utilities':
        return HugeIconsSolid.invoice;
      case 'health & fitness':
        return HugeIconsSolid.health;
      case 'entertainment':
        return HugeIconsSolid.tv01;
      case 'travel':
        return HugeIconsSolid.airplane01;
      case 'insurance':
        return HugeIconsSolid.shield01;
      case 'gifts & donations':
        return HugeIconsSolid.gift;
      case 'investments':
        return HugeIconsSolid.chart01;
      case 'kids':
        return HugeIconsSolid.baby01;
      case 'alcohol & bars':
        return HugeIconsSolid.drink;
      case 'miscellaneous':
        return HugeIconsSolid.tag02;

      default:
        return HugeIconsSolid.tag01;
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
