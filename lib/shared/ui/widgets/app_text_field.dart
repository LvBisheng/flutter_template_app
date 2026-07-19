import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../screen/screen.dart';

/// 通用文本输入框。
///
/// ─────────────────────────────────────────────────────────────────────
/// 为什么内部维护 TextEditingController，而不是直接用 initialValue？
/// ─────────────────────────────────────────────────────────────────────
///
/// 如果直接使用 TextFormField(initialValue: xxx)，会有以下问题：
///
/// **问题场景：**
/// 1. 用户在输入框输入 "abc"
/// 2. onChanged 回调触发，父 Widget 状态更新（如保存到 Controller）
/// 3. 父 Widget 重建，传入新的 initialValue（如从 Controller 读取的最新值）
/// 4. Flutter 检测到 initialValue 变化，重新创建 TextFormField
/// 5. **光标跳回开头**（因为 Widget 被 rebuild，TextEditingController 被重置）
///
/// **解决方案：**
/// 内部维护一个 TextEditingController，它的生命周期与 State 绑定。
/// 这样即使父 Widget 重建，State 不会销毁，Controller 也保持不变，
/// 光标位置自然不会跳动。
///
/// ─────────────────────────────────────────────────────────────────────
/// 使用示例：
/// ─────────────────────────────────────────────────────────────────────
///
/// ```dart
/// // 简单用法
/// AppTextField(
///   label: '用户名',
///   onChanged: (value) => print(value),
/// );
///
/// // 带初始值（需要配合 Controller 使用）
/// AppTextField(
///   label: '用户名',
///   initialValue: state.username,
///   onChanged: ref.read(controller.notifier).usernameChanged,
/// );
///
/// // 密码输入框
/// AppTextField(
///   label: '密码',
///   obscureText: true,
/// );
/// ```
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

  /// 输入框标签（显示在输入框上方或边框内）
  final String label;

  /// 占位提示文字（输入框为空时显示）
  final String? hint;

  /// 初始值。
  ///
  /// 注意：
  /// - 只在 Widget 第一次创建时使用
  /// - 后续如果外部状态变化导致 initialValue 改变，
  ///   会通过 didUpdateWidget 同步到 Controller
  final String? initialValue;

  /// 错误提示文字。
  ///
  /// 传入非 null 值时，输入框会显示错误状态边框和错误提示。
  final String? errorText;

  /// 是否启用（默认 true）。
  ///
  /// 禁用时输入框变为灰色，不可编辑。
  final bool enabled;

  /// 最大输入长度。
  ///
  /// 设置后会显示输入计数器（默认隐藏 counterText: ''）。
  final int? maxLength;

  /// 键盘类型（如数字键盘、邮箱键盘等）。
  final TextInputType? keyboardType;

  /// 输入格式化器。
  ///
  /// 示例：
  /// - [FilteringTextInputFormatter.digitsOnly] 只允许数字
  /// - [LengthLimitingTextInputFormatter(11)] 限制长度
  final List<TextInputFormatter>? inputFormatters;

  /// 是否隐藏文字（密码输入框）。
  final bool obscureText;

  /// 输入变化回调。
  final ValueChanged<String>? onChanged;

  @override
  State<AppTextField> createState() => _AppTextFieldState();
}

class _AppTextFieldState extends State<AppTextField> {
  /// 内部维护的 TextEditingController。
  ///
  /// 生命周期与 State 绑定，不会因为父 Widget 重建而销毁，
  /// 从而避免光标跳动问题。
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    // 初始化 Controller，设置初始值
    _controller = TextEditingController(text: widget.initialValue ?? '');
  }

  /// Widget 更新时调用。
  ///
  /// ─────────────────────────────────────────────────────────────────────
  /// 为什么需要这个方法？
  /// ─────────────────────────────────────────────────────────────────────
  ///
  /// 当父 Widget 重建并传入新的 initialValue 时，需要同步到内部的 Controller。
  /// 例如：
  /// 1. 用户输入 "abc"
  /// 2. 父 Widget 保存到状态管理（如 Riverpod）
  /// 3. 父 Widget 重建，传入新的 initialValue = "abc"（从状态管理读取）
  /// 4. 此时需要判断：是否要更新 Controller？
  ///
  /// ─────────────────────────────────────────────────────────────────────
  /// 更新逻辑（避免不必要的光标跳动）：
  /// ─────────────────────────────────────────────────────────────────────
  ///
  /// 只有同时满足以下 2 个条件，才更新 Controller：
  ///
  /// 条件 1：新的 initialValue 与旧的 initialValue 不同
  /// - 说明父 Widget 确实传了新值（不是简单的重建）
  ///
  /// 条件 2：新的 initialValue 与当前 Controller 的值不同
  /// - 说明用户没有在输入，或者是外部强制更新（如重置表单）
  ///
  /// 如果只满足条件 1，不满足条件 2：
  /// - 说明用户正在输入，值已经是最新的
  /// - 不需要更新，避免光标跳动
  ///
  /// ─────────────────────────────────────────────────────────────────────
  /// 示例场景分析：
  /// ─────────────────────────────────────────────────────────────────────
  ///
  /// 场景 A：用户输入 "abc"，父 Widget 重建
  /// - oldWidget.initialValue = ""
  /// - widget.initialValue = "abc"（父Widget 从状态管理读取）
  /// - _controller.text = "abc"（用户刚刚输入的）
  /// - 满足条件 1（"" -> "abc"），但不满足条件 2（"abc" == "abc"）
  /// - 结论：不更新 Controller，光标不动 ✓
  ///
  /// 场景 B：重置表单（外部清空）
  /// - oldWidget.initialValue = "abc"
  /// - widget.initialValue = ""
  /// - _controller.text = "abc"
  /// - 满足条件 1（"abc" -> ""），满足条件 2（"" != "abc"）
  /// - 结论：更新 Controller，清空输入框 ✓
  ///
  /// 场景 C：从 API 加载数据填充表单
  /// - oldWidget.initialValue = ""
  /// - widget.initialValue = "张三"（API 返回）
  /// - _controller.text = ""
  /// - 满足条件 1（"" -> "张三"），满足条件 2（"张三" != ""）
  /// - 结论：更新 Controller，填充数据 ✓
  @override
  void didUpdateWidget(covariant AppTextField oldWidget) {
    super.didUpdateWidget(oldWidget);

    final nextText = widget.initialValue ?? '';
    final oldText = oldWidget.initialValue ?? '';
    final currentText = _controller.text;

    // 只有当新值确实变化，且与当前 Controller 的值不同时，才更新
    if (nextText != oldText && nextText != currentText) {
      _controller.value = TextEditingValue(
        text: nextText,
        // 光标移动到末尾（用户友好）
        selection: TextSelection.collapsed(offset: nextText.length),
      );
    }
  }

  @override
  void dispose() {
    // 释放 Controller，避免内存泄漏
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
      style: TextStyle(fontSize: 16.sp),
      decoration: InputDecoration(
        labelText: widget.label,
        labelStyle: TextStyle(fontSize: 14.sp),
        hintText: widget.hint,
        hintStyle: TextStyle(fontSize: 14.sp),
        errorText: widget.errorText != null && widget.errorText!.isNotEmpty? widget.errorText : null,
        // 隐藏输入计数器（即使设置了 maxLength）
        counterText: '',
        contentPadding: 12.s.paddingAll,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.s),
        ),
      ),
    );
  }
}
