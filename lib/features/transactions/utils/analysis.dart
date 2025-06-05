import '../models/transaction_model.dart';

/// Group transactions by category and sum amounts.
/// Returns a map: { "Food": 450.0, "Shopping": 350.0, ... }
Map<String, double> totalByCategory(List<Transaction> txs) {
  final Map<String, double> result = {};
  for (final tx in txs) {
    result[tx.category] = (result[tx.category] ?? 0) + tx.amount;
  }
  return result;
}

/// Group transactions by a single tag (decision: count each tx once per tag).
/// Returns { "Movies": 120.0, "Games": 75.0, ... }
Map<String, double> totalByTag(List<Transaction> txs) {
  final Map<String, double> result = {};
  for (final tx in txs) {
    for (final tag in tx.tags) {
      result[tag.name] = (result[tag.name] ?? 0) + tx.amount;
    }
  }
  return result;
}

/// Get mood distribution as percentages (or counts).
/// E.g. { happy: 5, sad: 2, neutral: 3 }
Map<Mood, int> moodCounts(List<Transaction> txs) {
  final Map<Mood, int> counts = {};
  for (final tx in txs) {
    final m = tx.mood ?? Mood.neutral;
    counts[m] = (counts[m] ?? 0) + 1;
  }
  return counts;
}

/// Compute average spending per category (only expenses).
Map<String, double> averageExpenseByCategory(List<Transaction> txs) {
  final Map<String, double> sumMap = {};
  final Map<String, int> countMap = {};
  for (final tx in txs.where((t) => !t.isIncome)) {
    sumMap[tx.category] = (sumMap[tx.category] ?? 0) + tx.amount;
    countMap[tx.category] = (countMap[tx.category] ?? 0) + 1;
  }
  final Map<String, double> avgMap = {};
  for (final cat in sumMap.keys) {
    avgMap[cat] = sumMap[cat]! / (countMap[cat] ?? 1);
  }
  return avgMap;
}

/// Percentage of recurring vs one-time transactions:
Map<String, int> recurringVsOneTime(List<Transaction> txs) {
  int recurringCount = 0, oneTimeCount = 0;
  for (final tx in txs) {
    if (tx.recurring) {
      recurringCount++;
    } else {
      oneTimeCount++;
    }
  }
  return {
    'Recurring': recurringCount,
    'One-Time': oneTimeCount,
  };
} 