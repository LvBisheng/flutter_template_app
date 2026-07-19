import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// ========================================
/// Riverpod 入门 - 第2课：AsyncNotifier 异步数据
/// ========================================
///
/// 当需要处理异步数据（网络请求、数据库查询等）时
/// 使用 AsyncNotifier 代替 Notifier

// ==================== 1. 数据模型 ====================

/// 用户数据模型
class User {
  final int id;
  final String name;
  final String email;

  User({required this.id, required this.name, required this.email});

  User copyWith({int? id, String? name, String? email}) {
    return User(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
    );
  }
}

// ==================== 2. AsyncNotifier - 异步状态管理 ====================

/// 【AsyncNotifier 入门】
/// 继承 `AsyncNotifier<状态类型>`
/// 用于处理异步数据加载，自带 loading/error/data 三种状态
class UserNotifier extends AsyncNotifier<User> {
  /// build() 返回 `FutureOr<User>`
  /// 可以是同步返回，也可以是异步返回
  /// 这个方法会在首次被访问时执行
  @override
  Future<User> build() async {
    // 模拟网络请求延迟
    await Future.delayed(const Duration(seconds: 1));

    // 返回初始数据
    return User(id: 1, name: '张三', email: 'zhangsan@example.com');
  }

  /// 【异步更新数据】
  /// 演示：异步操作后更新状态
  Future<void> refresh() async {
    // 设置为加载中状态
    state = const AsyncValue.loading();

    // 模拟网络请求
    await Future.delayed(const Duration(seconds: 1));

    // 设置新数据
    // AsyncValue.data() 创建成功状态
    state = AsyncValue.data(User(id: 1, name: '李四', email: 'lisi@example.com'));
  }

  /// 【异步更新 - 另一种写法】
  /// 直接给 state 赋值 AsyncValue
  Future<void> loadUser(int userId) async {
    state = const AsyncValue.loading();

    try {
      await Future.delayed(const Duration(seconds: 1));

      // 模拟根据 ID 加载用户
      final user = User(
        id: userId,
        name: '用户$userId',
        email: 'user$userId@example.com',
      );

      state = AsyncValue.data(user);
    } catch (e) {
      // 【错误处理】
      // AsyncValue.error() 创建错误状态
      state = AsyncValue.error(e, StackTrace.current);
    }
  }

  /// 【同步更新数据】
  /// 如果只是修改当前数据，不需要异步
  void updateName(String newName) {
    // state.value 获取当前数据（需要有值）
    final currentUser = state.value;
    if (currentUser != null) {
      state = AsyncValue.data(currentUser.copyWith(name: newName));
    }
  }

  void updateEmail(String newEmail) {
    final currentUser = state.value;
    if (currentUser != null) {
      state = AsyncValue.data(currentUser.copyWith(email: newEmail));
    }
  }
}

/// 注册 Provider
/// AsyncNotifierProvider 用于 AsyncNotifier
final userProvider = AsyncNotifierProvider<UserNotifier, User>(
  UserNotifier.new,
);

// ==================== 3. 模拟用户列表 ====================

class UserListNotifier extends AsyncNotifier<List<User>> {
  @override
  Future<List<User>> build() async {
    await Future.delayed(const Duration(seconds: 1));
    return [
      User(id: 1, name: '张三', email: 'zhangsan@example.com'),
      User(id: 2, name: '李四', email: 'lisi@example.com'),
      User(id: 3, name: '王五', email: 'wangwu@example.com'),
    ];
  }

  Future<void> addUser(String name) async {
    // 【更新前先获取当前数据】
    final currentUsers = state.value ?? [];

    // 立即更新 UI（乐观更新）
    state = AsyncValue.data([
      ...currentUsers,
      User(id: currentUsers.length + 1, name: name, email: '$name@example.com'),
    ]);

    // 模拟后台同步
    await Future.delayed(const Duration(milliseconds: 500));
  }
}

final userListProvider = AsyncNotifierProvider<UserListNotifier, List<User>>(
  UserListNotifier.new,
);

// ==================== 页面 ====================

class Lesson2AsyncNotifier extends ConsumerWidget {
  const Lesson2AsyncNotifier({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // 【watch 异步 Provider】
    // 返回的是 AsyncValue<User>，不是 User
    final asyncUser = ref.watch(userProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('第2课：AsyncNotifier 异步数据')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // ==================== 说明卡片 ====================
          const _InfoCard(
            title: '💡 AsyncNotifier 核心概念',
            color: Colors.blue,
            content: '''
1. 继承 AsyncNotifier<T> 处理异步数据
2. build() 返回 FutureOr<T>
3. state 的类型是 AsyncValue<T>
4. AsyncValue 有三种状态：loading/data/error''',
          ),
          const SizedBox(height: 16),

          // ==================== AsyncValue.when 处理状态 ====================
          Card(
            color: Colors.purple.shade50,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    '👤 单个用户数据',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  const SizedBox(height: 12),

                  /// 【when() - 处理三种状态】
                  /// 这是 AsyncValue 的核心用法
                  /// 根据状态自动显示不同的 UI
                  asyncUser.when(
                    /// 【loading 状态】数据加载中
                    loading: () => const Center(
                      child: Column(
                        children: [
                          CircularProgressIndicator(),
                          SizedBox(height: 8),
                          Text('加载中...'),
                        ],
                      ),
                    ),

                    /// 【error 状态】发生错误
                    error: (err, stack) => Column(
                      children: [
                        const Icon(Icons.error, color: Colors.red, size: 48),
                        const SizedBox(height: 8),
                        Text(
                          '加载失败: $err',
                          style: const TextStyle(color: Colors.red),
                        ),
                        ElevatedButton(
                          onPressed: () =>
                              ref.invalidate(userProvider), // 【刷新 Provider】
                          child: const Text('重试'),
                        ),
                      ],
                    ),

                    /// 【data 状态】数据加载成功
                    data: (user) => Column(
                      children: [
                        const Icon(
                          Icons.account_circle,
                          size: 64,
                          color: Colors.purple,
                        ),
                        const SizedBox(height: 8),
                        Text('ID: ${user.id}'),
                        Text(
                          '姓名: ${user.name}',
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text('邮箱: ${user.email}'),
                      ],
                    ),
                  ),

                  const SizedBox(height: 16),

                  // ==================== 操作按钮 ====================
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton(
                        onPressed: () =>
                            ref.read(userProvider.notifier).refresh(),
                        child: const Text('刷新数据'),
                      ),
                      ElevatedButton(
                        onPressed: () =>
                            ref.read(userProvider.notifier).loadUser(99),
                        child: const Text('加载用户99'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 16),

          // ==================== 乐观更新演示 ====================
          Card(
            color: Colors.green.shade50,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    '👥 用户列表（乐观更新演示）',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  const SizedBox(height: 12),

                  ref
                      .watch(userListProvider)
                      .when(
                        loading: () =>
                            const Center(child: CircularProgressIndicator()),
                        error: (err, _) => Text('错误: $err'),
                        data: (users) => Column(
                          children: [
                            ...users.map(
                              (u) => ListTile(
                                leading: CircleAvatar(
                                  child: Text(u.id.toString()),
                                ),
                                title: Text(u.name),
                                subtitle: Text(u.email),
                              ),
                            ),
                            const SizedBox(height: 8),
                            ElevatedButton.icon(
                              onPressed: () => ref
                                  .read(userListProvider.notifier)
                                  .addUser('新用户'),
                              icon: const Icon(Icons.add),
                              label: const Text('添加用户'),
                            ),
                          ],
                        ),
                      ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 16),

          // ==================== 完整代码示例 ====================
          Card(
            color: Colors.orange.shade50,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text(
                    '📝 关键代码',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  SizedBox(height: 8),
                  Text('''
// 定义 AsyncNotifier
class UserNotifier extends AsyncNotifier<User> {
  @override
  Future<User> build() async {
    await Future.delayed(Duration(seconds: 1));
    return User(name: '张三');
  }
}

// 使用 .when() 处理状态
asyncUser.when(
  loading: () => CircularProgressIndicator(),
  error: (err, _) => Text('Error: \$err'),
  data: (user) => Text(user.name),
);''', style: TextStyle(fontFamily: 'monospace', fontSize: 12)),
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
