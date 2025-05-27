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
  final String? incomeType;
  final bool isPaid;
  final String? paymentMethod;

  MockTransaction({
    required this.source,
    required this.description,
    required this.date,
    required this.time,
    required this.amount,
    required this.isIncome,
    required this.categories,
    this.incomeType,
    this.isPaid = true,
    this.paymentMethod,
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
      incomeType: incomeType,
      isPaid: isPaid,
      paymentMethod: paymentMethod,
    );
  }
}

final List<MockTransaction> mockTransactions = [
  // Income Transactions
  MockTransaction(source: 'Med Melanin Inc.', description: 'Payment for May Design Work', date: '2024-06-01', time: '12:30', amount: 1500.0, isIncome: true, categories: ['Design'], incomeType: 'Salary'),
  MockTransaction(source: 'Tech Solutions LLC', description: 'Frontend Development Contract', date: '2024-06-02', time: '09:15', amount: 2800.0, isIncome: true, categories: ['Development'], incomeType: 'Freelance' ),
  MockTransaction(source: 'Creative Studios', description: 'Logo Design Project', date: '2024-06-03', time: '14:45', amount: 950.0, isIncome: true, categories: ['Design'], incomeType: 'Freelance' ),
  MockTransaction(source: 'Digital Marketing Co.', description: 'Social Media Campaign', date: '2024-06-04', time: '11:20', amount: 1200.0, isIncome: true, categories: ['Marketing'], incomeType: 'Freelance'  ),
  MockTransaction(source: 'Web Solutions Inc.', description: 'Website Maintenance', date: '2024-06-05', time: '16:30', amount: 750.0, isIncome: true, categories: ['Development'], incomeType: 'Salary'),
  MockTransaction(source: 'Brand Identity Co.', description: 'Brand Guidelines Design', date: '2024-06-06', time: '13:15', amount: 1800.0, isIncome: true, categories: ['Design'], incomeType: 'Freelance'  ),
  MockTransaction(source: 'Mobile Apps Ltd.', description: 'App UI/UX Design', date: '2024-06-07', time: '10:45', amount: 2200.0, isIncome: true, categories: ['Design'], incomeType: 'Freelance'),
  MockTransaction(source: 'E-commerce Solutions', description: 'Shopify Store Setup', date: '2024-06-08', time: '15:30', amount: 1600.0, isIncome: true, categories: ['Development'], incomeType: 'Salary'),
  MockTransaction(source: 'Content Creators Inc.', description: 'Content Strategy', date: '2024-06-09', time: '14:00', amount: 1100.0, isIncome: true, categories: ['Marketing'], incomeType: 'Freelance'),
  MockTransaction(source: 'UI/UX Collective', description: 'Mobile App Design', date: '2024-06-10', time: '11:45', amount: 2500.0, isIncome: true, categories: ['Design'], incomeType: 'Freelance'  ),
  MockTransaction(source: 'Tech Innovators', description: 'API Development', date: '2024-06-11', time: '09:30', amount: 3200.0, isIncome: true, categories: ['Development'], incomeType: 'Salary'),
  MockTransaction(source: 'Design Masters', description: 'Product Packaging Design', date: '2024-06-12', time: '13:45', amount: 1400.0, isIncome: true, categories: ['Design'], incomeType: 'Freelance'),
  MockTransaction(source: 'Digital Agency', description: 'SEO Optimization', date: '2024-06-13', time: '10:15', amount: 900.0, isIncome: true, categories: ['Marketing'], incomeType: 'Freelance'),
  MockTransaction(source: 'Web Developers Co.', description: 'WordPress Development', date: '2024-06-14', time: '15:45', amount: 1800.0, isIncome: true, categories: ['Development'], incomeType: 'Salary'),
  MockTransaction(source: 'Brand Designers', description: 'Rebranding Project', date: '2024-06-15', time: '14:30', amount: 3000.0, isIncome: true, categories: ['Design'], incomeType: 'Freelance'),
  MockTransaction(source: 'Social Media Pro', description: 'Instagram Campaign', date: '2024-06-16', time: '11:00', amount: 850.0, isIncome: true, categories: ['Marketing'], incomeType: 'Freelance'),  
  MockTransaction(source: 'App Developers Inc.', description: 'Flutter App Development', date: '2024-06-17', time: '16:15', amount: 3500.0, isIncome: true, categories: ['Development'], incomeType: 'Salary'),
  MockTransaction(source: 'Design Studio', description: 'Website Redesign', date: '2024-06-18', time: '13:30', amount: 2000.0, isIncome: true, categories: ['Design'], incomeType: 'Freelance'),
  MockTransaction(source: 'Digital Marketing Pro', description: 'PPC Campaign', date: '2024-06-19', time: '10:45', amount: 1200.0, isIncome: true, categories: ['Marketing'], incomeType: 'Freelance'),
  MockTransaction(source: 'Tech Solutions Pro', description: 'Backend Development', date: '2024-06-20', time: '15:00', amount: 2800.0, isIncome: true, categories: ['Development'], incomeType: 'Salary'),

  // Expense Transactions
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
]; 

