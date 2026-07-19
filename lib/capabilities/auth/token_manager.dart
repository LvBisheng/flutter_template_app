import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/storage/secure_storage.dart';

/// ─────────────────────────────────────────────────────────────────────
/// TokenManager - Token 存储管理。
/// ─────────────────────────────────────────────────────────────────────
///
/// 【职责】
/// 封装 Token 的持久化存储，不涉及登录状态管理。
///
/// 【与 SessionManager 的关系】
/// - TokenManager：负责 Token 的读写（存储层）
/// - SessionManager：负责登录状态管理（业务层）
///
/// ```
/// SessionManager（业务层）
///     ↓ 调用
/// TokenManager（存储层）
///     ↓ 调用
/// SecureStorage（底层实现）
/// ```
///
/// 【为什么要单独抽一层？】
/// 1. 职责分离：TokenManager 只管存储，不管状态
/// 2. 可测试性：可以 Mock TokenManager 进行单元测试
/// 3. 扩展性：未来可以添加 Token 过期检查、刷新逻辑
///
/// 【存储位置】
/// Token 存储在 SecureStorage 中，使用 Keychain(iOS) / Keystore(Android) 保护。
/// 不使用 LocalStorage，因为 Token 是敏感数据。
///
/// 【使用示例】
/// ```dart
/// // 通过 Provider 获取
/// final tokenManager = ref.read(tokenManagerProvider);
///
/// // 保存 Token
/// await tokenManager.saveToken('abc123');
///
/// // 读取 Token
/// final token = await tokenManager.readToken();
///
/// // 清除 Token
/// await tokenManager.clearToken();
/// ```
///
/// ─────────────────────────────────────────────────────────────────────

/// TokenManager 的 Provider。
///
/// 全局单例，所有模块共享同一个实例。
/// 依赖 SecureStorage（Token 存储需要安全存储）。
final tokenManagerProvider = Provider<TokenManager>(
  (_) => TokenManager(const SecureStorage()),
);

class TokenManager {
  TokenManager(this._storage);

  /// Token 存储的 key。
  ///
  /// 固定为 'access_token'，存储在 SecureStorage 中。
  /// 如果需要存储多个Token（如 refresh_token），可以扩展。
  static const _key = 'access_token';

  /// SecureStorage 实例。
  ///
  /// 通过构造函数注入，便于单元测试时 Mock。
  final SecureStorage _storage;

  /// 保存 Token。
  ///
  /// 登录成功后调用，Token 会加密存储在 SecureStorage 中。
  /// ```dart
  /// await tokenManager.saveToken(response.token);
  /// ```
  Future<void> saveToken(String token) => _storage.write(_key, token);

  /// 读取 Token。
  ///
  /// App 启动时调用，恢复登录态。
  /// 返回 null 表示未登录或 Token 已清除。
  ///
  /// ⚠️ 注意：这是异步操作，不能在 build() 中直接调用。
  /// 应该在 `initState()` 或 `SessionManager.restore()` 中调用。
  Future<String?> readToken() => _storage.read(_key);

  /// 清除 Token。
  ///
  /// 退出登录时调用，清除本地存储的 Token。
  /// ```dart
  /// await tokenManager.clearToken();
  /// ```
  Future<void> clearToken() => _storage.delete(_key);
}
