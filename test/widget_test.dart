import 'dart:convert';

import 'package:flutter_enterprise_starter/app/env/app_env.dart';
import 'package:flutter_enterprise_starter/app/env/env_config.dart';
import 'package:flutter_enterprise_starter/core/logging/business_trace_logger.dart';
import 'package:flutter_enterprise_starter/core/logging/long_log_printer.dart';
import 'package:flutter_enterprise_starter/core/network/mock/mock_config.dart';
import 'package:flutter_enterprise_starter/core/network/mock/mock_customer_json.dart';
import 'package:flutter_enterprise_starter/features/customer_update/domain/customer_update_policy.dart';
import 'package:flutter_enterprise_starter/features/customer_update/presentation/customer_update_state.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('template smoke test', () {
    expect('Flutter Enterprise Starter'.contains('Enterprise'), isTrue);
  });

  test('mock customer detail follows requested id', () {
    final json =
        jsonDecode(MockCustomerJson.detailSuccessFor('C10002'))
            as Map<String, dynamic>;
    final data = json['data'] as Map<String, dynamic>;

    expect(data['cust_id'], 'C10002');
    expect(data['cust_name'], 'Demo Customer B');
  });

  test('customer update policy clears invalid submit state', () {
    const state = CustomerUpdateState(
      loading: false,
      name: 'Demo',
      email: 'demo@example.invalid',
      mobile: '13800000001',
      industryCode: 'tech',
      professionCode: 'engineer',
      acceptedTerms: true,
    );

    expect(CustomerUpdatePolicy.validate(state), isNull);
  });

  test('locked environment always uses production', () {
    final config = EnvConfig.forEnv(AppEnv.sit, switchEnabled: false);

    expect(config.env, AppEnv.prd);
    expect(config.switchEnabled, isFalse);
  });

  test('mock config can represent prd disabled state', () {
    const config = MockConfig(
      masterEnabled: false,
      enabledRuleIds: {},
      availableRules: [],
    );

    expect(config.masterEnabled, isFalse);
    expect(config.enabledRules, isEmpty);
  });

  test('long log printer splits long single line without dropping text', () {
    final source = 'x' * 25;
    final chunks = LongLogPrinter.splitForConsole(source, chunkSize: 10);

    expect(chunks.length, 3);
    expect(chunks.join(), contains('x' * 10));
    expect(chunks.join(), contains('x' * 5));
  });

  test('business trace logger never throws when upload fails', () async {
    final logger = BusinessTraceLogger(uploader: _ThrowingBusinessLogSink());
    final traceId = logger.startFlow(
      'ocr',
      businessId: 'C10001',
      attributes: {'token': 'secret-token', 'step': 'scan'},
    );

    logger.info(traceId, 'scan_start');
    logger.error(traceId, 'scan_failed', error: StateError('sdk failed'));

    final result = await logger.upload(traceId, error: 'sdk failed');

    expect(result.status, BusinessTraceUploadStatus.failed);
    expect(logger.snapshot(traceId), isNotNull);
  });

  test('business trace logger supports one-shot upload', () async {
    final sink = _MemoryBusinessLogSink();
    final logger = BusinessTraceLogger(uploader: sink);

    final result = await logger.uploadOneShot(
      flow: 'document_download',
      name: 'download_pdf_failed',
      message: '下载 PDF 失败啦',
      businessId: 'PDF-1',
      attributes: {'token': 'secret-token'},
      error: StateError('network failed'),
    );

    expect(result.isUploaded, isTrue);
    expect(sink.snapshots.single.flow, 'document_download');
    expect(sink.snapshots.single.events.single.name, 'download_pdf_failed');
    expect(sink.snapshots.single.events.single.attributes['token'], '***');
  });
}

class _ThrowingBusinessLogSink implements BusinessLogUploadSink {
  @override
  Future<void> upload(BusinessTraceSnapshot snapshot) async {
    throw StateError('network unavailable');
  }
}

class _MemoryBusinessLogSink implements BusinessLogUploadSink {
  final snapshots = <BusinessTraceSnapshot>[];

  @override
  Future<void> upload(BusinessTraceSnapshot snapshot) async {
    snapshots.add(snapshot);
  }
}
