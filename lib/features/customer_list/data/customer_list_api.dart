import '../../../core/network/api_client.dart';

class CustomerListApi {
  const CustomerListApi(this._client);
  final ApiClient _client;

  Future<List<dynamic>> fetchCustomers() =>
      _client.get<List<dynamic>>('/customer/list');
}
