class LoginState {
  const LoginState({
    this.username = 'demo',
    this.password = 'demo123',
    this.loading = false,
  });
  final String username;
  final String password;
  final bool loading;

  LoginState copyWith({String? username, String? password, bool? loading}) =>
      LoginState(
        username: username ?? this.username,
        password: password ?? this.password,
        loading: loading ?? this.loading,
      );
}
