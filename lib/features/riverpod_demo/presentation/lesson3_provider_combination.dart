import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// ========================================
/// Riverpod 入门 - 第3课：Provider 组合与 ref.listen
/// ========================================

// ==================== 1. 基础 Provider ====================

/// 计数器
class Counter extends Notifier<int> {
  @override
  int build() => 0;

  void increment() => state++;
  void decrement() => state--;
}

final counterProvider = NotifierProvider<Counter, int>(Counter.new);

// ==================== 2. Provider 组合（依赖其他 Provider） ====================

/// 【组合】依赖另一个 Provider
/// 当 counterProvider 变化时，这个自动重新计算
final doubleCounterProvider = Provider<int>((ref) {
  final count = ref.watch(counterProvider);
  return count * 2;
});

/// 【组合】多个依赖
final summaryProvider = Provider<String>((ref) {
  final count = ref.watch(counterProvider);
  final doubled = ref.watch(doubleCounterProvider);
  return '计数: $count, 双倍: $doubled';
});

// ==================== 3. ref.listen 示例 ====================

/// 游戏分数
class GameScore extends Notifier<int> {
  @override
  int build() => 0;

  void addScore(int points) {
    state += points;
    // 【注意】state 变化后，所有 watch 这个 provider 的地方都会重建
  }

  void reset() {
    state = 0;
  }
}

final gameScoreProvider = NotifierProvider<GameScore, int>(GameScore.new);

// ==================== 页面 ====================

class Lesson3ProviderCombination extends ConsumerStatefulWidget {
  const Lesson3ProviderCombination({super.key});

  @override
  ConsumerState<Lesson3ProviderCombination> createState() => _Lesson3State();
}

class _Lesson3State extends ConsumerState<Lesson3ProviderCombination> {
  /// 日志列表（本地状态，不用 Provider）
  List<String> logs = [];

  @override
  Widget build(BuildContext context) {
    // 监听分数变化
    final score = ref.watch(gameScoreProvider);

    /// 【ref.listen 在 Widget 中使用】
    /// 每次分数变化时，自动执行回调
    /// 用途：显示提示、播放音效、记录日志等
    ref.listen<int>(gameScoreProvider, (previous, next) {
      // previous 是旧值，next 是新值
      if (next > (previous ?? 0) && next % 10 == 0) {
        // 每10分显示一次祝贺
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('🎉 恭喜！达到 $next 分！'),
            backgroundColor: Colors.green,
          ),
        );
      }

      // 记录日志
      setState(() {
        logs.add('分数变化: $previous -> $next');
      });
    });

    return Scaffold(
      appBar: AppBar(title: const Text('第3课：Provider 组合')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // ==================== 核心概念讲解 ====================
          const _InfoCard(
            title: '💡 核心概念',
            color: Colors.blue,
            content: '''
ref.watch  → 监听数据，重建 UI
ref.listen → 监听数据，执行副作用（不重建 UI）

副作用是什么？
• 显示 SnackBar
• 导航到新页面
• 播放音效
• 记录日志
• 发送统计事件''',
          ),
          const SizedBox(height: 16),

          // ==================== Provider 组合演示 ====================
          Card(
            color: Colors.purple.shade50,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    '🔗 Provider 组合',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  const SizedBox(height: 8),
                  const Text('一个 Provider 可以依赖另一个 Provider：'),
                  const SizedBox(height: 12),

                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('counterProvider: ${ref.watch(counterProvider)}'),
                        Text(
                          'doubleCounterProvider: ${ref.watch(doubleCounterProvider)}',
                        ),
                        Text('summaryProvider: ${ref.watch(summaryProvider)}'),
                      ],
                    ),
                  ),

                  const SizedBox(height: 8),
                  const Text(
                    '依赖关系：\n'
                    'counterProvider\n'
                    '  └─ doubleCounterProvider (依赖 counter)\n'
                    '      └─ summaryProvider (依赖 counter 和 double)',
                    style: TextStyle(fontSize: 12, fontFamily: 'monospace'),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 16),

          // ==================== ref.listen 实际演示 ====================
          Card(
            color: Colors.orange.shade50,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    '👂 ref.listen 演示',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  const SizedBox(height: 8),
                  const Text('点击按钮加分，观察：'),
                  const Text(
                    '1. 分数是10的倍数时显示 SnackBar',
                    style: TextStyle(color: Colors.green),
                  ),
                  const Text(
                    '2. 每次变化都记录日志',
                    style: TextStyle(color: Colors.blue),
                  ),
                  const SizedBox(height: 12),

                  // 分数显示
                  Center(
                    child: Container(
                      width: 120,
                      height: 120,
                      decoration: BoxDecoration(
                        color: Colors.orange,
                        borderRadius: BorderRadius.circular(60),
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        '$score',
                        style: const TextStyle(
                          fontSize: 40,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 16),

                  // 加分按钮
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton(
                        onPressed: () =>
                            ref.read(gameScoreProvider.notifier).addScore(1),
                        child: const Text('+1分'),
                      ),
                      ElevatedButton(
                        onPressed: () =>
                            ref.read(gameScoreProvider.notifier).addScore(5),
                        child: const Text('+5分'),
                      ),
                      ElevatedButton(
                        onPressed: () =>
                            ref.read(gameScoreProvider.notifier).reset(),
                        child: const Text('重置'),
                      ),
                    ],
                  ),

                  const SizedBox(height: 16),

                  // 日志列表
                  const Text('📋 变化日志：'),
                  const SizedBox(height: 8),
                  Container(
                    constraints: const BoxConstraints(maxHeight: 120),
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.orange.shade200),
                    ),
                    child: logs.isEmpty
                        ? const Text('（还没有日志）')
                        : ListView.builder(
                            itemCount: logs.length,
                            itemBuilder: (ctx, i) => Text(
                              logs[i],
                              style: const TextStyle(
                                fontSize: 12,
                                fontFamily: 'monospace',
                              ),
                            ),
                          ),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 16),

          // ==================== 代码示例 ====================
          Card(
            color: Colors.green.shade50,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text(
                    '📝 ref.listen 代码示例',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  SizedBox(height: 8),
                  Text('''// 在 build 方法中使用
ref.listen<int>(scoreProvider, (previous, next) {
  // previous: 变化前的值
  // next: 变化后的值

  // 副作用示例：
  if (next >= 100) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('恭喜通关！')),
    );
    Navigator.push(context, ...);
  }
});''', style: TextStyle(fontFamily: 'monospace', fontSize: 12)),
                ],
              ),
            ),
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
            Text(content),
          ],
        ),
      ),
    );
  }
}
