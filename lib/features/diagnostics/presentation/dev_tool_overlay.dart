import 'package:flutter/foundation.dart';
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

/// 非生产包的全局开发工具入口。
///
/// 该 Overlay 放在 MaterialApp.builder 层级，和 Navigator 是兄弟节点，不是
/// Navigator 的子节点。因此面板本身用 Stack 内部状态展示，进入日志页时再通过
/// rootNavigatorKey 跳转，避免依赖错误的 BuildContext。
class DevToolOverlay extends ConsumerStatefulWidget {
  const DevToolOverlay({super.key, required this.child});

  final Widget child;

  @override
  ConsumerState<DevToolOverlay> createState() => _DevToolOverlayState();
}

class _DevToolOverlayState extends ConsumerState<DevToolOverlay> {
  bool _panelVisible = false;
  bool _runtimeErrorDialogVisible = false;
  int? _shownRuntimeErrorId;

  @override
  Widget build(BuildContext context) {
    final env = ref.watch(envConfigProvider);
    ref.listen(runtimeErrorControllerProvider.select((state) => state.latest), (
      previous,
      next,
    ) {
      if (next == null ||
          _shownRuntimeErrorId == next.id ||
          !env.switchEnabled ||
          kReleaseMode) {
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
    if (!env.switchEnabled) return widget.child;

    return Stack(
      children: [
        widget.child,
        if (_panelVisible)
          Positioned.fill(
            child: GestureDetector(
              onTap: () => setState(() => _panelVisible = false),
              child: ColoredBox(
                color: Colors.black.withValues(alpha: 0.18),
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: GestureDetector(
                    onTap: () {},
                    child: _DevToolPanel(
                      onClose: () => setState(() => _panelVisible = false),
                    ),
                  ),
                ),
              ),
            ),
          ),
        Positioned(
          right: 16,
          bottom: 84,
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
      ],
    );
  }
}

class _DevToolPanel extends ConsumerWidget {
  const _DevToolPanel({required this.onClose});

  final VoidCallback onClose;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final env = ref.watch(envConfigProvider);
    final mock = ref.watch(mockConfigProvider);
    final auth = ref.watch(sessionManagerProvider);
    final runtimeErrors = ref.watch(runtimeErrorControllerProvider);
    final mockAllowed = env.env != AppEnv.prd;
    final l10n = context.l10n;

    return Material(
      color: Theme.of(context).colorScheme.surface,
      borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
      clipBehavior: Clip.antiAlias,
      child: SafeArea(
        top: false,
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxHeight: 620),
          child: ListView(
            shrinkWrap: true,
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
            children: [
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
                      : l10n.settingsNotLoggedIn,
                ),
              ),
              ListTile(
                leading: const Icon(Icons.delete_outline),
                title: Text(l10n.settingsClearToken),
                enabled: auth.isLoggedIn,
                onTap: auth.isLoggedIn
                    ? () async {
                        await ref
                            .read(sessionManagerProvider.notifier)
                            .clearToken();
                        appLogger.w('Token cleared from dev panel');
                        onClose();
                      }
                    : null,
              ),
              const Divider(height: 24),
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

class _InfoCard extends StatelessWidget {
  const _InfoCard({required this.title, required this.lines});

  final String title;
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
