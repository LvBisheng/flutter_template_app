import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'auth_state.dart';
import 'token_manager.dart';

/// ─────────────────────────────────────────────────────────────────────
/// SessionManager - 登录态管理。
/// ─────────────────────────────────────────────────────────────────────
///
/// 【职责】
/// 管理用户的登录状态，包括：
/// - 登录：保存 Token，更新状态
/// - 退出：清除 Token，重置状态
/// - 恢复：App 启动时从存储恢复登录态
///
/// 【架构位置】
/// ```
///┌─────────────────────────────────────────────────────────────┐
/// │UI 层（LoginPage, SettingsPage）                              │
/// │   ↓ 调用 login() / logout() / clearToken()                  │
/// └─────────────────────────────────────────────────────────────┘
///                          ↓
/// ┌─────────────────────────────────────────────────────────────┐
/// │ SessionManager（登录态管理）                                  │
/// │   - 管理 AuthState                                          │
/// │   - 协调 TokenManager                                       │
/// └─────────────────────────────────────────────────────────────┘
///                          ↓
/// ┌─────────────────────────────────────────────────────────────┐
/// │ TokenManager（Token 存储）│
/// │   - saveToken / readToken / clearToken                      │
/// └─────────────────────────────────────────────────────────────┘
///                          ↓
/// ┌─────────────────────────────────────────────────────────────┐
/// │ SecureStorage（安全存储）                                     │
/// │   - Keychain(iOS) / Keystore(Android)                       │
/// └─────────────────────────────────────────────────────────────┘
/// ```
///
/// 【状态变化触发 UI 更新】
/// SessionManager 是 Riverpod 的 Notifier，状态变化会通知所有监听者：
/// - `ref.watch(sessionManagerProvider)` → 自动重建 Widget
/// - 路由守卫监听此状态 → 自动跳转登录页/首页
///
/// 【使用示例】
/// ```dart
/// // 登录
/// await ref.read(sessionManagerProvider.notifier).login(token, userName);
///
/// // 退出
/// await ref.read(sessionManagerProvider.notifier).logout();
///
/// // 监听状态
/// final state = ref.watch(sessionManagerProvider);
/// if (state.isLoggedIn) { ... }
/// ```
///
/// 【与其他模块的关系】
/// - LoginUseCase：登录成功后调用 SessionManager.login()
/// - RouteGuard：监听 isLoggedIn 决定是否跳转登录页
/// - SettingsPage：调用 clearToken() / logout()
/// - ApiClient：读取 Token添加到请求头
///
/// ─────────────────────────────────────────────────────────────────────

/// SessionManager 的 Provider。
///
/// 使用 NotifierProvider 管理状态：
/// - 状态类型：AuthState
/// - Notifier 类型：SessionManager
final sessionManagerProvider = NotifierProvider<SessionManager, AuthState>(
  SessionManager.new,
);

class SessionManager extends Notifier<AuthState> {
  /// 初始化状态。
  ///
  /// 默认返回空状态（未登录）。
  /// 真正的登录态恢复在 `restore()` 中进行。
  ///
  /// 为什么不在 build() 中直接调用 restore()？
  /// - build() 应该是同步的，快速返回初始状态
  /// - restore() 是异步操作（读取 SecureStorage）
  /// - App 启动时在 bootstrap() 中显式调用 restore()
  @override
  AuthState build() => const AuthState();

  /// 恢复登录态。
  ///
  /// App 启动时调用，从 SecureStorage 读取保存的 Token：
  /// ```dart
  /// // 在 bootstrap.dart 中
  /// await ref.read(sessionManagerProvider.notifier).restore();
  /// ```
  ///
  /// 流程：
  /// 1. 从 TokenManager 读取 Token
  /// 2. Token 存在 → 恢复登录态
  /// 3. Token 不存在 → 保持未登录状态
  Future<void> restore() async {
    final token = await ref.read(tokenManagerProvider).readToken();
    if (token != null) {
      // Token 存在，恢复登录态
      // 注意：这里 userName 是写死的，实际项目应该也从存储读取
      state = AuthState(token: token, userName: 'Demo Operator');
    } else {
      // Token 不存在，保持未登录
      state = const AuthState();
    }
  }

  /// 清除 Token（不退出登录）。
  ///
  /// 用于"清除 Token"功能，状态变为未登录，但不调用退出接口。
  /// 通常是调试/开发时使用。
  Future<void> clearToken() async {
    await ref.read(tokenManagerProvider).clearToken();
    state = const AuthState();
  }

  /// 登录。
  ///
  /// 登录成功后调用，保存 Token 并更新状态：
  /// ```dart
  /// // 在 LoginUseCase 中
  /// final result = await _repository.login(...);
  /// await _sessionManager.login(result.token, result.userName);
  /// ```
  ///
  /// 流程：
  /// 1. 将 Token 保存到 SecureStorage（持久化）
  /// 2. 更新 AuthState（触发 UI 更新）
  /// 3. 路由守卫检测到登录态变化，自动跳转首页
  Future<void> login(String token, String userName) async {
    // 1. 持久化存储 Token
    await ref.read(tokenManagerProvider).saveToken(token);
    // 2. 更新状态（触发 UI 更新）
    state = AuthState(token: token, userName: userName);
  }

  /// 退出登录。
  ///
  /// 清除 Token 并重置状态：
  /// ```dart
  /// await ref.read(sessionManagerProvider.notifier).logout();
  /// ```
  ///
  /// 流程：
  /// 1. 清除 SecureStorage 中的 Token
  /// 2. 重置 AuthState（触发 UI 更新）
  /// 3. 路由守卫检测到未登录，自动跳转登录页
  Future<void> logout() async {
    await clearToken();
  }
}
