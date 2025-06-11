import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'savings_event.dart';
import 'savings_state.dart';

class SavingsBloc extends Bloc<SavingsEvent, SavingsState> {
  final SharedPreferences _prefs;
  static const String _savingsKey = 'savings_goals';

  SavingsBloc({required SharedPreferences prefs}) 
      : _prefs = prefs,
        super(const SavingsState()) {
    on<LoadSavings>(_onLoadSavings);
    on<AddSavingsGoalSubmitted>(_onAddSavingsGoalSubmitted);
    on<UpdateSavingsGoalSubmitted>(_onUpdateSavingsGoalSubmitted);
    on<DeleteSavingsGoal>(_onDeleteSavingsGoal);
    on<UpdateSavingsCurrentAmount>(_onUpdateSavingsCurrentAmount);
  }

  Future<void> _onLoadSavings(
    LoadSavings event,
    Emitter<SavingsState> emit,
  ) async {
    emit(state.copyWith(status: SavingsStatus.loading));
    try {
      final goalsJson = _prefs.getStringList(_savingsKey) ?? [];
      final goals = goalsJson
          .map((json) => SavingsGoal.fromJson(jsonDecode(json)))
          .toList();
      
      emit(state.copyWith(
        status: SavingsStatus.success,
        goals: goals,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: SavingsStatus.error,
        errorMessage: 'Failed to load savings goals',
      ));
    }
  }

  Future<void> _onAddSavingsGoalSubmitted(
    AddSavingsGoalSubmitted event,
    Emitter<SavingsState> emit,
  ) async {
    emit(state.copyWith(status: SavingsStatus.loading));
    try {
      final newGoal = SavingsGoal(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        name: event.name,
        targetAmount: event.targetAmount,
        currentAmount: event.initialContribution,
        targetDate: event.targetDate,
        notes: event.notes,
      );

      final updated = [newGoal, ...state.goals];
      await _saveGoals(updated);

      emit(state.copyWith(
        status: SavingsStatus.success,
        goals: updated,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: SavingsStatus.error,
        errorMessage: 'Failed to create savings goal',
      ));
    }
  }

  Future<void> _onUpdateSavingsGoalSubmitted(
    UpdateSavingsGoalSubmitted event,
    Emitter<SavingsState> emit,
  ) async {
    emit(state.copyWith(status: SavingsStatus.loading));
    try {
      final goal = state.goals.firstWhere((g) => g.id == event.id);
      final updatedGoal = goal.copyWith(
        name: event.name,
        targetAmount: event.targetAmount,
        targetDate: event.targetDate,
        notes: event.notes,
      );

      final updated = state.goals.map((g) => g.id == event.id ? updatedGoal : g).toList();
      await _saveGoals(updated);

      emit(state.copyWith(
        status: SavingsStatus.success,
        goals: updated,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: SavingsStatus.error,
        errorMessage: 'Failed to update savings goal',
      ));
    }
  }

  Future<void> _onDeleteSavingsGoal(
    DeleteSavingsGoal event,
    Emitter<SavingsState> emit,
  ) async {
    emit(state.copyWith(status: SavingsStatus.loading));
    try {
      final updated = state.goals.where((g) => g.id != event.id).toList();
      await _saveGoals(updated);

      emit(state.copyWith(
        status: SavingsStatus.success,
        goals: updated,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: SavingsStatus.error,
        errorMessage: 'Failed to delete savings goal',
      ));
    }
  }

  Future<void> _onUpdateSavingsCurrentAmount(
    UpdateSavingsCurrentAmount event,
    Emitter<SavingsState> emit,
  ) async {
    emit(state.copyWith(status: SavingsStatus.loading));
    try {
      final goal = state.goals.firstWhere((g) => g.id == event.id);
      final updatedGoal = goal.copyWith(
        currentAmount: goal.currentAmount + event.delta,
      );

      final updated = state.goals.map((g) => g.id == event.id ? updatedGoal : g).toList();
      await _saveGoals(updated);

      emit(state.copyWith(
        status: SavingsStatus.success,
        goals: updated,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: SavingsStatus.error,
        errorMessage: 'Failed to update savings amount',
      ));
    }
  }

  Future<void> _saveGoals(List<SavingsGoal> goals) async {
    final goalsJson = goals
        .map((g) => jsonEncode(g.toJson()))
        .toList();
    await _prefs.setStringList(_savingsKey, goalsJson);
  }
} 