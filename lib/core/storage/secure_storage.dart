import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// ─────────────────────────────────────────────────────────────────────
/// SecureStorage - 安全存储。
/// ─────────────────────────────────────────────────────────────────────
///
/// 【职责】
/// 封装 flutter_secure_storage，提供加密存储能力。
///
/// 【适用场景】
/// ✅ 敏感数据（如 Token、密码、证书）
/// ✅ 需要系统级保护的数据
/// ✅ 不希望被沙盒读取的数据
///
/// 【不适用场景】
/// ❌ 频繁读写的非敏感数据（性能较差）→ 使用 LocalStorage
/// ❌ 大量数据（有存储限制）→ 使用数据库
///
/// 【底层实现】
/// - iOS: Keychain Services（系统级加密存储）
/// - Android: Keystore + EncryptedSharedPreferences
/// - macOS: Keychain Services
/// - Windows: Windows Credential Manager
/// - Linux: libsecret
///
/// 【安全性】
/// - 数据加密存储，App 沙盒无法直接读取
/// - 系统级别的安全保护
/// - 越狱/Root 设备仍可能被攻破，但比 LocalStorage 安全得多
///
/// 【与 LocalStorage 的区别】
/// | 特性 | LocalStorage | SecureStorage |
/// |------|-------------|---------------|
/// | 底层实现 | SharedPreferences | Keychain/Keystore |
/// | 数据安全 | 明文 | 加密 |
/// | 性能 | 快 | 较慢（涉及加密解密） |
/// | 存储限制 | 无明显限制 | 有一定限制 |
/// | App 卸载后 | 数据清除 | iOS: 清除；Android: 可能保留 |
///
/// 【使用示例】
/// ```dart
/// const storage = SecureStorage();
///
/// // 保存 Token
/// await storage.write('access_token', token);
///
/// // 读取 Token
/// final token = await storage.read('access_token');
///
/// // 删除 Token
/// await storage.delete('access_token');
/// ```
///
/// 【注意事项】
/// 1. 不要存储大量数据，有性能开销
/// 2. Android 上某些机型可能需要额外配置
/// 3. iOS Keychain 在 App 卸载后数据可能保留（取决于配置）
///
/// ─────────────────────────────────────────────────────────────────────
class SecureStorage {
  /// 私有构造函数，使用单例模式。
  ///
  /// 整个 App 共享一个 FlutterSecureStorage 实例。
  const SecureStorage();

  /// FlutterSecureStorage 实例。
  ///
  /// 使用 static const 确保全局只有一个实例。
  /// FlutterSecureStorage 内部会处理平台差异。
  static const _storage = FlutterSecureStorage();

  /// 写入数据。
  ///
  /// [key] 存储的键名
  /// [value] 存储的值（字符串）
  ///
  /// 底层行为：
  /// - iOS: 写入 Keychain
  /// - Android: 使用 Keystore 加密后写入 SharedPreferences
  Future<void> write(String key, String value) =>
      _storage.write(key: key, value: value);

  /// 读取数据。
  ///
  /// 返回 null 表示 key 不存在。
  ///
  /// ⚠️ 注意：这是异步操作，不能在 build() 中直接使用。
  /// 如果需要在 build() 中使用，考虑：
  /// 1. 在 initState() 中预先加载
  /// 2. 使用 FutureBuilder
  Future<String?> read(String key) => _storage.read(key: key);

  /// 删除数据。
  Future<void> delete(String key) => _storage.delete(key: key);

  /// 清空所有数据。
  ///
  /// ⚠️ 谨慎使用，会清除所有安全存储的数据。
  Future<void> deleteAll() => _storage.deleteAll();
}
