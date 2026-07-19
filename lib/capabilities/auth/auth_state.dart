/// ─────────────────────────────────────────────────────────────────────
/// AuthState - 登录态状态。
/// ─────────────────────────────────────────────────────────────────────
///
/// 【职责】
/// 存储用户的登录状态信息，供多个模块共享。
///
/// 【字段说明】
/// - `token`: 访问令牌（用于 API 鉴权）
/// - `userName`: 用户名称（用于 UI 显示）
///
/// 【状态来源】
/// 1. 登录成功：`SessionManager.login(token, userName)` 写入
/// 2. App 启动：`SessionManager.restore()` 从 SecureStorage 恢复
/// 3. 退出登录：`SessionManager.logout()` 清空
///
/// 【状态变化通知】
/// 通过 Riverpod 的 NotifierProvider 管理：
/// - 状态变化时，所有监听的 Widget 自动重建
/// - 例如：路由守卫监听此状态，决定是否跳转到登录页
///
/// 【使用示例】
/// ```dart
/// // 监听状态（自动重建）
/// final state = ref.watch(sessionManagerProvider);
/// if (state.isLoggedIn) {
///   Text('欢迎，${state.userName}');
/// }
///
/// // 检查是否登录
/// final isLoggedIn = ref.read(sessionManagerProvider).isLoggedIn;
/// ```
///
/// ─────────────────────────────────────────────────────────────────────
class AuthState {
  const AuthState({this.token, this.userName});

  /// 访问令牌。
  ///
  /// 用于 API 请求的 Authorization 头。
  /// null 表示未登录。
  final String? token;

  /// 用户名称。
  ///
  /// 用于 UI 显示，如顶部问候语、个人中心。
  final String? userName;

  /// 是否已登录。
  ///
  /// 判断逻辑：token 存在且非空。
  /// 这是一个便捷方法，避免在业务代码中重复判断。
  bool get isLoggedIn => token != null && token!.isNotEmpty;
}
