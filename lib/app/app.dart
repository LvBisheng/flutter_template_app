import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:talker_flutter/talker_flutter.dart';

import '../core/logging/app_logger.dart';
import '../features/diagnostics/presentation/dev_tool_overlay.dart';
import '../shared/ui/screen/screen.dart';
import 'l10n/app_locale_controller.dart';
import 'l10n/generated/app_localizations.dart';
import 'router/app_router.dart';
import 'theme/app_theme.dart';
import 'theme/app_theme_controller.dart';

/// 应用根 Widget。
///
/// ─────────────────────────────────────────────────────────────────────
/// 关键 Flutter 概念：
/// ─────────────────────────────────────────────────────────────────────
///
/// 1. ConsumerWidget vs StatelessWidget
///    - StatelessWidget：普通的不可变 Widget
///    - ConsumerWidget：Riverpod 提供的 Widget，可以监听 Provider 状态变化
///    - 区别：build() 方法多了一个 WidgetRef 参数
///
/// 2. WidgetRef 的作用
///    - ref.watch(provider)：监听状态，状态变化时自动重建 Widget
///    - ref.read(provider)：只读取一次，不触发重建
///    - ref.listen(provider, callback)：监听变化并执行副作用（如显示 SnackBar）
///
/// 3. MaterialApp.router
///    - MaterialApp：Flutter Material Design 应用的根 Widget
///    - .router：使用声明式路由（GoRouter）而不是命令式导航
///
/// 4. ScreenInit - 屏幕适配初始化
///    - 包裹在 MaterialApp 外层，确保所有 Widget 都能使用 .w/.h/.sp 适配
///    - 设计稿基准尺寸通过 ScreenConfig 配置
class AppRoot extends ConsumerWidget {
  // ─────────────────────────────────────────────────────────────
  // const 构造函数
  // ─────────────────────────────────────────────────────────────
  // const 表示这个 Widget 是编译时常量
  // Flutter 会对 const Widget 做优化：只创建一次实例，复用
  // super.key 用于 Flutter 在 Widget 树中识别和比较 Widget
  const AppRoot({super.key});

  @override
  // ─────────────────────────────────────────────────────────────
  // build 方法
  // ─────────────────────────────────────────────────────────────
  // WidgetRef ref 是 ConsumerWidget 特有的参数
  // 用于访问 Riverpod 的状态管理功能
  Widget build(BuildContext context, WidgetRef ref) {
    // ─────────────────────────────────────────────────────────────
    // ref.watch - 监听 Provider 状态
    // ─────────────────────────────────────────────────────────────
    // 当 appRouterProvider 的状态变化时，整个 build 方法会重新执行
    // 这样可以响应式地更新路由配置（例如登录状态变化后重定向）
    final router = ref.watch(appRouterProvider);

    // 监听语言设置变化，实现国际化切换
    final locale = ref.watch(appLocaleControllerProvider);

    // 监听主题设置变化，实现深色模式切换
    final themeOption = ref.watch(themeControllerProvider);

    // ─────────────────────────────────────────────────────────────
    // ScreenInit - 屏幕适配初始化
    // ─────────────────────────────────────────────────────────────
    // 使用默认配置：375 × 812（iPhone X 标准尺寸）
    // 如需自定义设计稿尺寸，修改 designWidth/designHeight：
    //   ScreenInit(designWidth: 750, designHeight: 1334, child: ...)
    // 或在 ScreenConfig 中全局配置：
    //   ScreenConfig.update(designWidth: 750, designHeight: 1334);
    // ─────────────────────────────────────────────────────────────
    // ScreenInit - 屏幕适配初始化
    // ─────────────────────────────────────────────────────────────
    // 使用默认配置：375 × 812（iPhone X 标准尺寸）
    // 如需自定义设计稿尺寸，修改 designWidth/designHeight：
    //   ScreenInit(designWidth: 750, designHeight: 1334, child: ...)
    // 或在 ScreenConfig 中全局配置：
    //   ScreenConfig.update(designWidth: 750, designHeight: 1334);
    return ScreenInit(
      child: TalkerWrapper(
        talker: appTalker,
        options: const TalkerWrapperOptions(
          // 异常时弹出警告对话框（如网络错误、空指针等）
          enableExceptionAlerts: true,
          // FlutterError（框架错误）不弹窗，只记录日志
          enableErrorAlerts: true,
        ),
        child: MaterialApp.router(
          onGenerateTitle: (context) => AppLocalizations.of(context).appTitle,
          debugShowCheckedModeBanner: true,
          theme: AppTheme.light(),
          darkTheme: AppTheme.dark(),
          themeMode: themeOption.toThemeMode(),
          locale: locale.locale,
          supportedLocales: AppLocalizations.supportedLocales,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          routerConfig: router,
          builder: (context, child) =>
              DevToolOverlay(child: child ?? const SizedBox.shrink()),
        ),
      ),
    );
  }
}
