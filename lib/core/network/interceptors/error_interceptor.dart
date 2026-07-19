import 'package:dio/dio.dart';

import '../app_exception.dart';

/// ─────────────────────────────────────────────────────────────────────
/// 错误拦截器。
/// ─────────────────────────────────────────────────────────────────────
///
/// 【职责】
/// 将 Dio 的原始错误转换为 AppException，统一错误格式。
///
/// 【设计原因】
/// Dio 的错误类型较多（网络超时、连接失败、HTTP 错误等），
/// 直接在业务代码处理会很繁琐。统一转换为 AppException 后，
/// 业务代码只需捕获 AppException 即可。
///
class ErrorInterceptor extends Interceptor {
  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    handler.reject(
      DioException(
        requestOptions: err.requestOptions,
        error: AppException(err.message ?? '网络请求失败'),
      ),
    );
  }
}
