import 'dart:async';
import 'dart:collection';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../network/api_client.dart';
import 'app_logger.dart';

// ═══════════════════════════════════════════════════════════════════════
// Provider 定义
// ═══════════════════════════════════════════════════════════════════════

/// BusinessTraceLogger Provider。
///
/// 【依赖注入】
/// 通过 Provider 注入，确保全局单例。
/// 上传逻辑通过 ApiBusinessLogUploadSink 实现，方便测试时替换。
///
final businessTraceLoggerProvider = Provider<BusinessTraceLogger>((ref) {
  return BusinessTraceLogger(
    uploader: ApiBusinessLogUploadSink(ref.read(apiClientProvider)),
  );
});

// ═══════════════════════════════════════════════════════════════════════
// 枚举与结果类型
// ═══════════════════════════════════════════════════════════════════════

/// 业务追踪日志级别。
enum BusinessTraceLevel { debug, info, warning, error }

/// 上传状态。
enum BusinessTraceUploadStatus { uploaded, skipped, failed }

/// ─────────────────────────────────────────────────────────────────────
/// 业务追踪上传结果。
/// ─────────────────────────────────────────────────────────────────────
///
/// 【使用场景】
/// 调用方可以根据结果决定后续操作：
/// - uploaded：上传成功
/// - skipped：trace 不存在或其他原因跳过
/// - failed：网络错误等
///
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

// ═══════════════════════════════════════════════════════════════════════
// 数据模型
// ═══════════════════════════════════════════════════════════════════════

/// ─────────────────────────────────────────────────────────────────────
/// 业务追踪事件。
/// ─────────────────────────────────────────────────────────────────────
///
/// 【字段说明】
/// - [level]：日志级别（debug/info/warning/error）
/// - [name]：事件名称，如 "ocr_scan_start"
/// - [occurredAt]：事件发生时间
/// - [message]：可选的详细消息
/// - [attributes]：附加属性（键值对）
///
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

/// ─────────────────────────────────────────────────────────────────────
/// 业务追踪快照（完整流程的瞬时状态）。
/// ─────────────────────────────────────────────────────────────────────
///
/// 【用途】
/// 当流程结束或需要上传时，生成快照用于上报。
///
/// 【字段说明】
/// - [traceId]：唯一追踪 ID
/// - [flow]：流程名称，如 "identity_update"
/// - [businessId]：业务 ID（如客户 ID）
/// - [startedAt] / [endedAt]：流程起止时间
/// - [events]：流程中的所有事件
/// - [error] / [stackTrace]：流程失败时的错误信息
///
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

// ═══════════════════════════════════════════════════════════════════════
// 上传接口
// ═══════════════════════════════════════════════════════════════════════

/// 业务日志上传接口（抽象）。
///
/// 【设计原因】
/// 抽象接口便于测试时替换为 Mock 实现。
abstract class BusinessLogUploadSink {
  Future<void> upload(BusinessTraceSnapshot snapshot);
}

/// 基于 API 的上传实现。
///
/// 【接口】
/// POST /diagnostics/business-log/upload
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

// ═══════════════════════════════════════════════════════════════════════
// BusinessTraceLogger 核心类
// ═══════════════════════════════════════════════════════════════════════

/// ─────────────────────────────────────────────────────────────────────
/// 业务追踪日志收集与上传门面。
/// ─────────────────────────────────────────────────────────────────────
///
/// 【设计目标】
/// 可随手调用、绝不影响用户流程。
/// 记录、快照和上传内部都会捕获异常。
///
/// 【两种使用模式】
///
/// 1. 长流程模式（Start → Record → Upload）：
/// ```dart
/// final traceId = logger.startFlow('identity_update', businessId: 'cust_123');
/// logger.info(traceId, 'ocr_scan_start');
/// logger.info(traceId, 'ocr_scan_success');
/// await logger.uploadSilently(traceId, closeAfterUpload: true);
/// ```
///
/// 2. One-shot 模式（单点错误上报）：
/// ```dart
/// logger.uploadOneShotSilently(
///   flow: 'pdf_download',
///   name: 'download_failed',
///   error: e,
///   stackTrace: st,
/// );
/// ```
///
/// 【内存管理】
/// - 最多保存 20 个 session
/// - 每个 session 最多 120 个事件
/// - 超出限制时自动丢弃最旧的
///
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

  /// 开始一次长流程追踪。
  ///
  /// 【典型场景】
  /// - OCR 识别流程
  /// - 蓝牙连接流程
  /// - 启动弹框链路
  ///
  /// 【参数说明】
  /// - [flow]：流程名称，如 "identity_update"
  /// - [traceId]：可选，不传则自动生成
  /// - [businessId]：业务 ID（如客户 ID）
  /// - [attributes]：附加属性
  ///
  /// 【返回值】
  /// 返回 traceId，后续所有操作都需要传入此 ID。
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

  /// 记录 debug 级别事件。
  void debug(
    String traceId,
    String name, {
    String? message,
    Map<String, Object?> attributes = const {},
  }) {
    _record(traceId, BusinessTraceLevel.debug, name, message, attributes);
  }

  /// 记录 info 级别事件。
  void info(
    String traceId,
    String name, {
    String? message,
    Map<String, Object?> attributes = const {},
  }) {
    _record(traceId, BusinessTraceLevel.info, name, message, attributes);
  }

  /// 记录 warning 级别事件。
  void warning(
    String traceId,
    String name, {
    String? message,
    Map<String, Object?> attributes = const {},
  }) {
    _record(traceId, BusinessTraceLevel.warning, name, message, attributes);
  }

  /// 记录 error 级别事件。
  ///
  /// 用于记录流程中的错误，可附带异常和堆栈。
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

  /// 生成流程快照（不上传）。
  ///
  /// 用于手动检查流程状态，或自定义上传逻辑。
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

  /// 上传流程日志。
  ///
  /// 【参数说明】
  /// - [traceId]：流程 ID
  /// - [error] / [stackTrace]：可选，流程失败时的错误信息
  /// - [closeAfterUpload]：上传后是否关闭 session
  ///
  /// 【返回值】
  /// 返回上传结果，可用于判断是否成功。
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

  /// 上传一条一次性业务日志（One-shot 模式）。
  ///
  /// 【适用场景】
  /// - 下载 PDF 失败
  /// - 某 SDK 初始化失败
  /// - 单点错误上报
  ///
  /// 【特点】
  /// 不需要提前创建 trace，直接上传一条完整日志。
  /// 上传失败会被转换成 [BusinessTraceUploadResult.failed]。
  ///
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

  /// One-shot 的 fire-and-forget 版本。
  ///
  /// 【适用场景】
  /// 业务 catch 分支里直接调用，不阻塞主流程。
  ///
  /// 【特点】
  /// 使用 unawaited 包装，不会返回结果，也不会抛异常。
  ///
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

  /// 长流程上传的 fire-and-forget 版本。
  ///
  /// 【特点】
  /// 上传失败不会抛异常，不会阻塞用户流程。
  /// 适用于业务代码中快速上报错误。
  ///
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

  /// 关闭流程追踪。
  ///
  /// 上传成功后，关闭 session 释放内存。
  void close(String traceId) {
    try {
      _sessions.remove(traceId);
    } catch (_) {}
  }

  // ───────────────────────────────────────────────────────────────────
  // 私有方法
  // ───────────────────────────────────────────────────────────────────

  /// 记录事件到指定 session。
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

  /// 清理超出限制的 session。
  void _trimSessions() {
    while (_sessions.length > _maxSessions) {
      _sessions.remove(_sessions.keys.first);
    }
  }

  /// 生成唯一 traceId。
  String _newTraceId(String flow) {
    final safeFlow = flow.replaceAll(RegExp(r'[^a-zA-Z0-9_.-]'), '_');
    return '$safeFlow-${DateTime.now().microsecondsSinceEpoch}';
  }
}

/// ─────────────────────────────────────────────────────────────────────
/// 业务追踪会话（内部类）。
/// ─────────────────────────────────────────────────────────────────────
///
/// 【职责】
/// 管理单个流程追踪的所有事件。
///
/// 【内存控制】
/// 事件数量超出 maxEvents 时，自动丢弃最旧的。
///
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

  /// 添加事件（超出限制时自动丢弃最旧的）。
  void add(BusinessTraceEvent event) {
    _events.addLast(event);
    while (_events.length > maxEvents) {
      _events.removeFirst();
    }
  }

  /// 生成快照。
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

// ═══════════════════════════════════════════════════════════════════════
// 数据脱敏工具函数
// ═══════════════════════════════════════════════════════════════════════

/// 脱敏 Map 数据。
///
/// 【安全措施】
/// - 敏感 key（token/password/secret 等）替换为 '***'
/// - 字符串长度限制为 800
/// - Map 条目限制为 30 个
/// - 嵌套深度限制为 2 层
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

/// 脱敏值（递归处理嵌套结构）。
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

/// 限制字符串长度。
String? _limitString(String? value, {int maxLength = 800}) {
  if (value == null) return null;
  if (value.length <= maxLength) return value;
  return '${value.substring(0, maxLength)}...';
}

/// 判断是否为敏感 key。
bool _isSensitiveKey(String key) {
  final lower = key.toLowerCase();
  return lower.contains('token') ||
      lower.contains('password') ||
      lower.contains('secret') ||
      lower.contains('authorization') ||
      lower.contains('id_number') ||
      lower.contains('idnumber');
}
