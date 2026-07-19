/// ─────────────────────────────────────────────────────────────────────
/// 运行时错误来源。
/// ─────────────────────────────────────────────────────────────────────
///
/// 【来源说明】
/// - flutter：Flutter 框架错误（Widget 构建错误、渲染错误等）
/// - platform：平台错误（异步异常、Native 错误等）
/// - router：路由错误（导航错误、路由配置错误等）
///
enum RuntimeErrorSource { flutter, platform, router }

/// ─────────────────────────────────────────────────────────────────────
/// 运行时错误报告。
/// ─────────────────────────────────────────────────────────────────────
///
/// 【职责】
/// 封装运行时错误信息，用于开发和调试。
///
/// 【字段说明】
/// - [id]：唯一标识符（自增）
/// - [source]：错误来源
/// - [message]：错误消息
/// - [stackTrace]：堆栈跟踪
/// - [occurredAt]：发生时间
/// - [context]：上下文信息（可选）
///
/// 【使用方式】
/// 通过 RuntimeErrorController 捕获错误，自动生成报告。
///
class RuntimeErrorReport {
  RuntimeErrorReport({
    required this.id,
    required this.source,
    required this.message,
    required this.stackTrace,
    required this.occurredAt,
    this.context,
  });

  /// 唯一标识符（自增）。
  final int id;

  /// 错误来源。
  final RuntimeErrorSource source;

  /// 错误消息。
  final String message;

  /// 堆栈跟踪。
  final String stackTrace;

  /// 发生时间。
  final DateTime occurredAt;

  /// 上下文信息（如 Widget 名称、操作名称等）。
  final String? context;

  /// 获取来源显示名称。
  String get sourceName => switch (source) {
    RuntimeErrorSource.flutter => 'Flutter',
    RuntimeErrorSource.platform => 'Platform',
    RuntimeErrorSource.router => 'Router',
  };

  /// 生成可分享的错误报告文本。
  ///
  /// 【格式】
  /// ```
  /// [来源] 错误消息
  /// Time: ISO8601 时间
  /// Context: 上下文信息（如有）
  ///
  /// 堆栈跟踪
  /// ```
  String toShareText() {
    final buffer = StringBuffer()
      ..writeln('[$sourceName] $message')
      ..writeln('Time: ${occurredAt.toIso8601String()}');
    final contextText = context;
    if (contextText != null && contextText.isNotEmpty) {
      buffer.writeln('Context: $contextText');
    }
    buffer
      ..writeln()
      ..writeln(stackTrace);
    return buffer.toString();
  }
}
