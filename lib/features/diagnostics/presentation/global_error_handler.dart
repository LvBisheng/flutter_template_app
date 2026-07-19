import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'runtime_error_controller.dart';

/// ─────────────────────────────────────────────────────────────────────
/// 全局错误处理器安装。
/// ─────────────────────────────────────────────────────────────────────
///
/// 【职责】
/// 在应用启动时安装全局错误处理器，捕获所有未处理的异常。
///
/// 【使用方式】
/// 在 bootstrap.dart 中调用：
/// ```dart
/// installGlobalErrorHandlers(container);
/// ```
///
/// 【捕获的错误类型】
/// 1. FlutterError：Widget 构建错误、渲染错误等
/// 2. Platform Error：异步异常、Native 错误等
///
/// 【行为】
/// - 捕获错误后，Flutter 默认的红色错误屏幕仍会显示
/// - 同时将错误记录到 RuntimeErrorController
/// - 开发者可在 App 内的"开发工具"面板查看错误列表
///
void installGlobalErrorHandlers(ProviderContainer container) {
  // Flutter 框架错误处理器
  // 捕获：Widget 构建错误、渲染错误、Layout 溢出等
  FlutterError.onError = (details) {
    // 保持 Flutter 默认行为（显示红色错误屏幕）
    FlutterError.presentError(details);

    // 同时记录到 RuntimeErrorController
    container
        .read(runtimeErrorControllerProvider.notifier)
        .captureFlutter(details);
  };

  // 平台异步错误处理器
  // 捕获：Future 中未处理的异常、Native 错误等
  PlatformDispatcher.instance.onError = (error, stackTrace) {
    container
        .read(runtimeErrorControllerProvider.notifier)
        .capturePlatform(error, stackTrace);

    // 返回 true 表示已处理，不再传递给其他处理器
    return true;
  };
}
