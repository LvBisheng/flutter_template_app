import '../../../../core/network/api_client.dart';

/// 客户列表 API。
///
/// 【API 层职责】
/// - 封装 HTTP 请求细节
/// - 只关心接口路径和参数
/// - 不处理数据转换（由 Repository 负责）
///
/// 【命名约定】
/// - 类名：XxxApi（如 CustomerListApi）
/// - 方法名：动词 + 名词（如 fetchCustomers）
///
/// 【典型用法】
/// ```dart
/// final api = CustomerListApi(apiClient);
/// final response = await api.fetchCustomers();
/// // response 通常是原始 JSON（List<dynamic> 或 Map）
/// ```
///
class CustomerListApi {
  const CustomerListApi(this._client);

  final ApiClient _client;

  /// 获取客户列表。
  ///
  /// 返回原始 JSON 数组，由 Repository 转换为 Entity。
  Future<List<dynamic>> fetchCustomers() =>
      _client.get<List<dynamic>>('/customer/list');
}
