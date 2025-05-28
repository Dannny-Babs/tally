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
  final Map<String, double> categoryTotals;
  final double totalAmount;
  final bool hasReachedMax;

  const TransactionLoaded({
    required this.transactions,
    required this.categoryTotals,
    required this.totalAmount,
    required this.hasReachedMax,
  });

  TransactionLoaded copyWith({
    List<Transaction>? transactions,
    Map<String, double>? categoryTotals,
    double? totalAmount,
    bool? hasReachedMax,
  }) {
    return TransactionLoaded(
      transactions: transactions ?? this.transactions,
      categoryTotals: categoryTotals ?? this.categoryTotals,
      totalAmount: totalAmount ?? this.totalAmount,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
    );
  }

  @override
  List<Object> get props => [transactions, categoryTotals, totalAmount, hasReachedMax];
}

class TransactionError extends TransactionState {
  final String message;

  const TransactionError(this.message);

  @override
  List<Object> get props => [message];
} 