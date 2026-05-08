import '../utils/app_date_utils.dart';

extension DateTimeExt on DateTime? {
  String get ymd => AppDateUtils.formatDate(this);
  String get ymdHm => AppDateUtils.formatDateTime(this);
}
