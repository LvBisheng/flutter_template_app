/// 类型转换工具类。
///
/// 【职责】
/// 提供安全的类型转换方法，处理动态类型到具体类型的转换。
///
/// 【典型场景】
/// - JSON 解析：后端字段类型不稳定（ID 有时 int 有时 String）
/// - 表单输入：用户输入的字符串需要转为数值
/// - 配置读取：SharedPreferences 存储的动态类型
/// - 第三方数据：SDK 返回的不确定类型
///
/// 【使用方式】
/// ```dart
/// // JSON 解析
/// factory CustomerDto.fromJson(Map<String, dynamic> json) => CustomerDto(
///   id: TypeConvertUtils.asString(json['id']),
///   age: TypeConvertUtils.asInt(json['age']),
/// );
///
/// // 表单输入
/// final age = TypeConvertUtils.asInt(inputController.text);
///
/// // 配置读取
/// final timeout = TypeConvertUtils.asInt(prefs.get('timeout'), defaultValue: 30);
/// ```
class TypeConvertUtils {
  TypeConvertUtils._();  // 私有构造，禁止实例化

  /// 安全转换为 String。
  ///
  /// 支持类型：int、double、String、bool、null。
  /// - `123` → `"123"`
  /// - `3.14` → `"3.14"`
  /// - `"abc"` → `"abc"`
  /// - `null` → `defaultValue`（默认空字符串）
  static String asString(dynamic value, {String defaultValue = ''}) {
    if (value == null) return defaultValue;
    return value.toString();
  }

  /// 安全转换为 int。
  ///
  /// 支持类型：int、double、String。
  /// - `123` → `123`
  /// - `123.9` → `123`（截断小数）
  /// - `"456"` → `456`
  /// - `null` → `defaultValue`
  static int asInt(dynamic value, {int defaultValue = 0}) {
    if (value == null) return defaultValue;
    if (value is int) return value;
    if (value is double) return value.toInt();
    if (value is String) return int.tryParse(value) ?? defaultValue;
    return defaultValue;
  }

  /// 安全转换为 double。
  ///
  /// 支持类型：int、double、String。
  /// - `123` → `123.0`
  /// - `"3.14"` → `3.14`
  /// - `null` → `defaultValue`
  static double asDouble(dynamic value, {double defaultValue = 0.0}) {
    if (value == null) return defaultValue;
    if (value is double) return value;
    if (value is int) return value.toDouble();
    if (value is String) return double.tryParse(value) ?? defaultValue;
    return defaultValue;
  }

  /// 安全转换为 bool。
  ///
  /// 支持类型：bool、int、String。
  /// - `true` → `true`
  /// - `1` → `true`
  /// - `"true"` → `true`（不区分大小写）
  /// - `"yes"` → `true`
  /// - `"1"` → `true`
  /// - `null` → `defaultValue`
  static bool asBool(dynamic value, {bool defaultValue = false}) {
    if (value == null) return defaultValue;
    if (value is bool) return value;
    if (value is int) return value != 0;
    if (value is String) {
      final lower = value.toLowerCase();
      return lower == 'true' || lower == 'yes' || lower == '1';
    }
    return defaultValue;
  }

  /// 安全解析 DateTime。
  ///
  /// 支持类型：String（ISO8601）、int（毫秒时间戳）、DateTime。
  /// - `"2024-01-15"` → 解析为 DateTime
  /// - `1705286400000` → 解析为 DateTime（毫秒时间戳）
  /// - DateTime 对象直接返回
  /// - `null` → `defaultValue`
  static DateTime asDateTime(dynamic value, {DateTime? defaultValue}) {
    if (value == null) return defaultValue ?? DateTime.now();
    if (value is DateTime) return value;
    if (value is String) return DateTime.parse(value);
    if (value is int) return DateTime.fromMillisecondsSinceEpoch(value);
    throw FormatException('Invalid datetime format: ${value.runtimeType}');
  }

  /// 安全转换为 `List<T>`。
  ///
  /// 支持类型：List。
  /// - `[1, 2, 3]` → `[1, 2, 3]`
  /// - `null` → `defaultValue`
  static List<T> asList<T>(dynamic value, {List<T>? defaultValue}) {
    if (value == null) return defaultValue ?? [];
    if (value is List) return value.cast<T>();
    return defaultValue ?? [];
  }
}
