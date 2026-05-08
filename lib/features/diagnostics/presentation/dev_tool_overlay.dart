import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/env/app_env.dart';
import '../../../app/env/env_config.dart';
import '../../../app/router/app_router.dart';
import '../../../capabilities/auth/session_manager.dart';
import '../../../core/logging/app_logger.dart';
import '../../../core/network/mock/mock_config.dart';
import '../../../shared/utils/string_utils.dart';
import 'log_console_page.dart';

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

  @override
  Widget build(BuildContext context) {
    final env = ref.watch(envConfigProvider);
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
    final mockAllowed = env.env != AppEnv.prd;

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
                      '开发工具',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                  ),
                  IconButton(onPressed: onClose, icon: const Icon(Icons.close)),
                ],
              ),
              const SizedBox(height: 12),
              _InfoCard(
                title: '当前网络',
                lines: [
                  '环境：${env.env.name}',
                  'Base URL：${env.baseUrl}',
                  'Mock 总开关：${mockAllowed ? (mock.masterEnabled ? '开启' : '关闭') : 'prd 禁用'}',
                  '已 Mock 接口：${mock.enabledRules.length} 个',
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
              SwitchListTile(
                contentPadding: EdgeInsets.zero,
                title: const Text('接口 Mock 总开关'),
                subtitle: Text(
                  mockAllowed ? '开启后，只拦截下方启用的接口' : 'prd 环境不允许接口 Mock',
                ),
                value: mock.masterEnabled,
                onChanged: mockAllowed
                    ? (enabled) {
                        ref
                            .read(mockConfigProvider.notifier)
                            .setMasterEnabled(enabled);
                        appLogger.i('Mock master switch changed: $enabled');
                      }
                    : null,
              ),
              ExpansionTile(
                tilePadding: EdgeInsets.zero,
                leading: const Icon(Icons.rule_folder_outlined),
                title: const Text('接口 Mock 规则'),
                subtitle: Text(
                  mock.enabledRules.isEmpty
                      ? '当前没有接口被 mock'
                      : mock.enabledRules
                            .map((rule) => rule.routeKey)
                            .join('\n'),
                ),
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: TextButton.icon(
                      onPressed: mockAllowed
                          ? () => ref
                                .read(mockConfigProvider.notifier)
                                .enableDefaultRules()
                          : null,
                      icon: const Icon(Icons.restore),
                      label: const Text('恢复默认 Mock 规则'),
                    ),
                  ),
                  for (final rule in mock.availableRules)
                    SwitchListTile(
                      contentPadding: EdgeInsets.zero,
                      title: Text('${rule.method} ${rule.path}'),
                      subtitle: Text('${rule.name}：${rule.description}'),
                      value: mock.enabledRuleIds.contains(rule.id),
                      onChanged: mockAllowed && mock.masterEnabled
                          ? (enabled) => ref
                                .read(mockConfigProvider.notifier)
                                .setRuleEnabled(rule.id, enabled)
                          : null,
                    ),
                ],
              ),
              const Divider(height: 24),
              ListTile(
                leading: const Icon(Icons.receipt_long_outlined),
                title: const Text('查看日志'),
                subtitle: Text('当前 ${appTalker.history.length} 条'),
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
                leading: const Icon(Icons.cleaning_services_outlined),
                title: const Text('清空日志'),
                onTap: () {
                  appTalker.cleanHistory();
                  appLogger.i('Diagnostics log history cleaned from dev panel');
                  onClose();
                },
              ),
              ListTile(
                leading: const Icon(Icons.person_search_outlined),
                title: const Text('当前登录用户'),
                subtitle: Text(
                  auth.isLoggedIn
                      ? '${auth.userName ?? '-'} / ${StringUtils.maskToken(auth.token ?? '')}'
                      : '未登录',
                ),
              ),
              ListTile(
                leading: const Icon(Icons.delete_outline),
                title: const Text('清除 Token'),
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
                title: const Text('Mock 工具'),
                subtitle: const Text('预留入口：接口错误注入、假数据场景、功能开关'),
                onTap: () {
                  appLogger.i('Mock tools placeholder tapped');
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
