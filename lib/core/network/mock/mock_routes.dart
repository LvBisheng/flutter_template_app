import 'mock_rule.dart';

/// ─────────────────────────────────────────────────────────────────────
/// Mock 路由映射表。
/// ─────────────────────────────────────────────────────────────────────
///
/// 【职责】
/// 将 Mock 规则按 routeKey（'METHOD /path'）映射，便于快速查找。
///
/// 【使用方式】
/// ```dart
/// final rule = MockRoutes.routes['GET /user/profile'];
/// ```
///
class MockRoutes {
  MockRoutes._();

  /// 路由映射表。
  ///
  /// Key: 'METHOD /path'，如 'GET /user/profile'
  /// Value: 对应的 MockRule
  static final routes = {
    for (final rule in MockRuleRegistry.rules) rule.routeKey: rule,
  };
}
