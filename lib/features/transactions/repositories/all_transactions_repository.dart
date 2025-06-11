import '../models/transaction_model.dart';
import 'income_repository.dart';
import 'expense_repository.dart';

class AllTransactionsRepository {
  final IncomeRepository incomeRepository;
  final ExpenseRepository expenseRepository;

  AllTransactionsRepository({
    required this.incomeRepository,
    required this.expenseRepository,
  });

  Future<List<Transaction>> getAllTransactions({int limit = 20}) async {
    final income = await incomeRepository.fetchIncomes();
    final expenses = await expenseRepository.fetchExpenses();
    final all = [...income, ...expenses];
    all.sort((a, b) {
      final aDateTime = DateTime.parse('${a.date} ${a.time}');
      final bDateTime = DateTime.parse('${b.date} ${b.time}');
      return bDateTime.compareTo(aDateTime); // newest first
    });
    return all.take(limit).toList();
  }
} 