import '../domain/login_repository.dart';
import 'login_api.dart';

class LoginRepositoryImpl implements LoginRepository {
  const LoginRepositoryImpl(this._api);
  final LoginApi _api;

  @override
  Future<LoginResult> login({
    required String username,
    required String password,
  }) async {
    final json = await _api.login(username, password);
    return LoginResult(
      token: json['token'] as String,
      userName: json['user_name'] as String? ?? username,
    );
  }
}
