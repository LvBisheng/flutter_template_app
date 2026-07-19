import 'package:talker_flutter/talker_flutter.dart';

import 'long_log_printer.dart';

// ═══════════════════════════════════════════════════════════════════════
// 全局日志实例
// ═══════════════════════════════════════════════════════════════════════

/// 长日志打印器实例。
///
/// 用于处理超长日志的分块输出。
final longLogPrinter = LongLogPrinter();

/// ─────────────────────────────────────────────────────────────────────
/// App 内统一日志实例（基于 Talker）。
/// ─────────────────────────────────────────────────────────────────────
///
/// 【职责】
/// 1. 统一管理应用内的日志输出
/// 2. 将日志保存到内存历史中，供诊断页查看
/// 3. 支持控制台输出的开关控制
///
/// 【架构说明】
/// Talker 会把业务日志、异常和网络日志保存在内存历史中：
/// - 开发环境：测试人员可以在 App 内诊断页直接查看
/// - 生产环境：隐藏诊断入口，网络层也不会挂 Talker Dio 拦截器
///
/// 【使用方式】
/// ```dart
/// appLogger.i('用户点击了按钮');
/// appLogger.w('网络请求超时，使用缓存数据');
/// appLogger.e('登录失败', error: e, stackTrace: st);
/// ```
///
final appTalker = TalkerFlutter.init(
  logger: TalkerLogger(output: longLogPrinter.print),
  settings: TalkerSettings(maxHistoryItems: 1000),
);

/// AppLogger 包装类。
///
/// 提供更简洁的 API，隐藏 Talker 的复杂性。
final appLogger = AppLogger(appTalker);

/// ─────────────────────────────────────────────────────────────────────
/// App 日志封装类。
/// ─────────────────────────────────────────────────────────────────────
///
/// 【职责】
/// 封装 Talker，提供简洁的日志 API。
///
/// 【日志级别】
/// - [i] (info): 普通业务日志，用于追踪流程
/// - [w] (warning): 警告日志，不影响主流程但需要关注
/// - [d] (debug): 调试日志，仅开发环境可见
/// - [e] (error): 错误日志，需要附带异常和堆栈
///
/// 【最佳实践】
/// - 关键流程节点用 info 记录
/// - 异常捕获用 error + stackTrace
/// - 敏感信息已脱敏，但仍需注意不要记录密码等
///
class AppLogger {
  const AppLogger(this._talker);

  final Talker _talker;

  /// 设置是否启用控制台输出。
  ///
  /// 生产环境建议关闭，避免敏感信息泄露。
  void setConsoleEnabled(bool enabled) {
    longLogPrinter.setConsoleEnabled(enabled);
  }

  /// 记录 info 级别日志。
  ///
  /// 用于记录普通业务流程，如"用户登录成功"。
  void i(Object? message) => _talker.info(message);

  /// 记录 warning 级别日志。
  ///
  /// 用于记录不影响主流程但需要关注的情况，如"网络超时，使用缓存"。
  void w(Object? message) => _talker.warning(message);

  /// 记录 debug 级别日志。
  ///
  /// 用于开发调试，生产环境会自动过滤。
  void d(Object? message) => _talker.debug(message);

  /// 记录 error 级别日志。
  ///
  /// 用于记录错误，必须附带上下文信息。
  ///
  /// [message] 错误描述
  /// [error] 异常对象
  /// [stackTrace] 堆栈信息
  void e(Object? message, {Object? error, StackTrace? stackTrace}) {
    _talker.error(message, error, stackTrace);
  }

  /// 统一处理未捕获异常。
  ///
  /// 用于 Flutter 错误处理回调，将异常记录到日志系统。
  void handle(Object error, StackTrace stackTrace, [String? message]) {
    _talker.handle(error, stackTrace, message);
  }
}
