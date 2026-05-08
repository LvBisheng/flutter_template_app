import 'package:talker_flutter/talker_flutter.dart';

import 'long_log_printer.dart';

final longLogPrinter = LongLogPrinter();

/// App 内统一日志实例。
///
/// Talker 会把业务日志、异常和网络日志保存在内存历史中，测试人员可以在
/// App 内诊断页直接查看。正式生产包会隐藏诊断入口，网络层也不会挂 Talker Dio 拦截器。
final appTalker = TalkerFlutter.init(
  logger: TalkerLogger(output: longLogPrinter.print),
  settings: TalkerSettings(maxHistoryItems: 1000),
);

final appLogger = AppLogger(appTalker);

class AppLogger {
  const AppLogger(this._talker);

  final Talker _talker;

  void setConsoleEnabled(bool enabled) {
    longLogPrinter.setConsoleEnabled(enabled);
  }

  void i(Object? message) => _talker.info(message);
  void w(Object? message) => _talker.warning(message);
  void d(Object? message) => _talker.debug(message);

  void e(Object? message, {Object? error, StackTrace? stackTrace}) {
    _talker.error(message, error, stackTrace);
  }

  void handle(Object error, StackTrace stackTrace, [String? message]) {
    _talker.handle(error, stackTrace, message);
  }
}
