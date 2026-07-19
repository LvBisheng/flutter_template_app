import 'package:go_router/go_router.dart';

/// ─────────────────────────────────────────────────────────────────────
/// FeatureRoute - Feature 路由抽象接口。
/// ─────────────────────────────────────────────────────────────────────
///
/// 【设计理念】
/// 每个 Feature 模块实现此接口，定义自己的路由。
/// 主路由通过聚合所有 FeatureRoute 来构建完整路由表。
///
/// 【职责】
/// - 定义 Feature 的路由配置
/// - 提供 Feature 的路径常量
/// - 支持认证配置（可选）
///
/// 【使用示例】
/// ```dart
/// class LoginRoutes extends FeatureRoute {
///   static final instance = LoginRoutes._();
///   LoginRoutes._();
///
///   static const loginPath = '/login';
///
///   @override
///   String get featureName => 'login';
///
///   @override
///   bool get requiresAuth => false;
///
///   @override
///   List<RouteBase> get routes => [
///     GoRoute(path: loginPath, builder: ...),
///   ];
/// }
/// ```
///
/// 【扩展性】
/// 新增 Feature 时：
/// 1. 创建 XxxRoutes 类实现此接口
/// 2. 在 app_router.dart 的 _allFeatureRoutes 中注册
/// 3. 无需修改其他核心代码
///
abstract class FeatureRoute {
  /// Feature 名称（用于调试和日志）。
  String get featureName;

  /// 该 Feature 的路由列表。
  ///
  /// 返回 GoRoute、ShellRoute 或 StatefulShellRoute 列表。
  List<RouteBase> get routes;

  /// 是否需要认证。
  ///
  /// - true（默认）：需要登录才能访问
  /// - false：公开页面（如登录页）
  ///
  /// 路由守卫会根据此属性判断是否重定向到登录页。
  bool get requiresAuth => true;
}
