import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// ========================================
/// Riverpod 进阶 - 第4课：ProviderScope 与作用域
/// ========================================
///
/// ProviderScope 是 Riverpod 的容器
/// 理解作用域和 override 可以帮助你管理共享状态和页面级状态

// ==================== 全局 Provider ====================

/// 全局状态：在整个 app 中共享
class GlobalCounter extends Notifier<int> {
  @override
  int build() => 0;

  void increment() => state++;
}

final globalCounterProvider = NotifierProvider<GlobalCounter, int>(
  GlobalCounter.new,
);

// ==================== 页面 ====================

class Lesson4Scope extends ConsumerWidget {
  const Lesson4Scope({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(title: const Text('第4课：ProviderScope 作用域')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const _InfoCard(
            title: '💡 ProviderScope 核心概念',
            color: Colors.blue,
            content: '''
ProviderScope 是状态的容器：
• runApp(ProviderScope(child: App())) - 根作用域
• 默认情况下，子作用域会复用父作用域中已经存在的 Provider 状态
• 要让某个 Provider 在页面内独立，需要在新的 ProviderScope 中 override

关键理解：
• 同一个 ProviderScope 内，状态共享
• 新 ProviderScope 负责创建容器
• overrides 决定哪些 Provider 使用新的实例''',
          ),
          const SizedBox(height: 16),

          // 全局计数器
          Card(
            color: Colors.purple.shade50,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    '🌐 全局计数器（所有页面共享）',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '值: ${ref.watch(globalCounterProvider)}',
                    style: const TextStyle(fontSize: 32),
                  ),
                  const SizedBox(height: 8),
                  ElevatedButton(
                    onPressed: () =>
                        ref.read(globalCounterProvider.notifier).increment(),
                    child: const Text('+1'),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 16),

          // 对比两种打开方式
          Card(
            color: Colors.green.shade50,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    '🔍 对比共享状态和独立状态',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  const Text('共享页面使用根作用域；独立页面用 overrides 创建自己的实例：'),
                  const SizedBox(height: 12),

                  /// 【方式1】共享状态 - 不包 ProviderScope
                  ElevatedButton.icon(
                    onPressed: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const _SharedCounterPage(),
                      ),
                    ),
                    icon: const Icon(Icons.share),
                    label: const Text('打开共享状态页面'),
                  ),
                  const Text(
                    '读取根 ProviderScope 中的计数器，返回后变化仍保留',
                    style: TextStyle(fontSize: 12, color: Colors.blue),
                  ),

                  const SizedBox(height: 12),

                  /// 【方式2】独立状态 - 在子 ProviderScope 中 override
                  ElevatedButton.icon(
                    onPressed: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        /// 【关键】override 后，子树使用新的 GlobalCounter 实例
                        builder: (_) => ProviderScope(
                          overrides: [
                            globalCounterProvider.overrideWith(
                              GlobalCounter.new,
                            ),
                          ],
                          child: const _IsolatedCounterPage(),
                        ),
                      ),
                    ),
                    icon: const Icon(Icons.layers),
                    label: const Text('打开独立状态页面'),
                  ),
                  const Text(
                    '每次 push 都创建新的 ProviderScope，计数从 0 开始',
                    style: TextStyle(fontSize: 12, color: Colors.green),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 16),

          // 理解说明
          Card(
            color: Colors.orange.shade50,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text(
                    '❓ 为什么不能只包一层 ProviderScope？',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8),
                  Text(
                    '如果父作用域里已经有 globalCounterProvider 的状态，'
                    '子 ProviderScope 默认会向上读取这个已有状态。\n\n'
                    '所以"新 ProviderScope = 所有状态自动重置"这个说法不准确。'
                    '要做页面级独立状态，最直观的方式是在子作用域里 override 目标 Provider。',
                    style: TextStyle(fontSize: 12),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 16),

          const _InfoCard(
            title: '💡 如何真正实现独立状态？',
            color: Colors.green,
            content: '''
方法1：使用 overrides（本页采用）
ProviderScope(
  overrides: [counterProvider.overrideWith(Counter.new)],
  child: MyPage(),
)

方法2：使用 autoDispose
final counterProvider = NotifierProvider.autoDispose<Counter, int>(Counter.new);
// 没有监听者时自动销毁，下次访问重新初始化

方法3：使用 ref.invalidate()
离开页面时调用 ref.invalidate(counterProvider);
// 手动让 Provider 失效并重新初始化
''',
          ),

          const SizedBox(height: 16),

          // 使用场景
          Card(
            color: Colors.teal.shade50,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text(
                    '🎯 实际使用场景',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8),
                  Text(
                    '全局状态：\n'
                    '• 用户登录信息\n'
                    '• 购物车\n'
                    '• App 主题设置\n\n'
                    '独立状态（通常使用 overrides、autoDispose 或手动失效）：\n'
                    '• 表单填写页面\n'
                    '• 商品详情页',
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

/// 共享状态页面 - 使用全局计数器
class _SharedCounterPage extends ConsumerWidget {
  const _SharedCounterPage();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final counter = ref.watch(globalCounterProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('共享状态页面'),
        backgroundColor: Colors.blue.withValues(alpha: 0.3),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.share, size: 64, color: Colors.blue),
            const SizedBox(height: 16),
            const Text(
              '🌐 使用全局计数器',
              style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Text('$counter', style: const TextStyle(fontSize: 64)),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () =>
                  ref.read(globalCounterProvider.notifier).increment(),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue.withValues(alpha: 0.3),
              ),
              child: const Text('+1'),
            ),
            const SizedBox(height: 32),
            const Text(
              '返回后，变化会保留\n（使用全局 Provider）',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey, fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }
}

/// 独立状态页面 - 使用 override 后的计数器
/// 【关键】这个页面在带 overrides 的 ProviderScope 中打开
class _IsolatedCounterPage extends ConsumerWidget {
  const _IsolatedCounterPage();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // 这里仍然 watch 同一个 provider 标识符；
    // 实际实例由最近的 ProviderScope.overrides 决定。
    final counter = ref.watch(globalCounterProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('独立状态页面'),
        backgroundColor: Colors.green.withValues(alpha: 0.3),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.layers, size: 64, color: Colors.green),
            const SizedBox(height: 16),
            const Text(
              '📦 在新 ProviderScope 中',
              style: TextStyle(
                color: Colors.green,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Text('$counter', style: const TextStyle(fontSize: 64)),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () =>
                  ref.read(globalCounterProvider.notifier).increment(),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green.withValues(alpha: 0.3),
              ),
              child: const Text('+1'),
            ),
            const SizedBox(height: 32),
            const Text(
              '每次打开都从 0 开始\n（子作用域 override 了 Provider）',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey, fontSize: 12),
            ),
          ],
        ),
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
