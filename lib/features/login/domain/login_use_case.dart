import '../../../capabilities/auth/session_manager.dart';
import '../../../core/network/app_exception.dart';
import 'login_repository.dart';

/// 登录 UseCase 编排“校验输入 -> 调接口 -> 保存登录态”。
///
/// 页面不直接保存 token，是为了让登录态策略集中在 capability/auth 中。
class LoginUseCase {
  const LoginUseCase(this._repository, this._sessionManager);

  final LoginRepository _repository;
  final SessionManager _sessionManager;

  Future<void> call(String username, String password) async {
    if (username.trim().isEmpty || password.isEmpty) {
      throw const AppException('请输入用户名和密码');
    }
    final result = await _repository.login(
      username: username,
      password: password,
    );
    await _sessionManager.login(result.token, result.userName);
  }
}
