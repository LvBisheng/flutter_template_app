import 'customer_summary.dart';

/// 客户列表仓库抽象接口。
///
/// 【Repository 模式说明】
/// Repository 是领域层与数据层之间的桥梁：
/// - 抽象接口放在 domain 层
/// - 具体实现放在 data 层
/// - 上层（Controller）只依赖抽象，不依赖实现
///
/// 【好处】
/// 1. 解耦：Controller 不需要知道数据从哪来（API、Mock、本地数据库）
/// 2. 可测试：可以轻松替换为 Mock 实现
/// 3. 可维护：更换数据源只需修改 Repository 实现
///
/// 【典型用法】
/// ```dart
/// // Controller 通过 Repository 获取数据
/// final customers = await repository.fetchCustomers();
///
/// // 注入不同实现
/// // 真实环境: CustomerListRepositoryImpl(api)
/// // 测试环境: MockCustomerListRepository()
/// ```
///
abstract class CustomerListRepository {
  /// 获取客户列表。
  Future<List<CustomerSummary>> fetchCustomers();
}
