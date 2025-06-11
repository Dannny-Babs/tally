import 'package:equatable/equatable.dart';

class AccountsState extends Equatable {
  final List<SavingsAccount> savingsAccounts;
  final String? error;
  final bool loading;

  const AccountsState({
    this.savingsAccounts = const [],
    this.error,
    this.loading = false,
  });

  int get savingsCount => savingsAccounts.length;

  AccountsState copyWith({
    List<SavingsAccount>? savingsAccounts,
    String? error,
    bool? loading,
  }) {
    return AccountsState(
      savingsAccounts: savingsAccounts ?? this.savingsAccounts,
      error: error,
      loading: loading ?? this.loading,
    );
  }

  @override
  List<Object?> get props => [savingsAccounts, error, loading];
}

class SavingsAccount {
  final String id;
  final String name;
  final double balance;

  const SavingsAccount({
    required this.id,
    required this.name,
    required this.balance,
  });
} 