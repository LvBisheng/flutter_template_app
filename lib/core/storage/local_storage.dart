import 'package:shared_preferences/shared_preferences.dart';

/// ─────────────────────────────────────────────────────────────────────
/// LocalStorage - 普通本地存储。
/// ─────────────────────────────────────────────────────────────────────
///
/// 【职责】
/// 封装 SharedPreferences，提供键值对存储能力。
///
/// 【适用场景】
/// - 用户偏好设置（如语言、主题、字体大小）
/// - 非敏感数据（如上一次选择的选项）
/// - 简单的字符串、布尔值、列表存储
///
/// 【不适用场景】
/// ❌ 敏感数据（如 Token、密码）→ 使用 SecureStorage
/// ❌ 复杂对象 → 考虑数据库或 JSON 序列化
///
/// 【特点】
/// - 存储：明文存储在 App 沙盒
/// - 性能：读写快，适合频繁访问
/// - 安全性：低，可被越狱/Root 设备读取
///
/// 【与 SecureStorage 的区别】
/// | 特性 | LocalStorage | SecureStorage |
/// |------|-------------|---------------|
/// | 底层实现 | SharedPreferences | Keychain(iOS) / Keystore(Android) |
/// | 数据安全 | 明文，可被读取 | 加密，系统级保护 |
/// | 适用数据 | 非敏感数据 | 敏感数据（Token、密码） |
/// | 性能 | 快 | 较慢 |
/// | App 卸载后 | 数据清除 | iOS: 清除；Android: 可能保留 |
///
/// 【使用示例】
/// ```dart
/// // 保存用户偏好
/// await LocalStorage.setString('language', 'zh');
/// await LocalStorage.setBool('dark_mode', true);
///
/// // 读取
/// final lang = LocalStorage.getString('language');
/// final isDark = LocalStorage.getBool('dark_mode');
/// ```
///
/// 【初始化】
/// 必须在 App 启动时调用 `LocalStorage.init()`：
/// ```dart
/// // 在 bootstrap.dart 或 main.dart 中
/// await LocalStorage.init();
/// ```
///
/// ─────────────────────────────────────────────────────────────────────
class LocalStorage {
  /// 私有构造函数，禁止实例化。
  ///
  /// 所有方法都是静态的，不需要创建实例。
  LocalStorage._();

  /// SharedPreferences 实例。
  ///
  /// 在 `init()` 中初始化，之后全局可用。
  static late final SharedPreferences _prefs;

  /// 初始化本地存储。
  ///
  /// 必须在 App 启动时调用，通常在 `bootstrap()` 中：
  /// ```dart
  /// Future<void> bootstrap() async {
  ///   WidgetsFlutterBinding.ensureInitialized();
  ///   await LocalStorage.init();  // 必须在使用前调用
  ///   runApp(MyApp());
  /// }
  /// ```
  static Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  // ─────────────────────────────────────────────────────────────────
  // 基础读写方法
  // ─────────────────────────────────────────────────────────────────

  /// 保存字符串。
  static Future<void> setString(String key, String value) =>
      _prefs.setString(key, value);

  /// 读取字符串。
  ///
  /// 返回 null 表示 key 不存在。
  static String? getString(String key) => _prefs.getString(key);

  /// 保存布尔值。
  static Future<void> setBool(String key, bool value) =>
      _prefs.setBool(key, value);

  /// 读取布尔值。
  static bool? getBool(String key) => _prefs.getBool(key);

  /// 保存字符串列表。
  static Future<void> setStringList(String key, List<String> value) =>
      _prefs.setStringList(key, value);

  /// 读取字符串列表。
  static List<String>? getStringList(String key) => _prefs.getStringList(key);

  /// 删除指定 key 的数据。
  static Future<void> remove(String key) => _prefs.remove(key);

  /// 清空所有数据。
  ///
  /// ⚠️ 谨慎使用，会清除所有本地存储的数据。
  static Future<void> clear() => _prefs.clear();
}
