import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/theme/app_theme_controller.dart';
import '../../../shared/extensions/context_ext.dart';
import '../../../shared/ui/screen/screen.dart';
import '../../../shared/ui/widgets/common_app_bar.dart';

/// ─────────────────────────────────────────────────────────────────────
/// SettingThemePage - 主题设置页面。
/// ─────────────────────────────────────────────────────────────────────
///
/// 【职责】
/// 提供 APP 主题切换功能，支持：
/// - 普通模式（浅色）
/// - 深色模式
/// - 跟随系统
class SettingThemePage extends ConsumerWidget {
  const SettingThemePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeOption = ref.watch(themeControllerProvider);
    final l10n = context.l10n;

    return Scaffold(
      appBar: CommonAppBar(title: l10n.settingsTheme),
      body: ListView(
        children: [
          // 说明文字
          Padding(
            padding: EdgeInsets.all(16.s),
            child: Text(
              l10n.settingsThemeDescription,
              style: TextStyle(
                fontSize: 14.sp,
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
          ),
          Divider(height: 1.s),

          // 普通模式
          _ThemeTile(
            option: ThemeOption.light,
            title: l10n.settingsThemeLight,
            subtitle: l10n.settingsThemeLightDesc,
            icon: Icons.light_mode_outlined,
            isSelected: themeOption == ThemeOption.light,
            onTap: () => _selectTheme(ref, ThemeOption.light),
          ),

          // 深色模式
          _ThemeTile(
            option: ThemeOption.dark,
            title: l10n.settingsThemeDark,
            subtitle: l10n.settingsThemeDarkDesc,
            icon: Icons.dark_mode_outlined,
            isSelected: themeOption == ThemeOption.dark,
            onTap: () => _selectTheme(ref, ThemeOption.dark),
          ),

          // 跟随系统
          _ThemeTile(
            option: ThemeOption.system,
            title: l10n.settingsThemeSystem,
            subtitle: l10n.settingsThemeSystemDesc,
            icon: Icons.brightness_auto_outlined,
            isSelected: themeOption == ThemeOption.system,
            onTap: () => _selectTheme(ref, ThemeOption.system),
          ),
        ],
      ),
    );
  }

  void _selectTheme(WidgetRef ref, ThemeOption option) {
    ref.read(themeControllerProvider.notifier).select(option);
  }
}

/// 主题选项 Tile。
class _ThemeTile extends StatelessWidget {
  const _ThemeTile({
    required this.option,
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.isSelected,
    required this.onTap,
  });

  final ThemeOption option;
  final String title;
  final String subtitle;
  final IconData icon;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return InkWell(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16.s, vertical: 12.s),
        child: Row(
          children: [
            // 左侧图标
            Container(
              width: 40.s,
              height: 40.s,
              decoration: BoxDecoration(
                color: isSelected
                    ? colorScheme.primary.withValues(alpha: 0.1)
                    : colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
                borderRadius: BorderRadius.circular(8.s),
              ),
              child: Icon(
                icon,
                color: isSelected
                    ? colorScheme.primary
                    : colorScheme.onSurfaceVariant,
                size: 24.s,
              ),
            ),
            SizedBox(width: 12.s),

            // 中间文字
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(height: 2.s),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 13.sp,
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),

            // 右侧选中状态
            if (isSelected)
              Icon(
                Icons.check_circle,
                color: colorScheme.primary,
                size: 24.s,
              )
            else
              Icon(
                Icons.circle_outlined,
                color: colorScheme.outlineVariant,
                size: 24.s,
              ),
          ],
        ),
      ),
    );
  }
}
