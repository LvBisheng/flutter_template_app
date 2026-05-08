import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/router/route_paths.dart';
import '../../../shared/extensions/datetime_ext.dart';
import '../../../shared/ui/feedback/app_loading.dart';
import '../../../shared/ui/feedback/app_toast.dart';
import '../../../shared/ui/form/input_formatters.dart';
import '../../../shared/ui/widgets/app_button.dart';
import '../../../shared/ui/widgets/app_checkbox_tile.dart';
import '../../../shared/ui/widgets/app_error_view.dart';
import '../../../shared/ui/widgets/app_picker_field.dart';
import '../../../shared/ui/widgets/app_radio_group.dart';
import '../../../shared/ui/widgets/app_text_field.dart';
import '../domain/customer_update_policy.dart';
import 'customer_update_controller.dart';

class CustomerUpdatePage extends ConsumerWidget {
  const CustomerUpdatePage({super.key, required this.customerId});
  final String customerId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(customerUpdateControllerProvider(customerId));
    final controller = ref.read(
      customerUpdateControllerProvider(customerId).notifier,
    );
    if (state.loading) {
      return Scaffold(
        appBar: AppBar(title: const Text('修改资料')),
        body: const AppLoading(),
      );
    }
    if (state.errorMessage != null) {
      return Scaffold(
        appBar: AppBar(title: const Text('修改资料')),
        body: AppErrorView(
          message: state.errorMessage!,
          onRetry: controller.load,
        ),
      );
    }
    return Scaffold(
      appBar: AppBar(title: const Text('修改资料')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          AppTextField(
            label: '姓名',
            initialValue: state.name,
            errorText: state.fieldErrors['name'],
            onChanged: controller.nameChanged,
          ),
          const SizedBox(height: 12),
          AppTextField(
            label: '邮箱',
            initialValue: state.email,
            keyboardType: TextInputType.emailAddress,
            errorText: state.fieldErrors['email'],
            onChanged: controller.emailChanged,
          ),
          const SizedBox(height: 12),
          AppTextField(
            label: '手机号',
            initialValue: state.mobile,
            keyboardType: TextInputType.phone,
            inputFormatters: AppInputFormatters.mobile,
            errorText: state.fieldErrors['mobile'],
            onChanged: controller.mobileChanged,
          ),
          const SizedBox(height: 12),
          AppPickerField(
            label: '行业',
            hint: '请选择行业',
            value: state.industryCode,
            options: CustomerUpdatePolicy.industries,
            errorText: state.fieldErrors['industry'],
            onSelected: (v) => controller.industryChanged(v.value),
          ),
          const SizedBox(height: 12),
          AppPickerField(
            label: '职业',
            hint: state.industryCode == null ? '请先选择行业' : '请选择职业',
            value: state.professionCode,
            enabled: state.industryCode != null,
            options: CustomerUpdatePolicy.professions(state.industryCode),
            errorText: state.fieldErrors['profession'],
            onSelected: (v) => controller.professionChanged(v.value),
          ),
          const SizedBox(height: 12),
          OutlinedButton.icon(
            onPressed: () async {
              final picked = await showDatePicker(
                context: context,
                initialDate: state.birthday ?? DateTime(1990),
                firstDate: DateTime(1900),
                lastDate: DateTime.now(),
              );
              if (picked != null) controller.birthdayChanged(picked);
            },
            icon: const Icon(Icons.calendar_month_outlined),
            label: Text('生日：${state.birthday.ymd}'),
          ),
          AppCheckboxTile(
            title: '我确认客户资料真实有效',
            value: state.acceptedTerms,
            onChanged: controller.acceptedChanged,
          ),
          if (state.fieldErrors['acceptedTerms'] != null)
            Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Text(
                state.fieldErrors['acceptedTerms']!,
                style: TextStyle(color: Theme.of(context).colorScheme.error),
              ),
            ),
          AppRadioGroup<String>(
            title: '首选联系渠道',
            value: state.contactMethod,
            options: const {'email': '邮箱', 'mobile': '手机'},
            onChanged: controller.contactMethodChanged,
          ),
          const SizedBox(height: 16),
          AppButton(
            label: '提交修改',
            loading: state.submitting,
            onPressed: CustomerUpdatePolicy.canSubmit(state)
                ? () async {
                    final error = await controller.submit();
                    if (!context.mounted) return;
                    if (error != null) {
                      AppToast.show(context, error);
                      return;
                    }
                    context.go(
                      Uri(
                        path: RoutePaths.result,
                        queryParameters: {
                          'title': '客户资料已更新',
                          'message': '客户资料修改流程已通过 mock 接口完成。',
                        },
                      ).toString(),
                    );
                  }
                : null,
          ),
        ],
      ),
    );
  }
}
