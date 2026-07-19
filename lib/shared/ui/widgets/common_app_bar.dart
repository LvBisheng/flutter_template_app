import 'package:flutter/material.dart';

import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_text_styles.dart';

/// ─────────────────────────────────────────────────────────────────────
/// 通用 AppBar 组件。
/// ─────────────────────────────────────────────────────────────────────
///
/// 【设计目标】
/// 统一企业级 App 的顶部导航栏样式，解决 Material AppBar 的常见问题：
/// - 自动处理返回按钮显示/隐藏
/// - 标题居中（带返回按钮时也能正确居中）
/// - 右侧操作按钮自动排列，带合适间距
/// - 支持加载状态显示
/// - 支持自定义返回按钮点击行为
/// - 自动适配深色模式
///
/// 【使用方式】
/// ```dart
/// // 基础用法
/// CommonAppBar(title: '页面标题');
///
/// // 带右侧按钮
/// CommonAppBar(
///   title: '页面标题',
///   actions: [
///     IconButton(icon: Icon(Icons.search), onPressed: () {}),
///     IconButton(icon: Icon(Icons.more_vert), onPressed: () {}),
///   ],
/// );
///
/// // 自定义返回行为
/// CommonAppBar(
///   title: '页面标题',
///   onBackPressed: () => showDialog(...),
/// );
///
/// // 加载中状态
/// CommonAppBar(title: '页面标题', isLoading: true);
/// ```
///
class CommonAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CommonAppBar({
    super.key,
    required this.title,
    this.actions,
    this.onBackPressed,
    this.isLoading = false,
    this.centerTitle = true,
    this.backgroundColor,
    this.foregroundColor,
    this.elevation,
    this.showBackButton,
  });

  /// 标题文字。
  final String title;

  /// 右侧操作按钮列表。
  ///
  /// 会自动添加合适的间距。
  final List<Widget>? actions;

  /// 返回按钮点击回调。
  ///
  /// 为 null 时使用默认返回行为（Navigator.pop）。
  final VoidCallback? onBackPressed;

  /// 是否显示加载状态。
  ///
  /// 为 true 时，标题右侧会显示加载指示器。
  final bool isLoading;

  /// 标题是否居中。
  ///
  /// 默认 true（企业级 App 常见风格）。
  final bool centerTitle;

  /// 背景色。
  ///
  /// 默认自动适配深色模式（浅色模式为白色，深色模式为深色背景）。
  final Color? backgroundColor;

  /// 前景色（文字、图标颜色）。
  ///
  /// 默认自动适配深色模式（浅色模式为深色文字，深色模式为浅色文字）。
  final Color? foregroundColor;

  /// 阴影高度。
  final double? elevation;

  /// 是否显示返回按钮。
  ///
  /// 为 null 时自动判断：能否 pop 就显示。
  final bool? showBackButton;

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    final canPop = Navigator.of(context).canPop();
    final shouldShowBack = showBackButton ?? canPop;

    // 根据主题自动选择颜色
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final defaultBgColor = isDark ? AppColorsDark.surface : Colors.white;
    final defaultFgColor =
        isDark ? AppColorsDark.textPrimary : AppColors.textPrimary;

    final bgColor = backgroundColor ?? defaultBgColor;
    final fgColor = foregroundColor ?? defaultFgColor;

    return AppBar(
      // 背景
      backgroundColor: bgColor,
      elevation: elevation ?? 0,
      surfaceTintColor: Colors.transparent,

      // 标题
      title: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Flexible(
            child: Text(
              title,
              style: AppTextStyles.section.copyWith(color: fgColor),
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
            ),
          ),
          if (isLoading) ...[
            const SizedBox(width: 12),
            SizedBox(
              width: 16,
              height: 16,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                valueColor: AlwaysStoppedAnimation<Color>(fgColor),
              ),
            ),
          ],
        ],
      ),
      centerTitle: centerTitle,

      // 返回按钮
      leading: shouldShowBack
          ? IconButton(
              icon: Icon(Icons.arrow_back, color: fgColor),
              onPressed: onBackPressed ?? () => Navigator.of(context).pop(),
              tooltip: MaterialLocalizations.of(context).backButtonTooltip,
            )
          : null,

      // 禁止 AppBar 自动添加返回按钮
      // 当 showBackButton=false 且 leading=null 时，不再显示任何返回按钮
      automaticallyImplyLeading: shouldShowBack,

      // 右侧操作按钮
      actions: actions?.isNotEmpty == true
          ? [
              for (var i = 0; i < actions!.length; i++) ...[
                actions![i],
                if (i < actions!.length - 1) const SizedBox(width: 8),
              ],
              const SizedBox(width: 8), // 右侧留白
            ]
          : null,

      // 前景色（影响图标、文字）
      foregroundColor: fgColor,
    );
  }
}
