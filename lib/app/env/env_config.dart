import 'package:flutter/foundation.dart' show kReleaseMode;
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/logging/app_logger.dart';
import '../../core/storage/local_storage.dart';
import 'app_env.dart';

/// ─────────────────────────────────────────────────────────────────────
/// 环境配置。
/// ─────────────────────────────────────────────────────────────────────
///
/// 【设计目标】
/// 统一管理环境参数，支持 App 内切换环境，无需命令行参数。
///
/// 【使用方式】
/// ┌─────────────────────────────────────────────────────────────────┐
/// │ 开发调试（flutter run）                                          │
/// ├─────────────────────────────────────────────────────────────────┤
/// │ 1. 直接运行，默认使用 sit 环境                                    │
/// │ 2. 在 App 内「开发工具」面板切换环境                              │
/// │ 3. 选择会保存到本地，下次启动自动恢复                              │
/// └─────────────────────────────────────────────────────────────────┘
/// ┌─────────────────────────────────────────────────────────────────┐
/// │ 打包发布（flutter build）                                        │
/// ├─────────────────────────────────────────────────────────────────┤
/// │ # 打 sit 测试包（允许 App 内切环境）                              │
/// │ flutter build apk --dart-define=APP_ENV=sit                     │
/// │                                                                 │
/// │ # 打 prd 生产包（锁定环境，禁止切换）                              │
/// │ flutter build apk --dart-define=APP_ENV=prd                     │
/// │                 --dart-define=ENV_SWITCH_ENABLED=false          │
/// └─────────────────────────────────────────────────────────────────┘
///
/// 【字段说明】
/// - [env]：当前环境（sit/uat/prd 等）
/// - [baseUrl]：API 基础地址
/// - [switchEnabled]：是否允许切换环境
/// - [isDevMode]：是否为开发模式（统一判断开关）
///
/// 【安全策略】
/// - Release 包锁定后禁止切换环境
/// - ENV_SWITCH_ENABLED=false 时强制使用生产环境
/// - isDevMode=false 时禁用所有开发调试功能
///
class EnvConfig {
  const EnvConfig({
    required this.env,
    required this.baseUrl,
    required this.switchEnabled,
  });

  /// 当前环境。
  final AppEnv env;

  /// API 基础地址。
  final String baseUrl;

  /// 是否允许切换环境。
  final bool switchEnabled;

  /// 是否为开发模式。
  ///
  /// 【用途】
  /// 统一控制开发调试功能的开关，避免多处重复判断：
  /// - Mock 拦截器
  /// - 开发日志
  /// - 诊断工具
  /// - 等等
  ///
  /// 【示例】
  /// ```dart
  /// if (envConfig.isDevMode) {
  ///   // 仅开发环境启用的功能
  /// }
  /// ```
  bool get isDevMode => switchEnabled && env != AppEnv.prd;

  // ═══════════════════════════════════════════════════════════════════════
  // 打包参数（编译时常量）
  // ═══════════════════════════════════════════════════════════════════════

  /// 打包时传入的环境名称。
  ///
  /// 【用途】
  /// 仅用于 `flutter build` 打包时指定默认环境。
  ///
  /// 【开发调试】
  /// `flutter run` 时无需关心此参数，直接在 App 内切换即可。
  ///
  /// 【示例】
  /// ```bash
  /// # 打 sit 包
  /// flutter build apk --dart-define=APP_ENV=sit
  /// ```
  static const packagedEnvName = String.fromEnvironment(
    'APP_ENV',
    defaultValue: 'sit',
  );

  /// 打包时传入的环境开关。
  ///
  /// 【用途】
  /// 控制是否允许在 App 内切换环境：
  /// - true（默认）：允许切换，适用于测试包
  /// - false：锁定环境，适用于生产包
  ///
  /// 【示例】
  /// ```bash
  /// # 打生产包（锁定环境）
  /// flutter build apk --dart-define=ENV_SWITCH_ENABLED=false
  /// ```
  static const packagedSwitchEnabled = bool.fromEnvironment(
    'ENV_SWITCH_ENABLED',
    defaultValue: true,
  );

  /// 运行时环境存储 Key。
  static const _envStorageKey = 'runtime_app_env';

  // ═══════════════════════════════════════════════════════════════════════
  // 工厂方法
  // ═══════════════════════════════════════════════════════════════════════

  /// 获取打包时的环境配置。
  ///
  /// 【流程】
  /// 1. Release 包 + ENV_SWITCH_ENABLED=false → 锁定为 prd 环境
  /// 2. 否则使用 --dart-define 指定的默认环境（允许切换）
  /// 3. 应用控制台日志策略
  ///
  static EnvConfig packaged() {
    // 安全检查：Release 包锁定后不允许切换环境
    final switchEnabled = packagedSwitchEnabled && !kReleaseMode;

    if (!switchEnabled) {
      final config = forEnv(AppEnv.prd, switchEnabled: false);
      _applyConsolePolicy(config);
      return config;
    }

    final config = forEnv(AppEnvX.parse(packagedEnvName), switchEnabled: true);
    _applyConsolePolicy(config);
    return config;
  }

  /// 恢复运行时环境（从本地存储读取用户上次选择）。
  ///
  /// 【流程】
  /// 1. 先获取打包时的默认环境
  /// 2. 如果不允许切换（生产包锁定），直接返回 prd
  /// 3. 否则从本地存储读取用户上次选择
  /// 4. 应用控制台日志策略
  ///
  /// 【用户体验】
  /// - 开发调试时，用户选择的环境会被保存
  /// - 下次启动自动恢复上次选择
  /// - 生产包忽略本地存储，始终使用 prd
  ///
  static EnvConfig restore() {
    final base = packaged();
    if (!base.switchEnabled) return base;

    final env = AppEnvX.parse(
      LocalStorage.getString(_envStorageKey) ?? base.env.name,
    );
    final config = forEnv(env, switchEnabled: true);
    _applyConsolePolicy(config);
    return config;
  }

  /// 创建指定环境的配置。
  ///
  /// 【参数】
  /// - [env]：目标环境
  /// - [switchEnabled]：是否允许切换
  ///
  /// 【安全】
  /// 如果不允许切换，强制使用 prd 环境。
  ///
  static EnvConfig forEnv(AppEnv env, {required bool switchEnabled}) {
    final safeEnv = switchEnabled ? env : AppEnv.prd;
    final baseUrl = switch (safeEnv) {
      AppEnv.sit => 'https://sit-api.example.invalid',
      AppEnv.sit2 => 'https://sit2-api.example.invalid',
      AppEnv.sit3 => 'https://sit3-api.example.invalid',
      AppEnv.uat => 'https://uat-api.example.invalid',
      AppEnv.uat1 => 'https://uat1-api.example.invalid',
      AppEnv.uat2 => 'https://uat2-api.example.invalid',
      AppEnv.prd => 'https://api.example.invalid',
    };
    return EnvConfig(
      env: safeEnv,
      baseUrl: baseUrl,
      switchEnabled: switchEnabled,
    );
  }

  /// 应用控制台日志策略。
  ///
  /// 【策略】
  /// - 开发模式：开启控制台日志
  /// - 其余情况：关闭控制台日志
  ///
  static void _applyConsolePolicy(EnvConfig config) {
    appLogger.setConsoleEnabled(config.isDevMode);
  }
}

// ═══════════════════════════════════════════════════════════════════════
// Provider & Controller
// ═══════════════════════════════════════════════════════════════════════

/// EnvConfig Provider。
final envConfigProvider = NotifierProvider<EnvConfigController, EnvConfig>(
  EnvConfigController.new,
);

/// ─────────────────────────────────────────────────────────────────────
/// 环境配置 Controller。
/// ─────────────────────────────────────────────────────────────────────
///
/// 【职责】
/// 管理运行时环境切换，持久化用户选择。
///
class EnvConfigController extends Notifier<EnvConfig> {
  @override
  EnvConfig build() => EnvConfig.restore();

  /// 切换环境。
  ///
  /// 【安全】
  /// 如果不允许切换，直接返回不执行任何操作。
  ///
  /// 【持久化】
  /// 切换后保存到本地存储，下次启动自动恢复。
  ///
  Future<void> selectEnv(AppEnv env) async {
    if (!state.switchEnabled) return;

    state = EnvConfig.forEnv(env, switchEnabled: true);
    EnvConfig._applyConsolePolicy(state);
    await LocalStorage.setString(EnvConfig._envStorageKey, env.name);
  }
}
