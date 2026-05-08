import '../../customer_detail/data/customer_profile_dto.dart';
import '../../customer_detail/domain/customer_profile.dart';
import '../domain/customer_update_repository.dart';
import 'customer_update_api.dart';

class CustomerUpdateRepositoryImpl implements CustomerUpdateRepository {
  const CustomerUpdateRepositoryImpl(this._api);
  final CustomerUpdateApi _api;

  @override
  Future<CustomerProfile> fetchProfile(String customerId) async =>
      CustomerProfileDto(await _api.fetchProfile(customerId)).toEntity();

  @override
  Future<void> updateProfile(CustomerProfile profile) => _api.update({
    'cust_id': profile.id,
    'cust_name': profile.name,
    'email_addr': profile.email,
    'mobile_no': profile.mobile,
    'industry_cd': profile.industryCode,
    'profession_cd': profile.professionCode,
    'birthday': profile.birthday?.toIso8601String(),
  });
}
