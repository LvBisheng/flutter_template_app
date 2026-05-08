import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/env/app_env.dart';
import '../../../app/env/env_config.dart';
import '../../storage/local_storage.dart';
import 'mock_rule.dart';

/// 接口 Mock 的运行时配置。
///
/// 注意：Mock 是“接口覆盖能力”，不是环境。用户可以在 sit/uat 等真实环境下
/// 只 mock 某几个接口，其余接口仍然走当前 baseUrl。prd 环境会强制禁用。
class MockConfig {
  const MockConfig({
    required this.masterEnabled,
    required this.enabledRuleIds,
    required this.availableRules,
  });

  final bool masterEnabled;
  final Set<String> enabledRuleIds;
  final List<MockRule> availableRules;

  List<MockRule> get enabledRules => [
    for (final rule in availableRules)
      if (enabledRuleIds.contains(rule.id)) rule,
  ];

  bool isRuleEnabled(String id) => masterEnabled && enabledRuleIds.contains(id);

  MockConfig copyWith({bool? masterEnabled, Set<String>? enabledRuleIds}) {
    return MockConfig(
      masterEnabled: masterEnabled ?? this.masterEnabled,
      enabledRuleIds: enabledRuleIds ?? this.enabledRuleIds,
      availableRules: availableRules,
    );
  }
}

final mockConfigProvider = NotifierProvider<MockConfigController, MockConfig>(
  MockConfigController.new,
);

class MockConfigController extends Notifier<MockConfig> {
  static const _masterKey = 'mock_master_enabled';
  static const _rulesKey = 'mock_enabled_rule_ids';

  @override
  MockConfig build() {
    final env = ref.watch(envConfigProvider);
    // prd 和生产锁定包都不允许 mock，避免测试数据或假流程进入生产验证链路。
    if (!env.switchEnabled || kReleaseMode || env.env == AppEnv.prd) {
      return MockConfig(
        masterEnabled: false,
        enabledRuleIds: const {},
        availableRules: MockRuleRegistry.rules,
      );
    }
    final storedRules = LocalStorage.getStringList(_rulesKey);
    return MockConfig(
      masterEnabled: LocalStorage.getBool(_masterKey) ?? true,
      enabledRuleIds: storedRules?.toSet() ?? _defaultRuleIds(),
      availableRules: MockRuleRegistry.rules,
    );
  }

  Future<void> setMasterEnabled(bool enabled) async {
    // 即使 UI 没有禁用，Controller 仍然做一次保护，避免外部误调用。
    if (ref.read(envConfigProvider).env == AppEnv.prd) return;
    state = state.copyWith(masterEnabled: enabled);
    await LocalStorage.setBool(_masterKey, enabled);
  }

  Future<void> setRuleEnabled(String ruleId, bool enabled) async {
    // 单接口规则同样不能在 prd 下被开启。
    if (ref.read(envConfigProvider).env == AppEnv.prd) return;
    final next = {...state.enabledRuleIds};
    if (enabled) {
      next.add(ruleId);
    } else {
      next.remove(ruleId);
    }
    state = state.copyWith(enabledRuleIds: next);
    await LocalStorage.setStringList(_rulesKey, next.toList()..sort());
  }

  Future<void> enableDefaultRules() async {
    if (ref.read(envConfigProvider).env == AppEnv.prd) return;
    final defaults = _defaultRuleIds();
    state = state.copyWith(masterEnabled: true, enabledRuleIds: defaults);
    await LocalStorage.setBool(_masterKey, true);
    await LocalStorage.setStringList(_rulesKey, defaults.toList()..sort());
  }

  static Set<String> _defaultRuleIds() => {
    for (final rule in MockRuleRegistry.rules)
      if (rule.defaultEnabled) rule.id,
  };
}
