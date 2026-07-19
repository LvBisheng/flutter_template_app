import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../app/router/feature_route.dart';
import '../../announcement/routing/announcement_routes.dart';
import '../../demo/routing/demo_routes.dart';
import '../../settings/routing/settings_routes.dart';
import '../presentation/home_shell_page.dart';

/// ─────────────────────────────────────────────────────────────────────
/// HomeRoutes - 首页 Shell 路由定义。
/// ─────────────────────────────────────────────────────────────────────
///
/// 【职责】
/// 定义首页 StatefulShellRoute（底部导航容器）的配置。
///
/// 【设计说明】
/// HomeRoutes 负责：
/// 1. 定义 StatefulShellRoute（底部导航容器）
/// 2. 聚合 Tab 子路由（Demos、Me）
/// 3. 不包含具体的页面实现，由各 Feature 自己管理
///
/// 【StatefulShellRoute 说明】
/// StatefulShellRoute.indexedStack 用于实现底部导航栏：
/// - 每个 Tab 拥有独立 Navigator
/// - Tab 页面常驻，切换时保留状态
/// - 行为更接近 iOS UITabBarController / Android BottomNavigation
///
/// 【关于 Tab 页面】
/// 只有 Tab 页面放在 StatefulShellRoute 中（/home/announcements、/home/demos、/home/me）。
/// 其他所有页面（详情页、设置页、登录页等）都是独立路由，
/// 通过 push 导航，无底部导航栏。
///
class HomeRoutes extends FeatureRoute {
  HomeRoutes._();
  static final instance = HomeRoutes._();

  // ═══════════════════════════════════════════════════════════════════
  // 路径常量
  // ═══════════════════════════════════════════════════════════════════

  /// 首页根路径。
  ///
  /// 【注意】
  /// 访问 `/home` 会重定向到默认 Tab（demos），
  /// 因为 `/home` 本身没有内容。
  static const homePath = '/home';

  /// 公告列表 Tab 路径。
  ///
  /// 这是默认 Tab，访问 `/home` 会重定向到这里。
  static const announcementsPath = '/home/announcements';

  /// Demo Hub Tab 路径。
  static const demosPath = '/home/demos';

  /// "我的" Tab 路径。
  static const mePath = '/home/me';

  /// 默认 Tab 路由（重定向目标）。
  static const defaultTabPath = demosPath;

  // ═══════════════════════════════════════════════════════════════════
  // FeatureRoute 实现

  @override
  String get featureName => 'home';

  /// 默认 Tab 路由（供外部引用）。
  String? get initialRoute => defaultTabPath;

  @override
  List<RouteBase> get routes => [
    // StatefulShellRoute 用于底部导航（只包含 Tab 页面）
    StatefulShellRoute.indexedStack(
      builder: _shellBuilder,
      branches: [
        StatefulShellBranch(
          routes: [
            // 公告列表 Tab（首页，默认 Tab）
            GoRoute(
              path: announcementsPath,
              name: AnnouncementRoutes.announcementsName,
              builder: (context, state) => AnnouncementRoutes.buildPage(),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            // Demo Hub Tab
            GoRoute(
              path: demosPath,
              name: DemoRoutes.demosName,
              builder: (context, state) => DemoRoutes.buildPage(),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            // "我的" Tab
            GoRoute(
              path: mePath,
              name: SettingsRoutes.meName,
              builder: (context, state) => SettingsRoutes.buildTabPage(),
            ),
          ],
        ),
      ],
    ),
  ];

  /// Shell 构建器 - 提供 HomeShellPage 包装。
  ///
  /// 所有 Tab 子路由都会被 HomeShellPage 包裹，
  /// 从而共享同一个底部导航栏。
  Widget _shellBuilder(
    BuildContext context,
    GoRouterState state,
    StatefulNavigationShell navigationShell,
  ) {
    return HomeShellPage(navigationShell: navigationShell);
  }
}
