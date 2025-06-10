class Payback {
  final String id;
  final String counterparty;
  final double amount;
  final double remaining;
  final DateTime startDate;
  final DateTime? dueDate;
  final String status; // "pending" | "overdue" | "paid" | "active"
  final String type; // "owed_to_me" | "i_owe"
  final String category; // "personal" | "credit" | "debt"
  final double? interestRate;
  final String? description;

  Payback({
    required this.id,
    required this.counterparty,
    required this.amount,
    required this.remaining,
    required this.startDate,
    this.dueDate,
    required this.status,
    required this.type,
    required this.category,
    this.interestRate,
    this.description,
  });

  Payback copyWith({
    String? id,
    String? counterparty,
    double? amount,
    double? remaining,
    DateTime? startDate,
    DateTime? dueDate,
    String? status,
    String? type,
    String? category,
    double? interestRate,
    String? description,
  }) {
    return Payback(
      id: id ?? this.id,
      counterparty: counterparty ?? this.counterparty,
      amount: amount ?? this.amount,
      remaining: remaining ?? this.remaining,
      startDate: startDate ?? this.startDate,
      dueDate: dueDate ?? this.dueDate,
      status: status ?? this.status,
      type: type ?? this.type,
      category: category ?? this.category,
      interestRate: interestRate ?? this.interestRate,
      description: description ?? this.description,
    );
  }
} 