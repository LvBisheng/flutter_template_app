import '../../detail/domain/customer_profile.dart';
import '../domain/customer_update_field_error.dart';

/// ─────────────────────────────────────────────────────────────────────
/// 客户资料修改页面状态。
/// ─────────────────────────────────────────────────────────────────────
///
/// 【设计说明】
/// 复杂表单不要把字段散落在 StatefulWidget 中。
/// 集中建模后，回显、联动、校验、提交 loading 和错误展示都能围绕
/// 同一个状态对象工作。
///
/// 【状态字段分类】
/// 1. 加载状态：loading、errorMessage
/// 2. 原始数据：profile（从后端获取的原始数据）
/// 3. 表单字段：name、email、mobile、industryCode、professionCode 等
/// 4. 校验状态：fieldErrors、submittedOnce
/// 5. 提交状态：submitting
///
/// 【submittedOnce 的作用】
/// 用户第一次点击提交前，不显示错误提示。
/// 点击提交后，submittedOnce = true，后续输入实时校验。
/// 这样可以避免用户输入时就报错，体验更好。
///
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

  /// 是否正在加载原始数据。
  final bool loading;

  /// 是否正在提交。
  final bool submitting;

  /// 原始客户数据（从后端获取）。
  final CustomerProfile? profile;

  /// 姓名字段。
  final String name;

  /// 邮箱字段。
  final String email;

  /// 手机号字段。
  final String mobile;

  /// 选择的行业代码。
  final String? industryCode;

  /// 选择的职业代码。
  final String? professionCode;

  /// 是否接受条款。
  final bool acceptedTerms;

  /// 首选联系方式。
  final String contactMethod;

  /// 生日。
  final DateTime? birthday;

  /// 加载失败的错误信息。
  final String? errorMessage;

  /// 字段校验错误。
  ///
  /// Key: 字段名（如 'name'、'email'）
  /// Value: 错误类型
  final Map<String, CustomerUpdateFieldError> fieldErrors;

  /// 是否已提交过一次。
  ///
  /// 用于控制是否显示实时校验错误。
  final bool submittedOnce;

  /// 复制并更新状态。
  ///
  /// 【clearProfession 参数】
  /// 当行业变化时，需要清空职业（因为旧职业可能不属于新行业）。
  /// 这是一种特殊的联动规则，通过参数控制。
  ///
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
    Map<String, CustomerUpdateFieldError>? fieldErrors,
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
