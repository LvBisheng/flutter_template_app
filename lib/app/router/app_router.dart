import 'package:flutter/material.dart';
import 'package:flutter_enterprise_starter/features/settings/routing/settings_routes.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:talker_flutter/talker_flutter.dart';

import '../../capabilities/auth/session_manager.dart';
import '../../core/logging/app_logger.dart';
import '../../features/announcement/routing/announcement_routes.dart';
import '../../features/auth/routing/auth_routes.dart';
import '../../features/customer/routing/customer_routes.dart';
import '../../features/demo/routing/demo_routes.dart';
import '../../features/riverpod_demo/routing/riverpod_demo_routes.dart';
import '../../features/diagnostics/presentation/runtime_error_controller.dart';
import '../../features/home/routing/home_routes.dart';
import '../../features/result/routing/result_routes.dart';
import '../../shared/routing/app_route_stack.dart';
import 'feature_route.dart';
import 'route_guard.dart';

// ═══════════════════════════════════════════════════════════════════════
// 全局 Navigator Key
// ═══════════════════════════════════════════════════════════════════════

final rootNavigatorKey = GlobalKey<NavigatorState>();

// ═══════════════════════════════════════════════════════════════════════
// 所有 Feature 路由注册表
// ═══════════════════════════════════════════════════════════════════════

/// 所有 Feature 路由定义。
///
/// 【架构说明】
/// - HomeRoutes：StatefulShell 路由（Tab 页面）
/// - 其他 Routes：独立路由（无底部导航栏）
///
/// 【扩展方式】
/// 新增 Feature 时，在此列表中添加对应的 XxxRoutes.instance 即可。
/// 认证守卫和路由表都从这个列表自动生成。
final _allFeatureRoutes = <FeatureRoute>[
  // StatefulShell 路由（必须放在第一位）
  HomeRoutes.instance,

  // 独立路由
  AnnouncementRoutes.instance,
  AuthRoutes.instance,
  CustomerRoutes.instance,
  DemoRoutes.instance,
  ResultRoutes.instance,
  RiverpodDemoRoutes.instance,
  SettingsRoutes.instance,
];

// ═══════════════════════════════════════════════════════════════════════
// 路由 Provider
// ═══════════════════════════════════════════════════════════════════════

/// 应用路由配置。
///
/// 【架构说明】
/// 采用 Feature-based 路由架构：
/// - 所有 Feature 通过 FeatureRoute 接口暴露路由
/// - HomeRoutes 包含 StatefulShellRoute（Tab 页面）
/// - 其他 Feature 都是独立路由（无底部导航栏）
/// - 认证守卫和路由表统一从 _allFeatureRoutes 生成
///
/// 【扩展方式】
/// 新增 Feature 时：
/// 1. 创建 XxxRoutes 类实现 FeatureRoute 接口
/// 2. 在 _allFeatureRoutes 中注册
/// 3. 无需修改其他代码
///
final appRouterProvider = Provider<GoRouter>((ref) {
  final loggedIn = ref.watch(sessionManagerProvider).isLoggedIn;
  appRouteStackObserver.reset();

  return GoRouter(
    navigatorKey: rootNavigatorKey,
    initialLocation: loggedIn
        ? HomeRoutes.defaultTabPath
        : AuthRoutes.loginPath,

    // ───────────────────────────────────────────────────────────────────
    // 全局重定向逻辑（认证守卫）
    // ───────────────────────────────────────────────────────────────────
    redirect: (context, state) {
      final path = state.uri.path;

      // 未登录访问受保护路由 → 重定向到登录页
      if (!loggedIn && isProtectedRoute(path, _allFeatureRoutes)) {
        return AuthRoutes.loginPath;
      }

      // 已登录访问登录页 → 重定向到首页
      if (loggedIn && path == AuthRoutes.loginPath) {
        return HomeRoutes.demosPath;
      }

      // 访问 /home 根路径 → 重定向到默认 Tab
      if (path == HomeRoutes.homePath) {
        return HomeRoutes.defaultTabPath;
      }

      return null;
    },

    // ───────────────────────────────────────────────────────────────────
    // 路由表（自动聚合所有 Feature 路由）
    // ───────────────────────────────────────────────────────────────────
    routes: [for (final r in _allFeatureRoutes) ...r.routes],

    observers: [appRouteStackObserver, TalkerRouteObserver(appTalker)],

    errorBuilder: (context, state) {
      final error = state.error;
      if (error != null) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          ref
              .read(runtimeErrorControllerProvider.notifier)
              .captureRouter(error, StackTrace.current);
        });
      }
      return Scaffold(body: Center(child: Text(error.toString())));
    },
  );
});
