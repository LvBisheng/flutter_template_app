import '../domain/customer_list_repository.dart';
import '../domain/customer_summary.dart';
import 'customer_list_api.dart';
import 'customer_summary_dto.dart';

class CustomerListRepositoryImpl implements CustomerListRepository {
  const CustomerListRepositoryImpl(this._api);
  final CustomerListApi _api;

  @override
  Future<List<CustomerSummary>> fetchCustomers() async {
    final list = await _api.fetchCustomers();
    return list
        .cast<Map<String, dynamic>>()
        .map(CustomerSummaryDto.fromJson)
        .map((dto) => dto.toEntity())
        .toList();
  }
}
