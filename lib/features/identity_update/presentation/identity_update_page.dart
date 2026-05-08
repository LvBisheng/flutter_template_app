import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/l10n/generated/app_localizations.dart';
import '../../../app/router/route_paths.dart';
import '../../../shared/extensions/context_ext.dart';
import '../../../shared/extensions/datetime_ext.dart';
import '../../../shared/ui/feedback/app_dialog.dart';
import '../../../shared/ui/widgets/app_button.dart';
import '../../../shared/ui/widgets/app_text_field.dart';
import 'identity_update_controller.dart';
import 'identity_update_state.dart';

class IdentityUpdatePage extends ConsumerWidget {
  const IdentityUpdatePage({super.key, required this.customerId});
  final String customerId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(identityUpdateControllerProvider(customerId));
    final controller = ref.read(
      identityUpdateControllerProvider(customerId).notifier,
    );
    final identity = state.identity;
    final l10n = context.l10n;
    return Scaffold(
      appBar: AppBar(title: Text(l10n.identityUpdateTitle)),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Card(
            child: ListTile(
              leading: const Icon(Icons.timeline),
              title: Text(state.step.localize(l10n)),
              subtitle: Text(l10n.identityFlowDescription),
            ),
          ),
          const SizedBox(height: 12),
          AppButton(
            label: identity == null
                ? l10n.identityStartOcr
                : l10n.identityRescanOcr,
            loading: state.scanning,
            icon: Icons.document_scanner_outlined,
            onPressed: controller.scan,
          ),
          const SizedBox(height: 16),
          if (identity != null) ...[
            AppTextField(
              label: l10n.identityName,
              initialValue: identity.idName,
              onChanged: controller.updateName,
            ),
            const SizedBox(height: 12),
            AppTextField(
              label: l10n.identityNumber,
              initialValue: identity.idNumber,
              onChanged: controller.updateIdNumber,
            ),
            const SizedBox(height: 12),
            _Info(l10n.identityBirthday, identity.birthday.ymd),
            _Info(l10n.identityExpiryDate, identity.expiryDate.ymd),
            const SizedBox(height: 20),
            AppButton(
              label: l10n.identitySubmitNext,
              loading: state.submitting,
              onPressed: () async {
                try {
                  await controller.submit(
                    scanRequiredMessage: l10n.identityScanRequired,
                    faceVerifyFailedMessage: l10n.identityFaceVerifyFailed,
                  );
                  if (context.mounted) {
                    context.go(
                      Uri(
                        path: RoutePaths.result,
                        queryParameters: {
                          'title': l10n.identityResultTitle,
                          'message': l10n.identityResultMessage,
                        },
                      ).toString(),
                    );
                  }
                } catch (e) {
                  if (context.mounted) AppDialog.error(context, e.toString());
                }
              },
            ),
          ],
        ],
      ),
    );
  }
}

extension on IdentityUpdateStep {
  String localize(AppLocalizations l10n) => switch (this) {
    IdentityUpdateStep.waitingOcr => l10n.identityStepWaitingOcr,
    IdentityUpdateStep.scanning => l10n.identityStepScanning,
    IdentityUpdateStep.ocrCompleted => l10n.identityStepOcrCompleted,
    IdentityUpdateStep.signing => l10n.identityStepSigning,
    IdentityUpdateStep.completed => l10n.identityStepCompleted,
  };
}

class _Info extends StatelessWidget {
  const _Info(this.label, this.value);
  final String label;
  final String value;
  @override
  Widget build(BuildContext context) => ListTile(
    contentPadding: EdgeInsets.zero,
    title: Text(label),
    subtitle: Text(value),
  );
}
