import 'package:equatable/equatable.dart';

class SavingsAccount extends Equatable {
  final String id;
  final String name;
  final double balance;
  const SavingsAccount({required this.id, required this.name, required this.balance});
  @override
  List<Object?> get props => [id, name, balance];
}

class Gift extends Equatable {
  final String id;
  final String name;
  final double amount;
  final String dateFormatted;
  const Gift({required this.id, required this.name, required this.amount, required this.dateFormatted});
  @override
  List<Object?> get props => [id, name, amount, dateFormatted];
}

class AccountsState extends Equatable {
  final int savingsCount;
  final List<SavingsAccount> savingsList;
  final List<Gift> giftsList;
  const AccountsState({
    required this.savingsCount,
    required this.savingsList,
    required this.giftsList,
  });
  @override
  List<Object?> get props => [savingsCount, savingsList, giftsList];
} 