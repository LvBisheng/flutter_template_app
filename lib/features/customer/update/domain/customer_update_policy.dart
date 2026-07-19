import '../../../../shared/ui/widgets/app_picker_field.dart';
import '../../../../shared/utils/regex_utils.dart';
import '../../../../shared/utils/string_utils.dart';
import 'customer_update_field_error.dart';
import '../presentation/customer_update_state.dart';

/// ─────────────────────────────────────────────────────────────────────
/// 客户资料修改业务规则（Policy）。
/// ─────────────────────────────────────────────────────────────────────
///
/// 【职责】
/// 定义客户资料修改的业务规则：
/// - 可选行业列表
/// - 行业与职业的联动关系
/// - 字段校验规则
///
/// 【为什么叫 Policy？】
/// Policy = 业务策略/规则。它和 Validator 的区别：
/// - Validator：通用校验（如邮箱格式、手机号格式）
/// - Policy：业务规则（如哪些字段必填、行业职业如何联动）
///
/// 【为什么不放在 shared/utils？】
/// 邮箱格式可以放 shared/utils，但"哪些字段必填、行业职业如何联动"
/// 是本 feature 的业务规则，不是通用规则。
///
/// 【错误码 vs 错误文案】
/// Policy 只返回错误码（CustomerUpdateFieldError），不返回文案。
/// 具体文案由 presentation 层根据当前 Locale 翻译（见 customer_update_localizations.dart）。
/// 这样 Policy 可以保持纯业务逻辑，不依赖国际化。
///
class CustomerUpdatePolicy {
  /// 可选行业列表。
  ///
  /// 【联动规则】
  /// 选择行业后，职业列表会根据行业变化。
  /// 例如：选择"科技"行业后，职业列表显示"工程师"、"设计师"。
  static const industries = [
    PickerOption(
      'tech',
      'Technology / Internet / Software and Information Services',
    ),
    PickerOption(
      'finance',
      'Finance / Insurance / Securities and Wealth Management',
    ),
    PickerOption(
      'service',
      'Professional Services / Consulting / Customer Operations',
    ),
  ];

  /// 行业对应的职业列表。
  ///
  /// 【联动规则】
  /// Key: 行业代码
  /// Value: 该行业下的职业列表
  static const professionsByIndustry = {
    'tech': [
      PickerOption('engineer', 'Senior Software Engineer / Solution Architect'),
      PickerOption('designer', 'Product Designer / User Experience Specialist'),
    ],
    'finance': [
      PickerOption('analyst', 'Risk Analyst / Investment Research Analyst'),
      PickerOption(
        'advisor',
        'Private Client Advisor / Financial Planning Consultant',
      ),
    ],
    'service': [
      PickerOption(
        'operator',
        'Customer Operations Manager / Service Delivery Lead',
      ),
      PickerOption(
        'consultant',
        'Business Consultant / Implementation Specialist',
      ),
    ],
  };

  /// 获取指定行业的职业列表。
  static List<PickerOption> professions(String? industry) =>
      professionsByIndustry[industry] ?? const [];

  /// 校验整个表单，返回第一个错误。
  ///
  /// 用于提交前的快速校验。
  static CustomerUpdateFieldError? validate(CustomerUpdateState state) {
    final errors = validateField(state);
    if (errors.isNotEmpty) return errors.values.first;
    return null;
  }

  /// 校验所有字段，返回错误 Map。
  ///
  /// 【校验规则】
  /// - 姓名：必填
  /// - 邮箱：必填 + 格式校验
  /// - 手机号：必填 + 格式校验
  /// - 行业：必选
  /// - 职业：必选
  /// - 条款：必须勾选
  ///
  /// 【返回值】
  /// Map<字段名, 错误类型>，例如：
  /// ```dart
  /// {'email': CustomerUpdateFieldError.invalidEmail}
  /// ```
  static Map<String, CustomerUpdateFieldError> validateField(
    CustomerUpdateState state,
  ) {
    final errors = <String, CustomerUpdateFieldError>{};

    // 姓名校验
    if (StringUtils.isBlank(state.name)) {
      errors['name'] = CustomerUpdateFieldError.requiredName;
    }

    // 邮箱校验
    if (StringUtils.isBlank(state.email)) {
      errors['email'] = CustomerUpdateFieldError.requiredEmail;
    } else if (!RegexUtils.isEmail(state.email)) {
      errors['email'] = CustomerUpdateFieldError.invalidEmail;
    }

    // 手机号校验
    if (StringUtils.isBlank(state.mobile)) {
      errors['mobile'] = CustomerUpdateFieldError.requiredMobile;
    } else if (!RegexUtils.isMobile(state.mobile)) {
      errors['mobile'] = CustomerUpdateFieldError.invalidMobile;
    }

    // 行业校验
    if (state.industryCode == null) {
      errors['industry'] = CustomerUpdateFieldError.requiredIndustry;
    }

    // 职业校验
    if (state.professionCode == null) {
      errors['profession'] = CustomerUpdateFieldError.requiredProfession;
    }

    // 条款校验
    if (!state.acceptedTerms) {
      errors['acceptedTerms'] = CustomerUpdateFieldError.acceptedTermsRequired;
    }

    return errors;
  }

  /// 判断是否可以提交。
  ///
  /// 按钮禁用条件：正在加载 或 正在提交。
  static bool canSubmit(CustomerUpdateState state) =>
      !state.submitting && !state.loading;
}
