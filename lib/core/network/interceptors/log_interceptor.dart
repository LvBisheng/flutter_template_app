import 'package:dio/dio.dart';

import '../../logging/app_logger.dart';

/// ─────────────────────────────────────────────────────────────────────
/// 业务日志拦截器。
/// ─────────────────────────────────────────────────────────────────────
///
/// 【职责】
/// 记录 HTTP 请求的轻量级日志。
///
/// 【与 TalkerDioLogger 的区别】
/// - TalkerDioLogger：详细日志（请求/响应头、数据、耗时）
/// - AppLogInterceptor：轻量日志（仅记录请求和失败）
///
/// 【设计原因】
/// TalkerDioLogger 已经记录完整 http-error，这里只保留一条轻量业务日志，
/// 避免同一个网络失败在 Talker Error 页面里重复刷屏。
///
class AppLogInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    appLogger.d('HTTP ${options.method} ${options.uri}');
    handler.next(options);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    appLogger.w(
      'HTTP ${err.requestOptions.method} ${err.requestOptions.uri} failed',
    );
    handler.next(err);
  }
}
