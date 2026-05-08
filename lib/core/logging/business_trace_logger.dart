import 'dart:async';
import 'dart:collection';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../network/api_client.dart';
import 'app_logger.dart';

final businessTraceLoggerProvider = Provider<BusinessTraceLogger>((ref) {
  return BusinessTraceLogger(
    uploader: ApiBusinessLogUploadSink(ref.read(apiClientProvider)),
  );
});

enum BusinessTraceLevel { debug, info, warning, error }

enum BusinessTraceUploadStatus { uploaded, skipped, failed }

class BusinessTraceUploadResult {
  const BusinessTraceUploadResult._(this.status, [this.message]);

  const BusinessTraceUploadResult.uploaded()
    : this._(BusinessTraceUploadStatus.uploaded);
  const BusinessTraceUploadResult.skipped([String? message])
    : this._(BusinessTraceUploadStatus.skipped, message);
  const BusinessTraceUploadResult.failed([String? message])
    : this._(BusinessTraceUploadStatus.failed, message);

  final BusinessTraceUploadStatus status;
  final String? message;

  bool get isUploaded => status == BusinessTraceUploadStatus.uploaded;
}

class BusinessTraceEvent {
  BusinessTraceEvent({
    required this.level,
    required this.name,
    required this.occurredAt,
    this.message,
    this.attributes = const {},
  });

  final BusinessTraceLevel level;
  final String name;
  final String? message;
  final DateTime occurredAt;
  final Map<String, Object?> attributes;

  Map<String, Object?> toJson() => {
    'level': level.name,
    'name': name,
    if (message != null) 'message': message,
    'occurred_at': occurredAt.toIso8601String(),
    if (attributes.isNotEmpty) 'attributes': attributes,
  };
}

class BusinessTraceSnapshot {
  BusinessTraceSnapshot({
    required this.traceId,
    required this.flow,
    required this.startedAt,
    required this.endedAt,
    required this.events,
    this.businessId,
    this.attributes = const {},
    this.error,
    this.stackTrace,
  });

  final String traceId;
  final String flow;
  final String? businessId;
  final DateTime startedAt;
  final DateTime endedAt;
  final Map<String, Object?> attributes;
  final List<BusinessTraceEvent> events;
  final String? error;
  final String? stackTrace;

  Map<String, Object?> toJson() => {
    'trace_id': traceId,
    'flow': flow,
    if (businessId != null) 'business_id': businessId,
    'started_at': startedAt.toIso8601String(),
    'ended_at': endedAt.toIso8601String(),
    if (attributes.isNotEmpty) 'attributes': attributes,
    'events': [for (final event in events) event.toJson()],
    if (error != null) 'error': error,
    if (stackTrace != null) 'stack_trace': stackTrace,
  };
}

abstract class BusinessLogUploadSink {
  Future<void> upload(BusinessTraceSnapshot snapshot);
}

class ApiBusinessLogUploadSink implements BusinessLogUploadSink {
  const ApiBusinessLogUploadSink(this._client);

  final ApiClient _client;

  @override
  Future<void> upload(BusinessTraceSnapshot snapshot) async {
    await _client.post<Map<String, dynamic>>(
      '/diagnostics/business-log/upload',
      data: snapshot.toJson(),
    );
  }
}

/// 业务追踪日志收集与上传门面。
///
/// 设计目标是“可随手调用、绝不影响用户流程”：记录、快照和上传内部都会
/// 捕获异常。调用方可以用长流程模式记录多个事件，也可以用 one-shot 模式
/// 直接上传一条简单业务错误日志。
class BusinessTraceLogger {
  BusinessTraceLogger({
    required BusinessLogUploadSink uploader,
    int maxSessions = 20,
    int maxEventsPerSession = 120,
  }) : _uploader = uploader,
       _maxSessions = maxSessions,
       _maxEventsPerSession = maxEventsPerSession;

  final BusinessLogUploadSink _uploader;
  final int _maxSessions;
  final int _maxEventsPerSession;
  final _sessions = <String, _BusinessTraceSession>{};

  /// 开始一次长流程追踪，例如 OCR、蓝牙连接、启动弹框链路。
  String startFlow(
    String flow, {
    String? traceId,
    String? businessId,
    Map<String, Object?> attributes = const {},
  }) {
    try {
      final id = traceId ?? _newTraceId(flow);
      _sessions[id] = _BusinessTraceSession(
        traceId: id,
        flow: flow,
        businessId: businessId,
        startedAt: DateTime.now(),
        attributes: _sanitizeMap(attributes),
        maxEvents: _maxEventsPerSession,
      );
      _trimSessions();
      return id;
    } catch (e) {
      appLogger.w('Business trace start ignored: $e');
      return traceId ?? _newTraceId(flow);
    }
  }

  void debug(
    String traceId,
    String name, {
    String? message,
    Map<String, Object?> attributes = const {},
  }) {
    _record(traceId, BusinessTraceLevel.debug, name, message, attributes);
  }

  void info(
    String traceId,
    String name, {
    String? message,
    Map<String, Object?> attributes = const {},
  }) {
    _record(traceId, BusinessTraceLevel.info, name, message, attributes);
  }

  void warning(
    String traceId,
    String name, {
    String? message,
    Map<String, Object?> attributes = const {},
  }) {
    _record(traceId, BusinessTraceLevel.warning, name, message, attributes);
  }

  void error(
    String traceId,
    String name, {
    Object? error,
    StackTrace? stackTrace,
    Map<String, Object?> attributes = const {},
  }) {
    _record(traceId, BusinessTraceLevel.error, name, error?.toString(), {
      ...attributes,
      if (stackTrace != null) 'stack_trace': stackTrace.toString(),
    });
  }

  BusinessTraceSnapshot? snapshot(
    String traceId, {
    Object? error,
    StackTrace? stackTrace,
  }) {
    try {
      final session = _sessions[traceId];
      if (session == null) return null;
      return session.toSnapshot(error: error, stackTrace: stackTrace);
    } catch (e) {
      appLogger.w('Business trace snapshot ignored: $e');
      return null;
    }
  }

  Future<BusinessTraceUploadResult> upload(
    String traceId, {
    Object? error,
    StackTrace? stackTrace,
    bool closeAfterUpload = false,
  }) async {
    try {
      final snapshot = this.snapshot(
        traceId,
        error: error,
        stackTrace: stackTrace,
      );
      if (snapshot == null) {
        return const BusinessTraceUploadResult.skipped('trace not found');
      }
      await _uploader.upload(snapshot);
      if (closeAfterUpload) close(traceId);
      return const BusinessTraceUploadResult.uploaded();
    } catch (e) {
      appLogger.w('Business trace upload failed silently: $e');
      return BusinessTraceUploadResult.failed(e.toString());
    }
  }

  /// 上传一条一次性业务日志。
  ///
  /// 适合“下载 PDF 失败”“某 SDK 初始化失败”这类没有必要提前创建 trace 的
  /// 单点场景。上传失败会被转换成 [BusinessTraceUploadResult.failed]。
  Future<BusinessTraceUploadResult> uploadOneShot({
    required String flow,
    required String name,
    String? message,
    String? businessId,
    BusinessTraceLevel level = BusinessTraceLevel.error,
    Map<String, Object?> attributes = const {},
    Object? error,
    StackTrace? stackTrace,
  }) async {
    final traceId = startFlow(
      flow,
      businessId: businessId,
      attributes: {'mode': 'one_shot'},
    );
    _record(traceId, level, name, message ?? error?.toString(), attributes);
    return upload(
      traceId,
      error: error,
      stackTrace: stackTrace,
      closeAfterUpload: true,
    );
  }

  /// one-shot 的 fire-and-forget 版本，适合业务 catch 分支里直接调用。
  void uploadOneShotSilently({
    required String flow,
    required String name,
    String? message,
    String? businessId,
    BusinessTraceLevel level = BusinessTraceLevel.error,
    Map<String, Object?> attributes = const {},
    Object? error,
    StackTrace? stackTrace,
  }) {
    unawaited(
      uploadOneShot(
        flow: flow,
        name: name,
        message: message,
        businessId: businessId,
        level: level,
        attributes: attributes,
        error: error,
        stackTrace: stackTrace,
      ),
    );
  }

  /// 长流程上传的 fire-and-forget 版本，上传失败不会冒泡到用户流程。
  void uploadSilently(
    String traceId, {
    Object? error,
    StackTrace? stackTrace,
    bool closeAfterUpload = false,
  }) {
    unawaited(
      upload(
        traceId,
        error: error,
        stackTrace: stackTrace,
        closeAfterUpload: closeAfterUpload,
      ),
    );
  }

  void close(String traceId) {
    try {
      _sessions.remove(traceId);
    } catch (_) {}
  }

  void _record(
    String traceId,
    BusinessTraceLevel level,
    String name,
    String? message,
    Map<String, Object?> attributes,
  ) {
    try {
      final session = _sessions[traceId];
      if (session == null) return;
      session.add(
        BusinessTraceEvent(
          level: level,
          name: name,
          message: _limitString(message),
          occurredAt: DateTime.now(),
          attributes: _sanitizeMap(attributes),
        ),
      );
    } catch (e) {
      appLogger.w('Business trace record ignored: $e');
    }
  }

  void _trimSessions() {
    while (_sessions.length > _maxSessions) {
      _sessions.remove(_sessions.keys.first);
    }
  }

  String _newTraceId(String flow) {
    final safeFlow = flow.replaceAll(RegExp(r'[^a-zA-Z0-9_.-]'), '_');
    return '$safeFlow-${DateTime.now().microsecondsSinceEpoch}';
  }
}

class _BusinessTraceSession {
  _BusinessTraceSession({
    required this.traceId,
    required this.flow,
    required this.startedAt,
    required this.maxEvents,
    this.businessId,
    this.attributes = const {},
  });

  final String traceId;
  final String flow;
  final String? businessId;
  final DateTime startedAt;
  final int maxEvents;
  final Map<String, Object?> attributes;
  final _events = Queue<BusinessTraceEvent>();

  void add(BusinessTraceEvent event) {
    _events.addLast(event);
    while (_events.length > maxEvents) {
      _events.removeFirst();
    }
  }

  BusinessTraceSnapshot toSnapshot({Object? error, StackTrace? stackTrace}) {
    return BusinessTraceSnapshot(
      traceId: traceId,
      flow: flow,
      businessId: businessId,
      startedAt: startedAt,
      endedAt: DateTime.now(),
      attributes: attributes,
      events: _events.toList(growable: false),
      error: _limitString(error?.toString()),
      stackTrace: _limitString(stackTrace?.toString(), maxLength: 12000),
    );
  }
}

Map<String, Object?> _sanitizeMap(Map<String, Object?> source) {
  final result = <String, Object?>{};
  for (final entry in source.entries.take(30)) {
    final key = _limitString(entry.key, maxLength: 80) ?? 'unknown';
    result[key] = _isSensitiveKey(key)
        ? '***'
        : _sanitizeValue(entry.value, depth: 0);
  }
  return result;
}

Object? _sanitizeValue(Object? value, {required int depth}) {
  if (value == null || value is num || value is bool) return value;
  if (value is DateTime) return value.toIso8601String();
  if (value is String) return _limitString(value);
  if (depth >= 2) return _limitString(value.toString());
  if (value is Iterable) {
    return [
      for (final item in value.take(20)) _sanitizeValue(item, depth: depth + 1),
    ];
  }
  if (value is Map) {
    final result = <String, Object?>{};
    for (final entry in value.entries.take(20)) {
      final key =
          _limitString(entry.key.toString(), maxLength: 80) ?? 'unknown';
      result[key] = _isSensitiveKey(key)
          ? '***'
          : _sanitizeValue(entry.value, depth: depth + 1);
    }
    return result;
  }
  return _limitString(value.toString());
}

String? _limitString(String? value, {int maxLength = 800}) {
  if (value == null) return null;
  if (value.length <= maxLength) return value;
  return '${value.substring(0, maxLength)}...';
}

bool _isSensitiveKey(String key) {
  final lower = key.toLowerCase();
  return lower.contains('token') ||
      lower.contains('password') ||
      lower.contains('secret') ||
      lower.contains('authorization') ||
      lower.contains('id_number') ||
      lower.contains('idnumber');
}
