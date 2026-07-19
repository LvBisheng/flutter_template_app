import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// ========================================
/// Riverpod 进阶 - 第5课：精准重建 select/ref.invalidate
/// ========================================
///
/// 性能优化的关键：只重建需要重建的部分

// ==================== 复杂状态 ====================

class User {
  final String name;
  final int age;
  final String city;
  final int score;

  User({
    required this.name,
    required this.age,
    required this.city,
    required this.score,
  });

  User copyWith({String? name, int? age, String? city, int? score}) {
    return User(
      name: name ?? this.name,
      age: age ?? this.age,
      city: city ?? this.city,
      score: score ?? this.score,
    );
  }
}

class UserNotifier extends Notifier<User> {
  @override
  User build() => User(name: '张三', age: 25, city: '北京', score: 100);

  void updateName(String name) => state = state.copyWith(name: name);
  void updateAge(int age) => state = state.copyWith(age: age);
  void updateCity(String city) => state = state.copyWith(city: city);
  void updateScore(int score) => state = state.copyWith(score: score);
}

final userProvider = NotifierProvider<UserNotifier, User>(UserNotifier.new);

// ==================== 刷新计数器（演示 ref.invalidate） ====================

class RefreshCounter extends Notifier<int> {
  @override
  int build() {
    debugPrint('🔄 RefreshCounter 被重建');
    return DateTime.now().second;
  }

  void refresh() {
    // 不修改 state，而是触发 rebuild
    // 这会重新执行 build()
  }
}

final refreshCounterProvider = NotifierProvider<RefreshCounter, int>(
  RefreshCounter.new,
);

// ==================== 页面 ====================

class Lesson5Select extends ConsumerWidget {
  const Lesson5Select({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(title: const Text('第5课：精准重建')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const _InfoCard(
            title: '💡 问题：为什么需要精准重建？',
            color: Colors.blue,
            content: '''
当 Provider 有多个属性时：
• ref.watch(userProvider) 监听整个对象
• 任何属性变化都会重建

这会造成不必要的性能浪费！

解决方案：
• ref.watch(provider.select((s) => s.xxx))
• 只监听特定属性，其他变化不触发重建''',
          ),
          const SizedBox(height: 16),

          // ==================== 对比演示 ====================
          Card(
            color: Colors.purple.shade50,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    '📊 对比：watch 全部 vs select 部分',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 12),

                  // 监听全部（会重建）
                  _WatchAllWidget(),

                  const Divider(height: 24),

                  // 只监听 name（只在 name 变化时重建）
                  _SelectNameWidget(),

                  const Divider(height: 24),

                  // 只监听 score（只在 score 变化时重建）
                  _SelectScoreWidget(),
                ],
              ),
            ),
          ),

          const SizedBox(height: 16),

          // ==================== 操作按钮 ====================
          Card(
            color: Colors.green.shade50,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    '🎮 操作按钮',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const Text('点击按钮修改不同属性，观察哪些组件重建'),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      ElevatedButton(
                        onPressed: () =>
                            ref.read(userProvider.notifier).updateName('李四'),
                        child: const Text('改姓名'),
                      ),
                      ElevatedButton(
                        onPressed: () =>
                            ref.read(userProvider.notifier).updateAge(30),
                        child: const Text('改年龄'),
                      ),
                      ElevatedButton(
                        onPressed: () =>
                            ref.read(userProvider.notifier).updateCity('上海'),
                        child: const Text('改城市'),
                      ),
                      ElevatedButton(
                        onPressed: () =>
                            ref.read(userProvider.notifier).updateScore(200),
                        child: const Text('改分数'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 16),

          // ==================== ref.invalidate 演示 ====================
          Card(
            color: Colors.orange.shade50,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    '🔄 ref.invalidate 刷新 Provider',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const Text('强制重新执行 build()，重置状态'),
                  const SizedBox(height: 12),
                  Text('当前秒数: ${ref.watch(refreshCounterProvider)}'),
                  const SizedBox(height: 8),
                  ElevatedButton(
                    onPressed: () {
                      // 【关键】使 Provider 失效，重新执行 build()
                      ref.invalidate(refreshCounterProvider);
                    },
                    child: const Text('刷新（重新执行 build）'),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 16),

          const _InfoCard(
            title: '📝 代码总结',
            color: Colors.green,
            content: '''
// 监听全部（任何变化都重建）
ref.watch(userProvider)

// 只监听 name（只有 name 变化才重建）
ref.watch(userProvider.select((u) => u.name))

// 刷新 Provider（重新执行 build）
ref.invalidate(userProvider)

// 刷新并获取新值
ref.refresh(userProvider)''',
          ),
        ],
      ),
    );
  }
}

/// 监听全部属性
class _WatchAllWidget extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // 监听整个 user 对象
    final user = ref.watch(userProvider);
    debugPrint('📱 _WatchAllWidget 重建了');

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.red.shade100,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '❌ ref.watch(userProvider)',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          Text(
            '姓名: ${user.name}, 年龄: ${user.age}, 城市: ${user.city}, 分数: ${user.score}',
          ),
          const Text(
            '⚠️ 任何属性变化都会重建这个 widget',
            style: TextStyle(color: Colors.red, fontSize: 12),
          ),
        ],
      ),
    );
  }
}

/// 只监听 name
class _SelectNameWidget extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // 【关键】只监听 name 属性
    final name = ref.watch(userProvider.select((u) => u.name));
    debugPrint('📱 _SelectNameWidget 重建了');

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.green.shade100,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '✅ ref.watch(userProvider.select((u) => u.name))',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          Text('姓名: $name'),
          const Text(
            '✅ 只有 name 变化才重建',
            style: TextStyle(color: Colors.green, fontSize: 12),
          ),
        ],
      ),
    );
  }
}

/// 只监听 score
class _SelectScoreWidget extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // 【关键】只监听 score 属性
    final score = ref.watch(userProvider.select((u) => u.score));
    debugPrint('📱 _SelectScoreWidget 重建了');

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.blue.shade100,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '✅ ref.watch(userProvider.select((u) => u.score))',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          Text('分数: $score'),
          const Text(
            '✅ 只有 score 变化才重建',
            style: TextStyle(color: Colors.blue, fontSize: 12),
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
