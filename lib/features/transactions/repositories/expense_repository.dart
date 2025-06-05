import 'dart:convert';
import 'package:flutter/services.dart';
import '../models/transaction_model.dart';

class ExpenseRepository {
  static const String _assetPath = 'lib/features/transactions/data/expense.json';

  Future<List<Transaction>> fetchExpenses() async {
    try {
      // Load the JSON file from assets
      final String jsonString = await rootBundle.loadString(_assetPath);
      final List<dynamic> jsonList = json.decode(jsonString);
      
      // Convert JSON to Transaction objects with proper mapping
      return jsonList.map((json) => Transaction.fromJson(json)).toList();
    } catch (e) {
      print('Error loading expenses: $e');
      rethrow;
    }
  }

  Future<void> addExpense(Transaction transaction) async {
    try {
      // Load existing expenses
      final String jsonString = await rootBundle.loadString(_assetPath);
      final List<dynamic> jsonList = json.decode(jsonString);
      
      // Add new transaction
      jsonList.add(transaction.toJson());
      
      // TODO: Implement saving to file
      // For now, we'll just print the updated list
      print('Updated expenses: $jsonList');
    } catch (e) {
      print('Error adding expense: $e');
      throw Exception('Failed to add expense');
    }
  }
} 