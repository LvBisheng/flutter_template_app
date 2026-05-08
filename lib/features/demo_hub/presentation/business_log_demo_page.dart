import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/l10n/generated/app_localizations.dart';
import '../../../core/logging/business_trace_logger.dart';
import '../../../shared/extensions/context_ext.dart';

class BusinessLogDemoPage extends ConsumerStatefulWidget {
  const BusinessLogDemoPage({super.key});

  @override
  ConsumerState<BusinessLogDemoPage> createState() =>
      _BusinessLogDemoPageState();
}

class _BusinessLogDemoPageState extends ConsumerState<BusinessLogDemoPage> {
  bool _uploading = false;
  BusinessTraceUploadResult? _result;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Scaffold(
      appBar: AppBar(title: Text(l10n.demoBusinessLogTitle)),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Text(l10n.demoBusinessLogDescription),
            ),
          ),
          const SizedBox(height: 12),
          FilledButton.icon(
            onPressed: _uploading ? null : _uploadPdfFailureLog,
            icon: _uploading
                ? const SizedBox.square(
                    dimension: 18,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Icon(Icons.upload_file_outlined),
            label: Text(l10n.demoBusinessLogUploadPdfFailure),
          ),
          const SizedBox(height: 16),
          if (_result != null)
            Card(
              child: ListTile(
                leading: Icon(
                  _result!.isUploaded
                      ? Icons.check_circle_outline
                      : Icons.info_outline,
                ),
                title: Text(_statusText(l10n, _result!)),
                subtitle: _result!.message == null
                    ? null
                    : Text(_result!.message!),
              ),
            ),
        ],
      ),
    );
  }

  Future<void> _uploadPdfFailureLog() async {
    setState(() => _uploading = true);
    final result = await ref
        .read(businessTraceLoggerProvider)
        .uploadOneShot(
          flow: 'document_download',
          name: 'download_pdf_failed',
          message: '下载 PDF 失败啦',
          businessId: 'PDF-DEMO-0001',
          attributes: {
            'document_id': 'PDF-DEMO-0001',
            'endpoint': '/document/pdf/download',
            'http_status': 500,
          },
          error: StateError('Mock PDF download failed'),
          stackTrace: StackTrace.current,
        );
    if (!mounted) return;
    setState(() {
      _result = result;
      _uploading = false;
    });
  }

  String _statusText(AppLocalizations l10n, BusinessTraceUploadResult result) {
    return switch (result.status) {
      BusinessTraceUploadStatus.uploaded => l10n.demoBusinessLogUploadSuccess,
      BusinessTraceUploadStatus.skipped => l10n.demoBusinessLogUploadSkipped,
      BusinessTraceUploadStatus.failed => l10n.demoBusinessLogUploadFailed,
    };
  }
}
