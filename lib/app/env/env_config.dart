import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/logging/app_logger.dart';
import '../../core/storage/local_storage.dart';
import 'app_env.dart';

/// 统一管理环境参数。
///
/// 打包参数提供默认值，调试开关开启时允许在 App 内切换环境。
/// 当 ENV_SWITCH_ENABLED=false 或 release 构建时，强制使用生产环境。
class EnvConfig {
  const EnvConfig({
    required this.env,
    required this.baseUrl,
    required this.switchEnabled,
  });

  final AppEnv env;
  final String baseUrl;
  final bool switchEnabled;

  static const packagedEnvName = String.fromEnvironment(
    'APP_ENV',
    defaultValue: 'sit',
  );

  static const packagedSwitchEnabled = bool.fromEnvironment(
    'ENV_SWITCH_ENABLED',
    defaultValue: true,
  );

  static const _envStorageKey = 'runtime_app_env';

  static EnvConfig packaged() {
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

  static void _applyConsolePolicy(EnvConfig config) {
    appLogger.setConsoleEnabled(
      config.switchEnabled && config.env != AppEnv.prd,
    );
  }
}

final envConfigProvider = NotifierProvider<EnvConfigController, EnvConfig>(
  EnvConfigController.new,
);

class EnvConfigController extends Notifier<EnvConfig> {
  @override
  EnvConfig build() => EnvConfig.restore();

  Future<void> selectEnv(AppEnv env) async {
    if (!state.switchEnabled) return;
    state = EnvConfig.forEnv(env, switchEnabled: true);
    EnvConfig._applyConsolePolicy(state);
    await LocalStorage.setString(EnvConfig._envStorageKey, env.name);
  }
}
