import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'app/env/env_config.dart';
import 'capabilities/auth/session_manager.dart';
import 'core/logging/app_logger.dart';
import 'core/storage/local_storage.dart';

/// 应用启动入口。
///
/// 模板项目把启动逻辑放在 bootstrap 中，后续接入崩溃收集、日志初始化、
/// 环境切换时，不需要让 main.dart 变成一个难维护的大文件。
Future<void> bootstrap(void Function(ProviderContainer container) run) async {
  WidgetsFlutterBinding.ensureInitialized();
  await LocalStorage.init();
  EnvConfig.restore();
  final container = ProviderContainer();
  await container.read(sessionManagerProvider.notifier).restore();
  appLogger.i('App bootstrap completed');
  run(container);
}
