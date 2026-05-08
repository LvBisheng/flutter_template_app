import 'package:dio/dio.dart';

import '../app_exception.dart';

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
