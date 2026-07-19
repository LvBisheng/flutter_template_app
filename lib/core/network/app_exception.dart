/// ─────────────────────────────────────────────────────────────────────
/// 应用统一异常类。
/// ─────────────────────────────────────────────────────────────────────
///
/// 【职责】
/// 封装应用内的所有异常，统一错误信息格式。
///
/// 【字段说明】
/// - [message]：错误信息，用户可见
/// - [code]：错误码，用于区分错误类型（可选）
///
/// 【使用场景】
/// - 网络请求失败
/// - 业务逻辑错误
/// - 数据校验失败
///
class AppException implements Exception {
  const AppException(this.message, {this.code});

  final String message;
  final String? code;

  @override
  String toString() => code == null ? message : '$code: $message';
}
