import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:heroicons/heroicons.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:tally/features/transactions/views/add_expense_screen.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../bloc/transaction_bloc.dart';
import '../bloc/category_bloc.dart';
import '../bloc/category_state.dart';
import '../bloc/category_event.dart';
import '../widgets/activity_card.dart';
import '../widgets/empty_state_placeholder.dart';
import '../widgets/error_screen.dart';

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
                child: Padding(
                  padding: const EdgeInsets.all(8),
                  child: Column(
                    children: [
                      // Header
                      Padding(
                        padding: const EdgeInsets.all(8),
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
                                    fontFamily: GoogleFonts.spaceGrotesk().fontFamily,
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
                                    fontFamily: GoogleFonts.spaceGrotesk().fontFamily,
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
                                  builder: (context) => const AddExpenseModal(),
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

                      // Summary Card
                      if (state is TransactionLoaded) ...[
                        Container(
                          padding: const EdgeInsets.all(16),
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
                                  color: AppColors.textSecondaryLight,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                '\$${state.totalAmount.toStringAsFixed(2)}',
                                style: AppTextStyles.displaySmall.copyWith(
                                  color: AppColors.primary500,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(height: 16),
                              Text(
                                'Top Categories',
                                style: AppTextStyles.bodyMedium.copyWith(
                                  color: AppColors.textSecondaryLight,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              const SizedBox(height: 8),
                              ...state.categoryTotals.entries
                                  .take(3)
                                  .map((entry) => Padding(
                                        padding: const EdgeInsets.only(bottom: 8),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              entry.key,
                                              style: AppTextStyles.bodyMedium
                                                  .copyWith(
                                                color: AppColors.textPrimaryLight,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                            Text(
                                              '\$${entry.value.toStringAsFixed(2)}',
                                              style: AppTextStyles.bodyMedium
                                                  .copyWith(
                                                color: AppColors.primary500,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                          ],
                                        ),
                                      )),
                            ],
                          ),
                        ),
                        const SizedBox(height: 16),

                      
                      ],

                      // Categories Panel
                      BlocBuilder<CategoryBloc, CategoryState>(
                        builder: (context, categoryState) {
                          return Container(
                            margin: const EdgeInsets.symmetric(horizontal: 16),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(color: AppColors.borderLight),
                            ),
                            child: Column(
                              children: [
                                ListTile(
                                  title: Text(
                                    'Categories',
                                    style: AppTextStyles.bodyMedium.copyWith(
                                      color: AppColors.textPrimaryLight,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  trailing: IconButton(
                                    onPressed: () {
                                      // TODO: Show add category modal
                                    },
                                    icon: HeroIcon(
                                      HeroIcons.plus,
                                      color: AppColors.neutral900,
                                    ),
                                  ),
                                ),
                                if (categoryState is CategoryLoading)
                                  const Center(
                                    child: Padding(
                                      padding: EdgeInsets.all(16),
                                      child: CircularProgressIndicator(),
                                    ),
                                  )
                                else if (categoryState is CategoryEmpty)
                                  const EmptyStatePlaceholder(
                                    message:
                                        'No categories yet. Tap + to add your first category.',
                                  )
                                else if (categoryState is CategoryLoaded)
                                  ListView.separated(
                                    shrinkWrap: true,
                                    physics: const NeverScrollableScrollPhysics(),
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 16,
                                      vertical: 8,
                                    ),
                                    itemCount: categoryState.categories.length,
                                    separatorBuilder: (context, index) =>
                                        const Divider(height: 1),
                                    itemBuilder: (context, index) {
                                      final category =
                                          categoryState.categories[index];
                                      return ListTile(
                                        title: Text(
                                          category.name,
                                          style: AppTextStyles.bodyMedium.copyWith(
                                            color: AppColors.textPrimaryLight,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                        subtitle: Text(
                                          category.description ?? '',
                                          style: AppTextStyles.bodySmall.copyWith(
                                            color: AppColors.textSecondaryLight,
                                          ),
                                        ),
                                        trailing: IconButton(
                                          onPressed: () {
                                            // TODO: Show edit category modal
                                          },
                                          icon: HeroIcon(
                                            HeroIcons.pencilSquare,
                                            color: AppColors.neutral900,
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                              ],
                            ),
                          );
                        },
                      ),
                      const SizedBox(height: 16),

                      // Expense List
                      Expanded(
                        child: state is TransactionLoading
                            ? const Center(
                                child: CircularProgressIndicator(),
                              )
                            : state is TransactionEmpty
                                ? const EmptyStatePlaceholder(
                                    message:
                                        'No expenses recorded. Tap + Add to log your first expense.',
                                  )
                                : state is TransactionLoaded
                                    ? Container(
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: BorderRadius.circular(16),
                                          border: Border.all(
                                            color: AppColors.borderLight,
                                          ),
                                        ),
                                        child: NotificationListener<
                                            ScrollNotification>(
                                          onNotification:
                                              (ScrollNotification scrollInfo) {
                                            if (scrollInfo
                                                    is ScrollEndNotification &&
                                                scrollInfo.metrics.pixels >=
                                                    scrollInfo.metrics
                                                            .maxScrollExtent -
                                                        200) {
                                              if (!state.hasReachedMax) {
                                                context
                                                    .read<TransactionBloc>()
                                                    .add(TransactionLoadMore());
                                              }
                                            }
                                            return true;
                                          },
                                          child: ListView.separated(
                                            padding: const EdgeInsets.symmetric(
                                              vertical: 8,
                                              horizontal: 8,
                                            ),
                                            itemCount:
                                                state.transactions.length + 1,
                                            separatorBuilder: (context, index) =>
                                                const SizedBox(height: 8),
                                            itemBuilder: (context, index) {
                                              if (index ==
                                                  state.transactions.length) {
                                                if (!state.hasReachedMax) {
                                                  return const Center(
                                                    child: Padding(
                                                      padding:
                                                          EdgeInsets.symmetric(
                                                        vertical: 16,
                                                      ),
                                                      child: SizedBox(
                                                        width: 24,
                                                        height: 24,
                                                        child:
                                                            CircularProgressIndicator(
                                                          strokeWidth: 2,
                                                        ),
                                                      ),
                                                    ),
                                                  );
                                                }
                                                return const SizedBox();
                                              }
                                              final transaction =
                                                  state.transactions[index];
                                              return ActivityCard(
                                                icon: _getIconForCategory(
                                                  transaction.source,
                                                ),
                                                title:
                                                    '${transaction.source}: ${transaction.description}',
                                                subtitle:
                                                    '${transaction.date} • ${transaction.time}',
                                                amount: transaction.amount,
                                                isIncome: false,
                                              );
                                            },
                                          ),
                                        ),
                                      )
                                    : const SizedBox(),
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