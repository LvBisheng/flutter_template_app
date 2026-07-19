import '../domain/announcement.dart';

/// ─────────────────────────────────────────────────────────────────────
/// 公告列表页面状态。
/// ─────────────────────────────────────────────────────────────────────
///
/// 【状态设计】
/// - loading：是否正在加载
/// - announcements：公告列表
/// - errorMessage：错误信息（null 表示无错误）
/// - lastRefreshTime：最后刷新时间（用于 UI 展示）
///
class AnnouncementState {
  const AnnouncementState({
    this.loading = false,
    this.announcements = const [],
    this.errorMessage,
    this.lastRefreshTime,
  });

  /// 是否正在加载。
  final bool loading;

  /// 公告列表。
  final List<Announcement> announcements;

  /// 错误信息。
  final String? errorMessage;

  /// 最后刷新时间。
  final DateTime? lastRefreshTime;

  /// 复制并更新状态。
  AnnouncementState copyWith({
    bool? loading,
    List<Announcement>? announcements,
    String? errorMessage,
    DateTime? lastRefreshTime,
  }) {
    return AnnouncementState(
      loading: loading ?? this.loading,
      announcements: announcements ?? this.announcements,
      errorMessage: errorMessage,
      lastRefreshTime: lastRefreshTime ?? this.lastRefreshTime,
    );
  }
}
