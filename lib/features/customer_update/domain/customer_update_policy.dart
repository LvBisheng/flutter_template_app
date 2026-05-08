import '../../../shared/ui/widgets/app_picker_field.dart';
import '../../../shared/utils/regex_utils.dart';
import '../../../shared/utils/string_utils.dart';
import '../presentation/customer_update_state.dart';

/// 客户资料修改业务规则。
///
/// 邮箱格式可以放通用 RegexUtils，但“哪些字段必填、行业职业如何联动”
/// 属于本 feature 的业务规则，所以放在 Policy，而不是 shared/utils。
class CustomerUpdatePolicy {
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

  static List<PickerOption> professions(String? industry) =>
      professionsByIndustry[industry] ?? const [];

  static String? validate(CustomerUpdateState state) {
    final errors = validateFields(state);
    if (errors.isNotEmpty) return errors.values.first;
    return null;
  }

  static Map<String, String> validateFields(CustomerUpdateState state) {
    final errors = <String, String>{};
    if (StringUtils.isBlank(state.name)) {
      errors['name'] = '请输入姓名';
    }
    if (StringUtils.isBlank(state.email)) {
      errors['email'] = '请输入邮箱';
    } else if (!RegexUtils.isEmail(state.email)) {
      errors['email'] = '邮箱格式不正确，例如 demo@example.com';
    }
    if (StringUtils.isBlank(state.mobile)) {
      errors['mobile'] = '请输入手机号';
    } else if (!RegexUtils.isMobile(state.mobile)) {
      errors['mobile'] = '手机号需为 11 位数字';
    }
    if (state.industryCode == null) {
      errors['industry'] = '请选择行业';
    }
    if (state.professionCode == null) {
      errors['profession'] = '请选择职业';
    }
    if (!state.acceptedTerms) {
      errors['acceptedTerms'] = '请勾选资料真实性声明';
    }
    return errors;
  }

  static bool canSubmit(CustomerUpdateState state) =>
      !state.submitting && !state.loading;
}
