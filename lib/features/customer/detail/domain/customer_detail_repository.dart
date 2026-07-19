import 'customer_profile.dart';

abstract class CustomerDetailRepository {
  Future<CustomerProfile> fetchDetail(String customerId);
}
