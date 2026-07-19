import 'dart:convert';

import 'package:dio/dio.dart';

import 'mock_config.dart';
import 'mock_routes.dart';

/// ─────────────────────────────────────────────────────────────────────
/// Mock 拦截器。
/// ─────────────────────────────────────────────────────────────────────
///
/// 【职责】
/// 拦截匹配的请求，返回 Mock 数据（开发/测试环境使用）。
///
/// 【设计说明】
/// Mock 是"接口级覆盖能力"，而不是环境：
/// - 当前环境仍然决定 baseUrl
/// - 只有命中已开启的 Mock 规则时，才返回本地 JSON
/// - 其他未配置的接口正常走真实网络请求
///
/// 【流程】
/// 1. 检查 Mock 总开关是否开启
/// 2. 根据 method + path 查找对应的 Mock 规则
/// 3. 检查规则是否启用
/// 4. 命中则返回 Mock 数据（模拟 450ms 延迟）
/// 5. 未命中则继续真实请求
///
/// 【安全】
/// - Release 包强制禁用
/// - PRD 环境强制禁用
///
class MockInterceptor extends Interceptor {
  MockInterceptor(this._readConfig);

  final MockConfig Function() _readConfig;

  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    final config = _readConfig();

    // Mock 总开关未开启，继续真实请求
    if (!config.masterEnabled) return handler.next(options);

    // 查找匹配的 Mock 规则
    final key = '${options.method.toUpperCase()} ${options.path}';
    final rule = MockRoutes.routes[key];

    // 规则不存在或未启用，继续真实请求
    if (rule == null || !config.isRuleEnabled(rule.id)) {
      return handler.next(options);
    }

    // 模拟网络延迟（450ms），让体验更接近真实网络
    await Future<void>.delayed(const Duration(milliseconds: 450));

    // 返回 Mock 数据
    handler.resolve(
      Response(
        requestOptions: options,
        statusCode: 200,
        data: jsonDecode(rule.responseBuilder(options.queryParameters)),
      ),
    );
  }
}
