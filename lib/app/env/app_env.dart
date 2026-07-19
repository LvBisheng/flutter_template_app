/// ─────────────────────────────────────────────────────────────────────
/// 应用环境枚举。
/// ─────────────────────────────────────────────────────────────────────
///
/// 【环境说明】
/// - sit/sit2/sit3：系统集成测试环境
/// - uat/uat1/uat2：用户验收测试环境
/// - prd：生产环境
///
/// 【命名规范】
/// 环境名称与后端保持一致，便于 CI/CD 配置对齐。
///
enum AppEnv { sit, sit2, sit3, uat, uat1, uat2, prd }

/// AppEnv 扩展方法。
extension AppEnvX on AppEnv {
  /// 显示名称（用于 UI）。
  String get label => name;

  /// 从字符串解析环境。
  ///
  /// 【默认值】
  /// 如果字符串不匹配任何环境，默认返回 `AppEnv.sit`。
  static AppEnv parse(String value) {
    return AppEnv.values.firstWhere(
      (env) => env.name == value,
      orElse: () => AppEnv.sit,
    );
  }
}
