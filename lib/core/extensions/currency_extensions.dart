import 'package:intl/intl.dart';

/// Extension methods for double class for currency operations
extension CurrencyExtensions on double {
  /// Format the number as currency
  String toCurrency({
    String symbol = '\$',
    int decimalPlaces = 2,
  }) {
    final formatter = NumberFormat.currency(
      symbol: symbol,
      decimalDigits: decimalPlaces,
    );
    return formatter.format(this);
  }

  /// Format the number as percentage
  String toPercentage({
    int decimalPlaces = 1,
  }) {
    final formatter = NumberFormat.percentPattern()
      ..maximumFractionDigits = decimalPlaces;
    return formatter.format(this / 100);
  }

  /// Round to the nearest cent
  double get roundToCents => (this * 100).round() / 100;

  /// Calculate tax amount
  double calculateTax(double taxRate) {
    return (this * (taxRate / 100)).roundToCents;
  }

  /// Calculate total with tax
  double calculateTotalWithTax(double taxRate) {
    return (this + calculateTax(taxRate)).roundToCents;
  }

  /// Calculate percentage of total
  double calculatePercentageOf(double total) {
    if (total == 0) return 0;
    return (this / total) * 100;
  }

  /// Format as compact currency (e.g., 1.2K, 1.2M)
  String toCompactCurrency({
    String symbol = '\$',
    int decimalPlaces = 1,
  }) {
    if (this < 1000) {
      return toCurrency(symbol: symbol, decimalPlaces: decimalPlaces);
    } else if (this < 1000000) {
      return '$symbol${(this / 1000).toStringAsFixed(decimalPlaces)}K';
    } else {
      return '$symbol${(this / 1000000).toStringAsFixed(decimalPlaces)}M';
    }
  }
} 