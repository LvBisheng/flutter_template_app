import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/logging/app_logger.dart';
import '../domain/runtime_error_report.dart';

class RuntimeErrorState {
  const RuntimeErrorState({this.reports = const []});

  final List<RuntimeErrorReport> reports;

  RuntimeErrorReport? get latest => reports.isEmpty ? null : reports.first;

  RuntimeErrorState copyWith({List<RuntimeErrorReport>? reports}) {
    return RuntimeErrorState(reports: reports ?? this.reports);
  }
}

final runtimeErrorControllerProvider =
    NotifierProvider<RuntimeErrorController, RuntimeErrorState>(
      RuntimeErrorController.new,
    );

class RuntimeErrorController extends Notifier<RuntimeErrorState> {
  static const _maxReports = 30;
  static const _duplicateWindow = Duration(seconds: 2);

  int _nextId = 0;
  String? _lastFingerprint;
  DateTime? _lastCapturedAt;

  @override
  RuntimeErrorState build() => const RuntimeErrorState();

  RuntimeErrorReport captureFlutter(FlutterErrorDetails details) {
    final report = _capture(
      source: RuntimeErrorSource.flutter,
      message: details.exceptionAsString(),
      stackTrace: details.stack?.toString() ?? details.toString(),
      context: details.context?.toString(),
    );
    return report;
  }

  RuntimeErrorReport capturePlatform(Object error, StackTrace stackTrace) {
    return _capture(
      source: RuntimeErrorSource.platform,
      message: error.toString(),
      stackTrace: stackTrace.toString(),
    );
  }

  RuntimeErrorReport captureRouter(Object error, StackTrace? stackTrace) {
    return _capture(
      source: RuntimeErrorSource.router,
      message: error.toString(),
      stackTrace: stackTrace?.toString() ?? StackTrace.current.toString(),
    );
  }

  void clear() {
    state = const RuntimeErrorState();
  }

  RuntimeErrorReport _capture({
    required RuntimeErrorSource source,
    required String message,
    required String stackTrace,
    String? context,
  }) {
    final now = DateTime.now();
    final fingerprint = '$source|$message|${_firstStackLine(stackTrace)}';
    final lastCapturedAt = _lastCapturedAt;
    if (_lastFingerprint == fingerprint &&
        lastCapturedAt != null &&
        now.difference(lastCapturedAt) < _duplicateWindow) {
      return state.latest!;
    }
    _lastFingerprint = fingerprint;
    _lastCapturedAt = now;
    final report = RuntimeErrorReport(
      id: ++_nextId,
      source: source,
      message: message,
      stackTrace: stackTrace,
      context: context,
      occurredAt: now,
    );
    appLogger.w('Runtime ${report.sourceName} error captured: $message');
    state = state.copyWith(
      reports: [report, ...state.reports].take(_maxReports).toList(),
    );
    return report;
  }

  String _firstStackLine(String stackTrace) {
    final lines = stackTrace.trim().split('\n');
    return lines.isEmpty ? '' : lines.first;
  }
}
