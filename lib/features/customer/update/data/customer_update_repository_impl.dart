import '../../detail/data/customer_profile_dto.dart';
import '../../detail/domain/customer_profile.dart';
import '../domain/customer_update_repository.dart';
import 'customer_update_api.dart';

/// 客户资料修改仓库实现。
///
/// 【Repository 实现职责】
/// 1. 调用 API 获取原始数据
/// 2. 将 DTO 转换为 Entity
/// 3. 组装提交参数
///
/// 【数据流】
/// ```
/// fetchProfile:
///   API 返回 JSON → CustomerProfileDto.fromJson() → DTO.toEntity() → Entity
///
/// updateProfile:
///   Entity → 组装成 Map（后端字段名） → API.update()
/// ```
///
class CustomerUpdateRepositoryImpl implements CustomerUpdateRepository {
  const CustomerUpdateRepositoryImpl(this._api);

  final CustomerUpdateApi _api;

  @override
  Future<CustomerProfile> fetchProfile(String customerId) async {
    // JSON → DTO → Entity
    final json = await _api.fetchProfile(customerId);
    return CustomerProfileDto(json).toEntity();
  }

  @override
  Future<void> updateProfile(CustomerProfile profile) {
    // Entity → Map（后端字段命名）
    // 注意：字段名使用后端定义的命名（如 cust_id、cust_name）
    return _api.update({
      'cust_id': profile.id,
      'cust_name': profile.name,
      'email_addr': profile.email,
      'mobile_no': profile.mobile,
      'industry_cd': profile.industryCode,
      'profession_cd': profile.professionCode,
      'birthday': profile.birthday?.toIso8601String(),
    });
  }
}
