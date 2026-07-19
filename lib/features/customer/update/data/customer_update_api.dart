import '../../../../core/network/api_client.dart';

/// 客户资料修改 API。
///
/// 【API 层职责】
/// - 封装 HTTP 请求细节
/// - 只关心接口路径和参数
/// - 不处理数据转换（由 Repository 负责）
///
/// 【接口说明】
/// - fetchProfile: 获取客户详情（用于回显数据）
/// - update: 提交修改
///
class CustomerUpdateApi {
  const CustomerUpdateApi(this._client);

  final ApiClient _client;

  /// 获取客户详情。
  ///
  /// 返回原始 JSON，由 Repository 转换为 Entity。
  Future<Map<String, dynamic>> fetchProfile(String id) =>
      _client.get<Map<String, dynamic>>(
        '/customer/detail',
        queryParameters: {'customerId': id},
      );

  /// 更新客户资料。
  ///
  /// payload 由 Repository 组装，包含所有需要提交的字段。
  Future<void> update(Map<String, dynamic> payload) =>
      _client.post<Map<String, dynamic>>('/customer/update', data: payload);
}
