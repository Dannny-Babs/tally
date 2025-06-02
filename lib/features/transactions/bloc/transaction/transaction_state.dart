import 'package:equatable/equatable.dart';
import 'package:tally/features/transactions/models/transaction_model.dart';


abstract class TransactionState extends Equatable {
  const TransactionState();

  List<Transaction> get transactions => [];

  @override
  List<Object> get props => [];
}

class TransactionInitial extends TransactionState {}

class TransactionLoading extends TransactionState {}

class TransactionEmpty extends TransactionState {}

class TransactionLoaded extends TransactionState {
  final List<Transaction> _transactions;
  final Map<String, double> categoryTotals;
  final double totalAmount;
  final bool hasReachedMax;

  const TransactionLoaded({
    required List<Transaction> transactions,
    required this.categoryTotals,
    required this.totalAmount,
    required this.hasReachedMax,
  }) : _transactions = transactions;

  @override
  List<Transaction> get transactions => _transactions;

  TransactionLoaded copyWith({
    List<Transaction>? transactions,
    Map<String, double>? categoryTotals,
    double? totalAmount,
    bool? hasReachedMax,
  }) {
    return TransactionLoaded(
      transactions: transactions ?? _transactions,
      categoryTotals: categoryTotals ?? this.categoryTotals,
      totalAmount: totalAmount ?? this.totalAmount,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
    );
  }

  @override
  List<Object> get props => [_transactions, categoryTotals, totalAmount, hasReachedMax, ];
}

class TransactionError extends TransactionState {
  final String message;

  const TransactionError(this.message);

  @override
  List<Object> get props => [message];
} 