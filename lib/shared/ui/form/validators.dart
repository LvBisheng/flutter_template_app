import '../../utils/regex_utils.dart';
import '../../utils/string_utils.dart';

class Validators {
  Validators._();

  static String? required(String? value, String label) =>
      StringUtils.isBlank(value) ? '请输入$label' : null;
  static String? email(String value) =>
      RegexUtils.isEmail(value) ? null : '邮箱格式不正确';
  static String? mobile(String value) =>
      RegexUtils.isMobile(value) ? null : '手机号格式不正确';
}
