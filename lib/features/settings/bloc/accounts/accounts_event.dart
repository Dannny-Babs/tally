import 'package:equatable/equatable.dart';
import 'accounts_state.dart';

abstract class AccountsEvent extends Equatable {
  const AccountsEvent();

  @override
  List<Object?> get props => [];
}

class AccountsLoaded extends AccountsEvent {}

class SavingsSelected extends AccountsEvent {
  final String id;
  const SavingsSelected(this.id);

  @override
  List<Object?> get props => [id];
}

class CreateSavingsRequested extends AccountsEvent {}

class SavingsAccountAdded extends AccountsEvent {
  final SavingsAccount account;
  const SavingsAccountAdded(this.account);

  @override
  List<Object?> get props => [account];
}

class SavingsAccountUpdated extends AccountsEvent {
  final SavingsAccount account;
  const SavingsAccountUpdated(this.account);

  @override
  List<Object?> get props => [account];
}

class SavingsAccountDeleted extends AccountsEvent {
  final String id;
  const SavingsAccountDeleted(this.id);

  @override
  List<Object?> get props => [id];
} 