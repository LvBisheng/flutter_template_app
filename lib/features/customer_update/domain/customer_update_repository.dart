import '../../customer_detail/domain/customer_profile.dart';

abstract class CustomerUpdateRepository {
  Future<CustomerProfile> fetchProfile(String customerId);
  Future<void> updateProfile(CustomerProfile profile);
}
