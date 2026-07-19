import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../app/l10n/generated/app_localizations.dart';
import '../../../../capabilities/auth/session_manager.dart';
import '../../../../core/logging/app_logger.dart';
import '../../../../core/network/api_client.dart';
import '../../../../shared/utils/validators.dart';
import '../data/login_api.dart';
import '../data/login_repository_impl.dart';
import '../domain/login_use_case.dart';
import 'login_state.dart';

/// ─────────────────────────────────────────────────────────────────────
/// LoginController - 登录页面的控制器。
/// ─────────────────────────────────────────────────────────────────────
///
/// 【职责】
/// 1. 管理 UI 状态（username, password, loading）
/// 2. 处理用户交互（输入变化、点击登录）
/// 3. 调用 UseCase 执行业务逻辑
/// 4. 根据校验结果填充国际化错误文案
///
/// 【Controller 的边界】
/// - 只管 UI 交互：接收用户输入 → 更新状态 → 调用 UseCase
/// - 不管业务逻辑：业务规则（如校验用户名）在 UseCase/Validators 里
/// - 不管数据获取：数据从哪来（网络/缓存）是 Repository 的事
///
/// 【调用链】
/// LoginPage（UI）
///     ↓ 用户输入
/// LoginController（更新状态）
///     ↓ 点击登录
/// LoginUseCase（业务流程）
///     ↓
/// LoginRepository（数据获取）
///
/// ─────────────────────────────────────────────────────────────────────
/// Provider 注入说明
/// ─────────────────────────────────────────────────────────────────────
///
/// Riverpod 的 Provider 负责依赖注入：
/// - apiClientProvider：提供 ApiClient（网络客户端）
/// - sessionManagerProvider：提供 SessionManager（登录态管理）
/// - loginUseCaseProvider：提供 LoginUseCase（业务逻辑）
///
/// 为什么要用 Provider？
/// 1. 解耦：Controller 不直接 new 实例，而是从 Provider 获取
/// 2. 单例：全局只有一个实例
/// 3. 易于测试：测试时可以替换为 mock Provider
///
/// ─────────────────────────────────────────────────────────────────────
/// Provider 定义：创建 LoginController 的 Provider。
/// ─────────────────────────────────────────────────────────────────────
///
/// 【NotifierProvider 声明】
/// - `NotifierProvider<LoginController, LoginState>` 是泛型参数
/// - 第一个泛型：Controller 类型（LoginController）
/// - 第二个泛型：状态类型（LoginState）
///
/// 【构造函数引用（tear-off）】
/// 参数 `LoginController.new` 是构造函数引用，专门叫 **tear-off**。
///
/// 这两种写法完全等价：
/// ```dart
/// LoginController.new         // tear-off（推荐，简洁）
/// () => LoginController()     // lambda 表达式
/// ```
///
/// 【为什么用 tear-off？】
/// 1. 简洁：比 lambda 更短
/// 2. 延迟创建：NotifierProvider 会在首次访问时调用这个函数
/// 3. 性能：避免每次都创建匿名函数对象
///
/// 【能直接传 LoginController() 吗？】
/// 不能！`NotifierProvider` 的参数类型是 `NotifierT Function()`，
/// 即一个**无参数的函数**，而不是实例。
///
/// ```dart
/// // ❌ 错误：期望函数，传了实例
/// NotifierProvider<LoginController, LoginState>(LoginController())
///
/// // ✅ 正确：传入函数（工厂）
/// NotifierProvider<LoginController, LoginState>(LoginController.new)
/// ```
///
final loginControllerProvider = NotifierProvider<LoginController, LoginState>(
  LoginController.new, // tear-off：构造函数引用，等价于 () => LoginController()
);

/// LoginUseCase 的 Provider。
///
/// 将 UseCase 注入到 Provider 中，而不是在 Controller 里直接创建。
/// 这样做的好处：
/// 1. 单例：避免每次输入都创建新实例
/// 2. 易于测试：可以替换为 mock UseCase
/// 3. 依赖清晰：UseCase 的依赖通过 Provider 注入
final loginUseCaseProvider = Provider<LoginUseCase>((ref) {
  return LoginUseCase(
    LoginRepositoryImpl(LoginApi(ref.read(apiClientProvider))),
    ref.read(sessionManagerProvider.notifier),
  );
});

class LoginController extends Notifier<LoginState> {
  /// 初始化状态。
  ///
  /// Notifier 的 build() 相当于 initState，
  /// 返回的值就是 Provider 的初始状态。
  ///
  /// 注意：build() 中不能访问 this.state，因为此时 state 还未初始化。
  @override
  LoginState build() {
    // 默认值已经设置了 username='demo', password='demo123'
    // 校验通过，按钮可用
    const state = LoginState();
    return state.copyWith(
      loginButtonEnable: _isFormValid(state.username, state.password),
    );
  }

  /// 检查表单是否有效（用于控制按钮状态）。
  ///
  /// 只有当用户名和密码都校验通过时，按钮才可点击。
  bool _isFormValid(String username, String password) {
    final usernameResult = validateUsername(username);
    final passwordResult = validatePassword(password);
    return usernameResult == UsernameValidationResult.valid &&
        passwordResult == PasswordValidationResult.valid;
  }

  /// 用户名输入变化。
  ///
  /// 流程：
  /// 1. 调用校验逻辑（纯函数）
  /// 2. 根据校验结果填充国际化错误文案
  /// 3. 更新状态（包括按钮状态）
  ///
  /// 参数：
  /// - [value] 用户输入的值
  /// - [l10n] 国际化文案（由 Page 传入）
  ///
  /// 注意：
  /// - 校验逻辑在 Validators 里，不含文案
  /// - 文案由 Controller 根据校验结果决定
  /// - Controller 没有 BuildContext，所以需要 Page 传入 l10n
  void usernameChanged(String value, AppLocalizations l10n) {
    // 调用校验逻辑
    final result = validateUsername(value);

    // 根据校验结果决定错误文案（国际化）
    String errorMsg = _getUsernameErrorMsg(result, l10n);

    // 更新用户名、错误提示和按钮状态
    state = state.copyWith(
      username: value,
      usernameError: errorMsg,
      loginButtonEnable: _isFormValid(value, state.password),
    );
  }

  /// 密码输入变化。
  ///
  /// 密码输入时不显示错误提示，只更新按钮状态。
  void passwordChanged(String value) {
    // 更新密码和按钮状态
    state = state.copyWith(
      password: value,
      loginButtonEnable: _isFormValid(state.username, value),
    );
  }

  /// 执行登录。
  ///
  /// 流程：
  /// 1. 校验输入（用户名/密码格式）
  /// 2. 校验失败：更新错误提示并返回
  /// 3. 校验成功：设置 loading = true，执行登录
  /// 4. 成功：loading = false，登录态已保存，路由守卫会自动跳转
  /// 5. 失败：loading = false，抛出异常给 Page 处理（显示 toast）
  ///
  /// 注意：
  /// - 业务逻辑（校验、调接口、保存 Token）都在 UseCase 里
  /// - Controller 只负责状态管理和调用 UseCase
  Future<void> login({required AppLocalizations l10n}) async {
    // 1. 提交前校验
    final usernameResult = validateUsername(state.username);
    final passwordResult = validatePassword(state.password);

    // 校验失败，更新状态并返回
    if (usernameResult != UsernameValidationResult.valid ||
        passwordResult != PasswordValidationResult.valid) {
      // 根据校验结果填充错误文案
      final errorMsg = _getUsernameErrorMsg(usernameResult, l10n);
      // 如果密码也有问题，可以用 toast 提示
      if (passwordResult == PasswordValidationResult.empty ||
          passwordResult == PasswordValidationResult.tooShort) {
        // 这里简化处理：如果用户名也有错，只显示用户名错误
        // 如果用户名正确，显示密码错误
        if (errorMsg.isEmpty) {
          // 可以在 state 里增加 passwordError 字段，或者用 toast 提示
          // 这里暂时用 toast 提示
        }
      }
      state = state.copyWith(usernameError: errorMsg);
      return;
    }

    // 2. 开始 loading
    state = state.copyWith(loading: true);

    try {
      appLogger.i('Login started: ${state.username}');

      // 3. 从 Provider 获取 UseCase（不再每次 new）
      final useCase = ref.read(loginUseCaseProvider);

      // 4. 执行登录
      await useCase(
        state.username,
        state.password,
        emptyCredentialsMessage: l10n.loginEmptyCredentials,
      );

      appLogger.i('Login succeeded: ${state.username}');

      // 登录成功后不需要手动跳转页面
      // 路由守卫（route_guard.dart）会监听登录状态变化，自动跳转到首页
    } catch (e, st) {
      appLogger.e('Login failed', error: e, stackTrace: st);
      // 异常抛给 Page 处理（显示 toast）
      rethrow;
    } finally {
      // 5. 结束 loading（无论成功失败都要关闭）
      state = state.copyWith(loading: false);
    }
  }

  /// 根据校验结果获取用户名错误文案。
  String _getUsernameErrorMsg(
    UsernameValidationResult result,
    AppLocalizations l10n,
  ) {
    switch (result) {
      case UsernameValidationResult.valid:
        return '';
      case UsernameValidationResult.empty:
        return l10n.loginEmptyCredentials;
      case UsernameValidationResult.invalidCharacters:
        return l10n.loginInvalidUsername;
      case UsernameValidationResult.tooShort:
        return l10n.loginUsernameTooShort;
      case UsernameValidationResult.tooLong:
        return l10n.loginInvalidUsername; // 太长也用格式错误提示
    }
  }
}
