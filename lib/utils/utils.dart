import 'package:intl/intl.dart';

class Utils {
  static String formatCurrency(num value) {
    final formatter = NumberFormat.currency(
      locale: 'en_IN',
      symbol: '₹',
      decimalDigits: 2,
    );
    return formatter.format(
      value.toDouble().abs(),
    ); // Convert to double and handle negatives
  }
}
