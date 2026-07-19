import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'app/app.dart';
import 'bootstrap.dart';

/// Flutter 应用入口函数。
///
/// Flutter 应用的启动流程：
/// 1. main() 是 Dart 程序的入口点，由 Flutter 引擎调用
/// 2. 执行必要的初始化（通过 bootstrap）
/// 3. 调用 runApp() 将 Widget 树挂载到屏幕上
void main() {
  // bootstrap() 是自定义的启动逻辑，负责：
  // - 初始化本地存储
  // - 恢复用户登录状态
  // - 设置全局错误处理
  // bootstrap 接受一个回调，在初始化完成后执行
  bootstrap(
    // 回调参数是 ProviderContainer（Riverpod 的状态容器）
    (container) => runApp(
      // ─────────────────────────────────────────────────────────────
      // UncontrolledProviderScope - Riverpod 的 Widget
      // ─────────────────────────────────────────────────────────────
      // 作用：将 ProviderContainer 注入到 Widget 树中
      //
      // 为什么叫 "Uncontrolled"？
      // - 普通 ProviderScope 会内部创建和管理一个 ProviderContainer
      // - UncontrolledProviderScope 接收外部创建的 container，不自建
      //
      // 这样做的好处：
      // - bootstrap() 中创建的 container 可以在 runApp 之前使用
      // - 方便在启动前初始化依赖、恢复登录状态等
      //
      // child: const AppRoot() - 子 Widget，即整个应用的根
      // const 关键字表示这是一个编译时常量，Flutter 会优化重建
      UncontrolledProviderScope(container: container, child: const AppRoot()),
    ),
  );
}
