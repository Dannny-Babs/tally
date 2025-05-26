import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

// Events
abstract class TransactionEvent extends Equatable {
  const TransactionEvent();

  @override
  List<Object> get props => [];
}

class IncomeLoaded extends TransactionEvent {}

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
  final bool hasReachedMax;

  const TransactionLoaded({
    required this.transactions,
    this.hasReachedMax = false,
  });

  TransactionLoaded copyWith({
    List<Transaction>? transactions,
    bool? hasReachedMax,
  }) {
    return TransactionLoaded(
      transactions: transactions ?? this.transactions,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
    );
  }

  @override
  List<Object> get props => [transactions, hasReachedMax];
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

  const Transaction({
    required this.id,
    required this.source,
    required this.description,
    required this.amount,
    required this.date,
    required this.time,
    this.isIncome = false,
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
  ];
}

// Bloc
class TransactionBloc extends Bloc<TransactionEvent, TransactionState> {
  static const int _pageSize = 10;
  int _currentPage = 1;

  TransactionBloc() : super(TransactionInitial()) {
    on<IncomeLoaded>(_onIncomeLoaded);
    on<TransactionLoadMore>(_onTransactionLoadMore);
    on<AddIncomeSubmitted>(_onAddIncomeSubmitted);
  }

  Future<void> _onIncomeLoaded(
    IncomeLoaded event,
    Emitter<TransactionState> emit,
  ) async {
    print('Loading income data...'); // Debug print
    emit(TransactionLoading());
    _currentPage = 1;

    try {
      // TODO: Replace with actual API call
      await Future.delayed(const Duration(seconds: 1));

      final transactions = _getMockTransactions(page: 1);
      print('Loaded ${transactions.length} transactions'); // Debug print

      if (transactions.isEmpty) {
        emit(TransactionEmpty());
      } else {
        emit(
          TransactionLoaded(
            transactions: transactions,
            hasReachedMax: transactions.length < _pageSize,
          ),
        );
      }
    } catch (e) {
      print('Error loading income: $e'); // Debug print
      emit(TransactionError('Failed to load income data'));
    }
  }

  Future<void> _onTransactionLoadMore(
    TransactionLoadMore event,
    Emitter<TransactionState> emit,
  ) async {
    if (state is TransactionLoaded) {
      final currentState = state as TransactionLoaded;

      if (currentState.hasReachedMax) {
        print('Already reached max'); // Debug print
        return;
      }

      try {
        print('Loading more transactions...'); // Debug print
        // TODO: Replace with actual API call
        await Future.delayed(const Duration(seconds: 1));

        final newTransactions = _getMockTransactions(page: _currentPage + 1);
        print(
          'Loaded ${newTransactions.length} more transactions',
        ); // Debug print

        if (newTransactions.isEmpty) {
          emit(currentState.copyWith(hasReachedMax: true));
        } else {
          _currentPage++;
          emit(
            currentState.copyWith(
              transactions: [...currentState.transactions, ...newTransactions],
              hasReachedMax: newTransactions.length < _pageSize,
            ),
          );
        }
      } catch (e) {
        print('Error loading more: $e'); // Debug print
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
        );

        emit(currentState.copyWith(
          transactions: [newTransaction, ...currentState.transactions],
        ));
      } catch (e) {
        // Don't emit error state, just keep current state
      }
    }
  }

  List<Transaction> _getMockTransactions({required int page}) {
    print('Getting mock transactions for page $page'); // Debug print
    // Simulate pagination with mock data
    if (page > 2) return []; // Only 2 pages of mock data

    final baseTransactions = [
      Transaction(
        id: '1',
        source: 'Freelance',
        description: 'Halo Inc',
        amount: 850,
        date: 'Mar 15',
        time: '2:30 PM',
        isIncome: true,
      ),
      Transaction(
        id: '2',
        source: 'Job',
        description: 'Monthly Salary',
        amount: 1400,
        date: 'Mar 1',
        time: '9:00 AM',
        isIncome: true,
      ),
      Transaction(
        id: '3',
        source: 'Freelance',
        description: 'Tech Corp',
        amount: 1200,
        date: 'Feb 28',
        time: '3:45 PM',
        isIncome: true,
      ),
      Transaction(
        id: '4',
        source: 'Job',
        description: 'Bonus',
        amount: 500,
        date: 'Feb 15',
        time: '10:00 AM',
        isIncome: true,
      ),
      Transaction(
        id: '5',
        source: 'Freelance',
        description: 'Design Co',
        amount: 1500,
        date: 'Jan 30',
        time: '11:30 AM',
        isIncome: true,
      ),
      Transaction(
        id: '6',
        source: 'Job',
        description: 'Commission',
        amount: 200,
        date: 'Jan 10',
        time: '4:00 PM',
        isIncome: true,
      ),
      Transaction(
        id: '7',
        source: 'Freelance',
        description: 'Marketing',
        amount: 1000,
        date: 'Dec 20',
        time: '1:00 PM',
        isIncome: true,
      ),
      Transaction(
        id: '8',
        source: 'Job',
        description: 'Bonus',
        amount: 500,
        date: 'Dec 15',
        time: '2:00 PM',
        isIncome: true,
      ),
      Transaction(
        id: '9',
        source: 'Freelance',
        description: 'Design Co',
        amount: 1500,
        date: 'Nov 30',
        time: '11:30 AM',
        isIncome: true,
      ),
      Transaction(
        id: '10',
        source: 'Job',
        description: 'Commission',
        amount: 200,
        date: 'Nov 10',
        time: '4:00 PM',
        isIncome: true,
      ),
      Transaction(
        id: '11',
        source: 'Freelance',
        description: 'Marketing',
        amount: 1000,
        date: 'Oct 20',
        time: '1:00 PM',
        isIncome: true,
      ),
      Transaction(
        id: '12',
        source: 'Job',
        description: 'Bonus',
        amount: 500,
        date: 'Oct 15',
        time: '2:00 PM',
        isIncome: true,
      ),
    ];

    // Simulate different data for page 2
    if (page == 2) {
      return [
        Transaction(
          id: '3',
          source: 'Freelance',
          description: 'Tech Corp',
          amount: 1200,
          date: 'Feb 28',
          time: '3:45 PM',
          isIncome: true,
        ),
        Transaction(
          id: '4',
          source: 'Job',
          description: 'Bonus',
          amount: 500,
          date: 'Feb 15',
          time: '10:00 AM',
          isIncome: true,
        ),
      ];
    }

    return baseTransactions;
  }
}
