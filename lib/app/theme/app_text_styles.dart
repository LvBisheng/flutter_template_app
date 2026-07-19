import 'package:flutter/material.dart';

import 'app_colors.dart';

/// ─────────────────────────────────────────────────────────────────────
/// 应用文字样式定义。
/// ─────────────────────────────────────────────────────────────────────
///
/// 【设计目标】
/// 统一管理文字样式，确保全局一致性。
///
/// 【命名规范】
/// 按用途命名：title、section、body、muted 等，而非字号命名。
///
/// 【使用方式】
/// ```dart
/// Text('标题', style: AppTextStyles.title);
/// Text('正文内容', style: AppTextStyles.body);
/// ```
///
/// 【扩展建议】
/// 如需更多样式，按以下维度扩展：
/// - 大小层级：displayLarge、headlineMedium、bodySmall 等
/// - 使用场景：label、caption、overline 等
///
class AppTextStyles {
  AppTextStyles._();

  // ═══════════════════════════════════════════════════════════════════════
  // 标题样式
  // ═══════════════════════════════════════════════════════════════════════

  /// 页面大标题。
  ///
  /// 用于：页面顶部标题、重要信息标题等。
  /// 字号：22，字重：bold。
  static const title = TextStyle(
    fontSize: 22,
    fontWeight: FontWeight.w700,
    color: AppColors.textPrimary,
  );

  /// 区块小标题。
  ///
  /// 用于：卡片标题、列表分组标题等。
  /// 字号：17，字重：bold。
  static const section = TextStyle(
    fontSize: 17,
    fontWeight: FontWeight.w700,
    color: AppColors.textPrimary,
  );

  // ═══════════════════════════════════════════════════════════════════════
  // 正文样式
  // ═══════════════════════════════════════════════════════════════════════

  /// 普通正文。
  ///
  /// 用于：列表项内容、表单说明、普通文字等。
  /// 字号：14，行高：1.35（保证可读性）。
  static const body = TextStyle(
    fontSize: 14,
    height: 1.35,
    color: AppColors.textPrimary,
  );

  /// 辅助/弱化文字。
  ///
  /// 用于：时间戳、次要说明、提示文字等。
  /// 字号：13，颜色为次要文字色。
  static const muted = TextStyle(
    fontSize: 13,
    color: AppColors.textSecondary,
  );
}
