import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../capabilities/auth/session_manager.dart';
import '../../../core/logging/app_logger.dart';
import '../../../core/network/api_client.dart';
import '../data/login_api.dart';
import '../data/login_repository_impl.dart';
import '../domain/login_use_case.dart';
import 'login_state.dart';

final loginControllerProvider = NotifierProvider<LoginController, LoginState>(
  LoginController.new,
);

class LoginController extends Notifier<LoginState> {
  @override
  LoginState build() => const LoginState();

  void usernameChanged(String value) => state = state.copyWith(username: value);
  void passwordChanged(String value) => state = state.copyWith(password: value);

  Future<void> login() async {
    state = state.copyWith(loading: true);
    try {
      appLogger.i('Login started: ${state.username}');
      final useCase = LoginUseCase(
        LoginRepositoryImpl(LoginApi(ref.read(apiClientProvider))),
        ref.read(sessionManagerProvider.notifier),
      );
      await useCase(state.username, state.password);
      appLogger.i('Login succeeded: ${state.username}');
    } catch (e, st) {
      appLogger.e('Login failed', error: e, stackTrace: st);
      rethrow;
    } finally {
      state = state.copyWith(loading: false);
    }
  }
}
