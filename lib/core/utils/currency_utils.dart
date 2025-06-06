import 'package:intl/intl.dart';

class CurrencyUtils {
  static final _currencyFormat = NumberFormat.currency(
    symbol: '\$',
    decimalDigits: 2,
  );

  static String formatAmount(double amount) {
    return _currencyFormat.format(amount);
  }

  static String formatAmountNoDecimals(double amount) {
    return _currencyFormat.format(amount).replaceAll(RegExp(r'\.00$'), '');
  }

  static double? parseAmount(String value) {
    try {
      return double.parse(value.replaceAll(RegExp(r'[^\d.]'), ''));
    } catch (e) {
      return null;
    }
  }

  static bool isValidAmount(String value) {
    final amount = parseAmount(value);
    return amount != null && amount > 0;
  }
} 