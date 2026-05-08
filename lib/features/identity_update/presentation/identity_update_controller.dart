import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';

import '../../../capabilities/face_verify/face_verify_service.dart';
import '../../../capabilities/ocr/ocr_result.dart';
import '../../../capabilities/ocr/ocr_service.dart';
import '../../../capabilities/soft_token/soft_token_service.dart';
import '../../../core/logging/app_logger.dart';
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
    : super(const IdentityUpdateState());

  final Ref _ref;
  final String _customerId;

  Future<void> scan() async {
    state = state.copyWith(scanning: true, stepText: 'OCR 识别中');
    try {
      appLogger.i('Identity OCR started: $_customerId');
      final result = await _ref.read(ocrServiceProvider).scanIdentityCard();
      state = state.copyWith(identity: result, stepText: 'OCR 完成');
      appLogger.i('Identity OCR succeeded: $_customerId');
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

  Future<void> submit() async {
    final identity = state.identity;
    if (identity == null) {
      throw Exception('请先完成 OCR');
    }
    state = state.copyWith(submitting: true, stepText: '活体验证与签名中');
    try {
      appLogger.i('Identity update submit started: $_customerId');
      final useCase = IdentityUpdateUseCase(
        IdentityUpdateRepositoryImpl(
          IdentityUpdateApi(_ref.read(apiClientProvider)),
        ),
        _ref.read(faceVerifyServiceProvider),
        _ref.read(softTokenServiceProvider),
      );
      await useCase.submit(customerId: _customerId, identity: identity);
      state = state.copyWith(stepText: '证件更新完成');
      appLogger.i('Identity update submit succeeded: $_customerId');
    } catch (e, st) {
      appLogger.e('Identity update submit failed', error: e, stackTrace: st);
      rethrow;
    } finally {
      state = state.copyWith(submitting: false);
    }
  }
}
