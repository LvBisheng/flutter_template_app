import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../shared/ui/widgets/common_app_bar.dart';
import '../domain/announcement.dart';

/// ─────────────────────────────────────────────────────────────────────
/// 公告详情页面。
/// ─────────────────────────────────────────────────────────────────────
///
/// 这个页面很简单，只展示从列表页传递过来的数据。
/// 不需要 Controller，因为不需要复杂的状态管理。
///
/// 【场景】
/// 用户从公告列表 push 进来，查看详情后 pop 返回。
/// 返回时，列表页会在 await push 之后刷新数据。
///
class AnnouncementDetailPage extends StatelessWidget {
  const AnnouncementDetailPage({super.key, required this.announcement});

  final Announcement announcement;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CommonAppBar(title: '公告详情'),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 标题
            Text(
              announcement.title,
              style: Theme.of(
                context,
              ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),

            // 发布时间
            Text(
              DateFormat('yyyy-MM-dd HH:mm').format(announcement.publishedAt),
              style: Theme.of(
                context,
              ).textTheme.bodySmall?.copyWith(color: Colors.grey[600]),
            ),
            const SizedBox(height: 16),

            // 分隔线
            const Divider(),
            const SizedBox(height: 16),

            // 内容
            Text(
              announcement.content,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
          ],
        ),
      ),
    );
  }
}
