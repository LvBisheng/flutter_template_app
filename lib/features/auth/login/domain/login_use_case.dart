import '../../../../capabilities/auth/session_manager.dart';
import '../../../../core/network/app_exception.dart';
import 'login_repository.dart';

/// ─────────────────────────────────────────────────────────────────────
/// LoginUseCase - 登录用例（编排业务流程）。
/// ─────────────────────────────────────────────────────────────────────
///
/// 【职责】
/// 编排完整的登录业务流程：
/// 1. 校验输入（用户名/密码是否为空）
/// 2. 调用 Repository 登录
/// 3. 保存登录态到 SessionManager
///
/// 【为什么需要 UseCase？】
///
/// 问题：为什么不直接在 Controller 里写这些逻辑？
///
/// 答案：Controller 直接写的话，会有以下问题：
/// 1. Controller 膨胀：不只负责 UI 交互，还要管业务逻辑
/// 2. 逻辑难以复用：如果其他页面也需要登录（如注册后自动登录），代码会重复
/// 3. 难以测试：测试业务逻辑时，还要 mock Controller 的 UI 状态
///
/// 有了 UseCase，好处：
/// 1. Controller 只管 UI 交互（输入 → UseCase → 结果）
/// 2. UseCase 可被多个 Controller 复用
/// 3. UseCase 纯业务逻辑，易于单元测试
///
/// 【UseCase 适合的场景】
/// ✅ 多步骤流程（如：校验 → 登录 → 保存 Token → 记录日志）
/// ✅ 跨 Repository 操作（如：读用户信息 + 读订单信息 → 合并）
/// ✅ 可复用逻辑（如：多处都需要登录）
///
/// 【UseCase 不适合的场景】
/// ❌ 简单 CRUD（直接 Controller 调 Repository 即可）
/// ❌ 只有一个步骤的操作（如：只调用一个接口）
///
/// 登录这个场景其实属于"边界情况"：
/// - 简单版：直接 Controller 调 Repository
/// - 完整版：UseCase 编排校验 + 登录 + 保存 Token
///
/// 本模板选择完整版，是为了演示 UseCase 的用法。
///
/// ─────────────────────────────────────────────────────────────────────
class LoginUseCase {
  const LoginUseCase(this._repository, this._sessionManager);

  /// 依赖 Repository（数据源）
  final LoginRepository _repository;

  /// 依赖 SessionManager（登录态管理）
  /// 为什么不直接在 Repository 里保存 Token？
  /// - SessionManager 是跨模块的"能力"（capability），不只服务于登录
  /// - 其他模块（如 Token 刷新、自动登录）也需要用它
  /// - 使用 UseCase 编排，保证职责清晰
  final SessionManager _sessionManager;

  /// 执行登录用例。
  ///
  /// 流程：
  /// 1. 校验用户名/密码是否为空
  /// 2. 调用 Repository 登录
  /// 3. 保存登录态
  ///
  /// 抛出异常的情况：
  /// - 用户名/密码为空 → AppException（参数校验失败）
  /// - 网络请求失败 → Dio 抛出的异常
  Future<void> call(
    String username,
    String password, {
    required String emptyCredentialsMessage,
  }) async {
    // 1. 参数校验（业务规则，不放 Repository）
    if (username.trim().isEmpty || password.isEmpty) {
      throw AppException(emptyCredentialsMessage);
    }

    // 2. 调用 Repository 获取登录结果
    final result = await _repository.login(
      username: username,
      password: password,
    );

    // 3. 保存登录态（跨模块能力）
    await _sessionManager.login(result.token, result.userName);
  }
}
