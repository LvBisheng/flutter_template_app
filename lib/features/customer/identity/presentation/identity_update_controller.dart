import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';

import '../../../../capabilities/face_verify/face_verify_service.dart';
import '../../../../capabilities/ocr/ocr_result.dart';
import '../../../../capabilities/ocr/ocr_service.dart';
import '../../../../capabilities/soft_token/soft_token_service.dart';
import '../../../../core/logging/app_logger.dart';
import '../../../../core/logging/business_trace_logger.dart';
import '../../../../core/network/api_client.dart';
import '../data/identity_update_api.dart';
import '../data/identity_update_repository_impl.dart';
import '../domain/identity_update_use_case.dart';
import 'identity_update_state.dart';

/// ─────────────────────────────────────────────────────────────────────
/// 身份证件更新 Controller。
/// ─────────────────────────────────────────────────────────────────────
///
/// 【职责】
/// 1. 管理 UI 状态（流程步骤、Loading、OCR 结果）
/// 2. 调用 OCR 能力识别证件
/// 3. 调用 UseCase 提交完整的身份更新流程
/// 4. 记录业务链路日志（用于问题排查）
///
/// 【Provider 设计】
/// 使用 family 支持多实例（不同客户 ID）：
/// - 每个客户 ID 有独立的 Controller 实例
/// - autoDispose：页面销毁时自动释放
///
/// 【日志规范】
/// 使用 BusinessTraceLogger 记录完整链路：
/// - ocr_scan_start / ocr_scan_success / ocr_scan_failed
/// - identity_submit_start / identity_submit_success / identity_submit_failed
///
final identityUpdateControllerProvider =
    StateNotifierProvider.family.autoDispose<
      IdentityUpdateController,
      IdentityUpdateState,
      String
    >((ref, id) => IdentityUpdateController(ref, id));

class IdentityUpdateController extends StateNotifier<IdentityUpdateState> {
  IdentityUpdateController(this._ref, this._customerId)
    : super(const IdentityUpdateState()) {
    // 启动业务链路追踪
    _traceId = _trace.startFlow(
      'identity_update',
      businessId: _customerId,
      attributes: {'page': 'IdentityUpdatePage'},
    );
  }

  final Ref _ref;
  final String _customerId;
  late final String _traceId;
  late final _trace = _ref.read(businessTraceLoggerProvider);

  /// 调用 OCR 扫描身份证件。
  ///
  /// 【流程】
  /// 1. 更新状态为 scanning
  /// 2. 调用 OcrService 扫描
  /// 3. 成功：更新 OCR 结果，步骤变为 ocrCompleted
  /// 4. 失败：记录日志并重新抛出异常
  ///
  Future<void> scan() async {
    state = state.copyWith(scanning: true, step: IdentityUpdateStep.scanning);
    try {
      appLogger.i('Identity OCR started: $_customerId');
      _trace.info(
        _traceId,
        'ocr_scan_start',
        attributes: {'customer_id': _customerId},
      );
      final result = await _ref.read(ocrServiceProvider).scanIdentityCard();
      state = state.copyWith(
        identity: result,
        step: IdentityUpdateStep.ocrCompleted,
      );
      appLogger.i('Identity OCR succeeded: $_customerId');
      _trace.info(
        _traceId,
        'ocr_scan_success',
        attributes: {
          'customer_id': _customerId,
          'has_name': result.idName.isNotEmpty,
          'has_id_number': result.idNumber.isNotEmpty,
        },
      );
    } catch (e, st) {
      _trace.error(
        _traceId,
        'ocr_scan_failed',
        error: e,
        stackTrace: st,
        attributes: {'customer_id': _customerId},
      );
      _trace.uploadSilently(_traceId, error: e, stackTrace: st);
      rethrow;
    } finally {
      state = state.copyWith(scanning: false);
    }
  }

  /// 更新姓名（用户可在 OCR 结果基础上编辑）。
  void updateName(String value) {
    final old = state.identity;
    if (old != null) {
      state = state.copyWith(
        identity: OcrResult(
          idName: value,
          idNumber: old.idNumber,
          birthday: old.birthday,
          expiryDate: old.expiryDate,
        ),
      );
    }
  }

  /// 更新证件号（用户可在 OCR 结果基础上编辑）。
  void updateIdNumber(String value) {
    final old = state.identity;
    if (old != null) {
      state = state.copyWith(
        identity: OcrResult(
          idName: old.idName,
          idNumber: value,
          birthday: old.birthday,
          expiryDate: old.expiryDate,
        ),
      );
    }
  }

  /// 提交身份更新（完整流程：活体 + 签名 + 提交）。
  ///
  /// 【前置条件】
  /// 必须先完成 OCR 扫描（identity 不为空）。
  ///
  /// 【流程】
  /// 1. 校验 identity 是否存在
  /// 2. 调用 UseCase 执行完整流程（活体 → 签名 → 提交）
  /// 3. 成功：跳转结果页
  /// 4. 失败：记录日志并重新抛出异常
  ///
  /// 【参数说明】
  /// - [scanRequiredMessage]：未扫描时的提示文案（国际化）
  /// - [faceVerifyFailedMessage]：活体失败的提示文案（国际化）
  ///
  Future<void> submit({
    required String scanRequiredMessage,
    required String faceVerifyFailedMessage,
  }) async {
    final identity = state.identity;
    if (identity == null) {
      throw Exception(scanRequiredMessage);
    }
    state = state.copyWith(submitting: true, step: IdentityUpdateStep.signing);
    try {
      appLogger.i('Identity update submit started: $_customerId');
      _trace.info(
        _traceId,
        'identity_submit_start',
        attributes: {'customer_id': _customerId},
      );
      final useCase = IdentityUpdateUseCase(
        IdentityUpdateRepositoryImpl(
          IdentityUpdateApi(_ref.read(apiClientProvider)),
        ),
        _ref.read(faceVerifyServiceProvider),
        _ref.read(softTokenServiceProvider),
      );
      await useCase.submit(
        customerId: _customerId,
        identity: identity,
        faceVerifyFailedMessage: faceVerifyFailedMessage,
      );
      state = state.copyWith(step: IdentityUpdateStep.completed);
      appLogger.i('Identity update submit succeeded: $_customerId');
      _trace.info(
        _traceId,
        'identity_submit_success',
        attributes: {'customer_id': _customerId},
      );
      _trace.close(_traceId);
    } catch (e, st) {
      appLogger.e('Identity update submit failed', error: e, stackTrace: st);
      _trace.error(
        _traceId,
        'identity_submit_failed',
        error: e,
        stackTrace: st,
        attributes: {'customer_id': _customerId},
      );
      _trace.uploadSilently(_traceId, error: e, stackTrace: st);
      rethrow;
    } finally {
      state = state.copyWith(submitting: false);
    }
  }
}
