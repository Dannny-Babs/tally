import 'package:equatable/equatable.dart';

class Transaction extends Equatable {
  final String id;
  final String source;
  final String description;
  final String date;
  final String time;
  final double amount;
  final bool isIncome;
  final List<String> categories;
  final List<String> tags;
  final String? payeeName;
  final bool taxable;
  final bool recurring;
  final String? frequency;
  final List<String> receiptImages;
  final String? notes;
  final String? paymentMethod;
  final String? incomeType;
 

  const Transaction({
    required this.id,
    required this.source,
    required this.description,
    required this.date,
    required this.time,
    required this.amount,
    required this.isIncome,
    required this.categories,
    this.tags = const [],
    this.payeeName,
    this.taxable = false,
    this.recurring = false,
    this.frequency,
    this.receiptImages = const [],
    this.notes,
    this.paymentMethod,
    this.incomeType,

  });

  factory Transaction.fromJson(Map<String, dynamic> json) {
    return Transaction(
      id: json['id'] as String,
      source: json['source'] as String,
      description: json['description'] as String,
      date: json['date'] as String,
      time: json['time'] as String,
      amount: (json['amount'] as num).toDouble(),
      isIncome: json['isIncome'] as bool,
      categories: List<String>.from(json['categories'] as List),
      tags: List<String>.from(json['tags'] as List? ?? []),
      payeeName: json['payeeName'] as String?,
      taxable: json['taxable'] as bool? ?? false,
      recurring: json['recurring'] as bool? ?? false,
      frequency: json['frequency'] as String?,
      receiptImages: List<String>.from(json['receiptImages'] as List? ?? []),
      notes: json['notes'] as String?,
      paymentMethod: json['paymentMethod'] as String?,
      incomeType: json['incomeType'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'source': source,
      'description': description,
      'date': date,
      'time': time,
      'amount': amount,
      'isIncome': isIncome,
      'categories': categories,
      'tags': tags,
      'payeeName': payeeName,
      'taxable': taxable,
      'recurring': recurring,
      'frequency': frequency,
      'receiptImages': receiptImages,
      'notes': notes,
      'paymentMethod': paymentMethod,
      'incomeType': incomeType,
    };
  }

  @override
  List<Object?> get props => [
        id,
        source,
        description,
        date,
        time,
        amount,
        isIncome,
        categories,
        tags,
        payeeName,
        taxable,
        recurring,
        frequency,
        receiptImages,
        notes,
        paymentMethod,
        incomeType,
      ];
} 