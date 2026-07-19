import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter/material.dart';

import 'screen_config.dart';

/// 屏幕适配扩展方法。
///
/// ─────────────────────────────────────────────────────────────────────
/// 核心设计原则：所有适配统一基于宽度
/// ─────────────────────────────────────────────────────────────────────
///
/// 原因：
/// 1. UI 还原度高，设计师友好（标注宽度直接用）
/// 2. 避免宽高分别缩放导致的变形问题
/// 3. 行业主流做法
///
/// ─────────────────────────────────────────────────────────────────────
/// 两个扩展方法：
/// ─────────────────────────────────────────────────────────────────────
///
/// - `.s`  - 普通尺寸（宽度、高度、间距、圆角等）
/// - `.sp` - 字体专用（带最小值保护 + 字体缩放控制）
///
/// ─────────────────────────────────────────────────────────────────────
/// 使用示例：
/// ─────────────────────────────────────────────────────────────────────
///
/// ```dart
/// // 普通尺寸用 .s
/// Container(
///   width: 100.s,
///   height: 50.s,
///   padding: 16.s.paddingAll,
///   decoration: BoxDecoration(
///     borderRadius: BorderRadius.circular(8.s),
///   ),
/// );
///
/// // 字体用 .sp
/// Text('Hello', style: TextStyle(fontSize: 14.sp));
///
/// // 间距用 .s
/// SizedBox(height: 12.s);
///
/// // 图标用 .s
/// Icon(Icons.star, size: 24.s);
/// ```
extension ScreenUtilExt on num {
  /// 普通尺寸适配（基于宽度缩放）。
  ///
  /// 用于：宽度、高度、间距、圆角、图标大小等。
  ///
  /// 示例：
  /// - 设计稿标注 100px → 写 `100.s`
  /// - 设计稿标注 8px 圆角 → 写 `8.s`
  double get s {
    if (!ScreenConfig.enabled) return toDouble();
    return ScreenUtil().setWidth(this);
  }

  /// 字体适配（基于宽度缩放，带最小值保护）。
  ///
  /// 用于：字体大小。
  ///
  /// 计算公式：
  /// ```
  /// 最终字体 = 设计稿字体 * (屏幕宽度 / 设计稿宽度) * customFontScale
  /// ```
  ///
  /// 示例：
  /// - 设计稿 14sp，屏幕 375，设计稿宽度 375，缩放 1.0
  ///   → 最终 = 14 * (375/375) * 1.0 = 14
  ///
  /// - 设计稿 14sp，屏幕 375，设计稿宽度 375，缩放 1.5（巨大）
  ///   → 最终 = 14 * 1 * 1.5 = 21
  double get sp {
    if (!ScreenConfig.enabled) return toDouble();

    // 1. 基础字体大小（基于宽度适配）
    final baseFontSize = ScreenUtil().setWidth(this);

    // 2. 应用字体缩放
    double fontSize;
    if (ScreenConfig.disableSystemFontScale) {
      // 禁用系统字体缩放时，使用 customFontScale
      // 如果 customFontScale 为 null，默认为 1.0（标准大小）
      final scale = ScreenConfig.customFontScale ?? 1.0;
      fontSize = baseFontSize * scale;
    } else {
      // 跟随系统字体缩放
      fontSize = ScreenUtil().setSp(this);
    }

    // 3. 最小值保护
    if (fontSize < ScreenConfig.minFontSize) {
      return ScreenConfig.minFontSize;
    }

    return fontSize;
  }

  /// EdgeInsets.all 适配。
  ///
  /// 示例：`16.s.paddingAll` → `EdgeInsets.all(16.s)`
  EdgeInsets get paddingAll => EdgeInsets.all(s);

  /// EdgeInsets.symmetric 水平适配。
  ///
  /// 示例：`16.s.paddingH` → `EdgeInsets.symmetric(horizontal: 16.s)`
  EdgeInsets get paddingH => EdgeInsets.symmetric(horizontal: s);

  /// EdgeInsets.symmetric 垂直适配。
  ///
  /// 示例：`12.s.paddingV` → `EdgeInsets.symmetric(vertical: 12.s)`
  EdgeInsets get paddingV => EdgeInsets.symmetric(vertical: s);

  /// SizedBox 宽度。
  ///
  /// 示例：`100.s.sizedBoxW` → `SizedBox(width: 100.s)`
  SizedBox get sizedBoxW => SizedBox(width: s);

  /// SizedBox 高度。
  ///
  /// 示例：`12.s.sizedBoxH` → `SizedBox(height: 12.s)`
  SizedBox get sizedBoxH => SizedBox(height: s);
}

/// ─────────────────────────────────────────────────────────────────────
/// 原生扩展保留说明（flutter_screenutil 自带）
/// ─────────────────────────────────────────────────────────────────────
///
/// 如果你需要基于高度适配（极少情况），可以使用原生扩展：
///
/// - `.w` - 基于宽度适配
/// - `.h` - 基于高度适配（慎用，可能导致变形）
/// - `.radius` - 圆角适配
///
/// 需要手动导入：
/// ```dart
/// import 'package:flutter_screenutil/flutter_screenutil.dart';
/// ```
///
/// 注意：一般情况推荐统一使用 `.s` 和 `.sp`，不要混用。
/// ─────────────────────────────────────────────────────────────────────
