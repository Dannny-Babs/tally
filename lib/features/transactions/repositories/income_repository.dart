import 'dart:convert';
import 'package:flutter/services.dart';
import '../models/transaction_model.dart';

class IncomeRepository {
  Future<List<Transaction>> fetchIncomes() async {
    try {
      // Load the JSON file from assets
      final String jsonString = await rootBundle.loadString('assets/incomes.json');
      final List<dynamic> jsonList = json.decode(jsonString);
      
      // Convert JSON to Transaction objects
      return jsonList.map((json) => Transaction.fromJson(json)).toList();
    } catch (e) {
      // If there's an error loading the file, return an empty list
      print('Error loading incomes: $e');
      return [];
    }
  }

  Future<void> addIncome(Transaction transaction) async {
    try {
      // Load existing incomes
      final String jsonString = await rootBundle.loadString('assets/incomes.json');
      final List<dynamic> jsonList = json.decode(jsonString);
      
      // Add new transaction
      jsonList.add(transaction.toJson());
      
      // TODO: Implement saving to file
      // For now, we'll just print the updated list
      print('Updated incomes: $jsonList');
    } catch (e) {
      print('Error adding income: $e');
      throw Exception('Failed to add income');
    }
  }
} 