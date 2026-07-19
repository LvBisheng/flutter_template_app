import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../capabilities/auth/session_manager.dart';
import '../../../capabilities/auth/auth_state.dart';
import '../../../shared/extensions/context_ext.dart';
import '../../../shared/ui/screen/screen.dart';
import '../../../shared/ui/widgets/common_app_bar.dart';
import '../routing/settings_routes.dart';

/// "我的"页面（Tab 页面）。
///
/// 参考微信的"我"Tab，展示用户信息，提供入口跳转设置页面。
class MePage extends ConsumerWidget {
  const MePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final auth = ref.watch(sessionManagerProvider);
    final l10n = context.l10n;

    return Scaffold(
      appBar: CommonAppBar(title: l10n.meTitle),
      body: ListView(
        children: [
          // 用户信息区域
          _UserCard(auth: auth),
          SizedBox(height: 16.s),

          // 功能入口
          _MenuTile(
            icon: Icons.settings_outlined,
            title: l10n.navSettings,
            onTap: () => context.push(SettingsRoutes.settingsPagePath),
          ),
        ],
      ),
    );
  }
}

/// 用户信息卡片。
class _UserCard extends StatelessWidget {
  const _UserCard({required this.auth});

  final AuthState auth;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final theme = Theme.of(context);

    return Container(
      padding: 16.s.paddingAll,
      child: Row(
        children: [
          // 头像
          CircleAvatar(
            radius: 32.s,
            backgroundColor: theme.colorScheme.primaryContainer,
            child: Icon(
              Icons.person,
              size: 32.s,
              color: theme.colorScheme.primary,
            ),
          ),
          SizedBox(width: 16.s),
          // 用户信息
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  auth.isLoggedIn ? (auth.userName ?? l10n.meLoggedInUser) : l10n.meNotLoggedIn,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                if (!auth.isLoggedIn)
                  Text(
                    l10n.meTapToLogin,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
              ],
            ),
          ),
          // 右箭头
          Icon(
            Icons.chevron_right,
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ],
      ),
    );
  }
}

/// 菜单项。
class _MenuTile extends StatelessWidget {
  const _MenuTile({
    required this.icon,
    required this.title,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon),
      title: Text(title),
      trailing: const Icon(Icons.chevron_right),
      onTap: onTap,
    );
  }
}
