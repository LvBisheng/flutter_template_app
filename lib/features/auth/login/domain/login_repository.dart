/// ─────────────────────────────────────────────────────────────────────
/// LoginRepository - 登录数据仓储的抽象接口。
/// ─────────────────────────────────────────────────────────────────────
///
/// 【职责】
/// 定义登录相关的数据操作接口（只定义，不实现）。
///
/// 【为什么需要抽象接口？】
/// 1. 依赖倒置原则（DIP）：
///    - UseCase 依赖抽象接口，而不是具体实现
///    - 上层（domain）不依赖下层（data）
///
/// 2. 便于测试：
///    - 可以创建 MockLoginRepository，测试 UseCase 逻辑，不需要真实网络请求
///
/// 3. 多实现支持：
///    - 正式环境：LoginRepositoryImpl（真实 API）
///    - 测试环境：MockLoginRepository（假数据）
///    - 离线模式：OfflineLoginRepository（本地缓存）
///
/// 【domain 层的设计原则】
/// - 不依赖 Flutter、Riverpod 等框架
/// - 不依赖 data 层的具体实现
/// - 可以被任何上层复用（Controller、UseCase 等）
///
/// 【调用链】
/// LoginUseCase -> LoginRepository（接口）
///                        ↓
///              LoginRepositoryImpl（实现）
///
/// ─────────────────────────────────────────────────────────────────────
abstract class LoginRepository {
  /// 执行登录操作。
  ///
  /// 返回登录结果（token + 用户信息）。
  /// 实现 LoginRepositoryImpl 中完成，包括：
  /// 1. 调用 LoginApi 发起网络请求
  /// 2. 解析 JSON 数据为 LoginResult 对象
  Future<LoginResult> login({
    required String username,
    required String password,
  });
}

/// 登录结果实体。
///
/// 注意：这是 domain 层的 Entity，不是 data 层的 DTO。
/// - Entity：业务领域的实体，不依赖任何外部库
/// - DTO：数据传输对象，可能有 json_serializable 等 annotation
///
/// 简单场景下，Entity 和 DTO 可以合并（如本项目）。
/// 复杂场景下，DTO 和 Entity 可能不同：
/// - DTO：{ "user_name": "张三", "token_value": "xxx" }
/// - Entity：{ userName: "张三", token: "xxx" }
///
/// RepositoryImpl 负责完成 DTO → Entity 的转换。
class LoginResult {
  const LoginResult({required this.token, required this.userName});

  /// 登录凭证（用于后续 API 认证）
  final String token;

  /// 用户名称（用于显示）
  final String userName;
}
