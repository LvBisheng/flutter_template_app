import 'package:dio/dio.dart';

import '../../../capabilities/auth/token_manager.dart';

/// ─────────────────────────────────────────────────────────────────────
/// 认证拦截器。
/// ─────────────────────────────────────────────────────────────────────
///
/// 【职责】
/// 自动为请求添加 Authorization 头（Bearer Token）。
///
/// 【流程】
/// 1. 从 TokenManager 读取当前 Token
/// 2. 如果 Token 存在且非空，添加到请求头
/// 3. 继续执行后续拦截器
///
class AuthInterceptor extends Interceptor {
  AuthInterceptor(this._tokenManager);

  final TokenManager _tokenManager;

  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    final token = await _tokenManager.readToken();
    if (token != null && token.isNotEmpty) {
      options.headers['Authorization'] = 'Bearer $token';
    }
    handler.next(options);
  }
}
