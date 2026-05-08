import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/env/env_config.dart';
import '../../../capabilities/auth/session_manager.dart';
import '../../../shared/ui/feedback/app_dialog.dart';

class SettingsPage extends ConsumerWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final auth = ref.watch(sessionManagerProvider);
    final env = ref.watch(envConfigProvider);
    return Scaffold(
      appBar: AppBar(title: const Text('设置')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _SectionTitle('账号'),
          _Tile(
            '登录状态',
            auth.isLoggedIn ? '已登录：${auth.userName ?? '-'}' : '未登录',
          ),
          const SizedBox(height: 12),
          OutlinedButton.icon(
            onPressed: () async {
              await ref.read(sessionManagerProvider.notifier).clearToken();
            },
            icon: const Icon(Icons.delete_outline),
            label: const Text('清除 Token'),
          ),
          const SizedBox(height: 8),
          FilledButton.icon(
            onPressed: () async {
              final ok = await AppDialog.confirm(context, '确认退出当前登录？');
              if (ok) await ref.read(sessionManagerProvider.notifier).logout();
            },
            icon: const Icon(Icons.logout),
            label: const Text('退出登录'),
          ),
          const SizedBox(height: 24),
          _SectionTitle('应用信息'),
          _Tile('当前环境', env.env.name),
          _Tile('Base URL', env.baseUrl),
          _Tile('诊断工具', env.switchEnabled ? '右下角悬浮按钮' : '生产包已关闭'),
        ],
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle(this.text);

  final String text;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(bottom: 8),
    child: Text(text, style: Theme.of(context).textTheme.titleMedium),
  );
}

class _Tile extends StatelessWidget {
  const _Tile(this.title, this.value);
  final String title;
  final String value;

  @override
  Widget build(BuildContext context) => Card(
    child: ListTile(title: Text(title), subtitle: Text(value)),
  );
}
