import '../../customer_detail/domain/customer_profile.dart';

/// 客户资料修改页面状态。
///
/// 复杂表单不要把字段散落在 StatefulWidget 中。集中建模后，回显、联动、
/// 校验、提交 loading 和错误展示都能围绕同一个状态对象工作。
class CustomerUpdateState {
  const CustomerUpdateState({
    this.loading = true,
    this.submitting = false,
    this.profile,
    this.name = '',
    this.email = '',
    this.mobile = '',
    this.industryCode,
    this.professionCode,
    this.acceptedTerms = false,
    this.contactMethod = 'email',
    this.birthday,
    this.errorMessage,
    this.fieldErrors = const {},
    this.submittedOnce = false,
  });

  final bool loading;
  final bool submitting;
  final CustomerProfile? profile;
  final String name;
  final String email;
  final String mobile;
  final String? industryCode;
  final String? professionCode;
  final bool acceptedTerms;
  final String contactMethod;
  final DateTime? birthday;
  final String? errorMessage;
  final Map<String, String> fieldErrors;
  final bool submittedOnce;

  CustomerUpdateState copyWith({
    bool? loading,
    bool? submitting,
    CustomerProfile? profile,
    String? name,
    String? email,
    String? mobile,
    String? industryCode,
    bool clearProfession = false,
    String? professionCode,
    bool? acceptedTerms,
    String? contactMethod,
    DateTime? birthday,
    String? errorMessage,
    Map<String, String>? fieldErrors,
    bool? submittedOnce,
  }) => CustomerUpdateState(
    loading: loading ?? this.loading,
    submitting: submitting ?? this.submitting,
    profile: profile ?? this.profile,
    name: name ?? this.name,
    email: email ?? this.email,
    mobile: mobile ?? this.mobile,
    industryCode: industryCode ?? this.industryCode,
    professionCode: clearProfession
        ? null
        : (professionCode ?? this.professionCode),
    acceptedTerms: acceptedTerms ?? this.acceptedTerms,
    contactMethod: contactMethod ?? this.contactMethod,
    birthday: birthday ?? this.birthday,
    errorMessage: errorMessage,
    fieldErrors: fieldErrors ?? this.fieldErrors,
    submittedOnce: submittedOnce ?? this.submittedOnce,
  );
}
