import '../../../../shared/utils/type_convert_utils.dart';
import '../domain/customer_summary.dart';

/// 客户摘要 DTO（Data Transfer Object）。
///
/// 【DTO 说明】
/// DTO 用于数据传输，字段命名匹配后端接口：
/// - 反序列化：fromJson() 将后端 JSON 转为 Dart 对象
/// - 转换：toEntity() 将 DTO 转为业务层的 Entity
///
/// 【DTO vs Entity】
/// ┌────────────────────────────────────────────────────────┐
/// │ 后端 JSON     →    DTO        →    Entity    →    页面    │
/// │ cust_id           customerId     id                      │
/// │ cust_name         customerName   name                    │
/// │ email_addr        emailAddress   email                  │
/// │ mobile_no         mobileNumber   mobile                  │
/// └────────────────────────────────────────────────────────┘
///
/// 【为什么需要 DTO？】
/// 1. 隔离后端字段命名（如 cust_id -> id）
/// 2. 处理类型转换（如 String -> DateTime）
/// 3. 后端字段变更只影响 DTO，不影响 Entity
///
/// 【防御性编程】
/// 使用 JsonParseUtils 处理后端类型不稳定的情况。
///
class CustomerSummaryDto {
  const CustomerSummaryDto({
    required this.customerId,
    required this.customerName,
    required this.emailAddress,
    required this.mobileNumber,
    required this.status,
    required this.lastUpdatedAt,
  });

  final String customerId;
  final String customerName;
  final String emailAddress;
  final String mobileNumber;
  final String status;
  final DateTime lastUpdatedAt;

  /// 从 JSON 反序列化。
  ///
  /// 字段名匹配后端接口命名（如 cust_id、cust_name）。
  /// 使用 JsonParseUtils 做防御性转换。
  factory CustomerSummaryDto.fromJson(Map<String, dynamic> json) =>
      CustomerSummaryDto(
        customerId: TypeConvertUtils.asString(json['cust_id']),
        customerName: TypeConvertUtils.asString(json['cust_name']),
        emailAddress: TypeConvertUtils.asString(json['email_addr']),
        mobileNumber: TypeConvertUtils.asString(json['mobile_no']),
        status: TypeConvertUtils.asString(json['status']),
        lastUpdatedAt: TypeConvertUtils.asDateTime(json['last_updated_at']),
      );

  /// DTO -> Entity 转换。
  ///
  /// 把后端字段隔离在 data 层，页面不需要知道 cust_id 这类接口命名。
  CustomerSummary toEntity() => CustomerSummary(
    id: customerId,
    name: customerName,
    email: emailAddress,
    mobile: mobileNumber,
    status: status,
    lastUpdatedAt: lastUpdatedAt,
  );
}
