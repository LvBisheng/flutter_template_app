class RegexUtils {
  RegexUtils._();

  static final _email = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');
  static final _mobile = RegExp(r'^1\d{10}$');

  static bool isEmail(String value) => _email.hasMatch(value);
  static bool isMobile(String value) => _mobile.hasMatch(value);
}
