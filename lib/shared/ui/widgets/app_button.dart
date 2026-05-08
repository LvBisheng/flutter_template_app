import 'package:flutter/material.dart';

/// 统一按钮封装。
///
/// 企业 App 中按钮状态、loading、禁用样式需要保持一致；页面只表达“能否点击”和
/// “点击做什么”，不要重复拼装各类按钮细节。
class AppButton extends StatelessWidget {
  const AppButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.loading = false,
    this.icon,
  });

  final String label;
  final VoidCallback? onPressed;
  final bool loading;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    final child = loading
        ? const SizedBox(
            width: 18,
            height: 18,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              color: Colors.white,
            ),
          )
        : Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (icon != null) ...[
                Icon(icon, size: 18),
                const SizedBox(width: 8),
              ],
              Flexible(child: Text(label, overflow: TextOverflow.ellipsis)),
            ],
          );
    return SizedBox(
      width: double.infinity,
      height: 48,
      child: FilledButton(onPressed: loading ? null : onPressed, child: child),
    );
  }
}
