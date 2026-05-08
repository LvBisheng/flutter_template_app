import '../../../capabilities/face_verify/face_verify_service.dart';
import '../../../capabilities/ocr/ocr_result.dart';
import '../../../capabilities/soft_token/soft_token_service.dart';
import 'identity_update_repository.dart';

/// 证件更新 UseCase 展示跨业务能力编排。
///
/// OCR、活体、Soft Token 都是 capabilities 中的抽象服务，页面不直接调用 SDK。
/// 真实项目替换 SDK 实现时，只要保持 service 接口稳定，页面和流程改动会很小。
class IdentityUpdateUseCase {
  const IdentityUpdateUseCase(
    this._repository,
    this._faceVerifyService,
    this._softTokenService,
  );

  final IdentityUpdateRepository _repository;
  final FaceVerifyService _faceVerifyService;
  final SoftTokenService _softTokenService;

  Future<void> submit({
    required String customerId,
    required OcrResult identity,
    required String faceVerifyFailedMessage,
  }) async {
    final face = await _faceVerifyService.verify();
    if (!face.passed) throw Exception(faceVerifyFailedMessage);
    final payload = {
      'customer_id': customerId,
      'id_name': identity.idName,
      'id_number': identity.idNumber,
      'birthday': identity.birthday.toIso8601String(),
      'expiry_date': identity.expiryDate.toIso8601String(),
      'face_txn_id': face.transactionId,
    };
    final sign = await _softTokenService.sign(payload);
    await _repository.updateIdentity({...payload, 'signature': sign.signature});
  }
}
