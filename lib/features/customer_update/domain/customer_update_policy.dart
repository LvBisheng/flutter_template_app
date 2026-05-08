import '../../../shared/ui/widgets/app_picker_field.dart';
import '../../../shared/utils/regex_utils.dart';
import '../../../shared/utils/string_utils.dart';
import 'customer_update_field_error.dart';
import '../presentation/customer_update_state.dart';

/// 客户资料修改业务规则。
///
/// 邮箱格式可以放通用 RegexUtils，但“哪些字段必填、行业职业如何联动”
/// 属于本 feature 的业务规则，所以放在 Policy，而不是 shared/utils。
/// Policy 只返回错误码，具体文案由 presentation 根据当前 Locale 翻译。
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

  static CustomerUpdateFieldError? validate(CustomerUpdateState state) {
    final errors = validateFields(state);
    if (errors.isNotEmpty) return errors.values.first;
    return null;
  }

  static Map<String, CustomerUpdateFieldError> validateFields(
    CustomerUpdateState state,
  ) {
    final errors = <String, CustomerUpdateFieldError>{};
    if (StringUtils.isBlank(state.name)) {
      errors['name'] = CustomerUpdateFieldError.requiredName;
    }
    if (StringUtils.isBlank(state.email)) {
      errors['email'] = CustomerUpdateFieldError.requiredEmail;
    } else if (!RegexUtils.isEmail(state.email)) {
      errors['email'] = CustomerUpdateFieldError.invalidEmail;
    }
    if (StringUtils.isBlank(state.mobile)) {
      errors['mobile'] = CustomerUpdateFieldError.requiredMobile;
    } else if (!RegexUtils.isMobile(state.mobile)) {
      errors['mobile'] = CustomerUpdateFieldError.invalidMobile;
    }
    if (state.industryCode == null) {
      errors['industry'] = CustomerUpdateFieldError.requiredIndustry;
    }
    if (state.professionCode == null) {
      errors['profession'] = CustomerUpdateFieldError.requiredProfession;
    }
    if (!state.acceptedTerms) {
      errors['acceptedTerms'] = CustomerUpdateFieldError.acceptedTermsRequired;
    }
    return errors;
  }

  static bool canSubmit(CustomerUpdateState state) =>
      !state.submitting && !state.loading;
}
