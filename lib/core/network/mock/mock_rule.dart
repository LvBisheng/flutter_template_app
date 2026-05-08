import 'mock_auth_json.dart';
import 'mock_customer_json.dart';
import 'mock_diagnostics_json.dart';
import 'mock_identity_json.dart';

typedef MockResponseBuilder = String Function(Map<String, dynamic> query);

/// 一个可被本地 mock 覆盖的接口规则。
///
/// 新增 mock 接口时，只需要在 MockRuleRegistry.rules 中登记 method/path、
/// 展示名称和响应构造函数，开发工具面板会自动出现对应开关。
class MockRule {
  const MockRule({
    required this.id,
    required this.method,
    required this.path,
    required this.name,
    required this.description,
    required this.defaultEnabled,
    required this.responseBuilder,
  });

  final String id;
  final String method;
  final String path;
  final String name;
  final String description;
  final bool defaultEnabled;
  final MockResponseBuilder responseBuilder;

  String get routeKey => '${method.toUpperCase()} $path';
}

class MockRuleRegistry {
  MockRuleRegistry._();

  static final rules = <MockRule>[
    MockRule(
      id: 'auth.login',
      method: 'POST',
      path: '/auth/login',
      name: '登录',
      description: '返回演示 token 和操作员信息',
      defaultEnabled: true,
      responseBuilder: (_) => MockAuthJson.loginSuccess,
    ),
    MockRule(
      id: 'auth.profile',
      method: 'GET',
      path: '/auth/profile',
      name: '用户信息',
      description: '返回演示操作员资料',
      defaultEnabled: true,
      responseBuilder: (_) => MockAuthJson.profileSuccess,
    ),
    MockRule(
      id: 'customer.list',
      method: 'GET',
      path: '/customer/list',
      name: '客户列表',
      description: '返回三条脱敏客户资料',
      defaultEnabled: true,
      responseBuilder: (_) => MockCustomerJson.listSuccess,
    ),
    MockRule(
      id: 'customer.detail',
      method: 'GET',
      path: '/customer/detail',
      name: '客户详情',
      description: '按 customerId 返回对应脱敏详情',
      defaultEnabled: true,
      responseBuilder: (query) => MockCustomerJson.detailSuccessFor(
        query['customerId'] as String? ?? '',
      ),
    ),
    MockRule(
      id: 'customer.update',
      method: 'POST',
      path: '/customer/update',
      name: '客户资料更新',
      description: '返回客户资料更新成功',
      defaultEnabled: true,
      responseBuilder: (_) => MockCustomerJson.updateSuccess,
    ),
    MockRule(
      id: 'identity.update',
      method: 'POST',
      path: '/identity/update',
      name: '证件更新',
      description: '返回证件更新成功',
      defaultEnabled: true,
      responseBuilder: (_) => MockIdentityJson.updateSuccess,
    ),
    MockRule(
      id: 'diagnostics.business_log.upload',
      method: 'POST',
      path: '/diagnostics/business-log/upload',
      name: '业务日志上传',
      description: '接收前端业务追踪日志快照',
      defaultEnabled: true,
      responseBuilder: (_) => MockDiagnosticsJson.uploadBusinessLogSuccess,
    ),
  ];

  static MockRule? findByRouteKey(String routeKey) {
    for (final rule in rules) {
      if (rule.routeKey == routeKey) return rule;
    }
    return null;
  }
}
