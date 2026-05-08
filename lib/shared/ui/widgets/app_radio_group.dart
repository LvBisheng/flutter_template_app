// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';

class AppRadioGroup<T> extends StatelessWidget {
  const AppRadioGroup({
    super.key,
    required this.title,
    required this.value,
    required this.options,
    required this.onChanged,
  });
  final String title;
  final T? value;
  final Map<T, String> options;
  final ValueChanged<T> onChanged;

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(title, style: Theme.of(context).textTheme.labelLarge),
      for (final entry in options.entries)
        RadioListTile<T>(
          dense: true,
          contentPadding: EdgeInsets.zero,
          title: Text(entry.value),
          value: entry.key,
          groupValue: value,
          onChanged: (v) {
            if (v != null) onChanged(v);
          },
        ),
    ],
  );
}
