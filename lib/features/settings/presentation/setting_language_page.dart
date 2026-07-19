import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/l10n/app_locale_controller.dart';
import '../../../shared/extensions/context_ext.dart';
import '../../../shared/ui/screen/screen.dart';
import '../../../shared/ui/widgets/common_app_bar.dart';

/// ─────────────────────────────────────────────────────────────────────
/// SettingLanguagePage - 语言设置页面。
/// ─────────────────────────────────────────────────────────────────────
///
/// 【职责】
/// 提供 APP 语言切换功能，支持：
/// - 跟随系统
/// - 简体中文
/// - 繁体中文
/// - English
///
class SettingLanguagePage extends ConsumerWidget {
  const SettingLanguagePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final locale = ref.watch(appLocaleControllerProvider);
    final l10n = context.l10n;

    return Scaffold(
      appBar: CommonAppBar(title: l10n.settingsLanguage),
      body: ListView(
        children: [
          // 说明文字
          Padding(
            padding: EdgeInsets.all(16.s),
            child: Text(
              l10n.settingsLanguageDescription,
              style: TextStyle(
                fontSize: 14.sp,
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
          ),
          Divider(height: 1.s),
          // 语言选项列表
          _LanguageTile(
            option: AppLocaleOption.system,
            title: l10n.settingsLanguageSystem,
            subtitle: l10n.settingsLanguageSystemDesc,
            isSelected: locale.option == AppLocaleOption.system,
            onTap: () => _selectLocale(ref, AppLocaleOption.system),
          ),
          _LanguageTile(
            option: AppLocaleOption.zhHans,
            title: l10n.settingsLanguageChinese,
            subtitle: '简体中文',
            isSelected: locale.option == AppLocaleOption.zhHans,
            onTap: () => _selectLocale(ref, AppLocaleOption.zhHans),
          ),
          _LanguageTile(
            option: AppLocaleOption.zhHant,
            title: l10n.settingsLanguageTraditionalChinese,
            subtitle: '繁體中文',
            isSelected: locale.option == AppLocaleOption.zhHant,
            onTap: () => _selectLocale(ref, AppLocaleOption.zhHant),
          ),
          _LanguageTile(
            option: AppLocaleOption.en,
            title: l10n.settingsLanguageEnglish,
            subtitle: 'English',
            isSelected: locale.option == AppLocaleOption.en,
            onTap: () => _selectLocale(ref, AppLocaleOption.en),
          ),
        ],
      ),
    );
  }

  void _selectLocale(WidgetRef ref, AppLocaleOption option) {
    ref.read(appLocaleControllerProvider.notifier).select(option);
  }
}

/// 语言选项 Tile。
class _LanguageTile extends StatelessWidget {
  const _LanguageTile({
    required this.option,
    required this.title,
    required this.subtitle,
    required this.isSelected,
    required this.onTap,
  });

  final AppLocaleOption option;
  final String title;
  final String subtitle;
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
            // 左侧文字
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
                  SizedBox(height: 4.s),
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
