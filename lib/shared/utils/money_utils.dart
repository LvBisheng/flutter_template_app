import 'package:intl/intl.dart';

class MoneyUtils {
  MoneyUtils._();

  static String format(num value) =>
      NumberFormat.currency(symbol: '¥', decimalDigits: 2).format(value);
}
