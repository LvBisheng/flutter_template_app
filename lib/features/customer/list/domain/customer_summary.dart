/// 客户摘要实体。
///
/// 【实体说明】
/// Entity 是领域层的核心概念：
/// - 代表业务概念，不依赖任何框架
/// - 字段命名使用业务语言（id、name），而非数据库/API 字段
/// - 与 DTO（数据传输对象）分离，隔离后端字段命名
///
/// 【Entity vs DTO】
/// - Entity：业务层使用，字段命名友好（如 id、name）
/// - DTO：数据层使用，字段匹配后端（如 cust_id、cust_name）
/// - Repository 负责 DTO -> Entity 转换
///
class CustomerSummary {
  const CustomerSummary({
    required this.id,
    required this.name,
    required this.email,
    required this.mobile,
    required this.status,
    required this.lastUpdatedAt,
  });

  /// 客户 ID（对应后端 cust_id）
  final String id;

  /// 客户姓名（对应后端 cust_name）
  final String name;

  /// 邮箱地址（对应后端 email_addr）
  final String email;

  /// 手机号码（对应后端 mobile_no）
  final String mobile;

  /// 认证状态
  final String status;

  /// 最后更新时间
  final DateTime lastUpdatedAt;
}
