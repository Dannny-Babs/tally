import 'package:flutter_bloc/flutter_bloc.dart';
import 'dashboard_event.dart';
import 'dashboard_state.dart';
import '../models/transaction.dart';

class DashboardBloc extends Bloc<DashboardEvent, DashboardState> {
  DashboardBloc() : super(const DashboardState()) {
    on<DashboardLoaded>(_onDashboardLoaded);
  }

  void _onDashboardLoaded(
    DashboardLoaded event,
    Emitter<DashboardState> emit,
  ) {
    // Dummy data for now
    emit(state.copyWith(
      totalIncome: 5000.0,
      totalExpenses: 2500.0,
      totalSavings: 1500.0,
      totalGifts: 500.0,
      recentTransactions: [
        Transaction(
          id: '1',
          amount: 100.0,
          description: 'Grocery shopping',
          date: DateTime.now(),
          type: TransactionType.expense,
        ),
        Transaction(
          id: '2',
          amount: 2000.0,
          description: 'Freelance payment',
          date: DateTime.now().subtract(const Duration(days: 1)),
          type: TransactionType.income,
        ),
        Transaction(
          id: '3',
          amount: 50.0,
          description: 'Birthday gift',
          date: DateTime.now().subtract(const Duration(days: 2)),
          type: TransactionType.gift,
        ),
      ],
      aiInsight: 'You\'ve spent 30% more on groceries this month compared to last month.',
    ));
  }
} 