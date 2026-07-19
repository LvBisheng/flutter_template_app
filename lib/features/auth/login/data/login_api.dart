import '../../../../core/network/api_client.dart';

/// ─────────────────────────────────────────────────────────────────────
/// LoginApi - 登录相关的 HTTP API 调用。
/// ─────────────────────────────────────────────────────────────────────
///
/// 【职责】
/// 封装登录相关的 HTTP 请求，只负责"发请求、拿响应"。
///
/// 【为什么需要这层？】
/// 1. 网络库解耦：如果将来从 Dio 换成其他库（如 http、dio5），只需改这里
/// 2. 接口参数集中管理：API 的路径、参数名都在这里定义，方便维护
/// 3. 便于测试：可以 mock 这个类，测试 Repository 逻辑
///
/// 【这一层不该做的事】
/// - 业务逻辑（如校验用户名是否为空）→ 放 UseCase
/// - 数据转换（如 JSON → Entity）→ 放 RepositoryImpl
/// - 状态管理（如 loading 状态）→ 放 Controller
///
/// 【调用链】
/// LoginPage -> LoginController -> LoginUseCase -> LoginRepositoryImpl -> LoginApi
///
/// ─────────────────────────────────────────────────────────────────────
class LoginApi {
  const LoginApi(this._client);

  /// ApiClient 是项目的统一网络客户端，封装了 Dio。
  /// 通过依赖注入传入，方便测试时替换为 mock。
  final ApiClient _client;

  /// 调用登录接口。
  ///
  /// 返回原始 JSON 数据，数据转换交给 RepositoryImpl 处理。
  Future<Map<String, dynamic>> login(String username, String password) {
    return _client.post<Map<String, dynamic>>(
      '/auth/login',
      data: {'username': username, 'password': password},
    );
  }
}
