import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:heroicons/heroicons.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';

class InsightModal extends StatelessWidget {
  const InsightModal({super.key});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 6, vertical: 20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: const BorderRadius.all(Radius.circular(12)),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: ConstrainedBox(
              constraints: BoxConstraints(
                maxHeight: MediaQuery.of(context).size.height * 0.6,
              ),
              child: SingleChildScrollView(
                child: IntrinsicHeight(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Your AI Financial Summary',
                                  style: AppTextStyles.displaySmall.copyWith(
                                    color: AppColors.textPrimaryLight,
                                    fontFamily: GoogleFonts.spaceGrotesk().fontFamily,
                                    fontSize: 20,
                                    letterSpacing: -0.5,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                Text(
                                  'A quick, data-driven snapshot of your spending habits',
                                  style: AppTextStyles.bodyMedium.copyWith(
                                    color: AppColors.neutral700,
                                    letterSpacing: -0.15,
                                    fontFamily: GoogleFonts.spaceGrotesk().fontFamily,
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.close),
                            color: AppColors.textPrimaryLight,
                            onPressed: () => Navigator.pop(context),
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),
                      _buildOverviewCard(
                        context,
                        income: 3200,
                        spent: 1950,
                        net: 1250,
                      ),
                      const SizedBox(height: 16),
                      _buildInsightRow(
                        context,
                        title: 'Top Category',
                        value: 'Food & Dining',
                        change: '21%',
                        details: 'You spent \$420 this month on food',
                        icon: HeroIcons.cake,
                      ),
                      const SizedBox(height: 12),
                      _buildInsightRow(
                        context,
                        title: 'Spending Spike',
                        value: '+28%',
                        change: 'Thursdays',
                        details: 'Your food spend jumped compared to last month',
                        icon: HeroIcons.chartBar,
                        isIncrease: true,
                      ),
                      const SizedBox(height: 12),
                      _buildInsightRow(
                        context,
                        title: 'High-Frequency Expense',
                        value: '9 payments',
                        change: '\$180',
                        details: 'Subscription charges this period',
                        icon: HeroIcons.creditCard,
                      ),
                      const SizedBox(height: 16),
                      _buildSuggestionsCard(
                        context,
                        suggestions: [
                          'Consider setting a weekly food budget of \$100 to curb Thursday takeout',
                          'Shift one subscription to an annual plan—it could save you \$30/year',
                          'You\'re on track to hit your \$1,000 savings goal—keep up the good work!',
                        ],
                      ),
                      const SizedBox(height: 16),
                      _buildChartCard(context),
                      const SizedBox(height: 24),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          onPressed: () {
                            // TODO: Implement chat action
                          },
                          icon: HeroIcon(
                            HeroIcons.chatBubbleLeftRight,
                            style: HeroIconStyle.solid,
                            color: Colors.white,
                            size: 20,
                          ),
                          label: Text(
                            'Chat with AI',
                            style: AppTextStyles.bodyMedium.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                              letterSpacing: -0.15,
                              fontFamily: GoogleFonts.spaceGrotesk().fontFamily,
                            ),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.textPrimaryLight,
                            foregroundColor: AppColors.primary100,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(

                              borderRadius: BorderRadius.circular(12),
                              side: BorderSide(
                                color: AppColors.neutral700,                                
                                width: 2,
                              ),
                            
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
        ),
      ),
    );
  }

  Widget _buildOverviewCard(
    BuildContext context, {
    required double income,
    required double spent,
    required double net,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.neutral100,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppColors.borderLight,
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Net This Month',
                  style: GoogleFonts.spaceGrotesk(
                    color: AppColors.neutral800,
                    fontSize: 14,
                    letterSpacing: -0.15,
                  ),
                ),
                Text(
                  '\$${net.toStringAsFixed(0)}',
                  style: GoogleFonts.spaceGrotesk(
                    color: AppColors.textPrimaryLight,
                    fontSize: 32,
                    fontWeight: FontWeight.w600,
                    letterSpacing: -0.5,
                  ),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                'Earned: \$${income.toStringAsFixed(0)}',
                style: GoogleFonts.spaceGrotesk(
                      color: AppColors.neutral700,
                  fontSize: 14,
                  letterSpacing: -0.15,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Spent: \$${spent.toStringAsFixed(0)}',
                style: GoogleFonts.spaceGrotesk(
                  color: AppColors.neutral700,
                  fontSize: 14,
                  letterSpacing: -0.15,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildInsightRow(
    BuildContext context, {
    required String title,
    required String value,
    required String change,
    required String details,
    required HeroIcons icon,
    bool isIncrease = false,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: AppColors.neutral100,
            borderRadius: BorderRadius.circular(8),
          ),
          child: HeroIcon(
            icon,
            style: HeroIconStyle.solid,
            color: AppColors.neutral800,
            size: 20,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: AppTextStyles.bodyMedium.copyWith(
                  color: AppColors.neutral800,
                  fontWeight: FontWeight.w600,
                  fontSize: 13.5,
                  letterSpacing: -0.15,
                  fontFamily: GoogleFonts.spaceGrotesk().fontFamily,
                ),
              ),
              const SizedBox(height: 6),
              Row(
                children: [
                  Text(
                    value,
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: AppColors.textPrimaryLight,
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                      fontFamily: GoogleFonts.spaceGrotesk().fontFamily,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: isIncrease ? Colors.red.withOpacity(0.1) : Colors.green.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      change,
                      style: AppTextStyles.bodySmall.copyWith(
                        color: isIncrease ? Colors.red : Colors.green,
                        fontWeight: FontWeight.w600,
                        letterSpacing: -0.15,
                        fontSize: 12,
                        fontFamily: GoogleFonts.spaceGrotesk().fontFamily,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 2),
              Text(
                details,
                style: AppTextStyles.bodySmall.copyWith(
                  color: AppColors.neutral700,
                  fontSize: 12,
                  letterSpacing: -0.08,
                  fontFamily: GoogleFonts.spaceGrotesk().fontFamily,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSuggestionsCard(
    BuildContext context, {
    required List<String> suggestions,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.backgroundLight,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppColors.borderLight,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              HeroIcon(
                HeroIcons.lightBulb,
                style: HeroIconStyle.solid,
                color: AppColors.neutral800,
                size: 20,
              ),
              const SizedBox(width: 8),
              Text(
                'Smart Suggestions',
                style: AppTextStyles.bodyMedium.copyWith(
                  color: AppColors.textPrimaryLight,
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                  letterSpacing: -0.15,
                  fontFamily: GoogleFonts.spaceGrotesk().fontFamily,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ...suggestions.map((suggestion) => Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      margin: const EdgeInsets.only(top: 6),
                      width: 6,
                      height: 6,
                      decoration: BoxDecoration(
                        color: AppColors.textPrimaryLight,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        suggestion,
                        style: AppTextStyles.bodySmall.copyWith(
                          color: AppColors.neutral800,
                          fontSize: 14,
                          letterSpacing: -0.08,
                          fontFamily: GoogleFonts.spaceGrotesk().fontFamily,
                        ),
                      ),
                    ),
                  ],
                ),
              )),
        ],
      ),
    );
  }

  Widget _buildChartCard(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.backgroundLight,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppColors.primary200.withAlpha(150),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Spending Trend',
            style: GoogleFonts.spaceGrotesk(
              color: AppColors.textPrimaryLight,
              fontWeight: FontWeight.w600,
              fontSize: 16,
              letterSpacing: -0.15,
            ),
          ),
          const SizedBox(height: 12),
          SizedBox(
            height: 100,
            child: LineChart(
              LineChartData(
                gridData: const FlGridData(show: false),
                titlesData: const FlTitlesData(show: false),
                borderData: FlBorderData(show: false),
                lineBarsData: [
                  LineChartBarData(
                    spots: [
                      const FlSpot(0, 3),
                      const FlSpot(1, 1),
                      const FlSpot(2, 4),
                      const FlSpot(3, 2),
                      const FlSpot(4, 5),
                    ],
                    isCurved: true,
                    color: AppColors.textPrimaryLight,
                    barWidth: 3,
                    dotData: const FlDotData(show: false),
                    belowBarData: BarAreaData(
                      show: true,
                      color: AppColors.textPrimaryLight.withOpacity(0.1),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
} 