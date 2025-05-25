import 'package:equatable/equatable.dart';

class StatsState extends Equatable {
  final double monthlyIncome;
  final double monthlyExpenses;
  final Map<String, double> categoryBreakdown;
  final double taxProgress;
  final double savingsProgress;

  const StatsState({
    this.monthlyIncome = 0.0,
    this.monthlyExpenses = 0.0,
    this.categoryBreakdown = const {},
    this.taxProgress = 0.0,
    this.savingsProgress = 0.0,
  });

  @override
  List<Object> get props => [
        monthlyIncome,
        monthlyExpenses,
        categoryBreakdown,
        taxProgress,
        savingsProgress,
      ];

  StatsState copyWith({
    double? monthlyIncome,
    double? monthlyExpenses,
    Map<String, double>? categoryBreakdown,
    double? taxProgress,
    double? savingsProgress,
  }) {
    return StatsState(
      monthlyIncome: monthlyIncome ?? this.monthlyIncome,
      monthlyExpenses: monthlyExpenses ?? this.monthlyExpenses,
      categoryBreakdown: categoryBreakdown ?? this.categoryBreakdown,
      taxProgress: taxProgress ?? this.taxProgress,
      savingsProgress: savingsProgress ?? this.savingsProgress,
    );
  }
} 