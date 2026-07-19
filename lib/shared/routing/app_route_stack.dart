import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// 记录 root Navigator 当前的命令式路由栈。
///
/// GoRouter 偏声明式，公开 API 里没有提供“pop 到某个 location”的能力。
/// 如果业务需要 A -> B -> C -> D -> E 后从 E 回到栈里的 B，需要先知道 B
/// 是否仍在栈中，否则直接 popUntil 可能一路 pop 空导致黑屏。
final appRouteStackObserver = AppRouteStackObserver();

class AppRouteStackObserver extends NavigatorObserver {
  final List<Route<dynamic>> _stack = [];

  void reset() {
    _stack.clear();
  }

  bool containsName(String name) {
    return _stack.any((route) => route.settings.name == name);
  }

  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    _stack.add(route);
  }

  @override
  void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) {
    _stack.remove(route);
  }

  @override
  void didRemove(Route<dynamic> route, Route<dynamic>? previousRoute) {
    _stack.remove(route);
  }

  @override
  void didReplace({Route<dynamic>? newRoute, Route<dynamic>? oldRoute}) {
    if (oldRoute != null) {
      final index = _stack.indexOf(oldRoute);
      if (index != -1) {
        if (newRoute != null) {
          _stack[index] = newRoute;
        } else {
          _stack.removeAt(index);
        }
        return;
      }
    }

    if (newRoute != null) {
      _stack.add(newRoute);
    }
  }
}

extension AppRouteStackNavigation on BuildContext {
  /// 如果指定 route name 仍在栈中，就 pop 回该页面；否则 go 到兜底路径。
  ///
  /// 注意：[routeName] 是 GoRoute.name，不是 path。
  void popUntilRouteNameOrGo({
    required String routeName,
    required String fallbackLocation,
  }) {
    if (appRouteStackObserver.containsName(routeName)) {
      Navigator.of(
        this,
        rootNavigator: true,
      ).popUntil((route) => route.settings.name == routeName);
      return;
    }

    go(fallbackLocation);
  }
}
