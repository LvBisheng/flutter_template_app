import '../../../core/network/api_client.dart';

class IdentityUpdateApi {
  const IdentityUpdateApi(this._client);
  final ApiClient _client;

  Future<void> update(Map<String, dynamic> payload) =>
      _client.post<Map<String, dynamic>>('/identity/update', data: payload);
}
