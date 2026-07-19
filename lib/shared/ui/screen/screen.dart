// 屏幕适配模块统一导出
//
// 导出内容：
// - [ScreenConfig]：设计稿配置
// - [ScreenUtilExt]：适配扩展方法（.s / .sp）
// - [ScreenInit]：初始化 Widget
//
// ─────────────────────────────────────────────────────────────────────
// 两个扩展方法：
// ─────────────────────────────────────────────────────────────────────
//
// - `.s`  - 普通尺寸（宽度、高度、间距、圆角、图标等）
// - `.sp` - 字体专用（带最小值保护 + 字体缩放控制）
//
// ─────────────────────────────────────────────────────────────────────
// 使用示例：
// ─────────────────────────────────────────────────────────────────────
//
// ```dart
// import 'package:flutter_template_app/shared/ui/screen/screen.dart';
//
// // 普通尺寸用 .s
// Container(
//   width: 100.s,
//   height: 50.s,
//   padding: 16.s.paddingAll,
//   decoration: BoxDecoration(
//     borderRadius: BorderRadius.circular(8.s),
//   ),
//   child: Icon(Icons.star, size: 24.s),
// );
//
// // 字体用 .sp
// Text('Hello', style: TextStyle(fontSize: 14.sp));
//
// // 间距用 .s
// SizedBox(height: 12.s);
//
// // 自定义设计稿尺寸（在 app.dart）
// ScreenInit(
//   designWidth: 750,
//   designHeight: 1334,
//   child: AppRoot(),
// );
//
// // 禁用字体缩放（默认已禁用）
// ScreenConfig.disableSystemFontScale = true;
//
// // 自定义字体缩放（如老人模式）
// ScreenConfig.customFontScale = 1.2; // 放大 20%
// ```
export 'screen_config.dart';
export 'screen_util.dart';
export 'screen_init.dart';
