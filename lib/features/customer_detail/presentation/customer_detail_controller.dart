import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/network/api_client.dart';
import '../data/customer_detail_api.dart';
import '../data/customer_detail_repository_impl.dart';
import '../domain/customer_profile.dart';

final customerDetailControllerProvider =
    FutureProvider.family<CustomerProfile, String>((ref, id) {
      return CustomerDetailRepositoryImpl(
        CustomerDetailApi(ref.read(apiClientProvider)),
      ).fetchDetail(id);
    });
