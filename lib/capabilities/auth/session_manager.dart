import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'auth_state.dart';
import 'token_manager.dart';

final sessionManagerProvider = NotifierProvider<SessionManager, AuthState>(
  SessionManager.new,
);

class SessionManager extends Notifier<AuthState> {
  @override
  AuthState build() => const AuthState();

  Future<void> restore() async {
    final token = await ref.read(tokenManagerProvider).readToken();
    if (token != null) {
      state = AuthState(token: token, userName: 'Demo Operator');
    } else {
      state = const AuthState();
    }
  }

  Future<void> clearToken() async {
    await ref.read(tokenManagerProvider).clearToken();
    state = const AuthState();
  }

  Future<void> login(String token, String userName) async {
    await ref.read(tokenManagerProvider).saveToken(token);
    state = AuthState(token: token, userName: userName);
  }

  Future<void> logout() async {
    await clearToken();
  }
}
