import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';

import '../../../core/logging/app_logger.dart';
import '../../../core/network/api_client.dart';
import '../../customer_detail/domain/customer_profile.dart';
import '../data/customer_update_api.dart';
import '../data/customer_update_repository_impl.dart';
import '../domain/customer_update_policy.dart';
import '../domain/customer_update_use_case.dart';
import 'customer_update_state.dart';

final customerUpdateControllerProvider =
    StateNotifierProvider.family<
      CustomerUpdateController,
      CustomerUpdateState,
      String
    >((ref, id) => CustomerUpdateController(ref, id)..load());

class CustomerUpdateController extends StateNotifier<CustomerUpdateState> {
  CustomerUpdateController(this._ref, this._customerId)
    : super(const CustomerUpdateState());

  final Ref _ref;
  final String _customerId;
  late final _repository = CustomerUpdateRepositoryImpl(
    CustomerUpdateApi(_ref.read(apiClientProvider)),
  );

  Future<void> load() async {
    state = state.copyWith(loading: true, errorMessage: null);
    try {
      final profile = await _repository.fetchProfile(_customerId);
      appLogger.i('Customer update profile loaded: $_customerId');
      state = state.copyWith(
        loading: false,
        profile: profile,
        name: profile.name,
        email: profile.email,
        mobile: profile.mobile,
        industryCode: profile.industryCode,
        professionCode: profile.professionCode,
        birthday: profile.birthday,
      );
    } catch (e) {
      appLogger.e('Customer update profile load failed', error: e);
      state = state.copyWith(loading: false, errorMessage: e.toString());
    }
  }

  void nameChanged(String v) => _updateAndValidate(state.copyWith(name: v));
  void emailChanged(String v) => _updateAndValidate(state.copyWith(email: v));
  void mobileChanged(String v) => _updateAndValidate(state.copyWith(mobile: v));

  void industryChanged(String code) {
    // 行业变化后必须清空职业，因为旧职业可能不属于新行业。
    // 这类字段联动规则统一通过 Controller 修改状态，页面只负责把用户选择传进来。
    _updateAndValidate(
      state.copyWith(industryCode: code, clearProfession: true),
    );
  }

  void professionChanged(String code) =>
      _updateAndValidate(state.copyWith(professionCode: code));
  void acceptedChanged(bool v) =>
      _updateAndValidate(state.copyWith(acceptedTerms: v));
  void contactMethodChanged(String v) =>
      state = state.copyWith(contactMethod: v);
  void birthdayChanged(DateTime v) => state = state.copyWith(birthday: v);

  void _updateAndValidate(CustomerUpdateState next) {
    state = next.submittedOnce
        ? next.copyWith(fieldErrors: CustomerUpdatePolicy.validateFields(next))
        : next;
  }

  Future<String?> submit() async {
    final fieldErrors = CustomerUpdatePolicy.validateFields(state);
    state = state.copyWith(fieldErrors: fieldErrors, submittedOnce: true);
    if (fieldErrors.isNotEmpty) {
      return fieldErrors.values.first;
    }
    final base = state.profile!;
    final industry = CustomerUpdatePolicy.industries.firstWhere(
      (e) => e.value == state.industryCode,
    );
    final profession = CustomerUpdatePolicy.professions(
      state.industryCode,
    ).firstWhere((e) => e.value == state.professionCode);
    final updated = CustomerProfile(
      id: base.id,
      name: state.name,
      email: state.email,
      mobile: state.mobile,
      status: base.status,
      industryCode: industry.value,
      industryName: industry.label,
      professionCode: profession.value,
      professionName: profession.label,
      birthday: state.birthday,
      lastUpdatedAt: base.lastUpdatedAt,
    );
    state = state.copyWith(submitting: true);
    try {
      appLogger.i('Customer update submit started: ${base.id}');
      await CustomerUpdateUseCase(_repository).submit(updated);
      appLogger.i('Customer update submit succeeded: ${base.id}');
      return null;
    } catch (e) {
      appLogger.e('Customer update submit failed', error: e);
      return e.toString();
    } finally {
      state = state.copyWith(submitting: false);
    }
  }
}
