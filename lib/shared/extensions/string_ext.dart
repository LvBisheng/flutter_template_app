import '../utils/string_utils.dart';

extension StringExt on String? {
  bool get isBlank => StringUtils.isBlank(this);
  String get orDash => StringUtils.orDash(this);
}
