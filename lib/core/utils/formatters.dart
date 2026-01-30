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
  
  /// Format large price without compact notation
  static String formatLargePrice(double? price) {
    if (price == null) return '0.00';
    return NumberFormat('#,##0.00').format(price);
  }
  
  /// Format crypto amount with appropriate precision
  static String formatCryptoAmount(double? amount) {
    if (amount == null) return '0';
    if (amount >= 1000) {
      return NumberFormat('#,##0.00').format(amount);
    } else if (amount >= 1) {
      return amount.toStringAsFixed(4);
    } else if (amount >= 0.0001) {
      return amount.toStringAsFixed(6);
    } else {
      return amount.toStringAsFixed(8);
    }
  }
  
  /// Format time ago
  static String formatTimeAgo(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);
    
    if (difference.inDays > 365) {
      return '${(difference.inDays / 365).floor()}y ago';
    } else if (difference.inDays > 30) {
      return '${(difference.inDays / 30).floor()}mo ago';
    } else if (difference.inDays > 0) {
      return '${difference.inDays}d ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours}h ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes}m ago';
    } else {
      return 'Just now';
    }
  }
}
