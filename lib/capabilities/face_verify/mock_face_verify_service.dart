import 'face_verify_result.dart';
import 'face_verify_service.dart';

class MockFaceVerifyService implements FaceVerifyService {
  @override
  Future<FaceVerifyResult> verify() async {
    await Future<void>.delayed(const Duration(milliseconds: 650));
    return const FaceVerifyResult(passed: true, transactionId: 'FACE-MOCK-TXN');
  }
}
