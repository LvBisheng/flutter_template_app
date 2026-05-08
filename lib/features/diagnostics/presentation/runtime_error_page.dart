import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../shared/extensions/context_ext.dart';
import '../../../shared/extensions/datetime_ext.dart';
import '../../../shared/ui/feedback/app_toast.dart';
import '../domain/runtime_error_report.dart';
import 'runtime_error_controller.dart';

class RuntimeErrorListPage extends ConsumerWidget {
  const RuntimeErrorListPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(runtimeErrorControllerProvider);
    final l10n = context.l10n;
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.runtimeErrorTitle),
        actions: [
          IconButton(
            tooltip: l10n.runtimeErrorClear,
            onPressed: state.reports.isEmpty
                ? null
                : () =>
                      ref.read(runtimeErrorControllerProvider.notifier).clear(),
            icon: const Icon(Icons.delete_sweep_outlined),
          ),
        ],
      ),
      body: state.reports.isEmpty
          ? Center(child: Text(l10n.runtimeErrorEmpty))
          : ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: state.reports.length,
              separatorBuilder: (_, _) => const SizedBox(height: 8),
              itemBuilder: (context, index) {
                final report = state.reports[index];
                return Card(
                  child: ListTile(
                    leading: const Icon(Icons.bug_report_outlined),
                    title: Text(
                      report.message,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    subtitle: Text(
                      '${report.sourceName} · ${report.occurredAt.ymdHm}',
                    ),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () => Navigator.of(context).push(
                      MaterialPageRoute<void>(
                        builder: (_) => RuntimeErrorDetailPage(report: report),
                      ),
                    ),
                  ),
                );
              },
            ),
    );
  }
}

class RuntimeErrorDetailPage extends StatelessWidget {
  const RuntimeErrorDetailPage({super.key, required this.report});

  final RuntimeErrorReport report;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.runtimeErrorDetailTitle),
        actions: [
          IconButton(
            tooltip: l10n.runtimeErrorCopy,
            onPressed: () => _copy(context, report),
            icon: const Icon(Icons.copy_outlined),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _InfoTile(label: l10n.runtimeErrorSource, value: report.sourceName),
          _InfoTile(
            label: l10n.runtimeErrorTime,
            value: report.occurredAt.ymdHm,
          ),
          if (report.context != null)
            _InfoTile(label: l10n.runtimeErrorContext, value: report.context!),
          const SizedBox(height: 12),
          Text(
            l10n.runtimeErrorMessage,
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 8),
          SelectableText(report.message),
          const SizedBox(height: 20),
          Text(
            l10n.runtimeErrorStack,
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 8),
          DecoratedBox(
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surfaceContainerHighest,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: SelectableText(
                report.stackTrace,
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ),
          ),
          const SizedBox(height: 20),
          FilledButton.icon(
            onPressed: () => _copy(context, report),
            icon: const Icon(Icons.copy_outlined),
            label: Text(l10n.runtimeErrorCopyAll),
          ),
        ],
      ),
    );
  }

  Future<void> _copy(BuildContext context, RuntimeErrorReport report) async {
    await Clipboard.setData(ClipboardData(text: report.toShareText()));
    if (context.mounted) {
      AppToast.show(context, context.l10n.runtimeErrorCopied);
    }
  }
}

class RuntimeErrorSnackDialog extends StatelessWidget {
  const RuntimeErrorSnackDialog({super.key, required this.report});

  final RuntimeErrorReport report;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return AlertDialog(
      title: Text(l10n.runtimeErrorCaptured),
      content: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 520),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(report.message, maxLines: 4, overflow: TextOverflow.ellipsis),
            const SizedBox(height: 12),
            Text(
              '${report.sourceName} · ${report.occurredAt.ymdHm}',
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(l10n.commonCancel),
        ),
        TextButton(
          onPressed: () async {
            await Clipboard.setData(ClipboardData(text: report.toShareText()));
            if (context.mounted) {
              AppToast.show(context, l10n.runtimeErrorCopied);
            }
          },
          child: Text(l10n.runtimeErrorCopy),
        ),
        FilledButton(
          onPressed: () {
            Navigator.of(context).pop();
            Navigator.of(context).push(
              MaterialPageRoute<void>(
                builder: (_) => RuntimeErrorDetailPage(report: report),
              ),
            );
          },
          child: Text(l10n.runtimeErrorViewDetail),
        ),
      ],
    );
  }
}

class _InfoTile extends StatelessWidget {
  const _InfoTile({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(bottom: 8),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(width: 88, child: Text(label)),
        Expanded(child: SelectableText(value)),
      ],
    ),
  );
}
