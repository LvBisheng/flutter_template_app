import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../app/router/feature_route.dart';
import '../presentation/me_page.dart';
import '../presentation/setting_font_page.dart';
import '../presentation/setting_language_page.dart';
import '../presentation/setting_theme_page.dart';
import '../presentation/settings_page.dart';

/// ─────────────────────────────────────────────────────────────────────
/// SettingsRoutes - 设置模块路由定义。
/// ─────────────────────────────────────────────────────────────────────
///
/// 【职责】
/// 定义"我的"Tab 和设置模块的路由配置。
///
/// 【路由说明】
/// - `/home/me`: "我的"Tab 页面（在 Shell 中显示，有底部导航栏）
/// - `/setting`: 设置页面（独立页面，无底部导航栏）
/// - `/setting/language`: 语言设置页面（独立页面）
/// - `/setting/font`: 字体大小设置页面（独立页面）
///
/// 【关于 Tab 页面】
/// Tab 页面通过 `buildTabPage()` 构建，由 HomeRoutes 的 StatefulShellRoute 调用。
/// 独立页面通过 `routes` 暴露，注册到 app_router.dart。
///
class SettingsRoutes extends FeatureRoute {
  SettingsRoutes._();
  static final instance = SettingsRoutes._();

  // ═══════════════════════════════════════════════════════════════════
  // 路径常量
  // ═══════════════════════════════════════════════════════════════════

  /// "我的" Tab 页面路径。
  ///
  /// 这个页面在 StatefulShellRoute 中显示，有底部导航栏。
  /// 由 HomeRoutes 的 StatefulShellRoute 调用。
  static const mePath = '/home/me';

  /// "我的" Tab 路由名。
  static const meName = 'settings.me';

  /// 设置页面路径（独立页面）。
  static const settingsPagePath = '/setting';

  /// 设置页面路由名。
  static const settingsPageName = 'settings.index';

  /// 语言设置页面路径。
  static const settingLanguagePath = '/setting/language';

  /// 语言设置页面路由名。
  static const settingLanguageName = 'settings.language';

  /// 字体大小设置页面路径。
  static const settingFontSizePath = '/setting/font';

  /// 字体大小设置页面路由名。
  static const settingFontSizeName = 'settings.font';

  /// 主题设置页面路径。
  static const settingThemePath = '/setting/theme';

  /// 主题设置页面路由名。
  static const settingThemeName = 'settings.theme';

  // ═══════════════════════════════════════════════════════════════════
  // Tab 页面构建
  // ═══════════════════════════════════════════════════════════════════

  /// 构建 Tab 页面（由 HomeRoutes 的 StatefulShellRoute 调用）。
  static Widget buildTabPage() => const MePage();

  // ═══════════════════════════════════════════════════════════════════
  // FeatureRoute 实现（独立路由）
  // ═══════════════════════════════════════════════════════════════════

  @override
  String get featureName => 'settings';

  /// 独立路由（不在 Shell 中显示）。
  ///
  /// 这些页面通过 push 导航，没有底部导航栏。
  @override
  List<RouteBase> get routes => [
    GoRoute(
      path: settingsPagePath,
      name: settingsPageName,
      builder: (context, state) => const SettingsPage(),
    ),
    GoRoute(
      path: settingLanguagePath,
      name: settingLanguageName,
      builder: (context, state) => const SettingLanguagePage(),
    ),
    GoRoute(
      path: settingFontSizePath,
      name: settingFontSizeName,
      builder: (context, state) => const SettingFontPage(),
    ),
    GoRoute(
      path: settingThemePath,
      name: settingThemeName,
      builder: (context, state) => const SettingThemePage(),
    ),
  ];
}
