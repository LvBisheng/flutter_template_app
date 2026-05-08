import 'package:dio/dio.dart';

import '../../logging/app_logger.dart';

class AppLogInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    appLogger.d('HTTP ${options.method} ${options.uri}');
    handler.next(options);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    // TalkerDioLogger 已经记录完整 http-error，这里只保留一条轻量业务日志，
    // 避免同一个网络失败在 Talker Error 页面里重复刷屏。
    appLogger.w(
      'HTTP ${err.requestOptions.method} ${err.requestOptions.uri} failed',
    );
    handler.next(err);
  }
}
