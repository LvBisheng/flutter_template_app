import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../shared/ui/widgets/common_app_bar.dart';
import '../routing/riverpod_demo_routes.dart';

/// Riverpod 学习 Demo 入口页面。
///
/// 展示所有课程列表，点击可进入对应的学习页面。
class RiverpodDemoHubPage extends StatelessWidget {
  const RiverpodDemoHubPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CommonAppBar(title: 'Riverpod 学习指南'),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _LessonCard(
            title: '第1课：Provider 基础',
            subtitle: 'Provider、NotifierProvider、watch/read',
            color: Colors.blue,
            onTap: () => context.push(RiverpodDemoRoutes.lesson1Path),
          ),
          const SizedBox(height: 12),
          _LessonCard(
            title: '第2课：AsyncNotifier',
            subtitle: '异步数据加载、loading/error/data 状态',
            color: Colors.purple,
            onTap: () => context.push(RiverpodDemoRoutes.lesson2Path),
          ),
          const SizedBox(height: 12),
          _LessonCard(
            title: '第3课：Provider 组合',
            subtitle: '依赖关系、ref.listen 副作用',
            color: Colors.green,
            onTap: () => context.push(RiverpodDemoRoutes.lesson3Path),
          ),
          const SizedBox(height: 12),
          _LessonCard(
            title: '第4课：ProviderScope',
            subtitle: '作用域、全局 vs 局部状态',
            color: Colors.orange,
            onTap: () => context.push(RiverpodDemoRoutes.lesson4Path),
          ),
          const SizedBox(height: 12),
          _LessonCard(
            title: '第5课：精准重建',
            subtitle: 'select 性能优化、ref.invalidate',
            color: Colors.red,
            onTap: () => context.push(RiverpodDemoRoutes.lesson5Path),
          ),
          const SizedBox(height: 12),
          _LessonCard(
            title: '第6课：代码生成注解',
            subtitle: 'riverpod_annotation 简化代码',
            color: Colors.teal,
            onTap: () => context.push(RiverpodDemoRoutes.lesson6Path),
          ),
        ],
      ),
    );
  }
}

/// 课程卡片组件
class _LessonCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final Color color;
  final VoidCallback onTap;

  const _LessonCard({
    required this.title,
    required this.subtitle,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: color.withValues(alpha: 0.1),
      child: ListTile(
        leading: Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(8),
          ),
          alignment: Alignment.center,
          child: Text(
            title.substring(1, 2), // 提取课号
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
          ),
        ),
        title: Text(title, style: TextStyle(color: color, fontWeight: FontWeight.bold)),
        subtitle: Text(subtitle),
        trailing: Icon(Icons.arrow_forward_ios, color: color),
        onTap: onTap,
      ),
    );
  }
}
