import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'transaction_model.dart';

abstract class TransactionEvent extends Equatable {
  const TransactionEvent();

  @override
  List<Object> get props => [];
}

class IncomeLoaded extends TransactionEvent {}

class ExpensesLoaded extends TransactionEvent {}

class TransactionLoadMore extends TransactionEvent {}

class DateFilterChanged extends TransactionEvent {
  final DateTime startDate;
  final DateTime endDate;

  const DateFilterChanged({
    required this.startDate,
    required this.endDate,
  });

  @override
  List<Object> get props => [startDate, endDate];
}

class TransactionAdded extends TransactionEvent {
  final Transaction transaction;

  const TransactionAdded(this.transaction);

  @override
  List<Object> get props => [transaction];
}

class TransactionUpdated extends TransactionEvent {
  final Transaction transaction;

  const TransactionUpdated(this.transaction);

  @override
  List<Object> get props => [transaction];
}

class TransactionDeleted extends TransactionEvent {
  final String id;

  const TransactionDeleted(this.id);

  @override
  List<Object> get props => [id];
}

class AddIncomeSubmitted extends TransactionEvent {
  final double amount;
  final String source;
  final String description;
  final DateTime date;
  final TimeOfDay time;
  final List<String> categories;
  final String? notes;

  const AddIncomeSubmitted({
    required this.amount,
    required this.source,
    required this.description,
    required this.date,
    required this.time,
    required this.categories,
    this.notes,
  });

  @override
  List<Object> get props => [amount, source, description, date, time, categories, notes ?? ''];
}

class AddExpenseSubmitted extends TransactionEvent {
  final double amount;
  final String category;
  final String description;
  final DateTime date;
  final TimeOfDay time;
  final List<String> tags;
  final String? notes;
  final String paymentMethod;

  const AddExpenseSubmitted({
    required this.amount,
    required this.category,
    required this.description,
    required this.date,
    required this.time,
    required this.tags,
    this.notes,
    required this.paymentMethod,
  });

  @override
  List<Object> get props => [amount, category, description, date, time, tags, notes ?? '', paymentMethod];
} 