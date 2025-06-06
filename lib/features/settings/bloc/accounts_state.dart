import 'package:equatable/equatable.dart';

class AccountsState extends Equatable {
  final int savingsCount;
  const AccountsState({required this.savingsCount});
  @override
  List<Object?> get props => [savingsCount];
} 