import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'mock_soft_token_service.dart';
import 'soft_token_result.dart';

final softTokenServiceProvider = Provider<SoftTokenService>(
  (_) => MockSoftTokenService(),
);

abstract class SoftTokenService {
  Future<SoftTokenResult> sign(Map<String, dynamic> payload);
}
