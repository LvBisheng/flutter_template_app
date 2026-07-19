import '../domain/login_repository.dart';
import 'login_api.dart';

/// ─────────────────────────────────────────────────────────────────────
/// LoginRepositoryImpl - 登录数据仓储的实现。
/// ─────────────────────────────────────────────────────────────────────
///
/// 【职责】
/// 实现 LoginRepository 接口，负责：
/// 1. 调用 LoginApi 发起网络请求
/// 2. 解析 JSON 数据为 LoginResult（Entity）
///
/// 【这一层做的事】
/// - 网络请求 → JSON 解析
/// - 数据转换：Map 替换为 LoginResult
/// - 错误处理：将网络异常转换为业务异常（可选）
///
/// 【这一层不该做的事】
/// - 业务逻辑（如校验用户名）→ 放 UseCase
/// - 状态管理（如 loading）→ 放 Controller
/// - UI 相关（如显示 toast）→ 放 Page
///
/// 【为什么需要单独的 Repository 层？】
/// 1. 单一职责：Api 只负责网络，Repository 负责数据转换
/// 2. 多数据源支持：
///    - 优先读缓存，缓存不存在再请求网络
///    - 例如：登录 token 可以同时存网络 + 本地
/// 3. 数据格式转换：
///    - API 返回的格式可能不是我们想要的
///    - 例如：API 返回 user_name，Entity 用 userName
///
/// ─────────────────────────────────────────────────────────────────────
class LoginRepositoryImpl implements LoginRepository {
  const LoginRepositoryImpl(this._api);

  /// 依赖 LoginApi，通过构造函数注入。
  /// 这样可以方便测试时替换为 mock。
  final LoginApi _api;

  @override
  Future<LoginResult> login({
    required String username,
    required String password,
  }) async {
    // 1. 调用 API 获取原始 JSON 数据
    final json = await _api.login(username, password);

    // 2. 解析 JSON 为 Entity
    // 实际项目建议使用 json_serializable 或 freezed
    return LoginResult(
      token: json['token'] as String,
      // 兜底处理：如果后端没返回 user_name，就用用户输入的用户名
      userName: json['user_name'] as String? ?? username,
    );
  }
}
