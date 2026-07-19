/// ─────────────────────────────────────────────────────────────────────
/// 通用输入校验工具。
/// ─────────────────────────────────────────────────────────────────────
///
/// 【职责】
/// 提供纯函数校验逻辑，不依赖 Repository，可跨模块复用。
///
/// 【返回值】
/// 返回 bool 或枚举，由调用方决定显示什么国际化文案。
/// - true / ValidationResult.valid：校验通过
/// - false / ValidationResult.xxx：校验失败，具体原因由枚举表示
///
/// 【为什么不含错误文案？】
/// - 文案需要国际化（多语言）
/// - 校验逻辑是纯函数，不应该知道 UI 显示什么
/// - 由 Controller/Page 根据校验结果决定显示什么文案
///
/// ─────────────────────────────────────────────────────────────────────

library;

/// 校验结果枚举。
///
/// 用于表示校验失败的具体原因，由调用方翻译为国际化文案。
enum UsernameValidationResult {
  /// 校验通过
  valid,

  /// 为空
  empty,

  /// 包含非法字符
  invalidCharacters,

  /// 长度不足
  tooShort,

  /// 长度超限
  tooLong,
}

/// 密码校验结果枚举。
enum PasswordValidationResult {
  /// 校验通过
  valid,

  /// 为空
  empty,

  /// 长度不足
  tooShort,

  /// 长度超限
  tooLong,
}

/// 用户名校验。
///
/// [value] 要校验的字符串
/// [minLength] 最小长度（默认 4）
/// [maxLength] 最大长度（默认 20）
/// [pattern] 允许的字符正则（默认只允许英文数字下划线）
///
/// 返回校验结果枚举，由调用方决定显示什么文案。
UsernameValidationResult validateUsername(
  String? value, {
  int minLength = 4,
  int maxLength = 20,
  RegExp? pattern,
}) {
  if (value == null || value.trim().isEmpty) {
    return UsernameValidationResult.empty;
  }

  final trimmed = value.trim();

  // 检查长度
  if (trimmed.length < minLength) {
    return UsernameValidationResult.tooShort;
  }
  if (trimmed.length > maxLength) {
    return UsernameValidationResult.tooLong;
  }

  // 检查字符（默认只允许英文、数字、下划线）
  final regex = pattern ?? RegExp(r'^[a-zA-Z0-9_]+$');
  if (!regex.hasMatch(trimmed)) {
    return UsernameValidationResult.invalidCharacters;
  }

  return UsernameValidationResult.valid;
}

/// 密码校验。
///
/// [value] 要校验的字符串
/// [minLength] 最小长度（默认 6）
/// [maxLength] 最大长度（默认 32）
///
/// 返回校验结果枚举，由调用方决定显示什么文案。
PasswordValidationResult validatePassword(
  String? value, {
  int minLength = 6,
  int maxLength = 32,
}) {
  if (value == null || value.isEmpty) {
    return PasswordValidationResult.empty;
  }

  if (value.length < minLength) {
    return PasswordValidationResult.tooShort;
  }
  if (value.length > maxLength) {
    return PasswordValidationResult.tooLong;
  }

  return PasswordValidationResult.valid;
}

/// 通用非空校验。
bool isNotEmpty(String? value) => value != null && value.trim().isNotEmpty;

/// 通用邮箱格式校验。
bool isValidEmail(String? value) {
  if (value == null || value.isEmpty) return false;
  return RegExp(r'^[\w.-]+@[\w.-]+\.\w+$').hasMatch(value);
}

/// 通用手机号格式校验（中国大陆）。
bool isValidMobile(String? value) {
  if (value == null || value.isEmpty) return false;
  return RegExp(r'^1\d{10}$').hasMatch(value);
}
