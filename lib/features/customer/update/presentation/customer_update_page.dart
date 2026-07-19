import 'package:flutter/material.dart';
import 'package:flutter_enterprise_starter/features/result/routing/result_routes.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../shared/extensions/context_ext.dart';
import '../../../../shared/extensions/datetime_ext.dart';
import '../../../../shared/ui/feedback/app_loading.dart';
import '../../../../shared/ui/feedback/app_toast.dart';
import '../../../../shared/ui/form/input_formatters.dart';
import '../../../../shared/ui/widgets/app_button.dart';
import '../../../../shared/ui/widgets/app_checkbox_tile.dart';
import '../../../../shared/ui/widgets/app_error_view.dart';
import '../../../../shared/ui/widgets/app_picker_field.dart';
import '../../../../shared/ui/widgets/app_radio_group.dart';
import '../../../../shared/ui/widgets/app_text_field.dart';
import '../../../../shared/ui/widgets/common_app_bar.dart';
import '../domain/customer_update_policy.dart';
import 'customer_update_controller.dart';
import 'customer_update_localizations.dart';

/// ─────────────────────────────────────────────────────────────────────
/// 客户资料修改页面。
/// ─────────────────────────────────────────────────────────────────────
///
/// 【架构说明】
/// - 使用 ConsumerWidget 监听 Provider
/// - Provider 带 autoDispose，进入页面自动创建，离开页面自动销毁
/// - 表单字段集中在 CustomerUpdateState，不散落在 Widget 中
///
/// 【页面逻辑】
/// ```
/// 1. 进入页面 → Controller 创建 → load() 加载数据 → 回显
/// 2. 用户输入 → Controller 更新状态 → 实时校验（可选）
/// 3. 点击提交 → Controller 校验 → 提交 → 跳转结果页
/// ```
///
/// 【表单字段联动】
/// - 行业变化 → 清空职业（因为旧职业可能不属于新行业）
/// - 这是一个典型的字段联动，由 Controller 处理
///
class CustomerUpdatePage extends ConsumerWidget {
  const CustomerUpdatePage({super.key, required this.customerId});

  /// 客户 ID（从路由参数传入）。
  final String customerId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // 监听状态变化
    final state = ref.watch(customerUpdateControllerProvider(customerId));

    // 获取 Controller 实例（用于调用方法）
    final controller = ref.read(
      customerUpdateControllerProvider(customerId).notifier,
    );

    final l10n = context.l10n;

    // 加载中：显示 Loading
    if (state.loading) {
      return Scaffold(
        appBar: CommonAppBar(title: l10n.customerUpdateTitle),
        body: const AppLoading(),
      );
    }

    // 加载失败：显示错误视图
    if (state.errorMessage != null) {
      return Scaffold(
        appBar: CommonAppBar(title: l10n.customerUpdateTitle),
        body: AppErrorView(
          message: state.errorMessage!,
          onRetry: controller.load,
        ),
      );
    }

    // 正常显示表单
    return Scaffold(
      appBar: CommonAppBar(title: l10n.customerUpdateTitle),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // 姓名输入
          AppTextField(
            label: l10n.customerName,
            initialValue: state.name,
            errorText: state.fieldErrors['name']?.localize(l10n),
            onChanged: controller.nameChanged,
          ),
          const SizedBox(height: 12),

          // 邮箱输入
          AppTextField(
            label: l10n.customerEmail,
            initialValue: state.email,
            keyboardType: TextInputType.emailAddress,
            errorText: state.fieldErrors['email']?.localize(l10n),
            onChanged: controller.emailChanged,
          ),
          const SizedBox(height: 12),

          // 手机号输入
          AppTextField(
            label: l10n.customerMobile,
            initialValue: state.mobile,
            keyboardType: TextInputType.phone,
            inputFormatters: AppInputFormatters.mobile,
            errorText: state.fieldErrors['mobile']?.localize(l10n),
            onChanged: controller.mobileChanged,
          ),
          const SizedBox(height: 12),

          // 行业选择
          AppPickerField(
            label: l10n.customerIndustry,
            hint: l10n.customerChooseIndustry,
            value: state.industryCode,
            options: localizedIndustries(l10n),
            errorText: state.fieldErrors['industry']?.localize(l10n),
            onSelected: (v) => controller.industryChanged(v.value),
          ),
          const SizedBox(height: 12),

          // 职业选择（依赖行业）
          AppPickerField(
            label: l10n.customerProfession,
            hint: state.industryCode == null
                ? l10n.customerChooseIndustryFirst
                : l10n.customerChooseProfession,
            value: state.professionCode,
            enabled: state.industryCode != null,  // 未选行业时禁用
            options: localizedProfessions(state.industryCode, l10n),
            errorText: state.fieldErrors['profession']?.localize(l10n),
            onSelected: (v) => controller.professionChanged(v.value),
          ),
          const SizedBox(height: 12),

          // 生日选择
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

          // 条款勾选
          AppCheckboxTile(
            title: l10n.customerAcceptedTerms,
            value: state.acceptedTerms,
            onChanged: controller.acceptedChanged,
          ),
          // 条款错误提示（单独处理，不与其他字段一起）
          if (state.fieldErrors['acceptedTerms'] != null)
            Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Text(
                state.fieldErrors['acceptedTerms']!.localize(l10n),
                style: TextStyle(color: Theme.of(context).colorScheme.error),
              ),
            ),

          // 联系方式单选
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

          // 提交按钮
          AppButton(
            label: l10n.customerSubmitEdit,
            loading: state.submitting,
            onPressed: CustomerUpdatePolicy.canSubmit(state)
                ? () async {
                    try {
                      // 提交表单
                      final error = await controller.submit();
                      if (!context.mounted) return;

                      // 校验失败：显示错误
                      if (error != null) {
                        AppToast.show(context, error.localize(l10n));
                        return;
                      }

                      // 提交成功：跳转结果页
                      // 使用 context.go 替换当前路由（不保留返回栈）
                      // 用户在结果页侧滑返回时，会在根路由触发"退出确认"对话框
                      context.pushReplacement( Uri(
                          path: ResultRoutes.resultPath,
                          queryParameters: {
                            'title': l10n.customerUpdateSuccessTitle,
                            'message': l10n.customerUpdateSuccessMessage,
                          },
                        ).toString(), );
                      // context.go(
                      //   Uri(
                      //     path: ResultRoutes.resultPath,
                      //     queryParameters: {
                      //       'title': l10n.customerUpdateSuccessTitle,
                      //       'message': l10n.customerUpdateSuccessMessage,
                      //     },
                      //   ).toString(),
                      // );
                    } catch (e) {
                      // 提交失败：显示错误
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
