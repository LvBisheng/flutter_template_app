import '../../../core/network/api_client.dart';

class CustomerDetailApi {
  const CustomerDetailApi(this._client);
  final ApiClient _client;

  Future<Map<String, dynamic>> fetchDetail(String id) =>
      _client.get<Map<String, dynamic>>(
        '/customer/detail',
        queryParameters: {'customerId': id},
      );
}
