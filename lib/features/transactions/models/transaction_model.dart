import 'package:equatable/equatable.dart';

class Transaction extends Equatable {
  final String id;
  final String source;
  final String description;
  final double amount;
  final String date;
  final String time;
  final bool isIncome;
  final List<String> categories;
  final String? notes;
  final String? paymentMethod;
  final String? incomeType;
  final bool isPaid;

  const Transaction({
    required this.id,
    required this.source,
    required this.description,
    required this.amount,
    required this.date,
    required this.time,
    required this.isIncome,
    required this.categories,
    this.notes,
    this.paymentMethod,
    this.incomeType,
    this.isPaid = true,
  });

  @override
  List<Object> get props => [
    id,
    source,
    description,
    amount,
    date,
    time,
    isIncome,
    categories,
    notes ?? '',
    paymentMethod ?? '',
    incomeType ?? '',
    isPaid,
  ];
} 