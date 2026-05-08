import '../domain/customer_summary.dart';

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

  factory CustomerSummaryDto.fromJson(Map<String, dynamic> json) =>
      CustomerSummaryDto(
        customerId: json['cust_id'] as String,
        customerName: json['cust_name'] as String,
        emailAddress: json['email_addr'] as String,
        mobileNumber: json['mobile_no'] as String,
        status: json['status'] as String,
        lastUpdatedAt: DateTime.parse(json['last_updated_at'] as String),
      );

  /// DTO -> Entity 转换把后端字段隔离在 data 层，页面不需要知道 cust_id 这类接口命名。
  CustomerSummary toEntity() => CustomerSummary(
    id: customerId,
    name: customerName,
    email: emailAddress,
    mobile: mobileNumber,
    status: status,
    lastUpdatedAt: lastUpdatedAt,
  );
}
