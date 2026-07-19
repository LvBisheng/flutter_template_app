import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'app/env/env_config.dart';
import 'capabilities/auth/session_manager.dart';
import 'core/logging/app_logger.dart';
import 'core/storage/local_storage.dart';
import 'core/storage/secure_storage.dart';
import 'features/diagnostics/presentation/global_error_handler.dart';

/// 应用启动入口。
///
/// 模板项目把启动逻辑放在 bootstrap 中，后续接入崩溃收集、日志初始化、
/// 环境切换时，不需要让 main.dart 变成一个难维护的大文件。
///
/// ─────────────────────────────────────────────────────────────────────
/// Flutter 应用启动的关键概念：
/// ─────────────────────────────────────────────────────────────────────
/// 1. WidgetsFlutterBinding - Flutter 框架和 Flutter 引擎之间的粘合层
///    - 负责处理手势、渲染、调度等底层交互
///    - 必须在使用任何 Flutter 服务前初始化
///
/// 2. ProviderContainer - Riverpod 的状态容器
///    - 存储所有 Provider 的状态
///    - 提供 read/watch/dispose 等方法
///    - 生命周期与整个应用相同步
///
/// 3. 异步初始化模式
///    - 先完成必要的初始化（存储、配置、登录状态）
///    - 再调用 run() 启动 UI
///    - 保证 UI 启动时数据已准备好
Future<void> bootstrap(void Function(ProviderContainer container) run) async {
  // ─────────────────────────────────────────────────────────────
  // WidgetsFlutterBinding.ensureInitialized()
  // ─────────────────────────────────────────────────────────────
  // 这是 Flutter 启动的关键一步！
  //
  // 作用：确保 Flutter Binding 已初始化
  // Binding 是 Flutter 框架和底层引擎之间的桥梁
  //
  // 为什么需要这行代码？
  // 1. runApp() 内部会自动调用，但在 runApp 之前如果要用到 Flutter 服务
  //    （如 SharedPreferences、MethodChannel、平台插件等），必须先手动调用
  // 2. 它会初始化：
  //    - GestureBinding（手势识别）
  //    - SchedulerBinding（任务调度）
  //    - RendererBinding（渲染）
  //    - WidgetsBinding（Widget 树管理）
  //
  // 如果不调用，await LocalStorage.init() 可能会报错！
  WidgetsFlutterBinding.ensureInitialized();

  // ─────────────────────────────────────────────────────────────
  // 本地存储初始化
  // ─────────────────────────────────────────────────────────────
  // LocalStorage 基于 SharedPreferences 封装
  // 必须在 runApp 之前初始化，因为后续代码会读取存储的数据
  await LocalStorage.init();

  // ─────────────────────────────────────────────────────────────
  // 检测是否是全新安装
  // ─────────────────────────────────────────────────────────────
  // iOS Keychain 数据在 App 卸载后不会自动清除。
  // 如果用户卸载后重新安装，Keychain 中可能残留旧数据。
  // 这里检测是否是首次启动，如果是则清除 SecureStorage 数据。
  final isFirstLaunch = LocalStorage.getBool('first_launch') == null;
  if (isFirstLaunch) {
    appLogger.i('First launch detected, clearing secure storage');
    // 标记已启动过（写入 LocalStorage，App 卸载后会清除）
    await LocalStorage.setBool('first_launch', false);
    // 清除 SecureStorage 中可能残留的数据
    await const SecureStorage().deleteAll();
  }

  // ─────────────────────────────────────────────────────────────
  // 环境配置恢复
  // ─────────────────────────────────────────────────────────────
  // 从 LocalStorage 读取上次保存的环境设置（SIT/UAT/PRD）
  // 同时会根据环境设置日志级别
  EnvConfig.restore();

  // ─────────────────────────────────────────────────────────────
  // ProviderContainer 创建
  // ─────────────────────────────────────────────────────────────
  // 这是 Riverpod 的状态容器，所有 Provider 的状态都存在这里
  //
  // ProviderContainer 的作用：
  // 1. 创建和管理 Provider 实例
  // 2. 提供 read/watch 方法访问状态
  // 3. 处理 Provider 的依赖关系
  // 4. 支持 Provider 的刷新和销毁
  final container = ProviderContainer();

  // ─────────────────────────────────────────────────────────────
  // 全局错误处理器安装
  // ─────────────────────────────────────────────────────────────
  // 捕获 Flutter 框架未处理的异常，统一记录日志
  // 包括：异步错误、框架异常、路由错误等
  installGlobalErrorHandlers(container);

  // ─────────────────────────────────────────────────────────────
  // 恢复用户登录状态
  // ─────────────────────────────────────────────────────────────
  // 从 SecureStorage 读取保存的 token
  // 如果 token 存在，自动恢复登录状态，用户下次打开无需重新登录
  //
  // container.read() vs container.read(provider.notifier)：
  // - read(provider) 读取 provider 的状态值
  // - read(provider.notifier) 获取 Notifier 实例，调用方法
  await container.read(sessionManagerProvider.notifier).restore();

  // 记录启动完成日志
  appLogger.i('App bootstrap completed');

  // ─────────────────────────────────────────────────────────────
  // 调用回调，启动应用
  // ─────────────────────────────────────────────────────────────
  // run 是 main.dart 传入的回调，内容是：
  // runApp(UncontrolledProviderScope(container: container, child: AppRoot()))
  //
  // 这样做的好处：
  // 1. bootstrap 负责初始化，main.dart 负责启动 UI，职责分离
  // 2. 方便测试：可以 mock bootstrap 的初始化逻辑
  run(container);
}
