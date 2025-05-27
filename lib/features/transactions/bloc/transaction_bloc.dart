import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'transaction_event.dart';
import 'transaction_state.dart';
import 'mock_transactions.dart';
import 'transaction_model.dart';

// Helper to convert mock transactions to real Transaction objects with unique IDs
List<Transaction> _mockToTransactions(List<MockTransaction> mocks) {
  int idCounter = 1;
  return mocks.map((m) => m.toTransaction('mock_${idCounter++}')).toList();
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

      final transactions = _mockToTransactions(mockTransactions.where((t) => t.isIncome).toList());
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

      final transactions = _mockToTransactions(mockTransactions.where((t) => !t.isIncome).toList());
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

        final newTransactions = _mockToTransactions(mockTransactions.skip(_currentPage * _pageSize).take(_pageSize).toList());

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
