class StringUtils {
  StringUtils._();

  static bool isBlank(String? value) => value == null || value.trim().isEmpty;
  static String maskMobile(String value) => value.length < 7
      ? value
      : '${value.substring(0, 3)}****${value.substring(value.length - 4)}';
  static String maskToken(String value) => value.length < 10
      ? value
      : '${value.substring(0, 6)}...${value.substring(value.length - 4)}';
  static String orDash(String? value) => isBlank(value) ? '-' : value!;
}
