import 'package:dio/dio.dart';

import '../../../capabilities/auth/token_manager.dart';

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
