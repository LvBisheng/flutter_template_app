enum RuntimeErrorSource { flutter, platform, router }

class RuntimeErrorReport {
  RuntimeErrorReport({
    required this.id,
    required this.source,
    required this.message,
    required this.stackTrace,
    required this.occurredAt,
    this.context,
  });

  final int id;
  final RuntimeErrorSource source;
  final String message;
  final String stackTrace;
  final DateTime occurredAt;
  final String? context;

  String get sourceName => switch (source) {
    RuntimeErrorSource.flutter => 'Flutter',
    RuntimeErrorSource.platform => 'Platform',
    RuntimeErrorSource.router => 'Router',
  };

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
