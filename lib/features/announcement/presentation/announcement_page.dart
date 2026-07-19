import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../shared/extensions/context_ext.dart';
import '../../../shared/routing/refresh_on_visible.dart';
import '../../../shared/ui/feedback/app_loading.dart';
import '../../../shared/ui/feedback/app_toast.dart';
import '../../../shared/ui/widgets/app_error_view.dart';
import '../../../shared/ui/widgets/common_app_bar.dart';
import '../domain/announcement.dart';
import '../routing/announcement_routes.dart';
import 'announcement_controller.dart';
import 'announcement_state.dart';

/// ─────────────────────────────────────────────────────────────────────
/// 公告列表页面。
/// ─────────────────────────────────────────────────────────────────────
///
/// 【关键特性：每次进入刷新】
/// 监听 Tab 切换和 push 返回，当页面变为可见时刷新数据。
///
/// 【用户体验设计】
/// - 首次进入：静默加载（不显示 Loading）
/// - Tab 切换回来：静默刷新
/// - push 返回：静默刷新
///
/// 【实现原理】
/// 通过 RefreshOnVisibleMixin 统一处理：
/// 1. 首次进入：首帧后刷新
/// 2. Tab 切回来：监听路由 key 的可见事件
/// 3. push 返回：pushAndRefreshOnReturn 返回后刷新
///
class AnnouncementPage extends ConsumerStatefulWidget {
  const AnnouncementPage({super.key});

  @override
  ConsumerState<AnnouncementPage> createState() => _AnnouncementPageState();
}

class _AnnouncementPageState extends ConsumerState<AnnouncementPage>
    with RefreshOnVisibleMixin<AnnouncementPage> {
  @override
  String get visibleRefreshKey => AnnouncementRoutes.announcementsPath;

  @override
  Future<void> onVisibleRefresh(VisibleRefreshReason reason) {
    return ref.read(announcementControllerProvider.notifier).refresh();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(announcementControllerProvider);
    final l10n = context.l10n;

    return Scaffold(
      appBar: CommonAppBar(
        title: l10n.announcementTitle,
        actions: [
          // 刷新按钮
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () async {
              await _refreshWithToast();
            },
          ),
        ],
      ),
      body: _buildBody(context, state),
    );
  }

  /// 用户主动刷新时，如果保留旧数据的后台刷新失败，用 toast 提醒。
  Future<void> _refreshWithToast() async {
    try {
      await ref.read(announcementControllerProvider.notifier).refresh();
    } catch (e) {
      if (mounted) AppToast.show(context, '刷新失败: $e');
    }
  }

  Future<void> _openDetail(Announcement announcement) async {
    await pushAndRefreshOnReturn<void>(
      AnnouncementRoutes.detailPath,
      extra: announcement,
    );
  }

  Widget _buildBody(BuildContext context, AnnouncementState state) {
    // Loading 状态（首次加载且无数据时才显示）
    if (state.loading && state.announcements.isEmpty) {
      return const AppLoading();
    }

    // 错误状态（无数据时）
    if (state.errorMessage != null && state.announcements.isEmpty) {
      return AppErrorView(
        message: state.errorMessage!,
        onRetry: () {
          refreshWhenVisible();
        },
      );
    }

    // 空数据状态
    if (state.announcements.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.inbox_outlined, size: 64, color: Colors.grey),
            const SizedBox(height: 16),
            Text(
              context.l10n.announcementEmpty,
              style: const TextStyle(color: Colors.grey),
            ),
          ],
        ),
      );
    }

    // 正常显示列表
    return Stack(
      children: [
        RefreshIndicator(
          onRefresh: () async {
            await _refreshWithToast();
          },
          child: ListView.builder(
            padding: EdgeInsets.only(
              bottom: state.lastRefreshTime == null ? 0 : 48,
            ),
            itemCount: state.announcements.length,
            itemBuilder: (context, index) {
              final announcement = state.announcements[index];
              return _AnnouncementItem(
                announcement: announcement,
                onTap: () => _openDetail(announcement),
              );
            },
          ),
        ),
        // 显示刷新时间（底部浮动）
        if (state.lastRefreshTime != null)
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: _RefreshTimeFooter(time: state.lastRefreshTime!),
          ),
        // Loading 遮罩（刷新时如有旧数据，只显示小圆圈）
        if (state.loading && state.announcements.isNotEmpty)
          Positioned.fill(
            child: Container(
              color: Colors.black12,
              child: const Center(child: CircularProgressIndicator()),
            ),
          ),
      ],
    );
  }
}

/// 公告列表项。
class _AnnouncementItem extends StatelessWidget {
  const _AnnouncementItem({required this.announcement, required this.onTap});

  final Announcement announcement;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: ListTile(
        leading: Icon(
          Icons.campaign_outlined,
          color: Theme.of(context).colorScheme.primary,
        ),
        title: Text(announcement.title),
        subtitle: Text(
          // 显示发布时间
          _formatTime(announcement.publishedAt),
          style: Theme.of(context).textTheme.bodySmall,
        ),
        trailing: const Icon(Icons.chevron_right),
        onTap: onTap,
      ),
    );
  }

  String _formatTime(DateTime time) {
    final now = DateTime.now();
    final diff = now.difference(time);

    if (diff.inMinutes < 1) {
      return '刚刚';
    } else if (diff.inHours < 1) {
      return '${diff.inMinutes} 分钟前';
    } else if (diff.inDays < 1) {
      return '${diff.inHours} 小时前';
    } else if (diff.inDays < 7) {
      return '${diff.inDays} 天前';
    } else {
      return DateFormat('yyyy-MM-dd').format(time);
    }
  }
}

/// 刷新时间底部栏。
class _RefreshTimeFooter extends StatelessWidget {
  const _RefreshTimeFooter({required this.time});

  final DateTime time;

  @override
  Widget build(BuildContext context) {
    final formattedTime = DateFormat('HH:mm:ss').format(time);
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 4,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Text(
        '最后刷新: $formattedTime',
        textAlign: TextAlign.center,
        style: Theme.of(
          context,
        ).textTheme.bodySmall?.copyWith(color: Colors.grey[600]),
      ),
    );
  }
}
