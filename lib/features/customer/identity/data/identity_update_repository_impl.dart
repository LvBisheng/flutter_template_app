import '../domain/identity_update_repository.dart';
import 'identity_update_api.dart';

/// ─────────────────────────────────────────────────────────────────────
/// 身份证件更新 Repository 实现。
/// ─────────────────────────────────────────────────────────────────────
///
/// 【职责】
/// 调用 API 层，完成数据提交。
///
/// 【注意】
/// 当前是简单透传，真实项目可在此层添加：
/// - 数据校验
/// - 错误转换
/// - 缓存策略
///
class IdentityUpdateRepositoryImpl implements IdentityUpdateRepository {
  const IdentityUpdateRepositoryImpl(this._api);

  final IdentityUpdateApi _api;

  @override
  Future<void> updateIdentity(Map<String, dynamic> payload) =>
      _api.update(payload);
}
