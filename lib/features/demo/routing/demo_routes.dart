import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../app/router/feature_route.dart';
import '../presentation/business_log_demo_page.dart';
import '../presentation/demo_hub_page.dart';

/// ─────────────────────────────────────────────────────────────────────
/// DemoRoutes - Demo 功能模块路由定义。
/// ─────────────────────────────────────────────────────────────────────
///
/// 【职责】
/// 定义 Demo Hub 及其子页面的路由配置。
///
/// 【路由说明】
/// - `/home/demos`: Demo Hub Tab 页面（由 HomeRoutes 的 StatefulShellRoute 调用）
/// - `/home/demos/business-log`: 业务日志 Demo（独立页面，无底部导航栏）
///
/// 【关于 Tab 页面】
/// Tab 页面通过 `buildPage()` 构建，由 HomeRoutes 的 StatefulShellRoute 调用。
/// 独立页面通过 `routes` 暴露，注册到 app_router.dart。
///
class DemoRoutes extends FeatureRoute {
  DemoRoutes._();
  static final instance = DemoRoutes._();

  // ═══════════════════════════════════════════════════════════════════
  // 路径常量
  // ═══════════════════════════════════════════════════════════════════

  /// Demo Hub Tab 页面路径。
  ///
  /// 这个页面在 StatefulShellRoute 中显示，有底部导航栏。
  /// 由 HomeRoutes 的 StatefulShellRoute 调用。
  static const demosPath = '/home/demos';

  /// Demo Hub Tab 路由名。
  static const demosName = 'demo.hub';

  /// 业务日志 Demo 路径。
  ///
  /// 这个页面是独立路由，无底部导航栏。
  static const businessLogDemoPath = '/home/demos/business-log';

  /// 业务日志 Demo 路由名。
  static const businessLogDemoName = 'demo.businessLog';

  // ═══════════════════════════════════════════════════════════════════
  // Tab 页面构建
  // ═══════════════════════════════════════════════════════════════════

  /// 构建 Tab 页面（由 HomeRoutes 的 StatefulShellRoute 调用）。
  static Widget buildPage() => const DemoHubPage();

  // ═══════════════════════════════════════════════════════════════════
  // FeatureRoute 实现（独立路由）
  // ═══════════════════════════════════════════════════════════════════

  @override
  String get featureName => 'demo';

  /// 独立路由（不在 Shell 中显示）。
  ///
  /// 这些页面通过 push 导航，没有底部导航栏。
  @override
  List<RouteBase> get routes => [
    GoRoute(
      path: businessLogDemoPath,
      name: businessLogDemoName,
      builder: (context, state) => const BusinessLogDemoPage(),
    ),
  ];
}
