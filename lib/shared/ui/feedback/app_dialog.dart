import 'package:flutter/material.dart';

class AppDialog {
  AppDialog._();

  static Future<void> error(BuildContext context, String message) =>
      showDialog<void>(
        context: context,
        builder: (_) => AlertDialog(
          title: const Text('处理失败'),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('知道了'),
            ),
          ],
        ),
      );

  static Future<bool> confirm(BuildContext context, String message) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('请确认'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('取消'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('确认'),
          ),
        ],
      ),
    );
    return result ?? false;
  }
}
