import 'package:go_router/go_router.dart';

import '../../../app/router/feature_route.dart';
import '../presentation/lesson1_basic_provider.dart';
import '../presentation/lesson2_async_notifier.dart';
import '../presentation/lesson3_provider_combination.dart';
import '../presentation/lesson4_scope.dart';
import '../presentation/lesson5_select.dart';
import '../presentation/lesson6_annotation.dart';
import '../presentation/riverpod_demo_hub_page.dart';

/// ─────────────────────────────────────────────────────────────────────
/// RiverpodDemoRoutes - Riverpod 学习 Demo 路由定义。
/// ─────────────────────────────────────────────────────────────────────
///
/// 【职责】
/// 定义 Riverpod 学习 Demo 及其课程页面的路由配置。
///
/// 【路由说明】
/// - `/home/demos/riverpod`: Riverpod Demo Hub 入口页面
/// - `/home/demos/riverpod/lesson1`: 第1课 Provider 基础
/// - `/home/demos/riverpod/lesson2`: 第2课 AsyncNotifier
/// - `/home/demos/riverpod/lesson3`: 第3课 Provider 组合
/// - `/home/demos/riverpod/lesson4`: 第4课 ProviderScope
/// - `/home/demos/riverpod/lesson5`: 第5课 精准重建
///
class RiverpodDemoRoutes extends FeatureRoute {
  RiverpodDemoRoutes._();
  static final instance = RiverpodDemoRoutes._();

  // ═══════════════════════════════════════════════════════════════════
  // 路径常量
  // ═══════════════════════════════════════════════════════════════════

  /// Riverpod Demo Hub 路径。
  static const riverpodDemoPath = '/home/demos/riverpod';

  /// Riverpod Demo Hub 路由名。
  static const riverpodDemoName = 'RiverpodDemoHubPage';

  /// 第1课路径。
  static const lesson1Path = '/home/demos/riverpod/lesson1';

  /// 第1课路由名。
  static const lesson1Name = 'Lesson1BasicProvider';

  /// 第2课路径。
  static const lesson2Path = '/home/demos/riverpod/lesson2';

  /// 第2课路由名。
  static const lesson2Name = 'Lesson2AsyncNotifier';

  /// 第3课路径。
  static const lesson3Path = '/home/demos/riverpod/lesson3';

  /// 第3课路由名。
  static const lesson3Name = 'Lesson3ProviderCombination';

  /// 第4课路径。
  static const lesson4Path = '/home/demos/riverpod/lesson4';

  /// 第4课路由名。
  static const lesson4Name = 'Lesson4Scope';

  /// 第5课路径。
  static const lesson5Path = '/home/demos/riverpod/lesson5';

  /// 第5课路由名。
  static const lesson5Name = 'Lesson5Select';

  /// 第6课路径。
  static const lesson6Path = '/home/demos/riverpod/lesson6';

  /// 第6课路由名。
  static const lesson6Name = 'Lesson6Annotation';

  // ═══════════════════════════════════════════════════════════════════
  // FeatureRoute 实现
  // ═══════════════════════════════════════════════════════════════════

  @override
  String get featureName => 'riverpod_demo';

  /// 所有 Riverpod Demo 相关路由。
  @override
  List<RouteBase> get routes => [
    GoRoute(
      path: riverpodDemoPath,
      name: riverpodDemoName,
      builder: (context, state) => const RiverpodDemoHubPage(),
    ),
    GoRoute(
      path: lesson1Path,
      name: lesson1Name,
      builder: (context, state) => const Lesson1BasicProvider(),
    ),
    GoRoute(
      path: lesson2Path,
      name: lesson2Name,
      builder: (context, state) => const Lesson2AsyncNotifier(),
    ),
    GoRoute(
      path: lesson3Path,
      name: lesson3Name,
      builder: (context, state) => const Lesson3ProviderCombination(),
    ),
    GoRoute(
      path: lesson4Path,
      name: lesson4Name,
      builder: (context, state) => const Lesson4Scope(),
    ),
    GoRoute(
      path: lesson5Path,
      name: lesson5Name,
      builder: (context, state) => const Lesson5Select(),
    ),
    GoRoute(
      path: lesson6Path,
      name: lesson6Name,
      builder: (context, state) => const Lesson6Annotation(),
    ),
  ];
}
