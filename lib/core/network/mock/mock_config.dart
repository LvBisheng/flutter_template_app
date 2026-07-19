import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/env/env_config.dart';
import '../../storage/local_storage.dart';
import 'mock_rule.dart';

/// ─────────────────────────────────────────────────────────────────────
/// Mock 配置。
/// ─────────────────────────────────────────────────────────────────────
///
/// 【设计说明】
/// Mock 是”接口覆盖能力”，不是环境：
/// - 用户可以在 sit/uat 等真实环境下
/// - 只 mock 某几个接口，其余接口仍然走当前 baseUrl
/// - prd 环境会强制禁用
///
/// 【字段说明】
/// - [masterEnabled]：Mock 总开关
/// - [enabledRuleIds]：已启用的规则 ID 集合
/// - [availableRules]：所有可用规则列表
///
class MockConfig {
  const MockConfig({
    required this.masterEnabled,
    required this.enabledRuleIds,
    required this.availableRules,
  });

  final bool masterEnabled;
  final Set<String> enabledRuleIds;
  final List<MockRule> availableRules;

  /// 获取已启用的规则列表。
  List<MockRule> get enabledRules => [
    for (final rule in availableRules)
      if (enabledRuleIds.contains(rule.id)) rule,
  ];

  /// 检查指定规则是否启用。
  bool isRuleEnabled(String id) => masterEnabled && enabledRuleIds.contains(id);

  MockConfig copyWith({bool? masterEnabled, Set<String>? enabledRuleIds}) {
    return MockConfig(
      masterEnabled: masterEnabled ?? this.masterEnabled,
      enabledRuleIds: enabledRuleIds ?? this.enabledRuleIds,
      availableRules: availableRules,
    );
  }
}

/// MockConfig Provider。
final mockConfigProvider = NotifierProvider<MockConfigController, MockConfig>(
  MockConfigController.new,
);

/// ─────────────────────────────────────────────────────────────────────
/// Mock 配置 Controller。
/// ─────────────────────────────────────────────────────────────────────
///
/// 【职责】
/// 管理 Mock 配置的状态持久化。
///
/// 【存储】
/// - 总开关：LocalStorage 'mock_master_enabled'
/// - 规则列表：LocalStorage 'mock_enabled_rule_ids'
///
/// 【安全保护】
/// - Release 包强制禁用
/// - PRD 环境强制禁用
/// - 所有修改方法都做二次校验
///
class MockConfigController extends Notifier<MockConfig> {
  static const _masterKey = 'mock_master_enabled';
  static const _rulesKey = 'mock_enabled_rule_ids';

  @override
  MockConfig build() {
    final env = ref.watch(envConfigProvider);

    // 非开发模式强制禁用 Mock，避免测试数据进入生产环境
    if (!env.isDevMode) {
      return MockConfig(
        masterEnabled: false,
        enabledRuleIds: const {},
        availableRules: MockRuleRegistry.rules,
      );
    }

    // 从本地存储恢复配置
    final storedRules = LocalStorage.getStringList(_rulesKey);
    return MockConfig(
      masterEnabled: LocalStorage.getBool(_masterKey) ?? true,
      enabledRuleIds: storedRules?.toSet() ?? _defaultRuleIds(),
      availableRules: MockRuleRegistry.rules,
    );
  }

  /// 设置 Mock 总开关。
  ///
  /// 【安全】
  /// 非开发模式不允许开启。
  Future<void> setMasterEnabled(bool enabled) async {
    if (!ref.read(envConfigProvider).isDevMode) return;
    state = state.copyWith(masterEnabled: enabled);
    await LocalStorage.setBool(_masterKey, enabled);
  }

  /// 设置单个规则的开关。
  ///
  /// 【安全】
  /// 非开发模式不允许开启任何规则。
  Future<void> setRuleEnabled(String ruleId, bool enabled) async {
    if (!ref.read(envConfigProvider).isDevMode) return;

    final next = {...state.enabledRuleIds};
    if (enabled) {
      next.add(ruleId);
    } else {
      next.remove(ruleId);
    }
    state = state.copyWith(enabledRuleIds: next);
    await LocalStorage.setStringList(_rulesKey, next.toList()..sort());
  }

  /// 启用默认规则（重置为初始状态）。
  Future<void> enableDefaultRules() async {
    if (!ref.read(envConfigProvider).isDevMode) return;

    final defaults = _defaultRuleIds();
    state = state.copyWith(masterEnabled: true, enabledRuleIds: defaults);
    await LocalStorage.setBool(_masterKey, true);
    await LocalStorage.setStringList(_rulesKey, defaults.toList()..sort());
  }

  /// 获取默认启用的规则 ID。
  static Set<String> _defaultRuleIds() => {
    for (final rule in MockRuleRegistry.rules)
      if (rule.defaultEnabled) rule.id,
  };
}
