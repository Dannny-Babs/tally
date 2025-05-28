import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:heroicons/heroicons.dart';
import 'package:tally/features/transactions/views/add_income_screen.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../bloc/transaction_bloc.dart';
import '../bloc/transaction_event.dart';
import '../bloc/transaction_state.dart';
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
                                    'Total income this month',
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
                                        '4200.00',
                                        style: AppTextStyles.displayLarge.copyWith(
                                          fontSize: 52,
                                          color: AppColors.textPrimaryLight,
                                        ),
                                      ),
                                    ],
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
                                          fontFamily:
                                              GoogleFonts.spaceMono().fontFamily,
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

                      // Income History Header
                      SliverToBoxAdapter(
                        child: Padding(
                          padding: const EdgeInsets.all(12),
                          child: Text(
                            'Income History',
                            style: AppTextStyles.displaySmall.copyWith(
                              color: AppColors.textPrimaryLight,
                              letterSpacing: -0.5,
                              fontSize: 16,
                              fontFamily: GoogleFonts.spaceGrotesk().fontFamily,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),

                      // Income List
                      if (state is TransactionLoading)
                        const SliverToBoxAdapter(
                          child: Center(child: CircularProgressIndicator()),
                        )
                      else if (state is TransactionEmpty)
                        const SliverToBoxAdapter(
                          child: EmptyStatePlaceholder(
                            title: 'No Income Recorded',
                            message:
                                'You haven\'t recorded any income yet. Tap + Add to record your first payment.',
                          ),
                        )
                      else if (state is TransactionLoaded)
                        SliverPadding(
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          sliver:SliverToBoxAdapter(
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
                                    if (state.hasReachedMax) {
                                      return Center(
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                            vertical: 16,
                                          ),
                                          child: Text(
                                            'Oops, that\'s all!',
                                            style: AppTextStyles.bodySmall.copyWith(
                                              color: AppColors.neutral600,
                                              fontFamily:
                                                  GoogleFonts.spaceGrotesk().fontFamily,
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
                                              icon: _getIconForSource(
                                                transaction.source,
                                              ),
                                              title:transaction.description,
                                              subtitle:
                                                  '${transaction.source} • ${transaction.date}',
                                              amount: transaction.amount,
                                              isIncome: true,
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

  HeroIcons _getIconForSource(String source) {
    switch (source.toLowerCase()) {
      case 'freelance':
        return HeroIcons.computerDesktop;
      case 'job':
        return HeroIcons.briefcase;
      default:
        return HeroIcons.banknotes;
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
}
