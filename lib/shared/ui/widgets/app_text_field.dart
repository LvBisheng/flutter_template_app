import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// 通用文本输入框。
///
/// 这里内部维护 TextEditingController，而不是直接使用 initialValue。
/// 这样父级状态在每次输入后刷新时，不会重建输入框并造成光标跳动。
class AppTextField extends StatefulWidget {
  const AppTextField({
    super.key,
    required this.label,
    this.hint,
    this.initialValue,
    this.errorText,
    this.enabled = true,
    this.maxLength,
    this.keyboardType,
    this.inputFormatters,
    this.obscureText = false,
    this.onChanged,
  });

  final String label;
  final String? hint;
  final String? initialValue;
  final String? errorText;
  final bool enabled;
  final int? maxLength;
  final TextInputType? keyboardType;
  final List<TextInputFormatter>? inputFormatters;
  final bool obscureText;
  final ValueChanged<String>? onChanged;

  @override
  State<AppTextField> createState() => _AppTextFieldState();
}

class _AppTextFieldState extends State<AppTextField> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialValue ?? '');
  }

  @override
  void didUpdateWidget(covariant AppTextField oldWidget) {
    super.didUpdateWidget(oldWidget);
    final nextText = widget.initialValue ?? '';
    if (nextText != oldWidget.initialValue && nextText != _controller.text) {
      _controller.value = TextEditingValue(
        text: nextText,
        selection: TextSelection.collapsed(offset: nextText.length),
      );
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: _controller,
      enabled: widget.enabled,
      maxLength: widget.maxLength,
      keyboardType: widget.keyboardType,
      inputFormatters: widget.inputFormatters,
      obscureText: widget.obscureText,
      onChanged: widget.onChanged,
      decoration: InputDecoration(
        labelText: widget.label,
        hintText: widget.hint,
        errorText: widget.errorText,
        counterText: '',
      ),
    );
  }
}
