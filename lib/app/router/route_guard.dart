import 'package:go_router/go_router.dart';

import 'feature_route.dart';

/// ─────────────────────────────────────────────────────────────────────
/// 路由守卫 - 认证保护判断。
/// ─────────────────────────────────────────────────────────────────────
///
/// 【职责】
/// 判断路由是否需要认证保护。
///
/// 【设计说明】
/// 路由守卫只关心"是否登录"和"是否访问受保护页面"。
/// 业务权限、按钮权限等更细的规则应放到对应 Feature 中，
/// 避免路由层膨胀。
///
/// 【使用方式】
/// ```dart
/// redirect: (context, state) {
///   final path = state.uri.path;
///   if (!loggedIn && isProtectedRoute(path, allFeatureRoutes)) {
///     return LoginRoutes.loginPath;
///   }
///   return null;
/// }
/// ```

/// 判断路由是否需要认证保护。
///
/// 【参数】
/// - [location]: 当前访问的路径
/// - [featureRoutes]: 所有 Feature 路由列表
///
/// 【返回】
/// - true: 需要认证（受保护路由）
/// - false: 不需要认证（公开路由）
bool isProtectedRoute(String location, List<FeatureRoute> featureRoutes) {
  // 遍历所有 Feature 路由，找到匹配的路由
  for (final feature in featureRoutes) {
    // 检查是否有匹配的路由
    if (_matchFeature(location, feature)) {
      return feature.requiresAuth;
    }
  }

  // 默认：未匹配的路由需要认证（安全优先）
  return true;
}

/// 检查路径是否匹配 Feature 中的路由。
bool _matchFeature(String location, FeatureRoute feature) {
  for (final route in feature.routes) {
    if (_matchRoute(location, route)) {
      return true;
    }
  }
  return false;
}

/// 检查路径是否匹配某个 RouteBase 及其子路由。
bool _matchRoute(String location, RouteBase route) {
  if (route is GoRoute && _pathMatches(location, route.path)) {
    return true;
  }

  // ShellRoute、StatefulShellRoute、GoRoute 子路由都通过 routes 暴露。
  for (final subRoute in route.routes) {
    if (_matchRoute(location, subRoute)) {
      return true;
    }
  }

  return false;
}

/// 路径匹配（支持动态参数）。
///
/// 【匹配规则】
/// - 精确匹配：`/login` 匹配 `/login`
/// - 动态参数：`/customer/123` 匹配 `/customer/:id`
bool _pathMatches(String location, String routePath) {
  // 精确匹配
  if (location == routePath) return true;

  // 动态参数匹配（如 /customer/123 匹配 /customer/:id）
  if (routePath.contains(':')) {
    final locationParts = location.split('/');
    final routeParts = routePath.split('/');

    // 路径段数必须相同
    if (locationParts.length != routeParts.length) return false;

    // 逐段比较
    for (int i = 0; i < routeParts.length; i++) {
      // 动态参数段（如 :id）跳过
      if (routeParts[i].startsWith(':')) continue;
      // 普通段必须精确匹配
      if (locationParts[i] != routeParts[i]) return false;
    }
    return true;
  }

  return false;
}
