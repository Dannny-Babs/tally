import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

// Events
abstract class AccountsEvent extends Equatable {
  @override
  List<Object?> get props => [];
}
class SavingsTapped extends AccountsEvent {}
class GiftsTapped extends AccountsEvent {}

// State
class AccountsState extends Equatable {
  final int savingsCount;
  const AccountsState({required this.savingsCount});
  @override
  List<Object?> get props => [savingsCount];
}

// Bloc
class AccountsBloc extends Bloc<AccountsEvent, AccountsState> {
  AccountsBloc() : super(const AccountsState(savingsCount: 3)) {
    on<SavingsTapped>((event, emit) {
      // Navigation or logic can be handled here
    });
    on<GiftsTapped>((event, emit) {
      // Navigation or logic can be handled here
    });
  }
} 