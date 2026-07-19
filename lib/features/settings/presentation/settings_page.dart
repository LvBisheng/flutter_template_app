import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../capabilities/auth/session_manager.dart';
import '../../../shared/extensions/context_ext.dart';
import '../../../shared/ui/feedback/app_dialog.dart';
import '../../../shared/ui/screen/screen.dart';
import '../../../shared/ui/widgets/common_app_bar.dart';
import '../routing/settings_routes.dart';

/// 设置页面（独立页面，无底部导航栏）。
///
/// 包含语言设置、字体大小、退出登录。
class SettingsPage extends ConsumerWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;

    return Scaffold(
      appBar: CommonAppBar(title: l10n.settingsTitle),
      body: ListView(
        padding: 16.s.paddingAll,
        children: [
          // 语言设置
          _MenuTile(
            icon: Icons.language,
            title: l10n.settingsLanguage,
            onTap: () => context.push(SettingsRoutes.settingLanguagePath),
          ),
          SizedBox(height: 8.s),

          // 深色模式
          _MenuTile(
            icon: Icons.dark_mode_outlined,
            title: l10n.settingsTheme,
            onTap: () => context.push(SettingsRoutes.settingThemePath),
          ),
          SizedBox(height: 8.s),

          // 字体大小
          _MenuTile(
            icon: Icons.text_fields,
            title: l10n.settingsFontSize,
            onTap: () => context.push(SettingsRoutes.settingFontSizePath),
          ),
          SizedBox(height: 24.s),

          // 退出登录
          FilledButton.icon(
            onPressed: () async {
              final ok = await AppDialog.confirm(
                context,
                l10n.settingsLogoutConfirm,
              );
              if (ok && context.mounted) {
                await ref.read(sessionManagerProvider.notifier).logout();
              }
            },
            icon: const Icon(Icons.logout),
            label: Text(l10n.settingsLogout),
          ),
        ],
      ),
    );
  }
}

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
    return Card(
      margin: EdgeInsets.zero,
      child: ListTile(
        leading: Icon(icon),
        title: Text(title),
        trailing: const Icon(Icons.chevron_right),
        onTap: onTap,
      ),
    );
  }
}
