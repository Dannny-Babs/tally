import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

// Events
abstract class TransactionEvent extends Equatable {
  const TransactionEvent();

  @override
  List<Object> get props => [];
}

class IncomeLoaded extends TransactionEvent {}

class TransactionAdded extends TransactionEvent {
  final Transaction transaction;

  const TransactionAdded(this.transaction);

  @override
  List<Object> get props => [transaction];
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

  const TransactionLoaded(this.transactions);

  @override
  List<Object> get props => [transactions];
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
  List<Object> get props => [id, source, description, amount, date, time, isIncome];
}

// Bloc
class TransactionBloc extends Bloc<TransactionEvent, TransactionState> {
  TransactionBloc() : super(TransactionInitial()) {
    on<IncomeLoaded>(_onIncomeLoaded);
    on<TransactionAdded>(_onTransactionAdded);
  }

  Future<void> _onIncomeLoaded(
    IncomeLoaded event,
    Emitter<TransactionState> emit,
  ) async {
    emit(TransactionLoading());

    try {
      // TODO: Replace with actual API call
      await Future.delayed(const Duration(seconds: 1));
      
      final transactions = [
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
      ];

      if (transactions.isEmpty) {
        emit(TransactionEmpty());
      } else {
        emit(TransactionLoaded(transactions));
      }
    } catch (e) {
      emit(TransactionError('Failed to load income data'));
    }
  }

  void _onTransactionAdded(
    TransactionAdded event,
    Emitter<TransactionState> emit,
  ) {
    if (state is TransactionLoaded) {
      final currentState = state as TransactionLoaded;
      final updatedTransactions = List<Transaction>.from(currentState.transactions)
        ..add(event.transaction);
      emit(TransactionLoaded(updatedTransactions));
    }
  }
} 