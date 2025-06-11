import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tally/features/transactions/widgets/exports.dart';
import '../../../core/utils/category_icons.dart';
import '../../../utils/models.dart';
import '../../transactions/repositories/all_transactions_repository.dart';
import '../../transactions/repositories/expense_repository.dart';
import '../../transactions/repositories/income_repository.dart';
import '../bloc/dashboard_bloc.dart';
import '../bloc/dashboard_state.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import 'package:heroicons/heroicons.dart';
import '../widgets/insight_modal.dart';
import '../widgets/add_options_modal.dart';
import 'package:intl/intl.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DashboardBloc, DashboardState>(
      builder: (context, state) {
        return Scaffold(
          backgroundColor: Colors.white,
          body: SafeArea(
            child: Container(
              decoration: BoxDecoration(
                color: AppColors.backgroundLight,
                borderRadius: const BorderRadius.only(
                  bottomRight: Radius.circular(24),
                  bottomLeft: Radius.circular(24),
                ),
                border: Border.all(color: AppColors.borderLight),
              ),
              height: MediaQuery.of(context).size.height,
              padding: const EdgeInsets.symmetric(horizontal: 6),
              child: CustomScrollView(
                slivers: [
                  SliverToBoxAdapter(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            vertical: 12,
                            horizontal: 6,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Hi, Daniel',
                                    style: AppTextStyles.displayMedium.copyWith(
                                      color: AppColors.textPrimaryLight,
                                      fontFamily: GoogleFonts.spaceGrotesk().fontFamily,
                                      fontWeight: FontWeight.w600,
                                      letterSpacing: -0.5,
                                      fontSize: 18,
                                    ),
                                  ),
                                  Text(
                                    'Welcome back to Tally',
                                    style: AppTextStyles.bodySmall.copyWith(
                                      color: AppColors.neutral700,
                                      fontFamily: GoogleFonts.spaceGrotesk().fontFamily,
                                      fontWeight: FontWeight.w600,
                                      letterSpacing: -0.5,
                                      fontSize: 14,
                                    ),
                                  ),
                                ],
                              ),
                              InkWell(
                                onTap: () {
                                  showModalBottomSheet(
                                    context: context,
                                    backgroundColor: Colors.transparent,
                                    isScrollControlled: true,
                                    builder: (_) => const AddOptionsModal(),
                                  );
                                },
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 10,
                                  ),
                                  decoration: BoxDecoration(
                                    color: AppColors.textPrimaryLight,
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Row(
                                    children: [
                                      const HeroIcon(
                                        HeroIcons.plus,
                                        style: HeroIconStyle.solid,
                                        color: AppColors.neutral100,
                                        size: 16,
                                      ),
                                      const SizedBox(width: 4),
                                      Text(
                                        'Add more',
                                        style: AppTextStyles.bodyMedium.copyWith(
                                          color: AppColors.neutral100,
                                          fontSize: 14,
                                          letterSpacing: -0.35,
                                          fontFamily:
                                              GoogleFonts.spaceGrotesk().fontFamily,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 12),
                        _TotalIncomeCard(
                          total: state.totalIncome,
                          tax: 1267.12,
                          net: 2958.12,
                          currency: '\$',
                        ),
                        const _SavingsCard(current: 905.69, target: 1500),
                        const SizedBox(height: 12),
                      ],
                    ),
                  ),
                  SliverToBoxAdapter(
                    child: FutureBuilder<List<Transaction>>(
                      future: AllTransactionsRepository(
                        incomeRepository: IncomeRepository(),
                        expenseRepository: ExpenseRepository(),
                      ).getAllTransactions(limit: 1000),
                      builder: (context, snapshot) {
                        if (!snapshot.hasData) {
                          return const _ExpensesCard(total: 0, breakdown: {});
                        }
                        final allTransactions = snapshot.data!;
                        final expenseBreakdown = getThisMonthExpenseBreakdown(allTransactions);
                        final total = expenseBreakdown.values.fold(0.0, (a, b) => a + b);
                        return _ExpensesCard(total: total, breakdown: expenseBreakdown);
                      },
                    ),
                  ),
                  SliverToBoxAdapter(
                    child: GestureDetector(
                      onTap: () {
                        showModalBottomSheet(
                          context: context,
                          isScrollControlled: true,
                          backgroundColor: Colors.transparent,
                          builder: (context) => const InsightModal(),
                        );
                      },
                      child: const _AIInsightsCard(
                        message:
                            "You've saved 18% of your income. Want to hit 25% this month?",
                      ),
                    ),
                  ),
                  SliverToBoxAdapter(
                    child: Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                        side: const BorderSide(color: AppColors.borderLight),
                      ),
                      color: Colors.white,
                      elevation: 0,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12.0,
                              vertical: 12.0,
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Recent Activity',
                                  style: AppTextStyles.displaySmall.copyWith(
                                    color: AppColors.textPrimaryLight,
                                    letterSpacing: -0.5,
                                    fontSize: 16,
                                    fontFamily:
                                        GoogleFonts.spaceGrotesk().fontFamily,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 2),
                          FutureBuilder<List<Transaction>>(
                            future: AllTransactionsRepository(
                              incomeRepository: IncomeRepository(),
                              expenseRepository: ExpenseRepository(),
                            ).getAllTransactions(limit: 20),
                            builder: (context, snapshot) {
                              if (!snapshot.hasData) {
                                return const Center(
                                    child: Padding(
                                  padding: EdgeInsets.all(16),
                                  child: CircularProgressIndicator(),
                                ));
                              }
                              final transactions = snapshot.data!;
                              return Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: ListView.separated(
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  itemCount: transactions.length,
                                  separatorBuilder: (_, __) =>
                                      const SizedBox(height: 8),
                                  itemBuilder: (context, index) {
                                    final tx = transactions[index];
                                    return ActivityCard(
                                      icon: tx.isIncome
                                          ? CategoryIcons.getIncomeIcon(
                                              tx.source)
                                          : CategoryIcons.getExpenseIcon(
                                              tx.source),
                                      title: tx.description,
                                      subtitle: tx.source,
                                      amount:
                                          tx.isIncome ? tx.amount : -tx.amount,
                                      isIncome: tx.isIncome,
                                    );
                                  },
                                ),
                              );
                            },
                          ),
                          const SizedBox(height: 6),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class _TotalIncomeCard extends StatelessWidget {
  final double total;
  final double tax;
  final double net;
  final String currency;

  const _TotalIncomeCard({
    required this.total,
    required this.tax,
    required this.net,
    required this.currency,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: const BorderSide(color: AppColors.borderLight),
      ),
      color: Colors.white,
      elevation: 0,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 4),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 12),
            Text(
              'Total income this month',
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.neutral600,
                letterSpacing: -0.5,
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  currency,
                  style: AppTextStyles.bodyMedium.copyWith(
                    fontSize: 28,
                    color: AppColors.neutral500,
                  ),
                ),
                const SizedBox(width: 4),
                Text(
                  total.toStringAsFixed(2),
                  style: AppTextStyles.displayLarge.copyWith(
                    fontSize: 52,
                    color: AppColors.textPrimaryLight,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            _TaxNetCard(tax: tax, net: net),
          ],
        ),
      ),
    );
  }
}

class _TaxNetCard extends StatelessWidget {
  final double tax;
  final double net;
  const _TaxNetCard({required this.tax, required this.net});

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
        side: const BorderSide(color: AppColors.neutral300),
      ),
      color: AppColors.neutral50,
      elevation: 0,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  'Estimated Tax (30%)',
                  style: AppTextStyles.bodySmall.copyWith(letterSpacing: -0.5),
                ),
                const SizedBox(height: 4),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      '\$',
                      style: AppTextStyles.bodySmall.copyWith(fontSize: 20),
                    ),
                    const SizedBox(width: 2),
                    Text(
                      tax.toStringAsFixed(2),
                      style: AppTextStyles.displaySmall.copyWith(fontSize: 32),
                    ),
                  ],
                ),
              ],
            ),
            Container(width: 1, height: 48, color: AppColors.neutral300),
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text('Net Available', style: AppTextStyles.bodySmall),
                const SizedBox(height: 4),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      '\$',
                      style: AppTextStyles.bodySmall.copyWith(fontSize: 20),
                    ),
                    const SizedBox(width: 2),
                    Text(
                      net.toStringAsFixed(2),
                      style: AppTextStyles.displaySmall.copyWith(fontSize: 32),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _SavingsCard extends StatelessWidget {
  final double current;
  final double target;
  const _SavingsCard({required this.current, required this.target});

  @override
  Widget build(BuildContext context) {
    final percent = (current / target).clamp(0, 1.0);
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: const BorderSide(color: AppColors.borderLight),
      ),
      color: Colors.white,
      elevation: 0,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Savings This Month',
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.textPrimaryLight,
                letterSpacing: -0.5,
                fontFamily: GoogleFonts.spaceGrotesk().fontFamily,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  '\$',
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: AppColors.textSecondaryLight,
                    fontSize: 20,
                  ),
                ),
                const SizedBox(width: 2),
                Text(
                  current.toStringAsFixed(2),
                  style: AppTextStyles.displaySmall.copyWith(
                    fontSize: 28,
                    color: AppColors.textPrimaryLight,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  ' /${target.toStringAsFixed(0)}',
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: AppColors.neutral700,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Progress',
                  style: AppTextStyles.bodySmall.copyWith(
                    color: AppColors.neutral700,
                    fontWeight: FontWeight.w500,
                    letterSpacing: -0.15,
                    fontFamily: GoogleFonts.spaceGrotesk().fontFamily,
                  ),
                ),
                Text(
                  '${(percent * 100).round()}%',
                  style: AppTextStyles.bodySmall.copyWith(
                    color: AppColors.textPrimaryLight,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),
            ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: LinearProgressIndicator(
                borderRadius: BorderRadius.circular(4),
                value: percent.toDouble(),
                backgroundColor: AppColors.neutral200,
                valueColor: const AlwaysStoppedAnimation<Color>(
                  AppColors.textPrimaryLight,
                ),
                minHeight: 8,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ExpensesCard extends StatelessWidget {
  final double total;
  final Map<String, double> breakdown;
  const _ExpensesCard({required this.total, required this.breakdown});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.borderLight),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Total Expenses',
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.textPrimaryLight,
                letterSpacing: -0.15,
                fontFamily: GoogleFonts.spaceGrotesk().fontFamily,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 6),
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  '\$',
                  style: AppTextStyles.bodySmall.copyWith(
                    fontSize: 16,
                    color: AppColors.neutral700,
                  ),
                ),
                const SizedBox(width: 2),
                Text(
                  total.toStringAsFixed(2),
                  style: AppTextStyles.displaySmall.copyWith(
                    fontSize: 32,
                    color: AppColors.textPrimaryLight,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            TopCategoriesWidget(categoryTotals: breakdown),
          ],
        ),
      ),
    );
  }
}

class _AIInsightsCard extends StatelessWidget {
  final String message;
  const _AIInsightsCard({required this.message});

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: const BorderSide(color: AppColors.borderLight),
      ),
      color: Colors.white,
      elevation: 0,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const HeroIcon(
                  HeroIcons.sparkles,
                  style: HeroIconStyle.solid,
                  color: AppColors.textPrimaryLight,
                  size: 20,
                ),
                const SizedBox(width: 4),
                Text(
                  'AI Insights',
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: AppColors.textPrimaryLight,
                    fontSize: 16,
                    letterSpacing: -0.15,
                    fontFamily: GoogleFonts.spaceGrotesk().fontFamily,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Text(
              message,
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.textPrimaryLight,
                fontSize: 16,
                fontWeight: FontWeight.w500,
                letterSpacing: -0.2,
                fontFamily: GoogleFonts.spaceGrotesk().fontFamily,
              ),
            ),
            const SizedBox(height: 12),
            Container(
              decoration: BoxDecoration(
                color: AppColors.neutral100,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: AppColors.neutral300),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'View more',
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: AppColors.textPrimaryLight,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      letterSpacing: -0.2,
                      fontFamily: GoogleFonts.spaceGrotesk().fontFamily,
                    ),
                  ),
                  const HeroIcon(
                    HeroIcons.chevronRight,
                    color: AppColors.textPrimaryLight,
                    size: 20,
                    style: HeroIconStyle.solid,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ActivitiesCard extends StatelessWidget {
  final IconData icon;
  final Color bgColor;
  final Color strokeColor;
  final String title;
  final String category;
  final String time;
  final String amount;
  final Color amountColor;

  const ActivitiesCard({
    super.key,
    required this.icon,
    required this.bgColor,
    required this.strokeColor,
    required this.title,
    required this.category,
    required this.time,
    required this.amount,
    required this.amountColor,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: bgColor,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: strokeColor),
            ),
            child: Icon(icon, color: AppColors.textPrimaryLight, size: 24),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppTextStyles.bodyMedium.copyWith(
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimaryLight,
                    letterSpacing: -0.15,
                    fontSize: 16,
                    fontFamily: GoogleFonts.spaceGrotesk().fontFamily,
                  ),
                ),
                const SizedBox(height: 2),
                Row(
                  children: [
                    Text(
                      category,
                      style: AppTextStyles.bodySmall.copyWith(
                        color: AppColors.primary700,
                        letterSpacing: -0.25,
                        fontWeight: FontWeight.w600,
                        fontSize: 12,
                        fontFamily: GoogleFonts.spaceGrotesk().fontFamily,
                      ),
                    ),
                    const SizedBox(width: 6),
                    Container(
                      width: 3,
                      height: 3,
                      decoration: const BoxDecoration(
                        color: AppColors.primary500,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      time,
                      style: AppTextStyles.bodySmall.copyWith(
                        color: AppColors.primary600,
                        letterSpacing: -0.25,
                        fontSize: 12,
                        fontFamily: GoogleFonts.spaceGrotesk().fontFamily,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Text(
            amount,
            style: AppTextStyles.bodyMedium.copyWith(
              color: amountColor,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}

class InsightCard extends StatelessWidget {
  final String message;
  const InsightCard({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: const BorderSide(color: AppColors.borderLight),
      ),
      color: Colors.white,
      elevation: 0,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 18),
        child: Row(
          children: [
            const Icon(Icons.insights,
                color: AppColors.textPrimaryLight, size: 28),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                message,
                style: AppTextStyles.bodyMedium.copyWith(
                  color: AppColors.textPrimaryLight,
                ),
              ),
            ),
            const Icon(
              Icons.chevron_right,
              color: AppColors.textPrimaryLight,
              size: 28,
            ),
          ],
        ),
      ),
    );
  }
}

Map<String, double> getThisMonthExpenseBreakdown(
    List<Transaction> allTransactions) {
  final now = DateTime.now();
  final thisMonth = now.month;
  final thisYear = now.year;
  final Map<String, double> categoryTotals = {};
  for (final tx in allTransactions) {
    if (!tx.isIncome) {
      final txDate = DateTime.tryParse(tx.date);
      if (txDate != null &&
          txDate.month == thisMonth &&
          txDate.year == thisYear) {
        categoryTotals[tx.category] =
            (categoryTotals[tx.category] ?? 0) + tx.amount;
      }
    }
  }
  return categoryTotals;
}
