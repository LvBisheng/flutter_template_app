import 'soft_token_result.dart';
import 'soft_token_service.dart';

class MockSoftTokenService implements SoftTokenService {
  @override
  Future<SoftTokenResult> sign(Map<String, dynamic> payload) async {
    await Future<void>.delayed(const Duration(milliseconds: 400));
    return const SoftTokenResult(
      signature: 'MOCK-SIGNATURE-NOT-FOR-PRODUCTION',
    );
  }
}
