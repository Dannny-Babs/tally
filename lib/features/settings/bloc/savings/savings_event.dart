import 'package:equatable/equatable.dart';

abstract class SavingsEvent extends Equatable {
  const SavingsEvent();

  @override
  List<Object?> get props => [];
}

class LoadSavings extends SavingsEvent {
  const LoadSavings();
}

class AddSavingsGoalSubmitted extends SavingsEvent {
  final String name;
  final double targetAmount;
  final DateTime targetDate;
  final double initialContribution;
  final String? notes;

  const AddSavingsGoalSubmitted({
    required this.name,
    required this.targetAmount,
    required this.targetDate,
    this.initialContribution = 0,
    this.notes,
  });

  @override
  List<Object?> get props => [
        name,
        targetAmount,
        targetDate,
        initialContribution,
        notes,
      ];
}

class UpdateSavingsGoalSubmitted extends SavingsEvent {
  final String id;
  final String name;
  final double targetAmount;
  final DateTime targetDate;
  final String? notes;

  const UpdateSavingsGoalSubmitted({
    required this.id,
    required this.name,
    required this.targetAmount,
    required this.targetDate,
    this.notes,
  });

  @override
  List<Object?> get props => [
        id,
        name,
        targetAmount,
        targetDate,
        notes,
      ];
}

class DeleteSavingsGoal extends SavingsEvent {
  final String id;

  const DeleteSavingsGoal(this.id);

  @override
  List<Object?> get props => [id];
}

class UpdateSavingsCurrentAmount extends SavingsEvent {
  final String id;
  final double delta;

  const UpdateSavingsCurrentAmount({
    required this.id,
    required this.delta,
  });

  @override
  List<Object?> get props => [id, delta];
} 