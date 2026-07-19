import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'screen_config.dart';

/// ScreenUtil 初始化。
///
/// 必须在 MaterialApp 外层调用，确保所有 Widget 都能使用适配功能。
///
/// ─────────────────────────────────────────────────────────────────────
/// 使用示例（在 main.dart 或 app.dart）：
/// ─────────────────────────────────────────────────────────────────────
///
/// ```dart
/// void main() {
///   runApp(const MyApp());
/// }
///
/// class MyApp extends StatelessWidget {
///   const MyApp({super.key});
///
///   @override
///   Widget build(BuildContext context) {
///     // 方式一：使用默认配置（375 × 812）
///     return ScreenInit(
///       child: AppRoot(),
///     );
///
///     // 方式二：自定义设计稿尺寸
///     return ScreenInit(
///       designWidth: 750,
///       designHeight: 1334,
///       child: AppRoot(),
///     );
///   }
/// }
/// ```
///
/// ─────────────────────────────────────────────────────────────────────
/// 注意事项：
/// ─────────────────────────────────────────────────────────────────────
///
/// 1. ScreenInit 必须包裹 MaterialApp，否则适配不生效
/// 2. designWidth/designHeight 是设计稿的尺寸，不是屏幕尺寸
/// 3. 如果设计稿是 2x 图（750px），设置 designWidth: 750
/// 4. 字体适配默认跟随系统，可在 ScreenConfig 中配置
class ScreenInit extends StatelessWidget {
  /// 设计稿宽度
  final double? designWidth;

  /// 设计稿高度
  final double? designHeight;

  /// 子 Widget
  final Widget child;

  const ScreenInit({
    super.key,
    this.designWidth,
    this.designHeight,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    // 更新 ScreenConfig（确保配置一致性）
    final width = designWidth ?? ScreenConfig.designWidth;
    final height = designHeight ?? ScreenConfig.designHeight;

    // 使用 ScreenUtilInit 进行初始化
    return ScreenUtilInit(
      // 设计稿尺寸
      designSize: Size(width, height),

      // 字体适配设置
      // splitScreenMode: true 表示在分屏模式下也启用适配
      splitScreenMode: true,

      // 最小字体适配值
      minTextAdapt: true,

      // 子 Widget
      builder: (context, widget) => child,
    );
  }
}

/// 初始化 ScreenUtil（不使用 Widget 包裹的方式）。
///
/// 适用于需要在 MaterialApp 内部动态初始化的场景。
///
/// ```dart
/// @override
/// Widget build(BuildContext context) {
///   // 在有 BuildContext 的地方调用
///   ScreenInitHelper.init(context);
///
///   return MaterialApp(...);
/// }
/// ```
class ScreenInitHelper {
  /// 初始化 ScreenUtil。
  ///
  /// 需要在有 MediaQuery 的地方调用（通常是 MaterialApp 内部）。
  static void init(BuildContext context) {
    ScreenUtil.init(context);
  }
}
