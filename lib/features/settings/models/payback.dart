import 'package:flutter/material.dart';

enum PaybackStatus {
  pending,
  overdue,
  paid,
  active;

  String get displayName {
    switch (this) {
      case PaybackStatus.pending:
        return 'Pending';
      case PaybackStatus.overdue:
        return 'Overdue';
      case PaybackStatus.paid:
        return 'Paid';
      case PaybackStatus.active:
        return 'Active';
    }
  }

  Color get color {
    switch (this) {
      case PaybackStatus.pending:
        return Colors.orange;
      case PaybackStatus.overdue:
        return Colors.red;
      case PaybackStatus.paid:
        return Colors.green;
      case PaybackStatus.active:
        return Colors.blue;
    }
  }

  IconData get icon {
    switch (this) {
      case PaybackStatus.pending:
        return Icons.access_time;
      case PaybackStatus.overdue:
        return Icons.warning;
      case PaybackStatus.paid:
        return Icons.check_circle;
      case PaybackStatus.active:
        return Icons.trending_up;
    }
  }
}

enum PaybackType {
  owedToMe,
  iOwe;

  String get displayName {
    switch (this) {
      case PaybackType.owedToMe:
        return 'Owed to Me';
      case PaybackType.iOwe:
        return 'I Owe';
    }
  }

  Color get color {
    switch (this) {
      case PaybackType.owedToMe:
        return Colors.green;
      case PaybackType.iOwe:
        return Colors.red;
    }
  }
}

enum PaybackCategory {
  personal,
  credit,
  debt;

  String get displayName {
    switch (this) {
      case PaybackCategory.personal:
        return 'Personal';
      case PaybackCategory.credit:
        return 'Credit';
      case PaybackCategory.debt:
        return 'Debt';
    }
  }

  IconData get icon {
    switch (this) {
      case PaybackCategory.personal:
        return Icons.person;
      case PaybackCategory.credit:
        return Icons.credit_card;
      case PaybackCategory.debt:
        return Icons.account_balance;
    }
  }
}

class Payback {
  final String id;
  final String counterparty;
  final double amount;
  final double remaining;
  final DateTime startDate;
  final DateTime? dueDate;
  final PaybackStatus status;
  final PaybackType type;
  final PaybackCategory category;
  final double? interestRate;
  final String? description;

  const Payback({
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

  double get progress => amount > 0 ? (amount - remaining) / amount : 0;
  bool get isOverdue => dueDate != null && dueDate!.isBefore(DateTime.now());
  bool get isPaid => remaining <= 0;

  Payback copyWith({
    String? id,
    String? counterparty,
    double? amount,
    double? remaining,
    DateTime? startDate,
    DateTime? dueDate,
    PaybackStatus? status,
    PaybackType? type,
    PaybackCategory? category,
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

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'counterparty': counterparty,
      'amount': amount,
      'remaining': remaining,
      'startDate': startDate.toIso8601String(),
      'dueDate': dueDate?.toIso8601String(),
      'status': status.name,
      'type': type.name,
      'category': category.name,
      'interestRate': interestRate,
      'description': description,
    };
  }

  factory Payback.fromJson(Map<String, dynamic> json) {
    return Payback(
      id: json['id'] as String,
      counterparty: json['counterparty'] as String,
      amount: (json['amount'] as num).toDouble(),
      remaining: (json['remaining'] as num).toDouble(),
      startDate: DateTime.parse(json['startDate'] as String),
      dueDate: json['dueDate'] != null ? DateTime.parse(json['dueDate'] as String) : null,
      status: PaybackStatus.values.firstWhere((e) => e.name == json['status']),
      type: PaybackType.values.firstWhere((e) => e.name == json['type']),
      category: PaybackCategory.values.firstWhere((e) => e.name == json['category']),
      interestRate: json['interestRate'] != null ? (json['interestRate'] as num).toDouble() : null,
      description: json['description'] as String?,
    );
  }
} 