import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../../models/payback.dart';
import 'paybacks_event.dart';
import 'paybacks_state.dart';

class PaybacksBloc extends Bloc<PaybacksEvent, PaybacksState> {
  final SharedPreferences _prefs;
  static const String _paybacksKey = 'paybacks';

  PaybacksBloc({required SharedPreferences prefs}) 
      : _prefs = prefs,
        super(const PaybacksState()) {
    on<LoadPaybacks>(_onLoadPaybacks);
    on<AddPayback>(_onAddPayback);
    on<UpdatePayback>(_onUpdatePayback);
    on<DeletePayback>(_onDeletePayback);
    on<SwitchPaybacksTab>(_onSwitchTab);
  }

  Future<void> _onLoadPaybacks(
    LoadPaybacks event,
    Emitter<PaybacksState> emit,
  ) async {
    emit(state.copyWith(status: PaybacksStatus.loading));
    try {
      final paybacksJson = _prefs.getStringList(_paybacksKey) ?? [];
      final paybacks = paybacksJson
          .map((json) => Payback.fromJson(jsonDecode(json)))
          .toList();
      
      emit(state.copyWith(
        paybacks: paybacks,
        status: PaybacksStatus.success,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: PaybacksStatus.error,
        errorMessage: 'Failed to load paybacks',
      ));
    }
  }

  Future<void> _onAddPayback(
    AddPayback event,
    Emitter<PaybacksState> emit,
  ) async {
    try {
      final updated = [event.payback, ...state.paybacks];
      await _savePaybacks(updated);
      emit(state.copyWith(paybacks: updated));
    } catch (e) {
      emit(state.copyWith(
        status: PaybacksStatus.error,
        errorMessage: 'Failed to add payback',
      ));
    }
  }

  Future<void> _onUpdatePayback(
    UpdatePayback event,
    Emitter<PaybacksState> emit,
  ) async {
    try {
      final updated = state.paybacks
          .map((p) => p.id == event.payback.id ? event.payback : p)
          .toList();
      await _savePaybacks(updated);
      emit(state.copyWith(paybacks: updated));
    } catch (e) {
      emit(state.copyWith(
        status: PaybacksStatus.error,
        errorMessage: 'Failed to update payback',
      ));
    }
  }

  Future<void> _onDeletePayback(
    DeletePayback event,
    Emitter<PaybacksState> emit,
  ) async {
    try {
      final updated = state.paybacks.where((p) => p.id != event.id).toList();
      await _savePaybacks(updated);
      emit(state.copyWith(paybacks: updated));
    } catch (e) {
      emit(state.copyWith(
        status: PaybacksStatus.error,
        errorMessage: 'Failed to delete payback',
      ));
    }
  }

  void _onSwitchTab(SwitchPaybacksTab event, Emitter<PaybacksState> emit) {
    emit(state.copyWith(currentTab: event.tab));
  }

  Future<void> _savePaybacks(List<Payback> paybacks) async {
    final paybacksJson = paybacks
        .map((p) => jsonEncode(p.toJson()))
        .toList();
    await _prefs.setStringList(_paybacksKey, paybacksJson);
  }
} 