import 'package:intl/intl.dart';

class AppDateUtils {
  AppDateUtils._();

  static String formatDate(DateTime? date) =>
      date == null ? '-' : DateFormat('yyyy-MM-dd').format(date.toLocal());
  static String formatDateTime(DateTime? date) => date == null
      ? '-'
      : DateFormat('yyyy-MM-dd HH:mm').format(date.toLocal());
  static DateTime? tryParse(String? value) =>
      value == null ? null : DateTime.tryParse(value);
}
