import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'transaction_event.dart';
import 'transaction_state.dart';

// Events
abstract class TransactionEvent extends Equatable {
  const TransactionEvent();

  @override
  List<Object> get props => [];
}

class IncomeLoaded extends TransactionEvent {}

class ExpensesLoaded extends TransactionEvent {}

class TransactionLoadMore extends TransactionEvent {}

class AddIncomeSubmitted extends TransactionEvent {
  final double amount;
  final String source;
  final String description;
  final DateTime date;
  final TimeOfDay time;
  final List<String> categories;
  final String? notes;

  const AddIncomeSubmitted({
    required this.amount,
    required this.source,
    required this.description,
    required this.date,
    required this.time,
    required this.categories,
    this.notes,
  });

  @override
  List<Object> get props => [amount, source, description, date, time, categories, notes ?? ''];
}

class AddExpenseSubmitted extends TransactionEvent {
  final double amount;
  final String category;
  final String description;
  final DateTime date;
  final TimeOfDay time;
  final List<String> tags;
  final String? notes;
  final String paymentMethod;

  const AddExpenseSubmitted({
    required this.amount,
    required this.category,
    required this.description,
    required this.date,
    required this.time,
    required this.tags,
    this.notes,
    required this.paymentMethod,
  });

  @override
  List<Object> get props => [amount, category, description, date, time, tags, notes ?? '', paymentMethod];
}

// States
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

// Model
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
    required this.isIncome,
    required this.categories,
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

// Bloc
class TransactionBloc extends Bloc<TransactionEvent, TransactionState> {
  static const int _pageSize = 10;
  int _currentPage = 1;

  TransactionBloc() : super(TransactionInitial()) {
    on<IncomeLoaded>(_onIncomeLoaded);
    on<ExpensesLoaded>(_onExpensesLoaded);
    on<TransactionLoadMore>(_onTransactionLoadMore);
    on<AddIncomeSubmitted>(_onAddIncomeSubmitted);
    on<AddExpenseSubmitted>(_onAddExpenseSubmitted);
  }

  Future<void> _onIncomeLoaded(
    IncomeLoaded event,
    Emitter<TransactionState> emit,
  ) async {
    emit(TransactionLoading());
    _currentPage = 1;

    try {
      // TODO: Replace with actual API call
      await Future.delayed(const Duration(seconds: 1));

      final transactions = _getMockTransactions(page: 1, isIncome: true);
      final totalAmount = transactions.fold<double>(
        0,
        (sum, transaction) => sum + transaction.amount,
      );
      final categoryTotals = _calculateCategoryTotals(transactions);

      if (transactions.isEmpty) {
        emit(TransactionEmpty());
      } else {
        emit(
          TransactionLoaded(
            transactions: transactions,
            totalAmount: totalAmount,
            categoryTotals: categoryTotals,
            hasReachedMax: transactions.length < _pageSize,
          ),
        );
      }
    } catch (e) {
      emit(TransactionError('Failed to load income data'));
    }
  }

  Future<void> _onExpensesLoaded(
    ExpensesLoaded event,
    Emitter<TransactionState> emit,
  ) async {
    emit(TransactionLoading());
    _currentPage = 1;

    try {
      // TODO: Replace with actual API call
      await Future.delayed(const Duration(seconds: 1));

      final transactions = _getMockTransactions(page: 1, isIncome: false);
      final totalAmount = transactions.fold<double>(
        0,
        (sum, transaction) => sum + transaction.amount,
      );
      final categoryTotals = _calculateCategoryTotals(transactions);

      if (transactions.isEmpty) {
        emit(TransactionEmpty());
      } else {
        emit(
          TransactionLoaded(
            transactions: transactions,
            totalAmount: totalAmount,
            categoryTotals: categoryTotals,
            hasReachedMax: transactions.length < _pageSize,
          ),
        );
      }
    } catch (e) {
      emit(TransactionError('Failed to load expenses data'));
    }
  }

  Future<void> _onTransactionLoadMore(
    TransactionLoadMore event,
    Emitter<TransactionState> emit,
  ) async {
    if (state is TransactionLoaded) {
      final currentState = state as TransactionLoaded;

      if (currentState.hasReachedMax) {
        return;
      }

      try {
        // TODO: Replace with actual API call
        await Future.delayed(const Duration(seconds: 1));

        final newTransactions = _getMockTransactions(
          page: _currentPage + 1,
          isIncome: currentState.transactions.first.isIncome,
        );

        if (newTransactions.isEmpty) {
          emit(currentState.copyWith(hasReachedMax: true));
        } else {
          _currentPage++;
          final updatedTransactions = [
            ...currentState.transactions,
            ...newTransactions,
          ];
          final totalAmount = updatedTransactions.fold<double>(
            0,
            (sum, transaction) => sum + transaction.amount,
          );
          final categoryTotals = _calculateCategoryTotals(updatedTransactions);

          emit(
            currentState.copyWith(
              transactions: updatedTransactions,
              totalAmount: totalAmount,
              categoryTotals: categoryTotals,
              hasReachedMax: newTransactions.length < _pageSize,
            ),
          );
        }
      } catch (e) {
        // Don't emit error state, just keep current state
      }
    }
  }

  Future<void> _onAddIncomeSubmitted(
    AddIncomeSubmitted event,
    Emitter<TransactionState> emit,
  ) async {
    if (state is TransactionLoaded) {
      final currentState = state as TransactionLoaded;

      try {
        // TODO: Replace with actual API call
        await Future.delayed(const Duration(seconds: 1));

        final newTransaction = Transaction(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          source: event.source,
          description: event.description,
          amount: event.amount,
          date: '${event.date.day}/${event.date.month}/${event.date.year}',
          time: '${event.time.hour.toString().padLeft(2, '0')}:${event.time.minute.toString().padLeft(2, '0')}',
          isIncome: true,
          categories: event.categories,
          notes: event.notes,
        );

        final updatedTransactions = [newTransaction, ...currentState.transactions];
        final totalAmount = updatedTransactions.fold<double>(
          0,
          (sum, transaction) => sum + transaction.amount,
        );
        final categoryTotals = _calculateCategoryTotals(updatedTransactions);

        emit(currentState.copyWith(
          transactions: updatedTransactions,
          totalAmount: totalAmount,
          categoryTotals: categoryTotals,
        ));
      } catch (e) {
        // Don't emit error state, just keep current state
      }
    }
  }

  Future<void> _onAddExpenseSubmitted(
    AddExpenseSubmitted event,
    Emitter<TransactionState> emit,
  ) async {
    if (state is TransactionLoaded) {
      final currentState = state as TransactionLoaded;

      try {
        // TODO: Replace with actual API call
        await Future.delayed(const Duration(seconds: 1));

        final newTransaction = Transaction(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          source: event.category,
          description: event.description,
          amount: event.amount,
          date: '${event.date.day}/${event.date.month}/${event.date.year}',
          time: '${event.time.hour.toString().padLeft(2, '0')}:${event.time.minute.toString().padLeft(2, '0')}',
          isIncome: false,
          categories: event.tags,
          notes: event.notes,
          paymentMethod: event.paymentMethod,
        );

        final updatedTransactions = [newTransaction, ...currentState.transactions];
        final totalAmount = updatedTransactions.fold<double>(
          0,
          (sum, transaction) => sum + transaction.amount,
        );
        final categoryTotals = _calculateCategoryTotals(updatedTransactions);

        emit(currentState.copyWith(
          transactions: updatedTransactions,
          totalAmount: totalAmount,
          categoryTotals: categoryTotals,
        ));
      } catch (e) {
        // Don't emit error state, just keep current state
      }
    }
  }

  List<Transaction> _getMockTransactions({
    required int page,
    required bool isIncome,
  }) {
    if (page > 2) return []; // Only 2 pages of mock data

    if (isIncome) {
      return [
        Transaction(
          id: '1',
          source: 'Freelance',
          description: 'Halo Inc',
          amount: 850,
          date: 'Mar 15',
          time: '2:30 PM',
          isIncome: true,
          categories: ['Work'],
        ),
        Transaction(
          id: '2',
          source: 'Job',
          description: 'Monthly Salary',
          amount: 1400,
          date: 'Mar 1',
          time: '9:00 AM',
          isIncome: true,
          categories: ['Salary'],
        ),
      ];
    } else {
      return [
        Transaction(
          id: '3',
          source: 'Food & Dining',
          description: 'Grocery Shopping',
          amount: 120,
          date: 'Mar 15',
          time: '3:45 PM',
          isIncome: false,
          categories: ['Necessary'],
          paymentMethod: 'Credit Card',
        ),
        Transaction(
          id: '4',
          source: 'Transportation',
          description: 'Gas',
          amount: 50,
          date: 'Mar 14',
          time: '10:00 AM',
          isIncome: false,
          categories: ['Necessary'],
          paymentMethod: 'Cash',
        ),
      ];
    }
  }

  Map<String, double> _calculateCategoryTotals(List<Transaction> transactions) {
    final categoryTotals = <String, double>{};
    for (final transaction in transactions) {
      for (final category in transaction.categories) {
        categoryTotals[category] = (categoryTotals[category] ?? 0) + transaction.amount;
      }
    }
    return categoryTotals;
  }
}
