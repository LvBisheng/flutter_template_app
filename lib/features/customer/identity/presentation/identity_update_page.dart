import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/l10n/generated/app_localizations.dart';
import '../../../../shared/extensions/context_ext.dart';
import '../../../../shared/extensions/datetime_ext.dart';
import '../../../../shared/ui/feedback/app_dialog.dart';
import '../../../../shared/ui/widgets/app_button.dart';
import '../../../../shared/ui/widgets/app_text_field.dart';
import '../../../../shared/ui/widgets/common_app_bar.dart';
import 'identity_update_controller.dart';
import 'identity_update_state.dart';

/// ─────────────────────────────────────────────────────────────────────
/// 身份证件更新页面。
/// ─────────────────────────────────────────────────────────────────────
///
/// 【职责】
/// 展示身份更新流程的 UI，包括：
/// 1. 流程步骤指示器
/// 2. OCR 扫描按钮
/// 3. 证件信息展示与编辑（OCR 后）
/// 4. 提交按钮
///
/// 【流程】
/// 1. 用户点击扫描 → Controller 调用 OCR
/// 2. OCR 成功 → 展示识别结果，用户可编辑
/// 3. 用户点击提交 → Controller 调用 UseCase（活体 + 签名 + 提交）
/// 4. 提交成功 → 跳转结果页
///
/// 【参数】
/// [customerId]：客户 ID，用于 Controller family 参数
///
class IdentityUpdatePage extends ConsumerWidget {
  const IdentityUpdatePage({super.key, required this.customerId});

  /// 客户 ID，用于 Controller family 参数。
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
      appBar: CommonAppBar(title: l10n.identityUpdateTitle),
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
                        path: '/result',
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

/// 流程步骤本地化扩展。
extension on IdentityUpdateStep {
  String localize(AppLocalizations l10n) => switch (this) {
    IdentityUpdateStep.waitingOcr => l10n.identityStepWaitingOcr,
    IdentityUpdateStep.scanning => l10n.identityStepScanning,
    IdentityUpdateStep.ocrCompleted => l10n.identityStepOcrCompleted,
    IdentityUpdateStep.signing => l10n.identityStepSigning,
    IdentityUpdateStep.completed => l10n.identityStepCompleted,
  };
}

/// 信息展示组件（只读）。
///
/// 用于展示生日、有效期等不可编辑字段。
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
