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
    appLogger.e(err.message, error: err);
    handler.next(err);
  }
}
