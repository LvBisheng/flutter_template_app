import 'package:go_router/go_router.dart';

import '../../../app/router/feature_route.dart';
import '../login/presentation/login_page.dart';

/// ─────────────────────────────────────────────────────────────────────
/// AuthRoutes - 认证模块路由定义。
/// ─────────────────────────────────────────────────────────────────────
///
/// 【职责】
/// 定义认证相关的路由配置：
/// - 登录页路径常量
/// - 页面构建
///
/// 【架构位置】
/// AuthRoutes 是 Feature-based 路由架构的一部分，被 app_router.dart 聚合。
///
class AuthRoutes extends FeatureRoute {
  AuthRoutes._();
  static final instance = AuthRoutes._();

  // ═══════════════════════════════════════════════════════════════════
  // 路径常量
  // ═══════════════════════════════════════════════════════════════════

  /// 登录页路径。
  ///
  /// 访问方式：`context.go(AuthRoutes.loginPath)`
  static const loginPath = '/login';

  /// 登录页路由名。
  static const loginName = 'auth.login';

  // ═══════════════════════════════════════════════════════════════════
  // FeatureRoute 实现
  // ═══════════════════════════════════════════════════════════════════

  @override
  String get featureName => 'auth';

  @override
  bool get requiresAuth => false; // 登录页不需要认证

  @override
  List<RouteBase> get routes => [
    GoRoute(
      path: loginPath,
      name: loginName,
      builder: (context, state) => const LoginPage(),
    ),
  ];
}
