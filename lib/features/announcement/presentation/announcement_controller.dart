import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/logging/app_logger.dart';
import '../../../core/network/api_client.dart';
import '../data/announcement_api.dart';
import '../data/announcement_repository.dart';
import 'announcement_state.dart';

/// ─────────────────────────────────────────────────────────────────────
/// 公告列表 Controller。
/// ─────────────────────────────────────────────────────────────────────
///
/// 【职责】
/// 1. 管理 UI 状态（loading、数据、错误）
/// 2. 调用 Repository 获取数据
/// 3. 提供刷新方法（每次页面可见时调用）
///
/// 【关键特性：静默刷新】
/// 所有刷新都是静默的，不显示全屏 Loading。
/// - 有数据时：保留旧数据，后台刷新
/// - 无数据时：显示 Loading
///
/// 【企业 APP 常见场景】
/// - 首页：每次返回都刷新最新数据（金额、资产）
/// - 消息页：每次进入都获取最新消息
/// - 订单页：每次返回都刷新订单状态
///
final announcementControllerProvider =
    NotifierProvider<AnnouncementController, AnnouncementState>(
      AnnouncementController.new,
    );

/// Repository Provider。
///
/// 【依赖注入】
/// 通过 Provider 注入依赖，而不是在 Controller 里直接创建。
/// 这样做的好处：
/// 1. 单例：全局只有一个实例
/// 2. 易于测试：可以替换为 Mock Repository
/// 3. 依赖清晰：便于查看依赖关系
///
final announcementRepositoryProvider = Provider<AnnouncementRepository>((ref) {
  return AnnouncementRepositoryImpl(
    AnnouncementApi(ref.read(apiClientProvider)),
  );
});

class AnnouncementController extends Notifier<AnnouncementState> {
  Future<void>? _refreshing;

  @override
  AnnouncementState build() {
    // 不在这里自动加载，由 Page 决定何时刷新
    return const AnnouncementState();
  }

  /// 刷新数据（静默刷新）。
  ///
  /// 【调用时机】
  /// 1. 页面首次进入
  /// 2. Tab 切换回来
  /// 3. push 返回
  /// 4. 用户下拉刷新
  /// 5. 用户点击刷新按钮
  ///
  /// 【用户体验】
  /// - 有数据时：保留旧数据，后台刷新，用户无感知
  /// - 无数据时：显示 Loading
  ///
  Future<void> refresh() {
    final running = _refreshing;
    if (running != null) return running;

    late final Future<void> task;
    task = _doRefresh().whenComplete(() {
      if (identical(_refreshing, task)) {
        _refreshing = null;
      }
    });
    _refreshing = task;
    return task;
  }

  Future<void> _doRefresh() async {
    // 只有首次加载且无数据时才显示 Loading
    final shouldShowLoading = state.announcements.isEmpty;

    if (shouldShowLoading) {
      state = state.copyWith(loading: true, errorMessage: null);
    }

    try {
      appLogger.i('Fetching announcement list...');

      // 从 Provider 获取 Repository
      final repository = ref.read(announcementRepositoryProvider);
      final announcements = await repository.fetchList();

      appLogger.i('Fetched ${announcements.length} announcements');

      // 更新成功状态
      state = AnnouncementState(
        loading: false,
        announcements: announcements,
        lastRefreshTime: DateTime.now(),
      );
    } catch (e, st) {
      appLogger.e('Failed to fetch announcements', error: e, stackTrace: st);

      // 更新错误状态
      // - 无数据时：显示错误页面
      // - 有数据时：保留旧数据，由 Page 显示 toast
      state = state.copyWith(
        loading: false,
        errorMessage: state.announcements.isEmpty ? e.toString() : null,
      );

      // 如果有旧数据但刷新失败，重新抛出异常让 Page 显示 toast
      if (state.announcements.isNotEmpty) {
        rethrow;
      }
    }
  }
}
