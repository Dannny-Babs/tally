import 'package:equatable/equatable.dart';

abstract class AccountsEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class SavingsTapped extends AccountsEvent {}
class GiftsTapped extends AccountsEvent {}
class SavingsSelected extends AccountsEvent {
  final String accountId;
  SavingsSelected(this.accountId);
  @override
  List<Object?> get props => [accountId];
}
class CreateSavingsRequested extends AccountsEvent {}
class GiftSelected extends AccountsEvent {
  final String giftId;
  GiftSelected(this.giftId);
  @override
  List<Object?> get props => [giftId];
}
class AddGiftRequested extends AccountsEvent {} 