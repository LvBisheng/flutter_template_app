abstract class LoginRepository {
  Future<LoginResult> login({
    required String username,
    required String password,
  });
}

class LoginResult {
  const LoginResult({required this.token, required this.userName});
  final String token;
  final String userName;
}
