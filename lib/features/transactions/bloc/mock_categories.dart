// Mock categories and category totals for testing
const List<String> mockCategories = [
  'Food & Dining',
  'Transportation',
  'Housing',
  'Utilities',
  'Shopping',
  'Health & Fitness',
  'Entertainment',
  'Travel',
  'Education',
  'Personal Care',
  'Insurance',
  'Gifts & Donations',
  'Investments',
  'Taxes',
  'Pets',
  'Kids',
  'Groceries',
  'Subscriptions',
  'Alcohol & Bars',
  'Miscellaneous',
];

// Returns a map of category to total spent (for bar chart)
Map<String, double> getMockCategoryTotals() {
  return {
    'Food & Dining': 320.0,
    'Transportation': 150.0,
    'Housing': 800.0,
    'Utilities': 120.0,
    'Shopping': 210.0,
    'Health & Fitness': 90.0,
    'Entertainment': 75.0,
    'Travel': 60.0,
    'Education': 50.0,
    'Personal Care': 40.0,
    'Insurance': 100.0,
    'Gifts & Donations': 30.0,
    'Investments': 200.0,
    'Taxes': 300.0,
    'Pets': 25.0,
    'Kids': 80.0,
    'Groceries': 180.0,
    'Subscriptions': 45.0,
    'Alcohol & Bars': 35.0,
    'Miscellaneous': 20.0,
  };
} 