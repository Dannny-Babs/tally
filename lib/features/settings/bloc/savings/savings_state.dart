import 'package:equatable/equatable.dart';

enum SavingsStatus {
  initial,
  loading,
  success,
  error,
}

class SavingsState extends Equatable {
  final SavingsStatus status;
  final List<SavingsGoal> goals;
  final String? errorMessage;

  const SavingsState({
    this.status = SavingsStatus.initial,
    this.goals = const [],
    this.errorMessage,
  });

  SavingsState copyWith({
    SavingsStatus? status,
    List<SavingsGoal>? goals,
    String? errorMessage,
  }) {
    return SavingsState(
      status: status ?? this.status,
      goals: goals ?? this.goals,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, goals, errorMessage];
}

class SavingsGoal extends Equatable {
  final String id;
  final String name;
  final double targetAmount;
  final double currentAmount;
  final DateTime targetDate;
  final String? notes;

  const SavingsGoal({
    required this.id,
    required this.name,
    required this.targetAmount,
    required this.currentAmount,
    required this.targetDate,
    this.notes,
  });

  SavingsGoal copyWith({
    String? id,
    String? name,
    double? targetAmount,
    double? currentAmount,
    DateTime? targetDate,
    String? notes,
  }) {
    return SavingsGoal(
      id: id ?? this.id,
      name: name ?? this.name,
      targetAmount: targetAmount ?? this.targetAmount,
      currentAmount: currentAmount ?? this.currentAmount,
      targetDate: targetDate ?? this.targetDate,
      notes: notes ?? this.notes,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'targetAmount': targetAmount,
      'currentAmount': currentAmount,
      'targetDate': targetDate.toIso8601String(),
      'notes': notes,
    };
  }

  factory SavingsGoal.fromJson(Map<String, dynamic> json) {
    return SavingsGoal(
      id: json['id'] as String,
      name: json['name'] as String,
      targetAmount: (json['targetAmount'] as num).toDouble(),
      currentAmount: (json['currentAmount'] as num).toDouble(),
      targetDate: DateTime.parse(json['targetDate'] as String),
      notes: json['notes'] as String?,
    );
  }

  @override
  List<Object?> get props => [
        id,
        name,
        targetAmount,
        currentAmount,
        targetDate,
        notes,
      ];
} 