import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fl_chart/fl_chart.dart';
import '../bloc/stats_bloc.dart';
import '../bloc/stats_state.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';

class StatsScreen extends StatelessWidget {
  const StatsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<StatsBloc, StatsState>(
      builder: (context, state) {
        return Scaffold(
          body: SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildMonthlyOverview(state),
                  const SizedBox(height: 24),
                  _buildCategoryBreakdown(state),
                  const SizedBox(height: 24),
                  _buildProgressOverview(state),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildMonthlyOverview(StatsState state) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Monthly Overview', style: AppTextStyles.bodyMedium),
            const SizedBox(height: 16),
            SizedBox(
              height: 200,
              child: BarChart(
                BarChartData(
                  alignment: BarChartAlignment.spaceAround,
                  maxY: state.monthlyIncome * 1.2,
                  barTouchData: BarTouchData(enabled: false),
                  titlesData: FlTitlesData(
                    show: true,
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (value, meta) {
                          return Text(
                            value == 0 ? 'Income' : 'Expenses',
                            style: AppTextStyles.bodySmall,
                          );
                        },
                      ),
                    ),
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 40,
                        getTitlesWidget: (value, meta) {
                          return Text(
                            '\$${value.toInt()}',
                            style: AppTextStyles.bodySmall,
                          );
                        },
                      ),
                    ),
                    rightTitles: AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    topTitles: AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                  ),
                  borderData: FlBorderData(show: false),
                  gridData: FlGridData(show: false),
                  barGroups: [
                    BarChartGroupData(
                      x: 0,
                      barRods: [
                        BarChartRodData(
                          toY: state.monthlyIncome,
                          color: AppColors.textPrimaryLight,
                          width: 20,
                          borderRadius: const BorderRadius.vertical(
                            top: Radius.circular(4),
                          ),
                        ),
                      ],
                    ),
                    BarChartGroupData(
                      x: 1,
                      barRods: [
                        BarChartRodData(
                          toY: state.monthlyExpenses,
                          color: AppColors.textPrimaryLight,
                          width: 20,
                          borderRadius: const BorderRadius.vertical(
                            top: Radius.circular(4),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryBreakdown(StatsState state) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Category Breakdown', style: AppTextStyles.bodyMedium),
            const SizedBox(height: 16),
            SizedBox(
              height: 200,
              child: PieChart(
                PieChartData(
                  sections: _createPieChartSections(state),
                  sectionsSpace: 2,
                  centerSpaceRadius: 40,
                ),
              ),
            ),
            const SizedBox(height: 16),
            ...state.categoryBreakdown.entries.map(
              (entry) => Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(entry.key, style: AppTextStyles.bodyMedium),
                    Text(
                      '\$${entry.value.toStringAsFixed(2)}',
                      style: AppTextStyles.bodyMedium,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<PieChartSectionData> _createPieChartSections(StatsState state) {
    final colors = [
      AppColors.textPrimaryLight,
      AppColors.textPrimaryLight,
      AppColors.textPrimaryLight,
      AppColors.textPrimaryLight,
      AppColors.textPrimaryLight,
    ];

    return state.categoryBreakdown.entries.map((entry) {
      final index = state.categoryBreakdown.keys.toList().indexOf(entry.key);
      return PieChartSectionData(
        value: entry.value,
        title: '',
        color: colors[index % colors.length],
        radius: 100,
      );
    }).toList();
  }

  Widget _buildProgressOverview(StatsState state) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Progress Overview', style: AppTextStyles.bodyMedium),
            const SizedBox(height: 16),
            _buildProgressBar('Tax Goal', state.taxProgress),
            const SizedBox(height: 12),
            _buildProgressBar('Savings Goal', state.savingsProgress),
          ],
        ),
      ),
    );
  }

  Widget _buildProgressBar(String label, double progress) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: AppTextStyles.bodySmall),
        const SizedBox(height: 4),
        ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: LinearProgressIndicator(
            value: progress,
            backgroundColor: AppColors.primary200.withOpacity(0.2),
              valueColor: AlwaysStoppedAnimation<Color>(AppColors.textPrimaryLight),
            minHeight: 8,
          ),
        ),
      ],
    );
  }
} 