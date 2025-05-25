import 'package:flutter_bloc/flutter_bloc.dart';

// Events
abstract class TransactionEvent {}

class LoadTransactions extends TransactionEvent {}

// States
abstract class TransactionState {}

class TransactionInitial extends TransactionState {}
class TransactionLoading extends TransactionState {}
class TransactionsLoaded extends TransactionState {}
class TransactionError extends TransactionState {
  final String message;
  TransactionError(this.message);
}

// Bloc
class TransactionBloc extends Bloc<TransactionEvent, TransactionState> {
  TransactionBloc() : super(TransactionInitial()) {
    on<LoadTransactions>((event, emit) async {
      emit(TransactionLoading());
      try {
        // TODO: Implement transaction loading logic
        emit(TransactionsLoaded());
      } catch (e) {
        emit(TransactionError(e.toString()));
      }
    });
  }
} 