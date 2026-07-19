/// ─────────────────────────────────────────────────────────────────────
/// API 请求结果封装（sealed class）。
/// ─────────────────────────────────────────────────────────────────────
///
/// 【设计说明】
/// 使用 sealed class 确保结果只有两种状态：成功或失败。
/// 配合模式匹配，可以强制处理所有情况。
///
/// 【使用方式】
/// ```dart
/// final result = await fetchData();
/// switch (result) {
///   case ApiSuccess(data: final data):
///     // 处理成功
///   case ApiFailure(message: final msg):
///     // 处理失败
/// }
/// ```
///
/// 【与 AppException 的区别】
/// - AppException：用于抛出异常，沿用 try-catch 模式
/// - ApiResult：用于返回结果，沿用模式匹配模式
///
sealed class ApiResult<T> {
  const ApiResult();
}

/// API 请求成功。
class ApiSuccess<T> extends ApiResult<T> {
  const ApiSuccess(this.data);

  final T data;
}

/// API 请求失败。
class ApiFailure<T> extends ApiResult<T> {
  const ApiFailure(this.message);

  final String message;
}
