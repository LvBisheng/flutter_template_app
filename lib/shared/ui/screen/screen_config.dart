/// 设计稿基准尺寸配置。
///
/// 当设计师提供的设计稿尺寸与默认值不同时，可以在 `app.dart` 中覆盖配置：
///
/// ```dart
/// ScreenInit(
///   designWidth: 750,
///   designHeight: 1334,
///   child: AppRoot(),
/// );
/// ```
///
/// 常见设计稿尺寸：
/// - iPhone 6/7/8: 375 × 667
/// - iPhone 6/7/8 Plus: 414 × 736
/// - iPhone X/11: 375 × 812
/// - iPhone 12/13: 390 × 844
/// - Android mdpi: 360 × 640
/// - 设计稿 2x: 750 × 1334（需要配置为 designWidth: 750）
class ScreenConfig {
  /// 设计稿宽度基准（默认 375，iPhone 6/7/8 标准尺寸）
  ///
  /// 如果设计师给的是 2x 图（750px），设置为 750
  static double designWidth = 375;

  /// 设计稿高度基准（默认 812，iPhone X 标准尺寸）
  static double designHeight = 812;

  /// 字体最小适配值（单位：逻辑像素）
  ///
  /// 当字体适配后小于此值，强制使用此值，避免字体过小看不清。
  /// 合理范围：8-10
  static double minFontSize = 8;

  /// 是否禁用系统字体缩放（默认禁用）
  ///
  /// 大部分 APP 都应该禁用系统字体缩放，原因：
  /// 1. 避免 UI 布局错乱（大字体导致溢出、截断）
  /// 2. 保证设计还原度
  /// 3. 减少测试成本
  static bool disableSystemFontScale = true;

  /// 自定义字体缩放比例（可选）
  ///
  /// 当 disableSystemFontScale = true 时生效。
  /// - 1.0 = 正常大小
  /// - 1.2 = 放大 20%（适合老年人模式）
  /// - 0.9 = 缩小 10%
  ///
  /// 设置为 null 表示使用设计稿比例（默认推荐）
  static double? customFontScale;

  /// 是否启用适配（默认启用）
  ///
  /// 可以在特殊页面禁用适配：
  /// ```dart
  /// ScreenConfig.enabled = false;
  /// ```
  static bool enabled = true;

  /// 更新配置（推荐在 app.dart 初始化时调用）
  static void update({
    double? designWidth,
    double? designHeight,
    double? minFontSize,
    bool? disableSystemFontScale,
    double? customFontScale,
    bool? enabled,
  }) {
    if (designWidth != null) ScreenConfig.designWidth = designWidth;
    if (designHeight != null) ScreenConfig.designHeight = designHeight;
    if (minFontSize != null) ScreenConfig.minFontSize = minFontSize;
    if (disableSystemFontScale != null) {
      ScreenConfig.disableSystemFontScale = disableSystemFontScale;
    }
    if (customFontScale != null) ScreenConfig.customFontScale = customFontScale;
    if (enabled != null) ScreenConfig.enabled = enabled;
  }

  /// 重置为默认配置
  static void reset() {
    designWidth = 375;
    designHeight = 812;
    minFontSize = 10.0;
    disableSystemFontScale = true;
    customFontScale = null;
    enabled = true;
  }

  // 私有构造函数，防止实例化
  ScreenConfig._();
}
