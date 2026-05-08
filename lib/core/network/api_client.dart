import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:talker_dio_logger/talker_dio_logger.dart';

import '../../app/env/env_config.dart';
import '../../capabilities/auth/token_manager.dart';
import '../logging/app_logger.dart';
import 'app_exception.dart';
import 'base_response.dart';
import 'interceptors/auth_interceptor.dart';
import 'interceptors/error_interceptor.dart';
import 'interceptors/log_interceptor.dart';
import 'mock/mock_config.dart';
import 'mock/mock_interceptor.dart';

final apiClientProvider = Provider<ApiClient>(
  (ref) => ApiClient(
    ref.read(tokenManagerProvider),
    () => ref.read(envConfigProvider),
    () => ref.read(mockConfigProvider),
  ),
);

class ApiClient {
  ApiClient(this._tokenManager, this._readConfig, this._readMockConfig);

  final TokenManager _tokenManager;
  final EnvConfig Function() _readConfig;
  final MockConfig Function() _readMockConfig;

  Dio _createDio() {
    final config = _readConfig();
    // release 包禁止打开 mock，避免演示数据或假流程被误带到生产包。
    if (kReleaseMode && _readMockConfig().masterEnabled) {
      throw StateError('Interface mock must be disabled in release build.');
    }
    final dio = Dio(
      BaseOptions(
        baseUrl: config.baseUrl,
        connectTimeout: const Duration(seconds: 8),
        receiveTimeout: const Duration(seconds: 8),
      ),
    );
    if (config.switchEnabled) {
      dio.interceptors.add(
        TalkerDioLogger(
          talker: appTalker,
          settings: const TalkerDioLoggerSettings(
            printRequestHeaders: true,
            printRequestData: true,
            printResponseHeaders: false,
            printResponseData: true,
            printResponseMessage: true,
            printResponseTime: true,
            printErrorHeaders: true,
            printErrorData: true,
            printErrorMessage: true,
            hiddenHeaders: {'Authorization', 'authorization'},
          ),
        ),
      );
    }
    dio.interceptors.add(MockInterceptor(_readMockConfig));
    dio.interceptors.addAll([
      AuthInterceptor(_tokenManager),
      AppLogInterceptor(),
      ErrorInterceptor(),
    ]);
    return dio;
  }

  Future<T> get<T>(String path, {Map<String, dynamic>? queryParameters}) async {
    final response = await _createDio().get<Map<String, dynamic>>(
      path,
      queryParameters: queryParameters,
    );
    return _decode<T>(response.data);
  }

  Future<T> post<T>(String path, {Object? data}) async {
    final response = await _createDio().post<Map<String, dynamic>>(
      path,
      data: data,
    );
    return _decode<T>(response.data);
  }

  T _decode<T>(Map<String, dynamic>? json) {
    if (json == null) throw const AppException('响应为空');
    final base = BaseResponse<dynamic>.fromJson(json)..ensureSuccess();
    return base.data as T;
  }
}
