import '../../../core/network/api_client.dart';

class LoginApi {
  const LoginApi(this._client);
  final ApiClient _client;

  Future<Map<String, dynamic>> login(String username, String password) {
    return _client.post<Map<String, dynamic>>(
      '/auth/login',
      data: {'username': username, 'password': password},
    );
  }
}
