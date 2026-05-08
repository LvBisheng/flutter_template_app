import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:talker_flutter/talker_flutter.dart';

import '../../capabilities/auth/session_manager.dart';
import '../../core/logging/app_logger.dart';
import '../../features/customer_detail/presentation/customer_detail_page.dart';
import '../../features/customer_list/presentation/customer_list_page.dart';
import '../../features/customer_update/presentation/customer_update_page.dart';
import '../../features/home/presentation/home_shell_page.dart';
import '../../features/identity_update/presentation/identity_update_page.dart';
import '../../features/login/presentation/login_page.dart';
import '../../features/result/presentation/result_page.dart';
import '../../features/settings/presentation/settings_page.dart';
import 'route_guard.dart';
import 'route_paths.dart';

final rootNavigatorKey = GlobalKey<NavigatorState>();

final appRouterProvider = Provider<GoRouter>((ref) {
  final loggedIn = ref.watch(sessionManagerProvider).isLoggedIn;

  return GoRouter(
    navigatorKey: rootNavigatorKey,
    initialLocation: loggedIn ? RoutePaths.customers : RoutePaths.login,
    redirect: (context, state) {
      final path = state.uri.path;
      // 路由守卫只关心“是否登录”和“是否访问受保护页面”。
      // 业务权限、按钮权限等更细的规则应放到对应 feature 中，避免路由层膨胀。
      if (!loggedIn && isProtectedRoute(path)) {
        return RoutePaths.login;
      }
      if (loggedIn && path == RoutePaths.login) {
        return RoutePaths.customers;
      }
      if (path == RoutePaths.home) {
        return RoutePaths.customers;
      }
      return null;
    },
    routes: [
      GoRoute(
        path: RoutePaths.login,
        builder: (context, state) => const LoginPage(),
      ),
      ShellRoute(
        builder: (context, state, child) => HomeShellPage(child: child),
        routes: [
          GoRoute(
            path: RoutePaths.customers,
            builder: (context, state) => const CustomerListPage(),
          ),
          GoRoute(
            path: RoutePaths.settings,
            builder: (context, state) => const SettingsPage(),
          ),
        ],
      ),
      GoRoute(
        path: '/customer/:id',
        builder: (_, state) =>
            CustomerDetailPage(customerId: state.pathParameters['id']!),
      ),
      GoRoute(
        path: '/customer/:id/update',
        builder: (_, state) =>
            CustomerUpdatePage(customerId: state.pathParameters['id']!),
      ),
      GoRoute(
        path: '/customer/:id/identity-update',
        builder: (_, state) =>
            IdentityUpdatePage(customerId: state.pathParameters['id']!),
      ),
      GoRoute(
        path: RoutePaths.result,
        builder: (_, state) => ResultPage(
          title: state.uri.queryParameters['title'] ?? '提交成功',
          message: state.uri.queryParameters['message'] ?? '业务处理已完成。',
        ),
      ),
    ],
    observers: [TalkerRouteObserver(appTalker)],
    errorBuilder: (_, state) =>
        Scaffold(body: Center(child: Text(state.error.toString()))),
  );
});
