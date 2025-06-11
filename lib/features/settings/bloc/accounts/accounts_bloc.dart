import 'package:flutter_bloc/flutter_bloc.dart';
import 'accounts_event.dart';
import 'accounts_state.dart';
import '../../repositories/accounts_repository.dart';

class AccountsBloc extends Bloc<AccountsEvent, AccountsState> {
  final AccountsRepository _repository;

  AccountsBloc(this._repository) : super(const AccountsState()) {
    on<SavingsAccountAdded>(_onSavingsAccountAdded);
    on<SavingsAccountUpdated>(_onSavingsAccountUpdated);
    on<SavingsAccountDeleted>(_onSavingsAccountDeleted);
  }

  Future<void> _onSavingsAccountAdded(
    SavingsAccountAdded event,
    Emitter<AccountsState> emit,
  ) async {
    await _repository.addSavingsAccount(event.account);
    final accounts = _repository.savingsAccounts;
    emit(state.copyWith(savingsAccounts: accounts));
  }

  Future<void> _onSavingsAccountUpdated(
    SavingsAccountUpdated event,
    Emitter<AccountsState> emit,
  ) async {
    await _repository.updateSavingsAccount(event.account);
    final accounts = _repository.savingsAccounts;
    emit(state.copyWith(savingsAccounts: accounts));
  }

  Future<void> _onSavingsAccountDeleted(
    SavingsAccountDeleted event,
    Emitter<AccountsState> emit,
  ) async {
    await _repository.deleteSavingsAccount(event.id);
    final accounts = _repository.savingsAccounts;
    emit(state.copyWith(savingsAccounts: accounts));
  }
} 