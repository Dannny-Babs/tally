import 'package:equatable/equatable.dart';
import '../models/transaction.dart';

class DashboardState extends Equatable {
  final double totalIncome;
  final double totalExpenses;
  final double totalSavings;
  final double totalGifts;
  final List<Transaction> recentTransactions;
  final String aiInsight;

  const DashboardState({
    this.totalIncome = 0.0,
    this.totalExpenses = 0.0,
    this.totalSavings = 0.0,
    this.totalGifts = 0.0,
    this.recentTransactions = const [],
    this.aiInsight = '',
  });

  @override
  List<Object> get props => [
        totalIncome,
        totalExpenses,
        totalSavings,
        totalGifts,
        recentTransactions,
        aiInsight,
      ];

  DashboardState copyWith({
    double? totalIncome,
    double? totalExpenses,
    double? totalSavings,
    double? totalGifts,
    List<Transaction>? recentTransactions,
    String? aiInsight,
  }) {
    return DashboardState(
      totalIncome: totalIncome ?? this.totalIncome,
      totalExpenses: totalExpenses ?? this.totalExpenses,
      totalSavings: totalSavings ?? this.totalSavings,
      totalGifts: totalGifts ?? this.totalGifts,
      recentTransactions: recentTransactions ?? this.recentTransactions,
      aiInsight: aiInsight ?? this.aiInsight,
    );
  }
} 