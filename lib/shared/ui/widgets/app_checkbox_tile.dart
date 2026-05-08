import 'package:flutter/material.dart';

class AppCheckboxTile extends StatelessWidget {
  const AppCheckboxTile({
    super.key,
    required this.title,
    required this.value,
    required this.onChanged,
  });
  final String title;
  final bool value;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) => CheckboxListTile(
    contentPadding: EdgeInsets.zero,
    title: Text(title),
    value: value,
    onChanged: (v) => onChanged(v ?? false),
  );
}
