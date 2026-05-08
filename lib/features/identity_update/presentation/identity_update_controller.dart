import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';

import '../../../capabilities/face_verify/face_verify_service.dart';
import '../../../capabilities/ocr/ocr_result.dart';
import '../../../capabilities/ocr/ocr_service.dart';
import '../../../capabilities/soft_token/soft_token_service.dart';
import '../../../core/logging/app_logger.dart';
import '../../../core/logging/business_trace_logger.dart';
import '../../../core/network/api_client.dart';
import '../data/identity_update_api.dart';
import '../data/identity_update_repository_impl.dart';
import '../domain/identity_update_use_case.dart';
import 'identity_update_state.dart';

final identityUpdateControllerProvider =
    StateNotifierProvider.family<
      IdentityUpdateController,
      IdentityUpdateState,
      String
    >((ref, id) => IdentityUpdateController(ref, id));

class IdentityUpdateController extends StateNotifier<IdentityUpdateState> {
  IdentityUpdateController(this._ref, this._customerId)
    : super(const IdentityUpdateState()) {
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
