import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'face_verify_result.dart';
import 'mock_face_verify_service.dart';

final faceVerifyServiceProvider = Provider<FaceVerifyService>(
  (_) => MockFaceVerifyService(),
);

abstract class FaceVerifyService {
  Future<FaceVerifyResult> verify();
}
