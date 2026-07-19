import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/network/api_client.dart';
import '../data/customer_detail_api.dart';
import '../data/customer_detail_repository_impl.dart';
import '../domain/customer_profile.dart';

/// ─────────────────────────────────────────────────────────────────────
/// 客户详情控制器。
/// ─────────────────────────────────────────────────────────────────────
///
/// 【FutureProvider.family 说明】
/// - FutureProvider：用于一次异步数据获取
/// - family：支持传入参数（如此处的客户 ID）
/// - autoDispose：离开页面后自动销毁，释放内存
///
/// 【Provider 类型选择】
/// ┌─────────────────────────┬────────────────────────────────────────┐
/// │ Provider 类型           │ 适用场景                               │
/// ├─────────────────────────┼────────────────────────────────────────┤
/// │ Provider                │ 只读配置、常量                         │
/// │ NotifierProvider        │ 表单、UI 状态（同步）                  │
/// │ AsyncNotifierProvider   │ 列表（需手动刷新、分页）               │
/// │ FutureProvider          │ 简单异步获取（无参数）                 │
/// │ FutureProvider.family   │ 按参数获取（如详情页按 ID 获取）       │
/// │ StreamProvider          │ 实时数据流（WebSocket）                │
/// └─────────────────────────┴────────────────────────────────────────┘
///
/// 【family 的作用】
/// ```dart
/// // 每个 ID 独立缓存
/// ref.watch(customerDetailControllerProvider('123'))  // 缓存 key: '123'
/// ref.watch(customerDetailControllerProvider('456'))  // 缓存 key: '456'
/// ```
///
/// 【autoDispose 的作用】
/// - 进入页面：Provider 创建，自动加载数据
/// - 离开页面：Provider 销毁，释放内存
/// - 再次进入：Provider 重新创建，重新加载数据
///
/// 【使用方式】
/// ```dart
/// // 页面中使用
/// final profile = ref.watch(customerDetailControllerProvider(customerId));
///
/// // 处理三种状态
/// profile.when(
///   loading: () => Loading(),
///   error: (e, st) => ErrorView(),
///   data: (profile) => DetailView(profile),
/// );
/// ```
///
final customerDetailControllerProvider =
    FutureProvider.family.autoDispose<CustomerProfile, String>((ref, id) {
  return CustomerDetailRepositoryImpl(
    CustomerDetailApi(ref.read(apiClientProvider)),
  ).fetchDetail(id);
});
