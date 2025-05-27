import 'package:equatable/equatable.dart';

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
  final bool hasReachedMax;
  final double totalAmount;
  final Map<String, double> categoryTotals;

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

class Transaction extends Equatable {
  final String id;
  final String source;
  final String description;
  final double amount;
  final String date;
  final String time;
  final bool isIncome;
  final List<String> categories;
  final String? notes;
  final String? paymentMethod;

  const Transaction({
    required this.id,
    required this.source,
    required this.description,
    required this.amount,
    required this.date,
    required this.time,
    this.isIncome = false,
    this.categories = const [],
    this.notes,
    this.paymentMethod,
  });

  @override
  List<Object> get props => [
    id,
    source,
    description,
    amount,
    date,
    time,
    isIncome,
    categories,
    notes ?? '',
    paymentMethod ?? '',
  ];
} 