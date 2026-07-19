import 'package:go_router/go_router.dart';

import '../../../app/router/feature_route.dart';
import '../detail/presentation/customer_detail_page.dart';
import '../identity/presentation/identity_update_page.dart';
import '../list/presentation/customer_list_page.dart';
import '../update/presentation/customer_update_page.dart';

/// ─────────────────────────────────────────────────────────────────────
/// CustomerRoutes - 客户管理模块路由定义。
/// ─────────────────────────────────────────────────────────────────────
///
/// 【职责】
/// 聚合所有客户相关模块的路由配置：
/// - 客户列表 (`/home/customers`)
/// - 客户详情 (`/customer/:id`)
/// - 客户信息编辑 (`/customer/:id/update`)
/// - 身份认证更新 (`/customer/:id/identity-update`)
///
/// 【架构位置】
/// CustomerRoutes 是 Feature-based 路由架构的一部分，
/// 聚合了 customer 业务域下的所有子模块路由。
///
/// 【使用示例】
/// ```dart
/// // 跳转到客户列表
/// context.push(CustomerRoutes.customersPath);
///
/// // 跳转到客户详情
/// context.push(CustomerRoutes.customerDetailPath('123'));
///
/// // 跳转到客户编辑
/// context.push(CustomerRoutes.customerUpdatePath('123'));
/// ```
///
class CustomerRoutes extends FeatureRoute {
  CustomerRoutes._();
  static final instance = CustomerRoutes._();

  // ═══════════════════════════════════════════════════════════════════
  // 路径常量
  // ═══════════════════════════════════════════════════════════════════

  /// 客户列表页面路径。
  ///
  /// 这个页面不在 StatefulShellRoute 中，使用 push 导航，
  /// 有返回按钮，Android 返回键回到 Demo Hub。
  static const customersPath = '/home/customers';

  /// 客户列表页面路由名。
  static const customersName = 'customer.list';

  /// 客户详情页面路由名。
  static const customerDetailName = 'customer.detail';

  /// 客户信息编辑页面路由名。
  static const customerUpdateName = 'customer.update';

  /// 身份认证更新页面路由名。
  static const identityUpdateName = 'customer.identityUpdate';

  /// 客户详情页面路径模板。
  static const _customerDetailPath = '/customer/:id';

  /// 客户信息编辑页面路径模板。
  static const _customerUpdatePath = '/customer/:id/update';

  /// 身份认证更新页面路径模板。
  static const _identityUpdatePath = '/customer/:id/identity-update';

  /// 生成客户详情页面路径。
  ///
  /// 【参数】
  /// - [id]: 客户 ID
  ///
  /// 【返回】
  /// 完整路径，如 `/customer/123`
  static String customerDetailPath(String id) => '/customer/$id';

  /// 生成客户信息编辑页面路径。
  ///
  /// 【参数】
  /// - [id]: 客户 ID
  ///
  /// 【返回】
  /// 完整路径，如 `/customer/123/update`
  static String customerUpdatePath(String id) => '/customer/$id/update';

  /// 生成身份认证更新页面路径。
  ///
  /// 【参数】
  /// - [id]: 客户 ID
  ///
  /// 【返回】
  /// 完整路径，如 `/customer/123/identity-update`
  static String identityUpdatePath(String id) =>
      '/customer/$id/identity-update';

  // ═══════════════════════════════════════════════════════════════════
  // FeatureRoute 实现
  // ═══════════════════════════════════════════════════════════════════

  @override
  String get featureName => 'customer';

  @override
  List<RouteBase> get routes => [
    // 客户列表
    GoRoute(
      path: customersPath,
      name: customersName,
      builder: (context, state) => const CustomerListPage(),
    ),
    // 客户详情
    GoRoute(
      path: _customerDetailPath,
      name: customerDetailName,
      builder: (context, state) =>
          CustomerDetailPage(customerId: state.pathParameters['id']!),
    ),
    // 客户信息编辑
    GoRoute(
      path: _customerUpdatePath,
      name: customerUpdateName,
      builder: (context, state) =>
          CustomerUpdatePage(customerId: state.pathParameters['id']!),
    ),
    // 身份认证更新
    GoRoute(
      path: _identityUpdatePath,
      name: identityUpdateName,
      builder: (context, state) =>
          IdentityUpdatePage(customerId: state.pathParameters['id']!),
    ),
  ];
}
