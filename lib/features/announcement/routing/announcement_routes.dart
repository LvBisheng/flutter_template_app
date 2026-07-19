import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../app/router/feature_route.dart';
import '../domain/announcement.dart';
import '../presentation/announcement_detail_page.dart';
import '../presentation/announcement_page.dart';

/// ─────────────────────────────────────────────────────────────────────
/// AnnouncementRoutes - 公告模块路由定义。
/// ─────────────────────────────────────────────────────────────────────
///
/// 【职责】
/// 定义公告模块的路由配置。
///
/// 【路由说明】
/// - /home/announcements：公告列表 Tab（首页）
/// - /announcement/detail：公告详情页（独立页面）
///
class AnnouncementRoutes extends FeatureRoute {
  AnnouncementRoutes._();
  static final instance = AnnouncementRoutes._();

  // ═══════════════════════════════════════════════════════════════════
  // 路径常量
  // ═══════════════════════════════════════════════════════════════════

  /// 公告列表 Tab 路径（首页）。
  static const announcementsPath = '/home/announcements';

  /// 公告列表 Tab 路由名。
  static const announcementsName = 'announcement.list';

  /// 公告详情页路径。
  static const detailPath = '/announcement/detail';

  /// 公告详情页路由名。
  static const detailName = 'announcement.detail';

  // ═══════════════════════════════════════════════════════════════════
  // FeatureRoute 实现
  // ═══════════════════════════════════════════════════════════════════

  @override
  String get featureName => 'announcement';

  @override
  List<RouteBase> get routes => [
    // 公告详情页（独立页面，不在 StatefulShellRoute 中）
    GoRoute(
      path: detailPath,
      name: detailName,
      builder: (context, state) {
        final extra = state.extra;
        if (extra is Announcement) {
          return AnnouncementDetailPage(announcement: extra);
        }

        final queryParams = state.uri.queryParameters;
        return AnnouncementDetailPage(
          announcement: Announcement(
            id: queryParams['id'] ?? '',
            title: queryParams['title'] ?? '',
            content: queryParams['content'] ?? '',
            publishedAt:
                DateTime.tryParse(queryParams['publishedAt'] ?? '') ??
                DateTime.now(),
          ),
        );
      },
    ),
  ];

  /// 构建首页 Tab 页面。
  ///
  /// 由 HomeRoutes 的 StatefulShellRoute 调用。
  static Widget buildPage() => const AnnouncementPage();
}
