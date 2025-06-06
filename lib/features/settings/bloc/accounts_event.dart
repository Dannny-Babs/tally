import 'package:equatable/equatable.dart';

abstract class AccountsEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class SavingsTapped extends AccountsEvent {}
class GiftsTapped extends AccountsEvent {} 