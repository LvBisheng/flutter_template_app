import 'package:go_router/go_router.dart';

import '../../../app/router/feature_route.dart';
import '../../../shared/extensions/context_ext.dart';
import '../presentation/result_page.dart';

/// ─────────────────────────────────────────────────────────────────────
/// ResultRoutes - 结果页面路由定义。
/// ─────────────────────────────────────────────────────────────────────
///
/// 【职责】
/// 定义通用结果页面的路由配置。
///
/// 【设计说明】
/// ResultPage 是通用结果页，支持通过 query parameters 传递参数。
/// 这是一个跨 Feature 共享的页面，放在 result feature 中统一管理。
///
/// 【使用示例】
/// ```dart
/// // 使用静态方法生成带参数的 URI
/// context.go(ResultRoutes.buildResultUri(
///   title: '操作成功',
///   message: '数据已保存',
/// ).toString());
/// ```
///
class ResultRoutes extends FeatureRoute {
  ResultRoutes._();
  static final instance = ResultRoutes._();

  // ═══════════════════════════════════════════════════════════════════
  // 路径常量
  // ═══════════════════════════════════════════════════════════════════

  /// 结果页面路径。
  ///
  /// 支持 query parameters 传递标题和消息。
  static const resultPath = '/result';

  /// 通用结果页路由名。
  static const resultName = 'result.default';

  /// 构建带参数的结果页 URI。
  ///
  /// 【参数】
  /// - [title]: 结果标题
  /// - [message]: 结果消息
  ///
  /// 【返回】
  /// 完整 URI，如 `/result?title=xxx&message=yyy`
  static Uri buildResultUri({required String title, required String message}) {
    return Uri(
      path: resultPath,
      queryParameters: {'title': title, 'message': message},
    );
  }

  // ═══════════════════════════════════════════════════════════════════
  // FeatureRoute 实现
  // ═══════════════════════════════════════════════════════════════════

  @override
  String get featureName => 'result';

  @override
  List<RouteBase> get routes => [
    GoRoute(
      path: resultPath,
      name: resultName,
      builder: (context, state) => ResultPage(
        title:
            state.uri.queryParameters['title'] ??
            context.l10n.resultDefaultTitle,
        message:
            state.uri.queryParameters['message'] ??
            context.l10n.resultDefaultMessage,
      ),
    ),
  ];
}
