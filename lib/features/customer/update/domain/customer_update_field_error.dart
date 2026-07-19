/// 客户资料修改字段校验错误枚举。
///
/// 【职责】
/// 定义字段校验错误类型，用于 Policy 返回错误、Controller 存储错误、Page 显示错误文案。
///
/// 【设计说明】
/// - 只定义错误类型，不包含文案
/// - 文案由 presentation 层根据 Locale 翻译（见 customer_update_localizations.dart）
/// - 这样 Policy 可以不依赖国际化，保持纯业务逻辑
///
/// 【流程】
/// ```
/// Policy 校验
///     ↓
/// 返回 CustomerUpdateFieldError（错误类型）
///     ↓
/// Controller 存入 state.fieldErrors
///     ↓
/// Page 调用 error.localize(l10n) 获取文案
/// ```
enum CustomerUpdateFieldError {
  /// 姓名为空
  requiredName,

  /// 邮箱为空
  requiredEmail,

  /// 邮箱格式错误
  invalidEmail,

  /// 手机号为空
  requiredMobile,

  /// 手机号格式错误
  invalidMobile,

  /// 行业未选择
  requiredIndustry,

  /// 职业未选择
  requiredProfession,

  /// 未勾选条款
  acceptedTermsRequired,
}
