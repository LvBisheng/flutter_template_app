import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/router/route_paths.dart';
import '../../../shared/extensions/context_ext.dart';
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
import 'customer_update_localizations.dart';

class CustomerUpdatePage extends ConsumerWidget {
  const CustomerUpdatePage({super.key, required this.customerId});
  final String customerId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(customerUpdateControllerProvider(customerId));
    final controller = ref.read(
      customerUpdateControllerProvider(customerId).notifier,
    );
    final l10n = context.l10n;
    if (state.loading) {
      return Scaffold(
        appBar: AppBar(title: Text(l10n.customerUpdateTitle)),
        body: const AppLoading(),
      );
    }
    if (state.errorMessage != null) {
      return Scaffold(
        appBar: AppBar(title: Text(l10n.customerUpdateTitle)),
        body: AppErrorView(
          message: state.errorMessage!,
          onRetry: controller.load,
        ),
      );
    }
    return Scaffold(
      appBar: AppBar(title: Text(l10n.customerUpdateTitle)),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          AppTextField(
            label: l10n.customerName,
            initialValue: state.name,
            errorText: state.fieldErrors['name']?.localize(l10n),
            onChanged: controller.nameChanged,
          ),
          const SizedBox(height: 12),
          AppTextField(
            label: l10n.customerEmail,
            initialValue: state.email,
            keyboardType: TextInputType.emailAddress,
            errorText: state.fieldErrors['email']?.localize(l10n),
            onChanged: controller.emailChanged,
          ),
          const SizedBox(height: 12),
          AppTextField(
            label: l10n.customerMobile,
            initialValue: state.mobile,
            keyboardType: TextInputType.phone,
            inputFormatters: AppInputFormatters.mobile,
            errorText: state.fieldErrors['mobile']?.localize(l10n),
            onChanged: controller.mobileChanged,
          ),
          const SizedBox(height: 12),
          AppPickerField(
            label: l10n.customerIndustry,
            hint: l10n.customerChooseIndustry,
            value: state.industryCode,
            options: localizedIndustries(l10n),
            errorText: state.fieldErrors['industry']?.localize(l10n),
            onSelected: (v) => controller.industryChanged(v.value),
          ),
          const SizedBox(height: 12),
          AppPickerField(
            label: l10n.customerProfession,
            hint: state.industryCode == null
                ? l10n.customerChooseIndustryFirst
                : l10n.customerChooseProfession,
            value: state.professionCode,
            enabled: state.industryCode != null,
            options: localizedProfessions(state.industryCode, l10n),
            errorText: state.fieldErrors['profession']?.localize(l10n),
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
            label: Text(l10n.customerBirthdayValue(state.birthday.ymd)),
          ),
          AppCheckboxTile(
            title: l10n.customerAcceptedTerms,
            value: state.acceptedTerms,
            onChanged: controller.acceptedChanged,
          ),
          if (state.fieldErrors['acceptedTerms'] != null)
            Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Text(
                state.fieldErrors['acceptedTerms']!.localize(l10n),
                style: TextStyle(color: Theme.of(context).colorScheme.error),
              ),
            ),
          AppRadioGroup<String>(
            title: l10n.customerContactMethod,
            value: state.contactMethod,
            options: {
              'email': l10n.customerContactEmail,
              'mobile': l10n.customerContactMobile,
            },
            onChanged: controller.contactMethodChanged,
          ),
          const SizedBox(height: 16),
          AppButton(
            label: l10n.customerSubmitEdit,
            loading: state.submitting,
            onPressed: CustomerUpdatePolicy.canSubmit(state)
                ? () async {
                    try {
                      final error = await controller.submit();
                      if (!context.mounted) return;
                      if (error != null) {
                        AppToast.show(context, error.localize(l10n));
                        return;
                      }
                      context.go(
                        Uri(
                          path: RoutePaths.result,
                          queryParameters: {
                            'title': l10n.customerUpdateSuccessTitle,
                            'message': l10n.customerUpdateSuccessMessage,
                          },
                        ).toString(),
                      );
                    } catch (e) {
                      if (context.mounted) AppToast.show(context, e.toString());
                    }
                  }
                : null,
          ),
        ],
      ),
    );
  }
}
