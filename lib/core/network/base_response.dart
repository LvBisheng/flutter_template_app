import 'app_exception.dart';

/// ─────────────────────────────────────────────────────────────────────
/// 后端统一响应格式。
/// ─────────────────────────────────────────────────────────────────────
///
/// 【响应结构】
/// ```json
/// {
///   "code": "0000",      // 状态码，'0000' 表示成功
///   "message": "success", // 状态信息
///   "data": { ... }       // 业务数据
/// }
/// ```
///
/// 【设计说明】
/// 与后端约定统一的响应格式，简化错误处理逻辑：
/// - 成功：code = '0000'
/// - 失败：code 非 '0000'，message 包含错误描述
///
class BaseResponse<T> {
  const BaseResponse({
    required this.code,
    required this.message,
    required this.data,
  });

  /// 状态码，'0000' 表示成功。
  final String code;

  /// 状态信息，成功/失败的描述。
  final String message;

  /// 业务数据。
  final T data;

  /// 从 JSON 解析响应。
  ///
  /// 【默认值】
  /// - code 默认 '9999'（未知错误）
  /// - message 默认 'unknown'
  factory BaseResponse.fromJson(Map<String, dynamic> json) {
    return BaseResponse<T>(
      code: json['code'] as String? ?? '9999',
      message: json['message'] as String? ?? 'unknown',
      data: json['data'] as T,
    );
  }

  /// 检查响应是否成功。
  ///
  /// 【异常】
  /// 如果 code 非 '0000'，抛出 AppException。
  void ensureSuccess() {
    if (code != '0000') throw AppException(message, code: code);
  }
}
