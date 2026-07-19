import 'package:flutter/material.dart';
import 'package:talker_flutter/talker_flutter.dart';

import '../../../core/logging/app_logger.dart';
import '../../../shared/extensions/context_ext.dart';

/// ─────────────────────────────────────────────────────────────────────
/// 日志控制台页面。
/// ─────────────────────────────────────────────────────────────────────
///
/// 【职责】
/// 显示 Talker 日志历史，用于开发调试。
///
/// 【使用方式】
/// 从开发工具面板进入，或直接导航：
/// ```dart
/// Navigator.push(context, MaterialPageRoute(builder: (_) => LogConsolePage()));
/// ```
///
/// 【功能】
/// - 查看所有日志（按时间倒序）
/// - 筛选日志级别
/// - 搜索日志内容
/// - 分享日志
/// - 清空日志
///
class LogConsolePage extends StatelessWidget {
  const LogConsolePage({super.key});

  @override
  Widget build(BuildContext context) {
    return TalkerScreen(
      talker: appTalker,
      appBarTitle: context.l10n.devToolLogTitle,
      // 日志按时间倒序显示（最新的在上面）
      isLogOrderReversed: true,
    );
  }
}
