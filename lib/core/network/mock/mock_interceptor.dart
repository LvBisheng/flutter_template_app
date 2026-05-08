import 'dart:convert';

import 'package:dio/dio.dart';

import 'mock_config.dart';
import 'mock_routes.dart';

class MockInterceptor extends Interceptor {
  MockInterceptor(this._readConfig);

  final MockConfig Function() _readConfig;

  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    // Mock 是接口级覆盖能力，而不是环境。当前环境仍然决定 baseUrl；
    // 只有命中已开启的 mock 规则时，才在本地返回 raw JSON。
    final config = _readConfig();
    if (!config.masterEnabled) return handler.next(options);

    final key = '${options.method.toUpperCase()} ${options.path}';
    final rule = MockRoutes.routes[key];
    if (rule == null || !config.isRuleEnabled(rule.id)) {
      return handler.next(options);
    }

    await Future<void>.delayed(const Duration(milliseconds: 450));
    handler.resolve(
      Response(
        requestOptions: options,
        statusCode: 200,
        data: jsonDecode(rule.responseBuilder(options.queryParameters)),
      ),
    );
  }
}
