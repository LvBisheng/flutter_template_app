import 'customer_summary.dart';

abstract class CustomerListRepository {
  Future<List<CustomerSummary>> fetchCustomers();
}
