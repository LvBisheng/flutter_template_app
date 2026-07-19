import '../domain/customer_list_repository.dart';
import '../domain/customer_summary.dart';
import 'customer_list_api.dart';
import 'customer_summary_dto.dart';

/// 客户列表仓库实现。
///
/// 【Repository 实现职责】
/// 1. 调用 API 获取原始数据
/// 2. 将 DTO 转换为 Entity
/// 3. 处理数据转换逻辑（如类型转换、字段映射）
///
/// 【分层架构】
/// ┌─────────────────────────────────────────────────────────┐
/// │  Presentation (Controller)                             │
/// │     ↓ 调用 Repository 接口                               │
/// │  Domain (Repository 抽象 + Entity)                       │
/// │     ↓ 实现 Repository 接口                               │
/// │  Data (RepositoryImpl + DTO + API)                      │
/// │     ↓ 调用 API                                          │
/// │  Infrastructure (ApiClient)                            │
/// └─────────────────────────────────────────────────────────┘
///
/// 【数据流】
/// API 返回 JSON → DTO.fromJson() → DTO.toEntity() → Entity
///
class CustomerListRepositoryImpl implements CustomerListRepository {
  const CustomerListRepositoryImpl(this._api);

  final CustomerListApi _api;

  @override
  Future<List<CustomerSummary>> fetchCustomers() async {
    // 1. 调用 API 获取原始 JSON
    final list = await _api.fetchCustomers();

    // 2. 转换流程：JSON → DTO → Entity
    // 使用 map + as 而非 cast，避免类型不匹配时的模糊错误
    return list
        .map((e) => e as Map<String, dynamic>)  // 强制类型转换
        .map(CustomerSummaryDto.fromJson)       // JSON → DTO
        .map((dto) => dto.toEntity())           // DTO → Entity
        .toList();
  }
}
