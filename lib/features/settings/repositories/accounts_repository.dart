import 'base_repository.dart';
import '../bloc/accounts/accounts_state.dart';

class AccountsRepository extends BaseRepository {
  final List<SavingsAccount> _savingsAccounts = [];

  List<SavingsAccount> get savingsAccounts => List.unmodifiable(_savingsAccounts);

  Future<void> addSavingsAccount(SavingsAccount account) async {
    _savingsAccounts.add(account);
  }

  Future<void> updateSavingsAccount(SavingsAccount account) async {
    final index = _savingsAccounts.indexWhere((a) => a.id == account.id);
    if (index != -1) {
      _savingsAccounts[index] = account;
    }
  }

  Future<void> deleteSavingsAccount(String id) async {
    _savingsAccounts.removeWhere((account) => account.id == id);
  }

  @override
  Future<void> initialize() async {
    // TODO: Load accounts from local storage or API
  }

  @override
  Future<void> dispose() async {
    // TODO: Save accounts to local storage
  }
} 