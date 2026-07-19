import '../../../../core/network/api_client.dart';

/// ─────────────────────────────────────────────────────────────────────
/// 身份证件更新 API。
/// ─────────────────────────────────────────────────────────────────────
///
/// 【职责】
/// 封装身份证件更新的网络请求。
///
/// 【接口】
/// POST /identity/update - 提交证件更新数据
///
class IdentityUpdateApi {
  const IdentityUpdateApi(this._client);

  final ApiClient _client;

  /// 提交证件更新数据。
  ///
  /// [payload] 包含：customer_id, id_name, id_number, birthday, expiry_date, face_txn_id, signature
  Future<void> update(Map<String, dynamic> payload) =>
      _client.post<Map<String, dynamic>>('/identity/update', data: payload);
}
