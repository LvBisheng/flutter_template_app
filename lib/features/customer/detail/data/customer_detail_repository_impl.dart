import '../domain/customer_detail_repository.dart';
import '../domain/customer_profile.dart';
import 'customer_detail_api.dart';
import 'customer_profile_dto.dart';

class CustomerDetailRepositoryImpl implements CustomerDetailRepository {
  const CustomerDetailRepositoryImpl(this._api);
  final CustomerDetailApi _api;

  @override
  Future<CustomerProfile> fetchDetail(String customerId) async =>
      CustomerProfileDto(await _api.fetchDetail(customerId)).toEntity();
}
