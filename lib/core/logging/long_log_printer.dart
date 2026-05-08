import 'package:flutter/foundation.dart';

/// 长日志控制台打印工具。
///
/// Talker 内存历史会保留完整日志，但 Android logcat/部分 IDE 控制台对单行
/// 长文本有长度限制。这里按行再分块输出，避免后端超长响应在控制台被截断。
/// release 或 prd 环境下会关闭控制台输出，避免生产环境打印敏感信息。
class LongLogPrinter {
  LongLogPrinter({this.chunkSize = 800}) : assert(chunkSize > 0);

  final int chunkSize;
  bool _consoleEnabled = !kReleaseMode;

  void setConsoleEnabled(bool enabled) {
    _consoleEnabled = !kReleaseMode && enabled;
  }

  void print(String message) {
    if (!_consoleEnabled) return;
    for (final line in splitForConsole(message, chunkSize: chunkSize)) {
      // debugPrint 会比 print 更适合 Flutter 控制台；真正避免截断的是上面的分块。
      debugPrint(line);
    }
  }

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
