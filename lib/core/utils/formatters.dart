import 'package:intl/intl.dart';

/// Utility class for formatting values
class Formatters {
  static final _currencyFormat = NumberFormat.currency(
    symbol: '\$',
    decimalDigits: 2,
  );
  
  static final _compactCurrencyFormat = NumberFormat.compactCurrency(
    symbol: '\$',
    decimalDigits: 2,
  );
  
  static final _numberFormat = NumberFormat.decimalPattern();
  
  /// Format price with appropriate precision
  static String formatPrice(double? price) {
    if (price == null) return '\$0.00';
    
    if (price < 0.01) {
      return '\$${price.toStringAsFixed(6)}';
    } else if (price < 1) {
      return '\$${price.toStringAsFixed(4)}';
    } else if (price < 1000) {
      return _currencyFormat.format(price);
    } else {
      return _compactCurrencyFormat.format(price);
    }
  }
  
  /// Format large numbers (market cap, volume)
  static String formatLargeNumber(double? number) {
    if (number == null) return '\$0';
    return _compactCurrencyFormat.format(number);
  }
  
  /// Format percentage change
  static String formatPercentChange(double? percent) {
    if (percent == null) return '0.00%';
    final sign = percent >= 0 ? '+' : '';
    return '$sign${percent.toStringAsFixed(2)}%';
  }
  
  /// Format supply numbers
  static String formatSupply(double? supply) {
    if (supply == null) return 'N/A';
    return _numberFormat.format(supply.round());
  }
  
  /// Format date
  static String formatDate(DateTime date) {
    return DateFormat('MMM dd, yyyy').format(date);
  }
  
  /// Format date and time
  static String formatDateTime(DateTime date) {
    return DateFormat('MMM dd, yyyy HH:mm').format(date);
  }
}
