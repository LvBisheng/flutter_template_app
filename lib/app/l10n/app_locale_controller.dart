import 'dart:ui';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/storage/local_storage.dart';

/// ─────────────────────────────────────────────────────────────────────
/// 语言选项存储的 key。
/// ─────────────────────────────────────────────────────────────────────
/// 用户选择的语言会持久化到本地存储，
/// 下次启动 APP 时恢复上次选择。
const _localeOptionStorageKey = 'app.locale.option';

/// ─────────────────────────────────────────────────────────────────────
/// AppLocaleOption - 语言选项枚举。
/// ─────────────────────────────────────────────────────────────────────
///
/// 【四种语言选项】
/// - system：跟随系统（locale = null，Flutter 自动选择）
/// - zhHans：简体中文（locale = Locale('zh')）
/// - zhHant：繁体中文（locale = Locale.fromSubtags(languageCode: 'zh', scriptCode: 'Hant')）
/// - en：英文（locale = Locale('en')）
///
/// 【为什么用枚举而不是直接用 Locale？】
/// 1. 类型安全：枚举限定可选值，避免拼写错误
/// 2. 易于存储：枚举可以转为字符串存储
/// 3. 支持系统跟随：Locale 无法表示"跟随系统"
///
/// 【Locale 代码说明】
/// - zh：中文（不区分简繁）
/// - zh_Hans：简体中文（Hans = Simplified）
/// - zh_Hant：繁体中文（Hant = Traditional）
///
/// 对应的 ARB 文件：
/// - app_zh.arb → 简体中文
/// - app_zh_Hant.arb → 繁体中文
/// - app_en.arb → 英文
///
/// 【存储与恢复】
/// 用户选择的语言会保存到 SharedPreferences：
/// - system → storageValue = 'system'
/// - zhHans → storageValue = 'zh_hans'
/// - zhHant → storageValue = 'zh_hant'
/// - en → storageValue = 'en'
///
/// APP 启动时从存储读取，恢复用户选择。
enum AppLocaleOption {
  /// 跟随系统语言。
  ///
  /// locale = null，Flutter 会自动选择最匹配的语言。
  /// 例如：系统中文 → 使用 app_zh.arb 的文案
  ///       系统英文 → 使用 app_en.arb 的文案
  ///       系统其他语言 → 默认使用 template-arb-file（中文）
  system('system', null),

  /// 简体中文。
  ///
  /// locale = Locale('zh')，强制使用简体中文。
  zhHans('zh_hans', Locale('zh')),

  /// 繁体中文。
  ///
  /// 使用 Locale.fromSubtags 构造，因为脚本代码（Script）需要单独指定。
  /// - languageCode: 'zh'（中文）
  /// - scriptCode: 'Hant'（繁体脚本）
  ///
  /// 这样 Flutter 才能正确匹配到 app_zh_Hant.arb。
  zhHant('zh_hant', Locale.fromSubtags(languageCode: 'zh', scriptCode: 'Hant')),

  /// 英文。
  ///
  /// locale = Locale('en')，强制使用英文。
  en('en', Locale('en'));

  /// ─────────────────────────────────────────────────────────────────
  /// 构造函数
  /// ─────────────────────────────────────────────────────────────────
  const AppLocaleOption(this.storageValue, this.locale);

  /// 存储到本地的字符串值。
  ///
  /// 用于 SharedPreferences 持久化。
  final String storageValue;

  /// 对应的 Locale 对象。
  ///
  /// - null：表示跟随系统
  /// - 非 null：强制使用该语言
  final Locale? locale;

  /// ─────────────────────────────────────────────────────────────────
  /// 从存储值恢复语言选项。
  /// ─────────────────────────────────────────────────────────────────
  ///
  /// APP 启动时，从 SharedPreferences 读取存储的字符串，
  /// 转换回枚举值。
  ///
  /// 如果存储的值不匹配任何选项（如旧版本数据或损坏数据），
  /// 默认返回 system（跟随系统）。
  static AppLocaleOption fromStorage(String? value) {
    for (final option in values) {
      if (option.storageValue == value) return option;
    }
    // 兜底：未知值返回跟随系统
    return AppLocaleOption.system;
  }
}

/// ─────────────────────────────────────────────────────────────────────
/// AppLocaleState - 语言状态。
/// ─────────────────────────────────────────────────────────────────────
///
/// 【为什么需要单独的状态类？】
/// 1. 封装：把枚举和计算属性（locale）封装在一起
/// 2. 扩展性：未来可以添加更多属性（如地区代码）
/// 3. 不可变：状态变化时创建新实例，保证不可变性
class AppLocaleState {
  const AppLocaleState({required this.option});

  /// 用户选择的语言选项。
  final AppLocaleOption option;

  /// 获取实际的 Locale 对象。
  ///
  /// - option.locale 不为 null：返回用户选择的语言
  /// - option.locale 为 null：返回 null（MaterialApp 会使用系统语言）
  Locale? get locale => option.locale;
}

/// ─────────────────────────────────────────────────────────────────────
/// appLocaleControllerProvider - 语言控制器 Provider。
/// ─────────────────────────────────────────────────────────────────────
///
/// 【Riverpod Provider】
/// 通过 Provider 注入，实现：
/// 1. 全局单例：整个 APP 共享一个语言状态
/// 2. 响应式：语言变化时，监听的 Widget 自动重建
/// 3. 易于测试：可以替换为 mock Provider
///
/// 【使用方式】
/// ```dart
/// // 读取当前语言
/// final locale = ref.watch(appLocaleControllerProvider).locale;
///
/// // 切换语言
/// ref.read(appLocaleControllerProvider.notifier).select(AppLocaleOption.en);
/// ```
final appLocaleControllerProvider =
    NotifierProvider<AppLocaleController, AppLocaleState>(
      AppLocaleController.new,
    );

/// ─────────────────────────────────────────────────────────────────────
/// AppLocaleController - 语言控制器。
/// ─────────────────────────────────────────────────────────────────────
///
/// 【职责】
/// 1. 管理 APP 语言状态（读取、切换、持久化）
/// 2. 提供给 MaterialApp 的 locale 属性
///
/// 【工作流程】
/// 1. APP 启动 → build() 从本地存储恢复上次选择
/// 2. 用户切换语言 → select() 更新状态并持久化
/// 3. MaterialApp 监听状态 → 重建 UI 使用新语言
///
/// 【与 MaterialApp 的配合】
/// ```dart
/// MaterialApp(
///   locale: ref.watch(appLocaleControllerProvider).locale,
///   supportedLocales: AppLocalizations.supportedLocales,
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
/// );
/// ```
///
/// 当 locale 变化时，MaterialApp 会：
/// 1. 找到匹配的 AppLocalizations 实现
/// 2. 更新 context.l10n
/// 3. 重建所有使用 l10n 的 Widget
class AppLocaleController extends Notifier<AppLocaleState> {
  /// ─────────────────────────────────────────────────────────────────
  /// 初始化状态。
  /// ─────────────────────────────────────────────────────────────────
  ///
  /// 【调用时机】
  /// Provider 第一次被访问时调用（通常是 APP 启动时）。
  ///
  /// 【恢复逻辑】
  /// 1. 从 LocalStorage 读取上次的设置
  /// 2. 如果没有存储过（首次启动），默认跟随系统
  @override
  AppLocaleState build() {
    final option = AppLocaleOption.fromStorage(
      LocalStorage.getString(_localeOptionStorageKey),
    );
    return AppLocaleState(option: option);
  }

  /// ─────────────────────────────────────────────────────────────────
  /// 切换语言。
  /// ─────────────────────────────────────────────────────────────────
  ///
  /// 【流程】
  /// 1. 更新状态（触发 UI 重建）
  /// 2. 持久化到本地存储
  ///
  /// 【参数】
  /// - option：目标语言选项（system/zhHans/en）
  ///
  /// 【使用示例】
  /// ```dart
  /// // 切换到英文
  /// ref.read(appLocaleControllerProvider.notifier).select(AppLocaleOption.en);
  ///
  /// // 切换到跟随系统
  /// ref.read(appLocaleControllerProvider.notifier).select(AppLocaleOption.system);
  /// ```
  Future<void> select(AppLocaleOption option) async {
    // 1. 更新状态（Riverpod 会通知所有监听者）
    state = AppLocaleState(option: option);

    // 2. 持久化存储（下次启动恢复）
    await LocalStorage.setString(_localeOptionStorageKey, option.storageValue);
  }
}
