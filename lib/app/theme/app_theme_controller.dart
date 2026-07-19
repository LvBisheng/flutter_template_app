import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/storage/local_storage.dart';

/// ─────────────────────────────────────────────────────────────────────
/// 主题模式选项。
/// ─────────────────────────────────────────────────────────────────────
///
/// 支持三种模式：
/// - light：普通模式（浅色）
/// - dark：深色模式
/// - system：跟随系统
enum ThemeOption {
  light('普通模式'),
  dark('深色模式'),
  system('跟随系统');

  final String label;
  const ThemeOption(this.label);

  /// 存储值（用于持久化）。
  String get storageValue => name;

  /// 从存储值解析。
  static ThemeOption fromStorage(String? value) {
    return switch (value) {
      'light' => ThemeOption.light,
      'dark' => ThemeOption.dark,
      'system' => ThemeOption.system,
      _ => ThemeOption.light, // 默认普通模式
    };
  }

  /// 转换为 Flutter ThemeMode。
  ThemeMode toThemeMode() {
    return switch (this) {
      ThemeOption.light => ThemeMode.light,
      ThemeOption.dark => ThemeMode.dark,
      ThemeOption.system => ThemeMode.system,
    };
  }
}

// ═══════════════════════════════════════════════════════════════════════
// 存储键
// ═══════════════════════════════════════════════════════════════════════

const _themeOptionStorageKey = 'app.theme.option';

// ═══════════════════════════════════════════════════════════════════════
// Provider
// ═══════════════════════════════════════════════════════════════════════

/// 主题状态管理 Provider。
///
/// 【使用方式】
/// ```dart
/// // 监听当前主题
/// final theme = ref.watch(themeControllerProvider);
///
/// // 切换主题
/// ref.read(themeControllerProvider.notifier).select(ThemeOption.dark);
/// ```
final themeControllerProvider = NotifierProvider<AppThemeController, ThemeOption>(
  AppThemeController.new,
);

/// ─────────────────────────────────────────────────────────────────────
/// AppThemeController - 主题状态管理。
/// ─────────────────────────────────────────────────────────────────────
///
/// 【职责】
/// - 管理应用主题模式（浅色/深色/跟随系统）
/// - 持久化用户选择到 LocalStorage
/// - 应用启动时恢复用户设置
///
/// 【参考实现】
/// 参考 AppLocaleController 的实现模式
class AppThemeController extends Notifier<ThemeOption> {
  @override
  ThemeOption build() {
    // 从 LocalStorage 恢复用户设置
    return ThemeOption.fromStorage(
      LocalStorage.getString(_themeOptionStorageKey),
    );
  }

  /// 选择主题模式。
  ///
  /// 【流程】
  /// 1. 更新状态（触发 UI 重建）
  /// 2. 持久化到 LocalStorage
  Future<void> select(ThemeOption option) async {
    state = option;
    await LocalStorage.setString(_themeOptionStorageKey, option.storageValue);
  }
}
