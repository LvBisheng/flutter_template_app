import '../../../../app/l10n/generated/app_localizations.dart';
import '../../../../shared/ui/widgets/app_picker_field.dart';
import '../domain/customer_update_field_error.dart';
import '../domain/customer_update_policy.dart';

/// ─────────────────────────────────────────────────────────────────────
/// 客户资料修改国际化文案扩展。
/// ─────────────────────────────────────────────────────────────────────
///
/// 【职责】
/// 1. 将字段错误码翻译为用户可见文案
/// 2. 将行业/职业代码翻译为本地化名称
///
/// 【为什么不用 Policy 直接返回文案？】
/// Policy 是纯业务逻辑，不应该依赖国际化。
/// 错误码（枚举）在 Policy 中定义，文案在 presentation 层翻译。
/// 这样 Policy 可以保持简单，方便测试。
///
/// 【错误码 → 文案流程】
/// ```
/// Policy 校验
///     ↓
/// 返回 CustomerUpdateFieldError.requiredEmail（错误码）
///     ↓
/// Page 调用 error.localize(l10n)
///     ↓
/// 返回 "请输入邮箱"（文案）
/// ```
///

/// 字段错误的国际化扩展。
extension CustomerUpdateFieldErrorL10n on CustomerUpdateFieldError {
  /// 将错误码翻译为用户可见文案。
  String localize(AppLocalizations l10n) => switch (this) {
    CustomerUpdateFieldError.requiredName => l10n.validationRequiredName,
    CustomerUpdateFieldError.requiredEmail => l10n.validationRequiredEmail,
    CustomerUpdateFieldError.invalidEmail => l10n.validationInvalidEmail,
    CustomerUpdateFieldError.requiredMobile => l10n.validationRequiredMobile,
    CustomerUpdateFieldError.invalidMobile => l10n.validationInvalidMobile,
    CustomerUpdateFieldError.requiredIndustry =>
      l10n.validationRequiredIndustry,
    CustomerUpdateFieldError.requiredProfession =>
      l10n.validationRequiredProfession,
    CustomerUpdateFieldError.acceptedTermsRequired =>
      l10n.validationAcceptedTermsRequired,
  };
}

/// 获取本地化的行业列表。
///
/// Policy 中的行业列表是英文硬编码，这里转换为本地化名称。
List<PickerOption> localizedIndustries(AppLocalizations l10n) =>
    CustomerUpdatePolicy.industries
        .map(
          (option) =>
              PickerOption(option.value, _industryLabel(option.value, l10n)),
        )
        .toList();

/// 获取本地化的职业列表。
///
/// 根据选择的行业，返回该行业下的职业列表（已本地化）。
List<PickerOption> localizedProfessions(
  String? industry,
  AppLocalizations l10n,
) => CustomerUpdatePolicy.professions(industry)
    .map(
      (option) =>
          PickerOption(option.value, _professionLabel(option.value, l10n)),
    )
    .toList();

/// 行业代码 → 本地化名称。
String _industryLabel(String value, AppLocalizations l10n) => switch (value) {
  'tech' => l10n.industryTech,
  'finance' => l10n.industryFinance,
  'service' => l10n.industryService,
  _ => value,
};

/// 职业代码 → 本地化名称。
String _professionLabel(String value, AppLocalizations l10n) => switch (value) {
  'engineer' => l10n.professionEngineer,
  'designer' => l10n.professionDesigner,
  'analyst' => l10n.professionAnalyst,
  'advisor' => l10n.professionAdvisor,
  'operator' => l10n.professionOperator,
  'consultant' => l10n.professionConsultant,
  _ => value,
};
