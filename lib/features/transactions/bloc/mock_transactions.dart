import 'transaction_model.dart';

// Mock transactions for testing
class MockTransaction {
  final String source;
  final String description;
  final String date;
  final String time;
  final double amount;
  final bool isIncome;
  final List<String> categories;

  MockTransaction({
    required this.source,
    required this.description,
    required this.date,
    required this.time,
    required this.amount,
    required this.isIncome,
    required this.categories,
  });

  Transaction toTransaction(String id) {
    return Transaction(
      id: id,
      source: source,
      description: description,
      amount: amount,
      date: date,
      time: time,
      isIncome: isIncome,
      categories: categories,
    );
  }
}

final List<MockTransaction> mockTransactions = [
  MockTransaction(source: 'Food & Dining', description: 'Lunch at Cafe', date: '2024-06-01', time: '12:30', amount: 15.0, isIncome: false, categories: ['Food & Dining']),
  MockTransaction(source: 'Transportation', description: 'Bus Ticket', date: '2024-06-01', time: '08:00', amount: 2.5, isIncome: false, categories: ['Transportation']),
  MockTransaction(source: 'Housing', description: 'June Rent', date: '2024-06-01', time: '09:00', amount: 800.0, isIncome: false, categories: ['Housing']),
  MockTransaction(source: 'Utilities', description: 'Electricity Bill', date: '2024-06-02', time: '10:00', amount: 60.0, isIncome: false, categories: ['Utilities']),
  MockTransaction(source: 'Shopping', description: 'Clothes', date: '2024-06-02', time: '15:00', amount: 50.0, isIncome: false, categories: ['Shopping']),
  MockTransaction(source: 'Health & Fitness', description: 'Gym Membership', date: '2024-06-03', time: '18:00', amount: 30.0, isIncome: false, categories: ['Health & Fitness']),
  MockTransaction(source: 'Entertainment', description: 'Movie Night', date: '2024-06-03', time: '20:00', amount: 12.0, isIncome: false, categories: ['Entertainment']),
  MockTransaction(source: 'Travel', description: 'Train Ticket', date: '2024-06-04', time: '07:00', amount: 25.0, isIncome: false, categories: ['Travel']),
  MockTransaction(source: 'Education', description: 'Online Course', date: '2024-06-04', time: '21:00', amount: 40.0, isIncome: false, categories: ['Education']),
  MockTransaction(source: 'Personal Care', description: 'Haircut', date: '2024-06-05', time: '16:00', amount: 20.0, isIncome: false, categories: ['Personal Care']),
  MockTransaction(source: 'Insurance', description: 'Health Insurance', date: '2024-06-05', time: '11:00', amount: 100.0, isIncome: false, categories: ['Insurance']),
  MockTransaction(source: 'Gifts & Donations', description: 'Birthday Gift', date: '2024-06-06', time: '14:00', amount: 30.0, isIncome: false, categories: ['Gifts & Donations']),
  MockTransaction(source: 'Investments', description: 'Stock Purchase', date: '2024-06-06', time: '13:00', amount: 200.0, isIncome: false, categories: ['Investments']),
  MockTransaction(source: 'Taxes', description: 'Quarterly Tax', date: '2024-06-07', time: '10:00', amount: 300.0, isIncome: false, categories: ['Taxes']),
  MockTransaction(source: 'Pets', description: 'Dog Food', date: '2024-06-07', time: '17:00', amount: 25.0, isIncome: false, categories: ['Pets']),
  MockTransaction(source: 'Kids', description: 'Toys', date: '2024-06-08', time: '13:00', amount: 40.0, isIncome: false, categories: ['Kids']),
  MockTransaction(source: 'Groceries', description: 'Supermarket', date: '2024-06-08', time: '19:00', amount: 60.0, isIncome: false, categories: ['Groceries']),
  MockTransaction(source: 'Subscriptions', description: 'Music Streaming', date: '2024-06-09', time: '08:00', amount: 10.0, isIncome: false, categories: ['Subscriptions']),
  MockTransaction(source: 'Alcohol & Bars', description: 'Bar Night', date: '2024-06-09', time: '22:00', amount: 20.0, isIncome: false, categories: ['Alcohol & Bars']),
  MockTransaction(source: 'Miscellaneous', description: 'Stationery', date: '2024-06-10', time: '12:00', amount: 8.0, isIncome: false, categories: ['Miscellaneous']),
  MockTransaction(source: 'Food & Dining', description: 'Dinner at Restaurant', date: '2024-06-10', time: '19:30', amount: 35.0, isIncome: false, categories: ['Food & Dining']),
  MockTransaction(source: 'Groceries', description: 'Weekly Groceries', date: '2024-06-11', time: '17:00', amount: 120.0, isIncome: false, categories: ['Groceries']),
  MockTransaction(source: 'Shopping', description: 'Shoes', date: '2024-06-11', time: '16:00', amount: 80.0, isIncome: false, categories: ['Shopping']),
  MockTransaction(source: 'Travel', description: 'Flight Ticket', date: '2024-06-12', time: '09:00', amount: 35.0, isIncome: false, categories: ['Travel']),
  MockTransaction(source: 'Kids', description: 'School Supplies', date: '2024-06-12', time: '15:00', amount: 40.0, isIncome: false, categories: ['Kids']),
  MockTransaction(source: 'Health & Fitness', description: 'Yoga Class', date: '2024-06-13', time: '18:00', amount: 30.0, isIncome: false, categories: ['Health & Fitness']),
  MockTransaction(source: 'Personal Care', description: 'Spa', date: '2024-06-13', time: '20:00', amount: 20.0, isIncome: false, categories: ['Personal Care']),
  MockTransaction(source: 'Utilities', description: 'Water Bill', date: '2024-06-14', time: '10:00', amount: 60.0, isIncome: false, categories: ['Utilities']),
  MockTransaction(source: 'Entertainment', description: 'Concert', date: '2024-06-14', time: '21:00', amount: 25.0, isIncome: false, categories: ['Entertainment']),
  MockTransaction(source: 'Subscriptions', description: 'Video Streaming', date: '2024-06-15', time: '08:00', amount: 15.0, isIncome: false, categories: ['Subscriptions']),
]; 