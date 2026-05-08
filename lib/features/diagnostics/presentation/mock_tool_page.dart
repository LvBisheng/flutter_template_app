import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/env/app_env.dart';
import '../../../app/env/env_config.dart';
import '../../../core/logging/app_logger.dart';
import '../../../core/network/mock/mock_config.dart';
import '../../../shared/extensions/context_ext.dart';

class MockToolPage extends ConsumerWidget {
  const MockToolPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final env = ref.watch(envConfigProvider);
    final mock = ref.watch(mockConfigProvider);
    final mockAllowed = env.env != AppEnv.prd;
    final l10n = context.l10n;

    return Scaffold(
      appBar: AppBar(title: Text(l10n.mockToolTitle)),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    l10n.devToolCurrentNetwork,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 8),
                  Text(l10n.devToolEnvLine(env.env.name)),
                  Text('Base URL：${env.baseUrl}'),
                  Text(
                    l10n.devToolMockedApiCountLine(mock.enabledRules.length),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),
          SwitchListTile(
            contentPadding: EdgeInsets.zero,
            title: Text(l10n.devToolMockMasterSwitch),
            subtitle: Text(
              mockAllowed
                  ? l10n.devToolMockMasterEnabledHint
                  : l10n.devToolMockMasterPrdHint,
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
          Align(
            alignment: Alignment.centerLeft,
            child: TextButton.icon(
              onPressed: mockAllowed
                  ? () => ref
                        .read(mockConfigProvider.notifier)
                        .enableDefaultRules()
                  : null,
              icon: const Icon(Icons.restore),
              label: Text(l10n.devToolRestoreDefaultRules),
            ),
          ),
          const Divider(height: 28),
          Text(
            l10n.devToolMockRules,
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 8),
          for (final rule in mock.availableRules)
            Card(
              child: SwitchListTile(
                title: Text('${rule.method} ${rule.path}'),
                subtitle: Text('${rule.name}：${rule.description}'),
                value: mock.enabledRuleIds.contains(rule.id),
                onChanged: mockAllowed && mock.masterEnabled
                    ? (enabled) => ref
                          .read(mockConfigProvider.notifier)
                          .setRuleEnabled(rule.id, enabled)
                    : null,
              ),
            ),
        ],
      ),
    );
  }
}
