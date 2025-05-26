import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:heroicons/heroicons.dart';
import 'package:tally/features/transactions/views/add_income_screen.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../bloc/transaction_bloc.dart';
import '../widgets/activity_card.dart';
import '../widgets/empty_state_placeholder.dart';
import '../widgets/error_screen.dart';

class IncomeScreen extends StatelessWidget {
  const IncomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => TransactionBloc()..add(IncomeLoaded()),
      child: BlocBuilder<TransactionBloc, TransactionState>(
        builder: (context, state) {
          print('Current state: $state'); // Debug print

          if (state is TransactionError) {
            return ErrorScreen(
              message: state.message,
              onRetry: () {
                context.read<TransactionBloc>().add(IncomeLoaded());
              },
            );
          }

          return Scaffold(
            backgroundColor: AppColors.surfaceLight,
            appBar: AppBar(
              backgroundColor: AppColors.backgroundLight,
              title: Text(
                'Income',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      color: AppColors.neutral900,
                      fontWeight: FontWeight.w600,
                    ),
              ),
              actions: [
                IconButton(
                  icon: HeroIcon(
                    HeroIcons.plus,
                    style: HeroIconStyle.solid,
                    color: AppColors.primary200.withAlpha(150),
                    size: 24,
                  ),
                  onPressed: () {
                    // Navigate to add income screen
                  },
                ),
              ],
            ),
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
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Total Income',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: AppColors.textSecondaryLight,
                            ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        '\$2,500',
                        style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                              color: AppColors.neutral900,
                              fontWeight: FontWeight.w600,
                            ),
                      ),
                      const SizedBox(height: 16),
                      _buildIncomeSplitCard(
                        sources: {'Freelance': 2800, 'Job': 1400},
                      ),
                      const SizedBox(height: 4),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          onPressed: () {
                            // TODO: Navigate to AddTransactionScreen
                            showModalBottomSheet(
                              context: context,
                              backgroundColor: Colors.transparent,
                              isScrollControlled: true,
                              builder: (_) => const AddIncomeModal(),
                            );
                          },
                          icon: Icon(
                            Icons.add,
                            color: AppColors.surfaceLight,
                          ),
                          label: Text(
                            'Add Income / Payment',
                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: AppColors.surfaceLight,
                              fontWeight: FontWeight.w600,
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
                      const SizedBox(height: 16),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 4.0),
                        child: Text(
                          'Income History',
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            color: AppColors.neutral900,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Expanded(
                        child:
                            state is TransactionLoading
                                ? const Center(
                                  child: CircularProgressIndicator(),
                                )
                                : state is TransactionEmpty
                                ? const EmptyStatePlaceholder(
                                  message:
                                      'No income logged yet. Tap + Add to record your first payment.',
                                )
                                : state is TransactionLoaded
                                ? Container(
                                  decoration: BoxDecoration(
                                    color: AppColors.surfaceLight,
                                    borderRadius: BorderRadius.circular(16),
                                    border: Border.all(
                                      color: AppColors.primary200.withAlpha(150),
                                    ),
                                  ),
                                  child: NotificationListener<ScrollNotification>(
                                    onNotification: (ScrollNotification scrollInfo) {
                                      if (scrollInfo is ScrollEndNotification &&
                                          scrollInfo.metrics.pixels >=
                                              scrollInfo.metrics.maxScrollExtent - 200) {
                                        final currentState = state;
                                        if (!currentState.hasReachedMax) {
                                          context.read<TransactionBloc>().add(
                                            TransactionLoadMore(),
                                          );
                                        }
                                      }
                                      return true;
                                    },
                                    child: ListView.separated(
                                      padding: const EdgeInsets.symmetric(
                                        vertical: 8,
                                        horizontal: 8,
                                      ),
                                      itemCount: (state).transactions.length + 1,
                                      separatorBuilder: (context, index) =>
                                          const SizedBox(height: 8),
                                      itemBuilder: (context, index) {
                                        final currentState = state;
                                        if (index == currentState.transactions.length) {
                                          if (currentState.hasReachedMax) {
                                            return Center(
                                              child: Padding(
                                                padding: const EdgeInsets.symmetric(
                                                  vertical: 16,
                                                ),
                                                child: Text(
                                                  'Oops, that\'s all!',
                                                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                                    color: AppColors.textSecondaryLight,
                                                  ),
                                                ),
                                              ),
                                            );
                                          } else {
                                            return const Center(
                                              child: Padding(
                                                padding: EdgeInsets.symmetric(
                                                  vertical: 16,
                                                ),
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
                                        }
                                        final transaction = currentState.transactions[index];
                                        return ActivityCard(
                                          icon: _getIconForSource(transaction.source),
                                          title: '${transaction.source}: ${transaction.description}',
                                          subtitle: '${transaction.date} • ${transaction.time}',
                                          amount: transaction.amount,
                                          isIncome: true,
                                        );
                                      },
                                    ),
                                  ),
                                )
                                : const SizedBox.shrink(),
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

  Widget _buildIncomeSplitCard({required Map<String, int> sources}) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.primary200.withAlpha(150),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Income by Source',
            style: TextStyle(
              color: AppColors.textSecondaryLight,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 16),
          ...sources.entries.map((entry) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    entry.key,
                    style: TextStyle(
                      color: AppColors.textPrimaryLight,
                      fontSize: 14,
                    ),
                  ),
                  Text(
                    '\$${entry.value}',
                    style: TextStyle(
                      color: AppColors.neutral900,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
        ],
      ),
    );
  }

  HeroIcons _getIconForSource(String source) {
    switch (source.toLowerCase()) {
      case 'salary':
        return HeroIcons.briefcase;
      case 'freelance':
        return HeroIcons.computerDesktop;
      case 'investment':
        return HeroIcons.chartBar;
      case 'gift':
        return HeroIcons.gift;
      default:
        return HeroIcons.banknotes;
    }
  }
}
