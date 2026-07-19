import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// ========================================
/// Riverpod 入门 - 第1课：Provider 基础
/// ========================================
///
/// Provider 是 Riverpod 最基础的单元，用于提供数据
/// 可以理解为"全局可访问的变量"

// ==================== 1. Provider - 只读数据 ====================

/// 【最简单的 Provider】
/// 只提供静态值，永远不会变化
/// 用途：配置项、常量、主题色等
final appNameProvider = Provider<String>((ref) {
  return 'Riverpod 学习笔记';
});

/// 【依赖其他 Provider】
/// 一个 Provider 可以读取另一个 Provider 的值
/// ref.watch 会自动建立依赖关系
final greetingProvider = Provider<String>((ref) {
  // 监听 appNameProvider，当它变化时，这里也会重新计算
  final appName = ref.watch(appNameProvider);
  return '欢迎来到 $appName！';
});

/// 【懒加载】
/// Provider 默认是懒加载的，只有被访问时才会执行
final lazyDataProvider = Provider<String>((ref) {
  debugPrint('🚀 lazyDataProvider 被初始化了！'); // 只有被 watch/read 时才会打印
  return '这是懒加载的数据';
});

// ==================== 2. NotifierProvider - 可变状态 ====================

/// 【NotifierProvider 入门】
/// 当需要管理可变状态时，使用 NotifierProvider
/// 这是 Riverpod 2.0+ 推荐的方式

/// 定义一个计数器 Notifier
/// 继承 `Notifier<状态类型>`
class Counter extends Notifier<int> {
  /// build() 返回初始状态
  /// 这个方法只会在首次被访问时执行一次
  @override
  int build() {
    debugPrint('🔢 Counter 被初始化');
    return 0;
  }

  /// 定义修改状态的方法
  /// 直接修改 state 即可，不需要 notifyListeners
  /// Riverpod 会自动通知所有监听者
  void increment() {
    state++; // 简单！不需要 setState，不需要 notifyListeners
  }

  void decrement() {
    state--;
  }

  void reset() {
    state = 0;
  }

  void add(int value) {
    state += value;
  }
}

/// 注册 Provider
/// Counter.new 是 Counter 类的构造函数引用
final counterProvider = NotifierProvider<Counter, int>(Counter.new);

// ==================== 页面 ====================

/// 【ConsumerWidget】
/// Riverpod 的组件基类，多了一个 ref 参数
/// ref 是和 Provider 通信的桥梁
class Lesson1BasicProvider extends ConsumerWidget {
  const Lesson1BasicProvider({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // ==================== watch vs read 的区别 ====================

    /// 【watch - 监听】
    /// 获取值并建立依赖关系，值变化时会触发 widget 重建
    /// 在 build 方法中使用
    final appName = ref.watch(appNameProvider);
    final greeting = ref.watch(greetingProvider);
    final counter = ref.watch(counterProvider);

    /// 【read - 仅读取】
    /// 只读取值，不建立依赖，值变化不会触发重建
    /// 通常在按钮点击等回调中使用
    /// 下面 onPressed 里会用到 read

    return Scaffold(
      appBar: AppBar(title: const Text('第1课：Provider 基础')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // ==================== 说明卡片 ====================
          _InfoCard(
            title: '💡 Provider 核心概念',
            color: Colors.blue.shade50,
            content: '''
1. Provider：提供只读数据（常量、配置）
2. NotifierProvider：提供可变状态（需要修改的数据）
3. ref.watch()：监听数据变化
4. ref.read()：只读取，不监听''',
          ),
          const SizedBox(height: 16),

          // ==================== 只读 Provider 演示 ====================
          _InfoCard(
            title: '📦 只读 Provider',
            color: Colors.green.shade50,
            content: '''
appNameProvider: $appName
greetingProvider: $greeting
（这些值不会变化）
''',
          ),
          const SizedBox(height: 16),

          // ==================== NotifierProvider 演示 ====================
          Card(
            color: Colors.purple.shade50,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    '🔢 NotifierProvider',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  const SizedBox(height: 12),
                  const Text('ref.watch(counterProvider) 监听变化：'),
                  const SizedBox(height: 8),
                  Center(
                    child: Text(
                      '$counter',
                      style: const TextStyle(
                        fontSize: 48,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // ==================== 按钮中用 ref.read ====================
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      // 【重要】在按钮回调中用 ref.read，不用 ref.watch
                      ElevatedButton(
                        onPressed: () =>
                            ref.read(counterProvider.notifier).decrement(),
                        child: const Text('-1'),
                      ),
                      ElevatedButton(
                        onPressed: () =>
                            ref.read(counterProvider.notifier).reset(),
                        child: const Text('重置'),
                      ),
                      ElevatedButton(
                        onPressed: () =>
                            ref.read(counterProvider.notifier).increment(),
                        child: const Text('+1'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  const Text('''
💡 关键点：
• build() 定义初始值（只执行一次）
• 直接修改 state，自动通知监听者
• 按钮回调用 ref.read(provider.notifier) 获取实例''', style: TextStyle(fontSize: 12)),
                ],
              ),
            ),
          ),

          const SizedBox(height: 16),

          // ==================== 懒加载演示 ====================
          Card(
            color: Colors.orange.shade50,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    '📦 懒加载 Provider',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  const SizedBox(height: 8),
                  const Text('下面按钮点击前，lazyDataProvider 不会初始化：'),
                  const SizedBox(height: 8),
                  ElevatedButton(
                    onPressed: () {
                      // 【演示懒加载】点击按钮时才访问
                      final data = ref.read(lazyDataProvider);
                      ScaffoldMessenger.of(
                        context,
                      ).showSnackBar(SnackBar(content: Text('懒加载: $data')));
                    },
                    child: const Text('访问懒加载数据'),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// 工具组件
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
      color: color,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 8),
            Text(content),
          ],
        ),
      ),
    );
  }
}
