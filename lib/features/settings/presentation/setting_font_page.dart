import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../shared/extensions/context_ext.dart';
import '../../../shared/ui/screen/screen.dart';
import '../../../shared/ui/widgets/common_app_bar.dart';
import 'setting_font_controller.dart';

class SettingFontPage extends ConsumerWidget {
  const SettingFontPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final fontSize = ref.watch(settingFontControllerProvider);

    return Scaffold(
      appBar: CommonAppBar(title: l10n.settingsFontSize),
      body: SingleChildScrollView(
        child: _FontSizeSettingCard(
          currentOption: fontSize.option,
          onSelect: (option) {
            ref.read(settingFontControllerProvider.notifier).select(option);
          },
        ),
      ),
    );
  }
}

/// 字体大小设置卡片
class _FontSizeSettingCard extends ConsumerWidget {
  const _FontSizeSettingCard({
    required this.currentOption,
    required this.onSelect,
  });

  final FontSizeOption currentOption;
  final ValueChanged<FontSizeOption> onSelect;

  /// 获取字体档位的显示标签（根据当前语言）
  String _getLabel(BuildContext context, FontSizeOption option) {
    final l10n = context.l10n;
    switch (option) {
      case FontSizeOption.small:
        return l10n.settingsFontSizeSmall;
      case FontSizeOption.standard:
        return l10n.settingsFontSizeStandard;
      case FontSizeOption.large:
        return l10n.settingsFontSizeLarge;
      case FontSizeOption.extraLarge:
        return l10n.settingsFontSizeExtraLarge;
      case FontSizeOption.huge:
        return l10n.settingsFontSizeHuge;
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    return Card(
      child: Padding(
        padding: 16.s.paddingAll,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(width: double.infinity), // 撑满卡片宽度
            // 预览文字说明
            Text(
              l10n.settingsFontSizePreview,
              style: TextStyle(
                fontSize: 14.sp,
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
            SizedBox(height: 8.s),
            // 预览效果
            Text(
              'Hello, 世界！123',
              style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w500),
            ),
            SizedBox(height: 16.s),
            // 字体大小选择器（Wrap 布局，防止文字过长时挤压）
            Wrap(
              spacing: 8.s,
              runSpacing: 8.s,
              children: FontSizeOption.values.map((option) {
                final isSelected = option == currentOption;
                return GestureDetector(
                  onTap: () => onSelect(option),
                  child: Container(
                    width: 64.s,
                    padding: EdgeInsets.symmetric(vertical: 8.s),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? Theme.of(context).colorScheme.primaryContainer
                          : null,
                      borderRadius: BorderRadius.circular(4.s),
                      border: Border.all(
                        color: isSelected
                            ? Theme.of(context).colorScheme.primary
                            : Theme.of(context).colorScheme.outlineVariant,
                      ),
                    ),
                    child: Text(
                      _getLabel(context, option),
                      style: TextStyle(
                        fontSize: 12.sp,
                        fontWeight:
                            isSelected ? FontWeight.w600 : FontWeight.normal,
                        color: isSelected
                            ? Theme.of(context).colorScheme.primary
                            : Theme.of(context).colorScheme.onSurface,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }
}
