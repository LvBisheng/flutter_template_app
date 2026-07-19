import 'mock_announcement_json.dart';
import 'mock_auth_json.dart';
import 'mock_customer_json.dart';
import 'mock_diagnostics_json.dart';
import 'mock_identity_json.dart';

/// Mock 响应构建函数。
typedef MockResponseBuilder = String Function(Map<String, dynamic> query);

/// ─────────────────────────────────────────────────────────────────────
/// Mock 规则定义。
/// ─────────────────────────────────────────────────────────────────────
///
/// 【职责】
/// 定义一个可被 Mock 覆盖的接口规则。
///
/// 【新增规则】
/// 只需要在 MockRuleRegistry.rules 中登记：
/// 1. method/path - 接口标识
/// 2. name/description - 显示名称和描述
/// 3. responseBuilder - 响应内容构造函数
///
/// 开发工具面板会自动出现对应开关。
///
/// 【示例】
/// ```dart
/// MockRule(
///   id: 'user.profile',           // 唯一标识
///   method: 'GET',                 // HTTP 方法
///   path: '/user/profile',         // 接口路径
///   name: '用户信息',              // 显示名称
///   description: '返回演示用户资料', // 描述
///   defaultEnabled: true,          // 默认是否启用
///   responseBuilder: (_) => MockUserData.profile,  // 响应内容
/// )
/// ```
///
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

  /// 规则唯一标识。
  final String id;

  /// HTTP 方法（GET/POST 等）。
  final String method;

  /// 接口路径。
  final String path;

  /// 显示名称（用于开发工具面板）。
  final String name;

  /// 规则描述（用于开发工具面板）。
  final String description;

  /// 是否默认启用。
  final bool defaultEnabled;

  /// 响应内容构建函数。
  final MockResponseBuilder responseBuilder;

  /// 路由键（用于快速匹配）。
  String get routeKey => '${method.toUpperCase()} $path';
}

/// ─────────────────────────────────────────────────────────────────────
/// Mock 规则注册表。
/// ─────────────────────────────────────────────────────────────────────
///
/// 【职责】
/// 管理所有 Mock 规则，提供查找功能。
///
class MockRuleRegistry {
  MockRuleRegistry._();

  /// 所有已注册的 Mock 规则。
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
    MockRule(
      id: 'announcement.list',
      method: 'GET',
      path: '/announcement/list',
      name: '公告列表',
      description: '返回公告列表（演示每次进入刷新）',
      defaultEnabled: true,
      responseBuilder: (_) => MockAnnouncementJson.list,
    ),
  ];

  /// 根据路由键查找规则。
  static MockRule? findByRouteKey(String routeKey) {
    for (final rule in rules) {
      if (rule.routeKey == routeKey) return rule;
    }
    return null;
  }
}
