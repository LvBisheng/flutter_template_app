import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../l10n/generated/app_localizations.dart';

/// ─────────────────────────────────────────────────────────────────────
/// 应用退出处理工具。
/// ─────────────────────────────────────────────────────────────────────
///
/// 【设计说明】
/// 在 GoRouter 中，无法在顶层统一拦截退出（因为 builder 在路由树外部）。
/// 所以提供此工具方法，让"根页面"（如首页 Tab、登录页）统一处理退出确认。
///
/// 【使用方式】
/// ```dart
/// // 在根页面的 build 方法中：
/// return wrapWithExitConfirmation(context, child: Scaffold(...));
/// ```
///
/// 【根页面定义】
/// 用户无法再返回的页面，如：
/// - 首页 Tab（/home/demos、/home/me）
/// - 登录页（未登录时的根页面）
///

/// 包装页面，添加退出确认功能。
///
/// 用户侧滑或按返回键时，弹出确认对话框。
Widget wrapWithExitConfirmation({
  required BuildContext context,
  required Widget child,
}) {
  return PopScope(
    canPop: false,
    onPopInvokedWithResult: (didPop, result) {
      if (didPop) return;
      _showExitConfirmation(context);
    },
    child: child,
  );
}

/// 显示退出确认对话框。
void _showExitConfirmation(BuildContext context) {
  final l10n = AppLocalizations.of(context);
  showDialog<void>(
    context: context,
    builder: (dialogContext) => AlertDialog(
      title: Text(l10n.exitConfirmTitle),
      content: Text(l10n.exitConfirmMessage),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(dialogContext),
          child: Text(l10n.commonCancel),
        ),
        TextButton(
          onPressed: () {
            Navigator.pop(dialogContext);
            SystemNavigator.pop();
          },
          child: Text(l10n.commonConfirm),
        ),
      ],
    ),
  );
}
