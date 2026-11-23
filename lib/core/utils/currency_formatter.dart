import 'package:intl/intl.dart';

class CurrencyFormatter {
  static final NumberFormat _formatter = NumberFormat('#,##0', 'en_US');

  /// Formats amount in Pakistani Rupees, e.g. Rs. 48,750
  static String format(num amount) {
    return 'Rs. ${_formatter.format(amount)}';
  }

  /// Formats amount with sign, e.g. +Rs. 31,520 or -Rs. 5,000
  static String formatWithSign(num amount) {
    if (amount > 0) {
      return '+Rs. ${_formatter.format(amount)}';
    } else if (amount < 0) {
      return '-Rs. ${_formatter.format(amount.abs())}';
    }
    return 'Rs. 0';
  }

  /// Compact representation e.g. Rs. 1.2M
  static String formatCompact(num amount) {
    if (amount >= 1000000) {
      return 'Rs. ${(amount / 1000000).toStringAsFixed(1)}M';
    } else if (amount >= 1000) {
      return 'Rs. ${(amount / 1000).toStringAsFixed(1)}k';
    }
    return format(amount);
  }
}

