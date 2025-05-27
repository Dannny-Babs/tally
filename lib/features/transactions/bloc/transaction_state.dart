import 'package:equatable/equatable.dart';
import 'transaction_model.dart';

abstract class TransactionState extends Equatable {
  const TransactionState();

  @override
  List<Object> get props => [];
}

class TransactionInitial extends TransactionState {}

class TransactionLoading extends TransactionState {}

class TransactionEmpty extends TransactionState {}

class TransactionLoaded extends TransactionState {
  final List<Transaction> transactions;
  final double totalAmount;
  final Map<String, double> categoryTotals;
  final bool hasReachedMax;

  const TransactionLoaded({
    required this.transactions,
    required this.totalAmount,
    required this.categoryTotals,
    this.hasReachedMax = false,
  });

  TransactionLoaded copyWith({
    List<Transaction>? transactions,
    double? totalAmount,
    Map<String, double>? categoryTotals,
    bool? hasReachedMax,
  }) {
    return TransactionLoaded(
      transactions: transactions ?? this.transactions,
      totalAmount: totalAmount ?? this.totalAmount,
      categoryTotals: categoryTotals ?? this.categoryTotals,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
    );
  }

  @override
  List<Object> get props => [transactions, totalAmount, categoryTotals, hasReachedMax];
}

class TransactionError extends TransactionState {
  final String message;

  const TransactionError(this.message);

  @override
  List<Object> get props => [message];
} 