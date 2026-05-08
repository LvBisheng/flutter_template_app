import '../../../shared/utils/app_date_utils.dart';
import '../domain/customer_profile.dart';

class CustomerProfileDto {
  const CustomerProfileDto(this.json);
  final Map<String, dynamic> json;

  CustomerProfile toEntity() => CustomerProfile(
    id: json['cust_id'] as String,
    name: json['cust_name'] as String,
    email: json['email_addr'] as String,
    mobile: json['mobile_no'] as String,
    status: json['status'] as String,
    industryCode: json['industry_cd'] as String?,
    industryName: json['industry_name'] as String?,
    professionCode: json['profession_cd'] as String?,
    professionName: json['profession_name'] as String?,
    birthday: AppDateUtils.tryParse(json['birthday'] as String?),
    lastUpdatedAt: DateTime.parse(json['last_updated_at'] as String),
  );
}
