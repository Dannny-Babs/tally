import 'package:flutter_bloc/flutter_bloc.dart';
import 'transaction_event.dart';
import 'transaction_state.dart';
import '../../models/transaction_model.dart';
import '../../repositories/income_repository.dart';
import '../../repositories/expense_repository.dart';

class TransactionBloc extends Bloc<TransactionEvent, TransactionState> {
  static const int _pageSize = 10;
  int _currentPage = 1;
  final IncomeRepository _incomeRepository;
  final ExpenseRepository _expenseRepository;

  TransactionBloc({
    IncomeRepository? incomeRepository,
    ExpenseRepository? expenseRepository,
  }) : _incomeRepository = incomeRepository ?? IncomeRepository(),
       _expenseRepository = expenseRepository ?? ExpenseRepository(),
       super(TransactionInitial()) {
    on<IncomeLoaded>(_onIncomeLoaded);
    on<ExpensesLoaded>(_onExpensesLoaded);
    on<TransactionLoadMore>(_onTransactionLoadMore);
    on<AddIncomeSubmitted>(_onAddIncomeSubmitted);
    on<AddExpenseSubmitted>(_onAddExpenseSubmitted);
    on<DateFilterChanged>((event, emit) => _onDateFilterChanged(event, emit));
  }

  Future<void> _onIncomeLoaded(
    IncomeLoaded event,
    Emitter<TransactionState> emit,
  ) async {
    emit(TransactionLoading());
    _currentPage = 1;

    try {
      final transactions = await _incomeRepository.fetchIncomes();
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
      emit(TransactionError('Failed to load income data: ${e.toString()}'));
    }
  }

  Future<void> _onExpensesLoaded(
    ExpensesLoaded event,
    Emitter<TransactionState> emit,
  ) async {
    emit(TransactionLoading());
    _currentPage = 1;

    try {
      final transactions = await _expenseRepository.fetchExpenses();
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
      emit(TransactionError('Failed to load expenses data: ${e.toString()}'));
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
        final isIncome = currentState.transactions.first.isIncome;
        final repository = isIncome ? _incomeRepository : _expenseRepository;
        final allTransactions = isIncome 
            ? await _incomeRepository.fetchIncomes()
            : await _expenseRepository.fetchExpenses();
        
        final newTransactions = allTransactions
            .skip(_currentPage * _pageSize)
            .take(_pageSize)
            .toList();

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
        emit(TransactionError('Failed to load more transactions: ${e.toString()}'));
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
        final newTransaction = Transaction(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          source: event.source,
          description: event.source,
          payeeName: event.payee,
          amount: event.amount,
          date: '${event.date.day}/${event.date.month}/${event.date.year}',
          time: '${event.time.hour.toString().padLeft(2, '0')}:${event.time.minute.toString().padLeft(2, '0')}',
          isIncome: true,
          category: event.category,
          notes: event.notes,
        );

        await _incomeRepository.addIncome(newTransaction);
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
        emit(TransactionError('Failed to add income: ${e.toString()}'));
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
        final newTransaction = Transaction(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          source: event.category,
          description: event.description,
          amount: event.amount,
          date: '${event.date.day}/${event.date.month}/${event.date.year}',
          time: '${event.time.hour.toString().padLeft(2, '0')}:${event.time.minute.toString().padLeft(2, '0')}',
          isIncome: false,
          category: event.category,
          mood: Mood.neutral,
          notes: event.notes,
          paymentMethod: event.paymentMethod,
        );

        await _expenseRepository.addExpense(newTransaction);
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
        emit(TransactionError('Failed to add expense: ${e.toString()}'));
      }
    }
  }

  Future<void> _onDateFilterChanged(
    DateFilterChanged event,
    Emitter<TransactionState> emit,
  ) async {
    emit(TransactionLoading());

    try {
      final isIncome = state is TransactionLoaded 
          ? (state as TransactionLoaded).transactions.first.isIncome
          : true;
      
      final repository = isIncome ? _incomeRepository : _expenseRepository;
      final transactions = isIncome 
          ? await _incomeRepository.fetchIncomes()
          : await _expenseRepository.fetchExpenses();
      
      final filteredTransactions = transactions.where((t) {
        final transactionDate = DateTime.parse(t.date);
        return transactionDate.isAfter(event.startDate) && 
               transactionDate.isBefore(event.endDate.add(const Duration(days: 1)));
      }).toList();

      final totalAmount = filteredTransactions.fold<double>(
        0,
        (sum, transaction) => sum + transaction.amount,
      );
      final categoryTotals = _calculateCategoryTotals(filteredTransactions);

      if (filteredTransactions.isEmpty) {
        emit(TransactionEmpty());
      } else {
        emit(
          TransactionLoaded(
            transactions: filteredTransactions,
            totalAmount: totalAmount,
            categoryTotals: categoryTotals,
            hasReachedMax: true,
          ),
        );
      }
    } catch (e) {
      emit(TransactionError('Failed to filter transactions: ${e.toString()}'));
    }
  }

  Map<String, double> _calculateCategoryTotals(List<Transaction> transactions) {
    final Map<String, double> totals = {};
    for (final transaction in transactions) {
      if (transaction.category.isEmpty) {
        continue;
      }
      totals[transaction.category] = (totals[transaction.category] ?? 0) + transaction.amount;
    }
    return totals;
  }
}
