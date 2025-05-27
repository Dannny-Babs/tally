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
  ];
} 