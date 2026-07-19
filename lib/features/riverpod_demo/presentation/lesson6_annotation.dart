import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'lesson6_annotation.g.dart';

/// ========================================
/// Riverpod 进阶 - 第6课：代码生成注解
/// ========================================
///
/// riverpod_annotation + riverpod_generator 可以用注解生成 Provider，
/// 减少手写 Provider 定义的样板代码。

// ==================== 对比：手写 vs 注解 ====================

/// 【手写方式】之前学过的写法
class CounterManual extends Notifier<int> {
  @override
  int build() => 0;

  void increment() => state++;
  void decrement() => state--;
}

/// 手写方式需要自己声明 Provider
final counterManualProvider = NotifierProvider<CounterManual, int>(
  CounterManual.new,
);

// ==================== 真实注解示例 ====================

/// 【函数式 Provider】
/// 运行 build_runner 后会生成 annotationTitleProvider。
@riverpod
String annotationTitle(Ref ref) => '用 @riverpod 生成 Provider';

/// 【Family Provider】
/// 函数带参数时，生成的 Provider 会自动变成 family。
@riverpod
String annotationGreeting(Ref ref, String name) {
  final count = ref.watch(annotationCounterProvider);
  return '你好，$name！当前计数是 $count';
}

/// 【NotifierProvider】
/// 运行 build_runner 后会生成 annotationCounterProvider。
@riverpod
class AnnotationCounter extends _$AnnotationCounter {
  @override
  int build() => 0;

  void increment() => state++;
  void decrement() => state--;
  void reset() => state = 0;
}

// ==================== 页面演示 ====================

class Lesson6Annotation extends ConsumerWidget {
  const Lesson6Annotation({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final generatedTitle = ref.watch(annotationTitleProvider);
    final generatedGreeting = ref.watch(annotationGreetingProvider('Riverpod'));
    final generatedCount = ref.watch(annotationCounterProvider);
    final manualCount = ref.watch(counterManualProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('第6课：代码生成注解')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const _InfoCard(
            title: '💡 riverpod_annotation 是什么？',
            color: Colors.blue,
            content: r'''
用注解替代手写 Provider 定义：

手写：
class Counter extends Notifier<int> {...}
final counterProvider = NotifierProvider(...);

注解：
@riverpod
class Counter extends _$Counter {...}
// counterProvider 由 .g.dart 自动生成

优点：
• 减少样板代码
• 函数、异步、Notifier 都用同一套注解入口
• 带参数的 Provider 会自动生成 family''',
          ),
          const SizedBox(height: 16),

          Card(
            color: Colors.purple.shade50,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    '📝 手写 vs 注解对比',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.red.shade50,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '手写方式',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 8),
                        Text('''
class CounterManual extends Notifier<int> {
  @override
  int build() => 0;

  void increment() => state++;
}

final counterManualProvider =
    NotifierProvider<CounterManual, int>(
  CounterManual.new,
);''', style: TextStyle(fontFamily: 'monospace', fontSize: 11)),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.green.shade50,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '注解方式',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 8),
                        Text(
                          r'''
@riverpod
class AnnotationCounter
    extends _$AnnotationCounter {
  @override
  int build() => 0;

  void increment() => state++;
}
// annotationCounterProvider 自动生成''',
                          style: TextStyle(
                            fontFamily: 'monospace',
                            fontSize: 11,
                            color: Colors.green,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          Card(
            color: Colors.blue.shade50,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    '🎯 实际注解 Provider 演示',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  const SizedBox(height: 8),
                  Text(generatedTitle),
                  const SizedBox(height: 4),
                  Text(generatedGreeting),
                  const SizedBox(height: 12),
                  Text(
                    '注解计数: $generatedCount',
                    style: const TextStyle(fontSize: 32),
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      ElevatedButton(
                        onPressed: () => ref
                            .read(annotationCounterProvider.notifier)
                            .decrement(),
                        child: const Text('-1'),
                      ),
                      ElevatedButton(
                        onPressed: () => ref
                            .read(annotationCounterProvider.notifier)
                            .reset(),
                        child: const Text('重置'),
                      ),
                      ElevatedButton(
                        onPressed: () => ref
                            .read(annotationCounterProvider.notifier)
                            .increment(),
                        child: const Text('+1'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          Card(
            color: Colors.orange.shade50,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    '🔍 对照：手写 Provider 仍然可用',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '手写计数: $manualCount',
                    style: const TextStyle(fontSize: 32),
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    children: [
                      ElevatedButton(
                        onPressed: () => ref
                            .read(counterManualProvider.notifier)
                            .decrement(),
                        child: const Text('-1'),
                      ),
                      ElevatedButton(
                        onPressed: () => ref
                            .read(counterManualProvider.notifier)
                            .increment(),
                        child: const Text('+1'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          const _InfoCard(
            title: '⚙️ 项目配置',
            color: Colors.green,
            content: '''
dependencies:
  riverpod_annotation: ^3.0.3

dev_dependencies:
  build_runner: 2.8.0
  riverpod_generator: ^3.0.3

代码文件需要：
part 'lesson6_annotation.g.dart';

生成命令：
dart run build_runner build --delete-conflicting-outputs

说明：
当前 Flutter 3.38 / Dart 3.10 下暂时固定 build_runner 2.8.0，
避免 build_runner 2.10+ 触发 build hooks 编译错误。''',
          ),
        ],
      ),
    );
  }
}

class _InfoCard extends StatelessWidget {
  final String title;
  final Color color;
  final String content;

  const _InfoCard({
    required this.title,
    required this.color,
    required this.content,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: color.withValues(alpha: 0.1),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: color,
              ),
            ),
            const SizedBox(height: 8),
            Text(content, style: const TextStyle(fontSize: 12)),
          ],
        ),
      ),
    );
  }
}
