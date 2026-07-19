import '../../../../capabilities/face_verify/face_verify_service.dart';
import '../../../../capabilities/ocr/ocr_result.dart';
import '../../../../capabilities/soft_token/soft_token_service.dart';
import 'identity_update_repository.dart';

/// ─────────────────────────────────────────────────────────────────────
/// 身份证件更新 UseCase。
/// ─────────────────────────────────────────────────────────────────────
///
/// 【职责】
/// 编排跨 capabilities 的业务流程：OCR → 活体 → Soft Token 签名 → 提交。
///
/// 【为什么需要 UseCase？】
/// 当业务流程涉及多个步骤、多个能力时，UseCase 统一编排：
/// 1. 页面不关心流程细节，只关心成功/失败
/// 2. 流程变更只需修改 UseCase，不影响页面
/// 3. 可复用的流程逻辑抽取到 UseCase
///
/// 【跨 capabilities 编排】
/// OCR、活体、Soft Token 都是 capabilities 中的抽象服务，页面不直接调用 SDK。
/// 真实项目替换 SDK 实现时，只要保持 service 接口稳定，页面和流程改动会很小。
///
/// 【流程】
/// 1. 调用 FaceVerifyService 完成活体检测
/// 2. 构建请求 payload（包含 OCR 结果、活体 txn_id）
/// 3. 调用 SoftTokenService 对 payload 签名
/// 4. 调用 Repository 提交签名后的数据
///
class IdentityUpdateUseCase {
  const IdentityUpdateUseCase(
    this._repository,
    this._faceVerifyService,
    this._softTokenService,
  );

  final IdentityUpdateRepository _repository;
  final FaceVerifyService _faceVerifyService;
  final SoftTokenService _softTokenService;

  /// 提交身份更新。
  ///
  /// [customerId] 客户 ID
  /// [identity] OCR 识别结果（姓名、证件号、生日、有效期）
  /// [faceVerifyFailedMessage] 活体检测失败的提示文案（国际化）
  ///
  /// 【异常】
  /// - 活体检测未通过：抛出带 faceVerifyFailedMessage 的异常
  /// - 网络错误：由 Repository 层抛出
  ///
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
