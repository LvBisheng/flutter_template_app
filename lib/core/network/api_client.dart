import 'package:dio/dio.dart';
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

/// ─────────────────────────────────────────────────────────────────────
/// ApiClient Provider。
/// ─────────────────────────────────────────────────────────────────────
///
/// 【依赖注入】
/// 通过 Provider 注入，确保全局单例。
/// 依赖：TokenManager（认证）、EnvConfig（环境配置）、MockConfig（Mock 配置）。
///
final apiClientProvider = Provider<ApiClient>(
  (ref) => ApiClient(
    ref.read(tokenManagerProvider),
    () => ref.read(envConfigProvider),
    () => ref.read(mockConfigProvider),
  ),
);

/// ─────────────────────────────────────────────────────────────────────
/// 统一网络请求客户端（基于 Dio）。
/// ─────────────────────────────────────────────────────────────────────
///
/// 【职责】
/// 1. 封装 Dio，提供统一的 GET/POST 方法
/// 2. 自动注入认证 Token（通过 AuthInterceptor）
/// 3. 统一处理响应格式（BaseResponse）
/// 4. 支持 Mock 拦截（开发调试用）
///
/// 【拦截器链】（按顺序执行）
/// 1. TalkerDioLogger - 日志记录（开发环境）
/// 2. MockInterceptor - Mock 拦截（开发/测试环境）
/// 3. AuthInterceptor - Token 注入
/// 4. AppLogInterceptor - 业务日志
/// 5. ErrorInterceptor - 统一错误处理
///
/// 【响应格式】
/// 后端统一返回 BaseResponse 格式：
/// ```json
/// {
///   "code": "0000",
///   "message": "success",
///   "data": { ... }
/// }
/// ```
///
/// 【使用方式】
/// ```dart
/// final client = ref.read(apiClientProvider);
/// final data = await client.get<UserData>('/user/profile');
/// final result = await client.post<Result>('/user/update', data: {...});
/// ```
///
class ApiClient {
  ApiClient(this._tokenManager, this._readConfig, this._readMockConfig);

  final TokenManager _tokenManager;
  final EnvConfig Function() _readConfig;
  final MockConfig Function() _readMockConfig;

  /// 创建 Dio 实例（每次请求都创建新实例）。
  ///
  /// 【为什么每次创建？】
  /// 因为配置可能运行时变化（如 Mock 开关），每次创建确保使用最新配置。
  /// Dio 本身轻量，频繁创建不会造成性能问题。
  Dio _createDio() {
    final config = _readConfig();
    final mockConfig = _readMockConfig();

    // 安全检查：非开发模式不允许启用 Mock
    if (!config.isDevMode && mockConfig.masterEnabled) {
      throw StateError('Mock must be disabled in production build.');
    }

    final dio = Dio(
      BaseOptions(
        baseUrl: config.baseUrl,
        connectTimeout: const Duration(seconds: 8),
        receiveTimeout: const Duration(seconds: 8),
      ),
    );

    // 开发环境添加 Talker 日志拦截器
    if (config.isDevMode) {
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
            hiddenHeaders: {'Authorization', 'authorization'},  // 隐藏敏感头
          ),
        ),
      );
    }

    // 添加拦截器（按顺序执行）
    dio.interceptors.add(MockInterceptor(_readMockConfig));
    dio.interceptors.addAll([
      AuthInterceptor(_tokenManager),  // Token 注入
      AppLogInterceptor(),              // 业务日志
      ErrorInterceptor(),               // 错误处理
    ]);

    return dio;
  }

  /// GET 请求。
  ///
  /// [path] 接口路径，如 `/user/profile`
  /// [queryParameters] 查询参数
  /// [fromJson] JSON 转换函数（用于 Model 类）
  ///
  /// 【返回值】
  /// - 传入 [fromJson]：返回转换后的 Model 对象
  /// - 不传 [fromJson]：返回原始数据（Map/List/基本类型）
  ///
  /// 【使用示例】
  /// ```dart
  /// // 返回 Model 对象
  /// final user = await client.get<User>('/user/profile', fromJson: User.fromJson);
  ///
  /// // 返回列表（元素需要手动转换）
  /// final list = await client.get<List<dynamic>>('/user/list');
  /// final users = list.map((e) => User.fromJson(e as Map)).toList();
  ///
  /// // 返回简单类型
  /// final name = await client.get<String>('/user/name');
  /// ```
  ///
  Future<T> get<T>(
    String path, {
    Map<String, dynamic>? queryParameters,
    T Function(Map<String, dynamic>)? fromJson,
  }) async {
    final response = await _createDio().get<Map<String, dynamic>>(
      path,
      queryParameters: queryParameters,
    );
    return _decode<T>(response.data, fromJson);
  }

  /// POST 请求。
  ///
  /// [path] 接口路径，如 `/user/update`
  /// [data] 请求体数据
  /// [fromJson] JSON 转换函数（用于 Model 类）
  ///
  /// 【返回值】
  /// - 传入 [fromJson]：返回转换后的 Model 对象
  /// - 不传 [fromJson]：返回原始数据
  ///
  Future<T> post<T>(
    String path, {
    Object? data,
    T Function(Map<String, dynamic>)? fromJson,
  }) async {
    final response = await _createDio().post<Map<String, dynamic>>(
      path,
      data: data,
    );
    return _decode<T>(response.data, fromJson);
  }

  /// 解码响应数据。
  ///
  /// 【流程】
  /// 1. 检查响应是否为空
  /// 2. 解析为 BaseResponse
  /// 3. 检查 code 是否为 '0000'（成功）
  /// 4. 返回 data 字段（支持自动转换）
  ///
  T _decode<T>(
    Map<String, dynamic>? json,
    T Function(Map<String, dynamic>)? fromJson,
  ) {
    if (json == null) throw const AppException('响应为空');
    final base = BaseResponse<dynamic>.fromJson(json)..ensureSuccess();

    final data = base.data;

    // 传了 fromJson，自动转换
    if (fromJson != null && data is Map<String, dynamic>) {
      return fromJson(data);
    }

    // 没传 fromJson，直接强转
    return data as T;
  }
}
