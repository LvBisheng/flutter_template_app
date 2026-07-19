import 'package:flutter/material.dart';

import '../../extensions/context_ext.dart';

/// ─────────────────────────────────────────────────────────────────────
/// AppDialog - 统一 Dialog 封装。
/// ─────────────────────────────────────────────────────────────────────
///
/// 【为什么封装】
/// GoRouter + ShellRoute 架构下有多层 Navigator，
/// 直接使用 `Navigator.pop(context)` 可能 pop 错路由栈。
///
/// 【关键点】
/// builder 的参数 `dialogContext` 是 Dialog 自己的 BuildContext，
/// **关闭 Dialog 必须使用 `Navigator.of(dialogContext).pop()`，**
/// 而非外层传入的 `context`。
///
/// 【使用示例】
/// ```dart
/// // 确认弹窗
/// final ok = await AppDialog.confirm(context, '确定退出吗？');
/// if (ok) { ... }
///
/// // 错误提示
/// AppDialog.error(context, '网络请求失败');
/// ```
class AppDialog {
  AppDialog._();

  /// 显示错误提示弹窗。
  static Future<void> error(BuildContext context, String message) =>
      showDialog<void>(
        context: context,
        builder: (dialogContext) => AlertDialog(
          title: Text(context.l10n.commonErrorTitle),
          content: Text(message),
          actions: [
            TextButton(
              // 关键：使用 dialogContext 关闭 Dialog
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: Text(context.l10n.commonOk),
            ),
          ],
        ),
      );

  /// 显示确认弹窗，返回用户是否点击确认。
  static Future<bool> confirm(BuildContext context, String message) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(context.l10n.commonConfirmTitle),
        content: Text(message),
        actions: [
          TextButton(
            // 关键：使用 dialogContext 关闭 Dialog
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: Text(context.l10n.commonCancel),
          ),
          FilledButton(
            // 关键：使用 dialogContext 关闭 Dialog
            onPressed: () => Navigator.of(dialogContext).pop(true),
            child: Text(context.l10n.commonConfirm),
          ),
        ],
      ),
    );
    return result ?? false;
  }
}
