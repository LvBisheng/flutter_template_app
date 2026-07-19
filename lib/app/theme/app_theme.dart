import 'package:flutter/material.dart';

import 'app_colors.dart';

/// ─────────────────────────────────────────────────────────────────────
/// 应用主题配置。
/// ─────────────────────────────────────────────────────────────────────
///
/// 【设计目标】
/// 统一管理 ThemeData，确保全局样式一致。
///
/// 【使用方式】
/// ```dart
/// MaterialApp(
///   theme: AppTheme.light(),
///   // ...
/// );
/// ```
///
/// 【包含配置】
/// - ColorScheme：颜色方案
/// - AppBarTheme：顶栏样式
/// - InputDecorationTheme：输入框样式
/// - CardTheme：卡片样式
///
/// 【扩展建议】
/// 如需暗色模式，新增 `dark()` 方法：
/// ```dart
/// static ThemeData dark() { ... }
/// ```
///
class AppTheme {
  AppTheme._();

  /// 浅色主题。
  ///
  /// 【配置说明】
  /// - ColorScheme 从品牌色自动生成
  /// - AppBar 左对齐标题、白色背景
  /// - 输入框圆角 8px、白色填充
  /// - 卡片圆角 8px、无阴影
  static ThemeData light() {
    return ThemeData(
      // 从品牌色自动生成颜色方案
      colorScheme: ColorScheme.fromSeed(seedColor: AppColors.primary),

      // 页面背景色
      scaffoldBackgroundColor: AppColors.surface,

      // ═════════════════════════════════════════════════════════════════
      // AppBar 配置
      // ═════════════════════════════════════════════════════════════════
      appBarTheme: const AppBarTheme(
        centerTitle: true,  // 标题左对齐（Android 风格）
        backgroundColor: Colors.white,
        foregroundColor: AppColors.textPrimary,
      ),

      // ═════════════════════════════════════════════════════════════════
      // 输入框配置
      // ═════════════════════════════════════════════════════════════════
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.white,
        // 默认边框
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: AppColors.border),
        ),
        // 启用状态边框
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: AppColors.border),
        ),
      ),

      // ═════════════════════════════════════════════════════════════════
      // 卡片配置
      // ═════════════════════════════════════════════════════════════════
      cardTheme: CardThemeData(
        color: Colors.white,
        elevation: 0,  // 无阴影，现代扁平风格
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }

  /// 深色主题。
  ///
  /// 【配置说明】
  /// - ColorScheme 从品牌色自动生成（深色模式）
  /// - AppBar 使用深色背景
  /// - 输入框、卡片使用深色填充
  static ThemeData dark() {
    return ThemeData(
      brightness: Brightness.dark,

      // 从品牌色自动生成颜色方案（深色模式）
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColorsDark.primary,
        brightness: Brightness.dark,
      ),

      // 页面背景色
      scaffoldBackgroundColor: AppColorsDark.surface,

      // ═════════════════════════════════════════════════════════════════
      // AppBar 配置
      // ═════════════════════════════════════════════════════════════════
      appBarTheme: const AppBarTheme(
        centerTitle: true,
        backgroundColor: AppColorsDark.surface,
        foregroundColor: AppColorsDark.textPrimary,
      ),

      // ═════════════════════════════════════════════════════════════════
      // 输入框配置
      // ═════════════════════════════════════════════════════════════════
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColorsDark.cardSurface,
        // 默认边框
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: AppColorsDark.border),
        ),
        // 启用状态边框
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: AppColorsDark.border),
        ),
      ),

      // ═════════════════════════════════════════════════════════════════
      // 卡片配置
      // ═════════════════════════════════════════════════════════════════
      cardTheme: CardThemeData(
        color: AppColorsDark.cardSurface,
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }
}
