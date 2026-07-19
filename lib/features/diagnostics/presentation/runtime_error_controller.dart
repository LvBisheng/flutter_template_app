import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/logging/app_logger.dart';
import '../domain/runtime_error_report.dart';

/// ─────────────────────────────────────────────────────────────────────
/// 运行时错误状态。
/// ─────────────────────────────────────────────────────────────────────
///
/// 【职责】
/// 保存运行时错误报告列表。
///
class RuntimeErrorState {
  const RuntimeErrorState({this.reports = const []});

  /// 错误报告列表（按时间倒序，最新的在前）。
  final List<RuntimeErrorReport> reports;

  /// 获取最新的错误报告。
  RuntimeErrorReport? get latest => reports.isEmpty ? null : reports.first;

  RuntimeErrorState copyWith({List<RuntimeErrorReport>? reports}) {
    return RuntimeErrorState(reports: reports ?? this.reports);
  }
}

// ═══════════════════════════════════════════════════════════════════════
// Provider
// ═══════════════════════════════════════════════════════════════════════

/// RuntimeErrorController Provider。
final runtimeErrorControllerProvider =
    NotifierProvider<RuntimeErrorController, RuntimeErrorState>(
      RuntimeErrorController.new,
    );

/// ─────────────────────────────────────────────────────────────────────
/// 运行时错误捕获控制器。
/// ─────────────────────────────────────────────────────────────────────
///
/// 【职责】
/// 1. 捕获 Flutter 框架错误
/// 2. 捕获平台异步错误
/// 3. 捕获路由错误
/// 4. 去重处理（避免同一错误短时间内重复记录）
/// 5. 限制最大数量（防止内存溢出）
///
/// 【去重策略】
/// 使用 "来源|消息|首行堆栈" 作为指纹，2 秒内相同错误不重复记录。
///
/// 【限制数量】
/// 最多保留 30 条错误报告，超出后丢弃最旧的。
///
class RuntimeErrorController extends Notifier<RuntimeErrorState> {
  /// 最大保留错误报告数量。
  static const _maxReports = 30;

  /// 去重时间窗口（同一错误在此时间内不重复记录）。
  static const _duplicateWindow = Duration(seconds: 2);

  int _nextId = 0;
  String? _lastFingerprint;
  DateTime? _lastCapturedAt;

  @override
  RuntimeErrorState build() => const RuntimeErrorState();

  /// 捕获 Flutter 框架错误。
  ///
  /// 【参数】
  /// - [details]：Flutter 错误详情（由 FlutterError.onError 回调）
  ///
  RuntimeErrorReport captureFlutter(FlutterErrorDetails details) {
    final report = _capture(
      source: RuntimeErrorSource.flutter,
      message: details.exceptionAsString(),
      stackTrace: details.stack?.toString() ?? details.toString(),
      context: details.context?.toString(),
    );
    return report;
  }

  /// 捕获平台异步错误。
  ///
  /// 【参数】
  /// - [error]：错误对象
  /// - [stackTrace]：堆栈跟踪
  ///
  RuntimeErrorReport capturePlatform(Object error, StackTrace stackTrace) {
    return _capture(
      source: RuntimeErrorSource.platform,
      message: error.toString(),
      stackTrace: stackTrace.toString(),
    );
  }

  /// 捕获路由错误。
  ///
  /// 【参数】
  /// - [error]：错误对象
  /// - [stackTrace]：堆栈跟踪（可选，为空时使用当前堆栈）
  ///
  RuntimeErrorReport captureRouter(Object error, StackTrace? stackTrace) {
    return _capture(
      source: RuntimeErrorSource.router,
      message: error.toString(),
      stackTrace: stackTrace?.toString() ?? StackTrace.current.toString(),
    );
  }

  /// 清空所有错误报告。
  void clear() {
    state = const RuntimeErrorState();
  }

  /// 内部捕获方法。
  ///
  /// 【流程】
  /// 1. 生成指纹（来源|消息|首行堆栈）
  /// 2. 检查是否为重复错误（2 秒窗口内）
  /// 3. 创建报告对象
  /// 4. 添加到列表头部（最新的在前）
  /// 5. 限制最大数量
  /// 6. 记录日志
  ///
  RuntimeErrorReport _capture({
    required RuntimeErrorSource source,
    required String message,
    required String stackTrace,
    String? context,
  }) {
    final now = DateTime.now();

    // 去重检查
    final fingerprint = '$source|$message|${_firstStackLine(stackTrace)}';
    final lastCapturedAt = _lastCapturedAt;
    if (_lastFingerprint == fingerprint &&
        lastCapturedAt != null &&
        now.difference(lastCapturedAt) < _duplicateWindow) {
      return state.latest!;
    }

    // 更新去重状态
    _lastFingerprint = fingerprint;
    _lastCapturedAt = now;

    // 创建报告
    final report = RuntimeErrorReport(
      id: ++_nextId,
      source: source,
      message: message,
      stackTrace: stackTrace,
      context: context,
      occurredAt: now,
    );

    // 记录日志
    appLogger.w('Runtime ${report.sourceName} error captured: $message');

    // 更新状态（保留最新的 30 条）
    state = state.copyWith(
      reports: [report, ...state.reports].take(_maxReports).toList(),
    );

    return report;
  }

  /// 提取堆栈首行（用于去重指纹）。
  String _firstStackLine(String stackTrace) {
    final lines = stackTrace.trim().split('\n');
    return lines.isEmpty ? '' : lines.first;
  }
}
