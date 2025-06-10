import 'package:equatable/equatable.dart';
import '../../models/payback.dart';

abstract class PaybacksEvent extends Equatable {
  const PaybacksEvent();
  @override
  List<Object?> get props => [];
}

class LoadPaybacks extends PaybacksEvent {}

class AddPayback extends PaybacksEvent {
  final Payback payback;
  const AddPayback(this.payback);
  @override
  List<Object?> get props => [payback];
}

class UpdatePayback extends PaybacksEvent {
  final Payback payback;
  const UpdatePayback(this.payback);
  @override
  List<Object?> get props => [payback];
}

class DeletePayback extends PaybacksEvent {
  final String id;
  const DeletePayback(this.id);
  @override
  List<Object?> get props => [id];
}

class SwitchPaybacksTab extends PaybacksEvent {
  final String tab; // "personal", "credit", "debt"
  const SwitchPaybacksTab(this.tab);
  @override
  List<Object?> get props => [tab];
} 