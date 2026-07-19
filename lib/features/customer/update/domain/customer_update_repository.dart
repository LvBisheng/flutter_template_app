import '../../detail/domain/customer_profile.dart';

/// 客户资料修改仓库抽象接口。
///
/// 【Repository 模式说明】
/// - 抽象接口放在 domain 层
/// - 具体实现放在 data 层
/// - 上层（Controller）只依赖抽象，不依赖实现
///
/// 【好处】
/// 1. 解耦：Controller 不需要知道数据从哪来
/// 2. 可测试：可以轻松替换为 Mock 实现
/// 3. 可维护：更换数据源只需修改 Repository 实现
///
abstract class CustomerUpdateRepository {
  /// 获取客户资料详情。
  Future<CustomerProfile> fetchProfile(String customerId);

  /// 更新客户资料。
  Future<void> updateProfile(CustomerProfile profile);
}
