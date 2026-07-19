import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/network/api_client.dart';
import '../data/customer_list_api.dart';
import '../data/customer_list_repository_impl.dart';
import '../domain/customer_summary.dart';

/// ─────────────────────────────────────────────────────────────────────
/// 客户列表控制器。
/// ─────────────────────────────────────────────────────────────────────
///
/// 【AsyncNotifier 说明】
/// 使用 AsyncNotifier 而非普通 Notifier，因为客户列表需要异步加载：
/// - 内置 loading/error/data 状态管理
/// - 自动处理网络请求的异步状态
/// - 页面通过 .when() 处理不同状态
///
/// 【autoDispose 说明】
/// 使用 autoDispose，Provider 在没有监听者时自动销毁：
/// - 进入页面：Provider 创建，自动加载数据
/// - 离开页面：Provider 销毁，释放内存
/// - 再次进入：Provider 重新创建，重新加载数据
///
/// 这样就不需要手动 invalidate，更符合传统页面生命周期。
///
/// 【AsyncNotifier vs Notifier 对比】
/// ┌─────────────────────┬────────────────────┬─────────────────────────┐
/// │ 特性                │ Notifier           │ AsyncNotifier           │
/// ├─────────────────────┼────────────────────┼─────────────────────────┤
/// │ build 返回          │ T（同步）          │ `Future<T>`（异步）     │
/// │ state 类型          │ T                  │ `AsyncValue<T>`         │
/// │ 状态管理            │ 手动               │ 自动                    │
/// │ 典型场景            │ 表单、UI 状态      │ 网络请求、数据库查询    │
/// └─────────────────────┴────────────────────┴─────────────────────────┘
///
/// 【Provider 定义方式】
/// ```dart
/// // AsyncNotifier 的 Provider 定义（带 autoDispose）
/// final provider = AsyncNotifierProvider.autoDispose<Controller, Data>(
///   Controller.new,
/// );
///
/// // 对比普通 Notifier 的定义
/// final provider = NotifierProvider<Controller, State>(
///   Controller.new,
/// );
/// ```
///
/// 【AsyncValue 状态包装】
/// AsyncNotifier 的 state 不是直接存数据，而是包装成 AsyncValue：
/// ```dart
/// // Notifier 的 state
/// state = LoginState(username: 'alice', ...);  // 直接是数据
///
/// // AsyncNotifier 的 state
/// state = AsyncData([customer1, customer2]);   // 成功
/// state = AsyncLoading();                       // 加载中
/// state = AsyncError(e, st);                    // 失败
/// ```
///
/// 【状态变化 → UI 刷新流程】
/// ```
/// 1. build() 返回 Future
///         ↓
/// 2. Riverpod 自动设 state = AsyncLoading()
///         ↓
/// 3. Future 完成
///    → 成功：state = AsyncData(data)
///    → 失败：state = AsyncError(e, st)
///         ↓
/// 4. 通知所有 ref.watch(...) 的地方
///         ↓
/// 5. UI 通过 .when() 处理三种状态
/// ```
///
/// 【典型用法】
/// ```dart
/// // 监听数据（返回 AsyncValue<List<CustomerSummary>>）
/// final customers = ref.watch(customerListControllerProvider);
///
/// // 处理三种状态
/// customers.when(
///   loading: () => CircularProgressIndicator(),
///   error: (e, st) => Text('Error: e'),
///   data: (list) => ListView(...),
/// );
///
/// // 刷新数据
/// ref.read(customerListControllerProvider.notifier).refresh();
/// ```
///
final customerListControllerProvider =
    AsyncNotifierProvider.autoDispose<CustomerListController, List<CustomerSummary>>(
      CustomerListController.new,
    );

/// 客户列表控制器。
///
/// 负责管理客户列表的异步加载和刷新。
class CustomerListController extends AsyncNotifier<List<CustomerSummary>> {
  /// 初始化时加载数据。
  ///
  /// AsyncNotifier 的 build 方法必须返回 `Future<T>`，
  /// Riverpod 会在 Provider 创建时自动调用，并管理加载状态。
  @override
  Future<List<CustomerSummary>> build() => _load();

  /// 从 API 加载客户列表。
  Future<List<CustomerSummary>> _load() => CustomerListRepositoryImpl(
    CustomerListApi(ref.read(apiClientProvider)),
  ).fetchCustomers();

  /// 刷新客户列表。
  ///
  /// 使用 AsyncValue.guard 包装异步操作：
  /// - 成功：自动更新 state 为 AsyncData
  /// - 失败：自动更新 state 为 AsyncError
  ///
  /// 比 try-catch 更简洁，Riverpod 推荐的异步处理方式。
  Future<void> refresh() async => state = await AsyncValue.guard(_load);
}
