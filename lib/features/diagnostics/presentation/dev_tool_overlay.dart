import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/env/app_env.dart';
import '../../../app/env/env_config.dart';
import '../../../app/router/app_router.dart';
import '../../../capabilities/auth/session_manager.dart';
import '../../../core/logging/app_logger.dart';
import '../../../core/network/mock/mock_config.dart';
import '../../../shared/extensions/context_ext.dart';
import '../../../shared/utils/string_utils.dart';
import 'log_console_page.dart';
import 'mock_tool_page.dart';
import 'runtime_error_controller.dart';
import 'runtime_error_page.dart';

/// ─────────────────────────────────────────────────────────────────────
/// 全局开发工具悬浮面板。
/// ─────────────────────────────────────────────────────────────────────
///
/// 【职责】
/// 提供全局开发调试工具入口，包括：
/// - 环境切换
/// - Mock 规则管理
/// - 日志查看
/// - 运行时错误查看
/// - 用户信息查看
///
/// 【架构位置】
/// 该 Overlay 放在 MaterialApp.builder 层级，和 Navigator 是兄弟节点，
/// 不是 Navigator 的子节点。因此面板本身用 Stack 内部状态展示，
/// 进入日志页时再通过 rootNavigatorKey 跳转，避免依赖错误的 BuildContext。
///
/// 【显示条件】
/// 仅在开发模式（isDevMode=true）下显示，生产包自动隐藏。
///
/// 【交互方式】
/// - 点击右下角悬浮按钮打开面板
/// - 点击面板外部关闭面板
/// - 运行时错误发生时自动弹出提示
///
class DevToolOverlay extends ConsumerStatefulWidget {
  const DevToolOverlay({super.key, required this.child});

  /// 子组件（通常是整个 App）。
  final Widget child;

  @override
  ConsumerState<DevToolOverlay> createState() => _DevToolOverlayState();
}

class _DevToolOverlayState extends ConsumerState<DevToolOverlay> {
  /// 面板是否可见。
  bool _panelVisible = false;

  /// 运行时错误弹窗是否可见（防止重复弹窗）。
  bool _runtimeErrorDialogVisible = false;

  /// 已显示过的错误 ID（避免同一错误重复弹窗）。
  int? _shownRuntimeErrorId;

  /// 悬浮按钮位置（距右边缘）。
  double _buttonRight = 16;

  /// 悬浮按钮位置（距底边缘）。
  double _buttonBottom = 84;

  @override
  Widget build(BuildContext context) {
    final env = ref.watch(envConfigProvider);

    // 监听运行时错误，发生时弹出提示
    ref.listen(runtimeErrorControllerProvider.select((state) => state.latest), (
      previous,
      next,
    ) {
      // 非开发模式不显示运行时错误弹窗
      if (next == null ||
          _shownRuntimeErrorId == next.id ||
          !env.isDevMode) {
        return;
      }
      _shownRuntimeErrorId = next.id;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;
        if (_runtimeErrorDialogVisible) return;
        final navigatorContext = rootNavigatorKey.currentContext;
        if (navigatorContext == null) return;
        _runtimeErrorDialogVisible = true;
        showDialog<void>(
          context: navigatorContext,
          builder: (_) => RuntimeErrorSnackDialog(report: next),
        ).whenComplete(() => _runtimeErrorDialogVisible = false);
      });
    });

    // 非开发模式不显示开发工具
    if (!env.isDevMode) return widget.child;

    return Stack(
      children: [
        // 原始内容（整个 App）
        widget.child,

        // ───────────────────────────────────────────────────────────────
        // 开发工具面板（遮罩 + 面板内容）
        // ───────────────────────────────────────────────────────────────
        if (_panelVisible)
          Positioned.fill(
            child: GestureDetector(
              // 点击遮罩关闭面板
              onTap: () => setState(() => _panelVisible = false),
              child: ColoredBox(
                // 半透明遮罩
                color: Colors.black.withValues(alpha: 0.18),
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: GestureDetector(
                    // 阻止点击面板内部时关闭
                    onTap: () {},
                    child: _DevToolPanel(
                      onClose: () => setState(() => _panelVisible = false),
                    ),
                  ),
                ),
              ),
            ),
          ),

        // ───────────────────────────────────────────────────────────────
        // 悬浮按钮（可拖动，打开开发工具面板）
        // ───────────────────────────────────────────────────────────────
        Positioned(
          right: _buttonRight,
          bottom: _buttonBottom,
          child: GestureDetector(
            // 拖动处理
            onPanUpdate: (details) {
              setState(() {
                // 更新位置（限制在屏幕范围内）
                final screenSize = MediaQuery.of(context).size;
                _buttonRight = (_buttonRight - details.delta.dx)
                    .clamp(0.0, screenSize.width - 64);
                _buttonBottom = (_buttonBottom - details.delta.dy)
                    .clamp(0.0, screenSize.height - 64);
              });
            },
            // 拖动结束后吸附到屏幕边缘
            onPanEnd: (details) {
              setState(() {
                _buttonRight = _buttonRight < MediaQuery.of(context).size.width / 2
                    ? 16.0  // 吸附到左边
                    : 16.0; // 吸附到右边（保持初始位置）
              });
            },
            child: SafeArea(
              child: Material(
                color: Theme.of(context).colorScheme.primary,
                shape: const CircleBorder(),
                elevation: 6,
                clipBehavior: Clip.antiAlias,
                child: InkWell(
                  onTap: () {
                    appLogger.i('Open global dev tool panel');
                    setState(() => _panelVisible = true);
                  },
                  child: const SizedBox(
                    width: 48,
                    height: 48,
                    child: Icon(Icons.construction, color: Colors.white),
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

/// ─────────────────────────────────────────────────────────────────────
/// 开发工具面板内容。
/// ─────────────────────────────────────────────────────────────────────
///
/// 【功能列表】
/// - 显示当前环境信息
/// - 环境切换
/// - Mock 规则管理入口
/// - 日志查看入口
/// - 运行时错误查看入口
/// - 用户信息查看
///
class _DevToolPanel extends ConsumerWidget {
  const _DevToolPanel({required this.onClose});

  /// 关闭面板回调。
  final VoidCallback onClose;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final env = ref.watch(envConfigProvider);
    final mock = ref.watch(mockConfigProvider);
    final auth = ref.watch(sessionManagerProvider);
    final runtimeErrors = ref.watch(runtimeErrorControllerProvider);
    final mockAllowed = env.isDevMode;
    final l10n = context.l10n;

    return Material(
      color: Theme.of(context).colorScheme.surface,
      borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
      clipBehavior: Clip.antiAlias,
      child: SafeArea(
        top: false,
        child: ConstrainedBox(
          // 限制最大高度，防止内容过长
          constraints: const BoxConstraints(maxHeight: 620),
          child: ListView(
            shrinkWrap: true,
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
            children: [
              // ─────────────────────────────────────────────────────────
              // 拖拽指示器
              // ─────────────────────────────────────────────────────────
              Center(
                child: Container(
                  width: 36,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade400,
                    borderRadius: BorderRadius.circular(99),
                  ),
                ),
              ),
              const SizedBox(height: 12),

              // ─────────────────────────────────────────────────────────
              // 标题栏
              // ─────────────────────────────────────────────────────────
              Row(
                children: [
                  const Icon(Icons.construction),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      l10n.devToolTitle,
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                  ),
                  IconButton(onPressed: onClose, icon: const Icon(Icons.close)),
                ],
              ),
              const SizedBox(height: 12),

              // ─────────────────────────────────────────────────────────
              // 当前环境信息卡片
              // ─────────────────────────────────────────────────────────
              _InfoCard(
                title: l10n.devToolCurrentNetwork,
                lines: [
                  l10n.devToolEnvLine(env.env.name),
                  'Base URL：${env.baseUrl}',
                  l10n.devToolMockMasterLine(
                    mockAllowed
                        ? (mock.masterEnabled
                              ? l10n.devToolMockOn
                              : l10n.devToolMockOff)
                        : l10n.devToolMockPrdDisabled,
                  ),
                  l10n.devToolMockedApiCountLine(mock.enabledRules.length),
                ],
              ),
              const SizedBox(height: 12),

              // ─────────────────────────────────────────────────────────
              // 环境切换选择器
              // ─────────────────────────────────────────────────────────
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  for (final option in AppEnv.values)
                    ChoiceChip(
                      label: Text(option.name),
                      selected: env.env == option,
                      onSelected: (_) {
                        ref.read(envConfigProvider.notifier).selectEnv(option);
                        appLogger.i(
                          'Runtime environment changed: ${option.name}',
                        );
                      },
                    ),
                ],
              ),

              // ─────────────────────────────────────────────────────────
              // 功能入口列表
              // ─────────────────────────────────────────────────────────
              ListTile(
                leading: const Icon(Icons.rule_folder_outlined),
                title: Text(l10n.devToolMockRules),
                subtitle: Text(
                  mock.enabledRules.isEmpty
                      ? l10n.devToolNoMockedApi
                      : l10n.devToolMockedApiCountLine(
                          mock.enabledRules.length,
                        ),
                ),
                trailing: const Icon(Icons.chevron_right),
                onTap: () {
                  onClose();
                  rootNavigatorKey.currentState?.push(
                    MaterialPageRoute<void>(
                      builder: (_) => const MockToolPage(),
                    ),
                  );
                },
              ),
              const Divider(height: 24),
              ListTile(
                leading: const Icon(Icons.receipt_long_outlined),
                title: Text(l10n.devToolViewLogs),
                subtitle: Text(l10n.devToolLogCount(appTalker.history.length)),
                onTap: () {
                  onClose();
                  rootNavigatorKey.currentState?.push(
                    MaterialPageRoute<void>(
                      builder: (_) => const LogConsolePage(),
                    ),
                  );
                },
              ),
              ListTile(
                leading: const Icon(Icons.bug_report_outlined),
                title: Text(l10n.runtimeErrorTitle),
                subtitle: Text(
                  l10n.runtimeErrorCount(runtimeErrors.reports.length),
                ),
                onTap: () {
                  onClose();
                  rootNavigatorKey.currentState?.push(
                    MaterialPageRoute<void>(
                      builder: (_) => const RuntimeErrorListPage(),
                    ),
                  );
                },
              ),
              ListTile(
                leading: const Icon(Icons.cleaning_services_outlined),
                title: Text(l10n.devToolClearLogs),
                onTap: () {
                  appTalker.cleanHistory();
                  appLogger.i('Diagnostics log history cleaned from dev panel');
                  onClose();
                },
              ),
              ListTile(
                leading: const Icon(Icons.person_search_outlined),
                title: Text(l10n.devToolCurrentUser),
                subtitle: Text(
                  auth.isLoggedIn
                      ? '${auth.userName ?? '-'} / ${StringUtils.maskToken(auth.token ?? '')}'
                      : l10n.meNotLoggedIn,
                ),
              ),
              const Divider(height: 24),

              // ─────────────────────────────────────────────────────────
              // 调试工具
              // ─────────────────────────────────────────────────────────
              ListTile(
                leading: const Icon(Icons.extension_outlined),
                title: Text(l10n.devToolMockTools),
                subtitle: Text(l10n.devToolMockToolsSubtitle),
                onTap: () {
                  appLogger.i('Mock tools placeholder tapped');
                },
              ),
              ListTile(
                leading: const Icon(Icons.warning_amber_outlined),
                title: Text(l10n.runtimeErrorTriggerTest),
                subtitle: Text(l10n.runtimeErrorTriggerTestSubtitle),
                onTap: () {
                  // 触发一个测试错误，用于验证错误捕获功能
                  Future<void>.microtask(() {
                    throw StateError('Manual runtime error from dev panel');
                  });
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// ─────────────────────────────────────────────────────────────────────
/// 信息展示卡片。
/// ─────────────────────────────────────────────────────────────────────
///
/// 用于显示多行信息的卡片组件。
///
class _InfoCard extends StatelessWidget {
  const _InfoCard({required this.title, required this.lines});

  /// 卡片标题。
  final String title;

  /// 信息行列表。
  final List<String> lines;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: Theme.of(context).textTheme.titleSmall),
            const SizedBox(height: 8),
            for (final line in lines)
              Padding(
                padding: const EdgeInsets.only(top: 3),
                child: Text(line, style: Theme.of(context).textTheme.bodySmall),
              ),
          ],
        ),
      ),
    );
  }
}
