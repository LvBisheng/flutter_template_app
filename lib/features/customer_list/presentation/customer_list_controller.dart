import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/network/api_client.dart';
import '../data/customer_list_api.dart';
import '../data/customer_list_repository_impl.dart';
import '../domain/customer_summary.dart';

final customerListControllerProvider =
    AsyncNotifierProvider<CustomerListController, List<CustomerSummary>>(
      CustomerListController.new,
    );

class CustomerListController extends AsyncNotifier<List<CustomerSummary>> {
  @override
  Future<List<CustomerSummary>> build() => _load();

  Future<List<CustomerSummary>> _load() => CustomerListRepositoryImpl(
    CustomerListApi(ref.read(apiClientProvider)),
  ).fetchCustomers();
  Future<void> refresh() async => state = await AsyncValue.guard(_load);
}
