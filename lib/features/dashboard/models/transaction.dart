enum TransactionType {
  income,
  expense,
  gift,
  savings,
}

class Transaction {
  final String id;
  final double amount;
  final String description;
  final DateTime date;
  final TransactionType type;

  const Transaction({
    required this.id,
    required this.amount,
    required this.description,
    required this.date,
    required this.type,
  });
} 