import 'package:flutter/foundation.dart';

/// ─────────────────────────────────────────────────────────────────────
/// 长日志控制台打印工具。
/// ─────────────────────────────────────────────────────────────────────
///
/// 【问题背景】
/// Talker 内存历史会保留完整日志，但：
/// - Android logcat 对单行有长度限制（约 4KB）
/// - 部分 IDE 控制台也会截断超长行
/// - 后端接口返回的 JSON 可能非常长
///
/// 【解决方案】
/// 按行分块输出，避免超长日志在控制台被截断。
/// 每块带有序号标记：`[long-log 1/3]`, `[long-log 2/3]`...
///
/// 【安全考虑】
/// 由 EnvConfig.isDevMode 统一控制，非开发模式下关闭控制台输出。
///
class LongLogPrinter {
  LongLogPrinter({this.chunkSize = 800}) : assert(chunkSize > 0);

  /// 每块最大字符数。
  ///
  /// 默认 800，留有余量避免边界情况。
  final int chunkSize;

  /// 是否启用控制台输出。
  ///
  /// 由外部（EnvConfig._applyConsolePolicy）统一控制。
  bool _consoleEnabled = false;

  /// 设置是否启用控制台输出。
  ///
  /// 【调用方】
  /// EnvConfig._applyConsolePolicy() 根据 isDevMode 统一控制。
  void setConsoleEnabled(bool enabled) {
    _consoleEnabled = enabled;
  }

  /// 打印日志到控制台。
  ///
  /// 超长日志会被自动分块，每块带序号标记。
  void print(String message) {
    if (!_consoleEnabled) return;
    for (final line in splitForConsole(message, chunkSize: chunkSize)) {
      // debugPrint 会比 print 更适合 Flutter 控制台
      // 真正避免截断的是上面的分块逻辑
      debugPrint(line);
    }
  }

  /// 将超长字符串分块（供测试使用）。
  ///
  /// 【算法】
  /// 1. 先按换行符拆分
  /// 2. 对每行判断是否需要分块
  /// 3. 需要分块的行按 chunkSize 切割，并添加序号标记
  ///
  @visibleForTesting
  static List<String> splitForConsole(String message, {int chunkSize = 800}) {
    final result = <String>[];
    final lines = message.split('\n');
    for (final line in lines) {
      if (line.length <= chunkSize) {
        result.add(line);
        continue;
      }

      final total = (line.length / chunkSize).ceil();
      for (var index = 0; index < total; index++) {
        final start = index * chunkSize;
        final end = (start + chunkSize).clamp(0, line.length);
        result.add(
          '[long-log ${index + 1}/$total] ${line.substring(start, end)}',
        );
      }
    }
    return result;
  }
}
