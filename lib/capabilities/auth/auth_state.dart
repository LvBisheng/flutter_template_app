class AuthState {
  const AuthState({this.token, this.userName});
  final String? token;
  final String? userName;
  bool get isLoggedIn => token != null && token!.isNotEmpty;
}
