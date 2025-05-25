import 'package:flutter_bloc/flutter_bloc.dart';
import 'stats_event.dart';
import 'stats_state.dart';

class StatsBloc extends Bloc<StatsEvent, StatsState> {
  StatsBloc() : super(const StatsState()) {
    on<StatsLoaded>(_onStatsLoaded);
  }

  void _onStatsLoaded(
    StatsLoaded event,
    Emitter<StatsState> emit,
  ) {
    // Dummy data for now
    emit(state.copyWith(
      monthlyIncome: 5000.0,
      monthlyExpenses: 2500.0,
      categoryBreakdown: {
        'Food': 800.0,
        'Transport': 400.0,
        'Entertainment': 300.0,
        'Shopping': 600.0,
        'Bills': 400.0,
      },
      taxProgress: 0.6, // 60% of yearly tax goal
      savingsProgress: 0.75, // 75% of monthly savings goal
    ));
  }
} 