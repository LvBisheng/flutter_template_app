import '../../../core/network/api_client.dart';

class CustomerUpdateApi {
  const CustomerUpdateApi(this._client);
  final ApiClient _client;

  Future<Map<String, dynamic>> fetchProfile(String id) =>
      _client.get<Map<String, dynamic>>(
        '/customer/detail',
        queryParameters: {'customerId': id},
      );
  Future<void> update(Map<String, dynamic> payload) =>
      _client.post<Map<String, dynamic>>('/customer/update', data: payload);
}
