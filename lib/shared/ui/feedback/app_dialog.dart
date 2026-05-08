import 'package:flutter/material.dart';

import '../../extensions/context_ext.dart';

class AppDialog {
  AppDialog._();

  static Future<void> error(BuildContext context, String message) =>
      showDialog<void>(
        context: context,
        builder: (_) => AlertDialog(
          title: Text(context.l10n.commonErrorTitle),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(context.l10n.commonOk),
            ),
          ],
        ),
      );

  static Future<bool> confirm(BuildContext context, String message) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(context.l10n.commonConfirmTitle),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(context.l10n.commonCancel),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text(context.l10n.commonConfirm),
          ),
        ],
      ),
    );
    return result ?? false;
  }
}
