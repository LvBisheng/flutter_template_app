import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/router/route_paths.dart';
import '../../../shared/extensions/datetime_ext.dart';
import '../../../shared/ui/feedback/app_dialog.dart';
import '../../../shared/ui/widgets/app_button.dart';
import '../../../shared/ui/widgets/app_text_field.dart';
import 'identity_update_controller.dart';

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
    return Scaffold(
      appBar: AppBar(title: const Text('证件更新')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Card(
            child: ListTile(
              leading: const Icon(Icons.timeline),
              title: Text(state.stepText),
              subtitle: const Text('OCR -> 活体验证 -> Soft Token 签名 -> 提交接口'),
            ),
          ),
          const SizedBox(height: 12),
          AppButton(
            label: identity == null ? '开始 OCR' : '重新 OCR',
            loading: state.scanning,
            icon: Icons.document_scanner_outlined,
            onPressed: controller.scan,
          ),
          const SizedBox(height: 16),
          if (identity != null) ...[
            AppTextField(
              label: '证件姓名',
              initialValue: identity.idName,
              onChanged: controller.updateName,
            ),
            const SizedBox(height: 12),
            AppTextField(
              label: '证件号码',
              initialValue: identity.idNumber,
              onChanged: controller.updateIdNumber,
            ),
            const SizedBox(height: 12),
            _Info('出生日期', identity.birthday.ymd),
            _Info('证件有效期', identity.expiryDate.ymd),
            const SizedBox(height: 20),
            AppButton(
              label: '下一步并提交',
              loading: state.submitting,
              onPressed: () async {
                try {
                  await controller.submit();
                  if (context.mounted) {
                    context.go(
                      Uri(
                        path: RoutePaths.result,
                        queryParameters: {
                          'title': '证件信息已更新',
                          'message': 'OCR、活体验证和 Soft Token mock 流程已完成。',
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
