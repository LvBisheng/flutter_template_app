import 'package:collection/collection.dart';
import 'package:flutter/material.dart';

class PickerOption {
  const PickerOption(this.value, this.label);
  final String value;
  final String label;
}

class AppPickerField extends StatelessWidget {
  const AppPickerField({
    super.key,
    required this.label,
    required this.hint,
    required this.options,
    required this.onSelected,
    this.value,
    this.enabled = true,
    this.errorText,
  });

  final String label;
  final String hint;
  final String? value;
  final bool enabled;
  final String? errorText;
  final List<PickerOption> options;
  final ValueChanged<PickerOption> onSelected;

  @override
  Widget build(BuildContext context) {
    final selected = options.where((e) => e.value == value).firstOrNull;
    return InkWell(
      onTap: enabled ? () => _showPicker(context) : null,
      child: InputDecorator(
        decoration: InputDecoration(
          labelText: label,
          enabled: enabled,
          suffixIcon: const Icon(Icons.expand_more),
          errorText: errorText,
        ),
        child: Text(
          selected?.label ?? hint,
          style: TextStyle(color: selected == null ? Colors.grey : null),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
      ),
    );
  }

  Future<void> _showPicker(BuildContext context) async {
    await showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      builder: (_) => SafeArea(
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxHeight: MediaQuery.sizeOf(context).height * 0.65,
          ),
          child: ListView(
            shrinkWrap: true,
            children: [
              for (final option in options)
                ListTile(
                  selected: option.value == value,
                  title: Text(option.label, maxLines: 3),
                  subtitle: Text(option.value),
                  trailing: option.value == value
                      ? const Icon(Icons.check)
                      : null,
                  onTap: () {
                    Navigator.pop(context);
                    onSelected(option);
                  },
                ),
            ],
          ),
        ),
      ),
    );
  }
}
