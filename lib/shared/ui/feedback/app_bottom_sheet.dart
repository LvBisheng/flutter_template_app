import 'package:flutter/material.dart';

class AppBottomSheet {
  AppBottomSheet._();

  static Future<T?> show<T>(BuildContext context, Widget child) =>
      showModalBottomSheet<T>(
        context: context,
        showDragHandle: true,
        builder: (_) => child,
      );
}
