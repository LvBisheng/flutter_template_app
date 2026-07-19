/// ─────────────────────────────────────────────────────────────────────
/// LoginState - 登录页面的 UI 状态。
/// ─────────────────────────────────────────────────────────────────────
///
/// 【职责】
/// 存储登录页面需要展示的所有数据：
/// - 用户名（输入框内容）
/// - 密码（输入框内容）
/// - 加载状态（按钮是否显示 loading）
///
/// 【为什么需要单独的状态类？】
/// 1. 状态不可变：copyWith 模式，状态变化可追溯
/// 2. 类型安全：避免用 Map 存状态
/// 3. 易于测试：状态是纯数据，直接比较即可
///
/// 【状态设计原则】
/// - 只存 UI 需要展示的数据（不存与方法、逻辑）
/// - 状态不可变（通过 copyWith 创建新实例）
/// - 状态名称对应 UI 元素（如 username 对应输入框）
///
/// 【复杂状态可以扩展】
/// - 错误信息：errorText
/// - 表单校验：usernameError, passwordError
/// - 登录成功跳转：shouldNavigate
///
/// ─────────────────────────────────────────────────────────────────────
class LoginState {
  const LoginState({
    this.username = 'demo', // 默认填 demo，方便调试
    this.password = 'demo123',
    this.loading = false,
    this.usernameError = '',
    this.loginButtonEnable = false,
  });

  /// 用户名（输入框内容）
  final String username;

  /// 密码（输入框内容）
  final String password;

  /// 是否正在加载（按钮是否显示 loading 动画）
  final bool loading;

  /// 登录按钮能否点击
  final bool loginButtonEnable;

  /// 用户名错误提示。
  ///
  /// 空字符串表示无错误，非空时显示错误信息。
  /// 由 Controller 根据校验结果填充国际化文案。
  final String usernameError;

  /// 创建新状态（不可变模式）。
  ///
  /// 为什么用 copyWith 而不是直接修改字段？
  /// - Flutter 的 Widget 依赖状态不可变来判断是否需要重建
  /// - Riverpod 的 Provider 也依赖状态不可变来触发通知
  /// - 如果直接修改状态，可能导致状态不同步
  ///
  /// 示例：
  /// ```dart
  /// // ❌ 错误：直接修改
  /// state.username = 'new value';
  ///
  /// // ✅ 正确：通过 copyWith 创建新实例
  /// state = state.copyWith(username: 'new value');
  /// ```
  LoginState copyWith({
    String? username,
    String? password,
    bool? loading,
    String? usernameError,
    bool? loginButtonEnable,
  }) =>
      LoginState(
        username: username ?? this.username,
        password: password ?? this.password,
        loading: loading ?? this.loading,
        usernameError: usernameError ?? this.usernameError,
        loginButtonEnable: loginButtonEnable ?? this.loginButtonEnable,
      );
}
